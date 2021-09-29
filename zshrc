# Use powerline
USE_POWERLINE="true"

# Import Files
zsh_aliases=".zsh/zshaliases"
std_aliases=".aliases/stdaliases"
my_exports="~/.zsh/exports"
my_functions="~/.zsh/zsh_functions"


# Source manjaro-zsh-configuration
if [[ -e /usr/share/zsh/manjaro-zsh-config ]]; then
  source /usr/share/zsh/manjaro-zsh-config
fi
# Use manjaro zsh prompt
if [[ -e /usr/share/zsh/manjaro-zsh-prompt ]]; then
  source /usr/share/zsh/manjaro-zsh-prompt
fi


# If ^C is pressed while typing a command, add it to the history so it can be
# easily retrieved later and then abort like ^C normally does. This is useful
# when I want to abort an command to do something in between and then finish
# typing the command.
#
# Thanks to Vadim Zeitlin <vz-zsh@zeitlins.org> for a fix (--) so lines
# starting with - don't cause errors; and to Nadav Har'El
# <nyh@math.technion.ac.il> for a fix (-r) to handle whitespace/quotes
# correctly, both on the Zsh mailing list.
TRAPINT() {
    # Don't store this line in history if histignorespace is enabled and the
    # line starts with a space.
    if [[ -o histignorespace && ${BUFFER[1]} = " " ]]; then
        return $1
    fi

    # Store the current buffer in the history.
    zle && print -s -r -- $BUFFER

    # Return the default exit code so Zsh aborts the current command.
    return $1
}



# Imports

loading=`pwd`
cd ~

#---Aliases---
if [ -f "$std_aliases" ]; then
	source "$std_aliases"
else
   echo "File $std_aliases does not exist."
fi

if [ -f "$zsh_aliases" ]; then
	source "$zsh_aliases"
else
   echo "File $zsh_aliases does not exist."
fi


#---Exports---
if [ -f "$my_exports" ]; then
	source "$my_exports"
fi

#---Functions---
if [ -f "$my_functions" ]; then
	source "$my_functions"
fi


cd $loading
