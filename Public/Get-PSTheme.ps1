function Get-PSTheme {
    [CmdletBinding(DefaultParameterSetName='ByName')]
    Param (
        [Parameter(Mandatory=$false,ParameterSetName='Refresh')]
        [switch]$Refresh
    )
    DynamicParam {
        if ($PSTheme.Themes.Count -gt 0) {
            $parameterName = "Name"

            $attributes = New-Object System.Management.Automation.ParameterAttribute
            $attributes.Mandatory = $false
            $attributes.ParameterSetName = 'ByName'
            $attributes.Position = 0

            $attributeColl = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
            $attributeColl.Add($attributes)
            $attributeColl.Add((New-Object System.Management.Automation.ValidateSetAttribute($PSTheme.Themes.Keys)))

            $dynParam = New-Object System.Management.Automation.RuntimeDefinedParameter($ParameterName, [string], $attributeColl)
            $paramDict = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
            $paramDict.Add($ParameterName, $dynParam)

            $paramDict
        }
    }
    Process {
        switch ($PSCmdlet.ParameterSetName) {
            'Refresh' {
                $PSTheme.Themes = Get-Theme
            }
            Default {
                $Name = $PSBoundParameters['Name']
                Write-Debug "Name = '$Name'"

                if ($Name) {
                    $PSTheme.Themes[$Name]
                } else {
                    $PSTheme.Themes
                }
            }
        }
    }
}