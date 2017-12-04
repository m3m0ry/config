# Make sure aliases are expanded when using sudo.
alias please='sudo '
alias sudo='sudo '

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
alias grep='grep --color=auto'
alias nano='nano -w'
alias ping='ping -c 5'
alias mkdir='mkdir -p -v'
alias bc='bc -l'
alias j='jobs -l'


# ls configuration
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



abbr -a g git
abbr -a v vim
abbr -a c clear
abbr -a l ls
