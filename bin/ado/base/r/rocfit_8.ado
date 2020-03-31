*! version 7.1.0  01nov2017
prog def rocfit_8, eclass
	version 6, missing

	local vv : display "version " string(_caller()) ", missing:"

	if replay() {
		if `"`e(cmd)'"' != "rocfit" { error 301 } 
		syntax [, Level(cilevel) *]
	}
	else {
		syntax varlist(numeric min=2 max=2) [if] [in]  /*
	 	*/ [ fweight] [, Level(cilevel)   /*
	 	*/ FROM(string) MLMethod(string) /*
		*/ MLOpt(string) noLOG  CONTinuous(string) Generate(string) * ]
 
		marksample touse
		tempvar sample
		gen int `sample'=`touse'
		tokenize `varlist'
		local D = `"`1'"'
		local C = `"`2'"'
		local ind `"`2'"'
		local DC = `"`2'"'
		if "`from'"!="" { local iniopt init(`from') }
		if "`mlmethod'" == "" { local mlmetho  "lf" }
		if "`offset'" !="" { local offopt offset(`offset') }
		mlopts options, `options'

		cap assert `D'==0 | `D'==1 if `touse'
		if _rc~=0 {
		 	noi di in red "true status variable `D' must be 0 or 1"
			exit 198
 		}
		qui summ `D' if `touse', meanonly
		if r(min) == r(max) {
			di in red "outcome does not vary"
			exit 198
		}
		if "`log'"!="" { 
			local nlog="*" 
		}
		if "`continuous'"~="" & "`continuous'"~="." {
			if `continuous'>_N {
				di in red /*
				*/ "continuous() must be less than" /*
				*/ " or equal to the number of" /*
				*/ " observations" 
				error 198
			}		
			if `continuous' < 3 {
				di in red /*
				*/ "continuous() must be greater than" /*
				*/ " or equal to 3" 
				error 198
			}
			tempvar pct	
			qui sum `C', meanonly
			local cmax=r(max)
			local cmin=r(min)
			local A=`continuous'/(`cmax'+1-`cmin')
			local I=1-`A'*`cmin'
			qui gen long `pct'=int(`A'*`C'+`I')
			tempvar C
			qui gen `C'=`pct'
			qui drop `pct'
		}
		if "`generate'"~="" {
			if "`continuous'"=="" {
				noi di in red /*
				*/ "generate() cannot be specified without "/*
				*/ "continuous() option"
                                error 198
			}
			if "`continuous'"=="." {
				noi di in red /*
				*/ "generate() cannot be specified with " /*
				*/ "continuous(.) option; "
				noi di in red "continuous(.) requests that "/*
				*/ "class var not be grouped"
                                error 198
			}
			qui gen long `generate'=`C'
			qui compress `generate'
		}

		/* BEGIN-create freq weighted summary data */
		 if `"`weight'"' =="" {
			tempvar wv
			qui gen int `wv' = 1 if `touse'
			local nowt 1
			local weight="fweight"
		}
		else {
			tempvar wv
			qui gen double `wv' `exp'
			local nowt 0
		}
		qui inspect `C' if `touse'
		if r(N_unique)>20 & "`continuous'"=="" {
			di in red /*
			*/ "variable " abbrev("`C'",12) /*
			*/ " has over 20 unique values; " /*
			*/ "use continuous(#) to group "
			di in red /*
			*/ "into # categories " /* 
			*/ "or continuous(.) if variable is already categorical"
			exit 198
		}
		if  r(N_unique)<. & r(N_unique)>c(max_matdim)-3 {
			error 915
                }
		if r(N_unique)>=.  {
			tempvar cnt
			sort `touse' `C'
			qui by `touse' `C': gen byte `cnt' = 1 /*
						*/ if _n==1 & `touse'
			qui summ `cnt', meanonly
			if r(sum)>800 {
				di in red  /*
				*/ "`C' takes on more than 800 unique values"
				di in red "unable to estimate model;" /*
				*/  " use roctab command"			
				exit 134
			}
			drop `cnt'
		}
		tempvar newwt
		sort `touse' `D' `C'
		qui by `touse' `D' `C': gen double `newwt'=sum(`wv') if `touse'
		qui by `touse' `D' `C': replace `newwt'=. if _n~=_N
		qui replace `newwt'=. if `newwt'==0
		qui replace `touse'=0 if `newwt'>=.
		qui replace `wv'=`newwt'
		local wt=`"[fweight=`wv']"'
		tempvar MN
		sort `touse' `D' `C'
		qui by `touse' `D' : gen long `MN' = sum(`wv')
		qui by `touse' `D' : replace `MN' = `MN'[_N]
		qui replace `MN'=. if `touse'==0
		drop `newwt'
		*preserve
		*qui keep if `touse'
		/* END -create freq weighted summary data */

		/* BEGIN-get initial values */
		tempvar p  
		qui logistic `D' `C' `wt' if `touse', asis 
		tempvar b
		mat `b'=e(b)
		local bc=colsof(`b')
		if `bc'>1 {
			local coef=_b[`C']
		}
		else {
			di in green "unable to estimate model;" /*
			*/  " Use roctab command"			
			est clear
			exit	
		}
		
		qui predict double `p', p
		tempvar prob sens spec 
		qui sum `p', meanonly
		cap assert reldif(`p', r(min))<1e-12 if `p'<.
		if _rc==0 { 
			_rocsen if `touse', class(`C') genprob(`prob') /*
			*/ gensens(`sens') genspec(`spec')
		}
		else {
			qui `vv' lsens if `touse',  nograph genprob(`prob') /*
			*/ gensens(`sens') genspec(`spec')
		}
		qui replace `sens'=. if `prob'==0 | `prob'==1
		qui replace `spec'=. if `prob'==0 | `prob'==1
		qui replace `prob'=. if `sens'>=. | `spec'>=.
		sort `prob'
		qui replace `prob'=. if `sens'==1 & `spec'==0 & _n==1
		tempvar g
		qui egen `g'=group(`C') if `touse'
		qui sum `g' , meanonly 
		local max=r(max)
		local i= 1
		while `i'<`max' {
			local zv "`zv' /z`i'"			
			local nzv "`nzv' z`i'"
			local zname "`zname' Z:_cut`i'"
			local i=`i'+1
		}
		*noi di in red "`zv'"
		tempvar  zfpf ztpf ztnf
		qui gen double `ztpf'=invnorm(`sens') if `touse'
		qui gen double `zfpf'=invnorm(1-`spec') if `touse'
		qui gen double `ztnf'=invnorm(`spec') if `touse'
		if `max'>2 {
			cap qui regress `ztpf' `zfpf' 
			if _rc==0 {
				local a0 = _b[_cons]
				local b0 = _b[`zfpf']
			}
			else {
				local a0 = 1
				local b0 = 1 
			}
		}
		else {
			local a0 = 1
			local b0 = 1 
		}
		drop `ztpf' `zfpf' `sens' `spec'
		tempname bc0
		qui mat `bc0' = ( `a0', `b0')   
		qui mat colnames `bc0' = a:_cons b:_cons

		tempname ZV

		sort `prob'
		local i= 1
		while `i'<`max' {
			tempname Z
			if `ztnf'[`i'] <. {
				cap mat `Z'=(`ztnf'[`i']+`i'*1e-6)
			}
			cap mat colnames `Z' = z`i':_cons
			if `i'==1 {
				 cap mat `ZV'= `Z'
			}
			else {
			 	 cap mat `ZV'=`ZV' , `Z'
			}
			if _rc~=0 {
				local i=`max'+1
				local this 1
			}
			else { local i=`i'+1 }
		}
		drop `ztnf'
		if "`this'"~="" {
			sort `prob'
			local i= 1
			while `i'<`max' {
				if `prob'[`i']>=. {
					qui replace `prob'=0.9 if _n==`i'
				}
				tempname Z
				qui mat `Z'=(invnorm(`prob'[`i']))
				qui mat colnames `Z' = z`i':_cons
				qui mat `bc0'=`bc0' , `Z'
				local i=`i'+1
			}
		}
		else {
			qui mat `bc0'=`bc0' , `ZV'
		}
		if `coef'<0 {
			local tel=colsof(`bc0')
			tempname telm 
			qui mat `telm'=(-`bc0'[1,1], `bc0'[1,2])
			qui mat colnames `telm' = a:_cons b:_cons
			local j 1
			local i=`tel'
			while `i' >2 {
				tempname telc
				mat `telc' =  -`bc0'[1,`i']
				qui mat colnames `telc' = z`j':_cons
				local i=`i'-1
				local j=`j'+1
				mat `telm'= `telm', `telc'
			}
			mat `bc0'= `telm'
		}	
	 	/* noi mat l `bc0' */
		`nlog' di _n in gr "Fitting binormal model:"
		global MD `D'
		global MC `g'
		global ZV `nzv'
		tempvar  p
		qui gen double `p'=.
		global MP `p'
		sort `D' `C'
		ml model `mlmethod' rocf_lf /*
			*/  (a: `D' `C'  =  )  /*
			*/  /b `zv' `wt' if `touse', /*
			*/ `robust' `cluopt' `scopt' init(`bc0') `mlopt' /*
			*/ missing collin nopreserve  /*
			*/ max search(off) `log' `options' 
		global MD
		global MC
		global ZV 
		tempname B
		qui mat `B'=e(b)
		local a = `B'[1,1]
		local b = `B'[1,2]
		mat colnames `B' = :intercept :slope `zname'
		tempname x2 df
		tempvar num
		qui gen double `num'= /*
		*/ (`MN'/$MP)*(($MP - `wv'/`MN')^2) if `touse'
		qui replace `num'=sum(`num')
		scalar `x2'=`num'[_N]	
		scalar `df'=`max'-3	
		est scalar chi2_gf=`x2' 
		est scalar df_gf=`df' 
		est scalar p_gf=chiprob(`df',`x2') 
		est local chi2type="GOF"
		est repost b=`B' , rename esample(`sample')
		if `nowt'==1 {
			est local wtype
			est local wexp 
		}
		else {
			if "`e(wtype)'" != "" {
				est local wexp `"`exp'"'
			}
		}
		ROCInd `level'
		est local title  = "Binormal model of "+abbrev("`D'",12)+ /*
			*/ " on " + abbrev("`ind'",12)
		est local predict _no_predict
		est local depvar "`D' `DC'"
		est local cmd rocfit 
		est scalar area =`s(area)'
		est scalar se_area =`s(se_area)'
		est scalar deltam =`s(deltam)'
		est scalar se_delm =`s(se_delm)'
		est scalar de =`s(de)'
		est scalar se_de =`s(se_de)'
		est scalar da =`s(da)'
		est scalar se_da =`s(se_da)'
		est scalar neg=`MN'
		est scalar pos=e(N)-`MN'
		global MP 
	}
	di _n in gr `"`e(title)'"' _col(51) in gr "Number of obs" /*
	*/ _col(67) "= " in ye %10.0g e(N)
	di in gr "Goodness-of-fit chi2(" in ye "`e(df_gf)'" /*
	*/ in gr ") =  " in ye %10.2f e(chi2_gf)
	di in gr "Prob > chi2             =  " in ye %10.4f e(p_gf)
	di in gr "Log likelihood          =  " in ye %10.0g e(ll) 
	DISTab1 `level' 
	DISTab2 `level'
