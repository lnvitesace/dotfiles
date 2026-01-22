if status is-interactive
    # Commands to run in interactive sessions can go here

    export PATH="$HOME/.local/bin:$PATH"

end

# Alias
alias vim nvim

# fzf keybindings
fzf --fish | source

# Anthropic config
export ANTHROPIC_BASE_URL=https://anyrouter.top
export ANTHROPIC_AUTH_TOKEN=sk-XF99EkaA4MfySh3fAdv9AA7phlniCXbjh4Xu6tHx4p5BPDIY

# Gemini config
export GOOGLE_GEMINI_BASE_URL="https://api.chengtx.vip"
export GEMINI_API_KEY=sk-r8NwoEUxT8VAAMUVD1CzHAUR6OyedHDn9DhO2iMSgmjwZAhQ
