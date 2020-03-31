*! version 1.0.6  12sep2017
program anova_estat, rclass
	version 9

	local ver : di "version " string(_caller()) ", missing :"

	if "`e(cmd)'" != "anova" {
		error 301
	}

	gettoken key rest : 0, parse(", ")
	local lkey = length(`"`key'"')
	if `"`key'"' == bsubstr("ovtest",1,max(3,`lkey')) {
		if "`e(version)'" == "2" && _caller() < 11 {
			version 11: ovtest `rest'
		}
		else if "`e(version)'" == "" && _caller() >= 11 {
			version 10.1, missing: ovtest `rest'
		}
		else {
			`ver' ovtest `rest'
		}
	}
	else if `"`key'"' == bsubstr("hettest",1,max(4,`lkey')) {
		if 0`e(version)' < 2 {
			// old anova is limited
			AnovaHetTest `rest'
		}
		else {
			hettest `rest'
		}
	}
	else if `"`key'"' == bsubstr("summarize",1,max(2,`lkey')) {
		if 0`e(version)' < 2 {
			// old anova has generic name stripes
			AnovaSumm `rest'
		}
		else {
			estat_default `0'
		}
	}
	else if `"`key'"' == bsubstr("szroeter",1,max(3,`lkey')) {
		if 0`e(version)' < 2 {
			// not allowed after old anova 
			di as err ///
		  "estat szroeter not allowed after anova run with version < 11"
			exit 301
		}
		else {
			szroeter `rest'
		}
	}
	else if `"`key'"' == bsubstr("vif",1,max(3,`lkey')) {
		if 0`e(version)' < 2 {
			// not allowed after old anova 
			di as err ///
		    "estat vif not allowed after anova run with version < 11"
			exit 301
		}
		else {
			vif `rest'
		}
	}
	else if `"`key'"' == bsubstr("imtest",1,max(3,`lkey')) {
		if 0`e(version)' < 2 {
			// not allowed after old anova 
			di as err ///
		  "estat imtest not allowed after anova run with version < 11"
			exit 301
		}
		else {
			version 11: imtest `rest'
		}
	}
	else if `"`key'"' == bsubstr("esize",1,max(3,`lkey')) {
		if _caller() < 13 {
			// not allowed after old anova 
			di as err ///
		    "estat esize not allowed after anova run with version < 13"
			exit 301
		}
		else {
			`ver' estat_esize `rest'
		}
	}
	else {
		estat_default `0'
	}
	return add
end

program AnovaHetTest, rclass
	// -rhs- option not allowed for -hettest- after -anova-
	capture syntax [anything] , Rhs [*]
	if _rc == 0 {
		di as err "option rhs not allowed"
		exit 198
	}
	else {
		if "`anything'" == "" {
			syntax [, Mtest Mtest2(passthru) ]
			if `"`mtest'`mtest2'"' != "" {
				di as err ///
				`"varlist required with `mtest'`mtest2' option"'
				exit 198
			}
		}
		hettest `0'
	}
	return add
end

program AnovaSumm, rclass
	// handle the varlist since names are not on the e(b) matrix stripe

	syntax [anything(name=vlist)] [, * ]

	if `"`vlist'"' == "" {
		local vlist `e(depvar)' `e(varnames)'
	}

	estat_summ `vlist', `options'

	return add
end
