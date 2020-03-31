*! version 4.2.0  19feb2019
program define glm_6, eclass byable(recall)
	version 6.0, missing
	if replay() {
		if _by() { error 190 }
		Playback `0'
		exit
	}

	syntax varlist [if] [in] [aw fw iw] [, LEvel(cilevel) EForm /*
		*/ LTol(real -1) ITerate(int 0) /*
		*/ Family(string) Link(string) DISP(real 1) Scale(string) /*
		*/ FRVars Offset(varname numeric) LNOffset(varname numeric) /*
		*/ noCONStant INIt(varname numeric) noLOg ]


	marksample touse 		/* must be done early */

	if `"`log'"'!="" { local iflog `"*"' }
	else	local iflog "noi"

	if `"`constan'"'!="" { local cons "nocons" }
	local small 1e-6
	if `ltol'<0 { local ltol 1e-6 } /* was 1e-8 in glmr (sg22)-too small */
	if `iterate'<=0 { local iterate 50 }
/*
	Validate family and set up link indicator
	(MapFL is why touse must be resolved so soon)
*/
	MapFL `"`family'"' `"`link'"' 
	local family 	`"`r(family)'"'
	local link 	`"`r(link)'"'
	local pow 	`r(power)'
	local scale1 	`r(scale)' /* 1 for fams with default scale param 1 */
	local m 	`r(m)'
	local mfixed 	`r(mfixed)'
	local k 	`r(k)'

	local bernoul = `mfixed' & `"`m'"'=="1" /* Bernoulli dist */
	local reg = `"`family'"'=="gau" & `"`pow'"'=="1"
	if `reg' { local iterate 1 }
/*
	Values of `scale' used:
	-------------------------------------------
	"`scale'"    known scale      unknown scale
	-------------------------------------------
	"" (default)	"" => 1		"" => dispc
	dev		-1 => dispd	-1 => dispd
	x2		 0 => dispc	 0 => dispc
	#		 #		 #
	-------------------------------------------
