set __fish_git_prompt_show_informative_status

function fish_prompt --description 'Write out the prompt'
	set -l last_status $status

	# Just calculate this once, to save a few cycles when displaying the prompt
	if not set -q __fish_prompt_hostname
		set -g __fish_prompt_hostname (hostname|cut -d . -f 1)
	end

	set -l normal (set_color normal)

	# Hack; fish_config only copies the fish_prompt function (see #736)
	if not set -q -g __fish_classic_git_functions_defined
		set -g __fish_classic_git_functions_defined

		function __fish_repaint_user --on-variable fish_color_user --description "Event handler, repaint when fish_color_user changes"
			if status --is-interactive
				commandline -f repaint ^/dev/null
			end
		end
		
		function __fish_repaint_host --on-variable fish_color_host --description "Event handler, repaint when fish_color_host changes"
			if status --is-interactive
				commandline -f repaint ^/dev/null
			end
		end
		
		function __fish_repaint_status --on-variable fish_color_status --description "Event handler; repaint when fish_color_status changes"
			if status --is-interactive
				commandline -f repaint ^/dev/null
			end
		end

		function __fish_repaint_bind_mode --on-variable fish_key_bindings --description "Event handler; repaint when fish_key_bindings changes"
			if status --is-interactive
				commandline -f repaint ^/dev/null
			end
		end

		# initialize our new variables
		if not set -q __fish_classic_git_prompt_initialized
			set -qU fish_color_user; or set -U fish_color_user -o green
			set -qU fish_color_host; or set -U fish_color_host -o cyan
			set -qU fish_color_status; or set -U fish_color_status red
			set -U __fish_classic_git_prompt_initialized
		end
	end

	#set -l my_color_vcs magenta
	set -l my_color_vcs brblack

	switch $USER
	case root toor
		set suffix '#'
	case '*'
		set suffix '$'
	end

	set -l my_color_cwd $fish_color_cwd
	if ! test -w $PWD
		if set -q fish_color_cwd_root
			set my_color_cwd $fish_color_cwd_root
		end
	end

	set prompt_hostname "@"$__fish_prompt_hostname

	set -l prompt_status
	if test $last_status -ne 0
		#set prompt_status "[$last_status]"
		set fish_color_status red
	else
		set fish_color_status white
	end

	# Print prompt
	if set -q SSH_CONNECTION
		echo -n -s (set_color $fish_color_user) "$USER"
		echo -n -s (set_color $fish_color_host) "$prompt_hostname "
	end
	echo -n -s (set_color $my_color_cwd) (prompt_pwd) " "
	echo    -s (set_color $my_color_vcs) (__fish_vcs_prompt)
	echo -n -s (set_color $fish_color_status) $prompt_status "$suffix " (set_color normal)
	echo -n -s (set_color normal)
end
