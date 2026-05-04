<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use PhpOffice\PhpSpreadsheet\IOFactory;
use PhpOffice\PhpSpreadsheet\Reader\Csv;
use App\Models\Client;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;

class ClientImportController extends Controller {

    public function import(Request $request) {
        $request->validate([
            'file' => 'required|file|mimes:xlsx,csv'
        ]);

        $file = $request->file('file');

        $spreadsheet = IOFactory::load($file->getPathname());
        $rows = $spreadsheet->getActiveSheet()->toArray();

        $inserted = 0;
        $skipped = 0;

        $validTypes = ['client', 'insurer', 'regulator', 'partner'];
        $validStatus = ['active', 'inactive', 'prospect'];

        foreach (array_slice($rows, 1) as $row) {

            if (!array_filter($row))
                continue;

            $type = strtolower(trim($row[2] ?? ''));
            $status = 'active';

            // Validate enums
            if (!in_array($type, $validTypes) || !in_array($status, $validStatus)) {
                $skipped++;
                continue;
            }

            // Prevent duplicate (by code)
            if (Client::where('name', '=', $row[0])->exists()) {
                $skipped++;
                continue;
            }


            if ($type == 'insurer') {


                Client::create([
                    'name' => $row[0],
                    'type' => $type,
                    'status' => $status,
                ]);

                $inserted++;
            } else {

                $accountManagerId = $row[9] ?? null;
                if ($accountManagerId === 'NULL' || $accountManagerId === '') {
                    $accountManagerId = null;
                }

                Client::create([
                    'name' => $row[0],
                    'code' => $row[1],
                    'type' => $type,
                    'industry' => $row[3],
                    'contact_name' => $row[4],
                    'contact_email' => $row[5],
                    'contact_phone' => $row[6],
                    'address' => $row[7],
                    'country' => $row[8],
                    'account_manager_id' => $accountManagerId,
                    'status' => $status,
                ]);

                $inserted++;
            }
        }

        return response()->json([
                    'message' => 'Import completed',
                    'inserted' => $inserted,
                    'skipped' => $skipped
        ]);
    }

    public function importDocuments(Request $request) {
        try {
            $request->validate([
                'file' => 'required|file|mimes:xlsx,csv'
            ]);

            $file = $request->file('file');
            $filePath = $file->getPathname();
            $reader = IOFactory::createReaderForFile($filePath);
            if ($reader instanceof Csv) {
                $reader->setInputEncoding('UTF-8');
            }
            $spreadsheet = IOFactory::load($filePath);
            $rows = $spreadsheet->getActiveSheet()->toArray();

            // Normalize headers
            $headers = array_map(fn($h) => strtolower(trim($h)), $rows[0]);

            DB::beginTransaction();

            foreach (array_slice($rows, 1) as $row) {

                $data = array_combine($headers, $row);

                // Skip empty rows
                if (empty($data['document_name'])) {
                    continue;
                }

                // ✅ Extract filename from JSON
                $fileName = $this->extractFileName($data['file_name'] ?? null);

                // ✅ Generate document number
                $documentNo = $this->generateDocumentNo();

                $status = ($data['isactive'] == 0) ? 'draft' : 'approved';

                // ✅ Insert into documents table
                $documentId = DB::table('documents')->insertGetId([
                    'document_no' => $documentNo,
                    // 🔥 Main mapping
                    'title' => $this->fixEncoding($data['document_name'] ?? null),
                    'description' => $this->fixEncoding($data['description'] ?? null),
                    'category_id' => $this->mapCategory($data['category_id'] ?? null),
                    'owner_id' => $this->mapUser($data['createdby'] ?? null),
                    'reviewer_id' => $this->mapUser($data['modifiedby'] ?? null),
                    'approver_id' => null,
                    'department_id' => null, // optional
                    'type' => $this->mapType($data['document_type'] ?? null),
                    'status' => $status,
                    'version' => $data['document_version'] ?? '1.0',
                    'effective_date' => null,
                    'review_date' => null,
                    'expiry_date' => null,
                    'file_path' => $fileName,
                    'file_size' => null,
                    'mime_type' => null,
                    'is_controlled' => 1,
                    'requires_signature' => 0,
                    'rejection_reason' => null,
                    'submitted_at' => null,
                    'approved_at' => null,
                    'metadata' => $data['file_name'] ?? null, // store original JSON
                    'created_at' => $this->formatDate($data['createddate'] ?? null),
                    'updated_at' => $this->formatDate($data['modifieddate'] ?? null),
                ]);

                //insert department distribution

                $departmentIds = $this->mapDepartmentids($data['category_id'] ?? null);

                $insertData = [];

                foreach ($departmentIds as $deptId) {
                    $insertData[] = [
                        'document_id' => $documentId,
                        'department_id' => $deptId,
                        'distributed_at' => now(),
                    ];
                }

                if (!empty($insertData)) {
                    DB::table('document_departments')->insert($insertData);
                }

                // ✅ Insert into document_versions
                DB::table('document_versions')->insert([
                    'document_id' => $documentId,
                    'version' => $data['document_version'] ?? '1.0',
                    'change_summary' => 'Initial import',
                    'changed_by_id' => $this->mapUser($data['modifiedby'] ?? null),
                    'file_path' => $fileName,
                    'approved_at' => null,
                    'created_at' => now(),
                ]);
            }

            DB::commit();

            return response()->json([
                        'message' => 'Import completed',
                        'inserted' => 1,
                        'skipped' => 0
            ]);
        } catch (\Exception $e) {
            DB::rollBack();
            \Log::info('Error:: ' . $e->getMessage() . "Line:" . $e->getLine());

            return response()->json([
                        'message' => $e->getMessage()
                            ], 400);
        }
    }

