*! version 1.1.0  16mar2016
/* Used by the following routines:
	tnbreg, tpoisson, nbreg, poisson, zip, zinb,
	xtpoisson (re ver only), xtnbreg (re ver only),
	xtgee (family(poisson) and link(log) only)
*/
program define tpredict_p2
	version 11.0
	args vtyp 		/// variable type for prediction
		varn	 	/// new variable name
		touse		/// touse variable
		offset   	/// "noffset" or ""
		p		/// pr(n) or pr(a,b) optional contents
		cp	   	/// cpr(n) or cpr(a,b) optional contents
		xdata1   	/// data if needed
		xdata2   	// data if needed
	if (`"`p'"'!="" ) +  (`"`cp'"'!="")  > 1 {
		error 198
	}
	if `"`p'"'!="" {
		local tvar `"`p'"'
	}
	else{
		local tvar `"`cp'"'
	}
	gettoken lb tvar : tvar, parse(", ")
	local nargs = 0
	if `"`tvar'"' != "" {
					// more than one argument detected
		gettoken comma tvar : tvar, parse(",")
		gettoken ub tvar : tvar, parse(", ")
		local tvar `"`tvar'"'
		local comma `"`comma'"'
		if `"`tvar'"' != "" | "`comma'"!="," {
			error 198
		}
		Fix `lb'
		local lb  `s(res)'
		qui capture confirm variable `lb'
		if _rc!=0 {
			qui capture confirm number `lb'
			if _rc== 0 {
				if (`lb'<0 ) {
					/* lb must be nonnegative */
					di as error "lower bound of `lb' " ///
						"must be nonnegative"
					exit 198
				}
				if `lb'!=int(`lb') {
					di as error "lower bound of `lb' " ///
						"must be an integer"
					exit 198
				}
			}
			else {
				if(`lb'>=.) {
					/* lb cannot be missing */
					di as error "lower bound is missing"
					error 198
				}
			}
		}
		Fix `ub'
		local ub  `s(res)'
		qui capture confirm variable `ub'
		if _rc!= 0 {
			qui capture confirm number `ub'
			if _rc== 0 {
				if (`ub'<0) {
					/* ub must be nonnegative */
					di as error "upper bound of `ub' " ///
						"must be nonnegative"
					exit 198
				}
				if `ub'!=int(`ub') {
					di as error "upper bound of `ub' " ///
						"must be an integer"
					exit 198
				}
				if `ub'<`lb' {
					di as error "upper bound of `ub' " ///
						"must be greater than or " ///
						"equal to the lower bound " ///
						"of `lb'"
					exit 198
				}
			}
		}
		local nargs = 2
	}
	else{
						/* only one argument detected */
		local tvar `"`tvar'"'
		if "`tvar'" != "" {
			error 198
		}

		Fix `lb'
		local n  `s(res)'
		local nargs = 1
		qui capture confirm number `n'
		if _rc==0 {
			if `n' < 0 {
				di as err "argument must be nonnegative"
				exit 198
			}
			if `n'!=int(`n') {
				di as error "argument must be an integer"
				exit 198
			}
		}
		else {
			qui capture confirm variable `n'
			if _rc!=0 {
				di as err "argument must be a number " ///
					"or variable"
				exit 198
			}
		}
	}
	sret clear
	DepName depname
	local ttl `depname'
	tempvar xb new
	if e(cmd)!="zip" & e(cmd)!="zinb" {
		qui _predict double `xb' if `touse', xb `offset'
	}
	if `"`p'"' != "" & `nargs' == 2 {
		if e(cmd) == "xtnbreg" {
			CalcXTNBRegPr `new' `xb' `touse' `lb' `ub' "`ttl'"
		}
		if e(cmd) == "zinb"{
			CalcZinbPr `new' `xdata1' `touse' `lb' `ub' "`ttl'" ///
			`xdata2'
		}
		if e(cmd) == "zip"{
			CalcZipPr `new' `xdata1' `touse' `lb' `ub' "`ttl'" ///
			`xdata2'
		}
		if e(cmd) == "poisson" |  e(cmd) == "tpoisson" | ///
			e(cmd) == "xtpoisson" | e(cmd) == "xtgee" {
			CalcPoissonPr `new' `xb' `touse' `lb' `ub' "`ttl'"
		}
		if e(cmd) == "nbreg" | e(cmd) == "tnbreg" {
			CalcNBRegPr `new' `xb' `touse' `lb' `ub' "`ttl'"
		}
		if e(cmd) == "gnbreg" {
			CalcGNBRegPr `new' `xb' `touse' `lb' `ub' "`ttl'"
		}
	}
	else if `"`cp'"' != "" & `nargs' == 2{
		if e(cmd) == "tpoisson" {
			CalcTPoissonCPr `new' `xb' `touse' `lb' `ub' "`ttl'"
		}
		if e(cmd) == "tnbreg" {
			CalcTNBRegCPr `new' `xb' `touse' `lb' `ub' "`ttl'"
		}
	}
	else if `"`p'"' != "" & `nargs' == 1 {
		if e(cmd) == "zinb"{
			/* note this assumes xdata1 = exp(xb) and
			   that xdata2 = prob(y=0)		*/
			CalcZinbPrn `new' `xdata1' `touse' `n' "`ttl'" ///
			`xdata2'
		}
		if e(cmd) == "zip"{
			/* note this assumes xdata1 = exp(xb) and
			   that xdata2 = prob(y=0)		*/
			CalcZipPrn `new' `xdata1' `touse' `n' "`ttl'" ///
			`xdata2'
		}
		if e(cmd) == "poisson" |  e(cmd) == "tpoisson" | ///
			e(cmd) == "xtpoisson" | e(cmd) == "xtgee" {
			CalcPoissonPrn `new' `xb' `touse' `n' "`ttl'"
		}
		if e(cmd) == "nbreg" | e(cmd) == "tnbreg" {
			CalcNBRegPrn `new' `xb' `touse' `n' "`ttl'"
		}
		if e(cmd) == "xtnbreg" {
			CalcXTNBRegPrn `new' `xb' `touse' `n' "`ttl'"
		}
		if e(cmd) == "gnbreg" {
			CalcGNBRegPrn `new' `xb' `touse' `n' "`ttl'"
		}
	}
	else if `"`cp'"' != "" & `nargs' == 1 {
		if e(cmd) == "tpoisson" {
			CalcTPoissonCPrn `new' `xb' `touse' `n' "`ttl'"
		}
		if e(cmd) == "tnbreg" {
			CalcTNBRegCPrn `new' `xb' `touse' `n' "`ttl'"
		}
	}
	else {
		di "unexpected syntax error detected!"
		exit 198
	}
	local ttl : var label `new'
	qui gen `vtyp' `varn' = `new' if `touse'
	label var `varn' `"`ttl'"'
