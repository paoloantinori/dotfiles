# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	source /etc/bashrc
fi

# https://github.com/trapd00r/LS_COLORS
if [ -f $HOME/.dircolors ]; then
	eval $(dircolors -b $HOME/.dircolors)
fi

__prompt(){
	printf_format='(%s)'
	TXT=$(pwd);
	LEN=20;
	if (( ${#TXT}  > $LEN )); then 
	    TXT='..'${TXT:$(( ${#TXT} - ($LEN -2) )):$LEN}
	fi
	printf -- "$printf_format" $TXT
}


# PS1='[\e[1;35m\t\e[0m][\e[0;93m$(__prompt )\e[0m]\$ '

DARKGRAY='\e[1;30m'  
LIGHTRED='\[\e[31m\]'
GREEN='\e[32m'  
YELLOW='\[\e[33m\]'  
LIGHTBLUE='\e[1;34m'  
NC='\[\e[m\]'  # NO_COLOR
PURPLE='\[\e[1;35m\]'

# i have to escape the dollar that invokes the function since i am within double quotes
PCT="\$(if [[ \$EUID -eq 0 ]]; then T='$LIGHTRED' ; else T='$PURPLE'; fi;   echo \$T )"  

## 2 lines prompt
# PS1="\n$GREEN[\w] \n$DARKGRAY($PCT\t$DARKGRAY)-($PCT\u$DARKGRAY)-($PCT\!  $DARKGRAY)$YELLOW-> $NC"  

## simple prompt with colors
# export PS1="$PCT\u$NC@$YELLOW\h$NC\\$ "
# i have to escape the dollar that invokes the function since i am within double quotes
export PS1="$PCT\t$NC $YELLOW\$(__prompt )$NC\\$ "



# Maven opts
export MAVEN_OPTS="-Xms256m -Xmx2048m -XX:MaxPermSize=1024m  -XX:+CMSClassUnloadingEnabled -XX:+UseGCOverheadLimit"

export IDEA_JDK=/usr/java/jdk7_latest

#Play Framework
export PATH=/data/software/ext/play/play-2.0.4:$PATH

#Scala Building Tool
export PATH=/data/software/ext/sbt/bin:$PATH

#Infinispan Client
export ISPNCON_HOME=/data/repositories/github/ispncon
export PATH=$ISPNCON_HOME/bin:$PATH

#hURL
export PATH=/data/repositories/github/hURL:$PATH

#Standard ML
export PATH=/home/pantinor/sml/bin:$PATH

#java
#export JAVA_HOME=/usr/bin/JAVA_HOME
#export PATH=$PATH:$JAVA_HOME/bin

#gradle
#export PATH=/data/software/ext/gradle/gradle-1.8/bin:$PATH

export VISUAL="/usr/bin/sublime -n -w"

export GREP_OPTIONS='--color=auto'
# export GREP_COLOR='1;33'
alias yum='yum --color=auto'
alias o='xdg-open'
alias ll='ls -lh'
alias lls='ll'
alias cpprogress="rsync -WavP --human-readable --progress"
alias gollum="(cd /data/repositories/openshift/wiki/ && gollum)"
alias killkaraf="jps -lm | grep karaf | grep -v grep | awk '{print $1}' | xargs kill -KILL"
alias sshi="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o PreferredAuthentications=password"
alias scpi="scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o PreferredAuthentications=password"



# `cat` with beautiful colors. requires Pygments installed.
# sudo easy_install Pygments
alias catc='pygmentize -O style=monokai -f console256 -g'

# init z https://github.com/rupa/z
if [ -f /data/software/ext/z/z.sh ]; then
	source /data/software/ext/z/z.sh
	export MANPATH=$MANPATH:/data/software/ext/z
fi

# init node.js
# if [ -f /data/repositories/github/apps/nvm/nvm.sh ]; then
# 	source /data/repositories/github/apps/nvm/nvm.sh
# fi

# maven color
if [ -f ~/colorize-maven.sh ]; then
	source ~/colorize-maven.sh
fi

# hub
if [ -f /data/software/ext/hub/hub ]; then
	alias git=hub
fi

# Don’t clear the screen after quitting a manual page
export MANPAGER="less -X"

# Larger bash history (allow 32³ entries; default is 500)
export HISTSIZE=32768
export HISTFILESIZE=$HISTSIZE

# timestamps for bash history. www.debian-administration.org/users/rossen/weblog/1
HISTTIMEFORMAT='%F %T '
export HISTTIMEFORMAT

# save history after every command
# use 'history -r' to reload history
PROMPT_COMMAND="history -a ; $PROMPT_COMMAND" 



# Make Tab autocomplete regardless of filename case
bind 'set completion-ignore-case on'


# Show extra file information when completing, like `ls -F` does
bind 'set visible-stats on'


### cannot use an alias to inject the command line params
mci() {
	mvn clean install "$@" | h -i error success
}
### cannot use an alias to inject the command line params
mcis() {
	mvn clean install -DskipTests -Dmaven.test.skip  "$@" | h -i error success
}

# Color man pages
man() {
	env \
	    GROFF_NO_SGR=1 \
		LESS_TERMCAP_mb=$(printf "\e[1;31m") \
		LESS_TERMCAP_md=$(printf "\e[1;31m") \
		LESS_TERMCAP_me=$(printf "\e[0m") \
		LESS_TERMCAP_se=$(printf "\e[0m") \
		LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
		LESS_TERMCAP_ue=$(printf "\e[0m") \
		LESS_TERMCAP_us=$(printf "\e[1;32m") \
			man "$@"
}
#Colorize less search
less() {
	env \
		LESS_TERMCAP_so=$(printf "\e[1;31m") \
		LESS_TERMCAP_se=$(printf "\e[0m") \
			less -R "$@"
}

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

#  If  set, minor errors in the spelling of a directory component in a cd command will be corrected.  The errors checked for are transposed characters, a missing charac‐ ter, and one character too many.  If a correction is found, the corrected file name is printed, and the command proceeds.  This option is  only  used  by  interactive shells shopt -s cdspell
shopt -s cdspell

#If set, bash attempts to save all lines of a multiple-line command in the same history entry.  This allows easy re-editing of multi-line commands.
shopt -s cmdhist

function bashtips() {
# copyright 2007 - 2010 Christopher Bratusek
cat <<EOF
DIRECTORIES
-----------
~-          Previous working directory
pushd tmp   Push tmp && cd tmp
popd        Pop && cd
GLOBBING AND OUTPUT SUBSTITUTION
--------------------------------
ls a[b-dx]e Globs abe, ace, ade, axe
ls a{c,bl}e Globs ace, able
\$(ls)      \`ls\` (but nestable!)
HISTORY MANIPULATION
--------------------
!!        Last command
!?foo     Last command containing \`foo'
^foo^bar^ Last command containing \`foo', but substitute \`bar'
!!:0      Last command word
!!:^      Last command's first argument
!\$       Last command's last argument
!!:*      Last command's arguments
!!:x-y    Arguments x to y of last command
C-s       search forwards in history
C-r       search backwards in history
LINE EDITING
------------
ALT-d     kill to end of word
C-w     kill to beginning of word
C-k     kill to end of line
C-u     kill to beginning of line
ALT-r     revert all modifications to current line
C-]     search forwards in line
ALT-C-]   search backwards in line
C-t     transpose characters
ALT-t     transpose words
ALT-u     uppercase word
ALT-l     lowercase word
ALT-c     capitalize word
COMPLETION
----------
ALT-/     complete filename
ALT-~     complete user name
ALT-@     complete host name
ALT-\$    complete variable name
ALT-!     complete command name
ALT-^     complete history
EOF
}

if [ -f /data/repositories/github/apps/svn-color/svn-color.sh ]; then
	source /data/repositories/github/apps/svn-color/svn-color.sh 
fi

if [ -f /data/repositories/github/personal/hhighlight/h.sh ]; then
	source /data/repositories/github/personal/hhighlight/h.sh
fi

# used for truphone
export FUSE_HOME=/data/software/RedHat/FUSE/fuse_full/jboss-fuse-6.0.0.redhat-024

# usage: hr +
hr(){ yes -- ${@:-=} | tr -d $'\n' | head -c $COLUMNS ; } 

# Find a file with a pattern in name:  
function ff() { find . -type f -iname '*'"$*"'*' -ls ; }  


if [ -f ~/maven.completion.bash ]; then
	source ~/maven.completion.bash 
fi

###### docker
dockerbuild() {
	docker build -t "$1" . ;
}

# adding custom shortcuts to bash
# binds to ALT+W
bind '"\ew":"\C-e # macro"'
# copy current location and send return
bind '"\ec":"pwd | xclip -selection clipboard \C-j"'

 
