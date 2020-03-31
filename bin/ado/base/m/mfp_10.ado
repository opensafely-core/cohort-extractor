*! version 1.6.8  15oct2019
program define mfp_10, eclass sortpreserve
local VV : di "version " string(_caller()) ", missing:"
version 8
if "`1'" == "" | "`1'"=="," {
	if "`e(fp_cmd2)'"!="mfp" {
		error 301
	}
	syntax [ , level(cilevel) *]
	`VV' FracRep "fractional polynomial" "  df  " "Powers" "`level'" "`options'"
	exit
}
quietly ssd query
if (r(isSSD)) {
	di as err "mfp not possible with summary statistic data"
	exit 111
}
local cmdline : copy local 0
gettoken cmd 0 : 0
frac_chk `cmd' 
if `s(bad)' {
	di in red "invalid or unrecognized command, `cmd'"
	exit 198
}
/*
	dist=0 (normal), 1 (binomial), 2 (poisson), 3 (cox), 4 (glm),
	5 (xtgee), 6(ereg/weibull), 7(streg,stcox).
*/
if "`cmd'" == "cnreg" local cmd _cnreg
local dist `s(dist)'
local glm `s(isglm)'
local qreg `s(isqreg)'
local xtgee `s(isxtgee)'
local normal `s(isnorm)'

global MFpdist `dist'

// separate commands options from -mfp- options
_parse comma lhs rhs : 0
local 0 `rhs'
syntax [, mfpopts(string asis) hascolon DEAD(str) noCONStant or IRr coef * ]
if ("`hascolon'"!="") {
	local cmdopts `options'
	local 0 `lhs' , `mfpopts' `or' `irr' `coef'
}
else {
	local 0 `lhs', `options' `or' `irr' `coef'
}

/* parse */
syntax [anything(name=xlist)] [if] [in] [aw fw pw iw] , /* 
 */ [ ADDpowers(str) ADJust(str) CENTer(str) AIC ALpha(str) ALL CATzero(str) DF(str) /*
 */ DFDefault(int 4) CYCles(int 5) FIXpowers(str) FP01 noSCAling /*
 */ POwers(str) SELect(str) SEQuential noTESTLinear XOrder(str) /*
 */ XPowers(str) ZERo(str) LEVel(cilevel) or IRr coef * ]

* Disentangle
GetVL `xlist'
_get_diopts diopts options, `options' `cmdopts'
local diopts `diopts' `or' `irr' `coef'

if ("`adjust'"=="") {
	local adjust "`center'"
}
else if ("`center'"!="") {
	di as err "options {bf:adjust()} and {bf:center()} may not be specified together"
	exit 198
}


