$InvokePromptModule = [IO.Path]::GetFullPath("$PSScriptRoot/llama-cli-func-ex.psm1")
Import-Module -Name $InvokePromptModule -Force
$options = @{
    models=@($env:ModelTn, $env:ModelSm, $env:ModelMd, $env:ModelLg);
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
                    Invoke-Prompt -Model $model -Prompt $prompt -Large -Thinking
                } elseif ($large -and -not $thinking) {
                    Invoke-Prompt -Model $model -Prompt $prompt -Large
                } elseif (-not $large -and $thinking) {
                    Invoke-Prompt -Model $model -Prompt $prompt -Thinking
                } else {
                    Invoke-Prompt -Model $model -Prompt $prompt
                }
                $idx += 1
            }
        }
    }
}

Write-Host -ForegroundColor Green "Done!"