end

program define Fix, sclass
	sret clear
	capture confirm number `0'
	if _rc==0 {
		sret local res `0'
		exit
	}
	local args `"`0'"'
	if "`args'"=="." {
		sret local res "."
		sret local class missing
		capture noisily
		exit
	}
	capture confirm variable `0'
	if _rc==0 {
		syntax varname
		sret local res `varlist'
		exit
	}
	sret local res `0'
end

program define DepName
	args name	  /* name is lmacname to store the depvar name */
	local depname `e(depvar)'
	gettoken depname : depname
	c_local `name' `depname'
end

program define TPoint
/* name1 is lmacname to store tp=truncation point
 */
/* name2 is lmacname to store ll=contents of e(llopt) */
	args name1 name2 touse
	c_local `name2' `e(llopt)'
	local ll = e(llopt)
	if ("`ll'" != ""){
		cap confirm names `ll'
		if _rc {
		/* it is not a name, should be a number */
			cap confirm number `ll'
			if _rc{
				di as error ///
				"{cmd:ll(`ll')} must specify " ///
				"a nonnegative value"
				exit 200
			}
			else{
				local tp = `ll' + 1
				capture noisily
			}
		}
		else{
		/* ll() does not contain a number */
			cap confirm variable `ll'
			if _rc!=0 {
			/* ll() contains a name that is not a */
			/* variable.  possibly it is a scalar */
				local tp = `ll'
				cap confirm number `tp'
				if _rc!=0{
					di as error ///
					"{cmd:ll(`ll')} must " ///
					"specify a nonnegative value"
					exit 200
				}
			}
			else {
			/* ll() contains the name of a variable */
				qui summarize `ll' if `touse'
				if r(min) < 0 {
					di as error ///
					"{cmd:ll(`ll')} must " ///
					"contain all " ///
					"nonnegative values"
					exit 200
				}
				local tp `ll'
			}
		}
	}
	c_local `name1' `tp'
end

program define CalcXTNBRegPrn
	args P xb touse n ttl
	tempvar m p
	local r = e(r)
	local s = e(s)
	qui gen double `m' = exp(`xb')
	if `r' > 1 {
		local delta = `s'/(`r'-1)
		qui replace `m' = `m'*`delta'
	}
	else {
		di as error "estimated value of r=`r' " _c
		di as error "is less than one; expected value" _c
		di as error " undefined"
		qui gen double `P' = .
		exit 198
	}

	qui gen double `p' = 1/(1+`delta') if `touse'
	qui gen double `P' = nbinomialp(`m',`n',`p') if `touse'
	label var `P' `"Pr(`ttl'=`n')"'
	ShowPrnResults `P' `n' `touse'
end
program define CalcXTNBRegPr
	args P xb touse lb ub ttl
	tempvar m p
	local r = e(r)
	local s = e(s)
	qui gen double `m' = exp(`xb')
	if `r' > 1 {
		local delta = `s'/(`r'-1)
		qui replace `m' = `m'*`delta'
	}
	else {
		di as error "estimated value of r=`r' " _c
		di as error "is less than one; expected value" _c
		di as error " undefined"
		qui gen double `P' = .
		exit 198
	}
	qui gen double `p' = 1/(1+`delta') if `touse'

	qui gen double `P' = cond((`lb'>=.| `lb'<0), .,			///
				cond((`lb'==0 & `ub'>=.), 1,		///
				cond(`lb'>0 & `ub'>=., 			///
					nbinomialtail(`m',`lb',`p'),	///
				cond(`ub'<0| `ub'<`lb', ., 		///
				cond((`lb'>=. | floor(`lb')<=0) & 	///
					`ub'>=0 & `ub'<.,		///
					nbinomial(`m',`ub',`p'),	///
				cond(`lb'>0 & `lb'<. & `ub'<.,		///
					nbinomial(`m',`ub',`p') - 	///
					nbinomial(`m',`lb'-1,`p'),.	///
				)))))) if `touse'
	Problabel `P' `ttl' `lb' `ub'
	ShowPrResults `P' `lb' `ub' `touse'
end

program define CalcZinbPrn
	args P mu touse n ttl pr0
	tempvar m p
	tempname b
	mat `b' = get(_b)
	local nc	= colsof(`b')
	local alpha  = exp(`b'[1,`nc'])
	local ialpha = exp(-`b'[1,`nc'])

	qui gen double `p' = 1/(1+`alpha'*`mu') if `touse'

	qui gen double `m' = floor(`n') if `touse'
	qui gen double `P' = cond(`m'>0, 		///
		(1-`pr0')*nbinomialp(`ialpha',`m',`p'), ///
		`pr0' + (1-`pr0')*(`p'^`ialpha') )	///
		 if `touse'

	label var `P' `"Pr(`ttl'=`n')"'
	ShowPrnResults `P' `n' `touse'
end
program define CalcZinbPr
	args P mu touse lb ub ttl pr0
	tempvar p
	tempname b

	mat `b' = get(_b)
	local nc	 = colsof(`b')
	local alpha  = exp(`b'[1,`nc'])
	local ialpha = exp(-`b'[1,`nc'])

	qui gen double `p' = 1/(1+`alpha'*`mu') if `touse'

	qui gen double `P' = cond((`lb'>=.| `lb'<0), .,			///
			cond((`lb'>=. | floor(`lb')<=0) & `ub'>=., 1, 	///
			cond(`lb'>0 & `ub'>=. ,				///
				(1-`pr0')*				///
				nbinomialtail(`ialpha',`lb',`p'), 	///
			cond(`ub'<0 | `ub'<`lb', ., 			///
			cond((`lb'>=. | floor(`lb')<=0) & `ub'>=0 & `ub'<., ///
				(1-`pr0')*nbinomial(`ialpha',`ub',`p')+ ///
				`pr0',					///
			cond(`lb'>0 & `lb'<. & `ub'<. ,			///
				(1-`pr0')*				///
				(nbinomial(`ialpha',`ub',`p') -		///
				nbinomial(`ialpha',`lb'-1,`p')), .	///
			)))))) if `touse'
	Problabel `P' `ttl' `lb' `ub'
	ShowPrResults `P' `lb' `ub' `touse'
end

program define CalcZipPrn
	args P mu touse n ttl pr0
	tempvar m m1
	qui gen double `m'  = floor(`n') if `touse'
	qui gen double `m1' = poissonp(`mu',`m') if `touse' & `m'>0
	qui gen double `P'  = ///
		(1-`pr0')*`m1' if `touse' & `m'>0
	qui replace `P'	= `pr0' + ///
		(1-`pr0')*exp(-`mu') if `touse' & `m'==0
	label var `P' `"Pr(`ttl'=`n')"'
	ShowPrnResults `P' `n' `touse'
end
program define CalcZipPr
	args P mu touse lb ub ttl pr0

	qui gen double `P' = cond((`lb'>=.| `lb'<0), .,			///
			cond((`lb'>=. | floor(`lb')<=0) & `ub'>=., 1, 	///
			cond(`lb'>0 & `ub'>=. ,				///
				(1-`pr0')*poissontail(`mu',`lb'),	///
			cond( `ub'<0| `ub'<`lb', ., 			///
			cond((`lb'>=. | floor(`lb')<=0) & `ub'>=0 & `ub'<., ///
				(1-`pr0')*poisson(`mu',`ub') +`pr0',	///
			cond(`lb'>0 & `lb'<. & `ub'<. ,			///
				(1-`pr0')*(poisson(`mu',`ub') - 	///
				poisson(`mu',`lb'-1) ),.		///
		)))))) if `touse'
	Problabel `P' `ttl' `lb' `ub'
	ShowPrResults `P' `lb' `ub' `touse'
end

program define CalcPoissonPr
	args P xb touse lb ub ttl
	tempvar m
	qui gen double `m' = exp(`xb') if `touse'
	qui gen double `P' = cond((`lb'>=.| `lb'<0), .,			///
			cond((`lb'==0) & `ub'>=., 1, 			///
			cond(`lb'>0 & `ub'>=. ,				///
				poissontail(`m',`lb'),			///
			cond(`ub'<0 | `ub'<`lb', ., 			///
			cond((`lb'>=. | floor(`lb')<=0) & `ub'>=0 & `ub'<., ///
				poisson(`m',`ub'),			///
			cond(`lb'>0 & `lb'<. & `ub'<., 			///
				poisson(`m',`ub') - 			///
				poisson(`m',`lb'-1), .			///
		)))))) if `touse'
	Problabel `P' `ttl' `lb' `ub'
	ShowPrResults `P' `lb' `ub' `touse'
end

program define CalcTPoissonCPr
	args P xb touse lb ub ttl
	TPoint varName llName `touse'
	local ll `llName'
	cap confirm variable `varName'
	if _rc==0 {
		tempvar tp
		qui gen double `tp' = `varName' + 1
	}
	else {
		local tp `varName'
		cap confirm number `lb'
		if _rc==0 {
			local tp2 = `varName' - 1
			local a = floor(`lb')
			if floor(`lb') <= `tp2' {
				di as err "argument of `a' is less than " ///
					"or equal to truncation point " ///
					"`tp2'"
				exit 198
			}
		}
	}
	tempvar m d1
	qui gen double `m' = exp(`xb') if `touse'
	qui gen double `d1'=poissontail(`m',`tp') if `touse'

	qui gen double `P' = cond((`lb'>=.| `lb'<`tp'), .,		///
			cond((`lb'>=. | `lb'<=`tp') & `ub'>=., 1, 	///
			cond(`lb'>`tp' & `ub'>=. ,			///
				poissontail(`m',`lb')/`d1',		///
			cond(`ub'<`tp' | `ub'<`lb', ., 			///
			cond((`lb'>=. | floor(`lb')<=`tp') & `ub'>=`tp' & ///
				`ub'<., 				///
				(poisson(`m',`ub') - 			///
					poisson(`m',`ll'))/`d1', 	///
			cond(`lb'>`tp' & `ub'<. & `lb'<., 		///
				(poisson(`m',`ub') - 			///
			poisson(`m',`lb'-1))/`d1', .			///
		)))))) if `touse'
	Problabel `P' `ttl' `lb' `ub' `ll'
	ShowPrResults `P' `lb' `ub' `touse' `varName'
