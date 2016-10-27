# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
alias ll='ls -al --color=auto'
alias git='LANG=en_GB git'
alias hgrep='history | grep'

source /usr/share/doc/git-core-doc/contrib/completion/git-completion.bash
source /usr/share/git-core/contrib/completion/git-prompt.sh

export GIT_PS1_SHOWDIRTYSTATE=true
export GIT_PS1_SHOWUNTRACKEDFILES=true
export PS1='\[\e[0;93m\]\u@\h\[\e[m\]:\[\e[0;32m\]\w\[\e[m\]\[\e[0;33m\]$(__git_ps1)\[\e[m\]$ '
#export PS1='\e[0;33m\u@\h\e[m:\e[0;32m\w\e[m\e[0;31m$(__git_ps1)\e[m\$ '

