*! version 1.0.0  04feb2013

program define _teffects_gmm_ipw_hetprobit
	version 13
	syntax varlist if, at(name) tvars(varlist) tlevels(string)     ///
		tvarlist(varlist) stat(string) model(string) ipw(name) ///
		control(string) [ treated(string) hvarlist(varlist)    ///
		derivatives(varlist) prlist(namelist) ]

	local att = ("`stat'"=="att")
	local kvar : list sizeof tvarlist
	local klev : list sizeof tlevels
	local khvar : list sizeof hvarlist

	/* programmer error						*/
	if (colsof(`at')!=`kvar'+`khvar') error 503
	if (`klev'!=2) error 498 
	if (`khvar' & "`model'"!="hetprobit") exit 498

	tempvar xb p f tr
	tempname bx b0 mp

	mat `bx' = `at'[1,1..`kvar']
	mat colnames `bx' = `tvarlist'
	mat score double `xb' = `bx' `if'
	if `khvar' {
		tempvar z s

		mat `bx' = `at'[1,`=`kvar'+1'...]
		mat colnames `bx' = `hvarlist'
		mat score double `s' = `bx' `if'
		qui replace `s' = exp(`s') `if'
		qui replace `s' = max(`s',c(epsdouble)) `if'
		qui gen double `z' = `xb'/`s' `if'
	}
	else local z `xb'

	if "`stat'" == "att" {
		local jt : list posof "`treated'" in tlevels
		local jc = mod(`jt',2)+1
		local control : word `jc' of `tlevels'
	}
	else {
		local jc : list posof "`control'" in tlevels
		local jt = mod(`jc',2)+1
		local treated : word `jt' of `tlevels'
	}

	if ("`prlist'"=="") tempvar cdf
	else local cdf : word `jt' of `prlist'

	qui gen double `cdf' = normal(`z') `if'
	if "`prlist'" != "" {
		local p1 : word `jc' of `prlist'
		qui gen double `p1' = 1-`cdf' `if'
	}

	local tr : word `jt' of `tvars'
	qui gen double `p' = cond(`tr',`cdf',1-`cdf') `if' 
	qui replace `p' = max(`p',c(epsdouble)) `if'

	qui gen double `f' = normalden(`z') `if'
	qui replace `f' = cond(`tr',`f',-`f') `if'

	local r : word 1 of `varlist'
	qui replace `r' = `f'/`p' `if'
	if `khvar' {
		qui replace `r' = `r'/`s' `if'

		local rh : word 2 of `varlist'
		qui replace `rh' = -`r'*`xb' `if'
	}

	if (`att') qui gen double `ipw' = `cdf'/`p'
	else qui gen double `ipw' = 1/`p'

	summarize `ipw' `if', meanonly
	scalar `mp' = r(mean)
	qui replace `ipw' = `ipw'/`mp' `if'

	if ("`derivatives'"=="") exit

	tempvar dfx dfs dFx dFs dr drh dipw pp

	qui gen double `dfx' = -`z'*`f' `if'
	if `khvar' {
		tempvar dFx

		qui replace `dfx' = `dfx'/`s' `if'
		qui gen double `dFx' = `f'/`s' `if'

		qui gen double `dfs' = `z'^2*`f' `if'
		qui gen double `dFs' = -`f'*`xb'/`s' `if'
	}
	else local dFx `f'

	local kpar = `klev'+`kvar'+`khvar'
	if `att' {
		qui gen double `pp' = cond(`tr',1,`p'*`p') `if'
		qui gen double `dipw' = cond(`tr',0,`dFx'/`pp'/`mp') `if'
	}
	else {
		qui gen double `pp' = `p'*`p' `if'
		qui gen double `dipw' = `dFx'/`pp'/`mp' `if'
	}
	local j = `klev'
	forvalues i=1/`kvar' {
		local v : word `i' of `tvarlist' 
		local d : word `++j' of `derivatives'
		if `att' {
			qui replace `d' = cond(`tr',0,`dipw'*`v') `if'
		}
		else {
			qui replace `d' = `dipw'*`v' `if'
		}
		summarize `d' `if', meanonly
		if `att' {
			qui replace `d' = -`d'+`cdf'*r(mean)/`mp'/`p' `if'
		}
		else {
			qui replace `d' = -`d'+r(mean)/`mp'/`p' `if'
		}
	}
	if `khvar' {
		if `att' {
			qui replace `dipw' = cond(`tr',0,`dFs'/`pp'/`mp') `if'
		}
		else {
			qui replace `dipw' = `dFs'/`pp'/`mp' `if'
		}
		local j = `klev'+`kvar'
		forvalues i=1/`khvar' {
			local v : word `i' of `hvarlist' 
			local d : word `++j' of `derivatives'
			if `att' {
				qui replace `d' = cond(`tr',0,`dipw'*`v') `if'
			}
			else {
				qui replace `d' = `dipw'*`v' `if'
			}
			summarize `d' `if', meanonly
			if `att' {
				qui replace `d' = -`d'+ ///
					`cdf'*r(mean)/`mp'/`p' `if'
			}
			else {
				qui replace `d' = -`d'+r(mean)/`mp'/`p' `if'
			}
		}
	}
	qui gen double `dr' = (`dfx'-`dFx'*`f'/`p')/`p' `if'
	if `khvar' {
		qui replace `dr' = `dr'/`s' `if'
	}
	local j = `kpar'+`klev'
	forvalues i=1/`kvar' {
		local v : word `i' of `tvarlist'
		local d : word `++j' of `derivatives'
		qui replace `d' = `dr'*`v' `if'
	}
	if `khvar' {
		tempvar ps

		qui gen double `ps' = `s'*`p' `if'
		qui replace `dFs' = -`f'*`xb'+`ps' `if'
		qui gen double `drh' = (`dfs'-`dFs'*`f'/`ps')/`ps' `if'
		local j = `kpar'+`klev'+`kvar'
		forvalues i=1/`khvar' {
			local v : word `i' of `hvarlist'
			local d : word `++j' of `derivatives'
			qui replace `d' = `drh'*`v' `if'
		}
		qui replace `drh' = -`xb'*`drh'
		local j = 2*`kpar'+`klev'+`kvar'
		forvalues i=1/`khvar' {
			local v : word `i' of `hvarlist'
			local d : word `++j' of `derivatives'
			qui replace `d' = `drh'*`v' `if'
		}
		qui replace `dr' = -`xb'*`dr'-`r'
		local j = 2*`kpar'+`klev'
		forvalues i=1/`kvar' {
			local v : word `i' of `tvarlist'
			local d : word `++j' of `derivatives'
			qui replace `d' = `dr'*`v' `if'
		}
	}
end
exit
