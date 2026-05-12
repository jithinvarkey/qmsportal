
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Survey Invitation</title>
</head>
<body style="font-family: Arial, sans-serif; line-height: 1.6;">

    <h2>Hello {{ $name ?? 'Customer' }},</h2>

    <p>
        You have been invited to participate in the survey:
    </p>

    <h3>{{ $survey->title }}</h3>

    @if(!empty($survey->description))
        <p>{{ $survey->description }}</p>
    @endif

    <p>
        Please click the button below to complete the survey:
    </p>

    <p>
        <a href="{{ $surveyUrl }}"
           style="display:inline-block;
                  padding:12px 20px;
                  background:#2563eb;
                  color:white;
                  text-decoration:none;
                  border-radius:6px;">
            Open Survey
        </a>
    </p>

    <p>
        If the button does not work, copy this link:
    </p>

    <p>{{ $surveyUrl }}</p>

    @if($survey->end_date)
        <p>
            Survey closes on:
            <strong>{{ $survey->end_date->format('d M Y') }}</strong>
        </p>
    @endif

    <br>

    <p>Thank you!</p>

</body>
</html>
