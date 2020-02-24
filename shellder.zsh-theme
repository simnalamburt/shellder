# vim:ft=zsh ts=2 sw=2 sts=2

#
# Segment drawing
#
CURRENT_BG='NONE'

#
# color scheme
#
SHELLDER_CONTEXT_BG=${SHELLDER_CONTEXT_BG:-238}
SHELLDER_CONTEXT_FG=${SHELLDER_CONTEXT_FG:-250}

SHELLDER_DIRECTORY_BG=${SHELLDER_DIRECTORY_BG:-234}
SHELLDER_DIRECTORY_FG=${SHELLDER_DIRECTORY_FG:-231}

SHELLDER_GIT_CLEAN_BG=${SHELLDER_GIT_CLEAN_BG:-034}
SHELLDER_GIT_CLEAN_FG=${SHELLDER_GIT_CLEAN_FG:-'black'}

SHELLDER_GIT_UNTRACKED_BG=${SHELLDER_GIT_UNTRACKED_BG:-226}
SHELLDER_GIT_UNTRACKED_FG=${SHELLDER_GIT_UNTRACKED_FG:-'black'}

SHELLDER_GIT_UNPUSHED_BG=${SHELLDER_GIT_UNPUSHED_BG:-48}
SHELLDER_GIT_UNPUSHED_FG=${SHELLDER_GIT_UNPUSHED_FG:-'black'}

SHELLDER_GIT_MODIFIED_BG=${SHELLDER_GIT_MODIFIED_BG:-172}
SHELLDER_GIT_MODIFIED_FG=${SHELLDER_GIT_MODIFIED_FG:-'black'}

SHELLDER_GIT_STAGED_BG=${SHELLDER_GIT_STAGED_BG:-166}
SHELLDER_GIT_STAGED_FG=${SHELLDER_GIT_STAGED_FG:-'black'}

SHELLDER_GIT_ADDED_BG=${SHELLDER_GIT_ADDED_BG:-218}
SHELLDER_GIT_ADDED_FG=${SHELLDER_GIT_ADDED_FG:-'black'}

SHELLDER_VIRTUALENV_BG=${SHELLDER_VIRTUALENV_BG:-017}
SHELLDER_VIRTUALENV_FG=${SHELLDER_VIRTUALENV_FG:-189}

SHELLDER_STATUS_BG=${SHELLDER_STATUS_BG:-236}
SHELLDER_STATUS_FG=${SHELLDER_STATUS_FG:-'default'}

# Special Powerline characters
set_separator() {
  local LC_ALL='' LC_CTYPE='en_US.UTF-8'
  SEGMENT_SEPARATOR=$'\ue0b0'
}
set_separator

# Begin a segment
# Takes two arguments, background and foreground. Both can be omitted,
# rendering default background/foreground.
prompt_segment() {
  local bg fg
  [[ -n $1 ]] && bg="%K{$1}" || bg='%k'
  [[ -n $2 ]] && fg="%F{$2}" || fg='%f'
  if [[ "$CURRENT_BG" != 'NONE' && $1 != "$CURRENT_BG" ]]; then
    echo -n " %{$bg%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR%{$fg%} "
  else
    echo -n "%{$bg%}%{$fg%} "
  fi
  CURRENT_BG=$1
  [[ -n $3 ]] && echo -n "$3"
}

# End the prompt, closing any open segments
prompt_end() {
  if [[ -n "$CURRENT_BG" ]]; then
    echo -n " %{%k%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR"
  else
    echo -n '%{%k%}'
  fi
  echo -n '%{%f%}'
  CURRENT_BG=''
}


#
# Prompt functions
#

# Context: user@hostname (who am I and where am I)
prompt_context() {
  local prompt
  if [[ -n "$SSH_CLIENT" ]]; then
    if [[ "$USER" != "$DEFAULT_USER" ]]; then
      prompt="%(!.%{%F{yellow}%}.)$USER@%m"
    else
      prompt='%(!.%{%F{yellow}%}.)%m'
    fi
    prompt_segment "$SHELLDER_CONTEXT_BG" "$SHELLDER_CONTEXT_FG" "$prompt"
  fi
}

