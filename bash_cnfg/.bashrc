# .bashrc
# Run screenFetch (https://github.com/KittyKatt/screenFetch)
if [ -f /usr/bin/screenfetch ]; then screenfetch; fi
# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi
###############################
#	Aliases
###############################
alias ..='cd ..'
alias ...='cd ../../'
alias ....='cd ../../../'
alias du='du -cha'
alias df='df -H'
alias c='clear'
alias ls='ls --color=auto'
alias ll='ls -la'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias egreps='egrep --color=auto -v "^$|^#"'
alias mkdir='mkdir -pv'
alias h="history | grep --color=auto"
alias j='jobs -l'
alias now='date +"%T"'
alias nowtime=now
alias nowdate='date +"%d-%m-%Y"'
#Network
alias port='netstat -tulap'
alias tcpdump='tcpdump -i eth0'
#alias vnstat='vnstat -i eth0'
#alias dnstop='dnstop -l 5  eth0'
#alias iftop='iftop -i eth0'
#alias ethtool='ethtool eth0'

alias meminfo='free -m -l -t'
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 3 | head -10'
alias pscpu='ps auxf | sort -nr -k 3'
alias pscpu10='ps auxf | sort -nr -k 3 | head -10'
alias cpuinfo='lscpu'
alias df='df -H'
alias du='du -ch'
alias rm='rm -I --preserve-root'
alias mv='mv -i'
alias cp='cp -i'
alias ln='ln -i'
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'
alias root='sudo -i'
#alias listen='lsof -P -i -n'
alias pss='ps aux | grep'
#alias ips="ip addr | grep inet | awk '{ print $2; }' | sed 's/\/.*$//'"
alias mount='mount |column -t'

# get web server headers #
alias header='curl -I'
 
# find out if remote server supports gzip / mod_deflate or not #
alias headerc='curl -I --compress'

#continue download
alias wget='wget -c'

# reboot / halt / poweroff
alias reboot='/sbin/reboot'
alias poweroff='/sbin/poweroff'
alias halt='/sbin/halt'
alias shutdown='/sbin/shutdown'
########################################################
# Function
########################################################
backup() { cp "$1"{,.bak};}
extract() { 
    if [ -f $1 ] ; then 
      case $1 in 
        *.tar.bz2)   tar xjf $1     ;; 
        *.tar.gz)    tar xzf $1     ;; 
        *.bz2)       bunzip2 $1     ;; 
        *.rar)       unrar e $1     ;; 
        *.gz)        gunzip $1      ;; 
        *.tar)       tar xf $1      ;; 
        *.tbz2)      tar xjf $1     ;; 
        *.tgz)       tar xzf $1     ;; 
        *.zip)       unzip $1       ;; 
        *.Z)         uncompress $1  ;; 
        *.7z)        7z x $1        ;; 
        *)     echo "'$1' cannot be extracted via extract()" ;; 
         esac 
     else 
         echo "'$1' is not a valid file" 
     fi 
} 
sbs() { du -b --max-depth 1 | sort -nr | perl -pe 's{([0-9]+)}{sprintf "%.1f%s", $1>=2**30? ($1/2**30, "G"): $1>=2**20? ($1/2**20, "M"): $1>=2**10? ($1/2**10, "K"): ($1, "")}e';} 


# User specific aliases and functions
