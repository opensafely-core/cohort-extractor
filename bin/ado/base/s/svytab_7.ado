*! version 1.2.8  09feb2006
program define svytab_7, sortpreserve
	version 6, missing
	if replay() {
		if `"`e(cmd)'"'!="svytab" {
			error 301
		}
		Display `0'  /* display results */
		exit
	}
	nobreak {
		capture noisily break {
			tempvar doit subvar

			SvyParse `doit' `subvar' `0'

			local dopt "$S_VYdopt" /* save display options */

			SvyTab `doit' `subvar'
		}
		local rc = _rc
		macro drop S_VY*

		if `rc' {
			estimates clear
			exit `rc'
		}
	}
	Display, `dopt'  /* display results */
end

program define SvyTab, eclass
	args doit subvar

	tempname /* matrices */ Obs  ObsSub b V Vdeff cstub rstub b0 row col /*
	*/                      Vrow Vcol Vfrow Vfcol X1 X2 D Da
	tempname /* scalars  */ s zero Xp Xlr Wl Wp tr tr2 tra tr2a /*
	*/                      mgdeff cv total N_pop
	tempvar cat

	if "$S_VYwgt"!="" {
		local wt "[iw=$S_VYexp]"
	}

/* Set-up for inclusion of tab() variable. */

	if "$S_VYtab"!="" {
		local mult "$S_VYtab*"
		local vartype : type $S_VYtab
		local type "ratio"
		Total `total' $S_VYtab `doit' `subvar'
	}
	else {
		local vartype "byte"
		local type "mean"
	}

/* Generate 0/1 dummies. */

	quietly {
		sort `doit' $S_VYvar1 $S_VYvar2
		by `doit' $S_VYvar1 $S_VYvar2: gen byte `cat' = (_n==1) /*
		*/ if `doit'
/* trace1 */
		if "$S_VYsub" ~= "" {
			tab $S_VYvar1 $S_VYvar2 if `doit' , $S_VYmiss /*
				*/ matcell(`ObsSub') subpop($S_VYsvar)
		}
		tab $S_VYvar1 $S_VYvar2 if `doit', $S_VYmiss matcell(`Obs') /*
		*/ matrow(`rstub') matcol(`cstub')
		mat `rstub' = `rstub''
		local nrow = _result(2)
		local ncol = _result(3)

		replace `cat' = sum(`cat') if `doit'
		local ncat = `cat'[_N]

		local k 1
		while `k' <= `ncat' {
			tempvar x
			gen `vartype' `x' = `mult'(`cat'==`k') if `doit'
			local vars "`vars' `x' $S_VYtab" /* cell proportions */
			local vt   "`vt' `x'" /* totals */
			local k = `k' + 1
		}

		if "$S_VYse"=="row" | "$S_VYse"=="column"  {
			if "$S_VYse"=="row" {
				local var $S_VYvar1
				local colo "*"
			}
			else {
				local var $S_VYvar2
				local rowo "*"
			}
			tempvar catx
			sort `doit' `var'
			by `doit' `var': gen byte `catx' = (_n==1) /*
			*/ if `doit'
			replace `catx' = sum(`catx') if `doit'
			local ncatx = `cat'[_N]
			local i 1
			while `i' <= `ncatx' {
				tempvar x`i'
				gen `vartype' `x`i'' = `mult'(`catx'==`i') /*
				*/ if `doit'
				local i = `i' + 1
			}
			local i 1
			local j 1
			local k 1
			while `k' <= `ncat' {
				tempvar x
				gen `vartype' `x' = `mult'(`cat'==`k') if `doit'

				while `Obs'[`i',`j'] == 0 {
					local j = mod(`j',`ncol')+1
					local i = cond(`j'==1,`i'+1,`i')
				}

				`rowo' local vs "`vs' `x' `x`i''"
				`colo' local vs "`vs' `x' `x`j''"

				local k = `k' + 1
				local j = mod(`j',`ncol')+1
				local i = cond(`j'==1,`i'+1,`i')
			}
		}
	}

/* Put value labels into stub vectors. */

	ValueLab $S_VYvar1 `rstub' 1
	ValueLab $S_VYvar2 `cstub' 2

