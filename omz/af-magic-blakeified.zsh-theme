# af-magic.zsh-theme
#
# Author: Andy Fleming
# URL: http://andyfleming.com/
# 
# Edited by blake to fit the gruvbox color theme

# GRUVBOX COLORS IN ANSI:
dark_aqua=%{$(echo -e "\e[38;2;104;157;106m")%}
light_aqua=%{$(echo -e '\e[38;2;142;192;124m')%}
yellow=%{$(echo -e '\e[38;2;215;153;33m')%}

# dashed separator size
function afmagic_dashes {
  # check either virtualenv or condaenv variables
  local python_env_dir="${VIRTUAL_ENV:-$CONDA_DEFAULT_ENV}"
  local python_env="${python_env_dir##*/}"

  # if there is a python virtual environment and it is displayed in
  # the prompt, account for it when returning the number of dashes
  if [[ -n "$python_env" && "$PS1" = *\(${python_env}\)* ]]; then
    echo $(( COLUMNS - ${#python_env} - 3 ))
  elif [[ -n "$VIRTUAL_ENV_PROMPT" && "$PS1" = *${VIRTUAL_ENV_PROMPT}* ]]; then
    echo $(( COLUMNS - ${#VIRTUAL_ENV_PROMPT} - 3 ))
  else
    echo $COLUMNS
  fi
}

# primary prompt: dashed separator, directory and vcs info
PS1="${FG[237]}\${(l.\$(afmagic_dashes)..-.)}%{$reset_color%}
${dark_aqua}%~\$(git_prompt_info)\$(hg_prompt_info) ${light_aqua}%(!.#.λ)%{$reset_color%} "
PS2="%{$fg[red]%}\ %{$reset_color%}"

# right prompt: return code, virtualenv and context (user@host)
RPS1="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"
if (( $+functions[virtualenv_prompt_info] )); then
  RPS1+='$(virtualenv_prompt_info)'
fi
RPS1+=" ${FG[237]}%n@%m%{$reset_color%}"

# git settings
ZSH_THEME_GIT_PROMPT_PREFIX=" ${dark_aqua}(${light_aqua}"
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_DIRTY="${yellow}*%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="${dark_aqua})%{$reset_color%}"

# Truncate long git branch names in the prompt
function git_prompt_info() {
  local ref
  ref=$(git_current_branch)
  if [[ -n "$ref" ]]; then
    local max=10
    local display="$ref"
    if (( ${#display} > max )); then
      display="${display[1,$max]}…"
    fi
    echo "${ZSH_THEME_GIT_PROMPT_PREFIX}${display}$(parse_git_dirty)${ZSH_THEME_GIT_PROMPT_SUFFIX}"
  fi
}

# hg settings
ZSH_THEME_HG_PROMPT_PREFIX=" ${FG[075]}(${FG[078]}"
ZSH_THEME_HG_PROMPT_CLEAN=""
ZSH_THEME_HG_PROMPT_DIRTY="${FG[214]}*%{$reset_color%}"
ZSH_THEME_HG_PROMPT_SUFFIX="${FG[075]})%{$reset_color%}"

# virtualenv settings
ZSH_THEME_VIRTUALENV_PREFIX=" ${FG[075]}["
ZSH_THEME_VIRTUALENV_SUFFIX="]%{$reset_color%}"