    private function generateDocumentNo() {


        do {
            $docNo = 'DOC-' . date('Ymd') . '-' . rand(1000, 9999);
        } while (DB::table('documents')->where('document_no', $docNo)->exists());

        return $docNo;
    }

    private function mapType($type) {
        $type = strtolower(trim($type));

        $map = [
            'policy' => 'policy',
            'procedure' => 'procedure',
            'circulars' => 'work_instruction',
            'announcement' => 'announcement',
            'form' => 'form',
        ];

        return $map[$type] ?? 'procedure';
    }

    public function importUsers(Request $request) {
        try {

            $request->validate([
                'file' => 'required|file|mimes:xlsx,csv'
            ]);

            $file = $request->file('file');
            $filePath = $file->getPathname();
            $spreadsheet = IOFactory::load($filePath);
            $rows = $spreadsheet->getActiveSheet()->toArray();

            // Normalize headers
            $headers = array_map(fn($h) => strtolower(trim($h)), $rows[0]);

            $inserted = 0;
            $skipped = 0;
            DB::beginTransaction();

            foreach (array_slice($rows, 1) as $row) {

                $data = array_combine($headers, $row);

                // 🔍 Debug once if needed
                // dd($data);

                $email = trim($data['emailaddress'] ?? '');

                if (!$email) {
                    $skipped++;
                    continue;
                }


                if (DB::table('users')->where('email', $email)->exists()) {
                    $skipped++;
                    continue;
                }

                $name = trim(($data['firstname'] ?? '') . ' ' . ($data['lastname'] ?? ''));

                DB::table('users')->insert([
                    'name' => $name ?: 'Unknown',
                    'email' => $email,
                    'password' => $this->hashPassword($data['emppassword'] ?? null),
                    'role_id' => $this->mapRole($data['emprole'] ?? null),
                    // ✅ Clean department mapping
                    'department_id' => $this->mapDepartmentDirect($data['department_id'] ?? null),
                    'employee_id' => $data['employeeid'] ?? null,
                    'phone' => $data['contactnumber'] ?? null,
                    'avatar' => $data['profileimg'] ?? null,
                    'is_active' => (($data['isactive'] ?? 0) == 1) ? 1 : 0,
                    'email_verified_at' => now(),
                    'created_at' => $this->formatDate($data['createddate'] ?? null),
                    'updated_at' => $this->formatDate($data['modifieddate'] ?? null),
                ]);
            }
            $inserted++;
            DB::commit();

            return response()->json([
                        'message' => 'Users imported successfully',
                        'inserted' => $inserted,
                        'skipped' => $skipped
            ]);
        } catch (\Exception $e) {
            DB::rollBack();
            return $e->getMessage();
        }
    }

    /**
     * 
     * @param type $password
     * @return type
     */
    private function hashPassword($password) {
        if (!$password) {
            return Hash::make('123456');
        }

        // Already hashed
        if (strlen($password) > 20 && str_starts_with($password, '$2y$')) {
            return $password;
        }

        return Hash::make($password);
    }

    /**
     * 
     * @param type $role
     * @return type
     */
    private function mapRole($role) {
        return match ((int) $role) {
            1 => 1, // Admin
            2 => 2, // User
            default => 2
        };
    }

    /**
     * 
     * @param type $date
     * @return type
     */
    private function formatDate($date) {
        try {
            return $date ? Carbon::parse($date) : now();
        } catch (\Exception $e) {
            return now();
        }
    }

    private function mapDepartmentDirect($oldDeptId) {
        $map = [
            1 => 5, // HR → Human Resources
            2 => 3, // IT → IT
            3 => 9, // Technical
            4 => 4, // Finance
            5 => 2, // Operations
            6 => 7, // Compliance
            7 => 6, // Marketing → Sales & Marketing
            8 => 10, // Cyber security → Customer Service
            9 => 6, // Sales → Sales & Marketing
            10 => 1, // QA → Quality Assurance
        ];

        return $map[$oldDeptId] ?? null;
    }

    private function extractFileName($json) {
        if (!$json)
            return null;

        try {
            $files = json_decode($json, true);

            if (!is_array($files))
                return null;

            return $files[0]['new_name'] ?? null;
        } catch (\Exception $e) {
            return null;
        }
    }

    private function mapCategory($oldCategoryId) {
        return match ((int) $oldCategoryId) {
            1 => 1, // Policies
            2 => 2, // Procedures
            3 => 3, // Work Instructions
            default => 2,
        };
    }

    private function mapUser($oldUserId) {
        if (!$oldUserId) {
            return null;
        }

        $maparray = [
            194 => 38,
            214 => 44,
            242 => 54,
            '' => 44
        ];

        return $maparray[$oldUserId] ?? null;
    }

    private function fixEncoding($value) {
        return $value ? mb_convert_encoding($value, 'UTF-8', 'auto') : null;
    }

    private function mapDepartmentids($categoryId) {
        if (!$categoryId) {
            return [];
        }

        $mapArray = [
            1 => [3],
            2 => [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
            3 => [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
            4 => [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
            5 => [1],
            6 => [6],
            7 => [9],
            8 => [4],
            9 => [2],
            10 => [7],
            11 => [3],
            12 => [6],
            13 => [2],
            14 => [2],
            15 => [5],
            16 => [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
        ];

        return $mapArray[$categoryId] ?? [];
    }
}
