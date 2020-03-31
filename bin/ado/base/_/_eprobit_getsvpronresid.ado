*! version 1.0.1  12dec2019
program _eprobit_getsvpronresid, rclass
	version 15
	syntax varlist(numeric fv ts) [pw iw fw], [icovycont(string)	/// 	
		cov(string) resids(string) touse(string)		/// 
		newresid(string) vals(string) ncuts(string) 		///
		selvar(string) storxb(string)			///
		selxb(string) newselresid(string) noCONstant OFFset(passthru)]
	tempname xb
	if "`ncuts'" == "" {
		qui probit `varlist' `resids' if `touse', asis ///
			`constant' `offset' iter(50)
		local argncuts = 1
	}
	else {
		qui oprobit `varlist' `resids' if `touse', `offset' iter(50)
		local argncuts = e(k_cat)-1
	}
	local depvar `e(depvar)'
	qui predict double `xb' if `touse', xb
	// again maybe work on using conditional residual of s on y2

	local nresids: word count `resids'
	local totp = e(k)
	tempname regat
	matrix `regat' = e(b)
	if `nresids' > 0 {
		foreach var of varlist `resids' {
			qui replace `xb' = `xb' - ///	
				_b[`depvar':`var']*`var' if `touse'
		}
		tempvar temp 
		qui gen `temp' = 0 in 1/`totp'
		qui replace `temp' = 1 in 1

		tempname scale
		qui nl getpronresid @ `temp', icovycont(`icovycont') ///
		nresids(`nresids') totp(`totp') nparameters(`totp') ///
		regat(`regat') ncuts(`argncuts') cov(`cov') storescale(`scale') 
		qui replace `xb' = `xb'*`scale'
		if "`storxb'" != "" {
			qui gen double `storxb' = `xb' if `touse'
		}
	}
	else if "`storxb'" != "" {
		qui gen double `storxb' = `xb' if `touse'
	}
	tempname btmp rcorr b bcut
	matrix `btmp' = e(b)
	fvexpand `varlist' if `touse'
	local varlist `r(varlist)'
	local w: word count `varlist'
	local w = `w' - 1
	local l = e(k)
	if ("`ncuts'" == "" & `w' > 0) & ("`constant'" != "noconstant") {
		matrix `b' = (`btmp'[1,1..`w'],`btmp'[1,`l'])
	}
	else if "`ncuts'" == "" & "`constant'" != "noconstant" {
		matrix `b' = (`btmp'[1,`l'])
	}
	else if `w' > 0 {
		matrix `b' = `btmp'[1,1..`w']
	}
	local colnamesf
	local evarlist `varlist'
	gettoken ef evarlist: evarlist
	foreach word of local evarlist {
		local colnamesf `colnamesf' `depvar':`word'
	}
	if `"`ncuts'"' == ""  & "`constant'" != "noconstant" {
		local colnamesf `colnamesf' `depvar':_cons
	}
	matrix colnames `b' = `colnamesf'	
	if `nresids' > 0 {
		local f = `w'+1
		local bl = `f' + `nresids' - 1 
		matrix `rcorr' = `btmp'[1,`f'..`bl']
	}

	if "`ncuts'" != "" & "`newresid'" != "" {
		tempname bcuts
		local f = `totp'-`ncuts'+1
		matrix `bcuts' = `btmp'[1,`f'..`totp']
		tempvar condmean
		qui gen double `condmean' = 0 if `touse'
		local scale = 1
		local upper (`bcuts'[1,1] - `xb' - `condmean'*2)/`scale'
		qui gen double `newresid' = `condmean' - 		///
			`scale'*normalden(`upper')/normal(`upper') 	///
			if `depvar' == `vals'[1,1] & `touse'
		local j = `ncuts'
		forvalues i = 2/`j' {
			local lower (`bcuts'[1,`i'-1] - `xb' - ///
				`condmean'*2)/`scale'
			local upper (`bcuts'[1,`i'] - `xb' - ///
				`condmean'*2)/`scale'
			qui replace `newresid' = `condmean' +	/// 
				`scale'*(normalden(`lower')	///
				- normalden(`upper'))/		///
				(normal(`upper')		///  
				- normal(`lower'))		///
				if `depvar' == `vals'[1,`i'] & `touse'
		}
		local lower (`bcuts'[1,`ncuts'] - `xb' - `condmean'*2)/`scale'
		qui replace `newresid' = `condmean' + `scale'*	///
			normalden(`lower')/normal(-`lower') if ///
				`depvar' == `vals'[1,`j'+1] & `touse'
		local ncutsnames
		forvalues i = 1/`ncuts' {
			local ncutsnames `ncutsnames' cut`i':_cons
		}
		matrix colnames `bcuts'= `ncutsnames'
		return matrix cut = `bcuts'
	}
	else if "`newresid'" != "" {
		qui gen double `newresid' = -normalden(`xb')/normal(-`xb') ///
			if `depvar'==0 & `touse'
		qui replace `newresid' = normalden(`xb')/normal(`xb')	/// 
			if `depvar'==1 & `touse'
	}
	else if "`ncuts'" != "" {
		tempname bcuts
		local f = `totp'-`ncuts'+1
		matrix `bcuts' = `btmp'[1,`f'..`totp']
		local ncutsnames
		forvalues i = 1/`ncuts' {
			local ncutsnames `ncutsnames' cut`i':_cons
		}
		matrix colnames `bcuts'= `ncutsnames'
		return matrix cut = `bcuts'
	}
	if "`ncuts'" != "" & "`newselresid'" != "" {
		local selind 1
		qui gen double `newselresid' = .
		tempname bcuts
		local f = `totp'-`ncuts'+1
		matrix `bcuts' = `btmp'[1,`f'..`totp']
		//depvar = lowest & selvar == 0
		tempvar ttouse
		tempname r
		qui gen `ttouse' = `depvar' == `vals'[1,1] & ///
			`selvar' == 0 & `touse'
		scalar `r' = `rcorr'[1,`selind']
		local l1 -.
		local u1 (`bcuts'[1,1] - `xb')
		local l2 -.
		local u2 (-`selxb')
		qui ffm, l1(`l1') u1(`u1') l2(`l2') u2(`u2')	/// 
			touse(`ttouse') newresid(`newselresid') r(`r')
		drop `ttouse'
		//depvar = lowest & selvar == 1
		tempvar ttouse
		qui gen `ttouse' = `depvar' == `vals'[1,1] & ///
			`selvar' == 1 & `touse'
		local l1 -.
		local u1 (`bcuts'[1,1] - `xb')
		local l2 (-`selxb')
		local u2 +.
		qui ffm, l1(`l1') u1(`u1') l2(`l2') u2(`u2')	/// 
			touse(`ttouse') newresid(`newselresid') r(`r')
		drop `ttouse'
		local j = `ncuts'
		forvalues i = 2/`j' {
			//selvar == 0
			tempvar ttouse
			qui gen `ttouse' = `depvar' == `vals'[1,`i'] & ///
				`selvar' == 0 & `touse'
			local l1 (`bcuts'[1,`i'-1] - `xb')
			local u1 (`bcuts'[1,`i'] - `xb')
			local l2 -.
			local u2 (-`selxb')
			qui ffm, l1(`l1') u1(`u1') l2(`l2') u2(`u2')	/// 
				touse(`ttouse') newresid(`newselresid') r(`r')
			drop `ttouse'
			//selvar == 1
			tempvar ttouse
			qui gen `ttouse' = `depvar' == `vals'[1,`i'] & ///
				`selvar' == 1 & `touse'
			local l1 (`bcuts'[1,`i'-1] - `xb')
			local u1 (`bcuts'[1,`i'] - `xb')
			local l2 (-`selxb')
			local u2 +.
			qui ffm, l1(`l1') u1(`u1') l2(`l2') u2(`u2')	/// 
				touse(`ttouse') newresid(`newselresid') r(`r')
			drop `ttouse'
		}
		//selvar == 0
		tempvar ttouse
		qui gen `ttouse' = `depvar' == `vals'[1,`j'+1] & ///
			`selvar' == 0 & `touse'
		local l1 (`bcuts'[1,`ncuts'] - `xb')
		local u1 +.
		local l2 -.
		local u2 (-`selxb')
		qui ffm, l1(`l1') u1(`u1') l2(`l2') u2(`u2')	/// 
			touse(`ttouse') newresid(`newselresid') r(`r')
		drop `ttouse'
		//selvar == 1
		tempvar ttouse
		qui gen `ttouse' = `depvar' == `vals'[1,`j'+1] & ///
			`selvar' == 1 & `touse'
		local l1 (`bcuts'[1,`ncuts'] - `xb')
		local u1 +.
		local l2 (-`selxb')
		local u2 +.
		qui ffm, l1(`l1') u1(`u1') l2(`l2') u2(`u2')	/// 
			touse(`ttouse') newresid(`newselresid') r(`r')
		drop `ttouse'
	}
	else if "`newselresid'" != "" {
		local selind 1
		qui gen double `newselresid' = .
		//depvar == 0 & selvar == 0
		tempvar ttouse
		tempname r
		scalar `r' = `rcorr'[1,`selind']
		local l1 -.
		local u1 (-`xb')
		local l2 -.
		local u2 (-`selxb')
		qui gen byte `ttouse' = `depvar' == 0 & `selvar' == 0
		qui ffm, l1(`l1') u1(`u1') l2(`l2') u2(`u2')	/// 
			touse(`ttouse') newresid(`newselresid') r(`r')
		drop `ttouse'
		//resid for selvar under 0 and selvar 0
		//replace `selresid' = `f2ml' - `f2mu' +	/// 	
		//	`r'*`f1ml' - `r'*`f1mu' if `ttouse'
		//depvar == 0 & selvar == 1
		tempvar ttouse
		local l1 -.
		local u1 (-`xb')
		local l2 (-`selxb')
		local u2 +.
		qui gen byte `ttouse' = `depvar' == 0 & `selvar' == 1
		qui ffm, l1(`l1') u1(`u1') l2(`l2') u2(`u2')	/// 
			touse(`ttouse') newresid(`newselresid') r(`r')
		//depvar == 1 & selvar == 0
		drop `ttouse'
		local l1 (-`xb')
		local u1 +.
		local l2 -.
		local u2 (-`selxb')
		qui gen byte `ttouse' = `depvar' == 1 & `selvar' == 0
		qui ffm, l1(`l1') u1(`u1') l2(`l2') u2(`u2')	/// 
			touse(`ttouse') newresid(`newselresid') r(`r')
		//depvar == 1 & selvar == 1
		tempvar ttouse
		local l1 (-`xb')
		local u1 +.
		local l2 (-`selxb') 
		local u2 +.
		qui gen byte `ttouse' = `depvar' == 1 & `selvar' == 1
		qui ffm, l1(`l1') u1(`u1') l2(`l2') u2(`u2')	/// 
			touse(`ttouse') newresid(`newselresid') r(`r')
		drop `ttouse'
	}
	return matrix b = `b'
	if `nresids' > 0 {
		return matrix corr = `rcorr'
	}
end

program fm
syntax, y(string) fm(string) fullf(string) r(string) ///
	l(string) u(string) touse(string)
	local lb normal((`l'-`r'*`y')/sqrt(1-(`r'^2)))
	local ub normal((`u'-`r'*`y')/sqrt(1-(`r'^2)))
	if "`l'" == "-." {
		local lb 0
	}
	if "`u'" == "+." {
		local ub 1
	}
	if "`y'" == "+." {
		qui gen double `fm' = 1 if `touse'
	}
	else if "`y'" == "-." {
		qui gen double `fm' = 0 if `touse'
	}
	else {
		qui gen double `fm' = (1/(sqrt(2*_pi)))*exp(-(1/(2*(1-	///
			(`r'^2))))*((`y'^2) -(`r'*`y')^2))*		///
			(`ub' - `lb')/	///
			`fullf' if `touse'
	}
end

program ffm
syntax, l1(string) u1(string) l2(string) u2(string) ///
	r(string) touse(string) newresid(string)
	tempvar fullf f1ml f1mu f2ml f2mu
	local pt = 1
	if "`l1'"=="-." & "`u1'"=="+." & "`l2'"=="-." & "`u2'"=="+." {
		qui gen double `fullf' = 1 if `touse'		
	}
	else if "`l1'"=="-." & "`u1'"=="+." & "`l2'"=="-." {
		qui gen double `fullf' = normal(`u2') if `touse'		
	}
	else if "`l1'"=="-." & "`u1'"=="+." & "`u2'"=="+." {
		qui gen double `fullf' = normal(-`l2') if `touse'		
	}
	else if "`l1'"=="-." & "`u1'"=="+." {
		qui gen double `fullf' = normal(`u2') - normal(`l2') if `touse'
	}
	else if "`l2'"=="-." & "`u2'"=="+." & "`l1'"=="-." {
		qui gen double `fullf' = normal(`u1') if `touse'		
	}
	else if "`l2'"=="-." & "`u2'"=="+." & "`u1'"=="+." {
		qui gen double `fullf' = normal(-`l1') if `touse'		
	}
	else if "`l2'"=="-." & "`u2'"=="+." {
		qui gen double `fullf' = normal(`u1') - normal(`l1') if `touse'
	}
	else if "`l2'"=="-." & "`u1'" == "+." {
		qui gen double `fullf' = binormal(`u2',-`l1',-`r') if `touse'
		tempvar bebop
		local c (1/sqrt(1-(`r'^2)))
		qui replace `newresid' = (normalden(`l1')*normal(	///
			(`u2'-`r'*`l1')*`c')-`r'*normalden(`u2')*(1-	///
			normal((`l1'-`r'*`u2')*`c')))/`fullf' if `touse'
		local pt = 0
	}
	else if "`l2'"=="-." & "`l1'" == "-." {
		qui gen double `fullf' = binormal(`u2',`u1',`r') if `touse'
		local c (1/sqrt(1-(`r'^2)))
		qui replace `newresid' = (-normalden(`u1')*normal(	///
			(`u2'-`r'*`u1')*`c')				///
			-`r'*normalden(`u2')*normal(			///
			(`u1'-`r'*`u2')*`c'))/`fullf' if `touse'
		local pt = 0
	}
	else if "`l2'"=="-." {
		qui gen double `fullf' = binormal(`u2',`u1',`r') - ///
			binormal(`u2',`l1',`r') if `touse'
	}
	else if "`u2'"=="+." & "`u1'" == "+." {
		//a < x, b < y
		//-x < -a, -y < -b
		qui gen double `fullf' = binormal(-`l2',-`l1', `r') if `touse'
		local c (1/sqrt(1-(`r'^2)))
		replace `newresid' = (normalden(-`l1')*	///
			normal(((-`l2')-`r'*(-`l1'))*`c')	///
			+`r'*normalden(-`l2')*normal(	///
			((-`l1')-`r'*(-`l2'))*`c'))/`fullf' if `touse'		
		local pt = 0
	}
	else if "`u2'"=="+." & "`l1'" == "-." {
		// take out 1 minus stuff
		//a1 = u2, so 
		//a2 = l2, b1 = u1
		//and we want expectation for y2
		qui gen double `fullf' = binormal(`u1',-`l2',-`r') if `touse'
		local c (1/sqrt(1-(`r'^2)))
		qui replace `newresid' = (-normalden(`u1')*(1-normal(	///
			(`l2'-`r'*`u1')*`c'))+`r'*normalden(`l2')*	///
			(normal((`u1'-`r'*`l2')*`c')))/`fullf' if `touse'
		local pt = 0
	}
	else if "`u2'"=="+." {
		//a < x, b < y < c
		// -x < -a, b < y < c
		qui gen double `fullf' = binormal(`u1',-`l2',-`r') - ///
			binormal(`l1',-`l2',-`r') if `touse'
		tempvar blurb
		qui gen double `blurb' = binormal(`u1',-`l2',-`r') - ///
			binormal(`l1',-`l2',-`r')
		local r (-`r')
		local u2 (-`l2')
		local l2 -.
	}
	else if "`l1'"=="-." & "`u2'" == "+." {
		qui gen double `fullf' = binormal(`u1',-`l2',-`r') if `touse'
		local c (1/sqrt(1-(`r'^2)))
		qui replace `newresid' = (normalden(`l2')*normal(	///
			(`u1'-`r'*`l2')*`c')-`r'*normalden(`u1')*(1-	///
			normal((`l2'-`r'*`u1')*`c')))/`fullf' if `touse'
		local pt = 0
	}
	else if "`l1'"=="-." & "`l2'" == "-." {
		qui gen double `fullf' = binormal(`u1',`u2',`r') if `touse'
		local c (1/sqrt(1-(`r'^2)))
		qui replace `newresid' = normalden(`u1')*normal( ///
			(`u2'-`r'*`u1')*`c')			 ///
			`r'*normalden(`u2')*normal(		 ///
			(`u1'-`r'*`u2')*`c') if `touse'
		local pt = 0
	}
	else if "`l1'"=="-." {
		qui gen double `fullf' = binormal(`u1',`u2',`r') - ///
			binormal(`u1',`l2',`r') if `touse'
	}
	else if "`u1'"=="+." & "`u2'" == "+." {
		qui gen double `fullf' = binormal(-`l2',-`l1', `r') if `touse'
	}
	else if "`u1'"=="+." & "`l2'" == "-." {
		qui gen double `fullf' = binormal(-`l1',`u2',-`r') if `touse'
		tempvar bebop
		local pt = 0
	}
	else if "`u1'"=="+." {
		qui gen double `fullf' = binormal(`u2',-`l1',-`r') - ///
			binormal(`l2',-`l1',-`r') if `touse'
	}
	else {
		qui gen double `fullf' = binormal(`u2',`u1',`r')	/// 	
			- binormal(`u2',`l1',`r')			///
			- binormal(`u1',`l2',`r')			///
			+ binormal(`l1',`l2',`r') if `touse'
	}
	if `pt' {
		fm, y(`l1') fm(`f1ml') fullf(`fullf') r(`r') ///
			l(`l2') u(`u2') touse(`touse')
		fm, y(`u1') fm(`f1mu') fullf(`fullf') r(`r') ///
			l(`l2') u(`u2') touse(`touse')
		fm, y(`l2') fm(`f2ml') fullf(`fullf') r(`r') ///
			l(`l1') u(`u1') touse(`touse')
		fm, y(`u2') fm(`f2mu') fullf(`fullf') r(`r') ///
			l(`l1') u(`u1') touse(`touse')
		qui replace `newresid' = `f1ml' - `f1mu' +	/// 	
			`r'*`f2ml' - `r'*`f2mu' if `touse'
	}
end
exit
