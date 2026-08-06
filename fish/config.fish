if status is-interactive
    # Commands to run in interactive sessions can go here

    fish_add_path ~/.local/bin

end

# Alias
alias vim nvim
alias cat bat
alias cd z
alias ls eza
alias gs "git status"
alias ga "git add"
alias gcam "git add . && git commit -m"
alias gp "git push"
alias k kubectl
alias d docker
alias kg "kubectl get"
alias kd "kubectl describe"
alias kgp "kubectl get pods"
alias codex "codex --yolo"
alias dcu "docker compose up"
alias dcd "docker compose down"
alias dl "docker logs -f --tail 100"

# homebrew
eval (/opt/homebrew/bin/brew shellenv fish)

# fzf keybindings
fzf --fish | source

# Anthropic config
set -gx ANTHROPIC_BASE_URL https://anyrouter.top
set -gx ANTHROPIC_AUTH_TOKEN 

# set -gx ANTHROPIC_BASE_URL "https://www.su8.codes/codex/v1"
# set -gx ANTHROPIC_AUTH_TOKEN
set -gx CLAUDE_CODE_ATTRIBUTION_HEADER 0
set -gx CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC 1
set -gx DISABLE_INSTALLATION_CHECKS 1
set -gx ENABLE_TOOL_SEARCH 0

# Gemini config
# set -gx GOOGLE_GEMINI_BASE_URL "https://api.chengtx.vip"
# set -gx GEMINI_API_KEY <your-key>

zoxide init fish | source

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
# source ~/.orbstack/shell/init2.fish 2>/dev/null || :

# >>> grok installer >>>
# fish_add_path $HOME/.grok/bin
# <<< grok installer <<<

# kimi-code
# fish_add_path -g "/Users/rainsfall/.kimi-code/bin"

