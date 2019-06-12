#!/usr/bin/env bash

#https://superuser.com/questions/86340/linux-command-to-repeat-a-string-n-times
maroon='\[\033[38;5;52m\]'
forest='\[\033[38;5;22m\]'
tan='\[\033[38;5;179m\]'
dark_grey='\[\033[38;5;244m\]'
lavender='\[\033[38;5;183m\]'

PROMPT_VERTICAL_BAR_CHAR=${PROMPT_VERTICAL_BAR_CHAR:-┋}
PROMPT_VERTICAL_BAR_COLOR=${PROMPT_VERTICAL_BAR_COLOR:-$maroon}

PROMPT_HORIZONTAL_BAR_CHAR=${PROMPT_HORIZONTAL_BAR_CHAR:-┉}
PROMPT_HORIZONTAL_BAR_COLOR=${PROMPT_HORIZONTAL_BAR_COLOR:-$maroon}

PROMPT_CURSOR_CHAR=${PROMPT_CURSOR_CHAR:-◆}
PROMPT_CONTINUE_CURSOR_CHAR=${PROMPT_CONTINUE_CURSOR_CHAR:-◇}
PROMPT_CURSOR_COLOR=${PROMPT_CURSOR_COLOR:-$red}

PROMPT_CMD_SUCCESS_CHAR=${PROMPT_CMD_SUCCESS_CHAR:-︎︎✔︎}
PROMPT_CMD_SUCCESS_COLOR=${PROMPT_CMD_SUCCESS_COLOR:-︎︎$forest}

PROMPT_CMD_FAIL_CHAR=${PROMPT_CMD_FAIL_CHAR:-︎︎✘}
PROMPT_CMD_FAIL_COLOR=${PROMPT_CMD_FAIL_COLOR:-︎︎$maroon}

PROMPT_USER_COLOR=${PROMPT_USER_COLOR:-$white}
PROMPT_AT_COLOR=${PROMPT_AT_COLOR:-$maroon}
PROMPT_HOST_COLOR=${PROMPT_HOST_COLOR:-$dark_grey}

PROMPT_WORKDIR_CHAR=${PROMPT_WORKDIR_CHAR:-↳}
PROMPT_WORKDIR_COLOR=${PROMPT_WORKDIR_COLOR:-$red}

# SCM_THEME_PROMPT_DIRTY="✗"
# SCM_THEME_PROMPT_CLEAN="✓"
# SCM_THEME_PROMPT_PREFIX=""
# SCM_THEME_PROMPT_SUFFIX=""
# GIT_THEME_PROMPT_DIRTY="✗"
# GIT_THEME_PROMPT_CLEAN="✓"
# GIT_THEME_PROMPT_PREFIX=""
# GIT_THEME_PROMPT_SUFFIX=""

SCM_GIT_CHAR='⎇'
export SCM_GIT_CHAR

SCM_THEME_PROMPT_PREFIX=' '
export SCM_THEME_PROMPT_PREFIX

SCM_THEME_PROMPT_SUFFIX=''
export SCM_THEME_PROMPT_SUFFIX

KUBE_PS1_BINARY=oc
KUBE_PS1_SYMBOL_USE_IMG=true
KUBE_PS1_NS_ENABLE=false
KUBE_PS1_SYMBOL_COLOR=blue
KUBE_PS1_CTX_COLOR=blue
KUBE_PS1_NS_COLOR=blue
KUBE_PS1_CLUSTER_FUNCTION=__prompt_k8s_cluster_function