frac_cox "`dead'" `dist'
/*
	Process options
*/

local regopt `diopts' `options' `constant'
if "`dead'"!="" {
	local regopt "`regopt' dead(`dead')"
}
if "`powers'"==""  {
	local powers "-2,-1,-.5,0,.5,1,2,3"
}
if "`addpowers'"!="" {
	local fpopt "`fpopt' addp(`addpowers')"
}
if "`fixpowers'"!="" {
	local fpopt "`fpopt' fixp(`fixpowers')"
}
if "`aic'"!="" { /* aic selection for vars and functions */
	if "`alpha'`select'"!="" {
		noi di as err "options {bf:alpha()} and {bf:select()} invalid with option {bf:aic}"
		exit 198
	}
	local alpha -1
	local select -1
}/*
	Check for missing values in lhs, rhs and model vars.
*/
tempvar touse
quietly {
	marksample touse
	_fix_for_intreg `dist' "$MFP_dv" `touse' "$MFP_cur `dead'"
	if `dist'==7 {
		replace `touse' = 0 if _st==0
	}
	frac_wgt "`exp'" `touse' "`weight'"
	local wgt `r(wgt)'				/* [`weight'`exp'] */
	count if `touse'
	local nobs = r(N)
}
/*
	Detect collinearity among covariates, and fail if found.
*/
local ncur: word count $MFP_cur
_rmcoll $MFP_cur `if' `in' [`weight' `exp'], `constant'
local ncur2: word count `r(varlist)'
if `ncur2'<`ncur' {
	local ncoll=`ncur'-`ncur2'
	if `ncoll'>1 {
		local s ies
	}
	else local s y
	di in red `ncoll' " collinearit`s' detected among covariates"
	exit 198
}
/*
	Rearrange order of variables in varlist
*/
if "`xorder'"=="" {
	local xorder "+"
}
/*
	Apply fracord to order variables by P-value
*/
`VV' FracOrd `wgt' if `touse', order(`xorder') `regopt' cmd(`cmd')
local nx $MFP_n	/* number of clusters, <= number of predictors */
local lhs $MFP_dv
local i 1
while `i'<=`nx' {
/*
	Store original order and reverse order
	of each RHS variable/variable set
*/
	local r`i' `s(ant`i')'
	local i = `i'+1
}
/*
	Initialisation.
*/
local i 1
while `i'<=`nx' {
	local x ${MFP_`i'}
	local nx`i': word count `x'
	local alp`i' .05	/* default FP selection level */
	local h`i' `x'		/* names of H(xvars) 	*/
	local n`i' `x'		/* names of xvars 	*/
	local po`i' 1 		/* to be final power	*/
	local sel`i' 1		/* default var selection level */
/*
	Remove old I* variables
*/
	if `nx`i''==1 {
		frac_mun `n`i'' purge
	}
	local i=`i'+1
}
/*
	Adjustment
*/
FracAdj "`adjust'" `touse'
local i 1
while `i'<=`nx' {
	if "`r(adj`i')'"!="" {
		local adj`i' adjust(`r(adj`i')')
	}
	local uniq`i'=r(uniq`i')
	local i=`i'+1
}
/*
	Set up degrees of freedom for each variable
*/
if "`df'"!="" {
	FracDis "`df'" df 1 .
	local i 1
	while `i'<=`nx' {
		if "${S_`i'}"!="" {
			local df`i' ${S_`i'}
		}
		local i=`i'+1
	}
}
/*
	Assign default df for vars not so far accounted for.
	Give 1 df if 2-3 distinct values, 2 df for 4-5 values,
	dfdefault df for >=6 values.
*/
local i 1
while `i'<=`nx' {
	if `nx`i''>1 {
		* over-ride all suggestions that df>1 for grouped vars
		local df`i' 1
	}
	else {
		if "`df`i''"=="" {
			if `uniq`i''<=3 {
				local df`i' 1
			}
			else if `uniq`i''<=5 {
				local df`i'=min(2,`dfdefault')
			}
			else local df`i' `dfdefault'
		}
	}
	local i=`i'+1
}
/*
	Set up FP selection level (alpha) for each variable
*/
if "`alpha'"!="" {
	FracDis "`alpha'" alpha -1 1
	local i 1
	while `i'<=`nx' {
		if "${S_`i'}"!="" {
			local alp`i' ${S_`i'}
			if `alp`i''<0 {
				local alp`i' -1  /* AIC */
			}
		}
		local i=`i'+1
	}
}
/*
	Set up selection level for each variable
*/
if "`select'"!="" {
	FracDis "`select'" select -1 1
	local i 1
	while `i'<=`nx' {
		if "${S_`i'}"!="" {
			local sel`i' ${S_`i'}
			if `sel`i''<0 {
				local sel`i' -1  /* AIC */
			}
		}
		local i=`i'+1
	}
}
/*
	Rationalize select() and alpha() in cases of aic
*/
local i 1
while `i'<=`nx' {
	if `sel`i''==-1 & `alp`i''!=1 {
		local alp`i' -1
	}
	if `alp`i''==-1 & `sel`i''!=1 {
		local sel`i' -1
	}
	local i=`i'+1
}
/*
	Individual FP powers for variables.
*/
if "`xpowers'"!="" {
	FracDis "`xpowers'" xpowers
	local i 1
	while `i'<=`nx' {
		if "${S_`i'}"!="" & `nx`i''==1 {
			local xpow`i' ${S_`i'}
		}
		local i=`i'+1
	}
}
/*
	Vars with zero option
*/
if "`zero'"!="" {
	tokenize `zero'
	while "`1'"!="" {
		FracIn `1'
		local i `s(k)'
		if `nx`i''==1 {
			local zero`i' "zero"
		}
		mac shift
	}
}
/*
	Vars with catzero option
*/
if "`catzero'"!="" {
	tokenize `catzero'
	while "`1'"!="" {
		FracIn `1'
		local i `s(k)'
		if `nx`i''==1 {
			local catz`i' "catzero"
			local zero`i' "zero"		/* catzero implies zero */
		}
		mac shift
	}
}
/*
	Reserve names for H(predictors) by creating a dummy variable
	for each predictor which potentially needs transformation.
*/
local i 1
while `i'<=`nx' {
	if `df`i''>1 | "`zero`i''`catz`i''"!="" {
		frac_mun `n`i''
		local stub`i' `s(name)'
		qui gen byte `stub`i''_1=.
	}
	local i=`i'+1
}
/*
	Build FP model.
	`r*' macros present predictors according to FracOrd ordering,
	e.g. i=1, r`i'=3 means most sig predictor is third in user's xvarlist.
*/
local it 0
local initial 1
local stable 0 /* convergence flag */
while !`stable' & `it'< `cycles' {
	local it = `it'+1
	local pwrs
	local rhs1
	local stable 1 /* later changed to 0 if any power or status changes */
	local lastch 0 /* becomes index of last var which changed status */
	local i 1
	while `i'<=`nx' {
		local r `r`i''
		local ni `n`r''
		local dfi df(`df`r'')
/*
	Build up RHS2 from the i+1th var to the end 
*/
		local rhs2
		local j `i'
		while `j'<`nx' {
			local j = `j'+1
			local rhs2 `rhs2' `h`r`j'''
		}
		if `initial' {
			if "`rhs2'"!="" {
				local fixed "base(`rhs2')"
			}
			else local fixed
			`VV' ///
			qui FracSel `cmd' `lhs' `ni' `wgt' if `touse', /*
			 */ df(1) `fixed' select(1) `regopt'
			local dev=r(dev)
			di in gr _n /*
			 */ "Deviance for model with all terms " /*
			 */ "untransformed = " in ye %9.3f r(dev) in gr ", " /*
			 */ in ye `nobs' in gr " observations"
		}
		if "`rhs1'`rhs2'"!="" {
			local fixed "base(`rhs1' `rhs2')"
		}
		else local fixed
