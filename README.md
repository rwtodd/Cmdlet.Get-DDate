# RWTodd.DiscordianDate Powershell Module

This is a powershell version of the UNIX `ddate` utility.  It does all the same formatting, but
can also return a powershell object with properties for the day and season, etc. 

It is loadable as a module, and has a suitable XML help file.

I added it to the (PowerShell Gallery)[https://www.powershellgallery.com/packages/RWTodd.DiscordianDate/1.0], so you should be able to install it like so:

```powershell
PS> Install-Module -Name RWTodd.DiscordianDate -Repository PSGallery
```

## Examples

```powershell
PS C:\> Get-DDate 2020-2-19
Setting Orange, Chaos 50, 3186 YOLD
```

```powershell
PS C:\> Get-DDate 2020-2-19 -AsObject

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
```

```powershell
PS C:\> Get-DDate 2020-2-19 -Format "Why it's %A, the %e of %B!"
Why it's Setting Orange, the 50th of Chaos!
```

## Development Notes

### platyPS

I used platyPS to do the documentation...

```powershell
Update-MarkdownHelp .\Docs-en-US\Get-DDate.md   # if I change the script
New-ExternalHelp -Path .\Docs-en-US -OutputPath .\RWTodd.DiscordianDate\en-US\ -Force  # regen the XML
Get-HelpPreview .\RWTodd.DiscordianDate\en-US\RWTodd.DiscordianDate-help.xml  # view the generated help
```

### Publishing

I installed it in a local NuGet repository like so...

```powershell
mkdir j:\PS-NUGET
Register-PSRepository -Name 'MyRepo' -SourceLocation J:\PS-NUGET\ -InstallationPolicy Trusted
Publish-Module -Path .\RWTodd.DiscordianDate -Repository MyRepo
```

... then later I could install it like so...

```powershell
Get-PSRepository  # make sure my nuget repo is listed
Find-Module -Repository MyRepo  # see it is listed
Install-Module RWTodd.DiscordianDate -Repository MyRepo
```
