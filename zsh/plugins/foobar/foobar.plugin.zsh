# Global
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
alias -g ...='../../'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'
alias -g .......='../../../../../..'

# Suffix
# alias -s pdf="okular"
# alias -s c="vim"
# alias -s log="less"

#===========
#=Functions=
#===========

# Functions which are ment to be called as a command in the shell itself
# The zsh shell doesn't need them, but some of them are really nice to have.


#-----------------
# Extract archive
#-----------------
# copied and modified for my needs from http://zshwiki.org/home/examples/functions
# Author: Copyright © 2005 Eric P. Mangold - teratorn (-at-) gmail (-dot) com
# License: MIT. http://www.opensource.org/licenses/mit-license.html 

# this fucntion can extract any usuall archives

function extract_archive () {
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
        unzip $1 -d ${1:r}
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

# Make sure aliases are expanded when using sudo.
alias sudo='sudo '


#search in history
#usage: hs <word to be grepped>
alias HS='fc -l 0|grep'


# directory change
alias cd..='cd ..'
alias ..='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../../'
alias .....='cd ../../../../'
alias ......='cd ../../../../../'
alias .3='cd ../../../'
alias .4='cd ../../../../'
alias .5='cd ../../../../..'


# modified commands
alias c=clear
alias g=git
alias v='nvim'
alias vim='nvim'
alias grep='grep --color=auto'
alias nano='nano -w'
alias ping='ping -c 5'
alias mkdir='mkdir -p -v'
alias bc='bc -l'
alias j='jobs -l'


# ls configuration
alias l=ls
alias ls='ls --color=auto'
alias la='ls -A'
alias ll='ls -lah'
alias lx='ll -BX'                   # sort by extension
alias lz='ll -rS'                   # sort by size
alias lt='ll -rt'                   # sort by date

# saving my ass
# this is so fucking helpfull!!!
alias cp='cp -i -a'
alias mv='mv -i'
alias rm='rm -I --preserve-root'
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'
alias wget='wget -c'

# confused with vim
alias :q=' exit'
