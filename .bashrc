# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

#-----------------------------------------------------------------------------#
### Setting command prompt to show user, host, pwd and git branch
#-----------------------------------------------------------------------------#

export PS1="\[\033[0;36m\]\[\033[0m\033[0;36m\]\u \[\033[0;37m\]@ \[\033[0;34m\]\h \[\033[00;33m\][\w] \[\033[0;91m\]\$(git_branch) \[\033[00m\]\$ "

export PATH=~/.local/bin:$PATH

#-----------------------------------------------------------------------------#
### Personalized Aliases
#-----------------------------------------------------------------------------#

alias source-all="source ~/.bashrc && source ~/.bash_aliases"

alias drm='docker stop $(docker ps -qa) && docker rm $(docker ps -qa) && docker image rm $(docker images) && docker volume rm $(docker volume ls)' # && docker ps -a && docker images && docker volume ls'
alias dps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Image}}\t{{.Ports}}"'
alias dpsa='docker ps -a'
alias dstart='docker start $(docker ps -qa)'
alias dstop='docker stop $(docker ps -qa)'
alias dockx='docker rm $(docker ps -qa)'

alias jenkins-node='docker exec -e COLUMNS="`tput cols`" -e LINES="`tput lines`" -ti jenkins-node bash'

#-----------------------------------------------------------------------------#
### Docker status & stat commands
#-----------------------------------------------------------------------------#

# This will show the current settings for the container at run time
alias dps-status='while true; do clear && echo "#-----------------------------------------------------------------------------#" && echo "### Docker container status" && echo "#-----------------------------------------------------------------------------#" && echo "" && docker ps -a --format "table {{.Names}}\t{{.Status}}\t{{.Image}}\t{{.Ports}}" && sleep 2; done'

# This shows the stats of each container and the resources consumed
alias dps-stats='docker stats --all --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}"'


# File used for personalized Aliases

# Common Commands
alias vi='vim'
alias rm='sudo rm'
alias chmod='sudo chmod'
alias chown='sudo chown'
alias rmdir='sudo rmdir'
alias cl='clear'
alias reboot='sudo reboot'
alias webserv='cd /var/www'
alias x='exit'

# Update/Upgrade/Remove
alias install='sudo apt-get install'
alias remove='sudo apt-get --purge remove'
alias update='sudo apt-get update'
alias upgrade='sudo apt-get upgrade'
alias search='apt-cache search'
alias uu='sudo apt-get update -y && sudo apt-get upgrade -y'
alias uur='sudo apt-get update -y && sudo apt-get upgrade -y && sudo reboot'
alias uucr='sudo apt-get update -y && sudo apt-get upgrade -y && sudo apt-get autoclean && sudo reboot'
alias uucs='sudo apt-get update -y && sudo apt-get upgrade -y && sudo apt-get autoclean && sudo shutdown -P now'
alias deb='sudo dpkg -i'
alias clean='sudo apt-get autoclean'

#-----------------------------------------------------------------------------#
### General Aliased Commands
#-----------------------------------------------------------------------------#

alias ll='ls -larth'
alias vialias='vim ~/.bashrc'
alias deb='sudo dpkg -i'
