*! version 1.2.0  27aug2014
program sem_p, sortpreserve
	version 12

	if "`e(cmd)'"!="sem" {
		error 301
	}

	if e(estimates) == 0 {
		di as err ///
		"predict not allowed after sem with noestimate option"
		exit 198
	}

	quietly ssd query
	if (r(isSSD)) {
		dis as err "predict not possible with summary statistics data"
		exit 198
	}

	sem_check_data

	local lvars `e(lyvars)' `e(lxvars)'
	local ovars `e(oyvars)' `e(oxvars)'
	local lyvars `e(lyvars)'
	local oyvars `e(oyvars)'
	local yvars `oyvars' `lyvars'
	local nvars = e(k_ly) + e(k_lx) + e(k_oy) + e(k_ox)
	local nly = e(k_ly)
	local noy = e(k_oy)

	syntax  anything(id="prefix* or newvarlist") 	///
		[if] [in] [,				///
		XB1(string)				///
		XB					///
		XBLATent1(string)			///
		XBLATent				///
		LATent1(string)				///
		LATent					///
		SCores					///
	]

	if "`scores'" != "" {
		if "`e(method)'" == "adf" {
			di as err "{p 0 2 2}option scores not allowed after" ///
				" estimation with method(adf){p_end}"
			exit 198
		}
		if e(modelmeans) == 0 {
			di as err "{p 0 2 2}option scores not allowed after" ///
				" estimation with option nomeans{p_end}"
			exit 198
		}
	}

	if "`xb1'" != "" {
		local xbopt xb()
	}
	if "`xblatent1'" != "" {
		local xblaopt xblatent()
	}
	if "`latent1'" != "" {
		local laopt latent()
	}

	local opts `laopt' `latent' `xbopt' `xb' `xblaopt' `xblatent' `scores'
	opts_exclusive "`opts'"

	if "`xb1'`xblatent1'`latent1'" != "" {
		tempname x
		matrix `x' = J(1, `nvars', 0)
		matrix colna `x' = `ovars' `lvars'
		if `:list sizeof latent1' {
			capture _unab `latent1', matrix(`x')
			if c(rc) == 0 {
				local latent1 `"`r(varlist)'"'
			}
		}
		else {
			capture _unab `xblatent1', matrix(`x')
			if c(rc) == 0 {
				local xblatent1 `"`r(varlist)'"'
			}
		}
	}

	if "`opts'" == "" {
		local xb xb
	}

	// check: -xb- and -xb()-
	if "`xbopt'`xb'" != "" {
		if `noy' == 0 {
			if "`xbopt'" == "" {
				local xbopt xb
			}
			di as err ///
"option `xbopt' not allowed for models without observed endogenous variables"
			exit 198
		}
	}
	if "`xb'" != "" {
		local xb : copy local oyvars
		di as txt "{p 0 1 2}(xb(`xb') assumed){p_end}"
	}
	else if "`xbopt'" != "" {
		local xb : copy local xb1
		local extra : list dups xb
		if "`extra'" != "" {
			di as err "xb() invalid;"
			di as err "duplicate variables not allowed"
			exit 198
		}
		local extra : list xb - oyvars
		if "`extra'" != "" {
			di as err "xb() invalid;"
			gettoken extra : extra
			di as err ///
"'`extra'' is not an observed endogenous variable in the fitted model"
			exit 111
		}
	}

	// check: -xblatent- and -xblatent()-
	if "`xblaopt'`xblatent'" != "" {
		if `nly' == 0 {
			if "`xblaopt'" == "" {
				local xblaopt xblatent
			}
			di as err ///
"option `xblaopt' not allowed for models without latent endogenous variables"
			exit 198
		}
	}
	if "`xblatent'" != "" {
		local xblatent : copy local lyvars
		di as txt "{p 0 1 2}(xblatent(`xblatent') assumed){p_end}"
	}
	else if "`xblaopt'" != "" {
		local xblatent : copy local xblatent1
		capture mata: st_sem_p_unab("xblatent", "lyvars")
		local extra : list dups xblatent
		if "`extra'" != "" {
			di as err "xblatent() invalid;"
			di as err "duplicate variables not allowed"
			exit 198
		}
		local extra : list xblatent - lyvars
		if "`extra'" != "" {
			di as err "xblatent() invalid;"
			gettoken extra : extra
			di as err ///
"'`extra'' is not a latent endogenous variable in the fitted model"
			exit 111
		}
	}

	// check: -latent- and -latent()-
	if "`laopt'`latent'" != "" {
		if `:list sizeof lvars' == 0 {
			if "`laopt'" == "" {
				local laopt latent
			}
			di as err ///