end


program define CalcPoissonPrn
	args P xb touse n ttl
	qui gen double `P' = poissonp(exp(`xb'),`n') if `touse'
	label var `P' `"Pr(`ttl'=`n')"'
	ShowPrnResults `P' `n' `touse'
end

program define CalcTPoissonCPrn
	args P xb touse n ttl
	TPoint varName llName `touse'
	local ll `llName'
	cap confirm variable `varName'
	if _rc==0 {
		tempvar tp
		qui gen double `tp' = `varName' + 1
	}
	else {
		local tp `varName'
		cap confirm number `n'
		if _rc==0 {
			local tp2 = `varName' - 1
			local a = floor(`n')
			if floor(`n') <= `tp2' {
				di as err "argument of `a' is less than " ///
					"or equal to truncation point "   ///
					"`tp2'"
				exit 198
			}
		}
	}
	tempvar m

	quietly {
		gen double `m' = exp(`xb') if `touse'
		gen double `P' = cond(`n'<`tp'| `n'<0, .,		///
				cond(`n'>=`tp', 			///
				poissonp(`m',`n')/			///
					poissontail(`m', `tp'), .	///
				)) if `touse'
		}
	label var `P' `"Pr(`ttl'=`n' | `ttl'>`ll')"'
	ShowPrnResults `P' `n' `touse' `varName'
end

program define CalcNBRegPr
	args P xb touse lb ub ttl
	if(e(dispers) == "mean"){
		if `:colnfreeparms e(b)' {
			local b0 = _b[/lnalpha]
		}
		else {
			local b0 = [lnalpha]_cons
		}
		if (`b0' < -20)  {
			local b0 = -20
		}
		local m = exp(-`b0')
		tempvar p
		qui gen double `p' = 1/(1+exp(`xb')/`m') if `touse'
	}
	else{
		if `:colnfreeparms e(b)' {
			local b0 = _b[/lndelta]
		}
		else {
			local b0 = [lndelta]_cons
		}
		if (`b0' < -20)  {
			local b0 = -20
		}
		tempvar m
		qui gen double `m' = exp(`xb'-`b0') if `touse'
		local p = 1/(1+exp(`b0'))
	}

	qui gen double `P' = cond((`lb'>=.| `lb'<0), .,			///
			cond((`lb'>=. | floor(`lb')<=0) & `ub'>=., 1,	///
			cond(`lb'>0 & `ub'>=. ,				///
				nbinomialtail(`m',`lb',`p'),		///
			cond(`ub'<0 | `ub'<`lb', ., 			///
			cond((`lb'>=. | floor(`lb')<=0) & `ub'>=0  	///
				& `ub'<., 				///
				nbinomial(`m',`ub',`p'), 		///
			cond(`lb'>0 & `lb'<. & `ub'<., 			///
				nbinomial(`m',`ub',`p') - 		///
				nbinomial(`m',`lb'-1,`p'), .		///
		)))))) if `touse'
	Problabel `P' `ttl' `lb' `ub'
	ShowPrResults `P' `lb' `ub' `touse'
end

program define CalcTNBRegCPr
	args P xb touse lb ub ttl
	TPoint varName llName `touse'
	local ll `llName'
	cap confirm variable `varName'
	if _rc==0 {
		tempvar tp
		qui gen double `tp' = `varName' + 1
	}
	else {
		local tp `varName'
		cap confirm number `lb'
		if _rc==0 {
			local tp2 = `varName' - 1
			local a = floor(`lb')
			if floor(`lb') <= `tp2' {
				di as err "argument of `a' is less than " ///
					"or equal to truncation point "   ///
					"`tp2'"
				exit 198
			}
		}
	}
	if(e(dispers) == "mean"){
		if `:colnfreeparms e(b)' {
			local b0 = _b[/lnalpha]
		}
		else {
			local b0 = [lnalpha]_cons
		}
		if (`b0' < -20)  {
			local b0 = -20
		}
		local m = exp(-`b0')
		tempvar p
		qui gen double `p' = 1/(1+exp(`xb')/`m') if `touse'
	}
	else{
		if `:colnfreeparms e(b)' {
			local b0 = _b[/lndelta]
		}
		else {
			local b0 = [lndelta]_cons
		}
		if (`b0' < -20)  {
			local b0 = -20
		}
		tempvar m
		qui gen double `m' = exp(`xb'-`b0') if `touse'
		local p = 1/(1+exp(`b0'))
	}
	tempvar d1
	qui gen double `d1'=nbinomialtail(`m',`tp',`p') if `touse'

	qui gen double `P' = cond((`lb'>=.|`lb'<`tp'), .,		///
			cond((`lb'>=. | `lb'<=`tp') & `ub'>=., 1, 	///
			cond(`lb'>`tp' & `ub'>=. ,			///
				nbinomialtail(`m',`lb',`p')/`d1' ,	///
			cond(`ub'<`tp' | `ub'<`lb', ., 			///
			cond((`lb'>=.|floor(`lb')<=`tp') & `ub'>=`tp' & ///
				`ub'<., 				///
				(nbinomial(`m',`ub',`p') - 		///
				nbinomial(`m',`ll',`p'))/`d1', 		///
			cond(`lb'>`tp' & `ub'<. & `lb'<., 		///
				(nbinomial(`m',`ub',`p') - 		///
				nbinomial(`m',`lb'-1,`p'))/`d1', .	///
	)))))) if `touse'
	Problabel `P' `ttl' `lb' `ub' `ll'
	ShowPrResults `P' `lb' `ub' `touse' `varName'
