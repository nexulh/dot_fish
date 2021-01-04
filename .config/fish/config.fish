if status --is-interactive
	if ! set -q SSH_CONNECTION
		tmux ^ /dev/null; and exec true
	end

	if which keychain >/dev/null
		keychain --eval --quiet -Q --agents ssh id_rsa | source
	end

	set BASE16_SHELL "$HOME/.config/base16-shell/"
	source "$BASE16_SHELL/profile_helper.fish"
else
	if test -f ~/.keychain/$HOSTNAME-fish
		source ~/.keychain/$HOSTNAME-fish
	end
end


set -g fish_prompt_pwd_dir_length 0
set -l HOSTNAME (hostname)
set fish_greeting


#fish_vi_key_bindings
#bind -M insert \ek history-search-backward
#bind -M insert \ej history-search-forward
#bind -M insert \el accept-autosuggestion
fish_default_key_bindings
bind \ek history-search-backward
bind \ej history-search-forward
bind \el accept-autosuggestion


# Abbreviations and functions
abbr cls 'clear'
abbr ls 'exa'
abbr v 'exa -l'
abbr va 'exa -l -a'
abbr st 'stterm'
abbr i 'sxiv'
abbr o 'xdg-open'
abbr fm 'pcmanfm'

function dfh
	df -h $argv |grep --color=never -E "Filesystem|dev/(mapper|sd)"
end

set GOPATH "$HOME/go"

set -e tmp_user_paths
for tmp_new_path in $HOME/bin $HOME/go/bin $HOME/opt/bin /snap/bin /opt/bin /usr/local/bin /sbin /usr/sbin
	set -a tmp_user_paths $tmp_new_path
end
set fish_user_paths $tmp_user_paths
set -e tmp_user_paths


switch $TERM
	case 'stterm-*' # suckless' simple terminal
		# Enable keypad, do it once before fish_postexec ever fires
		tput smkx
		function st_smkx --on-event fish_postexec
			tput smkx
		end
		function st_rmkx --on-event fish_preexec
			tput rmkx
		end
end

set VISUAL vim
set EDITOR $VISUAL
set GIT_EDITOR $VISUAL


# colored man output
# from http://linuxtidbits.wordpress.com/2009/03/23/less-colors-for-man-pages/
setenv LESS_TERMCAP_mb \e'[01;31m'       # begin blinking
setenv LESS_TERMCAP_md \e'[01;38;5;74m'  # begin bold
setenv LESS_TERMCAP_me \e'[0m'           # end mode
setenv LESS_TERMCAP_se \e'[0m'           # end standout-mode
setenv LESS_TERMCAP_so \e'[38;5;246m'    # begin standout-mode - info box
setenv LESS_TERMCAP_ue \e'[0m'           # end underline
setenv LESS_TERMCAP_us \e'[04;38;5;146m' # begin underline


