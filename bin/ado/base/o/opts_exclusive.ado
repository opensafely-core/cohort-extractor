*! version 1.0.4  15oct2013
program opts_exclusive
	version 8.2

	args opts optname errcode

	local opts `opts'	// to trim leading and trailing spaces

	local n 0
	while `"`opts'"' != "" {
		local ++n
		gettoken item`n' opts : opts, bind
	}

	if `n' < 2 { // no error message or return code 
		exit
	}

	di in smcl as err "{p}"
	if `"`optname'"' ~= "" {
		di in smcl as err `"option {bf:`optname'()} invalid;{break}"'
	}
	di in smcl as err "only one of"
	if `n' == 2 {
		di in smcl as err `"{bf:`item1'} or {bf:`item2'}"'
	}
	else {
		forvalues i=1/`=`n'-1' {
			di in smcl as err `"{bf:`item`i''},"'
		}
		di in smcl as err `"or {bf:`item`n''}"'
	}
	di in smcl as err "is allowed{p_end}"

	if `"`errcode'"' != "" {
		exit `errcode'
	}
	else {
		exit 198
	}
end
exit
	opts_exclusive:
	display error message and exit for mutually exclusive options

	-opts_exclusive "a b c"- exits with r(198) and displays:
	only one of a, b, or c is allowed

	-opts_exclusive "a b c" xyz- exits with r(198) and displays:
	option xyz() invalid; only one of a, b, or c is allowed

        -opts_exclusive "a b" "" 99- exits with r(99) and displays:
        only one of a or b is allowed