end

program define CalcNBRegPrn
	args P xb touse n ttl
	if(e(dispers) == "mean"){
		if `:colnfreeparms e(b)' {
			local b0 = _b[/lnalpha]
		}
		else {
			local b0 = [lnalpha]_cons
		}
		if (`b0' < -20)  {
			local b0 = -20
		}
		local m = exp(-`b0')
		tempvar p
		qui gen double `p' = 1/(1+exp(`xb')/`m') if `touse'
	}
	else{
		if `:colnfreeparms e(b)' {
			local b0 = _b[/lndelta]
		}
		else {
			local b0 = [lndelta]_cons
		}
		if (`b0' < -20)  {
			local b0 = -20
		}
		tempvar m
		qui gen double `m' = exp(`xb'-`b0') if `touse'
		local p = 1/(1+exp(`b0'))
	}
	qui gen double `P' = nbinomialp(`m',`n',`p') if `touse'
	label var `P' `"Pr(`ttl'=`n')"'
	ShowPrnResults `P' `n' `touse'
end

program define CalcTNBRegCPrn
	args P xb touse n ttl
	TPoint varName llName `touse'
	local ll `llName'
	cap confirm variable `varName'
	if _rc==0 {
		tempvar tp
		qui gen double `tp' = `varName' + 1
	}
	else {
		local tp `varName'
		cap confirm number `n'
		if _rc==0 {
			local tp2 = `varName' - 1
			local a = floor(`n')
			if floor(`n') <= `tp2' {
				di as err "argument of `a' is less than " ///
					"or equal to truncation point "   ///
					"`tp2'"
				exit 198
			}
		}
	}
	if(e(dispers) == "mean"){
		if `:colnfreeparms e(b)' {
			local b0 = _b[/lnalpha]
		}
		else {
			local b0 = [lnalpha]_cons
		}
		if (`b0' < -20)  {
			local b0 = -20
		}
		local m = exp(-`b0')
		tempvar p
		qui gen double `p' = 1/(1+exp(`xb')/`m') if `touse'
	}
	else{
		if `:colnfreeparms e(b)' {
			local b0 = _b[/lndelta]
		}
		else {
			local b0 = [lndelta]_cons
		}
		if (`b0' < -20)  {
			local b0 = -20
		}
		tempvar m
		qui gen double `m' = exp(`xb'-`b0') if `touse'
		local p = 1/(1+exp(`b0'))
	}
	tempvar d1
	qui gen double `d1'=nbinomialtail(`m',`tp',`p') if `touse'
	qui gen double `P' = cond(`n'<0| `n'<`tp', ., 		///
			cond(`n'>=`tp', 			///
				nbinomialp(`m',`n',`p')/`d1', .	///
			)) if `touse'
	label var `P' `"Pr(`ttl'=`n' | `ttl'>`ll')"'
	ShowPrnResults `P' `n' `touse' `varName'
end

program define CalcGNBRegPr
	args P xb touse lb ub ttl
	tempname i j
	tempvar b0 m p
	qui predict double `b0', lnalpha
	qui gen double `m' = exp(-`b0')
	qui gen double `p' = 1/(1+exp(`xb')/`m') if `touse'

	qui gen double `P' = cond((`lb'>=. | floor(`lb')<=0) & `ub'>=., 1, ///
			cond(`lb'>0 & `ub'>=. ,				///
				nbinomialtail(`m',`lb',`p'),		///
			cond(`ub'<0 | `ub'<`lb', ., 			///
			cond((`lb'>=. | floor(`lb')<=0) & `ub'>=0 	///
				& `ub'<.,				///
				nbinomial(`m',`ub',`p'), 		///
			cond(`lb'>0 & `lb'<. & `ub'<., 			///
				nbinomial(`m',`ub',`p') - 		///
				nbinomial(`m',`lb'-1,`p'), .		///
		))))) if `touse'
	Problabel `P' `ttl' `lb' `ub'
	ShowPrResults `P' `lb' `ub' `touse'
end

program define CalcGNBRegPrn
	args P xb touse n ttl
	tempvar b0 m p
	tempname i j
	qui predict double `b0', lnalpha
	qui gen double `m' = exp(-`b0')
	qui gen double `p' = 1/(1+exp(`xb')/`m') if `touse'

	qui gen double `P' = nbinomialp(`m',`n',`p') if `touse'
	ShowPrnResults `P' `n' `touse'
	label var `P' `"Pr(`ttl'=`n')"'
end

program define ShowPrnResults
	args P n touse tp
	cap confirm numeric variable `n'
	local notint = 0
	if _rc==0 {
		tempvar _d
		qui gen double `_d' = `n' - int(`n') if `touse'
		qui sum `_d' if `_d'>0 & `touse', meanonly
		local notint = r(N)
		qui replace `P' = . if `_d'>0 & `touse'
	}
	qui sum `P', meanonly
	local nmissing = _N - r(N)
	if `nmissing' > 0 {
		local s
		if `nmissing'>1 local s s
		di in gr "(`nmissing' missing value`s' generated)"
	}
	cap confirm numeric variable `n'
	if _rc == 0 {
		qui qui sum `n' if `n' < 0 & `touse', meanonly
		local nneg = r(N)
		qui sum `n' if `touse', meanonly
		local nm   = _N - r(N)
		local m = `nneg' + `nm'
		if `m' > 0 {
			local s
			if `n'>1 {
			 	local s s
			 }
			di in gr "`n' contains `m' negative or missing count`s'"
		}
		if `notint' > 0 {
			local s
			if `notint'>1 {
				local s s
			}
			di in gr "`n' contains `notint' noninteger value`s'"
		}
		if "`tp'"!="" {
			tempvar _diff
			qui gen double `_diff' = `n' - `tp' if `touse'
			qui sum `_diff' if `_diff' <= 0 & `touse', meanonly
			local m = r(N)
			if `m' > 0 {
				local s
				if `m'>1 local s s
				di in gr "{p 0 4 2}`n' contains `m' "  ///
					"value`s' less than or equal to " ///
					"the truncation point{p_end}"
			}
		}
	}
	else {
		if "`tp'"!="" {
			qui capture confirm variable `tp'
			if _rc == 0 {
				tempvar _diff
				qui gen double `_diff' = `n' - `tp' if `touse'
				qui sum `_diff' if `_diff' <= 0 & `touse', ///
					meanonly
				local m = r(N)
				if `m' > 0 {
					local s
					if `m'>1 {
						local s s
					}
					di in gr  ///
					"{p 0 4 2}`m' truncation point`s' " ///
					"are greater than or equal to " ///
					"`n'{p_end}"
				}
			}
		}
	}
