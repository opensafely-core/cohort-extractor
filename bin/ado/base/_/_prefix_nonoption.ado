*! version 1.0.0  03may2006
program _prefix_nonoption
	version 10
	syntax [anything] [,*]
	if `"`anything'"' == "" {
		syntax [, NONOPTION]
	}
	else if `"`options'"' != "" {
		gettoken badopt : options, bind
		gettoken badopt rest : badopt, parse("()") bind
		if strtrim(`"`rest'"') != "" {
			local badopt `"`:list retok badopt'()"'
		}
		di as err `"option `badopt' not allowed `anything'"'
		exit 198
	}
end