end

program define ROCInd, sclass
	/* program to calculated indices */
	args level
	tempname B V Z a b va vb vab 
	mat `B'=e(b)
	mat `V'=e(V)
	scalar `a' = `B'[1,1]
	scalar `b' = `B'[1,2]
	scalar `va'=`V'[1,1]
	scalar `vb'=`V'[2,2]
	scalar `vab'=`V'[1,2]
	scalar `Z'=`a'/sqrt(1+`b'^2)
	local alpha=invnorm(.5+`level'/200)
	/* AREA */
	tempname ga gb ase area delta de da
	scalar `area'=normprob(`Z')
	scalar `ga'=normd(`Z')*(1/sqrt(1+`b'^2))
	scalar `gb'=normd(`Z')*(-`a'*`b')/((1+`b'^2)^(3/2))
	scalar `ase'=(`ga'^2)*(`va')+(`gb'^2)*(`vb') + 2*`ga'*`gb'*`vab'
	scalar `ase'=sqrt(`ase')
	sret local se_area = `ase' 
	sret local area = `area' 
	/* DELTA M */
	scalar `delta' = `a'/`b'
	scalar `ga'=1/`b'
	scalar `gb'=-`a'/(`b'^2)
	scalar `ase'=(`ga'^2)*(`va')+(`gb'^2)*(`vb') + 2*`ga'*`gb'*`vab'
	scalar `ase'=sqrt(`ase')
	sret local se_delm = `ase' 
	sret local deltam = `delta' 
	/* DE Line  */
	scalar `de' = 2*`a'/(`b'+1)
	scalar `ga'=2/(`b'+1)
	scalar `gb'=-2*`a'/((`b'+1)^2)
	scalar `ase'=(`ga'^2)*(`va')+(`gb'^2)*(`vb') + 2*`ga'*`gb'*`vab'
	scalar `ase'=sqrt(`ase')
	sret local se_de = `ase' 
	sret local de = `de' 
	/* DA Line  */
	scalar `da' = sqrt(2)*invnorm(`area')
	scalar `ga'=sqrt(2)/sqrt(1+`b'^2)
	scalar `gb'=-sqrt(2)*`a'*`b'/sqrt((1+`b'^2)^3)
	scalar `ase'=(`ga'^2)*(`va')+(`gb'^2)*(`vb') + 2*`ga'*`gb'*`vab'
	scalar `ase'=sqrt(`ase')
	sret local se_da = `ase' 
	sret local da = `da' 
end
prog def DISTab1
	args level max
	tempname B V
	qui mat `B'=e(b)
	qui mat `V'=e(V)
	local max=colsof(`B')
	local alpha=invnorm(.5+`level'/200)

	di
	DivLine top
	di in smcl in gr "             {c |}      Coef.   Std. Err."  /*
	*/ `"      z    P>|z|     [`=strsubdp("`level'")'% Conf. Interval]"'
	DivLine mid

	ELine "intercept" `B'[1,1] sqrt(`V'[1,1]) `alpha' 0
	ELine "slope (*)" `B'[1,2] sqrt(`V'[2,2]) `alpha' 1

	DivLine mid

	local i 3
	while `i'<=`max' {
		local j = `i'-2
		ELine "/cut`j'" `B'[1,`i'] sqrt(`V'[`i',`i']) `alpha' 0
		local i=`i'+1
	}
	DivLine bot
	DivLine top
end

program define DivLine
	args where
	if "`where'" == "top" {
		di in smcl in gr "{hline 13}{c TT}{hline 64}"
	}
	else if "`where'"=="mid" {
		di in smcl in gr "{hline 13}{c +}{hline 64}"
	}
	else 	di in smcl in gr "{hline 13}{c BT}{hline 64}"
end

program define ELine
	args name coef se alpha zero
	
	local z = (`coef'-`zero')/`se'
	local p = 2*norm(-abs(`z'))

 	local lb = `coef' - `alpha'*`se'
 	local ub = `coef' + `alpha'*`se'

	di in smcl in gr %12s "`name'" " {c |}" /*
		*/ in ye %11.6f `coef' 	/*
		*/ " " %10.6f `se' 	/*
		*/ %9.2f `z'		/*
		*/ "  "  %6.3f `p' 	/*
		*/ "   " %10.6f `lb' 	/*
		*/ "  " %10.6f `ub'
end

program define ILine
	args name coef se alpha

 	local lb = `coef' - `alpha'*`se'
 	local ub = `coef' + `alpha'*`se'

	di in smcl in gr %12s "`name'" " {c |}" /*
		*/ in ye %11.6f `coef' 	/*
		*/ " " %10.6f `se' 	/*
		*/ _col(57)		/*
		*/ %10.6f `lb' 		/*
		*/ "  " %10.6f `ub'
end



prog def DISTab2
	args level
	local alpha=invnorm(.5+`level'/200)

	local areau=`e(area)'+ `alpha'*`e(se_area)'
	local areal=`e(area)'- `alpha'*`e(se_area)'
	local deltau=`e(deltam)'+ `alpha'*`e(se_delm)'
	local deltal=`e(deltam)'- `alpha'*`e(se_delm)'
	local deu=`e(de)'+ `alpha'*`e(se_de)'
	local del=`e(de)'- `alpha'*`e(se_de)'
	local dau=`e(da)'+ `alpha'*`e(se_da)'
	local dal=`e(da)'- `alpha'*`e(se_da)'
	
	local cil `=string(`level')'
	local cil `=length("`cil'")'
	if `cil' == 2 {
		local spaces "      "
	}
	else if `cil' == 4 {
		local spaces "    "
	}
	else {
		local spaces "   "
	}
	di in smcl in gr  _col(14) /*
		*/ "{c |}                    Indices from binormal fit" 
	di in smcl in gr "       Index {c |}   Estimate    Std. Err." /*
*/ `"              `spaces'[`=strsubdp("`level'")'% Conf. Interval]"'
	DivLine mid

	ILine "ROC area" `e(area)' `e(se_area)' `alpha'
	ILine "delta(m)" `e(deltam)' `e(se_delm)' `alpha'
	ILine "d(e)" `e(de)' `e(se_de)' `alpha'
	ILine "d(a)" `e(da)' `e(se_da)' `alpha' 

	DivLine bot
	di in gr  "(*) z test for slope==1"
end

