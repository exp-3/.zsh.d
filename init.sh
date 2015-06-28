#!/bin/zsh

#################################################################
#ZSH Setting File
#This file is written using [http://blog.blueblack.net/item_204]
#Time-stamp: <2015-06-27 01:26:53 takaaki>
#################################################################

#----------------------------------------------------------------
# General Settings

## PATHの重複を防ぐ
typeset -U path PATH
## エディタをemacsに設定
export EDITOR=emacs24
## xwindowの時のみ日本語端末にする
if [ -n "$DISPLAY" ]; then
    export LANG=ja_JP.UTF-8
else
    export LANG=C
fi

## Emacsライクキーバインド設定
bindkey -e

## ビープを鳴らさない
setopt nobeep
## ディレクトリ名だけで cd
setopt auto_cd
## cd 時に自動で push
setopt auto_pushd
## 同じディレクトリを pushd しない
setopt pushd_ignore_dups
## コマンドのスペルを訂正する
setopt correct
## --prefix=/usr などの = 以降も補完
setopt magic_equal_subst
## プロンプト定義内で変数置換やコマンド置換を扱う
setopt prompt_subst
## バックグラウンドジョブの状態変化を逐次報告する
setopt notify
## =command を command のパス名に展開する
setopt equals
## 出力時8ビットを通して日本語の文字化けを直す
setopt print_eight_bit
## コアダンプサイズを制限
limit coredumpsize 102400
## 出力の文字列末尾に改行コードが無い場合でも表示
unsetopt promptcr
## 内部コマンド jobs の出力をデフォルトで jobs -l にする
setopt long_list_jobs
## サスペンド中のプロセスと同じコマンド名を実行した場合はリジューム
setopt auto_resume

#----------------------------------------------------------------
# Complement

## 補完機能の強化
autoload -U compinit
compinit
## 補完候補を一覧表示
setopt auto_list
## TAB で順に補完候補を切り替える
setopt auto_menu
## 補完時にできるだけ詰めて表示する
setopt list_packed
## 補完候補一覧でファイルの種別をマーク表示
setopt list_types
## Shift-Tabで補完候補を逆順する
bindkey "^[[Z" reverse-menu-complete
## 補完時に大文字小文字を区別しない
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
## 補完候補のカーソル選択を有効に
zstyle ':completion:*:default' menu select=1
## 補完候補の色づけ
eval `dircolors`
export ZLS_COLORS=$LS_COLORS
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
## カッコの対応などを自動的に補完
setopt auto_param_keys
## ディレクトリ名の補完で末尾の / を自動的に付加し、次の補完に備える
setopt auto_param_slash

#---------------------------------------------------------------
# Glob

## グロブ機能の拡張
setopt extended_glob
## ファイルグロブで大文字小文字を区別しない
unsetopt caseglob
## ファイル名の展開で辞書順ではなく数値的にソート
setopt numeric_glob_sort

#----------------------------------------------------------------
# History

## 履歴の保存先
HISTFILE=$HOME/.zsh_history
## メモリに展開する履歴の数
HISTSIZE=100000
## 保存する履歴の数
SAVEHIST=100000
## share command history data
setopt share_history
## 直前と同じコマンドをヒストリに追加しない
setopt hist_ignore_dups
## zsh の開始, 終了時刻をヒストリファイルに書き込む
setopt extended_history
## ヒストリを共有
setopt share_history
## ヒストリを呼び出してから実行する間に一旦編集
setopt hist_verify
## 余分なスペースを削除してヒストリに保存
setopt hist_reduce_blanks

# マッチしたコマンドのヒストリを表示できるようにする
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

#----------------------------------------------------------------------

# 右プロンプト
# %F{～}は色指定、%fでリセット
# "%1(v|%F{yellow}%1v%F{green} |)" の部分がVCS情報 (psvarの長さが1以上なら黄色で表示)
RPROMPT="%F{green}[%1(v|%F{yellow}%1v%F{green}|)]%f"
#gitブランチ名表示
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats '%c%u%b'
zstyle ':vcs_info:git:*' actionformats '%c%u%b|%a'

