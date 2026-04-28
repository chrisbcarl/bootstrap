# https://huggingface.co/unsloth/Llama-3.2-1B-Instruct-GGUF/resolve/main/Llama-3.2-1B-Instruct-UD-Q8_K_XL.gguf?download=true
$env:ModelSm = "$($env:USERPROFILE)/downloads/models/Llama-3.2-1B-Instruct-UD-Q8_K_XL.gguf"  # 1.84GB
# https://huggingface.co/unsloth/Qwen3.6-35B-A3B-GGUF/resolve/main/Qwen3.6-35B-A3B-UD-Q5_K_XL.gguf?download=true
$env:ModelLg = "$($env:USERPROFILE)/downloads/models/Qwen3.6-35B-A3B-UD-Q5_K_XL.gguf"  # 26.6GB
# https://huggingface.co/unsloth/gemma-4-31B-it-GGUF/resolve/main/gemma-4-31B-it-UD-Q5_K_XL.gguf?download=true
$env:ModelGm = "$($env:USERPROFILE)/downloads/models/gemma-4-31B-it-UD-Q5_K_XL.gguf"  # 21.9GB
# https://huggingface.co/unsloth/Llama-3.3-70B-Instruct-GGUF/resolve/main/Llama-3.3-70B-Instruct-UD-IQ3_XXS.gguf?download=true
$env:Model33 = "$($env:USERPROFILE)/downloads/models/Llama-3.3-70B-Instruct-UD-IQ3_XXS.gguf"  # 27.7GB
# https://huggingface.co/unsloth/gemma-3-27b-it-GGUF/resolve/main/gemma-3-27b-it-Q5_K_M.gguf?download=true
$env:ModelMm = "$($env:USERPROFILE)/downloads/models/gemma-3-27b-it-Q5_K_M.gguf"  # 19.3GB

function Start-PromptEx {
    <#
    https://unsloth.ai/docs/models/qwen3.6#llama.cpp-guides
    see https://unsloth.ai/docs/models/qwen3.6#llama.cpp-guides#qwen3.6-35b-a3b
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)][string]$Prompt,
        [Parameter()][string]$Model=$env:ModelSm,
        [Parameter()][switch]$Cpu,
        [Parameter()][switch]$Large,
        [Parameter()][switch]$Thinking,
        [Parameter()][switch]$Random
    )
    $start = Get-Date
    $arglist = @(
        "-m", "`"$Model`"",
        "-p", "`"$Prompt`"",
        "-t", "$([math]::Round([int]::Parse($env:NUMBER_OF_PROCESSORS) * 4 / 5))",
        "--no-display-prompt",
        "--single-turn",
        "--simple-io",
        # unsloth recommended code-type responses
        "--temp",  "0.6",
        "--top-p", "0.95",
        "--top-k", "20",
        "--min-p", "0.00"
    )
    if (-Not $Cpu) {
        # default
        $arglist += @(
            "--n-gpu-layers", "auto"  # rather than 999
        )
    } else {
        $arglist += @(
            "--n-gpu-layers", "0"
        )
    }
    if (-Not $Large) {
        # default (not necessarily defaults of model/llama-cli)
        $arglist += @(
            "-n", "512",
            "--ctx-size", "512"
        )
    } else {
        $arglist += @(
            "-n", "4096",
            "--ctx-size", "4096"
        )
    }
    if (-Not $Thinking) {
        # default
        $arglist += @(
            "--chat-template-kwargs", "{\`"enable_thinking\`":false}",  # '{\"enable_thinking\": false}'
            "--reasoning", "off"
        )
    }
    if ($Verbose) {
        $arglist += @(
            "--verbose"
        )
    }
    if (-Not $Random) {
        $arglist += @(
            "--seed", "69"
        )
    }

    Write-Host -ForegroundColor Cyan "llama-cli.exe $arglist"
    $proc = Start-Process `
        -Filepath llama-cli.exe `
        -ArgumentList $arglist `
        -NoNewWindow `
        -PassThru -Wait

    $end = Get-Date
    Write-Host "$($end - $start)"
    if ($proc.ExitCode -ne 0) {
        Write-Host -ForeGroundColor DarkRed "FAILED: $script_short, ec $($proc.ExitCode)!"
    }
    return $proc.ExitCode
}

# Start-PromptEx -Prompt "llama-cli move thinking phase away from CPU to GPU" -Model $ModelGm -Verbose
if (-Not (Get-Command llama-cli.exe -ErrorAction SilentlyContinue)) {
    Write-Warning "llama.cpp not installed! install llama.cpp first!"
} else {
    Export-ModuleMember -Function Start-PromptEx
}