/* Call to _svy for point estimates and variance of proportions. */

	if "$S_VYse"!="count" {
		local opts "vsrs(`Vdeff') $S_VYsrss"
	}
	_svy `vars' `wt' if `doit', type(`type') $S_VYopt /*
	*/ b(`b') v(`V') `opts'

	local  n        `r(N)'
	global S_VYnobs `r(N)'
	global S_VYnstr `r(N_strata)'
	global S_VYnpsu `r(N_psu)'
	scalar `N_pop' = r(N_pop)

	if "$S_VYtab"=="" {
		if "$S_VYsub"=="" {
			scalar `total' = r(N_pop)
		}
		else	scalar `total' = r(N_subpop)
	}

	if "$S_VYsub"!="" {
		global S_VYosub `r(N_sub)'
		tempname N_spop
		scalar `N_spop' = r(N_subpop)
	}

/* Get variance of totals. */

	if "$S_VYwald"!="" | "$S_VYse"=="count" {
		if "$S_VYse"=="count" {
			tempname bs
			local topts "b(`bs') vsrs(`Vdeff') $S_VYsrss"
		}
		tempname Vt
		_svy `vt' `wt' if `doit', type(total) $S_VYopt /*
		*/ v(`Vt') `topts'
	}

/* Get variance estimates for row or column proportions. */

	if "$S_VYse"=="row" | "$S_VYse"=="column" {
		tempname bs Vs
		_svy `vs' `wt' if `doit', type(ratio) $S_VYopt /*
		*/ b(`bs') v(`Vs')
	}

/* If `ncat'!=`nrow'*`ncol', then zeros need to be added to `b'. */

	if `ncat'!=`nrow'*`ncol' {
		AddZeros `Obs' `b' `V' `Vdeff' `Vt' `bs' `Vs'
	}

/* Get marginal row and column sums. */

	Marginal `nrow' `ncol' `b' `row' `col'

/* Get variance estimates for margins. */

	if "$S_VYse"!="count" {
		VMargin `nrow' `ncol' `V' `Vrow' `Vcol'
	}
	else	VMargin `nrow' `ncol' `Vt' `Vrow' `Vcol'

	VMargin `nrow' `ncol' `Vdeff' `Vfrow' `Vfcol'

/* Get expected values of proportions assuming independence: b0 = pi.*p.j. */

	Getb0 `row' `col' `b0'

/* `zero' = true if there is a zero in marginal totals (sum of weights must be
   zero for this to occur).
*/
	ChkZero `row' `col' `zero'

/* `one' = true if there is only one row or column. */

	local one = (`nrow'==1 | `ncol'==1)

	if !`zero' & !`one' {

/* Compute unadjusted statistics. */

	/* Pearson statistic. */

		Pearson `n' `b' `b0' `Xp'

	/* Likelihood ratio statistic. */

		LikeRat `n' `b' `b0' `Xlr'

	/* Get contrasts for test of independence. */

		IndCon `nrow' `ncol' `X1' `X2'

/* Compute adjustment factors and Wald tests. */

	/* Compute design effects matrix D using b0. */

		DeffMat `n' `b0' `V' `X2' `D' `tr' `tr2'

	/* Compute design effects matrix D using b. */

		DeffMat `n' `b' `V' `X2' `Da' `tra' `tr2a'

	/* Check against other methods.  COMMENTED OUT.  FOR TESTING ONLY.
        *
        *	Check `tr' `tra' `b' `b0' `V' `row' `col' `X1' `X2' `D' `Da'
	*/

	/* Standard log-linear Wald test. */

		LLWald `b' `b' `V' `X2' `Wl'

	/* Pearson Wald test. */

		if "$S_VYwald"!="" {
			PearWald `b' `Vt' `total' `row' `col' `Wp'
		}
	}
	else	SetMiss `Xp' `Xlr' `tr' `tr2' `tra' `tr2a' `Wl' `Wp'

/* Mean generalized deff and C.V. of eigenvalues. */

	local dfnom = (`nrow'-1)*(`ncol'-1)
	scalar `mgdeff' = `tr'/`dfnom'
	scalar `cv' = sqrt(`dfnom'*`tr2'/`tr'^2 - 1)

/*------------------------------ Save results ------------------------------*/

/* Post `bs' and `Vs'. */

	if "$S_VYse"=="" {
		tempname bs
		mat `bs' = `b' /* `bs' destroyed by post; we want to save `b' */
		local Vs "`V'"
	}
	else if "$S_VYse"=="count" {
		local Vs  "`Vt'"
	}

	LabelMat `nrow' `ncol' `b' `bs' `Vs'

	local dof = $S_VYnpsu - $S_VYnstr

	estimates post `bs' `Vs', dof(`dof') obs($S_VYnobs) depn("svytab") /*
	*/ esample(`doit')

/* Adjust and save Pearson and LR statistics. */

	MakeStat `dfnom' `tr'  `tr2'  `Xp'  Penl
	MakeStat `dfnom' `tra' `tr2a' `Xp'  Pear
	MakeStat `dfnom' `tr'  `tr2'  `Xlr' LRnl
	MakeStat `dfnom' `tra' `tr2a' `Xlr' LR
	MakeFull `dfnom' `tr'  `tr2'  `Xp'  Full

/* Adjust and save Wald tests. */

	MakeWald `dfnom' `Wl' LLW
	if "$S_VYwald"!="" {
		MakeWald `dfnom' `Wp' Wald
	}

/* Save other results. */

	SvySave `N_pop' "`N_spop'" `nrow' `ncol' `total' `zero' /*
	*/ `mgdeff' `cv' `Obs' `b' `rstub' `cstub' `Vrow' `Vcol' `Vdeff' /*
	*/ `Vfrow' `Vfcol' "`ObsSub'"
end

program define MakeStat, eclass
	args dfnom tr tr2 stat name

	est scalar cun_`name' = `stat'
	est scalar F_`name'   = `stat'/`tr'
	est scalar df1_`name' = `tr'^2/`tr2'
	est scalar df2_`name' = (`tr'^2/`tr2')*($S_VYnpsu - $S_VYnstr)
	est scalar p_`name'   = fprob(e(df1_`name'),e(df2_`name'),e(F_`name'))
end

program define MakeFull, eclass /* Fuller et al. variant */
	args dfnom tr tr2 stat name

	tempname tr3
	scalar `tr3' = `tr2' - `tr'^2/($S_VYnpsu-$S_VYnstr)
	if `tr3' < 0 { scalar `tr3' = . }

	est scalar cun_`name' = `stat'
	est scalar F_`name'   = `stat'/`tr'
	est scalar df1_`name' = min(`tr'^2/`tr3',`dfnom')
	est scalar df2_`name' = $S_VYnpsu - $S_VYnstr
	est scalar p_`name'   = fprob(e(df1_`name'),e(df2_`name'),e(F_`name'))
end

program define MakeWald, eclass
	args df1 chi name
	local dfv = $S_VYnpsu - $S_VYnstr

	est scalar F_`name' = (`dfv'-`df1'+1)*`chi'/(`df1'*`dfv')
	if e(F_`name') < 0 { est scalar F_`name' = . }

	est scalar p_`name' = fprob(`df1',`dfv'-`df1'+1,e(F_`name'))

	est scalar cun_`name' = `chi'        /* unadjusted */
	est scalar Fun_`name' = `chi'/`df1'
	est scalar pun_`name' = fprob(`df1',`dfv',`chi'/`df1')
end

program define Pearson
	args n b b0 X

	tempname A B
	mat `A' = diag(`b0')
	mat `A' = syminv(`A')
	mat `B' = `b' - `b0'
	mat `A' = `A'*`B''
	mat `A' = `B'*`A'
	scalar `X' = `n'*`A'[1,1]
end

program define LikeRat
	args n b b0 X

	local dim = colsof(`b')
	scalar `X' = 0
	local i 1
	while `i' <= `dim' {
		scalar `X' = `X' + `b'[1,`i']*log(`b'[1,`i']/`b0'[1,`i'])
		local i = `i' + 1
	}

	scalar `X' = 2*`n'*`X'
end

program define LLWald
	args b b0 V C X

	tempname A B G logbi
	local dim = colsof(`b')
	mat `G' = J(`dim',1,0)
	local i 1
	while `i' <= `dim' {
		scalar `logbi' = log(`b'[1,`i'])
		if `logbi'>=. {
			scalar `X' = .
			exit
		}
		mat `G'[`i',1] = `logbi'
		local i = `i' + 1
	}

	mat `G' = `C''*`G'
	mat `B' = diag(`b0')
	mat `B' = syminv(`B')
	mat `A' = `V'*`B'
	mat `A' = `B'*`A'
	mat `A' = `A'*`C'
	mat `A' = `C''*`A'
	SymInv `A'
	mat `A' = `A'*`G'
	mat `A' = `G''*`A'

	scalar `X' = `A'[1,1]
end

program define PearWald
	args b V total row col X

	tempname A B W b0ij

	local nrow = colsof(`row')
	local ncol = colsof(`col')
	local dfnom = (`nrow'-1)*(`ncol'-1)
	local dim = `nrow'*`ncol'

	mat `A' = J(`dfnom',`dim',0)
	mat `B' = J(1,`dfnom',0)

	local k 1
	local i 1
	while `i' < `nrow' {
		local j 1
		while `j' < `ncol' {
			local l = `ncol'*(`i'-1) + `j'
			scalar `b0ij' = `row'[1,`i']*`col'[1,`j']
			mat `B'[1,`k'] = `b'[1,`l'] - `b0ij'
			local m 1
			local g 1
			while `g' <= `nrow' {
				local h 1
				while `h' <= `ncol' {

		if `g'==`i' | `h'==`j' {
			if `g'==`i' & `h'!=`j' {
				mat `A'[`k',`m'] = -`col'[1,`j'] + `b0ij'
			}
			else if `g'!=`i' & `h'==`j' {
				mat `A'[`k',`m'] = -`row'[1,`i'] + `b0ij'
			}
			else {
				mat `A'[`k',`m'] = /*
				*/ 1 - `row'[1,`i'] - `col'[1,`j'] + `b0ij'
			}
		}
		else	mat `A'[`k',`m'] = `b0ij'

					local m = `m' + 1
					local h = `h' + 1
				}
				local g = `g' + 1
			}
			local k = `k' + 1
			local j = `j' + 1
		}
		local i = `i' + 1
	}

	mat `W' = `V'*`A''
	mat `W' = `A'*`W'
	SymInv `W'
	mat `W' = `W'*`B''
	mat `W' = `B'*`W'

	scalar `X' = `total'^2*`W'[1,1]
end

program define DeffMat
	args n b V C D tr tr2

	tempname B
	mat `B' = diag(`b')
	mat `B' = syminv(`B')
	mat `D' = `V'*`B'
	mat `D' = `B'*`D'
	mat `D' = `D'*`C'
	mat `D' = `C''*`D'
	mat `B' = `B'*`C'
	mat `B' = `C''*`B'
	SymInv `B'
	mat `D' = `B'*`D'
	mat `D' = `n'*`D'

	scalar `tr' = trace(`D')
	mat `B' = `D'*`D'
	scalar `tr2' = trace(`B')
end

program define Sym
	args X /* matrix in, replaced with exactly symmetric matrix */
	mat `X' = 0.5*(`X'' + `X')
	*tempname Y
	*mat `Y' = `X''
	*mat `Y' = `Y' + `X' /* labels picked from right */
	*mat `X' = 0.5*`Y'
