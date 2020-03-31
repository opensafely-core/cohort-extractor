*! version 1.0.2  18feb2011
program _on_colon_parse, sclass
	version 8.2

	sreturn local before ""
	sreturn local after ""

	// put ": <command>" in `after'
	gettoken before after : 0, parse(":") bind match(par) quotes
	if "`par'" != "" {
		local before `"(`before')"'
	}

	// handle special case when nothing is before ":"
	if `"`before'"' == ":" {
		sreturn local after `"`after'"'
		exit
	}

	while `"`COLON'"' != ":" & `"`after'"' != "" {
		// check for syntax errors
		gettoken COLON after : after, parse(":") bind match(par) quotes
		if "`par'" != "" {
			local before `before' (`COLON')
			local COLON
		}
		else if `"`COLON'"' != ":" {
			local before `"`before' `COLON'"'
			local COLON
		}
	}
	if `"`COLON'"' != ":" {
		di as err "'' found where ':' expected"
		exit 198
	}

	// return parsed pieces
	sreturn local before `"`before'"'
	sreturn local after `"`after'"'
end
exit