#カレントディレクトリ/コマンド記録
local _cmd=''
local _lastdir=''
preexec() {
  _cmd="$1"
  _lastdir="$PWD"
}
#git情報更新
update_vcs_info() {
  psvar=()
  LANG=en_US.UTF-8 vcs_info
  [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}
#カレントディレクトリ変更時/git関連コマンド実行時に情報更新
precmd() {
  _r=$?
  case "${_cmd}" in
    git*|stg*) update_vcs_info ;;
    *) [ "${_lastdir}" != "$PWD" ] && update_vcs_info ;;
  esac
  return $_r
}

#サブコマンド補完
compdef _hogecmd hoge
function _hogecmd {
  local -a cmds
  if (( CURRENT == 2 ));then
    cmds=('init' 'update' 'upgrade' 'commit')
    _describe -t commands "subcommand" cmds
  else
    _files
  fi

  return 1;
}



export PATH=/opt/local/bin:/opt/local/sbin:/usr/local/bin:$PATH
export MANPATH=$MANPATH:/opt/local/share/man
export LSCOLORS=gxfxxxxxcxxxxxxxxxxxxx

##############################################
#ZSH Color Setting File
#This file is written using [http://ho-ki-boshi.blogspot.com/2007/12/zsh.html]
#############################################
local LEFTC=$'%{\e[255;255;0m%}'
local RIGHTC=$'%{\e[38;5;255m%}'
local DEFAULTC=$'%{\e[m%}'
autoload colors
colors
export PROMPT="%{${fg[green]}%}%~%{${reset_color}%}
%{${fg[blue]}%}[%n@${HOST}]$%{${reset_color}%} "

export PROMPT2="%{${fg[blue]}%}[%n]%{${reset_color}%}>"
#export PROMPT='%{${fg[blue]}%}[%n@%m] %(!.#.$) %{${reset_color}%}[\n]'
#export PROMPT="%U$USER%%%u "$DEFAULTC
#export PROMPT=$RIGHTC"[%~]"$DEFAULTC
#local GREEN=$'%{\e[1;32m%}'
#local YELLOW=$'{\e[1;33m%}'
#local BLUE=$'%{\e[1;34m%}'
#local DEFAULT=$'%{\e[1;m}'
#PROMPT=$'\n'$GREEEN'${USER}@${HOSTNAME} '$YELLOW' %~ '$'\n'$DEFAULT'%(!.#.$) '
#色の設定

#This is for start-up settings
#and can be modified by others.

#this function execute ls after cd.
cdls ()
{
    \cd "$@" && ls --color -B
}

alias minicom="LANG=C minicom"
alias ls="ls --color -B"
alias emacs="emacsclient -cqa ''"
alias e="emacsclient -cqa ''"
alias l="ls"
alias v="vim"
alias c="cat"
alias less="less -R"
alias offpower="sudo shutdown -h 0"
alias lanrecovery="sudo rfkill unblock all"
alias nautilus="nemo"
alias ea="eagle"
alias qwer="pkill firefox"
alias ks="ls"
alias sls="ls"
alias lsl="ls"
alias la="=ls --color -a"
alias ll="ls -lc"
alias lla="=ls --color -alc"
alias mozc-dict="/usr/lib/mozc/mozc_tool --mode=dictionary_tool"
alias g++="g++ -std=c++14 -Wall -Wextra -Wconversion"
alias clang="clang-3.5 -std=c++14 -Wall -Wextra -Wconversion"
alias clang++="clang++-3.5 -std=c++14 -Wall -Wextra -Wconversion"
alias sl="$HOME/Workspace/temp/test.sh"
alias cd="cdls"
alias du="du -ah --max-depth=1"

alias -s pdf="evince"
alias -s {sch,brd}="eagle"
alias -s rb="ruby"
alias -s py="python"
alias -s png="eog"
alias -s jpg="eog"
alias -s jpeg="eog"
alias -s html="firefox"
#For GTK+ Programming
