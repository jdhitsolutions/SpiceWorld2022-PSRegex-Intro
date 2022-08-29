#requires -version 5.1

Function Get-ShareData {
    [cmdletbinding()]
    Param (
        [Parameter(
            Position = 0,
            Mandatory,
            HelpMessage = "Enter a UNC path like \\server\share",
            ValueFromPipeline
        )]
        [ValidatePattern("^\\\\[\w-]+\\[\w-]+$")]
        # [ValidateScript({ Test-Path -Path $_ })]
        [string]$Path
    )

    Begin {
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN] Starting $($myinvocation.mycommand)"
    } #begin
    Process {
        Write-Host "Getting top level folder size for $Path" -ForegroundColor Magenta
        # Get-ChildItem $path | Measure-Object -Property Length -Sum |
        # Select-Object -Property @{Name="Path";Expression={$Path}},
        # Count,Sum
    } #process
    End {
        Write-Verbose "[$((Get-Date).TimeofDay) END    ] Ending $($myinvocation.mycommand)"
    } #end
}