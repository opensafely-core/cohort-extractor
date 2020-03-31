*! version 7.6.4  21mar2019
program define binreg, eclass byable(onecall) prop(or hr rr mi bayes)
	local version : di "version " string(_caller()) ", missing:"
	if _by() {
		local BY `"by `_byvars'`_byrc0':"'
	}
	local vceopts bootopts(noheader notable)	///
		jkopts(noheader notable)		///
		mark(Exposure OFFset mu INIt CLuster)
	`BY' _vce_parserun binreg, `vceopts' : `0'
	if "`s(exit)'" != "" {
		// -bootstrap- and -jackknife- are not aware of -vfactor()-
		if e(vf) != 1 {
			tempname V
			matrix `V' = e(vf)*e(V)
			version 9: ereturn repost V = `V'
		}
		local ZERO : copy local 0
		local 0 `", `s(diopts)'"'
		capture syntax [, EForm(passthru) *]
		local EFORM : copy local eform
		local OPTS : copy local options
		local 0 : copy local ZERO
		version 9: ereturn local clustvar `"`e(cluster)'"'
		version 9: ereturn local cluster
		version 10: ereturn local cmdline `"binreg `0'"'
		quietly syntax [anything] [fw aw iw pw] [if] [in] [,	///
			Level(passthru) EForm(passthru) OR HR RR * ]
		if ! `:length local level' {
			if `"`s(level)'"' != "" {
				local level `"level(`s(level)')"'
			}
		}
		if `: length local EFORM' {
			local eform : copy local EFORM
		}
		else if ! `: length local eform' {
			local eform `"`e(eform)'"'
		}
		_get_diopts diopts options, `OPTS' `options'
		version 7: Playback, `level' `eform' `or' `hr' `rr' `diopts'
		exit
	}

	version 7.0, missing
	if replay() {
		if _by() { error 190 }
		syntax, [ Level(cilevel) * ]
		local efopt= `"`e(eform)'"'
		Playback ,level(`level') `efopt' `options'
		exit
	}
	`version' `BY' Estimate `0'
	version 10: ereturn local cmdline `"binreg `0'"'
end

program Estimate, eclass byable(recall)
	local version : di "version " string(_caller()) ", missing:"
	version 7.0, missing

	syntax varlist(ts fv) [if] [in] [fw aw pw iw] [, OR RR RD HR	/*
		*/ COEFficients ML IRLS /*
		*/ mu(varname) N(string) cmd Level(cilevel) /*
		*/ INIt(varname) moptobj(passthru) search from(passthru) /*
		*/ scale(string) *] 
	
	local options `options' `search' `from' scale(`scale')
	if ("`ml'"=="" & "`search'"!="") {
		di as err ///
"option {bf:search} is allowed only in combination with option {bf:ml}"
		exit 198
	}
	if ("`ml'"=="" & `"`from'"'!="") {
		di as err ///
"option {bf:from()} is allowed only in combination with option {bf:ml}"
		exit 198
	}
	if ("`ml'"!="" & `"`scale'"'=="dev") {
		di as err ///
"option {bf:scale(dev)} is not allowed in combination with option {bf:ml}"
		exit 198
	}
	
	_get_diopts diopts options, `options'
	gettoken lhs : varlist
	_fv_check_depvar `lhs'

	Disallow , `options'
	if `"`weight'"'!="" {
			local wtopt="[`weight' `exp']"
	}
	if "`ml'"=="" {
		local metopt="irls"
	}
	else if "`irls'"!="" {
		di as err "ml and irls options may not be combined"
		exit 198
	}

	if "`init'"!="" & "`mu'"!="" & "`init'"!="`mu'" {
		noi di as err "mu() and init() should use the same varname"
		exit 198
	}

	if "`init'"!="" {
		local mu "mu(`init')"
	}
	else {
		local mu "mu(`mu')"
	}

	local nc : word count `or' `rr' `rd' `hr'
	if `nc' > 1 {
		di as err "may choose only one of or, rr, rd, hr options"
		exit 198
	}
	local eopt 0 
	if `nc' != 0 & "`coefficients'" == "" { local eopt 1 } 
	if `nc' == 0 { 
		local or "or"
	}
	if "`rd'" != "" {
		local eopt 1
	}

	marksample touse 		/* must be done early */

	if "`n'" == ""			{ local m 1		}
	else				{ local m `"`n'"'	}
	capture confirm variable `m'
        if _rc~=0 {
		capture confirm integer number `m'
		if _rc~=0 {
			noi di as err /*
		*/ "option n(`m') invalid - integer or variable name expected"
		exit 198
		}
	}

        capture confirm integer number `m'
        local mfixed = (_rc==0)         /* Fixed if not a variable */


	local famopt="family(binomial `m')"

	if "`or'" != ""		{ 
		local link "logit"			/* logistic	*/
		local efopt "eform(Odds Ratio)"
		local cmsg  "Odds ratio coefficients"
	}
	else if "`rr'" != ""	{ 
		local link "log"			/* log		*/
		local efopt "eform(Risk Ratio)"
		local cmsg  "Risk ratio coefficients"
	}
	else if "`rd'" != ""	{ 
		local link "identity"			/* identity	*/
		local efopt "coeftitle(Risk Diff.)"
		local cmsg  "Risk difference coefficients"
	}
	else if "`hr'" != ""	{ 
		local link "logc"			/* log compl.	*/
		local efopt "eform(Hlth Ratio)"
//		local efopt "eform(HR)"
//		local efopt `"eform("__Health Ratio")"'
		local cmsg  "Health ratio coefficients"
		if "`coefficients'"=="" {
//			local cmsg  "Health ratio (HR)"
			local cmsg  "Health ratio"
		}
	}
	if !`eopt' { local efopt }

	local bernoul = `mfixed' & `"`m'"'=="1"         /* Bernoulli dist */

	
	if `"`cmd'"'!="" {
                di _n as txt "-> glm `varlist' `if' `in' `wtopt', " _c
		di as txt "`metopt' link(`link') family(binomial `m')" _c
		di as txt " level(`level') `mu' `options'" _c
                exit
        }


	`version' glm `varlist' if `touse' `wtopt', nodisplay /*
	*/  `metopt' link(`link') family(binomial `m') `mu' /* 
	*/   level(`level') `options' `moptobj'
	*  link(`link') family(binomial `m') level(`level') `options'


	if `"`e(offset)'"'!="" {
		local offopt `", offset `e(offset)'"'
	}

	DescFL "binomial" `"`link'"' `bernoul' `m'
        local o `"`r(dist)', `r(link)'`offopt'"'
        local lll : word 1 of `r(link)'
	est local cmd "binreg"
	est local  title_fl `"`o'"'
	est local  eform `"`efopt'"'
	_post_vce_rank
	
	if `"`e(msg)'"'!="" {
		est hidden local msg_1 `"(Standard errors scaled using `e(msg)')"'
	}
	if "`e(disp)'"~="" & "`e(disp)'"!="1" {
		est hidden local  msg_2 /*
	*/ `"(Quasi-likelihood model with dispersion `e(disp)')"'
	}
	if !`eopt' {
		est hidden local msg_3 `"`cmsg'"'
	}
	if "`hr'"~="" {
		est hidden local  msg_3 `"`cmsg'"'
	}

	// hidden e(power) and e(nbml) from -glm- for -binreg-
	capture confirm number `e(power)'
	local copy_power `"`e(power)'"'
	if !_rc {
		est hidden scalar power = `copy_power'
	}
	else {
		est hidden local power `"`copy_power'"'
	}
	
	
	
	local copy_nbml `e(nbml)'
	est hidden scalar nbml = `copy_nbml'
	
	local cln: colnames e(b)
	local wc: word count `cln'
	local conspos = ustrpos(`"`cln'"', "_cons")
	est hidden scalar noconstant = cond(`conspos'==0,1,0)
	est hidden scalar consonly = cond(`conspos'>0 & `wc'==1,1,0)
	
	Playback, level(`level') `efopt' `diopts'
end


program define Playback , eclass

	local ignore OR RR RD HR		// for bootstrap and jackknife

	syntax [, LEvel(cilevel) EForm(passthru)			///
		  COEFTitle(passthru) COEFTITLEFmt(passthru)		///
		  `ignore' *]
	if `"`e(cmd)'"'!="binreg" { error 301 } 

	_get_diopts diopts, `options'

nobreak {

capture noisily break {

	estimates local cmd "glm"
	glm , notable

} // capture noisily nobreak

	local rc = _rc
	estimates local cmd "binreg"

} // nobreak 

	if `rc' {
		exit `rc'
	}

	_coef_table, level(`level') `eform' `coeftitle' `diopts'
	local i 1
	while `i' <= 2 {
		if `"`e(msg_`i')'"' != "" { 
			di as txt `"`e(msg_`i')'"' 
		}
		local i = `i' + 1
	}
//	HRfootnote , `eform'
	_prefix_footnote
	error `e(rc)'
end

/*
program HRfootnote
	syntax [, eform(string)]

	if "`eform'" == "HR" & "`e(consonly)'"=="0" {
		di "Note: HR estimates health ratios."
	}
end
*/

program define DescFL, rclass /* return description of family and link */
	args f l bernoul m

	local s1 " distribution"
	local s2 " link"

	if `bernoul'	{ local s1 `"Bernoulli`s1'"' }
	else 		{ local s1 `"Binomial (N=`m')`s1'"' }

	if `"`l'"'=="logit"		{ local s2 `" fvlogit`s2'"' }
	else if `"`l'"'=="log"	{ local s2 `"log`s2'"' }
	else if `"`l'"'=="logc"	{ local s2 `"log-complement`s2'"' }
	else if `"`l'"'=="identity"	{ local s2 `"identity`s2'"' }

	ret local dist `"`s1'"'
	ret local link `"`s2'"'
end

program define Disallow

	syntax [, EForm *]
	local 0 , `eform'
	syntax [, NOTANOPTJUSTFORERROR ]

end
exit
Notes:
	This program fits the model described in:

	Wacholoder, Sholom 1986.
		Binomial regression in GLIM: estimating 
		risk ratios and risk differences
		American Journal of Epidemiology, 123:174--184.
