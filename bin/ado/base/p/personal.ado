*! version 1.0.1  31jul2007
program define personal
	version 7
	local p : sysdir PERSONAL

        if "$S_OS"=="Windows" { 
		local p : subinstr local p "/" "\", all
	}

	di as txt `"your personal ado-directory is {res}`p'"'
	if `"`1'"'=="dir" | `"`1'"'=="ls" {	
		if strpos(`"`p'"', " ") != 0 {
			// has space... must be quoted
			local home : env HOME
			if strpos(`"`p'"', "~") == 1  & `"`home'"' != "" {
				// quoted ~ is not allowed
				local p : subinstr local p "~" "`home'"
			}
			dir `"`p'"', wide
		}
		else {
			dir `p', wide
		}
	}
	else	di as txt "(type -personal dir- to see its contents)"
end
