<#
.SYNOPSIS
    Test credential for valid username and password.

    3/08/2016: Version 1.0

.DESCRIPTION
    Test credential for valid username and password. Returns $true if username and password pair are valid. 

.PARAMETER Credential 
    The Credential Object to test. 

.NOTES
    Author       : Adam W. Mrowicki
    File Name    : Test-Credential.ps1

    Version History:
    1.0 - 3/08/2016
        - Initial release

.EXAMPLE
    .\Test-Credential.ps1
#>

function Test-Credential{
    [OutputType([Bool])]

    Param(
        [Parameter(
            Mandatory = $true
        )]
        [Alias(
            'Credential'
        )]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Cred = (Get-Credential)
    )

    Begin{
        Add-Type -AssemblyName System.DirectoryServices.AccountManagement
        $ContextType = [System.DirectoryServices.AccountManagement.ContextType]::Domain
        $PrincipalContext = New-Object System.DirectoryServices.AccountManagement.PrincipalContext($ContextType, $Cred.GetNetworkCredential().domain)
    }

    Process{
        return $PrincipalContext.ValidateCredentials($Cred.GetNetworkCredential().username, $Cred.GetNetworkCredential().password)
    }

    End {
        $principalContext.Dispose()
    }
}