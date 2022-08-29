#Demo-RegularExpressions.ps1

return "This is a demo script file."

#region read the help

help about_regular_expressions
help about_Comparison_Operators

#endregion

#region use the -like operator

#use the * character

get-service | where name -like win*
get-service | where name -notlike xb*

cls

#endregion

#region use the -match operator

"PowerShell" -match "pow"
#view matches
$matches

"PowerShell" -match "pOw"
$matches

#match any single character
$names = "dan","dean","don","ladonna","DON","dane","dun","jeff","jdin" 
$names | where {$_ -match "d.n"}

#what about dane and ladonna?
$names | where {$_ -match "^d.n"}
$names | where {$_ -match "d.n$"}
$names | where {$_ -match "^d.n$"}

$names | where {$_ -match "^d[aeio]n$"}
#this will also work
$names -match "^d[aeio]n$"

cls

#using character classes
"PowerShell" -match "\w"
$matches

#zero or more
"PowerShell" -match "^\w*"
$matches

#one or more
"owerShell" -match "^\w+"
$matches

#multiple choice
"PowerShell" -match "[tpw]ower"
$matches
"TowerShell" -match "[tpw]ower"
$matches
"ZowerShell" -match "[tpw]ower"
$matches

#matching stops at first non-match
"Power Shell" -match "\w+"
$matches

#qualifiers
"#323#" -match "\d{2}"
$matches

"ABC#123#xyz" -match "\d{3}"
$matches

"ABC#123#" -match "\d{3}#$"
$matches

$ip = "192.168.4.100","10.1.120.240","300.400.500.600","a.b.c.d","10.10.1" 
#match with a literal period - this is a simple pattern
$pattern = "^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$"
$ip | where {$_ -match $pattern} 

#escaping the slash

"\\server01\public" -match "\\\w+\\w+"
"\\server01\public" -match "\\"
$matches
"\\server01\public" -match "\\\\"
$matches

"\\server01\public" -match "\\\\\w+\\\w+"
$matches

#be with careful \w
"\\server-01-test\public" -match "\\\\\w+\\\w+"

$unc = "\\server-01-test\public","\\server02\data",
"\\server 01\foo","\\server-01:test\public","\\server_x-23-33\data"
$unc -match "\\\\\S+\\\w+"

$unc -match "\\\\[a-zA-Z\d\-_]+\\\w+"

$unc -notmatch "\\\\[a-zA-Z\d\-_]+\\\w+"

#notmatch

#endregion

#region using Select-String

#powershell 7 includes highlighting
dir c:\scripts\*.ps1 | select-string 'requires -version 2.0' -OutVariable v
$v | get-member
$v[0] | select *
$old = dir c:\scripts\*.ps1 | select-string 'requires -version [345\.0]'
$old[0..9]
$old | group {$_.matches.value} -NoElement

#ov is an alias for the common OutVariable parameter
dir c:\scripts\*.ps1 | select-string 'requires -version \d(\.\d)?' -ov r | Group {$_.matches.value} -NoElement -ov g
#handle casing
dir c:\scripts\*.ps1 | select-string 'requires -version \d(\.\d)?' -ov r | Group {$_.matches.value.tolower()} -NoElement -ov g

#group my major version
dir c:\scripts\*.ps1 | select-string 'requires -version \d' | Group {$_.matches.value.tolower()}

help Select-String -full

#endregion

#region using Switch
$phone="(315) 456-7890"

Switch -regex ($phone) {
 "^\(\d{3}\)\s\d{3}-\d{4}$" {Write-Host "$phone is a valid phone number" -ForegroundColor green;break}
 "\d{3}-\d{4}"       {Write-Host "Can't determine area code" -ForegroundColor red}
 "\d{7}" {Write-Host "Missing the hyphen" -ForegroundColor yellow}
 "\d{3}-\d{3}-\d{4}" {Write-Host "Use () for the area code" -ForegroundColor yellow}

 default { Write-Host "Failed to find a regex match for $phone" -ForegroundColor magenta}
}

cls
#endregion

#region split

help about_split
$a = "192.168.5.100"
$a | get-member split
$a.split(".")

$b = "jeff345foo387jason"
$b -split "\d{3}"

#this won't work
$b -split "\d"

cls
#endregion

#region replace
help about_Comparison_Operators

#method - not regular expression...
$c = "Jeff"
$c.Replace.OverloadDefinitions
#... but it is case-sensitive 
$c.replace("F","x")
$c.replace("f","x")

#powershell is not case-sensitive
$c -replace "F","X"
#use patterns
$b -replace "\d{3}","---"

$mask = "DC-((PHI)|(NYC))-\d+"
#DC-PHI-123 or DC-NYC-2
$text = "Discovered domain controller DC-NYC-12"
$text -replace $mask,"*"

if ($text -match $mask) {
    $hide = "*" * $matches[0].length
    $text -replace $mask,$hide
}
else {
    $text
}

#an advanced example using the .NET regex class
psedit .\out-redacted.ps1
. .\out-redacted.ps1
#this works better in the console than the ISE
get-winevent -FilterHashtable @{logname="Security";id=4648} -MaxEvents 1 | select -ExpandProperty message | out-redacted

cls

#endregion 

#region parameter validation

get-sharedata \\localhost\scripts#region parameter validation

psedit .\Demo-ValidatePattern.ps1
. .\Demo-ValidatePattern.ps1
get-sharedata \\localhost\scripts
get-sharedata "\\local host\scripts"

"\\foo\bar","bad\sharename","\\srv1\public","\\srv-32-nyc\sales" | Get-ShareData 

psedit .\Convert-HTMLtoANSI.ps1
. .\Convert-HTMLtoANSI.ps1

"#123FF00","#CC-00F","#FFF000" | Convert-HtmlToAnsi

cls

#endregion

#region online testing

# Patterns: \bERR\b, \d{4}-\d{2}-\d{2}\s(\d{2}:){2}\d{2}Z
# Data: get-content .\demolog.txt | set-clipboard

start https://rubular.com

start https://regex101.com

#endregion

#region cheat sheet

#I can't recall where I got this or who created it
invoke-item .\regex-quick-ref.pdf

#endregion