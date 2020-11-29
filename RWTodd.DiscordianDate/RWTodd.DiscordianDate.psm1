$TIBS = "St. Tib's Day"
$SEASONS = "Chaos", "Chs", "Discord", "Dsc", "Confusion", "Cfn", `
    "Bureaucracy", "Bcy", "The Aftermath", "Afm"
$DAYS = "Sweetmorn", "SM", "Boomtime", "BT", `
    "Pungenday", "PD", "Prickle-Prickle", "PP", `
    "Setting Orange", "SO"
$HOLIDAY_5 = "Mungday", "Mojoday", "Syaday", "Zaraday", "Maladay"
$HOLYDAY_50 = "Chaoflux", "Discoflux", "Confuflux", "Bureflux", "Afflux"
$EXCLAIM = "Hail Eris!", "All Hail Discordia!", "Kallisti!", "Fnord.", "Or not.", `
    "Wibble.", "Pzat!", "P'tang!", "Frink!", "Slack!", "Praise `"Bob`"!", "Or kill me.", `
    "Grudnuk demand sustenance!", "Keep the Lasagna flying!", `
    "You are what you see.", "Or is it?", "This statement is false.", `
    "Lies and slander, sire!", "Hee hee hee!", "Hail Eris, Hack Powershell!"

function Get-DDate {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0)]
        [DateTime] $Date = [DateTime]::Now,

        [Parameter(ParameterSetName="FormatSet")]
        [string] $Format = "",

        [Parameter(Mandatory=$true,ParameterSetName="ObjectSet")]
        [Switch] $AsObject
    )

    Write-Verbose "Date is $Date"

    # Calculate a result object
    $adjustedYDay = $Date.DayOfYear - 1
    if ([DateTime]::IsLeapYear($Date.Year) -and ($Date.Month -gt 2)) {
        $adjustedYDay -= 1
    }
    Write-Verbose "$adjustedYDay is the adjusted Day of the Year"
    $seasonNbr = [Math]::Floor($adjustedYDay / 73)
    $seasonDay = ($adjustedYDay % 73) + 1
    $tibs_p = ($Date.Month -eq 2) -and ($Date.Day -eq 29)
    $holyDay = ""
    if ($seasonDay -eq 5) {
        $holyDay = $HOLIDAY_5[$seasonNbr]
    }
    elseif ($seasonDay -eq 50) {
        $holyDay = $HOLYDAY_50[$seasonNbr]
    }

    # Ok, build the result
    $result = [PSCustomObject]@{
        Year          = $Date.Year + 1166
        Season        = $tibs_p ? $TIBS : $SEASONS[2 * [Math]::Floor($adjustedYDay / 73)]
        SeasonAbbrev  = $tibs_p ? $TIBS : $SEASONS[2 * [Math]::Floor($adjustedYDay / 73) + 1]
        DayOfSeason   = $seasonDay
        Weekday       = $tibs_p ? $TIBS : $DAYS[2 * ($adjustedYDay % 5)]
        WeekdayAbbrev = $tibs_p ? $TIBS : $DAYS[2 * ($adjustedYDay % 5) + 1]
        IsTibs        = $tibs_p
        IsHolyDay     = $holyDay.Length -gt 0
        HolyDay       = $holyDay
        DaysTilXDay   = [Math]::Ceiling([datetime]::new(8661, 7, 5).Subtract($Date).TotalDays)
    }

    # if they asked for an object, return it now
    if ($AsObject) { return $result; }

    # ok, an object wasn't asked for, so return a formatted string
    if ($Format.Length -eq 0) {
        $today = [DateTime]::Now
        if (($Date.DayOfYear -eq $today.DayOfYear) -and ($Date.Year -eq $today.Year)) {
            $Format = "Today is %{%A, the %e day of %B%} in the YOLD %Y%N%nCelebrate %H"
        }
        else {
            $Format = "%{%A, %B %d%}, %Y YOLD"
        }
    }
    Write-Verbose "Format is: <$Format>"

    if (($result.DayOfSeason -lt 10) -or ($result.DayOfSeason -gt 20)) {
        $ordinal = switch ($result.DayOfSeason % 10) {
            1 { "st" }
            2 { "nd" }
            3 { "rd" }
            default { "th" }
        }
    }
    else {
        $ordinal = "th"
    }

    $callback = {
        param($match)
        switch -CaseSensitive ($match.Groups[1].Value) {
            "%" { "%" }
            "A" { $result.Weekday }
            "a" { $result.WeekdayAbbrev }
            "B" { $result.Season }
            "b" { $result.SeasonAbbrev }
            "d" { $result.DayOfSeason }
            "e" { "$($result.DayOfSeason)$ordinal" }
            "H" { $result.HolyDay }
            "n" { "`n" }
            "t" { "`t" }
            "X" { $result.DaysTilXDay }
            "Y" { $result.Year }
            "." { $EXCLAIM[(Get-Random -Maximum $EXCLAIM.Length)] }
            default { "" }      
        }
    }
    
    # first, take care of special-cases for holy days
    if (-not $result.IsHolyDay) {
        $Format = $Format -replace '%N.*$', ''
    }
    if ($tibs_p) {
        $Format = $Format -replace '%{.*%}', $TIBS
    }
    # then, replace all the other %-codes
    return ([regex]'%(.)').Replace($Format, $callback)
}
