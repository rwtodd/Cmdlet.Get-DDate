#function get-ddate {
[CmdletBinding()]
param (
    [Parameter(Position = 0)]
    [DateTime] $date = [DateTime]::Now,

    [Parameter()]
    $format = "",

    [Switch] $asObject
)

Write-Verbose "Date is $date"

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

# determine the best format to use...
if ($format.Length -eq 0) {
    $today = [DateTime]::Now
    if (($date.DayOfYear -eq $today.DayOfYear) -and ($date.Year -eq $today.Year)) {
        $format = "Today is %{%A, the %e day of %B%} in the YOLD %Y%N%nCelebrate %H"
    }
    else {
        $format = "%{%A, %B %d%}, %Y YOLD"
    }
}
Write-Verbose "Format is: <$format>"

# Calculate a result object
$adjustedYDay = $date.DayOfYear - 1
if ([DateTime]::IsLeapYear($date.Year) -and ($date.Month -gt 2)) {
    $adjustedYDay -= 1
}
Write-Verbose "$adjustedYDay is the adjusted Day of the Year"
$seasonNbr = [Math]::Floor($adjustedYDay / 73)
$seasonDay = ($adjustedYDay % 73) + 1
$tibs_p = ($date.Month -eq 2) -and ($date.Day -eq 29)
$holyDay = ""
if ($seasonDay -eq 5) {
    $holyDay = $HOLIDAY_5[$seasonNbr]
}
elseif ($seasonDay -eq 50) {
    $holyDay = $HOLYDAY_50[$seasonNbr]
}

# Ok, build the result
$result = [PSCustomObject]@{
    Year          = $date.Year + 1166
    Season        = $tibs_p ? $TIBS : $SEASONS[2 * [Math]::Floor($adjustedYDay / 73)]
    SeasonAbbrev  = $tibs_p ? $TIBS : $SEASONS[2 * [Math]::Floor($adjustedYDay / 73) + 1]
    DayOfSeason   = $seasonDay
    Weekday       = $tibs_p ? $TIBS : $DAYS[2 * ($adjustedYDay % 5)]
    WeekdayAbbrev = $tibs_p ? $TIBS : $DAYS[2 * ($adjustedYDay % 5) + 1]
    IsTibs        = $tibs_p
    IsHolyDay     = $holyDay.Length -gt 0
    HolyDay       = $holyDay
    DaysTilXDay   = [Math]::Ceiling([datetime]::new(8661, 7, 5).Subtract($date).TotalDays)
}

if (-not $asObject) {
    # format a response as a string
    if (($result.DayOfSeason -lt 10) -or ($result.DayOfSeason -gt 20)) {
        $ordinal = switch ($result.DayOfSeason % 10) {
            1 { "st" }
            2 { "nd" }
            3 { "rd" }
            default { "th" }
        }
    } else {
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
            "e" { "$seasonDay$ordinal" }
            "H" { $result.HolyDay }
            "n" { "`n" }
            "t" { "`t" }
            "X" { $result.DaysTilXDay }
            "Y" { $result.Year }
            "." { $EXCLAIM[(Get-Random -Maximum $EXCLAIM.Length)] }
            default { "" }      
        }
    }
    
    # first take care of holy days
    if (-not $result.IsHolyDay) {
        $format = $format -replace '%N.*$', ''
    }
    if ($tibs_p) {
        $format = $format -replace '%{.*%}', $TIBS
    }
    $result = ([regex]'%(.)').Replace($format, $callback)
}

return $result
#}
