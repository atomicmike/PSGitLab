Function Set-GitLabProtectedBranch 
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

        [string]$Name = $null,

        [ValidateSet("NoAccess", "DeveloperAccess", "MasterAccess")]
        $PushAccessLevel = $null,

        [ValidateSet("NoAccess", "DeveloperAccess", "MasterAccess")]
        $MergeAccessLevel = $null,

        [switch]$Passthru

    )

BEGIN {} 

PROCESS {

    foreach ( $ProjID in $ID ) {
        $Project = Get-GitLabProject -Id $ProjID

        Write-Verbose "Project Name: $($Project.Name)"

        $Body = @{}

        if ($Name -ne $null) { $Body.Add('name',$Name) }
        if ($PushAccessLevel -ne $null ) { $Body.Add('push_access_level', (GetProtectedBranchAccessLevel $PushAccessLevel) )}
        if ($MergeAccessLevel -ne $null ) { $Body.Add('merge_access_level', (GetProtectedBranchAccessLevel $MergeAccessLevel) )}

        Write-Verbose ( $PSBoundParameters | ConvertTo-Json )

        Write-Verbose "Body: $($Body | ConvertTo-Json )"

        $Request = @{
            URI = "/projects/$($Project.ID)/protected_branches"
            Method = 'POST'
            Body = $Body
            ContentType = 'application/x-www-form-urlencoded'
        }

        $Results = QueryGitLabAPI -Request $Request -ObjectType 'GitLab.ProtectedBranch'

        if ( $Passthru.isPresent ) {
            $Results
        }
    }
}

END {}

}