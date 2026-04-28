function Verb-Noun {
    <#
    Docstring

    Verb-Noun: noun can be anything
        "run verbs": Start/Invoke - async/sync
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)][string]$Required,
        [Parameter()][ValidateSet('A', 'B', 'C')][string]$Choice='A'
    )

    Write-Host "required: '$Required', choice: '$Choice'"
}