/*
	Vars with df(1) are straight-line
*/
		local pvalopt "alpha(`alp`r'') select(`sel`r'')"
		if `i'==1 {
			di
		}
		if `df`r''==1 {
			local pw
			local fpo
		}
		else {
			if "`xpow`r''"!="" {
				local pw "powers(`xpow`r'')"
			}
			else local pw "powers(`powers')"
			local fpo `fpopt'
		}
		if `df`r''==1 & `sel`r''==1 {	/* var is included anyway */
			local rhs1 `rhs1' `h`r''
			di in gr "[`ni' included with 1 df in model]" _n
		}
		else {
			if "`stub`r''"!="" {
				local n name(`stub`r'')
			}
			else local n
			`VV' ///
			FracSel `cmd' `lhs' `ni' `wgt' if `touse', `dfi' /*
			 */ `pw' `zero`r'' `catz`r'' `fixed' `h' /*
			 */ `fpo' `regopt' `pvalopt' `n' `sequential' `testlinear'
			local h`r' `r(rhs)'
			local dev=r(dev)
			local p `r(pwrs)'
			if "`p'"!="`po`r''" {
				if `nx'>1 {
					local stable 0
				}
				local po`r' "`p'"
				local lastch `i'
			}
			if "`pwrs'"=="" {
				local pwrs "`p'"
			}
			else local pwrs "`pwrs',`p'"
			if "`h`r''"!="" {
				local rhs1 `rhs1' `h`r''
			}
		}
		if `initial' {
			local h "nohead"
			local initial 0
		}
		local i = `i'+1
	}
	if `lastch'==1 {
		local stable 1
	} /* 1 change only, at i=1 */
	if !`stable' {
		di in smcl in gr "{hline 70}" _n "End of Cycle " in ye `it' in gr /*
		 */ ": deviance =   " in ye %9.3f `dev' _n in gr "{hline 70}"
	}
}
if `nx'>1 {
	local s
	if `it'!=1 {
		local s "s"
	}
	if !`stable' {
		di _n in gr "No convergence" _cont
	}
	else di _n in gr /*
	 */ "Fractional polynomial fitting algorithm converged" _cont
	di in gr " after " in ye `it' in gr " cycle`s'."
}
if `stable' {
	di _n in gr "Transformations of covariates:" _n
}
/*
	Remove variables left behind by frac_154
*/
local i 1
while `i'<=`nx' {
	if "`stub`i''"!="" {
		cap drop `stub`i''*
	}
	local i=`i'+1
}
/*
	Store results
*/
local finalvl	/* predictors in final model */
// PR 22mar2009 -start-
frac_eqmodel k
// PR 22mar2009 -end-
local i 1
while `i'<=`nx' {
	local p `po`i''
	local x `n`i''
	local z `zero`i''
	local c `catz`i''
	local a `adj`i''
/*
	Create FP vars as necessary, with new unique names
*/
	if trim("`p'")!="." {
		local nxi: word count `x'
		if (trim("`p'")=="1" & "`z'`c'`a'"=="") | (`nxi'>1) {
			local namex `x'
		}
		else {
			frac_mun `x'
			local vn `s(name)'
			if "`all'"!="" local restrict restrict(`touse')
			else local ifuse if e(sample)
			fracgen `x' `p' `ifuse', `restrict' `scaling' /*
			 */ `z' `c' `a' name(`vn')
			local namex `r(names)'
		}
		local finalvl `finalvl' `namex'
	}
/*
	Save stuff for FracRep to display
*/
	local npows: word count `p'
// PR 22mar2009 -start-
	if `npows' == 1 & "`p'" == "1" local fd`i' = `k' + `k' * ("`c'"!="")
	else local fd`i' = (`k' + 1) * `npows' + `k' * ("`c'" != "")
	local m = int((`df`i'' + .5) / 2)
	if `m' == 0 local id`i' = `k' + `k' * ("`c'"!="")
	else local id`i' = (`k' + 1) * `m' + `k' * ("`c'" != "")
// PR 22mar2009 -end-
	local i=`i'+1
}
/*
	Estimate final (conditionally linear) model.
*/
`VV' ///
quietly `cmd' `lhs' `finalvl' `wgt' if e(sample), `regopt'
/*
	Store results for each predictor
	(requires expansion if grouped variables present)
*/
global S_1 `finalvl'
global S_2 `dev'
local i 1
local nx2 0	/* number of predictors after expansion of groups (if any) */
while `i'<=`nx' {
	ereturn scalar Fp_fd`i'=`fd`i''	/* final degrees of freedom */
	ereturn scalar Fp_id`i'=`id`i''	/* initial degrees of freedom */
	ereturn scalar Fp_al`i'=`alp`i''	/* FP selection level */
	ereturn scalar Fp_se`i'=`sel`i''	/* var selection levl */
	ereturn local Fp_k`i' `po`i'' 	/* "powers" for ith predictor */

	tokenize `n`i''
	while "`1'"!="" {
		local nx2=`nx2'+1
		ereturn local fp_x`nx2' `1'		/* name of ith predictor in user order */
		ereturn local fp_k`nx2' `po`i'' 	/* "powers" for ith predictor */
		if "`catz`i''"!="" {
			ereturn local fp_c`nx2' 1
		}
		mac shift
	}
	local i=`i'+1
}
ereturn scalar fp_dist=`dist'
ereturn local fp_wgt `weight'
ereturn local fp_exp `exp'
ereturn local fp_depv `lhs'
if `dist'==7 {
	ereturn local fp_depv _t
}
ereturn scalar fp_dev=`dev'
ereturn local fp_rhs	/* deliberately blank for consistency with fracpoly */
ereturn local fp_opts `regopt'
ereturn local fp_fvl `finalvl'
ereturn scalar fp_nx=`nx2'
ereturn local fp_t1t "Fractional Polynomial"
`VV' FracRep "fractional polynomial" "  df  " "Powers" "`level'" "`diopts'"

* Store command to reproduce model using fracpoly.ado (new syntax)
local fracpoly `"fracpoly: `cmd' `lhs'"'
forvalues i=1/`nx2' {
	if "`e(fp_k`i')'"!="." local fracpoly `fracpoly' `e(fp_x`i')' `e(fp_k`i')'
}
if `"`if'"'!="" local fracpoly `fracpoly' `if'
if `"`in'"'!="" local fracpoly `fracpoly' `in'
if `"`weight'`exp'"'!="" local fracpoly `fracpoly' [`weight'`exp']
ereturn local fracpoly `fracpoly'

ereturn local cmdline `"mfp `cmdline'"'
ereturn local fp_cmd "fracpoly"
ereturn local fp_cmd2 "mfp"

end

program define ChkDepvar
	args xlist colon spec

	gettoken depvar spec : spec, parse("()") match(par)
	if ("`par'"!="") {
		di as err "invalid syntax"
		exit 198
	}
	unab depvar : `depvar'
	gettoken depvar rest : depvar
	global MFP_dv $MFP_dv `depvar'
	c_local `xlist' `rest' `spec'
end

