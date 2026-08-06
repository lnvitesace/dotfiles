if status is-interactive
    # Commands to run in interactive sessions can go here

    fish_add_path ~/.local/bin

end

alias vim "nvim"
alias cat "bat"
alias cd "z"
alias ls "eza"
alias gs "git status"
alias ga "git add"
alias gcam "git add . && git commit -m"
alias gp "git push"
alias k "kubectl"
alias d "docker"
alias kg "kubectl get"
alias kd "kubectl describe"
alias kgp "kubectl get pods"
alias codex "codex --yolo"
alias dcu "docker compose up"
alias dcd "docker compose down"
alias dl "docker logs -f --tail 100"

# fzf keybindings
fzf --fish | source

# zoxide init
zoxide init fish | source

