---
external help file: RWTodd.DiscordianDate-help.xml
Module Name: RWTodd.DiscordianDate
online version:
schema: 2.0.0
---

# Get-DDate

## SYNOPSIS
Converts dates to the Discordian calendar.

## SYNTAX

```
Get-DDate [[-Date] <DateTime>] [-Format <String>] [<CommonParameters>]
```

## DESCRIPTION
The command supports all options present in the UNIX `ddate` utility.  With no arguments, it formats the current date in a default, friendly format.  Custom format strings can be provided with the `-Format` parameter. Though the default display is the formatted string, this utility actually returns a Powershell object with properties for various aspects of the Discordian date. I'd like to see the venerable `ddate` utility do that!

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-DDate 2020-2-19

Setting Orange, Chaos 50, 3186 YOLD
```

The given date is converted to a discordian date and described.

### Example 2
```powershell
PS C:\> Get-DDate 2020-2-19 | Format-List

Year          : 3186
Season        : Chaos
SeasonAbbrev  : Chs
DayOfSeason   : 50
Weekday       : Setting Orange
WeekdayAbbrev : SO
IsTibs        : False
IsHolyDay     : True
HolyDay       : Chaoflux
DaysTilXDay   : 2425712
Formatted     : Setting Orange, Chaos 50, 3186 YOLD
```

The given date is converted to a discordian date and returned as an object.

### Example 3
```powershell
PS C:\> Get-DDate 2020-2-19 -Format "Why it's %A, the %e of %B!"

Why it's Setting Orange, the 50th of Chaos!
```

A custom format string is used.

## PARAMETERS

### -Date
The Gregorian-calendar date to convert to Discordian.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Format
The format string. When a format is not given, a default one is provided by the tool.  The flags allowed in the format string are the following:

%% Outputs a literal percent sign.

%n Outputs a newline.

%t Outputs a tab.

%A Outputs the Discordian weekday.

%a Outputs an abbreviation for the Discordian weekday.

%B Outputs the Discordian Season.

%b Outputs an abbreviation for the Discordian Season.

%d Outputs the day of the season.

%e Outputs the ordinal-number version of the day (e.g., `3rd` `24th`)

%H Outputs the name of the current Holy Day, if any.

%X Outputs the number of days left until X-Day

%Y Outputs the Discordian year.

%. Outputs a random exclamation.

%N Removes the rest of the format string, unless it is a Holy Day.

%{ ... %}  Outputs "St. Tib's Day" on St. Tib's Day, and removes everything between the brackets. Otherwise, formats everything between the brackets.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### RWTodd.DiscordianDate.Date
An object is returned with properties for aspects of the Discordian date.

## NOTES

## RELATED LINKS

[Wikipedia Entry for Discordian Calendar](https://en.wikipedia.org/wiki/Discordian_calendar)