program define GetVL /* [y1 [y2]] xvarlist [(xvarlist)] ... */
	macro drop MFP_*

	local xlist `0'
	if $MFpdist != 7 {
		ChkDepvar xlist : `"`xlist'"'
		if $MFpdist == 8 { /* intreg */ 
			ChkDepvar xlist : `"`xlist'"'
		}
	}
	if (`"`xlist'"'=="") {
		error 102
	}
	gettoken xvar xlist : xlist, parse("()") match(par)
	while (`"`xvar'"'!="" & `"`xvar'"'!="[]") {
		unab xvar : `xvar'
		local nvar : word count `xvar'
		if ("`par'"!="" | `nvar'==1) {
			global MFP_n = $MFP_n + 1
			global MFP_$MFP_n "`xvar'"
			global MFP_cur "$MFP_cur `xvar'"
		}
		else {
			tokenize `xvar'
			forvalues i=1/`nvar' {
				global MFP_n = $MFP_n + 1
				global MFP_$MFP_n "``i''"
				global MFP_cur "$MFP_cur ``i''"
			}
		}
		gettoken xvar xlist : xlist, parse("()") match(par)
		if ("`par'"=="(" & `"`xvar'"'=="") {
			di as err "empty () found"
			exit 198
		}
	}
end

program define FracOrd, sclass
local VV : di "version " string(_caller()) ", missing:"
version 8
sret clear
syntax [if] [in] [aw fw pw iw] [, CMd(string) ORDer(string) * ]
if "`cmd'"=="" {
	local cmd "regress"
}
if "`order'"=="" {
	di in red "option {bf:order()} must be specified"
	exit 198
}
local order=bsubstr("`order'",1,1)
if "`order'"!="+" &"`order'"!="-" &"`order'"!="r" &"`order'"!="n" {
	di in red "invalid option {bf:order()}"
	exit 198
}
quietly {
	local nx $MFP_n
	if "`order'"=="n" {
		* variable order as given
		local i 1
		while `i'<=`nx' {
			local r`i' `i'
			local i=`i'+1
		}
	}
	else {
		if "`order'"=="+" | "`order'"=="-" {
			`VV' ///
			`cmd' $MFP_dv $MFP_cur `if' `in' [`weight' `exp'], `options'
		}
		tempvar c n
		tempname p dfnum dfres stat
		gen `c'=.
		gen int `n'=_n in 1/`nx'
		if "`order'"=="+" | "`order'"=="-" {
			local i 1
			while `i'<=`nx' {
				local n`i' ${MFP_`i'}
				capture test `n`i''	/* could comprise >1 variable */
				local rc=_rc
				if `rc'!=0 {
					noi di in red "could not test ${MFP_`i'}---collinearity?"
					exit 1001
				}
				scalar `p'=r(p)
				if missing(`p') scalar `p'=0
/*
				if missing(`p') {
					noi di as err "could not compute P-value for ${MFP_`i'}"
					exit 1001
				}
*/
				if "`order'"=="-" { /* reducing P-value */
					replace `c'=-`p' in `i'
				}
				else replace `c'=`p' in `i'
				local i=`i'+1
			}
		}
		if "`order'"=="r" {
			replace `c'=uniform() in 1/`nx'
		}
		sort `c'
		local i 0
		while `i'<`nx' {
			local i=`i'+1
/*
	Store positions of sorted predictors in user's list
*/
			local j 0
			while `j'<`nx' {
				local j=`j'+1
				if `i'==`n'[`j'] {
					local r`j' `i'
					local j `nx'
				}
			}
		}
	}
}
/*
	Store original positions of variables in ant1, ant2, ...
*/
local i 1
while `i'<=`nx' {
	sret local ant`i' `r`i''
	local i=`i'+1
}
sret local names `names'
end

program define FracSel, rclass
local VV : di "version " string(_caller()) ", missing:"
version 8
gettoken cmd 0 : 0	/* frac_chk `cmd' omitted, caller assumed competent */
if $MFpdist == 8 		local vv varlist(min=3)
else if $MFpdist != 7 	local vv varlist(min=2) 
else 				local vv varlist(min=1)
syntax `vv' [if] [in] [aw fw pw iw] [, /*
*/ ALpha(real .05) SELect(real .05) noHEad DF(int -1) /*
*/ POwers(string) BAse(string) noTIDy CATzero SEQuential noTESTLinear * ]
if `df'==0 | `df'<-1 {
	di in red "invalid df"
	exit 198
}
local cz="`catzero'"!=""
local omit=(`select'<1)
local aic=(`select'==-1 | `alpha'==-1)
if `df'==-1 {
	local df 4
}
local m=int((`df'+.5)/2)	/* df=1 => m=0 => linear */
if `df'==1 {			/* linear */
	if "`powers'"!="" {
		di in red "option {bf:powers()} invalid with option {bf:df(1)}"
		exit 198
	}
	local fixpowers 1
}
else {
	if "`powers'"=="" {
		local powers "-2,-1,-.5,0,.5,1,2,3"
	}
	local powers "powers(`powers')"
	local degree "degree(`m')"
}
// PR 22mar2009 -start-
	frac_eqmodel k
// PR 22mar2009 -end-
if "`weight'"!="" { 
	local weight "[`weight'`exp']"
}
tokenize `varlist'
if $MFpdist == 8 {
	local lhs `1' `2'
	local n `3'
	mac shift 3
}
else if $MFpdist != 7 {
	local lhs `1'
	local n `2'
	mac shift 2
}
else {
	local lhs
	local n `1'
	mac shift 1
}
local nn `*'
if "`head'"=="" {
	di in smcl in gr "Variable" _col(14) "Model" _col(20) "(vs.)" /*
	 */ _col(28) "Deviance" _col(38) "Dev diff.   P      Powers   (vs.)"
	di in smcl "{hline 70}"
}
local vname `n' `nn'
if udstrlen("`vname'")>12 {
	local vname=udsubstr("`vname'",1,9)+"..."
}
local pwrs 1
if "`nn'"!="" | `df'==1 {
	* test linear for single or group of predictors, adjusting for base
	local pwrs2 .
	if "`base'"!="" {
		local base base(`base')
	}
	local n `n' `nn'
	`VV' ///
	qui TestVars `cmd' `lhs' `n' `if' `in' `weight', `base' `options'
	local P = r(P)
	local dev1 = r(dev1)
	local dev0 = r(dev0)
	local d = r(devdif)
	if "`sequential'"=="" {
		local vs1 null
		local vs lin.
		local dfirst `dev0'
	}
	else {
		local vs1 lin.
		local vs null
		local dfirst `dev1'
	}
	if `aic'==0 {
		if `P'<=`select' {
			local star *
			local dev `dev1'
		}
		else {
			local star
			local n
			local dev `dev0'
		}
	}
	else {	/* select by AIC */
		local nnn: word count `n'	/* no. of vars being tested */
		if (`dev1' + 2 * `k' * `nnn') < `dev0' {	// PR 22mar2009
			local star *
			local dev `dev1'
		}
		else {
			local star
			local n
			local dev `dev0'
		}
	}
	di in smcl in gr "`vname'" _col(14) "`vs1'" /*
	 */ _col(21) "`vs'" _col(27) %9.3f in ye `dfirst' /*
	 */ _col(38) %8.3f `d' %7.3f `P' "`star'" /*
	 */ _col(57) "`pwrs2'" _col(67) "`pwrs'"
	if "`n'"=="" {
		local pwrs .
	}
	di in gr _col(14) "Final" _col(27) %9.3f in ye `dev' _col(57) "`pwrs'"
	di
	ret local rhs `n'
	ret local pwrs `pwrs'
	ret scalar dev=`dev'
	exit
}
local xvar `n'
`VV' ///
capture frac_154 `cmd' `lhs' `n' `fixpowers' `nn' `base' `if' `in' /*
 */ `weight', `degree' `powers' `options' `catzero'
