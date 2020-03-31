*! version 1.4.1  04apr2019
program define xtgee_p
	version 6, missing
	syntax [anything] [if] [in] [, SCores * ]
	if `"`scores'"' != "" {
		GenScores `0'
		exit
	}

		/* Step 1:
			place command-unique options in local myopts
			Note that standard options are
			LR:
				Index XB Cooksd Hat
				REsiduals RSTAndard RSTUdent
				STDF STDP STDR noOFFset
			SE:
				Index XB STDP noOFFset
		*/
	local myopts "MU Rate pr0(string) pr(string)"
		/* Step 2:
			call _propts, exit if done,
			else collect what was returned.
		*/
	_pred_se "`myopts'" `0'
	if `s(done)' {
		exit
	}
	local vtyp  `s(typ)'
	local varn `s(varn)'
	local 0 `"`s(rest)'"'
		/* Step 3:
			Parse your syntax.
		*/
	syntax [if] [in] [, `myopts' noOFFset]

		/* Step 4:
			Concatenate switch options together
		*/
	local type "`mu'`rate'"
	local args `"`pr0'`pr'"'
	if "`pr0'" != "" {
		if "`e(distrib)'"=="" {
			di as err "the pr0() option is allowed only " ///
				"for random-effects models"
			exit 198
		}
		local propt pr(`pr0')
	}
	if "`pr'" != "" {
		if "`e(family)'"=="" {
			di as err "the pr() option is only " ///
				"allowed for population-averaged models"
			exit 198
		}
		local propt pr(`pr')
	}

		/* Step 5:
			quickly process default case if you can
			Do not forget -nooffset- option.
		*/


		/* Step 6:
			mark sample (this is not e(sample)).
		*/
	marksample touse


		/* Step 7:
			handle options that take argument one at a time.
			Comment if restricted to e(sample).
			Be careful in coding that number of missing values
			created is shown.
			Do all intermediate calculations in double.
		*/


		/* Step 8:
			handle switch options that can be used in-sample or
			out-of-sample one at a time.
			Be careful in coding that number of missing values
			created is shown.
			Do all intermediate calculations in double.
		*/

	if ("`type'"=="" & `"`args'"'=="") | "`type'"=="mu" {
		Title `offset'
		local ttl `"`s(title)'"'
		if "`type'"=="" {
			version 8: ///
			di `"{txt}(option {bf:mu} assumed; `ttl)')"'
		}
		Calc "`vtyp'" `varn' `touse' `offset'
		label var `varn' `"`ttl'"'
		exit
	}

	if "`type'"=="rate" {
		Title nooffset
		local ttl `"`s(title)'"'
		Calc "`vtyp'" `varn' `touse' nooffset
		label var `varn' `"`ttl'"'
		exit
	}


		/* Step 9:
			handle switch options that can be used in-sample only.
			Same comments as for step 8.
		*/
	* qui replace `touse'=0 if !e(sample)


			/* Step 10.
				Issue r(198), syntax error.
				The user specified more than one option
			*/
	local type `type'
	if `"`args'"'!="" & "`e(link)'"== "log" & "`e(family)'"=="Poisson" {
		if "`type'" != "" {
			error 198
		}
		tpredict_p2 "`vtyp'" "`varn'" "`touse'" "`offset'" "`pr'"
		exit
	}
	if `"`args'"'!="" & "`e(family)'"!="" {
		if "`type'" != "" {
			error 198
		}
		if "`e(predict)'" == "xtnbreg_pa_p" {
			di as err "probability calculations are not " ///
				"available for this model"
		}
		else {
			version 11: di as err 				///
				"{p 0 4 2}probability calculations " 	///
				"are only available for "		///
				"{cmd:family(poisson)} {cmd:link(log)}{p_end}"
		}
		error 198
	}
	error 198
end

program define Title, sclass
	args offset
	sret clear

	if "`e(denom)'" != "" & "`e(denom)'"!="1" {
	if "`offset'"=="" {
		local denom "`e(denom)'"
	}
	}
	if "`e(offset)'" != "" {
		local offnote "considering offset"
		if "`offset'"!="" {
			local offnote "not `offnote'"
	}
	}

	if "`e(link)'"== "identity" {
		local title "Linear prediction"
	}
	else if "`e(link)'"== "log" {
		local title "Exponentiated linear prediction"
	}
	else if inlist("`e(link)'", "cloglog", "logit", "probit") {
		if "`denom'" != "" {
			local title "Pr(`e(depvar)' | denominator=`denom')"
		}
		else {
			local title "Pr(`e(depvar)' != 0)"
		}

	}
	else if "`e(link)'"== "reciprocal" {
		local title "Reciprocal of linear prediction"
	}
	else if bsubstr("`e(link)'",1,5)== "power" {
		local title "Power (1/`e(power)') of linear prediction"
	}
	else if bsubstr("`e(link)'",1,5)== "odds p" {
		local title "Odds power (`e(power)') of linear prediction"
	}
	else if "`e(link)'"== "negative binomial" {
		local title "Negative binomial prediction"
	}
	else	error 301
	local title `"`title' `offnote'"'
	sreturn local title `"`:list retok title'"'
end

program define Calc
	args vtyp varn touse offset

	tempvar xb
	qui _predict double `xb' if `touse', xb `offset'

	local std 1
	if "`e(denom)'" != "" & "`e(denom)'"!="1" {
		if "`offset'"=="" {
			local std `"`e(denom)'"'
		}
	}

	if "`e(link)'"== "identity" {
		gen `vtyp' `varn' = `std'*`xb' if `touse'
	}
	else if "`e(link)'"== "log" {
		gen `vtyp' `varn' = `std'*exp(`xb') if `touse'
	}
	else if "`e(link)'"== "logit" {
		gen `vtyp' `varn' = `std'*exp(`xb')/(1+exp(`xb')) if `touse'
	}
	else if "`e(link)'"== "cloglog" {
		gen `vtyp' `varn' = `std'*(-expm1(-exp(`xb'))) if `touse'
	}
	else if "`e(link)'"== "reciprocal" {
		gen `vtyp' `varn' = `std'/`xb' if `touse'
	}
	else if "`e(link)'"== "probit" {
		gen `vtyp' `varn' = `std'*normprob(`xb') if `touse'
	}
	else if bsubstr("`e(link)'",1,5)== "power" {
		gen `vtyp' `varn' = `std'*`xb'^(1/`e(power)') if `touse'
	}
	else if bsubstr("`e(link)'",1,5)== "odds p" {
		qui replace `xb' = (`e(power)'*`xb'+1)^(1/`e(power)') /*
		*/ if `touse'
		gen `vtyp' `varn' = `std'*`xb'/(1+`xb') if `touse'
	}
	else if "`e(link)'"== "negative binomial" {
		gen `vtyp' `varn' = /*
		*/ `std'*`e(nbalpha)'*exp(`xb')/(-expm1(`xb')) /*
		*/ if `touse'
	}
	else	error 301
end

program GenScores, sortpreserve
	version 9, missing
	syntax [anything] [if] [in] [, * ]
	marksample touse

	// get `sarg'
	_score_spec `anything', `options'
	local vname `s(varlist)'
	local vtype `s(typlist)'
	local sarg score(`vname')
	// get `xvars'
	local xvars : colnames e(b)
	local xvars : list uniq xvars
	local CONS _cons
	local has_cons : list CONS in xvars
	local xvars : list xvars - CONS
	// get `warg'
	tempvar wvar
	if "`e(wtype)'" != "" {
		quietly gen double `wvar' `e(wexp)' if `touse'
		local w
		if "`e(wtype)'" == "fweight" {
			local fwt fwt
		}
		else if "`e(wtype)'" == "aweight" {
			sum `wvar', mean
			replace `wvar' = `wvar'/r(mean)
		}
	}
	else {
		quietly gen byte `wvar' = 1
	}
	local warg wvar(`wvar')
	// get `b1'
	tempname b1
	matrix `b1' = e(b)
	// get `link'
	local link = bsubstr("`e(link)'",1,5)
	if "`link'" == "clogl" {
		local link cloglog
	}
	if "`link'" == "probi" {
		local link probit
	}
	if "`link'" == "power" {
		local len = length("`e(link)'") - 7
		global S_X_pow = bsubstr("`e(link)'",7,`len')
	}
	if "`:list retok link'" == "odds" {
		local link opower
		local len = length("`e(link)'") - 12
		global S_X_pow = bsubstr("`e(link)'",12,`len')
	}
	if "`link'" == "negat" {
		local link nbinom
	}
	// get `family'
	local family = bsubstr(lower("`e(family)'"),1,5)
	if "`family'" == "negat" {
		local family nbinom
		local len = length("`e(family)'") - 21
		global S_X_nba = bsubstr("`e(family)'",21,`len')
	}
	if "`family'" == "inver" {
		local family igauss
	}
	// get `binom'
	tempvar binom
	if "`e(denom)'" == "" {
		quietly gen byte `binom' = 1
	}
	else {

		quietly gen `binom' = `e(denom)'
	}
	// get `mui'
	tempvar mui
	quietly mat score double `mui' = `b1'
	if "`e(offset)'" != "" {
		tempvar offset
		quietly gen double `offset' = `e(offset)'
		quietly replace `mui' = `mui' + `offset'
	}
	quietly xtgee_plink "`link'" `mui' `binom'
	tempvar ei
	quietly gen double `ei' = `e(depvar)' - `mui'
	quietly xtgee_elink "`family'" `mui' `ei' `binom'
	drop `mui'
	mat score double `mui' = `b1'
	if "`e(offset)'" != "" {
		drop `offset'
		quietly gen double `offset' = `e(offset)'
		quietly replace `mui' = `mui' + `offset'
	}
	// `S1' and `S2' are output matrices, their values are ignored
	tempname S1 S2
	// get maxni
	local maxni `e(g_max)'
	// get `ivar' and `tvar'
	local rivar `e(ivar)'
	local tvar `e(tvar)'
	markout `touse' `rivar' `tvar'
	sort `rivar'
	if "`tvar'" != "" {
		tempvar tord
		quietly tabulate `tvar', cgen(`tord')
		tempname ivar
		quietly xtgee_makeivar `rivar' `tvar' `tord' `maxni' -> `ivar'
		sort `ivar' `tvar'
	}
	else	local ivar `rivar'
	// get `R' -- this should not affect the scores
	tempname R
	matrix `R' = e(R)
	// get `phi'
	tempname phi
	scalar `phi' = 0
	// make globals
	global S_X_link `link'
	global S_X_mvar `family'
	global S_X_corr `e(corr)'
	global S_X_con  `has_cons'

	tempvar id
	quietly gen `id' = _n
	preserve
	quietly keep if `touse'
	quietly gen `vtype' `vname' = .
	_GEEBT `xvars', mui(`mui') N(`binom') by(`ivar')	///
		`warg' phi(`phi') `sarg' xy(`S1') xx(`S2')  ///
		R(`R') b1(`b1') depv(`e(depvar)') n(`maxni') `fwt'

	quietly replace `vname' = `vname'/sqrt(e(phi))
	tempfile tmpf
	quietly keep `id' `vname'
	sort `id'
	quietly save `"`tmpf'"'
	restore
	sort `id'
	capture merge `id' using `"`tmpf'"'
	if c(rc) {
		if c(rc) == 1 {
		 	di as err "unable to generate score `vname'"
		 	exit 198
		}
	}
	capture drop _merge
	label var `vname' "equation-level score from `e(cmd)'"

	quietly count if missing(`vname')
	if r(N) > 0 {
		di as txt "(`r(N)' missing values generated)"
	}
end
exit

