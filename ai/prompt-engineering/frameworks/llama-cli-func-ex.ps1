# https://huggingface.co/unsloth/Llama-3.2-1B-Instruct-GGUF/resolve/main/Llama-3.2-1B-Instruct-UD-Q8_K_XL.gguf?download=true
$ModelSm = "downloads/models/Llama-3.2-1B-Instruct-UD-Q8_K_XL.gguf"  # 1.84GB
# https://huggingface.co/unsloth/Qwen3.6-35B-A3B-GGUF/resolve/main/Qwen3.6-35B-A3B-UD-Q5_K_XL.gguf?download=true
$ModelLg = "downloads/models/Qwen3.6-35B-A3B-UD-Q5_K_XL.gguf"  # 26.6GB
# https://huggingface.co/unsloth/gemma-4-31B-it-GGUF/resolve/main/gemma-4-31B-it-UD-Q5_K_XL.gguf?download=true
$ModelGm = "downloads/models/gemma-4-31B-it-UD-Q5_K_XL.gguf"  # 21.9GB
# # https://huggingface.co/unsloth/Llama-3.3-70B-Instruct-GGUF/resolve/main/Llama-3.3-70B-Instruct-UD-IQ3_XXS.gguf?download=true
$Model33 = "downloads/models/Llama-3.3-70B-Instruct-UD-IQ3_XXS.gguf"  # 27.7GB

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
            "--n-gpu-layers", "999"
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

$options = @{
    models=@($ModelSm, $ModelLg, $ModelGm, $Model33);
    large=@($false, $true);
    thinking=@($false, $true);
    prompts=@("Output the text 'Hello World!'", "python code that hosts a gguf LLM model on an API that can be conversed with");
}

$idx = 0
$total = $options['models'].Count * $options['large'].Count * $options['thinking'].Count * $options['prompts'].Count

foreach ($thinking in $options['thinking']) {
    foreach ($large in $options['large']) {
        foreach ($model in $options['models']) {
            foreach ($prompt in $options['prompts']) {
                $percent = ($idx + 1) / $total * 100
                # Write-Progress -Activity "Model - $model; large - $large; thinking - $thinking; prompt - $prompt" -Status "Finishing..." -PercentComplete $percent
                Write-Host -ForegroundColor Cyan "$percent% Model - $model; large - $large; thinking - $thinking; prompt - $prompt"
                if ($large -and $thinking) {
                    Start-PromptEx -Model $model -Prompt $prompt -Large -Thinking
                } elseif ($large -and -not $thinking) {
                    Start-PromptEx -Model $model -Prompt $prompt -Large
                } elseif (-not $large -and $thinking) {
                    Start-PromptEx -Model $model -Prompt $prompt -Thinking
                } else {
                    Start-PromptEx -Model $model -Prompt $prompt
                }
                $idx += 1
            }
        }
    }
}

# Write-Host -ForegroundColor Cyan "$ModelSm SMALL ctx size"
# Start-PromptEx -Prompt "Output the text 'Hello World!'"

# Write-Host -ForegroundColor Cyan "$ModelSm LARGE ctx size"
# Start-PromptEx -Prompt "Output the text 'Hello World!'" -Large

# Write-Host -ForegroundColor Cyan "$ModelLg SMALL ctx size"
# Start-PromptEx -Prompt "Output the text 'Hello World!'" -Model $ModelLg

# Write-Host -ForegroundColor Cyan "$ModelLg LARGE ctx size"
# Start-PromptEx -Prompt "Output the text 'Hello World!'" -Large -Model $ModelLg

Write-Host -ForegroundColor Green "Done!"
