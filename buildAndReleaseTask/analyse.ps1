[CmdletBinding()]
param()

Trace-VstsEnteringInvocation $MyInvocation

# Check value contains content befor returning string value
function NamePairCheck($name, $value, $addQuotes) {

    if (-not ([string]::IsNullOrEmpty($value))) {
       $argument = ' /' + $name
       if ($addQuotes -match "true") {
           $argument += '="' + $value + '"'
       } else {
           $argument += '=' + $value
       }
       Write-Host $argument
       return $argument
   } else {
       return ''
   }
}

try {

    # Get the inputs.
    [string]$TargetExecutable = Get-VstsInput -Name TargetExecutable
    [string]$TargetArguments = Get-VstsInput -Name TargetArguments
    [string]$TargetWorkingDir = Get-VstsInput -Name TargetWorkingDir
    [string]$TempDir = Get-VstsInput -Name TempDir
    [string]$ReportType = Get-VstsInput -Name ReportType
    [string]$Output = Get-VstsInput -Name Output
    [string]$InheritConsole = Get-VstsInput -Name InheritConsole
    [string]$AnalyseTargetArguments = Get-VstsInput -Name AnalyseTargetArguments
    [string]$Scope = Get-VstsInput -Name Scope
    [string]$Filters = Get-VstsInput -Name Filters
    [string]$AttributeFilters = Get-VstsInput -Name AttributeFilters
    [string]$DisableDefaultFilters = Get-VstsInput -Name DisableDefaultFilters
    [string]$SymbolSearchPaths = Get-VstsInput -Name SymbolSearchPaths
    [string]$AllowSymbolServerAccess = Get-VstsInput -Name AllowSymbolServerAccess
    [string]$ReturnTargetExitCode = Get-VstsInput -Name ReturnTargetExitCode
    [string]$ProcessFilters = Get-VstsInput -Name ProcessFilters
    [string]$HideAutoProperties = Get-VstsInput -Name HideAutoProperties
    [string]$LogFile = Get-VstsInput -Name LogFile
    [string]$ProjectPattern = Get-VstsInput -Name ProjectPattern

    $DotCoverCommand = "analyse"
    $DotCoverPath = "JetBrains.dotCover.CommandLineTools.2017.3.2\"
    $DefaultOutputFilename = "CodeAnalyseResults"

    #### Create Command
    write-host "**** - Create Command Line Script.. Starting - **** "

    $cmdline = 'dotcover ' + $DotCoverCommand
    
    #### Check Output Directory
    if ([string]::IsNullOrEmpty($Output)){
        $Output = "$TargetWorkingDir"
    }
    elseif (-not($Output.Contains(".xml") -Or $Output.Contains(".html"))){
        if ($Output.Substring($Output.Length - 1).Contains("\") -Or $Output.Substring($Output.Length - 1).Contains("/")){
            $Output += "$DefaultOutputFilename.$ReportType"
        } else {
            $Output += "\$DefaultOutputFilename.$ReportType"
        }
    }

    #### Get Assembilies
    if (-not([string]::IsNullOrWhiteSpace($ProjectPattern))) {
        $SearchPath = $TargetWorkingDir + '\*'
        $var = get-childitem -Path $SearchPath -Filter  $ProjectPattern -recurse

        write-host "**** - Fetching list of Test Assembilies.. Begin - **** "
        $testAssmbilies = ""
        foreach ($file in $var) { 
            if ($testAssmbilies -notcontains $file.FullName) {
                write-host "Test Assembilie: " $file.FullName
                $testAssmbilies = $testAssmbilies + '\"' + $file.FullName + '\"' + " " 
            }
        }

        $TargetArguments = "$testAssmbilies $TargetArguments"

        if ([string]::IsNullOrEmpty($testAssmbilies)){
            Write-Error "No Files Found."
        }

        write-host "**** - Fetching list of Test Assembilies.. End - **** "
    }
    
    write-host "**** - Setting options.. Starting - **** "

    $cmdline += NamePairCheck -name "TargetExecutable" -value $TargetExecutable -addQuotes true
    $cmdline += NamePairCheck -name "TargetWorkingDir" -value $TargetWorkingDir -addQuotes true
    $cmdline += NamePairCheck -name "TempDir" -value $TempDir -addQuotes true
    $cmdline += NamePairCheck -name "ReportType" -value $ReportType -addQuotes true
    $cmdline += NamePairCheck -name "Output" -value $Output -addQuotes true
    $argus = NamePairCheck -name "TargetArguments" -value $TargetArguments -addQuotes false
    $cmdline += ' "' + $argus.Substring(1) + '" '
    $cmdline += NamePairCheck -name "InheritConsole" -value $InheritConsole -addQuotes true
    $cmdline += NamePairCheck -name "AnalyseTargetArguments" -value $AnalyseTargetArguments -addQuotes true
    $cmdline += NamePairCheck -name "LogFile" -value $LogFile -addQuotes true
    $cmdline += NamePairCheck -name "Scope" -value $Scope -addQuotes true
    $cmdline += NamePairCheck -name "Filters" -value $Filters -addQuotes true
    $cmdline += NamePairCheck -name "AttributeFilters" -value $AttributeFilters -addQuotes true
    $cmdline += NamePairCheck -name "DisableDefaultFilters" -value $DisableDefaultFilters -addQuotes true
    $cmdline += NamePairCheck -name "SymbolSearchPaths" -value $SymbolSearchPaths -addQuotes true
    $cmdline += NamePairCheck -name "AllowSymbolServerAccess" -value $AllowSymbolServerAccess -addQuotes true
    $cmdline += NamePairCheck -name "ReturnTargetExitCode" -value $ReturnTargetExitCode -addQuotes true
    $cmdline += NamePairCheck -name "ProcessFilters" -value $ProcessFilters -addQuotes true
    $cmdline += NamePairCheck -name "HideAutoProperties" -value $HideAutoProperties -addQuotes true

    write-host "**** - Setting options.. End - **** "

    write-host $cmdline

    write-host "**** - Create Command Line Script.. Starting - **** "

    #### Run Command
    write-host "**** - Run Command Line Script.. Starting - **** "

    Set-Location -Path $DotCoverPath
    cmd.exe /c $cmdline

    write-host "**** - Run Command Line Script.. Ending - **** "

}
Catch
{
    $ErrorMessage = $_.Exception.Message
    $FailedItem = $_.Exception.ItemName
    Write-Error "$FailedItem - $ErrorMessage"
}
finally {
    Trace-VstsLeavingInvocation $MyInvocation
}

