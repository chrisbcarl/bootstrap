# Quickstart
```powershell
irm https://claude.ai/install.ps1 | iex
add %USERPROFILE%\.local\bin to path
cd src
mkdir claude-code
cd claude-code
claude
/login


/simplify
/export
```

# Plugins
Context7
Playwright
Superpowers

# Commands
```bash
/compact - compact the current conversation
/clear
/init

/plan - enable plan mode or view the current session plan
/ultraplan
/batch                  Research and plan a large-scale change, then execute it in parallel across 5–30 isolate


/stats
/status
/usage
/context - visualize context usage
/export - export conversation to a text file
/voice - toggle voice mode
/insights - report analyzing sessions

/plugins - install Context7, playwright, superpowers
/reload-plugins - you have to run after install

/powerup - tutorials
/remove-control - connect this terminal for remote-control sessions
/remote-env - configure for teleport

/config
# verbose true
# thinking false
# model sonnet


/efforts - low, medium, high, max
sonnet + high
```


# Tips:
- Ask Claude to create a todo list when working on complex tasks to track progress and remain on track
- Double-tap esc to rewind the code and/or conversation to a previous point in time
- Tip: Hit shift+tab to cycle between default mode, auto-accept edit mode, and plan mode
- Tip: Use /agents to optimize specific tasks. Eg. Software Architect, Code Writer, Code Reviewer




# Reference
- CLI: https://code.claude.com/docs/en/cli-reference
- settings: https://code.claude.com/docs/en/settings


# Guides
- https://github.com/Cranot/claude-code-guide


# Local Exec
- https://docs.ollama.com/integrations/claude-code
- https://dev.to/tj1609/run-claude-for-free-locally-using-ollama-claude-code-45lf
- https://www.xda-developers.com/claude-code-local-llm-ollama-capable-costs-nothing/
- https://github.com/emilycodes-cmd/claude-code-ollama-local/tree/main