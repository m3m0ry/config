# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'


#=========
#=OPTIONS=
#=========

# If you have any doubt or questions, pls search in the man page
# of zshoptions, or visit for example:
# http://linux.die.net/man/1/zshoptions



#-----------------------
# Changing Directories
#-----------------------

# If a command is issued that can't be executed as a normal command,
# and the command is the name of a directory, perform the cd command
# to that directory. 
setopt autocd
# Make cd push the old directory onto the directory stack. 
setopt autopushd
# If the argument to a cd command (or an implied cd with the AUTO_CD
# option set) is not a directory, and does not begin with a slash, try
# to expand the expression as if it were preceded by a '~' (see the
# section 'Filename Expansion'). 
setopt cdablevars
# Resolve symbolic links to their true values when changing directory.
# This also has the effect of CHASE_DOTS, i.e. a '..' path segment 
# will be treated as referring to the physical parent, even if the 
# preceding path segment is a symbolic link. 
setopt chaselinks
# Resolve symbolic links to their true values when changing directory.
# This also has the effect of CHASE_DOTS, i.e. a '..' path segment 
# will be treated as referring to the physical parent, even if the 
# preceding path segment is a symbolic link. 
setopt PUSHD_IGNORE_DUPS 
# Exchanges the meanings of '+' and '-' when used with a number to
# specify a directory in the stack. 
setopt PUSHD_MINUS 
# Do not print the directory stack after pushd or popd. 
setopt PUSHD_SILENT
# Have pushd with no arguments act like 'pushd $HOME'. 
setopt PUSHD_TO_HOME


#------------
# Completion
#------------
#TODO:


#------------------------
# Expansion and Globbing
#------------------------
#TODO:


#---------
# History
#---------

# Keep 5000 lines of history within the shell and save it to ~/.zsh_history:
export HISTSIZE=50000
export SAVEHIST=500
export HISTFILE=~/.zsh_history
# If this is set, zsh sessions will append their history list to the
# history file, rather than replace it. Thus, multiple parallel zsh
# sessions will all have the new entries from their history lists added
# to the history file, in the order that they exit. The file will still
# be periodically re-written to trim it when the number of lines grows
# 20% beyond the value specified by $SAVEHIST
# (see also the HIST_SAVE_BY_COPY option). 
setopt APPEND_HISTORY
# Save each command's beginning timestamp (in seconds since the epoch)
# and the duration (in seconds) to the history file. The format of this
# prefixed data is: 
# ':<beginning time>:<elapsed seconds>:<command>'. 
setopt EXTENDED_HISTORY
# Do not enter command lines into the history list if they are
# duplicates of the previous event. 
setopt HIST_IGNORE_DUPS
# Remove command lines from the history list when the first character
# on the line is a space, or when one of the expanded aliases contains
# a leading space. Note that the command lingers in the internal history
# until the next command is entered before it vanishes, allowing you to
# briefly reuse or edit the line. If you want to make it vanish right
# away without entering another command, type a space and press return. 
setopt HIST_IGNORE_SPACE


#----------------
# Initialisation
#----------------
# nothing to do here


#--------------
# Input/Output
#--------------
# Allows '>' redirection to truncate existing files, and '>>' to create
# files. Otherwise '>!' or '>|' must be used to truncate a file, and
# '>>!' or '>>|' to create a file. 
# (noclobber doesn't allow it!)
setopt NO_CLOBBER
# Try to correct the spelling of commands. Note that, when the
# HASH_LIST_ALL option is not set or when some directories in the path
# are not readable, this may falsely report spelling errors the first
# time some commands are used. 
# The shell variable CORRECT_IGNORE may be set to a pattern to match
# words that will never be offered as corrections. 
setopt correct
# Do not exit on end-of-file. Require the use of exit or logout instead.
# However, ten consecutive EOFs will cause the shell to exit anyway, to
# avoid the shell hanging if its tty goes away. 
# Also, if this option is set and the Zsh Line Editor is used, widgets
# implemented by shell functions can be bound to EOF
# (normally Control-D) without printing the normal warning message.
# This works only for normal widgets, not for completion widgets. 
setopt IGNORE_EOF
# If querying the user before executing 'rm *' or 'rm path/*', first
# wait ten seconds and ignore anything typed in that time. This avoids
# the problem of reflexively answering 'yes' to the query when one
# didn't really mean it. The wait and query can always be avoided by
# expanding the '*' in ZLE (with tab). 
setopt RM_STAR_WAIT