end

program define SymInv
	args X /* matrix in, replaced with inverse */
	Sym `X'
	mat `X' = syminv(`X')
end

program define Marginal
	args nrow ncol b row col

	tempname A B

	mat `A' = I(`nrow')
	mat `B' = J(1,`ncol',1)
	mat `A' = `A' # `B'
	mat `row' = `b'*`A''

	mat `A' = J(1,`nrow',1)
	mat `B' = I(`ncol')
	mat `A' = `A' # `B'
	mat `col' = `b'*`A''
end

program define VMargin
	args nrow ncol V Vrow Vcol

	tempname A B

	mat `A' = I(`nrow')
	mat `B' = J(1,`ncol',1)
	mat `A' = `A' # `B'
	mat `Vrow' = `V'*`A''
	mat `Vrow' = `A'*`Vrow'
	Sym `Vrow'

	mat `A' = J(1,`nrow',1)
	mat `B' = I(`ncol')
	mat `A' = `A' # `B'
	mat `Vcol' = `V'*`A''
	mat `Vcol' = `A'*`Vcol'
end

program define Getb0
	args row col b0

	tempname A B

/* Compute expected cell proportions. */

	mat `A' = `row''*`col'

/* Convert into a row vector. */

	mat `b0' = `A'[1,1...]
	local nrow = colsof(`row')
	local i 2
	while `i' <= `nrow' {
		mat `B' = `A'[`i',1...]
		mat `b0' = `b0' , `B'
		local i = `i' + 1
	}
end

program define ChkZero
	args row col zero

	scalar `zero' = 0
	local nrow = colsof(`row')
	local i 1
	while `i' <= `nrow' {
		scalar `zero' = `zero' | (`row'[1,`i']==0)
		local i = `i' + 1
	}
	local ncol = colsof(`col')
	local i 1
	while `i' <= `ncol' {
		scalar `zero' = `zero' | (`col'[1,`i']==0)
		local i = `i' + 1
	}
end

program define AddZeros
	args cell
	macro shift
	local nrow = rowsof(`cell')
	local ncol = colsof(`cell')
	local k 1
	local i 1
	while `i' <= `nrow' {
		local j 1
		while `j' <= `ncol' {
			if `cell'[`i',`j'] == 0 {
				local m 1
				while "``m''"!="" {
					PutZero ``m'' `k'
					local m = `m' + 1
				}
			}
			local k = `k' + 1
			local j = `j' + 1
		}
		local i = `i' + 1
	}
end

program define PutZero
	args A i

	tempname B Z

	if `i' <= colsof(`A') {
		mat `B' = `A'[.,`i'...]
		local matAB "mat `A' = `A' , `B'"
	}

	local dim = rowsof(`A')
	mat `Z' = J(`dim',1,0)
	local i1 = `i' - 1

	if `i1' >= 1 {
		mat `A' = `A'[.,1..`i1']
		mat `A' = `A' , `Z'
	}
	else	mat `A' = `Z'

	`matAB'

	if `dim' == 1 { exit }

	if `i' <= `dim' {
		mat `B' = `A'[`i'...,.]
		local matAB "mat `A' = `A' \ `B'"
	}

	local dim = `dim' + 1
	mat `Z' = J(1,`dim',0)

	if `i1' >= 1 {
		mat `A' = `A'[1..`i1',.]
		mat `A' = `A' \ `Z'
	}
	else	mat `A' = `Z'

	`matAB'
end

program define IndCon
	args r c X1 X2

	tempname A X J

	local r1 = `r' - 1
	local c1 = `c' - 1

/* Build first `r'-1 columns: dummies for main effects of first variable. */

	mat `A' = I(`r1')
	mat `J' = J(1,`r1',-1)
	mat `A' = `A' \ `J'
	mat `J' = J(`c',1,1)
	mat `X1' = `A' # `J'

/* Build next `c'-1 columns: dummies for main effects of second variable. */

	mat `A' = I(`c1')
	mat `J' = J(1,`c1',-1)
	mat `A' = `A' \ `J'
	mat `J' = J(`r',1,1)
	mat `X' = `J' # `A'
	mat `X1' = `X1' , `X'

/* Build last (`r'-1)*(`c'-1) columns: interaction terms. */

	mat `X2' = I(`r1')
	mat `X2' = `X2' # `A'
	mat `J'  = J(1,`r1',-1)
	mat `A'  = `J' # `A'
	mat `X2' = `X2' \ `A'
end

program define LabelMat
	args nrow ncol
	macro shift 2
	local i 1
	while `i' <= `nrow' {
		local j 1
		while `j' <= `ncol' {
			local names "`names' p`i'`j'"
			local j = `j' + 1
		}
		local i = `i' + 1
	}
	local i 1
	while "``i''"!="" {
		mat colnames ``i'' = `names'
		if rowsof(``i'') > 1 | `i'==3 {
			mat rownames ``i'' = `names'
		}
		local i = `i' + 1
	}
end

program define ValueLab
	args var stub numb
	local dim = colsof(`stub')

	local lab : value label `var'
	if "`lab'"=="" { exit }

	local i 1
	while `i' <= `dim' {
		local x = `stub'[1,`i']
		local xlab : label `lab' `x'
		if `"`xlab'"'==`"`x'"' {
			local list `"`list' hoborxqc"'
					/* hoborxqc = flag for not labeled */
		}
		else {
			if `"`numb'"' == "1" {
				/* S_VYstw from -tabdisp, stubwidth()- */
				local xlab = trim(substr(`"`xlab'"',1,$S_VYstw))
			}
			else {
				/* S_VYclw from -tabdisp, cellwidth()- */
				local xlab = trim(substr(`"`xlab'"',1,$S_VYclw))
			}
			/* Replace periods with commas and colons with
			   semicolons so -xlab- can safely be matrix names */
			local j 1
			while `j' <= 8 {
				local xpr = index(`"`xlab'"',".")
				local xcl = index(`"`xlab'"',":")
				if `xpr'==0 & `xcl'==0 {
					local j 9  /* exit the loop */
				}
				if `xpr' ~= 0 {
					loc xlab=substr(`"`xlab'"',1,`xpr'-1)/*
					*/ + "," + substr(`"`xlab'"',`xpr'+1,.)
				}
				if `xcl' ~= 0 {
					loc xlab=substr(`"`xlab'"',1,`xcl'-1)/*
					*/ + ";" + substr(`"`xlab'"',`xcl'+1,.)
				}
				local j = `j' + 1
			}
			local list `"`list' "`xlab'""'
		}
		local i = `i' + 1
	}

	mat colnames `stub' = `list'
	global S_VYlab`numb' "label"
end

program define SetMiss
	local i 1
	while "``i''"!="" {
		scalar ``i'' = .
		local i = `i' + 1
	}
end

