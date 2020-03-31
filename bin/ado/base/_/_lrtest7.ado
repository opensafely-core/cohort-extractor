*! version 3.2.5  13feb2015
program define _lrtest7, rclass
	version 6
	
	syntax [, Saving(string) Using(string) Model(string) Df(real -9) FORCE]
	
	if "`model'"=="" {
		if "`e(vcetype)'" != "" & "`force'" == "" {
			di in smcl as err "lrtest not valid after robust"
			di in smcl as err "specify {cmd:force} option to"/*
				*/ " perform test anyway"
			exit 198
		}	
		local vcet "`e(vcetype)'"		
		local nmod "`e(cmd)'"
		local nobs = e(N)
		local nll  = e(ll)
		tempname V
		capture mat `V' = syminv(e(V))
		if _rc==0 { 
			local ndf = colsof(`V') - diag0cnt(`V')
			mat drop `V'
		}
		else {
			if _rc != 111 { 
				error _rc
			}
			local ndf 0
			if `"`nmod'"'=="" { 
				error 301
			}
		}
		/* If pre version 6 user programmed estimation command, then */
		/* try getting stuff from S_E_ or _result() */
		if `nobs' == . {
	                local nmod "$S_E_cmd"
			local vcet "$S_E_vce"
                	if "`nmod'"=="" { error 301 }
                	if "`nmod'"=="cox" | "`nmod'"=="logit" |       /*
			*/ "`nmod'"=="probit" | "`nmod'"=="tobit" |    /*
			*/ "`nmod'"=="cnreg" | "`nmod'"=="ologit" |    /*
			*/ "`nmod'"=="oprobit" | "`nmod'"=="mlogit" |  /*
			*/ "`nmod'"=="clogit" {
				quietly `nmod'
				local nobs = _result(1)
				local nll  = _result(2)
				* local ndf  = _result(3) (already set)
			}
			else {
				local nobs "$S_E_nobs"
				local nll  "$S_E_ll"
				* local ndf  "$S_E_mdf"  (already set) 
			}

		}
		if "`nmod'"=="" { error 301 }
		capture confirm integer number `nobs'
		if _rc { error 301 } 
		capture confirm number `nll'
		if _rc { error 301 } 
		capture confirm integer number `ndf'
		if _rc { error 301 } 
	}
	else {
		if (length("`model'")>4) { 
			di in red "model() name too long"
			exit 198
		}
		local name LRTS`model'
		local touse $`name'
		if "`touse'"=="" { 
			di in red "model `model' not found"
			exit 302
		}
		tokenize `touse'
		local nmod `1'
		local nobs `2'
		local nll  `3'
		local ndf  `4'
		local vcet `5'
	}
		
	if "`saving'" != "" {
		if (length("`saving'")>4) { 
			di in red "saving() name too long"
			exit 198
		}
		global LRTS`saving' "`nmod' `nobs' `nll' `ndf' `vcet'"
		if ("`using'"=="") { exit }
	}

	if "`using'"!= "" {
		if (length("`using'")>4) { 
			di in red "using() name too long"
			exit 198
		}
		local user `using'
	}
	else 	local user 0 
	local name LRTS`user'
	local touse $`name'
	if "`touse'"=="" {
		di in red "model `user' not found"
		exit 302
	}
	tokenize `touse'
	local bmod `1'
	local bobs `2'
	local bll  `3'
	local bdf  `4'
	local vcet `5'
	if "`vcet'" != "" & "`force'" == ""  {
		di in smcl as err "lrtest not valid after robust"
		di in smcl as err "specify {cmd:force} option to"/*
			*/ " perform test anyway"
		exit 198
	}
	
	if "`bmod'"!="`nmod'" & "`force'"=="" { 
		di in red "cannot compare `bmod' and `nmod' estimates"
		exit 402
	}
	if `bobs' != `nobs' { 
		di in blu "Warning:  observations differ:  `bobs' vs. `nobs'"
	}
	if `df' == -9 { 
		local df = `bdf' - `ndf'
	}
	/* double save in S_# and r() */
	ret scalar df = `df'
	ret scalar chi2 = -2*(`nll'-`bll')
	ret scalar p = chiprob(`df',return(chi2))
	global S_3 "`return(df)'"
	global S_6 "`return(chi2)'"
	global S_7 "`return(p)'"
	if "`bmod'"!="`nmod'" {
		local name  "`bmod'/`nmod'"
	}
	else	local name = upper(bsubstr("`nmod'",1,1))+bsubstr("`nmod'",2,.)
	#delimit ; 
	di in gr "`name':  likelihood-ratio test" _col(55)
		"chi2(" in ye `df' in gr ")     = "
		in ye %10.2f return(chi2) _n _col(55) in gr "Prob > chi2 = " 
		in ye %10.4f return(p) ;
	#delimit cr
end

