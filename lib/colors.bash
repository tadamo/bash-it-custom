#!/usr/bin/env bash

# Reset
# Color_Off='\e[0m'       # Text Reset

# # Regular Colors
# Black='\e[0;30m'        # Black
# Red='\e[0;31m'          # Red
# Green='\e[0;32m'        # Green
# Yellow='\e[0;33m'       # Yellow
# Blue='\e[0;34m'         # Blue
# Purple='\e[0;35m'       # Purple
# Cyan='\e[0;36m'         # Cyan
# White='\e[0;37m'        # White

# # Bold
# BBlack='\e[1;30m'       # Black
# BRed='\e[1;31m'         # Red
# BGreen='\e[1;32m'       # Green
# BYellow='\e[1;33m'      # Yellow
# BBlue='\e[1;34m'        # Blue
# BPurple='\e[1;35m'      # Purple
# BCyan='\e[1;36m'        # Cyan
# BWhite='\e[1;37m'       # White

# # Underline
# UBlack='\e[4;30m'       # Black
# URed='\e[4;31m'         # Red
# UGreen='\e[4;32m'       # Green
# UYellow='\e[4;33m'      # Yellow
# UBlue='\e[4;34m'        # Blue
# UPurple='\e[4;35m'      # Purple
# UCyan='\e[4;36m'        # Cyan
# UWhite='\e[4;37m'       # White

# # Background
# On_Black='\e[40m'       # Black
# On_Red='\e[41m'         # Red
# On_Green='\e[42m'       # Green
# On_Yellow='\e[43m'      # Yellow
# On_Blue='\e[44m'        # Blue
# On_Purple='\e[45m'      # Purple
# On_Cyan='\e[46m'        # Cyan
# On_White='\e[47m'       # White

# # High Intensty
# IBlack='\e[0;90m'       # Black
# IRed='\e[0;91m'         # Red
# IGreen='\e[0;92m'       # Green
# IYellow='\e[0;93m'      # Yellow
# IBlue='\e[0;94m'        # Blue
# IPurple='\e[0;95m'      # Purple
# ICyan='\e[0;96m'        # Cyan
# IWhite='\e[0;97m'       # White

# # Bold High Intensty
# BIBlack='\e[1;90m'      # Black
# BIRed='\e[1;91m'        # Red
# BIGreen='\e[1;92m'      # Green
# BIYellow='\e[1;93m'     # Yellow
# BIBlue='\e[1;94m'       # Blue
# BIPurple='\e[1;95m'     # Purple
# BICyan='\e[1;96m'       # Cyan
# BIWhite='\e[1;97m'      # White

# # High Intensty backgrounds
# On_IBlack='\e[0;100m'   # Black
# On_IRed='\e[0;101m'     # Red
# On_IGreen='\e[0;102m'   # Green
# On_IYellow='\e[0;103m'  # Yellow
# On_IBlue='\e[0;104m'    # Blue
# On_IPurple='\e[10;95m'  # Purple
# On_ICyan='\e[0;106m'    # Cyan
# On_IWhite='\e[0;107m'   # White

# ###     REGULAR-COLOR
# COLOROFF='\033[0m'
# BLACK='\033[0;30m'
# RED='\033[0;31m'
# GREEN='\033[0;32m'
# BROWN='\033[0;33m'
# BLUE='\033[0;34m'
# PURPLE='\033[0;35m'
# CYAN='\033[0;36m'
# LIGHT_GREY='\033[0;37m'
# DARK_GREY='\033[1;30m'
# LIGHT_RED='\033[1;31m'
# LIGHT_GREEN='\033[1;32m'
# YELLOW='\033[1;33m'
# LIGHT_BLUE='\033[1;34m'
# LIGHT_PURPLE='\033[1;35m'
# LIGHT_CYAN='\033[1;36m'
# WHITE='\033[1;37m'
# WHITETEXT='\033[1;38;5;231m'

# DARK_RED='\033[38;5;124m'
# DARK_ORANGE='\033[38;5;172m'
# DARK_YELLOW='\033[38;5;221m'
# DARK_GREEN='\033[38;5;28m'
# DARK_BLUE='\033[38;5;20m'
# DARK_PURPLE='\033[38;5;55m'
dark_pink='\[\033[38;5;90m\]'
dark_grey='\[\033[38;5;244m\]'
dark_orange='\[\033[38;5;130m\]'

# ###     HIGH-COLOR
# PINK='\033[38;5;211m'
# ORANGE='\033[38;5;208m'
# SKYBLUE='\033[38;5;111m'
# MEDIUMGREY='\033[38;5;246m'
lavender='\[\033[38;5;183m\]'
tan='\[\033[38;5;179m\]'
forest='\[\033[38;5;22m\]'
maroon='\[\033[38;5;52m\]'
# HOTPINK='\033[38;5;198m'
# MINTGREEN='\033[38;5;121m'
# LIGHTORANGE='\033[38;5;215m'
# LIGHTRED='\033[38;5;203m'
# JADE='\033[38;5;35m'
# LIME='\033[38;5;154m'

# ### background colors
#PINK_BG='\[\033[48;5;211m\]'
# ORANGE_BG='\033[48;5;203m'
# SKYBLUE_BG='\033[48;5;111m'
# MEDIUMGREY_BG='\033[48;5;246m'
# LAVENDER_BG='\033[48;5;183m'
# TAN_BG='\033[48;5;179m'
# FOREST_BG='\033[48;5;22m'
# MAROON_BG='\033[48;5;52m'
# HOTPINK_BG='\033[48;5;198m'
# MINTGREEN_BG='\033[48;5;121m'
# LIGHTORANGE_BG='\033[48;5;215m'
# LIGHTRED_BG='\033[48;5;203m'
# JADE_BG='\033[48;5;35m'
# LIME_BG='\033[48;5;154m'

# ### extra attributes
# UNDERLINE='\033[4m'

### sample of combining foreground and background
# PRI_A="$HOTPINK$MEDIUMGREY_BG$UNDERLINE"