local rc=_rc
if `rc'==1 {
	error 1
}
else if `rc' {
	noi di as err "failure encountered when estimating fractional polynomial model"
	noi di as err `"frac_154 `cmd' `lhs' `n' `fixpowers' `nn' `base' `if' `in' `weight', `degree' `powers' `options' `catzero'"'
 	error `rc'
}
local normal=(e(fp_dist)==0)
local nobs=e(fp_N)
local rdf=e(fp_rdf)
local bigpwrs=e(fp_k1)
local bigp `bigpwrs'
/*
	Store deviances for testing,
	starting with index 0 for null model.
*/
local j0 -1
local j 0
while `j'<=(`m'+1) {
	if `j'==0 {
		local dev0=e(fp_d0)
	}
	else if `j'==1 {
		local dev1=e(fp_dlin)
	}
	else local dev`j'=e(fp_d`j0')
	local j0 `j'
	local j=`j'+1
}
/*
	m0 is lowest model entertained.
	m0=-1 => can omit.
*/
if `omit' 	{
	local m0 -1
}
else if `m'==0 	{
	local m0 0
}		/* highest possible model is linear */
else {
	if "`testlinear'"=="notestlinear" {
		local m0 1		/* skip testing m=`m' vs. linear */
	}
	else 	local m0 0		/* standard mfracpol default */
}
local hed `vname'
local star " "
local done 0
if `aic'==0 & "`sequential'"=="" {
/*
	Closed tests
*/
	local m1=`m'+1
	local bigdev `dev`m1''
	if `m'==0 {
		local degmax lin.
	}
	else local degmax FP`m'
	local sig 0
	local j0 `m0'

