Function Remove-GitLabProtectedBranch 
{
    [cmdletbinding()]
    param(
        
        [ValidateNotNullOrEmpty()]
        [Parameter(
            Mandatory=$true,
            ParameterSetName='ID',
            ValueFromPipelineByPropertyName=$true
        )]
        [string[]]$ID,

        [ValidateNotNullOrEmpty()]
        [Parameter(
            Mandatory=$true,
            ParameterSetName='ID'
        )]
        [string]$Name = $null,

        [switch]$Passthru

    )

BEGIN {} 

PROCESS {

    foreach ( $ProjID in $ID ) {
        $Project = Get-GitLabProject -Id $ProjID

        Write-Verbose "Project Name: $($Project.Name)"

        $Body = @{}

        Write-Verbose ( $PSBoundParameters | ConvertTo-Json )

        Write-Verbose "Body: $($Body | ConvertTo-Json )"

        $Request = @{
            URI = "/projects/$($Project.ID)/protected_branches/$($Name)"
            Method = 'DELETE'
            Body = $Body
            ContentType = 'application/x-www-form-urlencoded'
        }

        if ($PSCmdlet.ShouldProcess($Project.Name, 'Delete Protected Branch')) {
            $Worked = QueryGitLabAPI -Request $Request -ObjectType 'GitLab.ProtectedBranch'
        }

        if ( $Passthru.isPresent ) {
            $Results
        }
    }
}

END {}

}