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
alias docker_ps='docker ps --format "table {{.ID}}\t{{.Image}}\t{{.Ports}}"'
alias dc="bash <(curl -s https://raw.githubusercontent.com/david986912425/script-bash/main/docker_connect.sh)"
alias lh='eza -lh'
alias ~='cd ~'

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



##function
cbf() {
    # Obtener los archivos modificados o añadidos de git (M: Modificados, A: Añadidos)
    modified_files=$(git status --porcelain | grep -E '^( M|A)' | awk '{print $2}')

    # Verificar si hay archivos modificados o añadidos
    if [ -z "$modified_files" ]; then
        echo "No hay archivos modificados o añadidos para procesar."
        return 0
    fi

    # Ejecutar phpcbf para los archivos modificados o añadidos
    echo "Ejecutando phpcbf en los siguientes archivos:"
    echo "$modified_files"

    # Aplicar phpcbf a cada archivo encontrado
    ./vendor/bin/phpcbf --standard=phpcs.xml $modified_files
}

size_top() {
    sudo du -sm * | sort -nr | head -5
}

bk_db() {
    local CURRENT_DATE=$(date +%F)

    # Nombre del archivo de backup sin extensión
    local BACKUP_FILE="/home/david/idbi/bk/${CURRENT_DATE}_id_pos.sql"

    # Crear el backup
    docker exec -i a2119a4874b8 mysqldump -u root -p4oYwDkVNXv9cQlzEZ86b id_pos > "$BACKUP_FILE"

    # Comprimir el archivo de backup
    gzip "$BACKUP_FILE"

    echo "Backup y compresión completados: ${BACKUP_FILE}.gz"
}

vpn() {
    cd ~/vpn || { echo "No se puede cambiar al directorio"; exit 1; }

    # Listar los archivos .ovpn
    archivos=( *.ovpn )

    # Verificar si hay archivos .ovpn en el directorio
    if [ ${#archivos[@]} -eq 0 ]; then
        echo "No se encontraron archivos .ovpn en el directorio."
        exit 1
    fi

    # Permitir al usuario seleccionar un archivo usando fzf
    archivo=$(printf '%s\n' "${archivos[@]}" | fzf --height 1% --border)

    # Verificar si se ha seleccionado un archivo
    if [ -n "$archivo" ]; then
        echo "Conectando a la VPN usando el archivo: $archivo"
        sudo openvpn "$archivo"
    else
        echo "Selección no válida o ningún archivo seleccionado."
        exit 1
    fi
}
