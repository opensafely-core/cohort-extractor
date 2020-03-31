*! version 6.1.9  20dec2004
program define tabodds_7, rclass sort
	version 6, missing

	local baopts /*
		*/ ADJust(string) BASE(string) Binomial(string) CIplot /*
		*/ COrnfield Level(cilevel) OR Woolf TB 

	local gropts Graph L1title(string) * 

	syntax varlist(min=1 max=2) [if] [in] [fweight] /*
		*/ [, `baopts' `gropts' ]

	if "`graph'"=="" {
		cap noi syntax varlist(min=1 max=2) [if] [in] [fweight] /*
		*/ [, `baopts' ]
		if _rc { 
			di in red /*
	*/ "(option is invalid or you need to specify graph option, too)"
			exit _rc
		}
	}
	local baopts
	local gropts

	if "`adjust'"!=""  {
		if "`graph'"!="" {
			noi di in red /*
			*/ " graph not allowed with adjust() option"
				exit 198
		}
		if "`ciplot'"!="" {
			noi di in red /*
			*/ "ciplot not allowed with adjust() option"
				exit 198
		}
		if "`cornfield'"!="" {
			noi di in red /*
			*/ " cornfield not allowed with adjust() options"
				exit 198
		}
		if "`woolf'"!="" {
			noi di in red /*
			*/ " woolf not allowed with adjust() options"
				exit 198
		}
		if "`tb'"!="" {
			noi di in red /*
			*/ " tb not allowed with adjust() options"
				exit 198
		}
		if "`exp'"!="" {
			local wtopt "[fw `exp']"
		}
		if "`binomial'"!="" {
			local binopt "bin(`binomial')"
		}
		if "`base'"!="" {
			local baseopt "base(`base')"
		}
		tab_or `varlist' `if' `in' `wtopt', `baseopt' /*
			*/ `binopt' adj(`adjust') level(`level') 
		ret scalar p_trend  = r(chi2_p)
         	ret scalar chi2_tr  = r(chi2)
		exit
	}
	if "`or'"!="" & "`woolf'"=="" & "`cornfield'"=="" & "`tb'"=="" { 
		if "`graph'"!="" {
			noi di in red /*
			*/ " graph not allowed with (or) option"
				exit 198
		}
		if "`ciplot'"!="" {
			noi di in red /*
			*/ "ciplot not allowed with (or) option"
				exit 198
		}
		tempvar adjust
		gen int `adjust'=1
		if "`exp'"!="" {
                        local wtopt "[fw `exp']"
                }
                if "`binomial'"!="" {
                        local binopt "bin(`binomial')"
                }
		if "`base'"!="" {
			local baseopt "base(`base')"
		}
                tab_or `varlist' `if' `in' `wtopt', `baseopt' /*
                        */ `binopt' adj(`adjust') level(`level') noadj
                local homonly=1
        }
	marksample touse, strok
	tokenize `varlist'
	local myd `1'
	cap confirm numeric var `1'
	if _rc~=0 {
		noi di in red "nonnumeric variable `1' not allowed"
		exit 198
	}

	if "`2'"!=""{
		capture confirm string variable `2'
		if _rc==0 {
			noi di in red "nonnumeric variable `2' not allowed"
			exit 198
		}
		else { local xp `2' }
	}
	else {
		tempvar one
		qui gen int `one'=1
		local xp `one'
	}
	

	* checks that weight and binomial are not both present
	if "`binomial'"!="" & "`weight'"!="" {
	        di in re "weight not allowed with binomial frequency records"
	        exit 198
        }

	/* checks whether the response variable is coded 0/1 for individual 
		or frequency records */
	tempvar h
	if "`binomial'" == "" {
		capture assert `myd'==0 | `myd'==1 if `touse'
		if _rc~=0 {
			di in re "response `myd' not coded 0/1"
			exit 198
		}
		qui gen int `h'= 1-`myd'
	}
	else {
		qui gen int `h' = `binomial' - `myd' 
	}
	local citype
	if "`woolf'"!="" | "`cornfield'"!="" | "`tb'"!="" { 
		local citype="`woolf' `cornfield' `tb'"
		local wrdcnt: word count `citype'
		if `wrdcnt'>1 {
			di in re /*
			*/ "only one of woolf, cornfield, and tb options allowed"
			exit 198
		}
	/* 
		else if "`cornfield'"!="" {
			local citype
		}
	
		else local citype="`woolf'`tb'`cornfield'"
	*/
	}
		
	if "`or'"=="" {
		if "`citype'"!="" {
			di in re "`citype' option only valid with OR"
			exit 198
		}
		if "`base'"!=""  {
			di in re "base() option only valid with OR"
			exit 198
		}
	}
	if "`or'"!="" {
		if "`2'"=="" {
			di in re /*
			*/ "OR not valid without categorical variable (xvar)"
			exit 198
		}
		else if "`base'"=="" {
			sum `xp' if `touse', meanonly
			local base=r(min)
		}
	}
	local l1=`level'
	local level = `level'*0.005 +0.50

	* sets frequency weights
	tempvar W
	qui gen long `W' = 1
	if "`weight'"!="" {
		qui qui replace `W' `exp'
	}

	quietly {
		tempvar order d
		gen int `order'=_n
		gen int `d' = `myd' * `W' if `touse'
		replace `h' = cond(`touse'==1,`h' * `W',.) 
		drop `W'	
		sort  `touse' `xp'
		by  `touse' `xp' : replace `d' = sum(`d') 
		by  `touse' `xp' : replace `h' = sum(`h') 

		tempvar last
		qui by `touse' `xp': gen byte `last'=1 if _n==_N & `touse'

		tempvar odds efac ci_low ci_high   
		by `touse' `xp': gen double `odds' = `d'[_N]/`h'[_N] if `touse'
		by `touse' `xp': gen double `efac' = /*
		*/ exp(invnorm(`level')*sqrt(1/`d'[_N]+1/`h'[_N])) if `touse'
		gen double `ci_low'=`odds'/`efac'  if `touse'
		gen double `ci_high'=`odds'*`efac'  if `touse'
		drop `efac'
		if "`or'"!="" & "`homonly'"=="" {
			tempvar mor ma mb mc md
			local cit="Cornfield"
			if trim("`citype'")=="woolf" { local cit = "Woolf" } 
			if trim("`citype'")=="tb" { local cit = "test based" } 
			by `touse' `xp': gen int `ma' = `d'[_N] if `touse'
			by `touse' `xp': gen int `mb' = `h'[_N] if `touse'
			sum `ma' if `touse' & `xp'==`base',mean
			gen int `mc'=r(mean)	if `touse'
			sum `mb' if `touse' & `xp'==`base',mean
			gen int `md'=r(mean)	if `touse'
			local cil `=string(`l1')'
			local cil `=length("`cil'")'
			local spaces "      "
			if `cil' == 4 {
				local spaces "    "
			}
			else if `cil' == 5 {
				local spaces "   "
			}
			noi di _n in smcl in gr "{hline 12}{c TT}{hline 61}"
			noi di in smcl in gr _col(12) /*
			*/ " {c |}" _col(45)  "odds           `cit'" 
			noi di in smcl in gr %10s abbrev("`2'",9) /*
			*/ "  {c |}      cases     " /*
			*/ "controls      ratio`spaces'[`l1'% Conf. Interval]"
			noi di in smcl in gr "{hline 12}{c +}{hline 61}"
			local label: value label `2'
			local i 1
			while `i'<=_N {
				if `last'[`i']==1 {
					local aa=`ma'[`i']
					local bb=`mb'[`i']
					local cc=`mc'[`i']
					local dd=`md'[`i']

					cci `aa' `bb' `cc' `dd' , /*
					*/ `citype' level(`l1') `exact'
					if "`label'"!="" {
						local x=`2'[`i']
						local labx: label `label' `x' 32
						local labx = /* 
						*/ abbrev(`"`labx'"',9)
					}
					else local labx : di %9.0g `2'[`i']
					local lng=12-length("`labx'")
					noi di in smcl in gr /*
					*/ _col(`lng') "`labx'" /*
					*/ in gr " {c |}  "  in ye %9.0g /*
					*/ `d'[`i'] "    " %9.0g  `h'[`i']  /*
					*/ "  " %9.5f r(or) " " /*
					*/ "     " %9.5f r(lb_or)   /*
					*/ " " %9.5f r(ub_or) 
				}
				local i=`i'+1
			}
			noi di in smcl in gr "{hline 12}{c BT}{hline 61}"
		}
		summ `xp' [fweight = `d'] if `last'==1, meanonly
		tempname md mh nd nh nt het 
		scalar `md' = r(mean)
		scalar `nd' = r(N)
		summ `xp' [fweight = `h'] if `last'==1, meanonly
		scalar `mh' = r(mean)
		scalar `nh' = r(N)
		scalar `nt' = `nd' + `nh'
		tempvar n
		gen int `n' = `d' + `h' if `touse'
		/* do this for trend */ 
		tempname v chitr ptrend 
		summ `xp' [fweight = `n'] if `last'==1
		scalar `v' = _result(4)*`nt'/(`nd'*`nh')
		scalar `chitr' = (`md' - `mh')^2/`v'
		scalar `ptrend' = chiprob(1,`chitr')
	
		/* test of homogeneity */	
		tempvar e
		gen double `e'=`nd'*`n'/`nt' if `last'==1
		replace `e'=(`d'-`e')*(`d'-`e')/`n' if `last'==1
		replace `e'=sum(`e') if `last'
		gen double `het' = `e'[_N] * `nt'*(`nt'-1)/(`nd'*`nh') 
		
	}

	if "`2'"!="" {
		 if "`l1title'"=="" {
                        local l1title "Odds"
		}
		if "`ciplot'"!="" {
 			graph7 `odds' `ci_low' `ci_high' /*
			*/ `xp' if `last'==1, c(lII) l1(`"`l1title'"') `options'
		}
 		else if  "`graph'"!="" {
 			graph7 `odds' `xp' if `last'==1, /*
			*/ c(l) l1(`"`l1title'"') `options'
		}
 	}
	*di in gr _n "table of cases (D), controls (H), and odds (D/H)"
	local i 1
	if "`2'"!="" & "`or'"=="" {
		di _n in smcl in gr "{hline 12}{c TT}{hline 61}"
		di in smcl in gr %10s abbrev("`2'",9) "  {c |}      cases     " /*
		*/ "controls       odds      [`l1'% Conf. Interval]"
		di in smcl in gr "{hline 12}{c +}{hline 61}"
		local label: value label `2'

		while `i'<=_N {
			local lst=`last'[`i']
			if `lst'==1 {
				if "`label'"!="" {
					local x=`2'[`i']
					local labx: label `label' `x' 32
					local labx = abbrev(`"`labx'"',9)
				}
				else local labx : di %9.0g `2'[`i']
				local lng=12-length("`labx'")
				noi di in smcl in gr _col(`lng') "`labx'" /*
				*/ in gr " {c |}  "  in ye %9.0g `d'[`i'] /*
				*/"    " %9.0g  `h'[`i']  /*
				*/ "  " %9.5f `odds'[`i'] " " /*
				*/ "     " %9.5f `ci_low'[`i']   /*
				*/ " " %9.5f `ci_high'[`i'] 
			}
			local i=`i'+1
		}
		di in smcl in gr "{hline 12}{c BT}{hline 61}"
	}
	else if "`or'"=="" {
		di _n in smcl in gr _dup(2) " " " " "{hline 61}"
		di in gr _col(2) "        cases     " /*
		*/ "controls       odds      [`l1'% Conf. Interval]"
		di in smcl in gr _dup(2) " " " " "{hline 61}"
		while `i'<=_N {
			local lst=`last'[`i']
			if `lst'==1 {
				noi di _col(2) "    " /*
				*/ in gr in ye %9.0g `d'[`i'] /*
				*/"    " %9.0g  `h'[`i']  /*
				*/ "  " %9.5f `odds'[`i'] " " /*
				*/ "     " %9.5f `ci_low'[`i']   /*
				*/ " " %9.5f `ci_high'[`i'] 
			}
			local i=`i'+1
		}
		di in smcl in gr _dup(2) " " " " "{hline 61}"
	}
	if "`homonly'"=="" & "`2'"=="" {
		ret scalar ub_odds  =  `ci_high'[_N]
		ret scalar lb_odds =  `ci_low'[_N]
		ret scalar odds =  `odds'[_N]
		*ret scalar controls  = `h'[_N]
		*ret scalar cases  = `d'[_N]
	}
	sort `order'

	if "`2'"!=""  {
		qui count if `last'==1
		local df=r(N)-1
		di in gr  "Test of homogeneity (equal odds): " /*
		*/ in gr "chi2(" in ye `df' in gr ")  = " /*
		*/ in ye %8.2f  `het' 
		local y 35
		if `df'>=10 { local y=36 }
		if `df'>=100 { local y=37 }
		di _col(`y') in gr "Pr>chi2  = "  /*
		*/ in ye %8.4f = chiprob(`df', `het') 
		ret scalar p_hom = chiprob(`df', `het')
		ret scalar df_hom = `df'
		ret scalar chi2_hom = `het'
	
		di in gr _n  "Score test for trend of odds:     " /*
		*/ in gr "chi2(" in ye "1" in gr ")  = " /*
		*/ in ye %8.2f  `chitr' 
		local y 35
		if `ptrend'>=10 { local y=36 }
		if `ptrend'>=100 { local y=37 }
		di _col(`y') in gr "Pr>chi2  = "  /*
		*/ in ye %8.4f `ptrend' 
		ret scalar p_trend =`ptrend'
		ret scalar chi2_tr = `chitr'
	}
end