*/
	if `"`scale'"'!="" {
		if `"`scale'"'=="x2" { local scale 0 }
		else if `"`scale'"'=="dev" { local scale -1 }
		else {
			capture confirm number `scale'
			if _rc {
				di in red "invalid scale()"
				exit 198
			}
		}
	}
	local efopt `"`eform'"'
	if `"`eform'"'!="" {
		MapEform `family' `"`link'"'
		local eform `"`r(eform)'"'
	}
 	tempvar mu eta W z V dev wt
	quietly {
		tokenize `varlist'
		local y `"`1'"'
		mac shift
/*
	Deal with missing values of binomial denominator variable (m).
*/
		if !`mfixed' { local mmiss `"`m'"' }
/*
	Offset / log offset
*/
		if `"`lnoffse'"'!="" {
			if `"`offset'"'!="" { error 198 }
			tempvar offvar
			local offstr `"ln(`lnoffse')"'
			gen double `offvar' = `offstr'
		}
		else if `"`offset'"'!="" {
			local offvar `"`offset'"'
			local offstr `"`offset'"'
		}
		if `"`offstr'"'!="" {
			local offopt `", offset `offstr'"'
		}

		markout `touse' `offvar' `mmiss'

		sum `y' if `touse'	/* purposely not weighted */
		if r(N)==0 { noisily error 2000 } 
		if r(N)==1 { noisily error 2001 }
		if r(min)==r(max) & `"`offstr'"'=="" {
			noi di _n in bl "outcome does not vary"
			exit 2000
		}

		local nobs = r(N) /* nobs reset below when fweights */
		if `"`weight'"'!="" { 
			gen double `wt' `exp' if `touse'
			if `"`weight'"'=="aweight" {
				summ `wt'
				replace `wt' = `wt'/r(mean)
			}
			else if `"`weight'"'=="fweight" {
				summ `touse' [fw=`wt'] if `touse'
				local nobs = round(r(N),1)
			}
		}
		else gen byte `wt' = `touse' if `touse'

/* check family(binomial) for sensibility of dependent variable */

	if `"`family'"'=="bin" {
		capture assert `y'>=0 if `touse'
		if _rc { 
			di in red `"dependent variable `y' has negative values"'
			exit 499
		}
		if `mfixed'==0 { 
			capture assert `m'>0 if `touse'		/* sic, > */
			if _rc { 
				di in red `"`m' has nonpositive values"'
				exit 499
			}
			capture assert `m'==int(`m') if `touse'
			if _rc {
				di in red `"`m' has noninteger values"'
				exit 499
			}
		}
		capture assert `y'<=`m' if `touse'
		if _rc {
			di in red `"`y' > `m' in some cases"'
			exit 499
		}
	}
/*
	Initialization: tolerance, iterations, mean (mu), working vectors
*/
		if `"`init'"'!="" {
			gen double `mu' = `init' if `touse'
		}
		else {
			sum `y' [aw=`wt'] if `touse'
			gen double `mu' = (`y'+r(mean))/(`m'+1)
		}
		gen double `W' = . in 1
		gen double `z' = . in 1
		gen double `V' = . in 1
		gen double `dev' = . in 1
/*
	Initialise linear predictor
*/
		if `"`link'"'!="pow" {
			if `"`family'"'=="bin" {
				if `"`init'"'=="" {
					replace `mu' = `m'*(`y'+.5)/(`m'+1) /*
					 */ if `touse'
				}
				if `"`link'"'=="l" {
					gen double `eta' = ln(`mu'/(`m'-`mu'))
				}
				else if `"`link'"'=="p" {
					gen double `eta' = invnorm(`mu'/`m')
				}
				else if `"`link'"'=="c" {
					gen double `eta' = ln(-ln(1-`mu'/`m'))
				}
				if `"`link'"'=="opo" {
					gen double `eta' = /*
					 */  cond(abs(`pow')<`small', /*
					 */ ln(`mu'/(`m'-`mu')), /*
					 */ ((`mu'/(`m'-`mu'))^`pow'-1)/`pow')
				}
			}
			if `"`family'"'=="gau" {
				gen double `eta' = `mu'
			}
			else if `"`family'"'=="poi" {
				gen double `eta' = ln(`mu')
			}
			else if `"`family'"'=="gam" {
				gen double `eta' = 1/`mu'
			}
			else if `"`family'"'=="ivg" {
				gen double `eta' = 1/`mu'^2
			}
			else if `"`family'"'=="nb" {
				gen double `eta' = -ln1p(1/(`k'*`mu'))
			}
		}
		else {
			if abs(`pow')<`small' {
				gen double `eta' =  ln(`mu')
			}
			else gen double `eta' = `mu'^`pow'
		}
/*
	Local scoring algorithm: IRLS
*/
		tempname newdev oldev Wscale
		scalar `oldev' =  0
		scalar `newdev' =  1  
		local i 1
		`iflog' di
		while abs(`newdev'-`oldev')>`ltol' & `i'<=`iterate' {
			scalar `oldev' = `newdev'
/*
	Get 1/(d(eta)/d(mu)) and iterative weights, W.
	(Up to a constant, these are the same for canonical link functions.)
	Also calculate the adjusted independent variable, z.
*/
			CalcV `touse' `y' `family' `"`link'"' `pow' `m' /*
			 */ `disp' `k' `eta' `mu' `W' `z' `V' `"`offvar'"'
/*
	Weighted regression
		`Wscale' added by wms 10 Apr 1995
*/
                        summarize `W' [aw=`wt']
                        scalar `Wscale' = r(mean)
                        regress `z' `*' [iw=`W'*`wt'/`Wscale'], mse1 `cons'
/*
	Get linear predictor
*/
			cap drop `eta'
			_predict double `eta' if `touse' 
			if `"`offstr'"'!="" { replace `eta' = `eta'+`offvar' }
/*
	Get inverse link
*/
			est local family `"`family'"'
			est local link `"`link'"'
			global S_E_fam `"`family'"'   /* double save */
			global S_E_link `"`link'"'
			_crcglil `eta' `mu' `pow' `m' `k' `bernoul'
			count if `mu'>=. & `eta' <  . & `touse'
			if r(N) != 0 {
				noi di in red "estimates diverging"
				exit 430
			}
/*
	Get weighted squared deviance contributions (residuals)
*/
			_crcgldv `y' `family' `bernoul' `m' `k' `mu' `wt' `dev'
/*
	Get deviance (note: analytic weights are already normalized).
*/
			replace `z' = sum(`dev')
			scalar `newdev' = `z'[_N]/`disp'
			`iflog' di in gr `"Iteration `i' : deviance = "' /*
			 */ in ye %9.4f `newdev'
			local i = `i'+1
		}
		local conrc = cond(abs(`newdev'-`oldev')>`ltol' & !`reg',430,0)
		if `conrc' { 
			noisily di in ye "(convergence not achieved)"
		}
/*
	Get weighted squared contributions (residuals) to Pearson X2
*/
		replace `z' = sum(`wt'*(`y'-`mu')^2/`V')
		local chisq = `z'[_N]/`disp'
		local df = `nobs'-e(df_m)-(`"`cons'"'=="")
		local dispc = `chisq'/`df'
		local dispd = `newdev'/`df'
	}
