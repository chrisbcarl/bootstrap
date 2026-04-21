# https://huggingface.co/unsloth/Llama-3.2-1B-Instruct-GGUF/resolve/main/Llama-3.2-1B-Instruct-UD-Q8_K_XL.gguf?download=true
$ModelSm = "downloads/models/Llama-3.2-1B-Instruct-UD-Q8_K_XL.gguf"
# https://huggingface.co/unsloth/Qwen3.6-35B-A3B-GGUF/resolve/main/Qwen3.6-35B-A3B-UD-Q6_K_XL.gguf?download=true
$ModelLg = "downloads/models/Qwen3.6-35B-A3B-UD-Q6_K_XL.gguf"

function Start-Prompt {
    <#
    https://unsloth.ai/docs/models/qwen3.6#llama.cpp-guides
    see https://unsloth.ai/docs/models/qwen3.6#llama.cpp-guides#qwen3.6-35b-a3b
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)][string]$Prompt,
        [Parameter()][string]$Model=$ModelSm
    )
    $start = Get-Date
    # CPU only, no reasoning/thinking, large output, large context, unsloth recommended code-type responses
    llama-cli `
        -m $Model `
        --n-gpu-layers 0 `
        -t $([math]::Round([int]::Parse($env:NUMBER_OF_PROCESSORS) * 4 / 5)) `
        -n 4096 `
        --ctx-size 4096 `
        --reasoning off `
        --chat-template-kwargs '{\"enable_thinking\": false}' `
        --single-turn `
        --simple-io `
        --temp 0.6 `
        --top-p 0.95 `
        --top-k 20 `
        --min-p 0.00 `
        -p $Prompt
    $end = Get-Date
    Write-Host "$($end - $start)"
}

# Start-Prompt -Prompt "powershell commandlet definition"
# Start-Prompt -Prompt "powershell commandlet definition" -Model $ModelLg
