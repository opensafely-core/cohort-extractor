*! version 1.0.2  19oct2002
program _check4gropts
	version 8.0

	syntax anything(name=opn id="option name") [, OPTs(string asis) ]
	local 0 , `opts'

	local exclude name SAVing
	foreach opt of local exclude {
		local syntax `"`syntax' `opt'(passthru)"'
		local synlist `synlist' `=lower("`opt'")'
	}
	syntax [, by(passthru) `syntax' * ]
	if `"`by'"' != "" {
		di as err `"option `opn'() does not allow the by() option"'
		exit 191
	}
	foreach opt of local synlist {
		if `"``opt''"' != "" {
			di as err ///
			`"option `opn'() does not allow the `opt'() option"'
			exit 198
		}
	}
end

exit

