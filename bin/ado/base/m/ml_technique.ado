*! version 1.2.0  27sep2006
program ml_technique, sclass
	version 8.0
	// parse the -technique()- and -vce()- options of -ml-
	syntax [,				///
		TECHnique(string)		///
		VCE(passthru)			///
		noDEFault			///
	]

	sreturn clear

	// saved results:
	//   s(vce)
	//   s(vceargs)
	//   s(vceopt)
	_vce_parse, argopt(CLuster) opt(Hessian OIM Opg NATIVE Robust) ///
		:, `vce'
	sreturn local vce	`"`r(vce)'"'
	sreturn local vceargs	`"`r(vceargs)'"'
	sreturn local vceopt	`"`r(vceopt)'"'
	if "`s(vce)'" == "hessian" {
		sreturn local vce	"oim"
		sreturn local vceopt	"vce(oim)"
	}
	if "$ML_vce" == "robust" & !inlist("`s(vce)'", "", "oim", "robust") {
		di as err "options robust and vce(`s(vce)') may not be combined"
		exit 198
	}

	// saved results:
	//   s(techlist)
	//   s(numlist)
	//   s(technique)
	get_technique `technique', `default'
end

// Syntax:
//   get_technique [ tname [#] ]...
//
// NOTE: The default value of # is 5.
// NOTE: The order of the arguments is preserved on purpose.
//
// Saved results:
//
//   s(techlist)   list of <tname>s in order given
//   s(numlist)    list of #s in order given, with default #s
//   s(technique)  retokenized arguments, with default #s
//
program get_technique, sclass
	syntax [anything(equalok)] [, noDEFault ]
	local 0 `"`anything'"'

	if "`default'" == "" {
		local default_num 5
	}
	else	local default_num 0
	gettoken tname rest : 0, parse(" =")
	while "`tname'" != "" {
		local tname = lower(`"`tname'"')
		capture confirm name `tname'
		if _rc {
			local rc = _rc
			di as err ///
			"`tname' is an invalid name in technique() option"
			exit `rc'
		}
		get_tech tech , `tname'
		gettoken num : rest, parse(" =")
		if "`num'" == "=" {
			// remove optional "=", UNDOCUMENTED
			gettoken num rest : rest, parse(" =")
			gettoken num : rest, parse(" =")
		}
		capture confirm integer number `num'
		if !_rc	gettoken num rest : rest, parse(" =")
		else	local num `default_num'
		if `num' < 0 {
			di as err ///
"negative integers are not allowed in technique() option"
			exit 125
		}
		else if `num' > 0 {
			local techlist `techlist' `tech'
			local numlist `numlist' `num'
			local technique `technique' `tech' `num'
		}
		else if "`default'" != "" {
			local techlist `techlist' `tech'
			local numlist `numlist' `num'
			local technique `technique' `tech'
		}
		gettoken tname rest : rest, parse(" =")
	}
	if "`default'`techlist'" == "" {
		local techlist nr
		local numlist `default_num'	// will be ignored
	}

	if "`default'" == "" {
		sreturn local techlist `:list retok techlist'
		sreturn local numlist `:list retok numlist'
	}
	sreturn local technique `:list retok technique'
end

program get_tech
	syntax name(id="macro name") [,		///
		BHHH				/// current valid techniques
		BHHHQ				///
		BFGS				///
		DFP				///
		NR				///
		*				/// invalid technique
	]
	if "`options'" != "" {
		di as err ///
		"`options' is not a valid argument of technique() option"
		exit 198
	}
	c_local `namelist' `bhhh' `bhhhq' `bfgs' `dfp' `nr'
end
