*! version 1.0.2  01may2013
program _me_chk_opts, sclass
	version 13
	
	syntax [, Family(string) Link(string) EXPosure(string) ///
		or(string) irr(string) eform(string) BINomial(string) ///
		COLlinear Dispersion(string) sret ]
	
	// always error out on these
	
	if "`family'"!="" {
		di "{err}option {bf:family()} not allowed"
		exit 198
	}
	if "`link'"!="" {
		di "{err}option {bf:link()} not allowed"
		exit 198
	}
	if "`exposure'"!="" {
		di "{err}option {bf:exposure()} not allowed"
		exit 198
	}
	if "`or'"!="" {
		di "{err}option {bf:or} not allowed"
		exit 198
	}
	if "`irr'"!="" {
		di "{err}option {bf:irr} not allowed"
		exit 198
	}
	if "`eform'"!="" {
		di "{err}option {bf:eform} not allowed"
		exit 198
	}
	if "`collinear'"!="" {
		di "{err}option {bf:collinear} not allowed"
		exit 198
	}
	
	if "`binomial'"!="" {
		if (`=`: list sizeof binomial'' > 1) {
			di "{err}option {bf:binomial()} invalid"
			exit 198
		}
		capture confirm integer number `binomial'
		local rc1 = _rc
		capture confirm numeric variable `binomial'
		local rc2 = _rc
		if (`rc1' & `rc2') {
			di "{err}option {bf:binomial()} invalid"
			exit 198
		}
		if `rc1' unab binomial : `binomial'
		sreturn local binomial `binomial'
	}
	
	if "`sret'"=="sret" {
		if "`dispersion'"=="" local dispersion mean
		local 0 , `dispersion'
		capture syntax [, Mean Constant ]
		if _rc {
			di "{err}option {bf:dispersion()} invalid"
			exit 198
		}
		sreturn local dispersion `mean'`constant'
	}
	
end
exit
