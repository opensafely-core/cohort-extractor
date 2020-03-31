*! version 1.2.0  17apr2019
program _check_eformopt
	version 9
	syntax [anything(name=cmdname)] [, soptions eformopts(passthru) ]

	if "`cmdname'" == "" {
		_get_eformopts, `soptions' `eformopts'
		exit
	}
	if "`cmdname'" == "binreg" {
		Check4Binreg, soptions `eformopts'
		exit
	}
	if "`cmdname'" == "gsem" {
		if "`e(cmd2)'" != "" {
			local cmdname `e(cmd2)'
		}
	}
	if `:list sizeof cmdname' > 1 {
		gettoken cmdname ignored : cmdname
	}
	_get_eformopts, `soptions' `eformopts' allowed(__all__)
	local efopt `s(opt)'
	if !inlist("`efopt'", "", "eform") {
		local props : properties `cmdname'
		if !`:list efopt in props' {
			_get_eformopts, eformopts(`efopt')
		}
	}
end

program Check4Binreg, sclass
	syntax [, soptions eformopts(string asis)]
	local 0, `eformopts'

	local EFALL NOHR hr NOSHR shr or IRr RR RRR tr RD 
	if "`soptions'" != "" {
		syntax [, EForm1(passthru) EForm `EFALL' * ]
		local opts `"`options'"'
		local 0 , `eform1' `eform' ///
			`nohr' `hr' `noshr' `shr' `or' `irr' `rr' `rrr' ///
			`tr' `rd'
	}

	local allowed or rr rd hr
	foreach ef of local allowed {
		local efopts `efopts' ``ef''
	}
	local efopts : list uniq efopts
	syntax [, EForm1(string) EForm `allowed' ]

	foreach ef of local efopts {
		local eform `eform' ``ef''
	}
	if `: list sizeof eform' {
		opts_exclusive "`eform'"
		if `:length local eform1' {
			opts_exclusive "eform() `eform'"
		}
	}
	
	if `: list sizeof eform' {
		if ("`eform'"=="eform") local eform1 = "exp(b)"
	   else if ("`eform'"=="or") 	local eform1 = "Odds Ratio"
	   else if ("`eform'"=="hr") 	local eform1 = "HR"
	   else if ("`eform'"=="rr") 	local eform1 = "Risk Ratio"
	   else if ("`eform'"=="rd") 	local eform1 = "Risk Diff."
	}

	sreturn clear
	sreturn local options `"`opts'"'
	sreturn local opt `eform'
	sreturn local str `eform1'
	if `"`eform1'"' != "" {
		if ("`eform'"=="rd") {
			sreturn local eform coeftitle(`"`eform1'"')
		}
		else {
			sreturn local eform eform(`"`eform1'"')
		}
	}
	else	sreturn local eform ""
end
exit