/*
	Store results
*/

	DescFL `"`family'"' `"`link'"' `pow' `bernoul' `k' `m'
	local o `"`r(dist)', `r(link)'`offopt'"'

	if `"`scale'"'=="" {	/* default */
		local scale `scale1'
		if `scale1' { local delta 1 }
		else local delta `dispc'
	}
	else if `scale'==0 {	/* Pearson X2 scaling */
		local delta `dispc'
		if `scale1' {
			local cd "square root of Pearson X2-based dispersion"
		}
	}
	else if `scale'==-1 {	/* deviance scaling */
		local delta `dispd'
		local cd "square root of deviance-based dispersion"
	}
	else {			/* user's scale parameter */
		local delta `scale'
		if !`scale1' | (`scale1' & `scale'!=1) {
			local cd `"dispersion equal to square root of `delta'"'
		}
	}
	if !`scale1' | (`scale1' & `scale'!=1) {
		if `scale1' { local dof 100000 }
		else local dof `df'
		if `delta'>=. { local zapse "yes" }
                else scalar `Wscale' = `Wscale'/`delta' /* scale to `delta' */
	} 

	tempname b V
	if `reg' {
		local dofopt `"dof(`df')"'
	}
	mat `b' = get(_b)
	mat `V' = get(VCE)
        scalar `Wscale' = 1/`Wscale'
        mat `V' = `Wscale'*`V' /* get rid of `Wscale' scaling */
	if `"`zapse'"'=="yes" { 
		local i 1
		while `i'<=rowsof(`V') {
			mat `V'[`i',`i'] = 0 
			local i=`i'+1
		}
	}
	tempvar mysamp
	qui gen byte `mysamp' = `touse'
	est post `b' `V', depname(`y') obs(`nobs') `dofopt' esample(`mysamp')

