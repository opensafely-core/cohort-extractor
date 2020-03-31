*! version 1.0.2  03jun2015

program define _teffects_gmm_ra
	version 13
	syntax varlist if [fw iw pw/], at(name) tvars(varlist) tlevels(string)  ///
		depvar(varname) dvarlist(varlist) stat(string) model(string) ///
		[ hvarlist(varlist) control(string) treated(string)          ///
		derivatives(varlist) ipw(varname) ]

	local kvar : list sizeof dvarlist
	local klev : list sizeof tlevels
	local khvar : list sizeof hvarlist
	local kpar = `klev'*(`kvar'+`khvar'+1)
	/* programmer error						*/
	if (colsof(`at')!=`kpar') error 503

	local pomeans = ("`stat'"=="pomeans")
	local att = ("`stat'"=="att")
	local logit = ("`model'"=="logit"|"`model'"=="flogit")
	local probit = ("`model'"=="probit"|"`model'"=="fprobit")
	local hetprobit = ("`model'"=="hetprobit"|"`model'"=="fhetprobit")
	local poisson = ("`model'"=="poisson")

	tempvar xb f pp tj
	tempname bx b0 bz

	if `att' {
		local jt : list posof "`treated'" in tlevels
		local treat : word `jt' of `tvars'
	}
	if `probit' | `hetprobit' {
		qui gen double `pp' = .
		if (`hetprobit') tempvar s
		else tempname s
	}

	if ("`ipw'"!="") local iwt `ipw'*

	qui gen byte `tj' = 0
	local i2 = `klev'
	local j2 = `i2' + `kvar'*`klev'
	local k = `klev'
	local h = 2*`klev'
	forvalues j=1/`klev' {
		tempvar p`j'

		local i1 = `i2' + 1
		local i2 = `i2' + `kvar'
		mat `bx' = `at'[1,`i1'..`i2']
		mat colnames `bx' = `dvarlist'
		mat score double `xb' = `bx' `if'

		if (`logit') qui gen double `p`j'' = invlogit(`xb') `if'
		else if `probit' {
			qui gen double `p`j'' = normal(`xb') `if'
			qui replace `pp' = `p`j''*(1-`p`j'')
			qui replace `pp' = max(`pp',c(epsdouble)) `if'
		}
		else if `hetprobit' {
			local j1 = `j2' + 1
			local j2 = `j2' + `khvar'
			mat `bz' = `at'[1,`j1'..`j2']
			mat colnames `bz' = `hvarlist'
			mat score double `s' = `bz' `if'
			qui replace `s' = exp(`s') `if'
			qui replace `s' = max(`s',c(epsdouble)) `if'

			qui gen double `f' = `xb'/`s' `if'
			qui gen double `p`j'' = normal(`f') `if'
			qui replace `f' = normalden(`f')/`s' `if'
			qui replace `pp' = `p`j''*(1-`p`j'')
			qui replace `pp' = max(`pp',c(epsdouble)) `if'
			qui drop `s'
		}
		else if (`poisson') qui gen double `p`j'' = exp(`xb') 
		else qui gen double `p`j'' = `xb' `if'

		local rx : word `++k' of `varlist'
		local tj : word `j' of `tvars' 

		if `probit' {
			qui replace `rx' = cond(`tj',`iwt'normalden(`xb')* ///
				(`depvar'-`p`j'')/`pp',0) `if' 
		}
		else if `hetprobit' {
			qui replace `f' = cond(`tj',`iwt'`f'* ///
				(`depvar'-`p`j'')/`pp',0) `if'

			qui replace `rx' = cond(`tj',`f',0) `if'

			local rz : word `++h' of `varlist'
			qui replace `rz' = cond(`tj',-`xb'*`f',0) `if'

			qui drop `f'
		}
		else {
			/* d(invlogit())/d(xb) = G(xb)*(1-G(xb))	*/
			qui replace `rx' =  ///
				cond(`tj',`iwt'(`depvar'-`p`j''),0) `if' 
		}
		qui drop `xb'
	}
	if `pomeans' {
		forvalues j=1/`klev' {
			scalar `bx' = `at'[1,`j']
			local rx : word `j' of `varlist'
			qui replace `rx' = `p`j''-`bx' `if'
		}
	}
	else {
		/* control index					*/
		local kc : list posof "`control'" in tlevels
		scalar `b0' = `at'[1,`kc']

		forvalues j=1/`klev' {
			local lev : word `j' of `tlevels'
			local rx : word `j' of `varlist'

			if ("`lev'"=="`control'") scalar `bx' = 0
			else scalar `bx' = `at'[1,`j']

			if `att' {
				qui replace `rx' = cond(`treat', ///
					`p`j''-`b0'-`bx',0) `if'
			}
			else qui replace `rx' = `p`j''-`b0'-`bx' `if' 
		}
	}
	if ("`derivatives'"=="") exit

	/* treatments							*/
	local kt = 1
	/* macro kc, control index, set above				*/
	forvalues j=1/`klev' {
		local dk : word `kt' of `derivatives'

		if (`att') qui replace `dk' = cond(`treat',-1,0) `if'
		else qui replace `dk' = -1 `if'

		local kt = `kt' + `kpar' + 1
		if !`pomeans' {
			local dk : word `kc' of `derivatives'
			if `att' & `kc'!=`kt' {
				qui replace `dk' = cond(`treat',-1,0) `if'
			}
			else  qui replace `dk' = -1 `if'

			local kc = `kc' + `kpar'
		}
	} 
	if `probit' | `hetprobit' {
		local i2 = `klev'
		if (`hetprobit') local j2 = `klev'*(1 + `kvar')

		qui gen double `f' = .
		/* hetprobit variance variables				*/
		if (`hetprobit') local kh = `klev'*(1 +`kvar')
	}
	else if `logit' {
		qui gen double `pp' = .
	}	
	/* regression variables for treatments				*/
	local kx = `klev'
	forvalues j=1/`klev' {
		if `probit' | `hetprobit' {
			tempvar f`j'
			local i1 = `i2' + 1
			local i2 = `i2' + `kvar'
			mat `bx' = `at'[1,`i1'..`i2']
			mat colnames `bx' = `dvarlist'
			mat score double `xb' = `bx' `if'
			if `hetprobit' {
				local j1 = `j2' + 1
				local j2 = `j2' + `khvar'
				mat `bz' = `at'[1,`j1'..`j2']
				mat colnames `bz' = `hvarlist'
				mat score double `s' = `bz' `if'
				qui replace `s' = exp(`s') `if'
				qui replace `s' = max(`s',c(epsdouble)) `if'
				qui replace `f' = normalden(`xb'/`s')/`s' `if'
			}
			else {
				qui replace `f' = normalden(`xb') `if'
			}
		}
		else if `logit' {
			qui replace `pp' = `p`j''*(1-`p`j'') `if'
			qui replace `pp' = max(`pp',c(epsdouble)) `if'
		}

		forvalues k=1/`kvar' {
			local x : word `k' of `dvarlist'
			local dk : word `++kx' of `derivatives'
			if `logit' {
				if `att' {
					qui replace `dk' = cond(`treat', ///
						`x'*`pp',0) `if'
				}
				else {
					qui replace `dk' = `x'*`pp' `if'
				}
			}
			else if `poisson' {
				if `att' {
					qui replace `dk' = cond(`treat', ///
						`x'*`p`j'',0) `if'
				}
				else {
					qui replace `dk' = `x'*`p`j'' `if'
				}
			} 
			else if `probit' | `hetprobit' {
				if `att' {
					qui replace `dk' = cond(`treat', ///
						`x'*`f',0) `if'
				}
				else {
					qui replace `dk' = `x'*`f' `if'
				}
			}
			else if `att' {
				qui replace `dk' = cond(`treat',`x',0) `if'
			}
			else qui replace `dk' = `x' `if'
		}
		if `hetprobit' {
			forvalues k=1/`khvar' {
				local x : word `k' of `hvarlist'
				local dk : word `++kh' of `derivatives'
				if `att' {
					qui replace `dk' = cond(`treat', ///
						-`x'*`xb'*`f',0) `if'
				}
				else {
					qui replace `dk' = -`x'*`xb'*`f' `if'
				}
			}
			local kh = `kh' + `kpar'
		}
		local kx = `kx' + `kpar'
		if `probit' | `hetprobit' {
			qui drop `xb'
			if (`hetprobit') qui drop `s'
		}
	}
	/* regression parameters					*/
	local kx = `klev'*(`kpar'+1)
	if `probit' | `hetprobit' {
		tempvar del d1 d2

		local i2 = `klev'
		if `hetprobit' {
			tempvar xbs s1

			local j2 = `klev'*(1+`kvar')
			local kxh = `kx' + `klev'*`kvar'
			local khx = `kx' + `klev'*`kpar'
			local kh = `kxh' + `klev'*`kpar'
			local kr = `klev'
			qui gen `s1' = .
			qui gen `xbs' = .
		}
		qui replace `pp' = .
		qui gen double `del' = .
		qui gen double `d1' = .
		qui gen double `d2' = .
	}
	forvalues j=1/`klev' {
		local tj : word `j' of `tvars'
		if `probit' | `hetprobit' {
			local i1 = `i2' + 1
			local i2 = `i2' + `kvar'
			mat `bx' = `at'[1,`i1'..`i2']
			mat colnames `bx' = `dvarlist'
			mat score double `xb' = `bx' `if'
			if `hetprobit' {
				local j1 = `j2' + 1
				local j2 = `j2' + `khvar'
				mat `bz' = `at'[1,`j1'..`j2']
				mat colnames `bz' = `hvarlist'
				mat score double `s' = `bz' `if'
				qui replace `s' = exp(`s') `if'
				qui replace `s' = max(`s',c(epsdouble)) `if'

				qui replace `xbs' = `xb'/`s'
				qui replace `f' = normalden(`xbs')/`s' `if'
			}
			else {
				local xbs `xb'
				scalar `s' = 1
				qui replace `f' = normalden(`xb') `if'
			}
			qui replace `del' = `depvar'-`p`j'' `if'
			qui replace `pp' = `p`j''*(1-`p`j'') `if'
			qui replace `pp' = max(`pp',c(epsdouble)) `if'

			qui replace `d1' = `xbs'*`del'/`s' + `f' `if'
			qui replace `d2' = `f'*(1-2*`p`j'')*`del'/`pp' `if'

			qui replace `d1' = -`f'*(`d1'+`d2')/`pp' `if'
			if `hetprobit' {
				qui replace `f' = -`f'*`xb' `if'
				qui replace `s1' = (1-`xbs'^2)*`del'+`f' `if'

				qui replace `s1' = -`f'*(`s1'-`xb'*`d2')/ ///
					`pp' `if'
				local rx : word `++kr' of `varlist'
			}
		}
		else if `logit' {
			qui replace `pp' = `p`j''*(1-`p`j'') `if'
			qui replace `pp' = c(epsdouble) `if' & `pp'<c(epsdouble)
		}
		forvalues k=1/`kvar' {
			local x : word `k' of `dvarlist'
			local dk : word `++kx' of `derivatives'
			if `logit' {
				qui replace `dk' = cond(`tj',-`iwt'`x'*`pp', ///
					0) `if'
			}
			else if `poisson' {
				qui replace `dk' = cond(`tj', ///
					-`iwt'`x'*`p`j'',0) `if'
			} 
			else if `probit' | `hetprobit' {
				qui replace `dk' = cond(`tj',`iwt'`x'*`d1', ///
					0) `if'
				if `hetprobit' {
					local dk : word `++khx' of `derivatives'
					qui replace `dk' = cond(`tj',       ///
						-`x'*(`rx'+`iwt'`xb'*`d1'), ///
						 0) `if'
				}
			}
			else qui replace `dk' = cond(`tj',-`iwt'`x',0) `if'
		}
		if `hetprobit' {
			forvalues k=1/`khvar' {
				local x : word `k' of `hvarlist'
				local dk : word `++kh' of `derivatives'

				qui replace `dk' = cond(`tj',`iwt'`x'*`s1', ///
					0) `if'

				local dk : word `++kxh' of `derivatives'
				qui replace `dk' = cond(`tj', ///
					-`iwt'`x'*`s1'/`xb',0) `if'
			}
		}
		local kx = `kx' + `kpar'
		if `probit' | `hetprobit' {
			qui drop `xb'
			if `hetprobit' {
				qui drop `s'
				local kh = `kh' + `kpar'
				local kxh = `kxh' + `kpar'
				local khx = `khx' + `kpar'
			}
		}
	}
end
exit
