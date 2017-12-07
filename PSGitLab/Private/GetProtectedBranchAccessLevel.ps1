function GetProtectedBranchAccessLevel {
    param(
        [ValidateSet("NoAccess", "DeveloperAccess", "MasterAccess")]
        $String 
    )

    switch ($String) 
    {
        'MasterAccess' { 40; break; }
        'DeveloperAccess' { 30; break; }
        'NoAccess' { 0; break; }
    }

}