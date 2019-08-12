#!/usr/bin/env bash

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# # Use ag for feeding into fzf for searching files.
# export FZF_DEFAULT_COMMAND='ag -U --hidden --ignore .git -g ""'
# # Color: https://github.com/junegunn/fzf/wiki/Color-schemes - Solarized Dark
# # Bind F1 key to toggle preview window on/off
# export FZF_DEFAULT_OPTS='--bind "F1:toggle-preview" --preview "rougify {} 2> /dev/null || cat {} 2> /dev/null || tree -C {} 2> /dev/null | head -100" --color dark,hl:33,hl+:37,fg+:235,bg+:136,fg+:254 --color info:254,prompt:37,spinner:108,pointer:235,marker:235'

# # Show long commands if needed
# # From https://github.com/junegunn/fzf/wiki/Configuring-shell-key-bindings
# # Bind F1 key to toggle preview window on/off
# export FZF_CTRL_R_OPTS='--bind "F1:toggle-preview" --preview "echo {}" --preview-window down:3:hidden:wrap'

# Solarized colors
_gen_fzf_default_opts() {
    local base03="234"
    local base02="235"
    local base01="240"
    local base00="241"
    local base0="244"
    local base1="245"
    local base2="254"
    local base3="230"
    local yellow="136"
    local orange="166"
    local red="160"
    local magenta="125"
    local violet="61"
    local blue="33"
    local cyan="37"
    local green="64"

    # Comment and uncomment below for the light theme.

    # Solarized Dark color scheme for fzf
    export FZF_DEFAULT_OPTS="
    --color fg:-1,bg:-1,hl:$blue,fg+:$base2,bg+:$base02,hl+:$blue
    --color info:$yellow,prompt:$yellow,pointer:$base3,marker:$base3,spinner:$yellow
    --height 60% --reverse --border --multi --prompt '◆ '
  "
    ## Solarized Light color scheme for fzf
    #export FZF_DEFAULT_OPTS="
    #  --color fg:-1,bg:-1,hl:$blue,fg+:$base02,bg+:$base2,hl+:$blue
    #  --color info:$yellow,prompt:$yellow,pointer:$base03,marker:$base03,spinner:$yellow
    #"
}
_gen_fzf_default_opts