program define Total
	args total y doit subvar

	quietly {
		if "$S_VYwgt"!="" {
			tempvar x
			gen double `x' = ($S_VYexp)*`y'
		}
		else local x "`y'"

		if "$S_VYsub"=="" {
			summarize `x' if `doit', meanonly
		}
		else	summarize `x' if `doit' & `subvar', meanonly

		scalar `total' = _result(18)
	}
end

/*----------------------------- Parse program --------------------------------*/

program define SvyParse
	gettoken doit 0 : 0
	gettoken subvar 0 : 0

/* Parse. */

	syntax varlist(min=2 max=2 numeric) [pweight iweight/] [if] [in] /*
	*/    [, STRata(varname) PSU(varname) FPC(varname numeric) /*
	*/    SUBpop(varname numeric) SRSsubpop MISSing TAB(varname numeric) /*
	*/    PEArson NULl LR WALD LLWALD noADJust UNADJust FULLER /*
	*/    COUnt CELl ROW COLumn SE CI DEFF DEFT OBS /*
	*/    noLABel noMARGinals PERcent PROPortion /*
	*/    Level(cilevel) FORmat(string) VERTical /*
	*/    CELLWidth(integer -1)	/* -tabdisp- options
	*/    CSEPwidth(passthru)	/*
	*/    STUBWidth(integer -1)	/*
	*/    ]

	if "`null'"!="" & "`pearson'`lr'"=="" & "`wald'`llwald'"!="" {
		di in red "null option modifies pearson and lr options only"
		exit 198
	}
	if "`unadjus'"!="" { local adjust "noadjust" }
	if "`adjust'"!="" & "`wald'`llwald'"=="" {
		di in red /*
		*/ "noadjust option modifies wald and llwald options only"
		exit 198
	}
	local ncell : word count `obs' `se' `deff' `deft'
	if "`ci'"!="" & "`vertical'"!="" & `ncell' > 2 {
		di in red "only 2 of se, deff, deft, and obs can " /*
		*/ "be specified when ci and vertical" _n "specified"
		exit 198
	}
	if "`ci'"!="" { local ncell = `ncell' + 1 }
	if "`vertical'"=="" & `ncell' > 4 {
		di in red "only 4 of se, ci, deff, deft, and obs can " /*
		*/ "be specified"
		exit 198
	}
	if "`format'"!="" {
		quietly di `format' 0
		local format "format(`format')"
	}
	if "`cell'`count'`row'`column'"=="" {
		local cell cell
	}
	if "`se'`ci'`deff'`deft'"!="" {
		local nopts : word count `cell' `count' `row' `column'
		if `nopts' > 1 {
			local opt : word 1 of `se' `deff' `deft'
			di in red "only one of cell, count, row, or column " /*
			*/ "can be specified when `opt' specified"
			exit 198
		}
	}
	if "`percent'"!="" & "`proport'"!="" {
		di in red "both percent and proportion cannot be specified"
		exit 198
	}
	if "`srssubp'"!="" & "`subpop'"=="" {
		di in red "srssubpop can only be specified when subpop() " /*
		*/	"is specified"
		exit 198
	}

/* Set global macros. */

	macro drop S_VY*

	global S_VYvar1 : word 1 of `varlist'
	global S_VYvar2 : word 2 of `varlist'
	if `cellwid' < 4 {
		global S_VYclw 8
		local cellwid
	}
	else {
		global S_VYclw `cellwid'
		local cellwid cellwidth(`cellwid')
	}
	if `stubwid' < 4 {
		global S_VYstw 8
		local stubwid
	}
	else {
		global S_VYstw `stubwid'
		local stubwid stubwidth(`stubwid')
	}

	global S_VYdopt `pearson' `null' `lr' `wald' `llwald' /*
	*/ `adjust' `fuller' /*
	*/ `label' `se' `deff' `deft' `margina' `percent' /*
	*/ `proport' `cell' `count' `row' `column' level(`level') `ci' /*
	*/ `format' `vertica' `obs' `cellwid' `csepwid' `stubwid'

	if "`se'`ci'`deff'`deft'"!="" {
		global S_VYse "`count'`row'`column'"
	}
	global S_VYwald "`wald'"
	global S_VYmiss "`missing'"
	global S_VYtab  "`tab'"
	global S_VYsrss "`srssubp'"
	global S_VYopt  /* erase macro */
	global S_VYsvar "`subpop'"

/* Get weights. */

	if "`exp'"=="" {
		svy_get pweight, optional
		local exp "$S_1"
	}
	else if "`weight'"=="pweight" { /* try to varset pweight variable */
		capture confirm variable `exp'
		if _rc==0 {
			svy_get pweight `exp'
			local exp "$S_1"
		}
	}
	if "`exp'"!="" {
		global S_VYexp "`exp'"
		if "`weight'"!="" { global S_VYwgt "`weight'" }
		else		    global S_VYwgt  pweight

		capture confirm variable `exp'
		if _rc {
			tempvar `w'
			qui gen double `w' = `exp'
		}
		else	local w "`exp'"
	}

/* Get strata, psu, and fpc. */

	svy_get strata `strata', optional
	global S_VYstr "$S_1"
	if "$S_VYstr"!="" {
		global S_VYopt "$S_VYopt str($S_VYstr)"
	}

	svy_get psu `psu', optional
	global S_VYpsu "$S_1"
	if "$S_VYpsu"!="" {
		global S_VYopt "$S_VYopt psu($S_VYpsu)"
	}

	svy_get fpc `fpc', optional
	global S_VYfpc "$S_1"
	if "$S_VYfpc"!="" {
		global S_VYopt "$S_VYopt fpc($S_VYfpc)"
	}

/* Mark. */

	mark `doit' `if' `in'

/* Check for negative weights if pweights. */

	if "$S_VYwgt"=="pweight" {
		capture assert `w' >= 0 if `doit'
		if _rc { error 402 }
	}

/* Markout. */

	markout `doit' `w' $S_VYfpc `subpop' `tab'
	markout `doit' $S_VYstr $S_VYpsu, strok

	if "`missing'"=="" {
		markout `doit' $S_VYvar1 $S_VYvar2
	}

/* Compute total #obs. */

	qui count if `doit'
	if _result(1) == 0 { error 2000 }
	global S_VYnobs = _result(1)

	if "`subpop'"=="" { exit }

/* Only here if subpop() specified. */

	qui count if `subpop'!=0 & `doit'
	if _result(1) == 0 {
		di in red "no observations in subpop() " /*
		*/ "subpopulation" _n /*
		*/ "subpop() = 1 indicates observation in " /*
		*/ "subpopulation" _n /*
		*/ "subpop() = 0 indicates observation not in " /*
		*/ "subpopulation"
		exit 461
	}
	if _result(1) == $S_VYnobs {
		di in blu _n "Note: subpop() subpopulation is " /*
		*/ "same as full population" _n /*
		*/ "subpop() = 1 (or nonzero) indicates " /*
		*/ "observation in subpopulation" _n /*
		*/ "subpop() = 0 indicates observation not in " /*
		*/ "subpopulation"
		local samemsg 1
	}
	qui count if `subpop'!=1 & `subpop'!=0 & `doit'
	if _result(1) > 0 {
		if "`samemsg'"=="" {
			di in blu _n "Note: subpop() takes on " /*
			*/ "values other than 0 and 1" _n /*
			*/ "subpop() ~= 0 indicates subpopulation"
		}
		global S_VYsub "`subpop'~=0"
	}
	else    global S_VYsub "`subpop'==1"

	qui gen byte `subvar' = (`subpop'!=0) if `doit'
	global S_VYopt "$S_VYopt by(`subvar') nby(1)"
end

/*--------------------------- Save results program ---------------------------*/

program define SvySave, eclass
	est scalar N        = $S_VYnobs
	est scalar N_strata = $S_VYnstr
	est scalar N_psu    = $S_VYnpsu
	est scalar N_pop    = `1'
	if "`2'"!="" {
		est scalar N_sub    = $S_VYosub
		est scalar N_subpop = `2'
	}
	est local setype    = cond("$S_VYse"!="", "$S_VYse", "cell")
	est local wtype     `"$S_VYwgt"'
	est local wexp      `"$S_VYexp"'
	est local strata    `"$S_VYstr"'
	est local psu       `"$S_VYpsu"'
	est local fpc       `"$S_VYfpc"'
	est local subpop    `"$S_VYsub"'
	est local rowvar    `"$S_VYvar1"'
	est local colvar    `"$S_VYvar2"'
	local vlab1 : variable label $S_VYvar1
	local vlab2 : variable label $S_VYvar2
	est local rowvlab   `"`vlab1'"'
	est local colvlab   `"`vlab2'"'
	est local rowlab    `"$S_VYlab1"'
	est local collab    `"$S_VYlab2"'
	est local tab       `"$S_VYtab"'

	est scalar r        = `3' /* # of rows                             */
	est scalar c        = `4' /* # of columns                          */
	est scalar total    = `5' /* e(N_pop) or total of tab variable     */
	if `6' {
		est local zero "zero marginal"
	}
	est scalar mgdeff   = `7' /* mean deff eigenvalue                  */
	est scalar cvgdeff  = `8' /* c.v. of deff eigenvalues              */

	est matrix Obs `9'        /* cell # of observations                */
	if "$S_VYsub" != "" {
	est matrix ObsSub `18'    /* cell # of observations in Sub         */
	}
	VectoMat `10' e(r) e(c)   /* convert cell proportions to matrix    */
	est matrix Prop `10'      /* proportions                           */

	est matrix Row  `11'      /* row stub                              */
	est matrix Col  `12'      /* column stub                           */
	est matrix V_row `13'     /* variance of row margins               */
	est matrix V_col `14'     /* variance of column margins            */

	MakeDeff `15'             /* make matrices e(Deff) and e(Deft)     */
	MakeDeff `16' _row        /* matrices e(Deff_row) and e(Deft_row)  */
	MakeDeff `17' _col        /* matrices e(Deff_col) and e(Deft_col)  */

	est local cmd  "svytab"
end

program define VectoMat /* converts `A' from vector to matrix */
	args A nrow ncol

	tempname row New

	mat `New' = `A'[1,1..`ncol']
	local i = `ncol' + 1
	while `i' <= `nrow'*`ncol' {
		local end = `i' + `ncol' - 1
		mat `row' = `A'[1,`i'..`end']
		mat `New' = `New' \ `row'
		local i = `end' + 1
	}

	mat `A' = `New'
