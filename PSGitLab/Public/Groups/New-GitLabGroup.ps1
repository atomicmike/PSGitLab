Function New-GitLabGroup {
    [cmdletbinding()]
    param(
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory=$true)]
        [string]$name,
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory=$true)]
        [string]$path,
        [string]$description,
        [string]$parent_id,
        [switch]$membership_lock,
        [switch]$share_with_group_lock,
        [switch]$lfs_enabled,
        [switch]$request_access_enabled,
        [string]$shared_runners_minutes_limit,
        [Switch]$public,
        [ValidateSet("Private", "Internal", "Public")]
        [String]$visibility_level
    )

    $Body = @{
        name = $Name
    }
    $PSBoundParameters.Remove('Name') | Out-Null

    try {
        foreach($p in $PSBoundParameters.GetEnumerator()) {
            if ($p.Key -eq 'visibility_level') {
                $vLevel = switch ($p.Value) {
                    'Private' {0}
                    'Internal' {10}
                    'Public' {20}
                }
                $Body.Add($p.Key, $vLevel)
            } else {
                $Body.Add($p.Key, $p.Value)
            }
        }

        $Request = @{
            URI='/groups';
            Method='POST';
            Body=$Body;
        }

        QueryGitLabAPI -Request $Request -ObjectType 'GitLab.Group'
    }
    catch {
        Write-Error $_
    }
}