/* results can be saved now */
/* double save in S_E_ and e() */
	if `"`cd'"'!="" {
		est local msg_1 `"(Standard errors scaled using `cd')"'
		global S_E_msg1 `"(Standard errors scaled using `cd')"'
	}
	if `reg' {
		est local msg_2 "(Model is ordinary regression, use regress instead)"
		global S_E_msg2 "(Model is ordinary regression, use regress instead)"
	}
	if `disp'!=1 {
		est local msg_3 `"(Quasi-likelihood model with dispersion `disp')"'
		global S_E_msg3 `"(Quasi-likelihood model with dispersion `disp')"'
	}
	if `"`frvars'"'!="" {
		cap drop _mu
		cap drop _eta
		cap drop _dres
		gen _dres = sign(`y'-`mu')*sqrt(`wt'*`dev'/`delta') if `touse'
		rename `mu' _mu
		rename `eta' _eta
		lab var _mu `"E(`y')"'
		lab var _eta "Linear predictor"
		lab var _dres "Scaled deviance-residuals"
	}

/*
	Save results -- new  gould
*/

/* double save in S_E_ and e() (actually triple save in S_#) */
	est scalar df_pear = `df'
	est scalar N = `nobs'
	est scalar chi2 = `chisq'
	est scalar deviance = `newdev'
	est scalar dispersp = `dispc'
	est scalar dispers = `dispd'

	global S_E_rdf `df'
	global S_E_nobs `nobs'
	global S_E_chi2 `chisq'
	global S_E_dev = `newdev'
	global S_E_dc `dispc'
	global S_E_dd `dispd'

	global S_1 `nobs'
	global S_2 `df'
	global S_3 = `newdev'
	global S_4 `chisq'

/*
	Save more results (for glmrpred) -- new Royston 4/94.
*/

/* more double saves in S_E_ and e() */
	est local wtype `"`weight'"'
	est local wexp `"`exp'"'
	est local family `"`family'"'
	est local link `"`link'"'
	est local title_fl `"`o'"'
	est scalar bernoul = `bernoul'
	est local m `"`m'"'
	est local depvar `"`y'"'
	est scalar power = `pow'
	est local offset `"`offstr'"'	        /* offset/lnoffset */
	est scalar lnoffset = `"`lnoffse'"'!="" /* 1 if lnoffset, 0 otherwise */
	est local eform `"`eform'"'
	est scalar k = `k'  
	est scalar disp = `disp'
	est scalar delta = `delta'
	est scalar rc = `conrc'

	global S_E_vl `"`varlist'"'
	global S_E_if `"`if'"'
	global S_E_in `"`in'"'
	global S_E_wgt `"`weight'"'
	global S_E_exp `"`exp'"'
	global S_E_fam  `"`family'"'
	global S_E_link `"`link'"'
	global S_E_flo  `"`o'"'
	global S_E_ber  `bernoul'
	global S_E_m    `"`m'"'
	global S_E_depv `"`y'"'
	global S_E_pow  `"`pow'"'
	global S_E_off  `"`offstr'"'		/* offset/lnoffset */
	global S_E_lno  = `"`lnoffse'"'!=""	/* 1 if lnoffset, 0 otherwise */
	global S_E_ef   `"`eform'"'
	global S_E_k    `"`k'"'
	global S_E_disp `"`disp'"'
	global S_E_del  `"`delta'"'
	global S_E_rc	`conrc'

	est local predict "glm_p"
	est local cmd "glm"
	global S_E_cmd  "glm"			/* must be last */

	Playback, level(`level') `efopt'
end


program define Playback
	syntax [, LEvel(cilevel) EForm]
	if `"`e(cmd)'"'!="glm" { error 301 } 

	#delimit ;
	di _n in gr "Residual df  = " in ye %9.0g e(df_pear)
		_col(57) in gr "No. of obs = "  in ye %9.0g e(N) ;
	di in gr "Pearson X2   = " in ye %9.0g e(chi2) in gr 
		_col(57) "Deviance   = "  in ye %9.0g e(deviance) ;
	di in gr "Dispersion   = " in ye %9.0g e(dispersp) in gr
		_col(57) "Dispersion = "  in ye %9.0g e(dispers) ;
	#delimit cr

	di in gr _n `"`e(title_fl)'"' /* family, link, offset */
	if `"`eform'"'!="" {
		MapEform `e(family)' `"`e(link)'"'
		est di, level(`level') `r(eform)'
	}
	else	est di, level(`level')
	local i 1
	while `i' <= 3 {
		if `"`e(msg_`i')'"' != "" { di in gr `"`e(msg_`i')'"' }
		local i = `i' + 1
	}
	error `e(rc)'
end


program define MapEform, rclass
	args fam link 

	if `"`link'"'=="l" | `"`link'"'=="opo" { 
		local eform "eform(Odds Ratio)"
	}
	else if `"`link'"'=="p" | `"`link'"'=="c" {
		local eform "eform(ExpB)"
	}
	else if (`"`fam'"'=="poi") { local eform "eform(IRR)" }
	else local eform "eform(e^coef)"
	ret local eform `eform'
end


program define MapFL, rclass /* family link */
	args f ulink

	MapFam tocode `f'		/* map user-specified family 	*/
	local fam `"`r(famcode)'"'	/* store code in fam 		*/

	local mfixed 1
	local m 1
	local k 1
	if `"`fam'"'=="bin" {		/* bin takes an optional argument */
		tokenize `"`f'"'
		if `"`2'"'!="" {
			capture confirm integer number `2'
			if _rc {
				unabbrev `2'
				local m `"`s(varlist)'"'
				local mfixed 0
			}
			else { 
				if `2'>=. | `2'<=0 {
					di in red /*
				     */ `"`2' in family(binomial `2') invalid"'
					exit 198
				}
				local m `2'
			}
		}
	}
	if `"`fam'"'=="nb" {	/* nb takes an optional argument */
		tokenize `"`f'"'
		if `"`2'"' != "" {
			confirm number `2'
			if `2'<=0 { 
				di in red /* 
				*/ `"`2' in family(nbinomial `2') invalid"'
				exit 198
			}
			local k `2'
		}
	}



	MapLink tocode `ulink'
	local link `"`r(link)'"'
	local pow `"`r(power)'"'
		
/*
	Apply default links and then check for allowed links
		
		fam	default link	allowed links
		---------------------------------------------
		gau	pow 1		pow #
		bin	l		l, p, c, pow #, opo #
		poi	pow 0		pow #
		nb	pow 0		nb, pow #
		gam	pow -1		pow #
		ivg	pow -2		pow #

*/

	local scale1 = `"`fam'"'=="bin" | `"`fam'"'=="nb" | `"`fam'"'=="poi"

	if `"`link'"'=="" {		/* apply defaults */
		local link "pow"
		if `"`fam'"'=="gau"      { local pow 1 }
		else if `"`fam'"'=="bin" { local link "l" }
		else if `"`fam'"'=="gam" { local pow -1 }
		else if `"`fam'"'=="ivg" { local pow -2 }
		else if `"`fam'"'=="poi" { local pow 0 }
		else if `"`fam'"'=="nb"  { local pow 0 }
		else local link
/* 
comment by wwg:
	the remaining defaults are applied someplace else in the 
	code and, moreover, "family(gam)" produces the description 
	"Gamma distribution, canonical link" while the equivalent 
	"family(gam) link(pow -1)" produces 
	"Gamma distribution, power link (power = -1)".  
	This should be considered a bug.

	I would like to see all the defaults set right here.

comment by wwg:  I do not fully understand the [above] restriction and
	am not convinced it excludes all the cases it should.

response by jpr, 26-Jan-94
--------------------------
1.	I have now set up all default links arising from null user link.
2.	We already know from previous checks that `link' must be one of
	id, log, pow, opo, nb, l, c or p.  Remains to check that l, c, p
	or opo are used only with binomial family.
*/
	}
	else {				/* check valid fam/link combination */
		local binlink = `"`link'"'=="c" | `"`link'"'=="l" | /*
			*/ `"`link'"'=="p" | `"`link'"'=="opo"
		if (`"`fam'"'=="bin" & !(`binlink' | `"`link'"'=="pow")) | /*
		*/ (`"`fam'"'!="bin" & `binlink' ) {
			di in red `"link `link' invalid with family `fam'"'
			exit 198
		}
	}

* di `"returns fam |`fam'|  link |`link'|  pow |`pow'|"'
* di `"                   scale1 |`scale1'|  m |`m'|  mfixed |`mfixed'|"'

	ret local family `"`fam'"'
	ret local link   `"`link'"'
	ret local power  `pow'
	ret local scale  `scale1'
	ret local m      `m'
	ret local mfixed `mfixed'
	ret local k      `k'
end


program define MapFam, rclass /* {tocode | fromcode} <code> <ignored> ... */

	if `"`1'"'=="fromcode" { 
		di in red "MapFam fromcode not yet implemented"
		exit 9000
	}

	local s1 
	local f = lower(trim(`"`2'"'))
	local l = length(`"`f'"')
	if `"`f'"'=="" 					  { local s1 "gau" }
	else if `"`f'"'==bsubstr("binomial",1,`l') 	  { local s1 "bin" }
	else if `"`f'"'==bsubstr("bernoulli",1,`l')	  { local s1 "bin" }
	else if `"`f'"'==bsubstr("gamma",1,max(`l',3)) 	  { local s1 "gam" }
	else if `"`f'"'==bsubstr("gaussian",1,max(`l',3))  { local s1 "gau" }
	else if `"`f'"'==bsubstr("igaussian",1,max(`l',2)) { local s1 "ivg" }
	else if `"`f'"'==bsubstr("inormal",1,max(`l',2))   { local s1 "ivg" }
	else if `"`f'"'=="ivg" 				  { local s1 `"`ivg'"' }
	else if `"`f'"'==bsubstr("normal",1,`l') 	  { local s1 "gau" }
	else if `"`f'"'==bsubstr("nbinomial",1,max(2,`l')) { local s1 "nb" }
	else if `"`f'"'==bsubstr("poisson",1,`l') 	  { local s1 "poi" }
	else { 
		di in red `"unknown family() `f'"'
		exit 198
	}
	if `"`s1'"'=="bin" | `"`s1'"'=="nb" { local last 4 }
	else 	local last 3
	if `"``last''"'!="" { 
		di in red "family() invalid"
		exit 198
	}
	ret local famcode `s1'
end

/*
	Map user-specified family `f' to internal family code `fam'.
	(Capitalization indicates minimum abbreviations.)

					mapped to
		Allowed			(fam) 
		-----------------------------------
		<nothing>		gau
		Binomial		bin
		Bernoulli		bin
		GAMma			gam
		GAUssian		gau
		IGaussian		ivg
		INormal			ivg
		IVG			ivg	(for backwards compatibility)
		Normal			gau
		NBinomial		nb
		Poisson			poi
*/


program define MapLink, rclass /* {tocode | fromcode ..} <code> <coderest> ... */

	if `"`1'"'=="fromcode" { 
		di in red "MapLink fromcode not yet implemented"
		exit 9000
	}

	local ulink = lower(`"`2'"')
	local upow `"`3'"'
	if `"`4'"'!="" { 
		di in red "link() invalid"
		exit 198
	}


	local l = length(`"`ulink'"')
	local s1 "pow"		/* returned link */
	local s2 .		/* returned power if link is pow */

	if `"`ulink'"'=="" 				{ local s1 }
	else if `"`ulink'"'==bsubstr("identity",1,`l') 	{ local s2 1 }
	else if `"`ulink'"'=="log" 			{ local s2 0 }
	else if `"`ulink'"'==bsubstr("power",1,max(`l',3)) {
		capture confirm number `upow'
		if _rc {
			di in red "invalid # in link(power #)"
			exit 198
		}
		local s2 `upow'
		local upow
	}
	else if `"`ulink'"'==bsubstr("opower",1,max(`l',3)) {
		capture confirm number `upow'
		if _rc {
			di in red "invalid # in link(opower #)"
			exit 198
		}
		if `upow'==0 {
			local s1 "l"
		}
		else {
			local s1 "opo" /* short for odds-power */
			local s2 `upow'
		}
		local upow
	}
	else if `"`ulink'"'==bsubstr("logit",1,`l')	{ local s1 "l" }
	else if `"`ulink'"'==bsubstr("probit",1,`l')	{ local s1 "p" }
	else if `"`ulink'"'==bsubstr("cloglog",1,`l')	{ local s1 "c" }
	else if `"`ulink'"'==bsubstr("nbinomial",1,`l')	{ local s1 "nb" }
	else {
		di in red `"unknown link() `ulink'"'
		exit 198
	}

	if `"`upow'"'!="" { 
		di in red `"unknown 2nd argument in link(`ulink' `upow')"'
		exit 198
	}
	ret local link `s1'
	ret local power `s2'
end

/*
	Map user-specified link to internal link code.
	(Capitalization indicates minimum abbreviations.)

						mapped to
		Allowed				(link)	(pow)
		-----------------------------------------
		Identity			pow 	1
		LOG				pow 	0
		Logit				l
		Probit				p
		Cloglog				c
		POWer #				pow 	#
		OPOwer #			opo 	#
		(nothing)			<empty>	<empty>
*/


program define DescFL, rclass /* return description of family and link */
	args f l pow bernoul k m

	local s1 " distribution"
	local s2 " link"

	if `"`f'"'=="gau" { local s1 `"Gaussian (normal)`s1'"' }
	else if `"`f'"'=="bin" & `bernoul' { local s1 `"Bernoulli`s1'"' }
	else if `"`f'"'=="bin" { local s1 `"Binomial (N=`m')`s1'"' }
	else if `"`f'"'=="poi" { local s1 `"Poisson`s1'"' }
	else if `"`f'"'=="gam" { local s1 `"Gamma`s1'"' }
	else if `"`f'"'=="ivg" { local s1 `"Inverse Gaussian`s1'"' }
	else if `"`f'"'=="nb" { 
		local myk = round(`k',.0001)
		local s1 `"Negative Binomial (k=`myk')`s1'"'
	}

	if `"`l'"'=="pow" {
		if `"`pow'"'=="1" { local s2 `"identity`s2'"' }
		else if `"`pow'"'=="0" { local s2 `"log`s2'"' }
		else local s2 `"power`s2' (power = `pow')"'
	}
	if `"`l'"'=="opo" {
		if `"`pow'"'=="1" { local s2 `"identity odds-power`s2'"' }
		else if `"`pow'"'=="0" { local s2 `"logit`s2'"' }
		else local s2 `"odds-power`s2' (power = `pow')"'
	}
	else if `"`l'"'=="l"  { local s2 `"logit`s2'"' }
	else if `"`l'"'=="p"  { local s2 `"probit`s2'"' }
	else if `"`l'"'=="c"  { local s2 `"cloglog`s2'"' }
	else if `"`l'"'=="nb" { local s2 `"`s2' -ln(1 + 1/(k*mu))"' }

	ret local dist `"`s1'"'
	ret local link `"`s2'"'
end


* Update of _glmwgt (sg16.3), PR 22-Dec-93, 11-Apr-94, 11-Oct-94.
* Calculates var functn, iterative weights and working dependent variable.
program define CalcV
	args touse y fam link pow m disp k eta mu W z V moffset
	if `"`moffset'"'!="" {
		local moffset `"-`14'"'
	}
	local small 1e-6
/*
	Calculate variance function, V, for each family
*/
	tempvar w
	if `"`fam'"'=="bin" {
		replace `V' = `mu'*(1-`mu'/`m')
	}
	else if `"`fam'"'=="gam" {
		replace `V' = `mu'^2
	}
	else if `"`fam'"'=="gau" {
		replace `V' = 1
	}
	else if `"`fam'"'=="ivg" {
		replace `V' = `mu'^3
	}
	else if `"`fam'"'=="nb" {
		replace `V' = (`mu'+`k'*`mu'^2)
	}
	else if `"`fam'"'=="poi" {
		replace `V' = `mu'
	}
/*
	Calc w = 1/{d(eta)/d(mu)} and W = w^2/V for each link/family,
	where V = variance function, noting W = abs(w) for canonical links.
*/
	if `"`link'"'=="pow" {
		if abs(`pow')<`small' {
			gen double `w' = `mu'
		}
		else {
			gen double `w' = `m'^`pow'/(`pow'*`mu'^(`pow'-1))
		}
	}
	else {
		if `"`fam'"' == "bin" {
			if `"`link'"' == "l" {
				gen double `w' = `V'
			}
			else if `"`link'"' == "p" {
				gen double `w' = `m'*exp(-.5*`eta'*`eta') /*
				 */ /sqrt(2*_pi) if `touse'
			}
			else if `"`link'"' == "c" {
				gen double `w' = -`m'*(1-`mu'/`m')*log1m(`mu'/`m')
			}
			else if `"`link'"' == "opo" {
				gen double `w' = cond( abs(`pow'-1)<`small', /*
				 */ `m'*(1-`mu'/`m')^2, /*
				 */ `m'*( (`mu'/`m')^(1-`pow') )* /*
				 */ (1-`mu'/`m')^(`pow'+1) )
			}
		}
		else if `"`fam'"' == "gam" { gen double `w' = -`V' }
		else if `"`fam'"' == "ivg" { gen double `w' = -.5*`V' }
		else if `"`fam'"' == "nb"  { gen double `w' = `V' }
		else if `"`fam'"' == "poi" { gen double `w' = `V' }
	}
	replace `W' = `disp'*`w'^2/`V' /* `disp' could be in wrong place */
	replace `z' = `eta'+(`y'-`mu')/`w' `moffset' 
end
