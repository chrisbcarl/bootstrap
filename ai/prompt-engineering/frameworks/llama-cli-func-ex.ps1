# https://huggingface.co/unsloth/Llama-3.2-1B-Instruct-GGUF/resolve/main/Llama-3.2-1B-Instruct-UD-Q8_K_XL.gguf?download=true
$ModelSm = "downloads/models/Llama-3.2-1B-Instruct-UD-Q8_K_XL.gguf"
# https://huggingface.co/unsloth/Qwen3.6-35B-A3B-GGUF/resolve/main/Qwen3.6-35B-A3B-UD-Q6_K_XL.gguf?download=true
$ModelLg = "downloads/models/Qwen3.6-35B-A3B-UD-Q6_K_XL.gguf"

function Start-PromptEx {
    <#
    https://unsloth.ai/docs/models/qwen3.6#llama.cpp-guides
    see https://unsloth.ai/docs/models/qwen3.6#llama.cpp-guides#qwen3.6-35b-a3b
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)][string]$Prompt,
        [Parameter()][string]$Model=$ModelSm,
        [Parameter()][switch]$Cpu,
        [Parameter()][switch]$Large,
        [Parameter()][switch]$Thinking
    )
    $start = Get-Date
    $arglist = @(
        "-m", "`"$Model`"",
        "-p", "`"$Prompt`"",
        "-t", "$([math]::Round([int]::Parse($env:NUMBER_OF_PROCESSORS) * 4 / 5))",
        "--single-turn",
        "--simple-io",
        # unsloth recommended code-type responses
        "--temp",  "0.6",
        "--top-p", "0.95",
        "--top-k", "20",
        "--min-p", "0.00"
    )
    if ($Cpu) {
        $arglist += @(
            "--n-gpu-layers", "0"
        )
    }
    if ($Large) {
        $arglist += @(
            "-n", "4096",
            "--ctx-size", "4096"
        )
    }
    if (-Not $Thinking) {
        $arglist += @(
            "--chat-template-kwargs", "{\`"enable_thinking\`":false}",  # '{\"enable_thinking\": false}'
            "--reasoning", "off"
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

Write-Host -ForegroundColor Cyan "$ModelSm SMALL ctx size"
Start-PromptEx -Prompt "Output the text 'Hello World!'"

Write-Host -ForegroundColor Cyan "$ModelSm LARGE ctx size"
Start-PromptEx -Prompt "Output the text 'Hello World!'" -Large

Write-Host -ForegroundColor Cyan "$ModelLg SMALL ctx size"
Start-PromptEx -Prompt "Output the text 'Hello World!'" -Model $ModelLg

Write-Host -ForegroundColor Cyan "$ModelLg LARGE ctx size"
Start-PromptEx -Prompt "Output the text 'Hello World!'" -Large -Model $ModelLg