#-------------
# Job Control
#-------------
# Treat single word simple commands without redirection as candidates
# for resumption of an existing job. 
setopt AUTO_RESUME
# Run all background jobs at a lower priority. This option is set by
# default. 
setopt BG_NICE
# Report the status of background and suspended jobs before exiting a
# shell with job control; a second attempt to exit the shell will
# succeed. NO_CHECK_JOBS is best used only in combination with NO_HUP,
# else such jobs will be killed automatically. 
# The check is omitted if the commands run from the previous command
# line included a 'jobs' command, since it is assumed the user is aware
# that there are background or suspended jobs. A 'jobs' command run from
# one of the hook functions defined in the section SPECIAL FUNCTIONS in
# zshmisc(1) is not counted for this purpose. 
setopt CHECK_JOBS
# DON'T!!! Send the HUP signal to running jobs when the shell exits. 
setopt NO_HUP


#-----------
# Prompting
#-----------
# nothing to do here


#-----------------------
# Scripts and Functions
#-----------------------
# Output hexadecimal numbers in the standard C format, for example
# '0xFF' instead of the usual '16#FF'. If the option OCTAL_ZEROES is
# also set (it is not by default), octal numbers will be treated
# similarly and hence appear as '077' instead of '8#77'. This option
# has no effect on the choice of the output base, nor on the output of
# bases other than hexadecimal and octal. Note that these formats will
# be understood on input irrespective of the setting of C_BASES. 
setopt C_BASES
# If a command has a non-zero exit status, return immediately from the
# enclosing function. The logic is identical to that for ERR_EXIT,
# except that an implicit return statement is executed instead of an
# exit. This will trigger an exit at the outermost level of a
# non-interactive script. 
setopt ERR_RETURN
# When executing a shell function or sourcing a script, set $0
# temporarily to the name of the function/script. 
setopt FUNCTION_ARGZERO
# Perform implicit tees or cats when multiple redirections are
# attempted (see the section 'Redirection'). 
setopt MULTIOS


#-----------------
# Shell Emulation
#-----------------
# nothing to do here


#-------------
# Shell State
#-------------
#nothing to do here


#-----
# Zle
#-----
# Use the zsh line editor. Set by default in interactive shells
# connected to a terminal. 
setopt ZLE
# DON'T!!! Beep on error in ZLE. 
setopt NO_BEEP






#==============
#=Key Bindings=
#==============



# I f ZLE is loaded, turning on this option has the equivalent effect of
# 'bindkey -v'. In addition, the EMACS option is unset. Turning it off
# has no effect. The option setting is not guaranteed to reflect the
# current keymap. This option is provided for compatibility;
# bindkey is the recommended interface. 
#setopt VI
bindkey -v
# Use jj and jk to exit insert mode.
bindkey 'jj' vi-cmd-mode
bindkey 'jk' vi-cmd-mode

bindkey '^P' vi-up-line-or-history 
bindkey '^N' vi-down-line-or-history
bindkey -a '^P' history-beginning-search-backward # binding for Vi-mode
# Here only Vi-mode is necessary as ^P enters Vi-mode and ^N only makes sense
# after calling ^P.
bindkey -a '^N' history-beginning-search-forward


bindkey "^[[1~" vi-beginning-of-line   # Home
bindkey "^[[4~" vi-end-of-line         # End
bindkey '^[[2~' beep                   # Insert
bindkey '^[[3~' delete-char            # Del

bindkey '^[[5~' vi-backward-blank-word # Page Up
bindkey '^[[6~' vi-forward-blank-word  # Page Down


bindkey -a u undo
bindkey -a '^R' redo















#===========
#=My Prompt=
#===========
# Thank's to Simon Ruderich (www.ruderich.org/simon) for teaching me
# how to use zsh and giving me the idea of 2 line prompt
# Use colorized output, necessary for prompts and completions.
autoload -Uz colors && colors


# Some shortcuts for colors. The %{...%} tells zsh that the data in between
# doesn't need any space, necessary for correct prompt drawing.
local red="%{${fg[red]}%}"
local blue="%{${fg[blue]}%}"
local green="%{${fg[green]}%}"
local yellow="%{${fg[yellow]}%}"
local default="%{${fg[default]}%}"



