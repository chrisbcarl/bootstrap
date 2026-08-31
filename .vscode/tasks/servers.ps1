# if there is a poetry env to invoke
$poetry_env_list=$(poetry env list)
& "$env:LOCALAPPDATA/pypoetry/Cache/virtualenvs/$poetry_env_list/Scripts/Activate.ps1"

Write-Host -ForegroundColor Green "sleep hi..."
python -c "while True: print('hi ' + str(__import__('time').time())); __import__('time').sleep(15)"