// PR edit 05may2017
	local n1_0 = (`k' + 1) * `m' + `k' * `cz' // model df for highest-degree fp model
	local n2 = `rdf' - `n1_0' // residual df for highest-degree fp model

// PR 22mar2009 -start-
	while !`done' & `j0' < `m' {
		local j = `j0' + 1
		if `j0' == -1 {		// null vs. model (+catzero)
			local vs null
			if `m' == 0 {	// null vs. linear (+cz)
				local n1 = `k' * (1 + `cz')
			}
			else 	local n1 = (`k' + 1) * `m' + `k' * `cz'
			local pwrs "."
		}
		else if `j0' == 0 {	// linear (+cz) vs. m (+cz)
			local vs lin.
			local n1 = (`k' + 1) * `m' - `k'
			local pwrs 1
		}
		else {
			local n1 = (`k' + 1) * (`m' - `j0') // m (+cz) vs m0 (+cz)
			local vs "FP`j0'"
			local pwrs = e(fp_p`j0')
		}
// PR 22mar2009 -end-
// PR deletion 05May2017: `n2' does not change since most complex model does not change
//		local n2=`rdf'-`n1'
		local d=`dev`j''-`bigdev'
		frac_pv `normal' "`weight'" `nobs' `d' `n1' `n2'
		local P = r(P)
		local pnom=cond(`j0'==-1,`select',`alpha')
		local ss=cond(`j0'==-1,"*","+")
		if `alpha'==1 & `j0'>-1 {
			local j0 `m'		/* finished */
		}
		else if `P'<=`pnom' {
			local sig 1
			local star `ss'
		}
		di in smcl in gr "`hed'" _col(14) "`vs'" /*
		 */ _col(21) "`degmax'" _col(26) %10.3f in ye `dev`j'' /*
		 */ _col(38) %8.3f `d' %7.3f `P' "`star'" /*
		 */ _col(57) "`pwrs'" _col(67) "`bigp'"
		local hed
		local degmax
		local bigp
		if `j0'<`m' & `P'>`pnom' {
			local done 1
			local dev `dev`j''
			if `j0'==-1 {		/* drop */
				local n
			}
			else {
/*
	Not sig, so selecting degree less than m.
	Re-estimate powers, shd be unnecessary.
*/
				qui fracgen `n' `pwrs', /*
				 */ `options' `catzero' replace
				local n `r(names)'
			}
		}
		local star " "
		if `m'>0 & `j0'==-1 & "`testlinear'"=="notestlinear" {
			local j0 1			/* skip testing linear */
		}
		else 	local j0=`j0'+1
	}
	if !`done' {	/* highest model was best */
		local done 1
		local dev `bigdev'
		local pwrs `bigpwrs'
		qui fracgen `n' `pwrs', `options' `catzero' replace
		local n `r(names)'
	}
}
if `aic' {		/* AIC selection of function and/or variable */
	local ss `star'
	if `m'==0 {
		local degmax lin.
	}
	else local degmax FP`m'
	if `alpha'==1 {			/* do not optimize function */
		* null model
		GetParam `m0' `cz'
		local vs_0 `s(desc)'
		local df_0 `s(df)'
		local pwrs_0 `s(pwrs)'
		local dev_0 `dev`s(j)''
		* max model
		GetParam `m' `cz'
		local vs_1 `s(desc)'
		local df_1 `s(df)'
		local pwrs_1 `s(pwrs)'
		local dev_1 `dev`s(j)''
		* compute AICs
		forvalues j=0/1 {
			local aic_`j'=`dev_`j''+2*`df_`j''
			di in gr "`hed'" _col(14) "`vs_`j''" /*
			 */ _col(26) %10.3f in ye `dev_`j'' /*
			 */ _col(57) "`pwrs_`j''"
			 local hed
		}
		if `select'==1 | (`select'==-1 & (`aic_1'<`aic_0')) {
			* accept max model
			local sig 1
			local ss "*"
			qui fracgen `n' `pwrs_1', /*
			 */ `options' `catzero' replace
			local n `r(names)'
			local pwrs `pwrs_1'
			local dev `dev_1'
		}
		else {
			* drop
			local n
			local pwrs `pwrs_0'
			local dev `dev_0'
		}
	}
	else {		/* optimize function */
		local aicopt .
		local jopt .
		forvalues j=`m0'/`m' {
			if "`testlin'"!="notestlinear" | `j'!=0 {
				GetParam `j' `cz'
				local Aic=`dev`s(j)''+2*`s(df)'
				di in gr "`hed'" _col(14) "`s(desc)'" /*
				 */ _col(26) %10.3f in ye `dev`s(j)'' /*
				 */ _col(57) "`s(pwrs)'"
				if `Aic'<`aicopt' {
					local jopt `j'
					local aicopt `Aic'
				}
				local hed
			}
		}
		* Opt values
		GetParam `jopt' `cz'
		local pwrs `s(pwrs)'
		local dev `dev`s(j)''
		if `jopt'==-1 {
			* drop
			local n
		}
		else {
			* accept
			local ss=cond(`m0'==-1,"*","+")
			qui fracgen `n' `pwrs', `options' `catzero' replace
			local n `r(names)'
		}
	}
}
if `aic'==0 & "`sequential'"!="" {
/*
	Sequential tests
	Note: ignores undocumented testlinear option for dropping m=1 vs. linear comparison
*/
	local j0 `m'
	while !`done' & `j0'>`m0' {
		local j=`j0'-1
		if `j0'==0 {		/* null vs. linear (+cz) */
			local vs1 lin.
			local vs null
			local n1 = `k' * (1 + `cz')	// PR 22mar2009
			local pwrs 1
			local pwrs2 .
		}
		else if `j0'==1 {	/* linear vs. m=1 */
			local n1 1
			local vs1 FP1
			local vs lin.
			local pwrs=e(fp_p`j0')
			local pwrs2 1
		}
		else {
			local n1 = `k' + 1	// PR 22mar2009
			local vs1 "FP`j0'"
			local vs "FP`j'"
			local pwrs=e(fp_p`j0')
			local pwrs2=e(fp_p`j')
		}
		local j1=`j0'+1
		local d=`dev`j0''-`dev`j1''
		local n2=`rdf'-`n1'
		frac_pv `normal' "`weight'" `nobs' `d' `n1' `n2'
		local P = r(P)
		local pnom=cond(`j0'==0,`select',`alpha')
		local ss=cond(`j0'==0,"*","+")
		if `P'<=`pnom' {
			local done 1
			local star *
			local dev `dev`j1''
			qui fracgen `n' `pwrs', `options' `catzero' replace
			local n `r(names)'
		}
		else local dev `dev`j0''
		di in smcl in gr "`hed'" _col(14) "`vs1'" /*
		 */ _col(21) "`vs'" _col(26) %10.3f in ye `dev`j1'' /*
		 */ _col(38) %8.3f `d' %7.3f `P' "`star'" /*
		 */ _col(57) "`pwrs'" _col(67) "`pwrs2'"
		local hed
		local j0 `j'
	}
	if !`done' {
		if `omit' {	/* drop */
			local pwrs "."
			local n
			local dev `dev0'
		}
		else {		/* linear */
			local pwrs 1
			qui fracgen `n' `pwrs', `options' `catzero' replace
			local n `r(names)'
			local dev `dev1'
		}
	}
}
di in smcl in gr _col(14) "Final" _col(28) in ye %8.3f `dev' _col(57) "`pwrs'"
local rhs "`rhs' `n'"
di
ret local rhs `rhs'
ret local pwrs `pwrs'
ret scalar dev=`dev'
ret local n `n'
end

program define FracAdj, rclass
version 8
* Inputs: 1=macro `adjust', 2=case filter.
* Returns adjustment values in r(adj1),...
* Returns number of unique values in r(uniq1),...

args adjust touse
if "`adjust'"=="" {
	FracDis mean adjust
}
else FracDis "`adjust'" adjust
tempname u
local i 1
while `i'<=$MFP_n {
	local x ${MFP_`i'}
	quietly inspect `x' if `touse'
	scalar `u'=r(N_unique)
	local nx: word count `x'
	if `nx'==1 {	/* can only adjust if single predictor */
		local a ${S_`i'}
		if "`a'"=="" | "`adjust'"=="" {	/* identifies default cases */
			if `u'==1 {		/* no adjustment */
				local a
			}
			else if `u'==2 {	/* adjust to min value */
				quietly summarize `x' if `touse', meanonly
				if r(min)==0 {
					local a
				}
				else local a=r(min)
			}
			else local a mean
		}
		else if "`a'"=="no" {
			local a
		}
		else if "`a'"!="mean" {
			confirm num `a'
		}
	}
	return local adj`i' `a'
	return scalar uniq`i'=`u'
	local i=`i'+1
}
end

program define FracDis
version 8
* Disentangle varlist:string clusters---e.g. for DF.
* Returns values in $S_*.
* If `3' is null, lowest and highest value checking is disabled.

local target "`1'"		/* string to be processed */
local tname "`2'"		/* name of option in calling program */
if "`3'"!="" {
	local low "`3'"		/* lowest permitted value */
	local high "`4'"	/* highest permitted value */
}
tokenize "`target'", parse(",")
local ncl 0 			/* # of comma-delimited clusters */
while "`1'"!="" {
	if "`1'"=="," {
		mac shift
	}
	local ncl=`ncl'+1
	local clust`ncl' "`1'"
	mac shift
}
if "`clust`ncl''"=="" {
	local ncl=`ncl'-1
}
if `ncl'>$MFP_n {
	di in red "too many `tname'() values specified"
	exit 198
}
/*
	Disentangle each varlist:string cluster
*/
local i 1
while `i'<=`ncl' {
	tokenize "`clust`i''", parse("=:")
	// PR bug fix: trailing blanks in list of variables cause problems
	local 1 = trim("`1'")
	if "`2'"!=":" & "`2'"!="=" {
		if `i'>1 {
			noi di in red /*
			*/ "invalid `tname'() value `clust`i''" /*
		 	*/ ", must be first item"
			exit 198
		}
		local 2 ":"
		local 3 `1'
		local j 0
		local 1
		while `j'<$MFP_n {
			local j=`j'+1
			local nxi: word count ${MFP_`j'}
			if `nxi'>1 {
				 local 1 `1' (${MFP_`j'})
			}
			else local 1 `1' ${MFP_`j'}
		}
	}
	local arg3 `3'
	if "`low'"!="" & "`high'"!="" {
		cap confirm num `arg3'
		if _rc {
			di in red "invalid `tname'() value `arg3'"
			exit 198
		}
		if `arg3'<`low' | `arg3'>`high' {
			di in red /*
			*/ "`tname'() value `arg3' out of allowed range"
			exit 198
		}
	}
	while "`1'"!="" {
		gettoken tok 1 : 1
		if bsubstr("`tok'",1,1)=="(" {
			local list
			while bsubstr("`tok'",-1,1)!=")" {
				if "`tok'"=="" {
					di in red "{it:varlist} invalid"
					exit 198
				}
				local list "`list' `tok'"
				gettoken tok 1 : 1
			}
			unabbrev `list' `tok'
			local w `s(varlist)'
			FracIn "`w'"
			local v`s(k)' `arg3'
		}
		else {
			unabbrev `tok'
			local tok `s(varlist)'
			local j 1
			local w : word 1 of `tok'
			while "`w'" != "" {
				FracIn `w'
				local v`s(k)' `arg3'
				local j=`j'+1
				local w : word `j' of `tok'
			}
		}
	}
	local i = `i'+1
}
local j 0
while `j'<$MFP_n {
	local j=`j'+1
	if "`v`j''"!="" {
		global S_`j' `v`j''
	}
	else global S_`j'
}
end

program define FracIn, sclass /* target varname/varlist */
version 8
* Returns s(k) = index # of target in MFP varlists.
args v
unab v : `v'
sret clear
sret local k 0
local j 0
while `j'<$MFP_n {
	local j = `j'+1
	if "`v'"=="${MFP_`j'}" {
		sret local k `j'
		local j $MFP_n
	}
}
if `s(k)'==0 {
   	di in red "`v' is not an xvar"
   	exit 198
}
end

