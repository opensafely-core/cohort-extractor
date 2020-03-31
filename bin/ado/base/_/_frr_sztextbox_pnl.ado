*! version 1.0.2  20jun2011

// Parses all occurrences of the specified option as changes to a sized_textbox
// and logs the changes to the specified log.

program _frr_sztextbox_pnl , rclass
	gettoken log   0 : 0
	gettoken tbox  0 : 0
	gettoken optnm 0 : 0 , parse(" ,")

	local opt = lower("`optnm'")

	syntax [ , `optnm'(string asis) * ]

	while `"``opt''"' != `""' {
		_fr_sztextbox_parse_and_log `log' `tbox' , ``opt''
		ChkNone , `r(rest)'

		local 0 `", `options'"'
		syntax [ , `optnm'(string asis) * ]
	}

	return local rest `options'

end

program ChkNone
	syntax [, FAKE_OPT_FOR_BETTER_MSG ]
end