# Git: branch/detached head, dirty status
prompt_git() {
  local repo_path
  local GIT_STATUS

  repo_path=$(git rev-parse --git-dir 2>/dev/null)

  if [[ -n $repo_path ]]; then
    local PL_BRANCH_CHAR dirty bgcolor fgcolor mode ref

    set_branch_char() {
      local LC_ALL='' LC_CTYPE='en_US.UTF-8'
      PL_BRANCH_CHAR=$'\ue0a0' # 
    }
    set_branch_char

    GIT_STATUS=$(
      command git status --porcelain --ignore-submodules=dirty 2>/dev/null |
        sed -e 's/^ //g'
    )
    modified=$(<<< "$GIT_STATUS" grep '^M')
    untracked=$(<<< "$GIT_STATUS" grep '^?')
    added=$(<<< "$GIT_STATUS" grep '^A')
    staged=$(git diff --name-only --cached)
    unpushed=$(command git cherry 2>/dev/null)

    if [[ -n $added ]]; then
      bgcolor=$SHELLDER_GIT_ADDED_BG
      fgcolor=$SHELLDER_GIT_ADDED_FG
    elif [[ -n $staged ]]; then
      bgcolor=$SHELLDER_GIT_STAGED_BG
      fgcolor=$SHELLDER_GIT_STAGED_FG
    elif [[ -n $modified ]]; then
      bgcolor=$SHELLDER_GIT_MODIFIED_BG
      fgcolor=$SHELLDER_GIT_MODIFIED_FG
    elif [[ -n $untracked ]]; then
      bgcolor=$SHELLDER_GIT_UNTRACKED_BG
      fgcolor=$SHELLDER_GIT_UNTRACKED_FG
    elif [[ -n $unpushed ]]; then
      bgcolor=$SHELLDER_GIT_UNPUSHED_BG
      fgcolor=$SHELLDER_GIT_UNPUSHED_FG
    else
      bgcolor=$SHELLDER_GIT_CLEAN_BG
      fgcolor=$SHELLDER_GIT_CLEAN_FG
    fi
    prompt_segment "$bgcolor" "$fgcolor"

    if [[ -e "${repo_path}/BISECT_LOG" ]]; then
      mode=' <B>'
    elif [[ -e "${repo_path}/MERGE_HEAD" ]]; then
      mode=' >M<'
    elif [[ -e "${repo_path}/rebase" || -e "${repo_path}/rebase-apply" || -e "${repo_path}/rebase-merge" || -e "${repo_path}/../.dotest" ]]; then
      mode=' >R>'
    fi

    # vcs_info is too slow with MSYS2 (~300ms with i7-6770K + SSD)
    if [[ -z $MSYS ]]; then
      autoload -Uz vcs_info
      zstyle ':vcs_info:*' enable git
      zstyle ':vcs_info:*' check-for-changes true
      zstyle ':vcs_info:*' stagedstr '✚'
      zstyle ':vcs_info:*' unstagedstr '●'
      zstyle ':vcs_info:*' formats ' %u%c'
      zstyle ':vcs_info:*' actionformats ' %u%c'
      vcs_info
    else
      if [[ -n $dirty ]]; then
        vcs_info_msg_0_=' !'
      fi
    fi

    ref=$(git symbolic-ref HEAD 2> /dev/null) || ref="➦ $(git rev-parse --short HEAD 2> /dev/null)"
    echo -n "${ref/refs\/heads\//$PL_BRANCH_CHAR }${vcs_info_msg_0_%% }${mode}"
  fi
}

prompt_hg() {
  local rev
  if hg id >/dev/null 2>&1; then
    if hg prompt >/dev/null 2>&1; then
      if [[ $(hg prompt '{status|unknown}') = '?' ]]; then
        # if files are not added
        prompt_segment red white
        st='±'
      elif [[ -n $(hg prompt '{status|modified}') ]]; then
        # if any modification
        prompt_segment yellow black
        st='±'
      else
        # if working copy is clean
        prompt_segment green black
      fi
      echo -n "$(hg prompt '☿ {rev}@{branch}')" "$st"
    else
      st=''
      rev=$(hg id -n 2>/dev/null | sed 's/[^-0-9]//g')
      branch=$(hg id -b 2>/dev/null)
      if hg st | grep -q "^\?"; then
        prompt_segment red black
        st='±'
      elif hg st | grep -q '^[MA]'; then
        prompt_segment yellow black
        st='±'
      else
        prompt_segment green black
      fi
      echo -n "☿ $rev@$branch" $st
    fi
  fi
}

# Turn '/some/quite/very/long/path' into '/s/q/v/l/path'
function shrinked_path() {
  local paths=(${PWD/$HOME/\~}) 'cur_dir'
  paths=(${(s:/:)paths})
  for idx in {1..$#paths}; do
    if [[ idx -lt $#paths ]]; then
      cur_dir+="${paths[idx]:0:1}"
    else
      cur_dir+="${paths[idx]}"
    fi
    cur_dir+='/'
  done
  echo "${cur_dir: :-1}"
}

# Dir: current working directory
prompt_dir() {
  local dir
  if [[ -n $SHELLDER_KEEP_PATH ]]; then
    dir='%~'
  else
    dir=$(shrinked_path)
  fi
  prompt_segment "$SHELLDER_DIRECTORY_BG" "$SHELLDER_DIRECTORY_FG" "$dir"
}

# Virtualenv: current working virtualenv
prompt_virtualenv() {
  local virtualenv_path="$VIRTUAL_ENV"
  if [[ -n $virtualenv_path && -n $VIRTUAL_ENV_DISABLE_PROMPT ]]; then
    prompt_segment "$SHELLDER_VIRTUALENV_BG" "$SHELLDER_VIRTUALENV_FG" "$(basename "$virtualenv_path")"
  fi
}

# Status: error + root + background jobs
prompt_status() {
  local symbols
  symbols=()
  [[ $RETVAL -ne 0 ]] && symbols+="%{%F{yellow}%}$RETVAL"
  [[ $UID -eq 0 ]] && symbols+='%{%F{yellow}%}⚡'
  [[ $(jobs -l | wc -l) -gt 0 ]] && symbols+='%{%F{cyan}%}⚙'

  [[ -n "$symbols" ]] && prompt_segment "$SHELLDER_STATUS_BG" "$SHELLDER_STATUS_FG" "$symbols"
}


#
# Prompt
#
build_prompt() {
  RETVAL=$?
  prompt_status
  prompt_virtualenv
  prompt_context
  prompt_dir
  prompt_git
  prompt_hg
  prompt_end
}

export VIRTUAL_ENV_DISABLE_PROMPT='true'
PROMPT='%{%f%b%k%}$(build_prompt) '