end
program define ShowPrResults
	args P lb ub touse tp
	tempvar _d
	local anotint = 0
	cap confirm variable `lb'
	if _rc==0 {
		qui gen double `_d' = `lb' - int(`lb') if `touse'
		qui sum `_d' if `_d'>0 & `touse', meanonly
		local anotint = r(N)
		qui replace `P' = . if `_d'>0 & `touse'
		drop `_d'
	}
	local bnotint = 0
	cap confirm variable `ub'
	if _rc==0 {
		qui gen double `_d' = `ub' - int(`ub') if `touse'
		qui sum `_d' if `_d'>0 & `touse', meanonly
		local bnotint = r(N)
		qui replace `P' = . if `_d'>0 & `touse'
		drop `_d'
	}
	qui sum `P', meanonly
	local nmissing = _N - r(N)
	if `nmissing' > 0 {
		local s
		if `nmissing'>1 local s s
		di in gr "(`nmissing' missing value`s' generated)"
	}
	cap confirm variable `lb'
	if _rc == 0 {
		qui sum `lb' if `lb' < 0 & `touse', meanonly
		local nneg = r(N)
		qui sum `lb' if `touse', meanonly
		local nm = _N - r(N)
		local m = `nneg' + `nm'
		if `m' > 0 {
			local s
			if `m'>1 local s s
			di in gr "`lb' contains `m' negative or missing count`s'"
		}
		if `anotint' > 0 {
			local s
			if `anotint'>1 local s s
			di in gr "`lb' contains `anotint' noninteger value`s'"
		}
		if "`tp'"!="" {
			qui capture confirm variable `tp'
			if _rc == 0 {
				qui gen double `_d' = `lb' - `tp' if `touse'
				qui sum `_d' if `_d' <= 0 & `lb'>=0 & ///
					`touse', meanonly
				local m = r(N)
				if `m' > 0 {
					local s
					if `m'>1 local s s
					di in gr  ///
					"{p 0 4 2}`lb' contains `m' "  ///
					"value`s' less than or equal to " ///
					"the truncation point{p_end}"
				}
				drop `_d'
			}
		}
	}
	else {
		if "`tp'"!="" {
			qui capture confirm variable `tp'
			if _rc == 0 {
				qui gen double `_d' = `lb' - `tp' if `touse'
				qui sum `_d' if `_d' <= 0 & `touse', ///
					meanonly
				local m = r(N)
				if `m' > 0 {
					local s
					if `m'>1 local s s
					di in gr ///
					"{p 0 4 2}`m' truncation point`s' " ///
					"are greater than or equal to " ///
					"`lb'{p_end}"
				}
				drop `_d'
			}
		}
	}
	cap confirm variable `ub'
	if _rc == 0 {
		qui sum `ub' if `ub' < 0 & `touse', meanonly
		local nneg = r(N)
		qui sum `ub' if `touse', meanonly
		local nm = _N - r(N)
		local m = `nneg' + `nm'
		if `m' > 0 {
			local s
			if `m'>1 local s s
			di in gr	///
				"`ub' contains `m' negative or missing count`s'"
		}
		if `bnotint' > 0 {
			local s
			if `bnotint'>1 local s s
			di in gr "`ub' contains `bnotint' noninteger value`s'"
		}
		qui sum `ub' if `ub' < `lb' & `lb'<. & `touse', meanonly
		local nsmall = r(N)
		if `nsmall' > 0 {
			local s
			if `nsmall'>1 local s s
			di in gr	///
				"`ub' contains `nsmall' count`s' less than `lb'"
		}
	}
	else {
		cap confirm variable `lb'
		if _rc == 0 {
			qui sum `lb' if `ub' < `lb' & `touse', meanonly
			local nsmall = r(N)
			if `nsmall' > 0 {
				local s
				if `nsmall'>1 local s s
				di in gr	///
				"`ub' contains `nsmall' count`s' less than `lb'"
			}
		}
	}