"option `laopt' not allowed for models without latent variables"
			exit 198
		}
	}
	if "`latent'" != "" {
		local latent : copy local lvars
		di as txt "{p 0 1 2}(latent(`latent') assumed){p_end}"
	}
	else if "`laopt'" != "" {
		local latent : copy local latent1
		capture mata: st_sem_p_unab("latent", "lvars")
		local extra : list dups latent
		if "`extra'" != "" {
			di as err "latent() invalid;"
			di as err "duplicate variables not allowed"
			exit 198
		}
		local extra : list latent - lvars
		if "`extra'" != "" {
			di as err "latent() invalid;"
			gettoken extra : extra
			di as err ///
"'`extra'' is not a latent variable in the fitted model"
			exit 111
		}
	}

	// new variable setup
	if "`xb'"!="" {
		local nvars : list sizeof xb
		foreach v of local xb {
			local iv : list posof "`v'" in yvars
			local ioptvars `ioptvars' `iv'
		}
	}
	else if "`xblatent'"!="" {
		local nvars : list sizeof xblatent
		foreach v of local xblatent {
			local iv : list posof "`v'" in yvars
			local ioptvars `ioptvars' `iv'
		}
	}
	else if "`latent'"!="" {
		local nvars : list sizeof latent
		foreach v of local latent {
			local iv : list posof "`v'" in lvars
			local ioptvars `ioptvars' `iv'
		}
	}
	else if "`scores'"!="" {
		tempname b
		matrix `b' = e(b)
		local svars: colfullnames `b'
		local nvars = colsof(`b')
	}

// sample

	marksample touse, novarlist

// variables to be generated

	if index("`anything'","*") {
		_stubstar2names `anything', nvars(`nvars')
		local varlist `s(varlist)'
		local typlist `s(typlist)'
		confirm new var `varlist'
	}
	else {
		local 0 `anything'
		syntax newvarlist(min=`nvars' max=`nvars')
	}

// scratch variables (type -double-)

	local VARS
	forvalues i = 1/`nvars' {
		tempvar V`i'
		local VARS `VARS' `V`i''
		qui gen double `V`i'' = .
	}

	tempvar tg GV

// generate the variables

	local ng = `e(N_groups)'
	if (`ng'>1) {
		local gvar 	 `e(groupvar)'
		local group_opt  group(`gvar')
		matrix `GV' 	 = e(groupvalue)
	}

	quietly count if `touse'
	if r(N) == 0 {
		* nothing to do here
	}
	else if "`scores'"!="" {
		if `ng' > 1 {
		    sem_mvsort `ovars', touse(`touse') `group_opt' minobs(0)
		}
		mata: st_sem_predict_scores("`VARS'", "`touse'")
	}
	else {
	    tempname ehold
	    _est hold `ehold', copy restore

	    // update -e(oyvars)- and -e(oxvars)- for revar changes in the
	    // column stripe of -e(b)-
	    local plist : colna e(b)
	    local plist : list uniq plist
	    local pdim : list sizeof plist
	    forval i = 1/`pdim' {
		gettoken pvar plist : plist
		if "`pvar'" == "_cons" {
			continue
		}
		if strpos("`pvar'", ".") {
			continue
		}
		local char
		capture local char : char `pvar'[tsrevar]
		if "`char'" == "" {
			continue
		}
		local oyvars `"`e(oyvars)'"'
		if "`oyvars'" != "" {
			local oyvars : subinstr local oyvars	///
				"`char'" "`pvar'", word all
			SetE local oyvars `"`oyvars'"'
		}
		local oxvars `"`e(oxvars)'"'
		if "`oxvars'" != "" {
			local oxvars : subinstr local oxvars	///
				"`char'" "`pvar'", word all
			SetE local oxvars `"`oxvars'"'
		}
	    }

	    if "`e(oyvars)'" != "" {
		fvrevar `e(oyvars)', tsonly
		SetE local oyvars `"`r(varlist)'"'
	    }
	    if "`e(oxvars)'" != "" {
		fvrevar `e(oxvars)', tsonly
		SetE local oxvars `"`r(varlist)'"'
	    }
	    sem_mvsort `ovars', touse(`touse') `group_opt' minobs(0)
	    forvalues g = 1/`ng' {
		if (`ng'>1) {
			capture drop `tg'
			gen byte `tg' = `touse' & `gvar'==`GV'[1,`g']
			local gstr    _`g'
		}
		else {
			local tg      `touse'
			local gstr
		}

		if "`xb'`xblatent'"!="" {
			mata: st_sem_predict_xb( ///
				"`VARS'", "`ioptvars'", "`tg'", `g')
		}
		else if "`latent'"!="" {
			mata: st_sem_predict_fs( ///
				"`VARS'", "`ioptvars'", "`tg'", `g')
		}
	    }
	}

// return results -- new variables are created to show missing values

nobreak noisily {

	forvalues iv = 1/`nvars' {
		gettoken v  varlist : varlist
		gettoken tp typlist : typlist

		gen `tp' `v' = `V`iv'' if `touse'

		if "`xb'"!="" {
			gettoken ov xb : xb
			capture local vlabel : variable label `ov'
			if _rc | !`:length local vlabel' {
				local vlabel `ov'
			}
			label var `v' `"Linear prediction (`vlabel')"'
		}
		else if "`xblatent'"!="" {
			gettoken ov xblatent : xblatent
			capture local vlabel : variable label `ov'
			if _rc | !`:length local vlabel' {
				local vlabel `ov'
			}
			label var `v' `"Linear prediction (`vlabel')"'
		}
		else if "`latent'"!="" {
			gettoken ov latent  : latent
			label var `v' `"Factor score (`ov')"'
		}
		else if "`scores'"!="" {
			gettoken sv svars  : svars
			label var `v' "score for `sv' from sem"
		}
		capture drop `V`iv''
	}

} // nobreak noisily

end

program SetE, eclass
	ereturn `0'
end

mata:

void st_sem_p_unab(string scalar lname, string scalar llist)
{
	real	scalar	rc
	string	vector	vlist

	vlist	= st_local(lname)
	rc = _st_unab(vlist, tokens(st_local(llist)))
	if (rc) exit(rc)
	st_local(lname, invtokens(vlist))
}

end

exit
