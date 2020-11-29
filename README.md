# RWTodd.DiscordianDate Powershell Module

This is a powershell version of the UNIX `ddate` utility.  It does all the same formatting, but
can also return a powershell object with properties for the day and season, etc. 

It is loadable as a module, and has a suitable XML help file.

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
