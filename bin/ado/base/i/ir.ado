*! version 3.4.9  02apr2019
program define ir, rclass sort
	version 6, missing
	syntax varlist(min=3 max=3) [if] [in] [fw] [, BY(string) /*
		*/ noCrude noHom noHEt EStandard Fast IRD IStandard /*
		*/ Level(cilevel) Pool Standard(varname) TB ]
	local hom "`hom'`het'"
	tokenize `varlist'
	local cas `1'
	local ex  `2'
	local tim `3'

	local stdflg=("`standar'"!="")+("`estanda'"!="")+("`istanda'"!="")
	if `stdflg'>1 { 
		di in red "only one method of standardization may be specified"
		error 198 
	}

	if ((`stdflg' == 0) & ("`ird'" != "")) {
		di in red "ird may be used only with one of " ///
			"estandard, istandard, or standard()"
		error 198
	} 

	marksample use
	qui count if `use'
	if (r(N)==0) {
		error 2000
	}
	
	_epitab_by_parse `by'
	local by `s(by)'
	local missing `s(missing)'
	sret clear
	local nbyvars: word count `by'
	if (`nbyvars' > 1) {
		error 103
	}
	
	tempvar wgt first decoded
	quietly { 
		if "`weight'"!="" { 
			gen double `wgt' `exp' if `use'
			local weight "[fweight=`wgt']"
		}
	}

	if "`by'"!="" {
		if ("`missing'" == "") {
			cap replace `use' = 0 if missing(`by')
			qui count if `use'
			if (r(N)==0) {
				error 2000
			}
		}
		quietly { 
			sort `use' `by'
			if "`standar'"!="" {
				capture assert `standar'>=0 if `use'
				if _rc { 
					noi di in red /*
					*/ "`standar' has negative values"
					exit 498
				}
				capture by `use' `by': assert /*
				*/ `standar'==`standar'[_n-1] if _n>1 & `use'
				if _rc { 
					noi di in red /*
					*/ "`standar' not constant within `by'"
					exit 198
				}
			}
			by `use' `by': gen byte `first'=1 if _n==1 & `use'
			sort `first' `by'

			if "`crude'" == "" {
				local optex = ("`tb'"=="") + ("`level'"=="") 
				
				if "`level'" != "" { 
					local ml  "level(`level')" }
				else 	local ml

				if `optex' == 2 {
					local myopt ""
				}
				else {
					local myopt ",`tb' `ml'   "
				}

				ir `cas' `ex' `tim' `if' `in' `w' `myopt'
				ret add /* add r() from recursive call */

				if "`ird'" != "" {
					local CRUDE  "`return(ird)'"
					local C0     "`return(lb_ird)'"
					local C1     "`return(ub_ird)'"
				}
				else {
					local CRUDE  "`return(irr)'"
					local C0     "`return(lb_irr)'"
					local C1     "`return(ub_irr)'"
				}
				ret scalar crude = `CRUDE'
				ret scalar lb_crude = `C0'
				ret scalar ub_crude = `C1'
				
				local CTYPE  ""
				if "`tb'" != ""    { local CTYPE  "(tb)" }
				else if "`ird'" == "" { local CTYPE  "(exact)" }
			}
		}
	}
	else {
		if `stdflg'!=0 { 
			di in red "missing by() option"
			error 198 
		}
	}
	capture assert `cas'>=0 & `tim'>=0 if `use'
	if _rc { 
		di in red "`cas' or `tim' takes on negative values"
		exit 499
	}

	_crcvarl `ex'
	local col "col(`s(varlabel)')"

	_crcvarl `cas'
	local row "row(`s(varlabel)')"

	_crcvarl `tim'
	local row2 "row2(`s(varlabel)')"

	if "`by'"=="" { 
		quietly { 
			sum `cas' `weight' if `ex' & `use'
			local a=int(r(N)*r(mean)+.5)
			sum `tim' `weight' if `ex' & `use'
			local n1 = r(N)*r(mean)
			sum `cas' `weight' if `ex'==0 & `use'
			local b=int(r(N)*r(mean)+.5)
			sum `tim' `weight' if `ex'==0 & `use'
			local n0= r(N)*r(mean)
		}
		if `a'>=. { local a 0 } 
		if `b'>=. { local b 0 } 
		if `n1'>=. { local n1 0 } 
		if `n0'>=. { local n0 0 } 
		iri `a' `b' `n1' `n0', level(`level') `col' `row' `row2' `tb'
		ret add
		exit
	}

	local lby : value label `by'
	if "`lby'"!="" { 
		quietly decode `by', gen(`decoded')
		local lby "`decoded'"
	}
	else	local lby `by'

	local i 1
	local df 0
	local sumIRR 0
	local sumwgt 0
	local sumV1 0
	local sumV2 0 
	local sumV3 0
	local sumV4 0
	local pwgt 0
	local pnum 0
	local pden 0
	local suma 0
	local sumb 0
	local sumn0 0
	local sumn1 0

	tempvar irr virr
	quietly gen `irr'=.
	quietly gen `virr'=.

	local lbl : var label `by'
	if "`lbl'"=="" { local lbl = abbrev("`by'", 12) }
	else local lbl = udsubstr("`lbl'",1,16)
	local skip=16-udstrlen("`lbl'")

	if "`ird'"=="" { local hdr "IRR" }
	else {
		if `stdflg'==0 { error 198 }
		local hdr "IRD"
	}
	if `stdflg'==0 { local hdr2 "M-H" }
	else local hdr2 "   "
	local cil `=string(`level')'
	local cil `=length("`cil'")'
	di _n in smcl in gr _skip(`skip') "`lbl' {c |}" _col(25) "`hdr'" /*
*/ _col(`=37-`cil'') `"[`=strsubdp("`level'")'% Conf. Interval]   `hdr2' Weight"' _n /*
	*/ "{hline 17}{c +}{hline 49}"

	local IRR0 . 
	local IRR1 . 
	local P0 .
	local P1 .
	local POOL .
	local nf ""
	while 1 { 
		if `first'[`i']!=1 {		/* end of loop */
			local iz=invnorm(1-(1-`level'/100)/2)
			/* double save in S_# and r() */
			global S_1 .
			global S_2 .
			global S_3 . 
			global S_4 . 
			global S_5 . 
			global S_6 .
			ret scalar ird = .
			ret scalar lb_ird = .
			ret scalar ub_ird = .
			ret scalar irr = .
			ret scalar lb_irr = .
			ret scalar ub_irr = .
			if `stdflg'==0 {	/* M-H */
				local IRR = `sumIRR'/`sumwgt'
				local var=`sumV1'/(`sumV2'*`sumV3')
				local sd=sqrt(`var')
				local IRR0=exp(ln(`IRR')-`iz'*`sd')
				local IRR1=exp(ln(`IRR')+`iz'*`sd')
				/* double save in S_# and r() */
				global S_4 `IRR'
				global S_5 `IRR0'
				global S_6 `IRR1'
				ret scalar irr = `IRR'
				ret scalar lb_irr = `IRR0'
				ret scalar ub_irr = `IRR1'
				local hdr2 "   M-H combined"
				local hdr3 "(M-H)    "
			}
			else {
				if "`estanda'"!="" {
					local hdr2 "E. Standardized"
					local hdr3 "(E.S.)   "
				}
				else if "`istanda'"!="" {
					local hdr2 "I. Standardized"
					local hdr3 "(I.S.)   "
				}
				else {
					local hdr2 "   Standardized"
					local hdr3 "(std.)   "
				}
				if "`ird'"!="" {
					local IRR = `sumIRR'/`sumwgt'
					local sd=sqrt(`sumV1'/(`sumwgt')^2)
					local IRR0=`IRR'-`iz'*`sd'
					local IRR1=`IRR'+`iz'*`sd'
					/* double save in S_# and r() */
					global S_1 `IRR'
					global S_2 `IRR0'
					global S_3 `IRR1'
					ret scalar ird = `IRR'
					ret scalar lb_ird = `IRR0'
					ret scalar ub_ird = `IRR1'
				}
				else {
					local IRR=`sumV2'/`sumV4'
					local sd=sqrt(`sumV1'/(`sumV2')^2 + /*
						*/    `sumV3'/(`sumV4')^2)
					local IRR0=exp(ln(`IRR')-`iz'*`sd')
					local IRR1=exp(ln(`IRR')+`iz'*`sd')
					/* double save in S_# and r() */
					global S_4 `IRR'
					global S_5 `IRR0'
					global S_6 `IRR1'
					ret scalar irr = `IRR'
					ret scalar lb_irr = `IRR0'
					ret scalar ub_irr = `IRR1'
				}
			}
			if "`ird'"=="" {
				local POOL=exp(`pnum'/`pden')
				local sd=sqrt(1/`pden')
				local P0=exp(ln(`POOL')-`iz'*`sd')
				local P1=exp(ln(`POOL')+`iz'*`sd')
				
				ret scalar pooled = `POOL'
				ret scalar lb_pooled = `P0'
				ret scalar ub_pooled = `P1'
				
				local dfm1=`df'-1
				tempvar sumf
				quietly gen `sumf'=.
				quietly replace `sumf'= sum( /*
				  */ (ln(`irr')-ln(`POOL'))^2/`virr') /*
				  */ in 1/`df'
				local pchi=`sumf'[`dfm1'+1]
quietly summ `irr' in 1/`df'
local cdf = r(N) - 1
				*local pval=chiprob(`dfm1',`pchi')
local pval=chiprob(`cdf',`pchi')
				quietly replace `sumf'= sum( /*
				  */ (ln(`irr')-ln(`IRR'))^2/`virr') /*
				  */ in 1/`df'
				local mchi=`sumf'[`dfm1'+1]
quietly summ `irr' in 1/`df'
local cdf = r(N) - 1
				*local mval=chiprob(`dfm1',`mchi')
local mval=chiprob(`cdf',`mchi')
			}
			else {
				local POOL=`pnum'/(`pden')
				local sd=sqrt(1/`pden')
				local P0=`POOL'-`iz'*`sd'
				local P1=`POOL'+`iz'*`sd'
				
				ret scalar pooled = `POOL'
				ret scalar lb_pooled = `P0'
				ret scalar ub_pooled = `P1'
				
				local dfm1=`df'-1
				tempvar sumf
				quietly gen `sumf'=.
				quietly replace `sumf'= sum( /*
				  */ (`irr'-`POOL')^2/`virr') /*
				  */ in 1/`df'
				local pchi=`sumf'[`dfm1'+1]
quietly summ `irr' in 1/`df'
local cdf = r(N) - 1
				*local pval=chiprob(`dfm1',`pchi')
local pval=chiprob(`cdf',`pchi')
				quietly replace `sumf'= sum( /*
				  */ (`irr'-`IRR')^2/`virr') /*
				  */ in 1/`df'
				local mchi=`sumf'[`dfm1'+1]
quietly summ `irr' in 1/`df'
local cdf = r(N) - 1
				*local mval=chiprob(`dfm1',`mchi')
local mval=chiprob(`cdf',`mchi')
			}

local dfm1 = `cdf'
			di in smcl in gr "{hline 17}{c +}{hline 49}"
			if "`crude'" == "" {
			  di in smcl in gr "           Crude {c |}  " in ye   /*
			  */ %9.0g `CRUDE' "     " %9.0g `C0' "  " /*
			  */ %9.0g `C1' in gr _col(69) "`CTYPE'"
			}
 			if "`pool'" != "" {
			  di in smcl in gr " Pooled (direct) {c |}  " in ye   /*
			  */ %9.0g `POOL' "     " %9.0g `P0' "  "  /*
			  */ %9.0g `P1'
			}
			di in smcl in gr " `hdr2' {c |}  " in ye /* 
			*/ %9.0g `IRR' "     " %9.0g `IRR0' "  " %9.0g `IRR1'

 			if "`hom'" == "" {
			  if `stdflg'==0 | "`pool'"!="" {
			    di in smcl in gr "{hline 17}{c BT}{hline 49}"
			  }
			  if "`pool'" != "" {
			    if `dfm1' > 0 {
			      di in gr /* 
			      */ " Test of homogeneity " /*
			      */ "(direct) chi2(" in ye "`dfm1'" in gr  /*
			      */ ") = " in ye %9.2f `pchi'           /*
			      */ in gr "  Pr>chi2 = " in ye %6.4f `pval'
			      /* double save in S_# and r() */
			      ret scalar df = `dfm1'
			      ret scalar chi2_p = `pchi'
			      global S_26 = `dfm1'
			      global S_27 = `pchi'
			    }
			    else {
			      global S_26
			      global S_27
			    }
			  }
			  if "`hdr3'" == "(M-H)    " {
			    if `dfm1' > 0 {
			      di in gr /* 
			      */ " Test of homogeneity " /* 
			      */ "`hdr3'" "chi2(" in ye "`dfm1'" in gr  /*
			      */ ") = " in ye %9.2f `mchi'           /* 
			      */ in gr "  Pr>chi2 = " in ye %6.4f `mval'
			      /* double save in S_# and r() */
			      ret scalar chi2_mh = `mchi'
			      ret scalar df = `dfm1'
			      global S_25 = `mchi'
			      global S_26 = `dfm1'
			    }
			  }
			}
			*if "`nf'"=="error" & `stdflg'==0{ 
			  *di
			  *di in bl "Note: Stratum specific estimates appear"/*
			  **/	" both sides of the null value. "
			  *di in bl "      This problem may require " /*
			  * */ " standardization."
			*}
			exit
		}
		quietly { 
			sum `cas' `weight' if `ex' & `use' & `by'==`by'[`i']
			local a=int(r(N)*r(mean)+.5)
			sum `tim' `weight' if `ex' & `use' & `by'==`by'[`i']
			local n1=r(N)*r(mean)
			sum `cas' `weight' if `ex'==0 & `use' & `by'==`by'[`i']
			local b=int(r(N)*r(mean)+.5)
			sum `tim' `weight' if `ex'==0 & `use' & `by'==`by'[`i']
			local n0=r(N)*r(mean)
		}
		if `a'>=. { local a 0 } 
		if `b'>=. { local b 0 } 
		if `n1'>=. { local n1 0 } 
		if `n0'>=. { local n0 0 } 
		if `stdflg'==0 {	/* M-H */
			local wgt=`b'*`n1'/(`n1'+`n0')
			local T=`n1'+`n0'
			local IRR=(`a'/`n1')/(`b'/`n0')

			*local sumIRR=`sumIRR'+`wgt'*`IRR'
local sumIRR=`sumIRR'+`a'*`n0'/(`n1'+`n0')

			local sumwgt=`sumwgt'+`wgt'
			local sumV1=`sumV1'+((`a'+`b')*`n1'*`n0')/((`T')^2)
			local sumV2=`sumV2'+`a'*`n0'/`T'
			local sumV3=`sumV3'+`b'*`n1'/`T'
		}
		else {
			if "`estanda'"!="" { local wgt `n0' }
			else if "`istanda'"!="" { local wgt `n1' }
			else local wgt=`standar'[`i']
			local sumwgt=`sumwgt'+`wgt'
			if "`ird'"!="" {	/* standardize ird */
				local IRR=`a'/`n1' - `b'/`n0'
				local sumIRR=`sumIRR'+`wgt'*`IRR'
				local VRD=`a'/(`n1')^2 + `b'/(`n0')^2
				local sumV1=`sumV1'+(`wgt')^2*`VRD'
			}
			else {			/* standardize irr */
				local R1=`a'/`n1'
				local R0=`b'/`n0'
				local IRR=`R1'/`R0'
				local varR1=`a'/(`n1')^2
				local varR0=`b'/(`n0')^2
				local sumV1=`sumV1'+(`wgt')^2*`varR1'
				local sumV2=`sumV2'+`wgt'*`R1'
				local sumV3=`sumV3'+(`wgt')^2*`varR0'
				local sumV4=`sumV4'+`wgt'*`R0'
			}
		}
		if "`ird'"=="" {
			local pwgt=(`a'*`b')/(`a'+`b')
			local pnum=`pnum'+`pwgt'*log(`IRR')
			quietly replace `virr'=(1/`a'+1/`b') in `i'
		}
		else {
			local pwgt=1/`VRD'
			local pnum=`pnum'+`pwgt'*`IRR'
			quietly replace `virr'=`VRD' in `i'
		}
		local pden=`pden'+`pwgt'
		local suma=`suma'+`a'
		local sumb=`sumb'+`b'
		local sumn0=`sumn0'+`n0'
		local sumn1=`sumn1'+`n1'	
		quietly replace `irr'=`IRR' in `i'

		local df=`df'+1
		global S_4     /* double save */
		ret scalar irr = .
		if "`fast'"=="" {
			if "`ird'"=="" { 
				_crcirr `a' `b' `n1' `n0' `level' `tb'
				local IRR0 "`r(lb_irr)'"
				local IRR1 "`r(ub_irr)'"
			}
			else {
				_crcird `a' `b' `n1' `n0' `level' `tb'
				local IRR0 "`r(lb_ird)'"
				local IRR1 "`r(ub_ird)'"
			}
		}
		local lbl=`lby'[`i']
		local lbl=udsubstr("`lbl'",1,16)
		local skip=16-udstrlen("`lbl'")
		di in smcl in gr _skip(`skip') "`lbl' {c |}  " in ye /*
		*/ %9.0g `IRR' "     " %9.0g `IRR0' "  " %9.0g `IRR1' /*
		*/ "    " %9.0g `wgt' in gr " `r(label)'"
		local i=`i'+1
	}
	/*NOTREACHED*/
end
exit
         1         2         3         4         5         6
1234567890123456789012345678901234567890123456789012345678901234567890
             age |      IRR       [95% Conf. Interval]   M-H Weight
-----------------+-------------------------------------------------
               1 |  12345678912345123456789121234567891234123456789
               2 |  123456789     123456789  123456789    123456789
-----------------+-------------------------------------------------
1234M-H combined |  123456789     123456789  123456789

(confidence intervals exact within stratum, combined is approximate)