# Copied from : http://zshwiki.org/home/zle/vi-mode to see
# if i am in cmd mode or not
# TODO: further testing
precmd() {
	  RPROMPT=""
}
zle-keymap-select() {
	  RPROMPT=""
	    [[ $KEYMAP = vicmd ]] && RPROMPT="${yellow}(CMD)${default}"
	      () { return $__prompt_status }
	        zle reset-prompt
}
zle-line-init() {
	  typeset -g __prompt_status="$?"
}
zle -N zle-keymap-select
zle -N zle-line-init






prompt_precmd() {
    # Setup. Create variables holding the formatted content.

    # Current directory in yellow
    local directory="${yellow}%~%#${default}"

    # Current time (seconds since epoch) in Hex in bright blue.
    local clock="${blue}[%T %D]${default}"

    # User name (%n) in bright green.
    local user="${green}%B%n%b${default}"
    # Host name (%m) in bright green; underlined if running on a remote
    # system through SSH.
    local host="${green}%B%m%b${default}"
    if [[ -n $SSH_CONNECTION ]]; then
        host="%U${host}%u"
    fi

    # Number of background processes in yellow.
    local background="%(1j.${yellow}(%j) ${default}.)"
    # Exit code in bright red if not zero.
    local exitcode="%(?..(${red}%B%?%b${default}%) )"


    PROMPT="${clock}${red}-${default}${user}@${host} ${background}${exitcode}
${directory} "
}
precmd_functions+=(prompt_precmd)





#-----------------
# Extract archive
#-----------------
# copied and modified for my needs from http://zshwiki.org/home/examples/functions
# Author: Copyright © 2005 Eric P. Mangold - teratorn (-at-) gmail (-dot) com
# License: MIT. http://www.opensource.org/licenses/mit-license.html 

# this fucntion can extract any usuall archives

extract_archive () {
    local old_dirs current_dirs lower
    lower=${(L)1}
    old_dirs=( *(N/) )
    if [[ $lower == *.tar.gz || $lower == *.tgz ]]; then
        tar zxfv $1
    elif [[ $lower == *.gz ]]; then
        gunzip $1
    elif [[ $lower == *.tar.bz2 || $lower == *.tbz ]]; then
        bunzip2 -c $1 | tar xfv -
    elif [[ $lower == *.bz2 ]]; then
        bunzip2 $1
    elif [[ $lower == *.zip ]]; then
        unzip $1
    elif [[ $lower == *.rar ]]; then
        unrar e $1
    elif [[ $lower == *.tar ]]; then
        tar xfv $1
    elif [[ $lower == *.lha ]]; then
        lha e $1
    else
        print "Unknown archive type: $1"
        return 1
    fi
}
alias extract=extract_archive
compdef '_files -g "*.gz *.tgz *.bz2 *.tbz *.zip *.rar *.tar *.lha"' extract_archive


#-------
# Umask
#-------
# For changing the umask automatically
chpwd () {
    case $PWD in
        $HOME/*)
            if [ $(umask) -ne 077 ] && [ $UID -ne 0 ]; then
                umask 0077
                echo -e "\033[01;32mumask: private \033[m"
            fi;;
        $HOME)
            if [ $(umask) -ne 077 ] && [ $UID -ne 0 ]; then
                umask 0077
                echo -e "\033[01;32mumask: private \033[m"
            fi;;
        *)
            if [[ $(umask) -ne 022 ]]; then
                umask 0022
                echo -e "\033[01;31mumask: world readable \033[m"
            fi;;
    esac
}
cd . &> /dev/null
















#---------
# Aliases
#---------

# Make sure aliases are expanded when using sudo.
alias sudo='sudo '

# Golobal
alias -g A='| awk'
alias -g H='| head'
alias -g T='| tail'
alias -g G='| grep'
alias -g L="| less"
alias -g M="| most"
alias -g B="&|"
alias -g HL="--help"
alias -g LE="2>&1 | less"
alias -g CE="2>&1 | cat -A"
alias -g NE="2> /dev/null"
alias -g NUL="> /dev/null 2>&1"


# fast directory change
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'
alias -g .......='../../../../../..'


# my aliases
alias c=clear
alias g=git
alias l=ls
alias v=vim
alias grep='grep --color=auto'

alias ls='ls --color=auto'
alias la='ls -a'
alias ll='ls -lah'






