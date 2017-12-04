function module --argument-names subcmd
	function bash2fish
	    python ~/.config/fish/bash2fish.py
	end
        
	switch $subcmd
		case load
			eval (modulecmd bash load $argv[2] | bash2fish )
		case unload
			eval (modulecmd bash unload $argv[2] | bash2fish )
		case switch
                       eval (modulecmd bash switch $argv[2] | bash2fish )
		case '*'
			modulecmd bash $subcmd
	end

end
