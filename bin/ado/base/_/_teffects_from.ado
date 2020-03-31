*! version 1.0.0  21jan2013

program define _teffects_from, rclass
	version 13
	syntax namelist(max=1), kpar(integer) komit(integer) index(numlist) ///
		tvar(passthru) tlevels(passthru) stat(string) [             ///
		from(string) copy skip omodel(passthru) tmodel(passthru)    ///
		control(string) fvdvlist(passthru) fvhdvlist(passthru)      ///
		fvtvlist(passthru) fvhtvlist(passthru) enseparator          ///
		dconstant(passthru) tconstant(passthru)]

	tempname b
	mat `b' = `namelist'

	if "`from'" != "" {
		if "`copy'" == "" {
			cap noi _teffects_ipwra_bv `b', kpar(`kpar')      ///
				komit(`komit') index(`index') `tvar'      ///
				`tlevels' stat(`stat') `omodel' `tmodel'  ///
				control(`control') `fvdvlist' `fvhdvlist' ///
				`fvtvlist' `fvhtvlist' `tconstant'        ///
				`dconstant' `enseparator'
			if (c(rc)) {
				/* programmer error			*/
				di as err "failed to use {bf:from()} option"
				exit 498
			}
			mat `b' = r(b)
		}
		cap noi _mkvec `b', from(`from',`copy'`skip') update 
		local rc = c(rc)
		if `rc' {
			di as err "in option {bf:from()}"
			exit `rc'
		}
	}
	if colsof(`b') != `kpar' {
		di as err "{p}matrix specified in {bf:from()} must have " ///
		 "`kpar' columns{p_end}"
		exit 503
	}
	/* remove omitteds for GMM					*/
	numlist "`index'", sort
	local index `r(numlist)'
	mata: st_matrix("`b'",st_matrix("`b'")[1,strtoreal( ///
		tokens(st_local("index")))])

	if "`stat'" != "pomeans" {
		local klev : list sizeof tlevels
		local k : list posof "`control'" in tlevels
		if (!`k') local k = 1
		if  `k' != `klev' {
			tempname a
			scalar `a' = `b'[1,`klev']
			mat `b'[1,`klev'] = `b'[1,`k']
			mat `b'[1,`k'] = `a'
		}
	}
	return mat b = `b'
end

program define ParseFrom, sclass
	cap noi syntax anything(name=from id="init_specs" equalok) ///
		[, copy skip ]
	local rc = c(rc)
	if `rc' {
		di as err "in option {bf:from()}"
		exit `rc'
	}
	sreturn local from `"`from'"'
	if "`copy'"!="" & "`skip'"!="" {
		di as err "{p}suboptions {bf:copy} and {bf:skip} may not " ///
		 "be combined in the {bf:from()} option{p_end}"
		exit 184
	}
	sreturn local copy `copy'
	sreturn local skip `skip'
end
exit
