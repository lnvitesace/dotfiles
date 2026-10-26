if status is-interactive
    # Commands to run in interactive sessions can go here

    fish_add_path ~/.local/bin

end

# CTRL-Z as fg
bind \cz 'fg 2>/dev/null; commandline -f repaint'

# Common alias
alias vim nvim
alias ls eza

# Git alias
abbr --add gs git status
abbr --add ga git add
abbr --add gcam "git add . && git commit -m"
abbr --add gp git push
abbr --add gl git log --all --graph --decorate --oneline
abbr --add gd git diff

# Docker alias
abbr --add dcu docker compose up
abbr --add dcd docker compose down
abbr --add dl docker logs -f --tail 100
abbr --add dp docker pull

# k8s alias
abbr --add k kubectl
abbr --add kg kubectl get
abbr --add kd kubectl describe
abbr --add kgp kubectl get pods

# Other alias
abbr --add codex codex --yolo

# fzf keybindings
fzf --fish | source

# kimi-code
fish_add_path -g "~/.kimi-code/bin"

# opencode
fish_add_path ~/.opencode/bin

# zoxide
zoxide init --cmd cd fish | source