program define FracRep
* 1=descriptor e.g. FRACTIONAL POLYNOMIAL
* 2=param descriptor e.g. df
* 3=param names e.g. powers
* 4=level for confidence intervals
version 8
local VV : di "version " string(_caller()) ", missing:"
args desc param paramv level options
if "`level'" == "" {
	local level = c(level)
}
local i 1
local l=udstrlen("`paramv'")
while `i'<=$MFP_n {
	local l=max(`l',udstrlen("`e(Fp_k`i')'"))
	local i=`i'+1
}

local l=`l'+48
local title "Final multivariable `desc' model for `e(fp_depv)'"
local lt=length("`title'")
di in smcl _n in gr "`title'"
di in smcl in gr "{hline 13}{c TT}{hline `l'}"
di in smcl in gr _skip(4) "Variable {c |}" _col(19) "{hline 5}" _col(24) /*
 */ "Initial" /*
 */ _col(31) "{hline 5}" _col(46) "{hline 5}" _col(51) "Final" /*
 */ _col(56) "{hline 5}"
di in smcl in gr _col(14) "{c |} `param'"/*
 */ _col(25) "Select" /*
 */ _col(34) "Alpha" /*
 */ _col(43) "Status" /*
 */ _col(51) "`param'" /*
 */ _col(59) "`paramv'"
