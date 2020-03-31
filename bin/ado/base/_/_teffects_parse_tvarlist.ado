*! version 1.0.4  02mar2015

program _teffects_parse_tvarlist, sclass
	version 13
	cap noi syntax varlist(numeric fv), touse(varname) stat(passthru) ///
		[ freq(passthru) logit probit hetprobit(string) mlogit    ///
		  noCONstant CONtrol(passthru) TLEVel(passthru)           ///
		  BASEoutcome(passthru) noMARKout cmd(string) binary ]
	local rc = c(rc)
	if `rc' {
		di as txt "{phang}The treatment model is misspecified.{p_end}"
		exit `rc'
	}

	if `"`hetprobit'"' != "" {
		local hetprobit `"hetprobit(`hetprobit')"'
	}

	ParsePSmodel `binary' : `"`logit' `probit' `hetprobit' `mlogit'"'
	local tmodel `s(tmodel)'
	local markvlist `varlist'
	if "`tmodel'" == "hetprobit" {
		local hvarlist `"`s(hvarlist)'"'
		local markvlist `"`markvlist' `hvarlist'"'
	}
	if "`markout'" == "" {
		cap noi markout `touse' `markvlist'
		local rc = c(rc) 
		if `rc' {
			di as txt "{phang}There is a conflict in the " ///
			 "treatment model specification{p_end}"
			exit `rc'
		}
		_teffects_count_obs `touse', `freq' ///
				why(observations with missing values)
	}
	
	gettoken tvar tvarlist : varlist, bind

	if "`tvarlist'"=="" & "`constant'"!="" {
		di as err "{p}treatment model is misspecified; there " ///
		 "must be at least a constant term in the model{p_end}"
		exit 100
	}

	_teffects_parse_tvar `tvar', touse(`touse') `freq' `control'   ///
		`tlevel' `baseoutcome' nomarkout `stat' `binary' cmd(`cmd')
	/* store sreturn; _rmdcoll will clear it			*/
	local klev = `s(klev)'
	local tvar `s(tvar)'
	local fvtvar `s(fvtvar)'
	local control = `s(control)'
	local levels `"`s(levels)'"'
	foreach lev of local levels {
		local n`lev' = `s(n`lev')'
	}
	if ("`s(tlevel)'"!="") local tlevel = `s(tlevel)'

	if `klev'>2 & "`tmodel'"!="logit" {
		di as err "{p}treatment-model {bf:`tmodel'} requires 2 " ///
		 "levels in treatment variable {bf:`tvar'}, but `klev' " ///
		 "were found{p_end}"
		exit 459
	}

        /* Check for collinearity among variables                       */
	local fvops false
	if "`tvarlist'" != "" {
		_teffects_vlist_exclusive2, vlist1(`tvar') 	///
			vlist2(`tvarlist') case(4)

		/* clears sreturn					*/
	        _rmdcoll `tvar' `tvarlist' `wts' if `touse', `constant'
        	if (r(k_omitted)!=0) local tvarlist `r(varlist)'

	        cap fvexpand `tvarlist' if `touse'
        	if c(rc) {
                	di as err "{p}unable to expand treatment model " ///
			 "{bf:`tvarlist'}{p_end}"
        	        exit 198
	        }
	        if "`r(fvops)'" == "true" {
			local fvtvarlist "`r(varlist)'"
			local fvops true
		}
		else local fvtvarlist `tvarlist'

		fvrevar `tvarlist', list
		local tvarlist `r(varlist)'
		local tvarlist : list uniq tvarlist
	}
	if "`hvarlist'" != "" {
	        cap fvexpand `hvarlist' if `touse'
        	if c(rc) {
                	di as err "{p}unable to expand treatment model " ///
			 "{bf:`hvarlist'}{p_end}"
        	        exit 198
	        }
		local fvhvarlist "`r(varlist)'"

		fvrevar `hvarlist', list
		local hvarlist `r(varlist)'
	}
	/* put back all the sreturn 					*/
	sreturn local tmodel `tmodel'
	sreturn local tvarlist `"`tvarlist'"'
	sreturn local k : word count `tvarlist'
	sreturn local fvtvarlist `"`fvtvarlist'"'
	sreturn local kfv : word count `fvtvarlist'
	sreturn local levels `"`levels'"'
	sreturn local control = `control'
	sreturn local klev = `klev'
	sreturn local tvar `tvar'
	sreturn local fvtvar `fvtvar'
	sreturn local levels `"`levels'"'
	sreturn local fvops `fvops'
	sreturn local tfvops `tfvops'
	sreturn local hvarlist `"`hvarlist'"'
	sreturn local fvhvarlist `"`fvhvarlist'"'
	sreturn local constant `constant'
	foreach lev of local levels {
		sreturn local n`lev' = `n`lev''
	}
	if ("`tlevel'"!="") sreturn local tlevel = `tlevel'
end

program define ParsePSmodel, sclass
	_on_colon_parse `0'
	local which `s(before)'
	local 0 `s(after)'

	cap noi syntax [anything(id="tmodel" name=tmodel)] [, linear ]
	local rc = c(rc)
	if `rc' {
		di as err "treatment model is misspecified"
		exit `rc'
	}
	if "`which'" == "binary" {
		ParseLogitProbitHetprob, `tmodel'
	}
	else {
		ParseMlogitLogitProbitHetprob, `tmodel'
		local mlogit `s(mlogit)'
	}

	local logit `s(logit)'
	local probit `s(probit)'
	local hetprobit `s(hetprobit)'

	local k : word count `mlogit' `logit' `probit'
	/* hetprobit has a varlist					*/
	if `k'>1 | (`k'>0 & "`hetprobit'"!="") {
		di as err "{p}treatment model is misspecified; only " ///
		 "one of {bf:logit}" _c 
		if ("`which'"=="mlogit") di as err " ({bf:mlogit}), " _c
		else di as err ", " _c

		di as err "{bf:probit}, or {bf:hetprobit()} is allowed{p_end}"
		exit 184
	}
	if ("`mlogit'"!="") local logit logit

	if "`hetprobit'" != "" {
		ParseHetprob `hetprobit'
		local tmodel hetprobit
	}
	else if (!`k') local tmodel logit
	else local tmodel `logit'`probit'
	
	sreturn local tmodel `tmodel'
	sreturn local linear `linear'
end

program define ParseLogitProbitHetprob, sclass
	cap noi syntax, [ logit probit hetprobit(string) ]
	local rc = c(rc)
	if `rc' {
		di as txt "{phang}The treatment model is misspecified.{p_end}"
		exit `rc'
	}
	sreturn local logit `logit'
	sreturn local probit `probit'
	sreturn local hetprobit `hetprobit'
end

program define ParseMlogitLogitProbitHetprob, sclass
	cap noi syntax, [ mlogit logit probit hetprobit(string) ]
	local rc = c(rc)
	if `rc' {
		di as txt "{phang}The treatment model is misspecified.{p_end}"
		exit `rc'
	}
	sreturn local mlogit `mlogit'
	sreturn local logit `logit'
	sreturn local probit `probit'
	sreturn local hetprobit `hetprobit'
end

program define ParseHetprob, sclass
	cap noi syntax varlist(numeric fv)
	local rc = c(rc)
	if `rc' {
		di as txt "{phang}The treatment model {bf:hetprobit()} " ///
		 "option is misspecified.{p_end}"
		exit `rc'
	}
	sreturn local hvarlist `varlist'
end

exit