end

program define MakeDeff, eclass
	args Vdeff name

	tempname v f deff deft
	matrix `v' = vecdiag(e(V`name'))

	matrix `deff' = `v'
	matrix `deft' = `v'

	if "$S_VYfpc"!="" { /* remove fpc from `Vdeff' for deft (which is wr) */
		tempname c
		if "$S_VYsrss"=="" {
			scalar `c' = 1 - e(N)/e(N_pop)
		}
		else	scalar `c' = 1 - e(N_sub)/e(N_subpop)
	}
	else	local c 1

	local dim  = colsof(`v')
	local i 1
	while `i' <= `dim' {
		scalar `f' = `v'[1,`i']/`Vdeff'[`i',`i']
		matrix `deff'[1,`i'] = cond(`f'<., `f', 0)

		scalar `f' = sqrt(`c'*`f')
		matrix `deft'[1,`i'] = cond(`f'<., `f', 0)

		local i = `i' + 1
	}

	est matrix Deff`name' `deff'
	est matrix Deft`name' `deft'
end

/*---------------------------- Display programs ------------------------------*/

program define Display
	syntax [, PEArson NULl LR WALD LLWALD noADJust UNADJust FULLER /*
	*/        COUnt CELl ROW COLumn SE CI DEFF DEFT OBS /*
	*/        noLABel noMARGinals PERcent PROPortion /*
	*/        Level(cilevel) FORmat(string) VERTical /*
	*/        CELLWidth(passthru)			/* tabdisp opts
	*/	  CSEPwidth(passthru)			/*
	*/	  STUBWidth(passthru)			/*
	*/	  ]

/* Check for syntax errors. */

	if "`null'"!="" & "`pearson'`lr'"=="" & "`wald'`llwald'"!="" {
		di in red "null option modifies pearson and lr options only"
		exit 198
	}
	if "`unadjus'"!="" { local adjust "noadjust" }
	if "`adjust'"!="" & "`wald'`llwald'"=="" {
		di in red /*
		*/ "noadjust option modifies wald and llwald options only"
		exit 198
	}
	if "`wald'"!="" & "`e(F_Wald)'"=="" {
		di in red "wald not available on redisplay" _n /*
		*/ "it must be specified at run time"
		exit 198
	}
	if "`format'"!="" {
		quietly di `format' 0
	}
	if "`cell'`count'`row'`column'"=="" {
		local cell cell
	}
	if "`se'`ci'`deff'`deft'"!="" {
		local nopts : word count `cell' `count' `row' `column'
		if `nopts' > 1 {
			local opt : word 1 of `se' `deff' `deft'
			di in red "only one of cell, count, row, or column " /*
			*/ "can be specified when `opt' specified"
			exit 198
		}
		if "`e(setype)'"!="`cell'`count'`row'`column'" {
			if "`se'"!="" {
				di in red "standard errors are only " /*
				*/ "available for `e(setype)'s" _n /*
				*/ "to compute `cell'`count'`row'`column' " /*
				*/ "standard errors, rerun command with " /*
				*/ "`cell'`count'`row'`column' and se options"
				exit 111
			}
			if "`ci'"!="" {
				di in red "confidence intervals are only " /*
				*/ "available for `e(setype)'s" _n /*
				*/ "to compute `cell'`count'`row'`column' " /*
				*/ "confidence intervals, rerun command " /*
				*/ "with `cell'`count'`row'`column' and " /*
				*/ "ci options"
				exit 111
			}

			local deff : word 1 of `deff' `deft'

			di in red "`deff' is only available for `e(setype)'s" /*
			*/ _n "to compute `cell'`count'`row'`column' `deff'," /*
			*/ " rerun command with `cell'`count'`row'`column' " /*
			*/ "and `deff' options"
			exit 111
		}
	}
	if "`percent'"!="" & "`proport'"!="" {
		di in red "both percent and proportion cannot be specified"
		exit 198
	}

/* Display header. */

	svy_head e(N) e(N_strata) e(N_psu) e(N_pop) "`e(N_sub)'" /*
	*/ "`e(N_subpop)'" "`e(wtype)'" "`e(wexp)'" "`e(strata)'" /*
	*/ "`e(psu)'" "`e(fpc)'" "`e(subpop)'"

/* Display tabulation. */

	DispTab "`label'" "`se'" "`deff'" "`deft'" "`margina'" "`percent'" /*
	*/ "`proport'" "`cell'" "`count'" "`row'" "`column'" "`level'" "`ci'" /*
	*/ "`format'" "`vertica'" "`obs'" /*
	*/ "`cellwid'" /*
	*/ "`csepwid'" /*
	*/ "`stubwid'" /*
	*/

/* Display error and warning messages. */

	if "`e(zero)'"!="" {
		di _n in blu "  Table contains a zero in the marginals." _n /*
		*/ "  Statistics cannot be computed."
	}
	if e(r) == 1 {
		di _n in blu "  Only one row category." _n /*
		*/ "  Statistics cannot be computed."
	}
	if e(c) == 1 {
		di _n in blu "  Only one column category." _n /*
		*/ "  Statistics cannot be computed."
	}
	if e(N_psu) - e(N_strata) < (e(r) - 1)*(e(c) - 1) {
		di _n in blu "  Note:  variance estimate degrees of freedom " /*
		*/ "= " in ye e(N_psu) - e(N_strata) _n in blu /*
		*/ "         are less than" _n /*
		*/ "         nominal table degrees of freedom = " /*
		*/ in ye (e(r) - 1)*(e(c) - 1)
	}

/* Display statistics. */

	if "`pearson'`lr'`wald'`llwald'`fuller'"=="" {
		local pearson "pearson"
	}
	if "`pearson'"!="" {
		if "`null'"!="" {
			DispStat "Pearson:" Pear Penl
		}
		else	DispStat "Pearson:" Pear
	}
	if "`lr'"!="" {
		if "`null'"!="" {
			DispStat "Likelihood ratio:" LR LRnl
		}
		else	DispStat "Likelihood ratio:" LR
	}
	if "`fuller'"!="" {
		DispStat "Pearson (Fuller version):" Full
	}
	if "`wald'"!="" {
		DispWald "Wald (Pearson):" Wald `adjust'
	}
	if "`llwald'"!="" {
		DispWald "Wald (log-linear):" LLW `adjust'
	}

/* Display mean generalized deff and cv. */

	if "`deff'`deft'"!="" {
		di _n in gr "  Mean generalized deff" _col(35) "= " in ye /*
		*/ %9.4f e(mgdeff) _n in gr "  CV of generalized deffs" /*
		*/ _col(35) "= " in ye %9.4f e(cvgdeff)
	}