###############################################################################
# HORIZONTAL BAR
__prompt_horizontal_bar() {
    if [ -z ${COLUMNS+x} ]; then
        column_count=$(tput cols)
    else
        column_count=$COLUMNS
    fi

    bat=$(printf "%s" "⚡$(battery_percentage)")
    bat_length=${#bat}

    dt=$(date)
    dt_length=${#dt}

    line_pre_length="$((($column_count - $dt_length - $bat_length) - 14))"
    line_pre=$(eval printf "$PROMPT_HORIZONTAL_BAR_CHAR%.0s" {1..$line_pre_length})
    line_short=$(eval printf '$PROMPT_HORIZONTAL_BAR_CHAR%.0s' {1..2})
    whole_line="$line_pre  $bat  $line_short  $dt  $line_short"
    printf "$PROMPT_HORIZONTAL_BAR_COLOR$whole_line$reset_color"
}

###############################################################################
# VERTICAL BAR
__prompt_vertical_bar() {
    printf "$PROMPT_HORIZONTAL_BAR_COLOR$PROMPT_VERTICAL_BAR_CHAR$reset_color"
}

###############################################################################
# CURSOR
__prompt_cursor() {
    printf "$PROMPT_CURSOR_COLOR$PROMPT_CURSOR_CHAR$reset_color"
}
__prompt_continue_cursor() {
    printf "$PROMPT_CURSOR_COLOR$PROMPT_CONTINUE_CURSOR_CHAR$reset_color"
}

###############################################################################
# LAST COMMAND STATUS
__prompt_last_command_status() {
    if [ $last_command_exit_code != 0 ]; then
        printf "$PROMPT_CMD_FAIL_COLOR$PROMPT_CMD_FAIL_CHAR$reset_color"
    else
        printf "$PROMPT_CMD_SUCCESS_COLOR$PROMPT_CMD_SUCCESS_CHAR$reset_color"
    fi
}

###############################################################################
# SESSION INFO
__prompt_user_host() {
    prompt_user_color="$white"
    user=$(whoami)
    if [ $user != 'tadamo' ]; then
        prompt_user_color="$lavender"
    fi
    hostname=$(hostname -s)
    printf "$PROMPT_USER_COLOR$user$reset_color$PROMPT_AT_COLOR@$reset_color$PROMPT_HOST_COLOR$hostname$reset_color"
    return $((${#user} + ${#hostname} + 1))
}

__prompt_git() {
    git_prompt=$(scm_prompt_char_info)
    printf "$tan$git_prompt$reset_color"
    return $((${#git_prompt}))
}

__prompt_k8s_cluster_function() {
    if [ -z ${KUBECONFIG_CURRENT_SESSION_DIRECTORY+x} ]; then
        k8s_session_icon='|-'
    else
        k8s_session_icon='|👤'
    fi
    echo "$1$k8s_session_icon"
}

__prompt_k8s() {
    k8s_prompt=$(kube_ps1)
    printf "$k8s_prompt"
    return $((${#k8s_prompt}))
}

__prompt_session_line() {
    if [ -z ${COLUMNS+x} ]; then
        column_count=$(tput cols)
    else
        column_count=$COLUMNS
    fi

    user_host=$(__prompt_user_host)
    user_host_length=$?
    #echo "$user_host_length"

    git=$(__prompt_git)
    git_length=$?

    # This isn't the correct value, it's also counting escape chars
    git_length=40
    #echo "$git_length"

    k8s=$(__prompt_k8s)
    k8s_length=$?
    #echo "$k8s_length"

    spacer_length="$((($column_count - $user_host_length - $git_length - $k8s_length) - 10))"
    spaces=$(printf '%*s' $spacer_length)
    spaces_length=${#spaces}

    printf "$(__prompt_vertical_bar) $user_host$spaces$git    $k8s"
}

###############################################################################
# WORKING INFO
__prompt_working_directory() {
    printf "$PROMPT_WORKDIR_COLOR$PROMPT_WORKDIR_CHAR $(dirs +0)$reset_color"
}

__prompt_working_info() {
    printf "$(__prompt_vertical_bar) $(__prompt_last_command_status)  $(__prompt_working_directory)"
}

###############################################################################
###############################################################################
###############################################################################
__prompt_header_line() {
    printf "$(__prompt_horizontal_bar)\n"
}
__prompt_2nd_line() {
    printf "$(__prompt_session_line)\n"
}
__prompt_3rd_line() {
    printf "$(__prompt_working_info)\n"
}
__prompt_cursor_line() {
    printf "$(__prompt_vertical_bar) $(__prompt_cursor)"
}
__prompt_cursor_continue_line() {
    printf "$(__prompt_vertical_bar) $(__prompt_continue_cursor)"
}

prompt_command() {
    local last_command_exit_code=$?
    PS1="$(__prompt_header_line)\n$(__prompt_2nd_line)\n$(__prompt_3rd_line)\n$(__prompt_cursor_line) "
    PS2="$(__prompt_cursor_continue_line) "
    PS3="$(__prompt_cursor_continue_line) "
    PS4="$(__prompt_cursor_continue_line) "
    export docker_working_directory=$PWD
}

safe_append_prompt_command prompt_command