end

program define Problabel
	args P ttl lb ub lln
	capture confirm number `lln'
	if _rc == 0 {
		local ll = `lln'
		if `ll' != . {
			local ttag "| `ttl'>`lln'"
		}
	}
	else{
		local ll `lln'
		local ttag "| `ttl'>`lln'"
		capture noisily
	}
	if `ub'<. {
		if `lb'<. {
			if "`ll'" != ""  {
				label var `P' `"Pr(`lb'<=`ttl'<=`ub' `ttag')"'
			}
			else{
				label var `P' `"Pr(`lb'<=`ttl'<=`ub')"'
			}
		}
		else{
			if "`ll'" != "" {
				label var `P' `"Pr(`ttl'<=`ub' `ttag')"'
			}
			else{
				label var `P' `"Pr(`ttl'<=`ub')"'
			}
		}
	}
	else{
		/* ub = missing */
		if `lb'<. {
			if "`ll'" != "" {
				label var `P' `"Pr(`ttl'>=`lb' `ttag')"'
			}
			else{
				label var `P' `"Pr(`ttl'>=`lb')"'
			}
		}
		else {
		/* ub = missing & lb = missing */
			if "`ll'" != "" {
				label var `P' `"Pr(-inf<`ttl'<+inf `ttag')"'
			}
			else{
				label var `P' `"Pr(-inf<`ttl'<+inf)"'
			}
		}
	}
end