/* Display FPC warning. */

	if "`e(fpc)'"!="" { /* print FPC note */
		di _n in blu "Finite population correction (FPC) assumes " /*
		*/ "simple random sampling without " _n /*
		*/ "replacement of PSUs within each stratum with no " /*
		*/ "subsampling within PSUs."
	}
end

program define DispTab
	args label se deff deft margina percent proport cell count row /*
	*/ column level ci format vertica obs /*
	*/ cellwid /*
	*/ csepwid /*
	*/ stubwid /*
	*/

	if "`format'"=="" { local format "%6.0g" }

/* Preserve, then make data set for -tabdisp-. */

	preserve
	drop _all

	tempname b matr matc Row Col

	local ncat = e(r)*e(c)
	local iii "int((_n-1)/e(c))+1"  /* row position */
	local jjj "mod(_n-1,e(c))+1"    /* column position */

	mat `b' = e(Prop)
	local bij "`b'[`iii',`jjj']"

	mat `matr' = J(1,e(c),1)
	mat `matr' = `matr'*`b''  /* row marginals */
	mat `matc' = J(1,e(r),1)
	mat `matc' = `matc'*`b'   /* column marginals */

	mat `Row' = e(Row)
	mat `Col' = e(Col)

	quietly {

	/* Set obs. */

		if "`margina'"=="" {
			local Nr1 = `ncat' + 1 /* start row marginals */
			local Nr2 = `ncat'+e(r) /* end row marginals */
			local Nc1 = `Nr2' + 1     /* start column marginals */
			local Nc2 = `Nr2' + e(c) /* end column marginals */
			local N   = `Nc2' + 1     /* end */

			local total "total"
		}
		else	local N `ncat'

		set obs `N'

	/* Make stubs of table. */

		gen double `e(rowvar)' = `Row'[1,`iii'] in 1/`ncat'
		gen double `e(colvar)' = `Col'[1,`jjj'] in 1/`ncat'

		if "`margina'"=="" {
			replace `e(rowvar)' = `Row'[1,_n-`Nr1'+1] in `Nr1'/`Nr2'
			replace `e(colvar)' = `Col'[1,_n-`Nc1'+1] in `Nc1'/`Nc2'
		}

	/* Make variable labels and value labels for stub variables. */

		if "`label'"=="" {
			label variable `e(rowvar)' `"`e(rowvlab)'"'
			label variable `e(colvar)' `"`e(colvlab)'"'

			if "`e(rowlab)'"!="" { 
				tempname lblname
				MakeLab `lblname' `e(rowvar)' `Row' 
			}
			if "`e(collab)'"!="" { 
				tempname lblname
				MakeLab `lblname' `e(colvar)' `Col'
			}
		}

	/* Handle display of missing values if necessary. */

		if `Row'[1,e(r)]>=. {
			tempname lblname
			FixMiss `lblname' `e(rowvar)' `Row'[1,e(r)-1] /*
			*/ `ncat' `Nr1' `Nr2'
		}
		if `Col'[1,e(c)]>=. {
			tempname lblname
			FixMiss `lblname' `e(colvar)' `Col'[1,e(c)-1] /*
			*/ `ncat' `Nc1' `Nc2'
		}

	/* Make counts and proportions or percents. */

		local keyi 1

		if "`count'"!="" {
			tempvar xc
			gen double `xc' = e(total)*`bij' in 1/`ncat'

			if "`margina'"=="" {
				replace `xc' = e(total)*`matr'[1,_n-`Nr1'+1] /*
				*/ in `Nr1'/`Nr2'
				replace `xc' = e(total)*`matc'[1,_n-`Nc1'+1] /*
				*/ in `Nc1'/`Nc2'
				replace `xc' = e(total) in l
			}

			if "`e(wtype)'"!="" {
				local key`keyi' "weighted counts"
			}
			else	local key`keyi' "counts"
			local keyi = `keyi' + 1
		}

		if "`percent'"!="" {
			local porp 100 /* percent or proportion */
			local kporp "percentages"
		}
		else {
			local porp 1
			local kporp "proportions"
		}

		if "`cell'"!="" {
			tempvar xp
			gen double `xp' = `porp'*`bij' in 1/`ncat'

			if "`margina'"=="" {
				replace `xp' = `porp'*`matr'[1,_n-`Nr1'+1] /*
				*/ in `Nr1'/`Nr2'
				replace `xp' = `porp'*`matc'[1,_n-`Nc1'+1] /*
				*/ in `Nc1'/`Nc2'
				replace `xp' = `porp' in l
			}
			local key`keyi' "cell `kporp'"
			local keyi = `keyi' + 1
		}
		if "`row'"!="" {
			tempvar xrow
			gen double `xrow' = `porp'*`bij'/`matr'[1,`iii'] /*
			*/ in 1/`ncat'

			if "`margina'"=="" {
				replace `xrow' = `porp' in `Nr1'/`Nr2'
				replace `xrow' = `porp'*`matc'[1,_n-`Nc1'+1] /*
				*/ in `Nc1'/`Nc2'
				replace `xrow' = `porp' in l
			}
			local key`keyi' "row `kporp'"
			local keyi = `keyi' + 1
		}
		if "`column'"!="" {
			tempvar xcol
			gen double `xcol' = `porp'*`bij'/`matc'[1,`jjj'] /*
			*/ in 1/`ncat'

			if "`margina'"=="" {
				replace `xcol' = `porp'*`matr'[1,_n-`Nr1'+1] /*
				*/ in `Nr1'/`Nr2'
				replace `xcol' = `porp' in `Nc1'/`Nc2'
				replace `xcol' = `porp' in l
			}
			local key`keyi' "column `kporp'"
			local keyi = `keyi' + 1
		}

	/* From here to `obs', only one of count, cell, row, or column is
	   chosen.
	*/
		local keylast = `keyi' - 1
		local item "`key`keylast''"

		if "`count'"!="" { local porp 1 }

		if "`se'`ci'"!="" {
			tempvar xse
			tempname V
			mat `V' = e(V)
			gen double `xse' = `porp'*sqrt(`V'[_n,_n]) /*
			*/ in 1/`ncat'

			if "`margina'"=="" {
				if "`row'"=="" {
					mat `V' = e(V_row)
					replace `xse' = `porp'* /*
					*/ sqrt(`V'[_n-`Nr1'+1, /*
					*/ _n-`Nr1'+1]) in `Nr1'/`Nr2'
				}
				if "`column'"=="" {
					mat `V' = e(V_col)
					replace `xse' = `porp'* /*
					*/ sqrt(`V'[_n-`Nc1'+1, /*
				        */ _n-`Nc1'+1]) in `Nc1'/`Nc2'
				}
			}

			if "`se'"!="" {
				if "`vertica'"=="" {
					local key`keyi' /*
					*/ "(standard errors of `item')"
				}
				else {
					local key`keyi' /*
					*/ "standard errors of `item'"
				}
				local keyi = `keyi' + 1
			}
		}
		if "`ci'"!="" {
			tempname t
			tempvar lb ub
			scalar `t' = invt(e(N_psu)-e(N_strata),`level'/100)

			if "`count'"=="" {
				local x "`xp'`xrow'`xcol'"
				if `porp' == 100 {
					local x "(`x'/100)"
				}

				gen double `lb' = `porp'/(1 + /*
				*/ exp(-(log(`x'/(1-`x')) /*
				*/ - `t'*`xse'/(`porp'*`x'*(1-`x')))))

				gen double `ub' = `porp'/(1 + /*
				*/ exp(-(log(`x'/(1-`x')) /*
				*/ + `t'*`xse'/(`porp'*`x'*(1-`x')))))
			}
			else {
				gen double `lb' = `xc' - `t'*`xse'
				gen double `ub' = `xc' + `t'*`xse'
			}

			local xci "`lb' `ub'"

			if "`se'"=="" { local xse /* erase tempvar */ }

			if "`vertica'"=="" {
				local key`keyi' /*
*/ `"[`=strsubdp("`level'")'% confidence intervals for `item']"'
			}
			else {
				local key`keyi' /*
*/ `"lower `=strsubdp("`level'")'% confidence bounds for `item'"'
				local keyi = `keyi' + 1
				local key`keyi' /*
*/ `"upper `=strsubdp("`level'")'% confidence bounds for `item'"'
			}
			local keyi = `keyi' + 1
		}
		if "`vertica'"=="" & "`se'`ci'"!="" {
			if "`se'"=="" {
				local nose "*"
			}
			if "`ci'"=="" {
				local noci "*"
			}

			`nose' tempvar xxse
			`nose' gen str1 `xxse' = "" in 1
			`noci' tempvar xci
			`noci' gen str1 `xci' = "" in 1

			local i 1
			while `i' <= `N' {
				`nose' local ses : di `format' `xse'[`i']
				`nose' replace `xxse' = "("+trim("`ses'")+")" /*
				*/ in `i' if `xse'<.

				`noci' local slb : di `format' `lb'[`i']
				`noci' local sub : di `format' `ub'[`i']
				`noci' replace `xci' = "["+trim("`slb'") /*
				*/ +","+trim("`sub'")+"]" in `i' /*
				*/ if `lb'<. & `ub'<.
				local i = `i' + 1
			}

			`nose' local xse "`xxse'"
		}
		if "`deff'"!="" {
			tempvar xdeff
			DeffVar `xdeff' f `Nr1' `Nr2' `Nc1' `Nc2' /*
			*/ "`margina'" "`row'" "`column'"
			local key`keyi' "deff for variances of `item'"
			local keyi = `keyi' + 1
		}
		if "`deft'"!="" {
			tempvar xdeft
			DeffVar `xdeft' t `Nr1' `Nr2' `Nc1' `Nc2' /*
			*/ "`margina'" "`row'" "`column'"
			local key`keyi' "deft for variances of `item'"
			local keyi = `keyi' + 1
		}
		if "`obs'"!="" {
			tempname Obs
			tempvar xobs
			if "`e(ObsSub)'" ~= "" {
				mat `Obs' = e(ObsSub)
			}
			else mat `Obs' = e(Obs)
			gen long `xobs' = `Obs'[`iii',`jjj'] in 1/`ncat'
			if "`margina'"=="" {
				tempname J
				mat `J' = J(1,e(c),1)
				mat `J' = `J'*`Obs''
				replace `xobs' = `J'[1,_n-`Nr1'+1] /*
				*/ in `Nr1'/`Nr2'
				mat `J' = J(1,e(r),1)
				mat `J' = `J'*`Obs'
				replace `xobs' = `J'[1,_n-`Nc1'+1] /*
				*/ in `Nc1'/`Nc2'
				if "`e(N_sub)'" ~= "" {
					replace `xobs' = e(N_sub) in l
				}
				else replace `xobs' = e(N) in l
			}
			local key`keyi' "number of observations"
			local keyi = `keyi' + 1
		}
	}

	local vars "`xc' `xp' `xrow' `xcol' `xse' `xci' `xdeff' `xdeft' `xobs'"

	tabdisp `e(rowvar)' `e(colvar)', cell(`vars') `total' /*
	*/ format(`format') /*
	*/ `cellwid' /*
	*/ `csepwid' /*
	*/ `stubwid' /*
	*/

	if "`e(tab)'"!="" {
		di in gr "  Tabulated variable:  `e(tab)'" _n
	}

	di in gr "  Key:  " _c
	local col 1
	local i 1
	while `i' < `keyi' {
		di _col(`col') in ye "`key`i''"
		local col 9
		local i = `i' + 1
	}
end

program define DeffVar
	args var ft Nr1 Nr2 Nc1 Nc2 margina row column

	local ncat = e(r)*e(c)
	tempname def
	mat `def' = e(Def`ft')

	quietly {
		gen double `var' = cond(`def'[1,_n]!=0,`def'[1,_n],.) /*
		*/ in 1/`ncat'

		if "`margina'"=="" {
			if "`row'"=="" {
				mat `def' = e(Def`ft'_row)
				replace `var' = cond(`def'[1,_n-`Nr1'+1]!=0, /*
				*/ `def'[1,_n-`Nr1'+1],.) in `Nr1'/`Nr2'
			}
			if "`column'"=="" {
				mat `def' = e(Def`ft'_col)
				replace `var' = cond(`def'[1,_n-`Nc1'+1]!=0, /*
				*/ `def'[1,_n-`Nc1'+1],.) in `Nc1'/`Nc2'
			}
		}
	}
end

program define FixMiss
	args lblname var missval N N1 N2
	local missval = round((`missval')+1,1)

	local lab : value label `var'
	if "`lab'"=="" {
		local lab `lblname'
		label define `lab' `missval' "."
		label value `var' `lab'
	}
	else	label define `lab' `missval' "." , add

	qui replace `var' = `missval' if `var'>=.&(_n<=`N'|(`N1'<=_n&_n<=`N2'))
end

program define MakeLab
	args labname var stub

	tempname imat
	local dim = colsof(matrix(`stub'))
	local i 1
	while `i' <= `dim' {
		mat `imat' = `stub'[1,`i'..`i']
		local lab : colnames `imat'
		if "`lab'"!="hoborxqc" {
			local x = `stub'[1,`i']
			label define `labname' `x' "`lab'", `add'
			local add "add"
		}
		local i = `i' + 1
	}
	if "`add'"!="" {
		label value `var' `labname'
	}
end

program define DispStat
	args title stat null

	local col0  5 /* left margin */
	local col1 19 /* statistic   */
	local col2 35 /* equal sign  */
	local col3 51 /* p-value     */

	local dfnom = (e(r)-1)*(e(c)-1)
	local df1 "e(df1_`stat')"
	local df2 "e(df2_`stat')"

	if `df1' != int(`df1') {
		local df1 "%4.2f `df1'"
	}
	if `df2' != int(`df2') {
		local df2 "%4.2f `df2'"
	}

	di _n in gr "  `title'"

	di in gr _col(`col0') "Uncorrected" _col(`col1') "chi2(" in ye /*
	*/ `dfnom' in gr ")" _col(`col2') "= " in ye %9.4f e(cun_`stat')

	if "`null'"!="" {
		local df1n "e(df1_`null')"
		local df2n "e(df2_`null')"

		if `df1n' != int(`df1n') {
			local df1n "%4.2f `df1n'"
		}
		if `df2n' != int(`df2n') {
			local df2n "%4.2f `df2n'"
		}

		di in gr _col(`col0') "D-B (null)" _col(`col1') "F(" in ye /*
		*/ `df1n' in gr ", " in ye `df2n' in gr ")" _col(`col2') "= " /*
		*/ in ye %9.4f e(F_`null') _col(`col3') in gr "P = " in ye /*
		*/ %6.4f e(p_`null')
	}

	di in gr _col(`col0') "Design-based" _col(`col1') "F(" in ye `df1' /*
	*/ in gr ", " in ye `df2' in gr ")" _col(`col2') "= " in ye %9.4f /*
	*/ e(F_`stat') _col(`col3') in gr "P = " in ye %6.4f e(p_`stat')
end

program define DispWald
	args title stat unadj

	local col0  5 /* left margin */
	local col1 19 /* statistic   */
	local col2 35 /* equal sign  */
	local col3 51 /* p-value     */

	di _n in gr "  `title'"

	local df1 = (e(r) - 1)*(e(c) - 1)

	di in gr _col(`col0') "Unadjusted" _col(`col1') "chi2(" in ye /*
	*/ `df1' in gr ")" _col(`col2') "= " in ye %9.4f /*
	*/ e(cun_`stat')

	if "`unadj'"!="" {
		di in gr _col(`col0') "Unadjusted" _col(`col1') "F(" in ye /*
		*/ `df1' in gr ", " in ye e(df_r) /*
		*/ in gr ")" _col(`col2') "= " in ye %9.4f e(Fun_`stat') /*
		*/ _col(`col3') in gr "P = " in ye %6.4f e(pun_`stat')
	}

	di in gr _col(`col0') "Adjusted" _col(`col1') "F(" in ye /*
	*/ `df1' in gr ", " in ye e(df_r)-`df1'+1 in gr ")" /*
	*/ _col(`col2') "= " in ye %9.4f e(F_`stat') _col(`col3') /*
	*/ in gr "P = " in ye %6.4f e(p_`stat')
end

exit

/*-------------------------------- old code  --------------------------------*/

program define Check
	args tr tra b b0 V row col X1 X2 D Da

	local nrow = colsof(`row')
	local ncol = colsof(`col')

	tempname A trc
	di in gr "tr(Ho)         = " in ye %12.8f `tr'
	di in gr "tr(Ha)         = " in ye %12.8f `tra'

	TraceD $S_VYnobs `nrow' `ncol' `b' `b0' `V' `trc'
	di in gr "tr(comparison) = " in ye %12.8f `trc' /*
	*/ %12.1e abs((`trc'-`tr')/`tr')

	Fuller `b0' `V' `row' `col' `A'
	scalar `trc' = trace(`A')
	di in gr "tr(Fuller)     = " in ye %12.8f `trc' /*
	*/ %12.1e abs((`trc'-`tr')/`tr')

	Nested `b0' `V' `X1' `X2' `A'
	scalar `trc' = trace(`A')
	di in gr "tr(Nested b0)  = " in ye %12.8f `trc' /*
	*/ %12.1e abs((`trc'-`tr')/`tr') %12.1e mreldif(`A',`D')

	Nested `b' `V' `X1' `X2' `A'
	scalar `trc' = trace(`A')
	di in gr "tr(Nested b)   = " in ye %12.8f `trc' /*
	*/ %12.1e abs((`trc'-`tra')/`tra') %12.1e mreldif(`A',`Da')
end

program define Nested /* With b0 as input, this program yields D with the same
                         trace(D) and trace(D^2) as DeffMat with b0, but D's are
                         different.  With b as input, gives same traces as
                         DeffMat with b (except when there are zeros in table).
		      */
	args b0 V X1 X2 D

	tempname A P Xt2

/* Construct misspecified variance estimate `P' under Ho. */

	mat `P' = `b0''*`b0'
	mat `A' = diag(`b0')
	mat `P' = `A' - `P'

/* Project `X2' onto the orthogonal complement of `X1' space w.r.t. `P' norm. */

	ProjOper `X1' `P' `A'

	mat `Xt2' = `A'*`X2'

/* Compute generalized design effects matrix. */

	mat `A' = `P'*`Xt2'
	mat `A' = `Xt2''*`A'
	SymInv `A'
	mat `D' = `V'*`Xt2'
	mat `D' = `Xt2''*`D'
	mat `D' = `A'*`D'
	mat `D' = $S_VYnobs*`D'
end

program define Fuller /* This program yields D with the same trace(D) and
                         trace(D^2) as DeffMat with b0, but D's are different;
                         they are not even the same dimension.  When called
			 with b, gives something not related to other methods.
		      */
	args b0 V row col D

	tempname A B X

	local nrow = colsof(`row')
	local ncol = colsof(`col')

/* Compute `X' matrix. */

	mat `A' = I(`nrow')
	mat `B' = `col''
	mat `X' = `A' # `B'
	mat `A' = I(`ncol')
	mat `B' = `row''
	mat `A' = `B' # `A'
	mat `X' = `X' , `A'
	local dim = `nrow' + `ncol' - 1
	mat `X' = `X'[1...,1..`dim']

/* Compute projection matrix. */

	mat `A' = diag(`b0')
	mat `A' = syminv(`A')

	ProjOper `X' `A' `D'

	mat `D' = `A'*`D'
	mat `D' = `D'*`V'
	mat `D' = $S_VYnobs*`D'
end

program define ProjOper /* returns P = I - X (X'WX)^-1 X'W */
	args X W P
	tempname A
	mat `A' = `W'*`X'
	mat `A' = `X''*`A'
	SymInv `A'
	mat `A' = `A'*`X''
	mat `A' = `X'*`A'
	Sym `A'
	mat `A' = `A'*`W'
	local dim = colsof(`A')
	mat `P' = I(`dim')
	mat `P' = `P' - `A'
end

program define TraceD
	args n nrow ncol b b0 V tr

	tempname A B row col Vrow Vcol

/* Get marginal row and column sums. */

	mat `A' = I(`nrow')
	mat `B' = J(1,`ncol',1)
	mat `A' = `A' # `B'
	mat `row' = `b'*`A''
	mat `Vrow' = `V'*`A''
	mat `Vrow' = `A'*`Vrow'

	mat `A' = J(1,`nrow',1)
	mat `B' = I(`ncol')
	mat `A' = `A' # `B'
	mat `col' = `b'*`A''
	mat `Vcol' = `V'*`A''
	mat `Vcol' = `A'*`Vcol'

	scalar `tr' = 0
	local i 1
	while `i' <= `nrow'*`ncol' {
		scalar `tr' = `tr' + `V'[`i',`i']/`b0'[1,`i']
		local i = `i' + 1
	}
	local i 1
	while `i' <= `nrow' {
		scalar `tr' = `tr' - `Vrow'[`i',`i']/`row'[1,`i']
		local i = `i' + 1
	}
	local i 1
	while `i' <= `ncol' {
		scalar `tr' = `tr' - `Vcol'[`i',`i']/`col'[1,`i']
		local i = `i' + 1
	}

	scalar `tr' = `n'*`tr'
end

/*---------------------------- end of old code ------------------------------*/

(1) Non-Wald statistics:

    Pear = Pearson with observed misspecified variance
    Penl = Pearson with null misspecified variance
    LR   = LR      with observed
    LRnl = LR      with null

    all these yield

	cun_Pear   uncorrected (i.e., misspecified) chi2
	F_Pear     F-statistic: F = chi2/df1
	df1_Pear   df1 = tr^2/tr2
	df2_Pear   df2 = df1*(#psu - #strata)
	p_Pear     p-value for above F-statistic ~ F(df1,df2)

(2) Fuller variant:

    Full = Pearson with null misspecified variance using Fuller et al.'s
    formula.

	F_Full     F = chi2/df1 ~ F(df1,df2)
	df1_Full   df1 = <complex formula>
	df2_Full   df2 = #psu - #strata
	p_Full     p-value for above F-statistic ~ F(df1,df2)

(3) Wald statistics:

    Wald = "Pearson" Wald
    LLW  = log-linear Wald

    both of these produce (with W or T in place of W below):

	F_Wald     adjusted F = (dfv-df1+1)*chi2/(df1*dfv)
	df1_Wald   (# rows - 1)*(# columns - 1)
	df2_Wald   df2 = dfv - df1 + 1, where dfv = #psu - #strata
	p_Wald     p-value for adjusted F-statistic ~ F(df1,df2)

	cun_Wald   unadjusted chi2
	Fun_Wald   unadjusted F = chi2/df1
	pun_Wald   p-value for unadjusted F-statistic ~ F(df1,dfv)

-------------------------------------------------------------------------------
<end of file>
