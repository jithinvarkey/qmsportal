import sys, re

path = sys.argv[1] if len(sys.argv) > 1 else \
    "src/app/features/settings/settings.component.ts"

with open(path, encoding='utf-8') as f:
    code = f.read()

original = code
changes = []

def rep(old, new, label):
    global code
    if old in code:
        code = code.replace(old, new)
        changes.append(f"  ✅ {label}")
    else:
        changes.append(f"  ⚠️  NOT FOUND: {label}")

# ── 1. loadDepts ─────────────────────────────────────────────────────────────
rep(
    "next: r => { this.departments.set(r||[]); this.loadingDepts.set(false); },",
    "next: r => { this.departments.set(Array.isArray(r)?r:(r?.data??[])); this.loadingDepts.set(false); },",
    "loadDepts"
)

# ── 2. loadRoles ─────────────────────────────────────────────────────────────
# Handle both patterns that may exist
rep(
    "next: r => { this.roles.set(Array.isArray(r) ? r : (r?.data || [])); this.loadingRoles.set(false); },",
    "next: r => { this.roles.set(Array.isArray(r)?r:(r?.data??[])); this.loadingRoles.set(false); },",
    "loadRoles (pattern A)"
)
rep(
    "next: r => { this.roles.set(r||[]); this.loadingRoles.set(false); },",
    "next: r => { this.roles.set(Array.isArray(r)?r:(r?.data??[])); this.loadingRoles.set(false); },",
    "loadRoles (pattern B)"
)

# ── 3. loadAllCats ────────────────────────────────────────────────────────────
rep(
    "this.cats.update(m => ({...m, [type]: r || []}))",
    "this.cats.update(m => ({...m, [type]: Array.isArray(r)?r:(r?.data??[])}))",
    "loadAllCats"
)

# ── 4. loadTemplates ─────────────────────────────────────────────────────────
rep(
    "next: r => { this.templates.set(r||[]); this.loadingTpls.set(false); },",
    "next: r => { this.templates.set(Array.isArray(r)?r:(r?.data??[])); this.loadingTpls.set(false); },",
    "loadTemplates"
)

# ── 5. loadSettings — the tricky one ─────────────────────────────────────────
# API returns: { success:true, data:{ flat:[...], grouped:{...} } }
# So r.data.flat is the array, NOT r.flat

# Pattern A: flat.forEach (already partially patched)
rep(
    "const flat=r?.flat??r??[]; this.systemSettings.set(Array.isArray(flat)?flat:[]); flat.forEach",
    "const flat=r?.data?.flat??(Array.isArray(r)?r:[]); this.systemSettings.set(flat); flat.forEach",
    "loadSettings flat.forEach (patched form)"
)

# Pattern B: original form
rep(
    "next: r => { this.systemSettings.set(r||[]); r.forEach((s:any) =>",
    "next: r => { const flat=r?.data?.flat??(Array.isArray(r)?r:[]); this.systemSettings.set(flat); flat.forEach((s:any) =>",
    "loadSettings original form"
)

# ── 6. loadUsers pagination ───────────────────────────────────────────────────
rep(
    "next: r => { this.users.set(r.data||[]); this.userTotal.set(r.total||0); this.userPages.set(r.last_page||1); this.loadingUsers.set(false); },",
    "next: r => { this.users.set(r?.data??[]); this.userTotal.set(r?.total??0); this.userPages.set(r?.last_page??1); this.loadingUsers.set(false); },",
    "loadUsers pagination"
)

# ── 7. activityLog ────────────────────────────────────────────────────────────
rep(
    "this.activityLog.set(r.data || (Array.isArray(r) ? r : []));",
    "this.activityLog.set(Array.isArray(r)?r:(r?.data??[]));",
    "activityLog"
)
rep(
    "this.activityLog.set(Array.isArray(r) ? r : (r?.data ?? []));",
    "this.activityLog.set(Array.isArray(r)?r:(r?.data??[]));",
    "activityLog (already fixed form)"
)

# ── Print results ─────────────────────────────────────────────────────────────
for c in changes:
    print(c)

if code != original:
    with open(path, 'w', encoding='utf-8') as f:
        f.write(code)
    print(f"\nSaved to {path}")
else:
    print("\nNo changes — all patterns already correct or not found.")