di in smcl in gr "{hline 13}{c +}{hline `l'}"
local i 1
while `i'<=$MFP_n {
	local pars `e(Fp_k`i')'
	if "`pars'"=="" | "`pars'"=="." {
		local final 0
		local status out
		local pars
	}
	else {
		local status in
		local final=e(Fp_fd`i')
	}
	local name ${MFP_`i'}
	local skip=12-udstrlen("`name'")
	if `skip'<=0 {
		local name=udsubstr("`name'",1,9)+"..."
		local skip 0
	}
	local select=e(Fp_se`i')
	local alpha=e(Fp_al`i')
	if `select'==-1 {
		local select " A.I.C."
	}
	else local select: di %7.4f `select'
	if `alpha'==-1 {
		local alpha " A.I.C."
	}
	else local alpha: di %7.4f `alpha'

	di in smcl in gr _skip(`skip') "`name' {c |}" in ye /*
	 */ _col(19) e(Fp_id`i') /*
	 */ _col(24) "`select'" /*
	 */ _col(33) "`alpha'" /*
	 */ _col(45) "`status'" /*
	 */ _col(53) "`final'" /*
	 */ _col(59) "`pars'"
	local i=`i'+1
}
di in smcl in gr "{hline 13}{c BT}{hline `l'}"
if "`e(cmd2)'"=="stpm" `VV' ml display, level(`level') `options'
else `VV' `e(cmd)', level(`level') `options'
di in smcl in gr "Deviance:" in ye %9.3f e(fp_dev) in gr "."
end

* version 1.0.0 PR 11Jul2002.
program define TestVars, rclass /* LR-blocktests variables in varlist, adj base */
	local VV : di "version " string(_caller()) ":"
	version 8
	gettoken cmd 0 : 0, parse(" ")
	frac_chk `cmd' 
	if `s(bad)' {
		di in red "invalid or unrecognized command, `cmd'"
		exit 198
	}
	local dist `s(dist)'
	local glm `s(isglm)'
	local qreg `s(isqreg)'
	local xtgee `s(isxtgee)'
	local normal `s(isnorm)'
	if $MFpdist == 8 local vv varlist(min=3)
	else if $MFpdist != 7 local vv varlist(min=2) 
	else local vv varlist(min=1)
	syntax `vv' [if] [in] [aw fw pw iw], /*
	 */ [, DEAD(string) noCONStant BASE(varlist) * ]
	frac_cox "`dead'" `dist'
	if "`constant'"=="noconstant" {
		if "`cmd'"=="fit" | "`cmd'"=="cox" | $MFpdist==7 {
			di in red "noconstant invalid with `cmd'"
			exit 198
		}
		local options "`options' nocons"
	}
	tokenize `varlist'
	if $MFpdist != 7 {
		local y `1'
		mac shift
		if $MFpdist == 8 {
			local y1 `y'
			local y2 `1'
			local y `y1' `y2'
			mac shift
		}
	}
	local rhs `*'
	tempvar touse
	quietly {
		mark `touse' [`weight' `exp'] `if' `in'
		_fix_for_intreg $MFpdist "`y'" `touse' "`rhs' `base' `dead'"
		if "`dead'"!="" {
			local options "`options' dead(`dead')"
		}
	/*
		Deal with weights.
	*/
		frac_wgt `"`exp'"' `touse' `"`weight'"'
		local mnlnwt = r(mnlnwt) /* mean log normalized weights */
		local wgt `r(wgt)'
		count if `touse'
		local nobs = r(N)
	}
	/*
		Calc deviance=-2(log likelihood) for regression on base covars only,
		allowing for possible weights.
	
		Note that for logit/clogit/logistic with nocons, must regress
		on zero, otherwise get r(102) error.
	*/
	if (`glm' | `dist'==1) & "`constant'"=="noconstant" {
		tempvar z0
		qui gen `z0'=0
	}
	`VV' ///
	qui `cmd' `y' `z0' `base' `wgt' if `touse', `options'
	if `xtgee' & "`base'"=="" {
		global S_E_chi2 0
	}
	if `glm' {
		* Note: with Stata 8 scale param is e(phi); was e(delta) in Stata 6
		* Also e(dispersp) has become e(dispers_p).
 		loc scale 1
 		local small 1e-6
 		if abs(e(dispers_p)/e(phi)-1)>`small' & /*
		*/ abs(e(dispers)/e(phi)-1)>`small' {
			loc scale = e(phi)
 		}
	}
	frac_dv `normal' "`wgt'" `nobs' `mnlnwt' `dist' /*
		*/ `glm' `xtgee' `qreg' "`scale'"
	local dev0 = r(deviance)
	if `normal' {
		local rsd0=e(rmse)
	}
	/*
		Fit full model
	*/
	`VV' ///
	`cmd' `y' `rhs' `base' `wgt' if `touse', `options'
	frac_dv `normal' "`wgt'" `nobs' `mnlnwt' `dist' `glm' /*
 	*/ `xtgee' `qreg' "`scale'"
	local dev1 = r(deviance)
	if `normal' {
		local rsd1=e(rmse)
	}
	// PR 22mar2009 -start-
	local df: word count `rhs'
	local bdf: word count `base'
	frac_eqmodel k
	local df = `df' * `k'
	// PR 22mar2009 -end-
	local df_r = `nobs'-`df'-`bdf'-("`constant'"!="noconstant")
	local d=`dev0'-`dev1'
	frac_pv `normal' "`wgt'" `nobs' `d' `df' `df_r'
	local P = r(P)
	di in smcl in gr "Deviance 1:" in ye %9.2g `dev1' in gr ". " _cont
	di in smcl in gr "Deviance 0:" in ye %9.2g `dev0' in gr ". "
	di in smcl in gr "Deviance d:" in ye %9.2g `d' in gr ". P = " in ye %8.4f `P'
	* store
	return scalar dev0 = `dev0'
	return scalar dev1 = `dev1'
	if `normal' {
		return scalar s0 = `rsd0'
		return scalar s1 = `rsd1'
	}
	return scalar df_m = `df'
	return scalar df_r = `df_r'
	return scalar devdif = `d'
	return scalar P=`P'
	return scalar N = `nobs'
end

program define GetParam, sclass
/*
	For given model j0, return its descriptor, numerator df and powers.
	cz is catzero indicator.
	j0: -1 null model, 0 linear, >0 FPj0
	Returns s(j) as index for dev`j' local macros
*/
// PR 22mar2009 -start-
frac_eqmodel k
// PR 22mar2009 -end-
args j0 cz
if `j0'==-1 {
	local desc null
	local n1 0
	local pwrs .
}
else if `j0'==0 {
	local desc lin.
	local n1 = `k' * (1 + `cz') // PR 22mar2009
	local pwrs 1
}
else {
	local desc FP`j0'
	local n1 = (`k' + 1) * `j0' + `k' * `cz' // PR 22mar2009
	local pwrs=e(fp_p`j0')
}
local j=`j0'+1
sret local j `j'
sret local desc `desc'
sret local df `n1'
sret local pwrs `pwrs'
end

program define _fix_for_intreg
version 8
	args dist dv touse markout
	if `dist' == 8 {
		local y1 : word 1 of `dv'
		local y2 : word 2 of `dv'
		replace `touse' = 0 if `y1'>=. & `y2'>=.
		replace `touse' = 1 if `touse'==0 & ///
		 ((`y1'<. & `y2'>=.) | (`y1'>=. & `y2'<.))
		markout `touse' `markout'
	}
	else markout `touse' `markout' `dv'
end

