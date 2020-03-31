*! version 3.4.18  18feb2016
program define cs, rclass sort
	version 6, missing
	syntax varlist(min=2 max=2) [if] [in] [fw] [, Binomial(varname) /*
	    */ BY(string) noHom noHEt noCrude Exact EStandard Fast IStandard /*
		*/ Level(cilevel) OR Pool RD Standard(varname) /*
		*/ TB Woolf ]
	local hom "`hom'`het'"

	tokenize `varlist'
	local cas `1'
	local ex `2'

	if "`woolf'" != "" & "`or'" == "" {
		di as error "woolf option only valid with OR"
		exit 198
	}

	local stdflg=("`standard'"!="")+("`estandard'"!="")+("`istandard'"!="")
	if `stdflg'>1 { error 198 }

	marksample use
	qui count if `use'
	if (r(N)==0) {
		error 2000
	}
	
	_epitab_by_parse `by'
	local by `s(by)'
	local missing `s(missing)'
	sret clear

	tempvar WGT one first decoded
	* checks that weight and binomial are not both present
	if "`binomial'"!="" & "`weight'"!="" {
		di in re "weight not allowed with binomial frequency records"
		exit 198 
	}       
        if "`binomial'"~="" {
		preserve
		qui keep if `use'
		tempvar case mywt
		bitowt `cas' `binomial' , c(`case') w(`mywt')
		local exp "= `mywt'"
		qui drop `cas'
		tempvar cas
		rename `case' `cas'
		local weight "fweight"
	}
	if "`weight'"!="" { 
		qui gen double `WGT' `exp' if `use'
		local w "[fweight=`WGT']"
	}
	if  "`by'"~="" {
		local count: word count `by'
		if `count' > 1 {
			tempvar myby
			qui gen str18 `myby'=""
			tokenize `by'
			qui while "`1'"~="" {
				cap confirm numeric variable `1'
				if (_rc) {
					replace `myby'=`myby'+" "+`1'
				}
				else {
					replace `myby'=`myby'+" "+string( `1')
				}
				mac shift
			}
			qui if ("`missing'" == "") {
				tempvar nmiss
				egen `nmiss' = rowmiss(`by')	
				replace `myby' = "" if `nmiss'!=0
			}
			if "`standard'"~="" {
				local stdopt "standard(`standard')"
			}
			label var `myby' "`by'"
			*local myopt  ", `pool' `or' `tb' `woolf' `exact' "
			*cs `cas' `ex' `if' `in' `w' `myopt'
			local myopt ", `estandard' `istandard' `pool' `or' `tb' `woolf' `exact' by(`myby',`missing') `rd' level(`level') `crude' `hom' `stdopt'"
			cs `cas' `ex' `if' `in' `w' `myopt'
			ret add
			exit
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
			if "`standard'"!="" {
				capture assert `standard'>=0 if `use'
				if _rc {
					noi di in red /*
					*/ "`standard' has negative values"
					exit 498
				}
				capture by `use' `by': assert /*
				*/ `standard'==`standard'[_n-1] if _n>1 & `use'
				if _rc {
					noi di in red /*
				*/ "`standard' not constant within `by'"
					exit 198
				}
			}
			by `use' `by': gen byte `first'=1 if _n==1 & `use'
			sort `first' `by'
			if "`crude'" == "" {
				if "`level'" != "" { 
					local ml "level(`level')" }
				else 	local ml ""

				local myopt ", `or' `tb' `woolf' `exact' `ml'"
				cs `cas' `ex' `if' `in' `w' `myopt'
				if "`or'"!="" {
					local CRUDE  = r(or)
					local C0     = r(lb_or)
					local C1     = r(ub_or)
				}
				else {
				  if "`rd'" != "" {
					local CRUDE  = r(rd)
					local C0     = r(lb_rd)
					local C1     = r(ub_rd)
				  }
				  else {
					local CRUDE  = r(rr)
					local C0     = r(lb_rr)
					local C1     = r(ub_rr)
				  }
				}

				ret scalar crude = `CRUDE'
				ret scalar lb_crude = `C0'
				ret scalar ub_crude = `C1'
				ret add
				
				local CTYPE  "(Cornfield)"
				if "`tb'" != ""    { local CTYPE  "(tb)" }
				if "`woolf'" != "" { local CTYPE  "(Woolf)" }
			}
		}
	}
	else {
		if `stdflg' | "`rd'" != ""{ 
			di in red "missing by() option"
			error 198 
		}
	}
	quietly gen byte `one'=1
	_crcvarl `ex'
	local col "col(`s(varlabel)')"

	if "`by'"=="" { 
		quietly { 
			safesum `one' `w' if `cas' & `ex' & `use'
			local a=r(sum)
			safesum `one' `w' if `cas' & `ex'==0 & `use'
			local b=r(sum)
			safesum `one' `w' if `cas'==0 & `ex' & `use'
			local c=r(sum)
			safesum `one' `w' if `cas'==0 & `ex'==0 & `use'
			local d=r(sum)
		}
		csi `a' `b' `c' `d', level(`level') /*
			*/ `col' `or' `woolf' `tb' `exact'
		ret add    /* add return values from csi call  */
		exit
	}

	local lby : value label `by'
	if "`lby'"!="" { 
		quietly decode `by', gen(`decoded')
		local lby "`decoded'"
	}
	else	local lby `by'

	local lbl : var label `by'
	if "`lbl'"=="" { local lbl "`by'" }
	else local lbl = udsubstr("`lbl'",1,16)
	local skip=16-udstrlen("`lbl'")

	if "`or'"!="" { 
		if `stdflg'!=0 { 
			error 198
		}
		local type "OR" 
	}
	else if "`rd'"!="" { 
		if `stdflg'==0 { 
			error 198 
		}
		local type "RD" 
	}
	else local type "RR"

	if `stdflg'== 0 { local hdr2 "M-H" }
	else local hdr2 "   "

	local cil `=string(`level')'
	local cil `=length("`cil'")'
	di in smcl _n in gr _skip(`skip') "`lbl' {c |}" _col(26) "`type'" /*
*/ _col(`=37-`cil'') `"[`=strsubdp("`level'")'% Conf. Interval]   `hdr2' Weight"' _n /*
	*/ "{hline 17}{c +}{hline 49}"

	#delimit ;
	local i 1; local df 0; 	local iz=invnorm(1-(1-`level'/100)/2); 
	local Swgt 0;  local Sor 0;  local SPR 0; local SR 0;
	local SPSQR 0; local SS 0;   local SQS 0; local SXnum 0;
	local SXden 0; local S1 0;   local S2 0;  local or0 .;
	local or1 .;   local POOL .; local P0 .;  local P1 .;    local Sa 0;
	local Sb 0;    local Sc 0;   local Sd 0;  local Sn0 0;   local Sn1 0;
	local pnum 0;  local pden 0; /* local nf ; */

	tempvar irr virr Sf;

	qui gen `Sf'=. ;  qui gen `irr'=. ;	qui gen `virr'=. ;
	#delimit cr
	
	while 1 { 			
		if `first'[`i']!=1 {     /* End of `by' loop */

	#delimit ;
	global S_1 . ; global S_2 . ; global S_3 . ; global S_4 . ;
	global S_5 . ; global S_6 . ; global S_7 . ; global S_8 . ;
	global S_9 . ; global S_10 .; global S_11 .; global S_12  ;
	global S_13  ; global S_14  ;
	#delimit cr

	#delimit ;
	ret local p1_exact ; ret local chi2 ; ret local p ;
	ret local p_exact ;  ret local rd ;   ret local lb_rd ;
	ret local ub_rd ;    ret local rr ;   ret local lb_rr ;
	ret local ub_rr ;    ret local or ;   ret local lb_or ;
	ret local ub_or ;    ret local afe ;  ret local lb_afe ;
	ret local ub_afe ;
	#delimit cr


			if `stdflg'==0 {
				local or=`Sor'/`Swgt'
				if "`type'"=="OR" { 
					local se=sqrt(`SPR'/(2*((`SR')^2))+/*
					*/ `SPSQR'/(2*`SR'*`SS')+/*
					*/ `SQS'/(2*((`SS')^2)))
					local x2=((`SXnum')^2)/`SXden'
					global S_1 `x2'     /* double save */
					ret scalar chi2 = `x2'
					if "`tb'"=="" {
					   local or0=exp(ln(`or')-`iz'*`se')
					   local or1=exp(ln(`or')+`iz'*`se')
					}
					else {
					   local x=`SXnum'/sqrt(`SXden')
					   local or0=(`or')^(1-`iz'/`x')
					   local or1=(`or')^(1+`iz'/`x')
					   if `or0'>`or1' { 
						local h `or1'
						local or1 `or2'
						local or2 `h'
					   }
					   local note "tb"
					}
				}
				else {	/* RR */
					local se=sqrt(`S1'/(`S2'*`Swgt'))
					local or0=exp(ln(`or')-`iz'*`se')
					local or1=exp(ln(`or')+`iz'*`se')
				}
				local hdr2 "   M-H combined"
				local paren "M-H"
			}
			else {
				if "`estandard'"!="" {
					local hdr2 "E. Standardized"
					local paren "E.S."
				}
				else if "`istandard'"!="" {
					local hdr2 "I. Standardized"
					local paren "I.S."
				}
				else 	{
					local hdr2 "   Standardized"
					local paren "STD."
				}
				if "`type'"=="RR" {
					local or=`SXnum'/`SXden'
					local se=sqrt(`SPR'/(`SXnum')^2+/*
						*/ `SR'/(`SXden')^2)
					local or0=exp(ln(`or')-`iz'*`se')
					local or1=exp(ln(`or')+`iz'*`se')
				}
				else {
					local or=`Sor'/`Swgt'
					local se=sqrt(`SXnum'/(`Swgt')^2)
					local or0=`or'-`iz'*`se'
					local or1=`or'+`iz'*`se'
				}
			}
			if "`type'"=="RR" {
				global S_6 `or'  /* double save S_ and r() */
				global S_7 `or0'
				global S_8 `or1'
				ret scalar rr = `or'
				ret scalar lb_rr = `or0'
				ret scalar ub_rr = `or1'
			}
			else if "`type'"=="OR" {
				global S_9 `or'
				global S_10 `or0'
				global S_11 `or1'
				ret scalar or = `or'
				ret scalar lb_or = `or0'
				ret scalar ub_or = `or1'
			}
			else {	/* RD */
				global S_3 `or'
				global S_4 `or0'
				global S_5 `or1'
				ret scalar rd = `or'
				ret scalar lb_rd = `or0'
				ret scalar ub_rd = `or1'
			}

			if "`note'"=="" { local  jopt "" }
			else local jopt "mote(`note')"

* Call dispcs

			dispcs "`Sf'" "`irr'" "`virr'" /*
			*/ "`CRUDE'" "`C0'" "`C1'"   /*
			*/ "`pnum'" "`pden'" "`iz'" "`df'" /*
			*/ "`or'" "`or0'" "`or1'" "`stdflg'" "`x2'" /*
		begin options 
			*/	`hom' `pool' `jopt' type(`type') 	   /*
			*/	hdr2("`hdr2'") paren("`paren'") `crude'

			ret add    /* add return values from dispcs */

			exit
		}
		quietly { 
			safesum `one' `w' /*
			*/ if `cas' & `ex' & `use' & `by'==`by'[`i']
			local a=r(sum)
			safesum `one' `w' /* 
			*/ if `cas' & `ex'==0 & `use' & `by'==`by'[`i']
			local b=r(sum)
			safesum `one' `w' /*
			*/ if `cas'==0 & `ex' & `use' & `by'==`by'[`i']
			local c=r(sum)
			safesum `one' `w' /*
			*/ if `cas'==0 & `ex'==0 & `use' & `by'==`by'[`i']
			local d=r(sum)
		}
		* csi `a' `b' `c' `d', level(`level') `col' `woolf'
		local m1=`a'+`b'
		local m0=`c'+`d'
		local n1=`a'+`c'
		local n0=`b'+`d'
		local t=`n1'+`n0'

		if `stdflg'==0 {
			if "`type'"=="OR" { 
				local wgt=(`b'*`c')/`t'
				local or=(`a'*`d')/(`b'*`c')

				local P=(`a'+`d')/`t'
				local Q=(`b'+`c')/`t'
				local R=(`a'*`d')/`t'
				local S=(`b'*`c')/`t'
				local SPR=`SPR'+`P'*`R'
				local SR=`SR'+`R'
				local SPSQR=`SPSQR'+`P'*`S'+`Q'*`R' /*sic*/
				local SS=`SS'+`S'
				local SQS=`SQS'+`Q'*`S'

				local SXnum=`SXnum'+`a'-(`n1'*`m1')/`t'
				local SXden=`SXden'+/*
				*/ (`n1'*`n0'*`m1'*`m0')/((`t')^2*(`t'-1))

				global S_4
				ret local lb_rd       /* -ret drop- */
				if "`fast'"=="" { 
					_crcor `a' `b' `c' `d' `level' /*
						*/ `woolf' `tb'

					local or0 = r(lb)
					local or1 = r(ub)
				}
				if `t' != 0 {
					local Sor=`Sor'+(`a'*`d')/`t'
				}
			}
			else { 
				local wgt=(`b'*`n1')/`t'
				_crcrr `a' `b' `c' `d' `level' `tb'
				local or = r(rr)
				local or0 = r(lb)
				local or1 = r(ub)
				local S1=`S1'+ /*
				*/ (`m1'*`n1'*`n0'-`a'*`b'*`t')/((`t')^2)
				local S2=`S2'+(`a'*`n0')/`t'
				local Sor = `Sor' + (`a'*`n0')/`t'
			}
			local Swgt=`Swgt'+`wgt'
		}
		else {	/* standardize */
			if "`estandard'"!="" { local wgt `n0' }
			else if "`istandard'"!="" { local wgt `n1' }
			else local wgt=`standard'[`i']
			local Swgt = `Swgt'+`wgt'
			local R1=`a'/`n1'
			local R0=`b'/`n0'
			local vR1=(`a'*`c')/(`n1')^3
			local vR0=(`b'*`d')/(`n0')^3
			if "`type'"=="RR" { 
				_crcrr `a' `b' `c' `d' `level' `tb'
				local or = r(rr)
				local or0 = r(lb)
				local or1 = r(ub)
				local SXnum=`SXnum'+`wgt'*`R1'
				local SXden=`SXden'+`wgt'*`R0'
				local SPR=`SPR'+(`wgt')^2*`vR1'
				local SR=`SR'+(`wgt')^2*`vR0'
			}
			else {	/* RD */
				_crcrd `a' `b' `c' `d' `level' `tb'
				local or = r(rd)
				local or0 = r(lb)
				local or1 = r(ub)
				local Sor=`Sor'+`wgt'*`or'
				local SXnum=`SXnum'+(`wgt')^2*(`vR0'+`vR1')
			}
		}

		local Sa = `Sa'+`a'
		local Sb = `Sb'+`b'
		local Sc = `Sc'+`c'
		local Sd = `Sd'+`d'
		local Sn0 = `Sn0'+`n0'
		local Sn1 = `Sn1'+`n1'

		qui replace `irr'=`or' in `i'

		if "`type'"=="OR" { 
			qui replace `irr' = (`a'*`d')/(`b'*`c') in `i'
			qui replace `virr'= 1/`a'+1/`b'+1/`c'+1/`d' in `i'
		}
		if "`type'"=="RR" { 
			qui replace `irr' = (`a'/`n1')/(`b'/`n0') in `i'
			qui replace `virr'=`c'/(`a'*`n1')+`d'/(`b'*`n0') in `i'
		}
		if "`type'"=="RD" {
			qui replace `irr' = (`a'/`n1')-(`b'/`n0') in `i'
			qui replace `virr'= (`a'*`c')/((`n1')^3) + /*
				*/	(`b'*`d')/((`n0')^3) in `i'
		}
		

if `irr'[`i']/`virr'[`i'] < . {
		if "`type'"=="RD" { 
			local pnum = `pnum' + `irr'[`i']/`virr'[`i'] 
		}
		else 	local pnum = `pnum'+log(`irr'[`i'])/`virr'[`i']
		local pden = `pden' + 1/`virr'[`i']
}


		local lbl=`lby'[`i']
		local lbl=udsubstr("`lbl'",1,16)
		local skip=16-udstrlen("`lbl'")
		di in smcl in gr _skip(`skip') "`lbl' {c |}   " in ye /*
			*/ %9.0g `or' "    " %9.0g `or0' "  " %9.0g `or1' /*
			*/ "    " %9.0g `wgt' in gr " `r(label)'"
		local i=`i'+1
		local df=`df'+1

	}
	/*NOTREACHED*/
end


prog define dispcs, rclass
	local Sf "`1'"		/* variable names */
	local irr "`2'"
	local virr "`3'"
	mac shift 3
	local CRUDE `1'
	local C0 `2'
	local C1 `3'
	local pnum `4'
	local pden `5'
	local iz `6'
	local df `7'
	local or `8'
	local or0 `9'
	local or1 `10' 	
	local stdflg `11'
	local x2 `12'
	mac shift 12

	#delimit ;
	local options "TYPE(string) MOTE(string) HDR2(string) ARGS(string) noHOM POOL PAREN(string) noCRUDE" ;
	#delimit cr
	parse ", `*'"

	local hdr2 = trim("`hdr2'")

	if "`hdr2'" == "M-H combined" | "`hdr2'"=="Standardized" {
		local hdr2 "   `hdr2'"
	}

	di in smcl in gr "{hline 17}{c +}{hline 49}"
	if "`crude'" == "" {
		di in smcl in gr "           Crude {c |}   " in ye /*
		*/	%9.0g `CRUDE' "    " %9.0g `C0' "  "  /*
		*/	%9.0g `C1'    in gr _col(69) "`CTYPE'"
	}

	if "`pool'" != "" {
		if "`type'"=="RD" { 
			local POOL = `pnum'/`pden'
			local sd = sqrt(1/`pden')
			local P0 = `POOL'-`iz'*`sd'
			local P1 = `POOL'+`iz'*`sd'

			local dfm1=`df'-1
			quietly replace `Sf'= sum( /*
				*/ (`irr'-`POOL')^2/`virr') in 1/`df'
			local pchi=`Sf'[`dfm1'+1]
			local pval=chiprob(`dfm1',`pchi')
		}
		else { 
			local POOL = exp(`pnum'/`pden') 
			local sd = sqrt(1/`pden')
			local P0 = exp(log(`POOL')-`iz'*`sd')
			local P1 = exp(log(`POOL')+`iz'*`sd')

			local dfm1=`df'-1
			quietly replace `Sf'= sum( /*
				*/ (log(`irr')-log(`POOL'))^2/`virr') in 1/`df'
			local pchi=`Sf'[`dfm1'+1]
			local pval=chiprob(`dfm1',`pchi')
		}
		
		ret scalar pooled = `POOL'
		ret scalar lb_pooled = `P0'
		ret scalar ub_pooled = `P1'
		
		di in smcl in gr " Pooled (direct) {c |}   " in ye /*
		*/	%9.0g `POOL' "    " %9.0g `P0' "  "  /*
		*/	%9.0g `P1'    

	}

	if "`mote'"=="" {
		di in smcl in gr " `hdr2' {c |}   " in ye /* 
		*/ %9.0g `or' "    " %9.0g `or0' "  " %9.0g `or1' 
	}
	else {
		di in smcl in gr " `hdr2' {c |}   " in ye /* 
		*/ %9.0g `or' "    " %9.0g `or0' "  " %9.0g `or1' /*
		*/ in gr _col(69) "(`mote')"
	}

	if "`hom'" == "" {
	  if "`pool'" != "" | "`paren'"=="M-H" {
	    di in smcl in gr "{hline 17}{c BT}{hline 49}"
	  }
	  if "`pool'" != "" {
	    di in gr /*
		    */ "Test of homogeneity " /*
		    */ "(direct)" _col(32) "chi2(" in ye "`dfm1'" in gr /*
		    */ ") =" in ye %9.3f `pchi' in gr /*
		    */ "  Pr>chi2 = " in ye %6.4f `pval'
	    global S_26 = `dfm1'     /* double save S_ and r()  */
	    global S_27 = `pchi'
	    ret scalar df = `dfm1'
	    ret scalar chi2_p = `pchi'
	  }

	  if "`paren'"=="M-H" {
	    if "`type'"=="RD" {
	      local dfm1=`df'-1
	      quietly replace `Sf'= sum( /*
	        */ (`irr'-`or')^2/`virr') /*
	        */ in 1/`df'
quietly summ `irr' in 1/`df', mean
local cdf = r(N) - 1
	      local mchi=`Sf'[`dfm1'+1]
	      *local mval=chiprob(`dfm1',`mchi')
local mval=chiprob(`cdf',`mchi')
	    }
	    else {
	      local dfm1=`df'-1
	      quietly replace `Sf'= sum( /*
	        */ (log(`irr')-log(`or'))^2/`virr') /*
	        */ in 1/`df'
quietly summ `irr' in 1/`df', mean
local cdf = r(N) - 1
	      local mchi=`Sf'[`dfm1'+1]
	      *local mval=chiprob(`dfm1',`mchi')
local mval=chiprob(`cdf',`mchi')
	    }

	if `cdf' > 0 {
	    di in gr /*
		    */ "Test of homogeneity " /*
		    */ "(`paren')"   _col(32) "chi2(" in ye "`cdf'" in gr /*
		    */ ") =" in ye %9.3f `mchi' in gr /*
		    */ "  Pr>chi2 = " in ye %6.4f `mval'
	    global S_26 = `cdf'     /* double save S_ and r()  */
	    global S_25 = `mchi'
	    ret scalar df = `cdf'
	    ret scalar chi2_mh = `mchi'
	}
	  }
	}

	if "`type'"=="OR" & `stdflg'==0 { 
		di in gr _n _col(20) /*
			*/ "Test that combined OR = 1:" _n _col(33) /*
			*/ "Mantel-Haenszel chi2(1) =" /*
			*/ in ye %10.2f `x2' _n in gr /*
			*/ _col(49) "Pr>chi2 =" in ye /*
			*/ %10.4f chiprob(1,`x2')
	}
end
