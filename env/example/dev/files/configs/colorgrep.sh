# color-grep initialization

cologrep() {

    # /usr/libexec/grepconf.sh -c || return

    alias grep='grep --color=auto' 2>/dev/null
    alias egrep='egrep --color=auto' 2>/dev/null
    alias fgrep='fgrep --color=auto' 2>/dev/null
}

colorxzgrep() {
    # /usr/libexec/grepconf.sh -c || return
    alias xzgrep='xzgrep --color=auto' 2>/dev/null
    alias xzegrep='xzegrep --color=auto' 2>/dev/null
    alias xzfgrep='xzfgrep --color=auto' 2>/dev/null
}

colorzgrep() {
    [ -f /usr/libexec/grepconf.sh ] || return

    # /usr/libexec/grepconf.sh -c || return
    alias zgrep='zgrep --color=auto' 2>/dev/null
    alias zfgrep='zfgrep --color=auto' 2>/dev/null
    alias zegrep='zegrep --color=auto' 2>/dev/null
}

cologrep
colorxzgrep
colorzgrep