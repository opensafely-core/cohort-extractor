*! version 1.0.0  10mar2015
program _mcmc_parse_comma, sclass
	version 14.0

	local lhs
	local rhs `0'
	local next
	while `"`next'"' != "," & `"`rhs'"' != "" {
		if bsubstr(`"`rhs'"', 1, 1) == " " {
			local lhs = `"`lhs' "'
		}
		gettoken next rhs: rhs, parse("\ ,{}") bind
		if `"`next'"' == "," {
			continue
		}
		if `"`next'"' == "{" {
			gettoken next rhs: rhs, parse("{}") bind
			if `"`next'"' == "}" {
				di as error `"{} not allowed"'
				exit 198
			}
			local lhs = `"`lhs'{`next'"'
			gettoken next rhs: rhs, parse("{}") bind
			if `"`next'"' != "}" {
			
			di as error `"{bf:`next'} found where } expected"'
			exit 198
			
			}
			local lhs = `"`lhs'}"'
		}
		else local lhs = `"`lhs'`next'"'
	}
	local lhs `lhs'
	local rhs `rhs'
	sreturn clear
	sreturn local lhs = `"`lhs'"'
	sreturn local rhs = `"`rhs'"'
end
