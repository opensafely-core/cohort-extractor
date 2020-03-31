*! version 1.0.1  16feb2007
program find_hlp_file, rclass
	args name

	capture which `name'.sthlp
	if c(rc)==0 {
		return local result "`name'"
		exit
	}
	capture which `name'.hlp
	if c(rc)==0 {
		return local result "`name'"
		exit
	}
	capture _findhlpalias `name'
	if c(rc)==0 {
		local alias "`r(name)'"
		capture which `alias'.sthlp
		if c(rc)==0 {
			return local result "`alias'"
			exit
		}
		capture which `alias'.hlp
		if c(rc)==0 {
			return local result "`alias'"
			exit
		}
	}
	display as err "help for `name' not found"
	exit 111
end
