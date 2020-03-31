*! version 1.7.0  01oct2018
program misstable, rclass
	version 11

	gettoken cmd 0 : 0, parse(" ,")
	local l = strlen("`cmd'")

	if ("`cmd'"==bsubstr("nested", 1, max(4,`l'))) {
		misstable_nested `0'
		return add
	}
	else if ("`cmd'"==bsubstr("patterns", 1, max(3,`l'))) {
		misstable_patterns `0'
		return add
	}
	else if ("`cmd'"==bsubstr("summarize", 1, max(3,`l'))) {
		misstable_summarize `0'
		return add
	}
	else if ("`cmd'"=="tree") {
		misstable_tree `0'
		return add
	}
	else {
		badsubcmd "`cmd'"
		/*NOTREACHED*/
	}
end

program badsubcmd 
	args subcmd

	di as smcl as err "{p 0 4 2}"
	if ("`subcmd'"=="") {
		di as smcl as err ///
			"{bf:misstable} subcommand not specified{break}"
	}
	else {
		di as smcl as err "{bf:misstable `subcmd'} unrecognized{break}"
	}
	di as smcl as err "valid {bf:misstable} subcommands are"
	di as smcl as err "{bf:summarize}, 
	di as smcl as err "{bf:patterns},"
	di as smcl as err "{bf:tree}, and"
	di as smcl as err "{bf:nested}"
	di as smcl as err "{p_end}"
	exit 198
end

						/* setup for Mata	*/
local RS	real scalar
local SS	string scalar
local SR	string rowvector
local SC	string colvector
local RM	real matrix
local RR	real rowvector
local RC	real colvector
local RV	real vector
local PC	pointer colvector
local PR	pointer rowvector
local PS	pointer scalar
local boolean	`RS'
local		True	1
local		False	0

						/* top level		*/
/* -------------------------------------------------------------------- */
						/* subcommand summarize	*/
/*
	misstable summarize [varlist] [if] [in] [, ALL SHOWzeros 
						   GENerate(<stub>[, exok]) ]

	saves in r():
	    macros:
		vartype		"numeric" | "string" | "none"
	    scalars:
		N_eq_dot	
		N_gt_dot
		N_lt_dot
		K_uniq
		min
		max
*/

program misstable_summarize, rclass
	syntax [varlist] [if] [in] [, ALL SHOWzeros GENerate(string) noPRESERVE]

	_chk_generate genstub exok : `"`generate'"'
	if ("`exok'"=="") {
		local geneq ">=."
	}
	else {
		local geneq"==."
	}

	return local  vartype "none"
	return scalar N_eq_dot = .
	return scalar N_gt_dot = .
	return scalar N_lt_dot = .
	return scalar K_uniq   = .
	return scalar min      = .
	return scalar max      = .

	if ("`varlist'"=="") {
		exit
	}
	
	tempvar touse 
	mark `touse' `if' `in'
	if ("`all'"=="") {
		local newlist
		foreach v of local varlist {
			local ty : type `v'
			if (bsubstr("`ty'",1,3)!="str") { 
				qui count if `v'>=. & `touse'
				if (r(N)) { 
					local newlist `newlist' `v'
				}
			}
		}
		if ("`newlist'"=="") {
			di as txt "(variables nonmissing or string)"
			exit
		}
		local varlist `newlist'
		local newlist
	}

	di as smcl as txt _col(64) "Obs<."
	di as smcl as txt _col(49) "{c TLC}{hline 30}"

	di as smcl as txt 			///
		_col(16) "{c |}"		///
		_col(49) "{c |} Unique"

	di as smcl as txt			///
		_col( 7) "Variable {c |}"	///
		_col(22) "Obs=."		///
		_col(32) "Obs>."		///
		_col(42) "Obs<."		///
		_col(49) "{c |} values"		///
		_col(65) "Min"			///
		_col(77) "Max"

	di as smcl as txt "  {hline 13}{c +}{hline 32}{c +}{hline 30}"

	local showzeros = cond("`showzeros'"!="", 1, 0)
	foreach v of local varlist {
		local vname = abbrev("`v'", 12)
		if "`c(hasicu)'" == "1" {
			local indent = 2 + 12 - udstrlen("`vname'")
		}
		else {
			local indent = 2 + 12 - strlen("`vname'")
		}
		local ty : type `v'
		if (bsubstr("`ty'",1,3)!="str") { 
			return local vartype "numeric"
			quietly {
				summarize `v' if `touse', meanonly
				return scalar N_lt_dot = r(N)
				return scalar min      = r(min)
				return scalar max      = r(max)

				if ("`genstub'"!="") {
if (ustrlen("`genstub'`v'")>`c(namelenchar)') {
	local genvname = abbrev("`v'", `c(namelenchar)'- ustrlen("`genstub'"))
	local genvname = ustrtoname("`genvname'")
	local genvname `genstub'`genvname'
}
else {
	local genvname `genstub'`v'
}

qui gen byte `genvname' = (`v'`geneq') if `touse'
label variable `genvname' "(`v'`geneq')" 
				}

				count if `v'==. & `touse'
				return scalar N_eq_dot = r(N)
				count if `v'>.  & `touse'
				return scalar N_gt_dot = r(N)

				capture tabulate `v' if `touse'
				if (_rc) { 
					if (_rc==1) { 
						exit 1
					}
					return scalar K_uniq = .
				}
				else {
					return scalar K_uniq = ///
							cond(r(r)>500, ., r(r))
				}
			}

			di as smcl as txt _skip(`indent') "`vname' {c |}" _c
			if (return(N_eq_dot) | `showzeros') {
				di as smcl as res %10.0gc return(N_eq_dot) _c
			}
			else {
				di as smcl as txt "{space 10}" _c
			}
			if (return(N_gt_dot) | `showzeros') {
				di as smcl as res %10.0gc return(N_gt_dot) _c
			}
			else {
				di as smcl as txt "{space 10}" _c
			}
			di as smcl as res %10.0gc return(N_lt_dot) _c


			if (return(K_uniq)>=.) { 
					 	/*1234567890*/
				di as smcl as txt "  {c |}   >500" _c
			}
			else {
				di as smcl as txt "  {c |}" %7.0gc return(K_uniq) _c
			}

			di as smcl as txt "  "  %9.0g return(min)	///
				  	  "   " %9.0g return(max)
		}
		else {
			return local vartype "string"
			return scalar N_eq_dot = .
			return scalar N_gt_dot = .
			return scalar N_lt_dot = .
			return scalar K_uniq   = .
			return scalar min      = .
			return scalar max      = .
			di as smcl as txt _skip(`indent') "`vname' {c |}" ///
			" (string variable)" _col(49) "{c |}"
		}
	}
	di as smcl as txt "  {hline 13}{c BT}{hline 32}{c BT}{hline 30}"
end

program _chk_generate
	args stub opt colon generate

	if (`"`generate'"'=="") exit

	local 0 `generate'
	cap syntax name(id="stub") [, exok ]
	if _rc {
		di as err "{bf:generate()}: " _c
		syntax name(id="stub") [, exok ]
	}
	if (strlen("`namelist'")>16) {
		di as err "{bf:generate()}: stub cannot exceed 16 characters"
		exit 198
	}
	c_local `stub' `namelist'
	c_local `opt' `exok'
end

						/* subcommand summarize	*/
/* -------------------------------------------------------------------- */
						/* subcommand patterns  */

/*
	misstable patterns [varlist] [if] [in]
		       [, 
			    ASIS
			    BYPATterns
			    EXOK
			    FREQuency
			    REPLACE [CLEAR]
			  noPRESERVE
		       ]

	saves in r():
	    macros:
		r(vars)			variables used in order used

	    scalars:
		r(N_complete)		# of complete obs.
		r(N_incomplete)		# of incomplete obs.
		r(K)			# of distinct mv patterns

*/


program misstable_patterns, rclass
	tempvar touse

	mt_std_parse done vlist options exok N : `touse' `"`0'"' 1 1

	local 0 `", `options'"'

	syntax [, BYPATterns FREQuency REPLACE CLEAR noPRESERVE]

	return scalar N_complete = `N'
	return scalar N_incomplete = 0
	return scalar K            = 0 
	return local vars `vlist'

	if ("`replace'"!="" & c(changed) & "`clear'"=="") {
		error 4
	}

	if ("`replace'"=="" & "`clear'"!="") {
		di as err "option {bf:clear} requires option {bf:replace}"
		exit 198
	}

	if (`done') {
		if ("`replace'"!="") {
			drop _all
		}
		exit
	}


	if ("`preserve'"=="") {
		preserve
	}

	tempvar freq
	mt_make_01_data `freq' `exok' "`vlist'" `touse'
	if ("`bypatterns'"!="") {
		tempvar totalmiss reorder
		quietly {
			gen long `totalmiss' = 0
			foreach v of local vlist {
				replace `totalmiss' = `totalmiss' + `v'
			}
			sort `totalmiss' `vlist'
			gen `c(obs_t)' `reorder' = -_n
			sort `reorder'
			drop `reorder'
		}
	}

	return scalar K          = _N

	quietly { 
		summ `freq', meanonly
		return scalar N_incomplete = r(sum)
		return scalar N_complete = `N' - r(sum)
		local TMV = r(sum)
		local PMV = round((`TMV'/`N')*100)
		if (`PMV'<1) { 
			local PMV "<1"
		}
	}


	local trun : word count `vlist'
	local n = cond(`trun'>16, 16, `trun')
	local indent = 2
	if (`n'>=4) {
		local fullblocks = floor(`n'/4)
		if (`fullblocks'*4 != `n') { 
			local extra = 2 + 3*(`n'-`fullblocks'*4)
		}
		else {
			local extra 0
		}
		local tabwid = 14*`fullblocks' - 1 + `extra' 
		local width = 12 + `tabwid' 
	}
	else {
		local tabwid = 13 
		local width = 12 + `tabwid'
	}
	local width = `width' 

	local ttl "Missing-value patterns"
	local ttlwid = strlen("`ttl'")
	local ttlpad = `indent' + max(0, floor((`width'-`ttlwid')/2))

	di as txt
	di as txt _skip(`ttlpad') "`ttl'"
	di as txt _skip(`ttlpad') "  (1 means complete)"
	di as txt

	mata: mt_patterns_print(`indent', `tabwid', "vlist", "`freq'", ///
			`return(N_complete)', `return(N_incomplete)',  ///
				"`frequency'", "`totalmiss'")
	di
	if (`trun'<=16) {
		local sub = `indent' + 14
		di as smcl as txt "{p `indent' `sub' 2}
		di as smcl as txt "Variables are"
		local i 0
		foreach v of local vlist {
			di as smcl as txt "{bind: (`++i') {res:`v'}}"
		}
		di as smcl as txt "{p_end}"
	}
	else {
		di as smcl as txt "{space `indent'}Variables are"
		local i0  = `indent' + 4
		local sub = `indent' + 12
		local i 0
		local j 0
		local row 0
		foreach v of local vlist {
			if (mod(`i',16)==0) {
				if (`row') {
					di as smcl as txt "{p_end}"
				}
				di as smcl as txt "{p `i0' `sub' 2}"
				di as smcl as txt "Row `++row':"
				local j 0
			}
			local ++i
			di as smcl as txt "{bind: (`++j') {res:`v'}}"
		}
		di as smcl as txt "{p_end}"
	}
	if ("`replace'"=="") {
		exit
	}
	rename `freq' _freq
	quietly compress 
	order _freq `vlist'
	quietly {			// reset sorted by
		gen `freq' = _n
		sort `freq'
		drop `freq'
	}
	mata: mt_patterns_fix("vlist")
	qui replace _freq = return(N_complete) in l
	global S_FN
	di as txt "(summary data now in memory)"
	if ("`preserve'"=="") {
		restore, not
	}
end

version 11
mata:
	

void mt_patterns_print(`RS' indent, `RS' tabwid, `SS' vlist, `SS' freqvar, 
	        `RS' Ncomplete, `RS' Nincomplete,
		`SS' freqopstr, `SS' totalmissvar)
{
	`RS'		i, j, freqop, n, N
	`RM'		V, tm
	`RC'		freq
	`SR'		vars
	`SS'		indentstr, tmstr
	`boolean' 	hastm

	if ((hastm = (totalmissvar!=""))) {
		tm = st_data(., totalmissvar) \ .
	}

	freqop = (freqopstr!="")

	indentstr = sprintf("{space %g}", indent)

	vars = tokens(st_local(vlist))

	pragma unset V
	pragma unset freq
	
	st_view(V, ., vars) 
	st_view(freq, ., freqvar)

	printf("{txt}")
	printf(indentstr) ; printf("            {c |}   Pattern\n")
	printf(indentstr) 
	printf(freqop ? "  Frequency {c |}" : "  Percent   {c |}")
	n = min((cols(V), 16))
	for (j=1; j<=n; j++) { 
		if (j>1 & mod(j-1,4)==0) printf("  ") 
		printf("%3.0f", j)
	}
	printf("\n") 
	printf(indentstr) ; printf("{hline 12}{c +}{hline %g}\n", tabwid) 

	/* ------------------------------------------------------------ */
	N = Ncomplete + Nincomplete

	print_one_line(1, indentstr, Ncomplete, N, J(1, cols(V), 0), freqop)
	printf(indentstr) ; printf("{space 12}{c |}\n")
	/* ------------------------------------------------------------ */


	for (i=rows(V); i>=1; --i) { 
		if (hastm) {
			if (tm[i] != tm[i+1]) {
/*
				if (i!=rows(V)) {
					printf(indentstr) 
					printf("{space 12}{c |}\n")
				}
*/
				tmstr = sprintf(" %g:", tm[i])
				printf(" %s{space %g}{c |}\n", 
					tmstr, 13-strlen(tmstr))
			}
		}
		print_one_line(0, indentstr, freq[i], N, V[i,], freqop)
	}

	printf(indentstr) ; printf("{hline 12}{c +}{hline %g}\n", tabwid) 
	printf(indentstr) 
	if (freqop) {
		printf("{res:%11.0gc} {c |}\n", N) 
	}
	else 	printf("    {res:100}%%    {c |}\n")
}

void print_one_line(`RS' firstline, `SR' indentstr, 
		    `RS' n, `RS' N, 
		    `RR' v, `RS' freqop)
{
	`RS'	j
	`RS'	f

	printf(indentstr) 
	if (freqop) {
		printf("{res:%11.0gc} {c |}", n)
	}
	else {
		if ((f = 100*n/N)<1) printf("     <1")
		else                 printf(" {res:%6.0f}", f) 
		printf(firstline ? "%%" : " ")
		printf("    {c |}")
	}
	for (j=1; j<=cols(v); j++) { 
		if (mod(j-1,16)==0 & j!=1) {
			printf("\n")
			printf(indentstr) 
			printf("{space 12}{c |}")
		}
		else {
			if (j>1 & mod(j-1,4)==0) printf("  ") 
		}
		printf("%3.0f", !v[j])
	}
	printf("\n")
	if (cols(v)>16 & !firstline) {
		printf(indentstr) 
		printf("{space 12}{c |}\n")
	}
}

void mt_patterns_fix(`SS' vlist)
{
	`RS'	i, N
	`SR'	vars
	`RM'	V

	pragma unset V
	st_view(V, ., vars=tokens(st_local(vlist)))
	N = rows(V)
	for (i=1; i<=N; i++) V[i,] = !V[i,]

	st_addobs(1, 1)
	st_view(V, ++N, vars)
	V[.] = J(1, cols(vars), 1)
	_st_store(N, st_varindex("_freq"), .)
}

end


						/* subcommand patterns  */
/* -------------------------------------------------------------------- */
						/* subcommand nested	*/

/*
	misstable nested [varlist] [if] [in] [, EXOK noPRESERVE]

	saves in r():
	    scalars:
		r(K)		# of statements
	    macros:
		r(vars)		variables considered
		r(stmt1)	first statement
		r(stmt2)	second statement
		.
		.
		r(stmt1wc)	r(stmt1) with mv counts
*/

program misstable_nested, rclass
	tempvar touse

	mt_std_parse done vlist options exok N : `touse' `"`0'"' 0 -1
	local 0 `", `options'"'
	syntax [, noPRESERVE]
	return local vars `vlist'
	if (`done') {
		return scalar K = 0
		exit
	}

	if ("`preserve'"=="") {
		preserve
	}
	tempvar freq
	mt_make_01_data `freq' `exok' "`vlist'" `touse'

	mata: mt_nested("vlist", "`freq'", "stmt")
	return scalar K = `stmtN'
	forvalues i=1(1)`stmtN' {
		return local stmt`i' "`stmt`i''"
	}
	return local stmt1wc "`stmt'"
end

version 11

local Rule	`RR'
local Ruleptr	pointer(`RR') scalar
local Rules	pointer(`Rule') colvector

local Infoname	mt_nested_Infodf
local Info 	struct `Infoname' scalar

local ALCSIZE	100

mata:
struct `Infoname' {
	`SR'	vars
	`RM'	X

	`RS'	n
	`Rules'	pv			/*[n]*/

	`RC'	vep			/*[cols(vars)]*/
	`RC'	vn			/*[cols(vars)]*/
	`PC'	used			/*[cols(vars)]*/
}


void mt_nested(`SS' vlistname, `SS' freqvar, `SS' macnamestub)
{
	`Info'	I
	`RM'	X
	`RC'	w
	`RS'	i, j
	`SS'	mynum

	mt_nested_initinfo(I, tokens(st_local(vlistname)))

	pragma unset X
	pragma unset w
	st_view(X, ., I.vars)
	st_view(w, ., freqvar)
	I.X = cross(X, w, X)
	X = w = .
	mt_order_matrix(I.X, I.vars)

	mt_nested_buildrules(I)
	mt_nested_editrules(I)

	j = 0 
	for (i=length(I.pv); i>=1; --i) {
		if (I.pv[i]) {
			if ((++j)==1) printf("\n") 
			mynum = sprintf("%g", j)
			printf("{p %g 10 2}\n", max((0,6-strlen(mynum))))
			printf("{txt}%s.  ", mynum)
			mt_nested_statement_print(*(I.pv[i]), I.X, I.vars)
			printf("{p_end}\n")

			st_local(sprintf("%s%g", macnamestub, j), 
				mt_nested_statement_get(*(I.pv[i]), I.X, I.vars, 0))
			if (j==1) {
				st_local(macnamestub, 
				mt_nested_statement_get(*(I.pv[i]), I.X, I.vars, 1))
			}
		}
	}
	for (i=1; i<=length(I.vars); i++) {
		if (mt_var_not_in_vs(i, I.pv)) { 
			if ((++j)==1) printf("\n") 
			mynum = sprintf("%g", j)
			printf("{p %g 10 2}\n", max((0,6-strlen(mynum))))
			printf("{txt}%s.  ", mynum)
			printf("{res:%s}(%g)\n", I.vars[i], I.X[i,i])
			printf("{p_end}\n")

			st_local(sprintf("%s%g", macnamestub, j), I.vars[i])
		}
	}
	st_local(macnamestub+"N", sprintf("%g", j))
}


void mt_nested_initinfo(`Info' I, `SR' names)
{
	`RS'	i


	I.vars = names 

	I.n  = 0
	I.pv   = J(`ALCSIZE', 1, NULL)

	I.vep  = I.vn = J(length(names), 1, 0)
	I.used =        J(length(names), 1, NULL)
	for (i=1; i<=length(names); i++) I.used[i] = &(J(1, 0, .))
}



void mt_order_matrix(`RM' X, `SR' vars)
{
	`RS'	i

	for (i=1; i<=rows(X)-1; i++) { 
		mt_order_matrix_order(i, X, vars)
	}
}

void mt_order_matrix_order(`RS' i, `RM' X, `SR' vars)
{
	`RS'	target
	`RS'	ip1, ic
	`SS'	hold

	if (i==rows(X)) return 

	ip1    = i+1
	target = X[i,i]
	if (X[ip1, ip1]  < target) return 
	if (X[ip1, i  ] == target) return 

	for (ic=i+2; ic<=rows(X); ic++) {
		if (X[ic, ic]!=target) 	return 
		if (X[ i, ic]==target) {
			mt_nested_swap(ip1, ic) 
			hold      = vars[ip1]
			vars[ip1] = vars[ic]
			vars[ic]  = hold 
			return
		}
	}
}
	

void mt_nested_swap(`RM' X, `RS' i, `RS' j)
{
	`RV'	hold

	if (i!=j) {
		hold  = X[,i]
		X[,i] = X[,j]
		X[,j] = hold

		hold = X[i,]
		X[i,] = X[j,]
		X[j,] = hold
	}
}

void mt_nested_editrules(`Info' I)
{
	`RS'	i, j
	`RS'	jidx0, jidx1

	`RR'	used

	used = J(1, 0, .)
	for (i=length(I.vars); i>=1; --i) {
		jidx0 = I.vep[i]
		jidx1 = jidx0 + I.vn[i] - 1

		if (mt_nested_inuse(i, used)) { 
			for (j=jidx0; j<=jidx1; j++) I.pv[j] = NULL
		}
		else {
			mt_nested_combineused(used, *(I.used[i]))
		}
	}
}

void mt_nested_buildrules(`Info' I)
{
	`RS'	i

	I.vep[1] = 1
	mt_nested_add_to_rules(I, 1, &(1))

	for (i=2; i<=cols(I.vars); i++) {
		I.vep[i] = I.n + 1
		mt_nested_buildrules_forvar(I, i)
	}
}
	

void mt_nested_buildrules_forvar(`Info' I, `RS' i)
{
	`RS'	j
	`RS' 	target
	`RR'	myused, newused

	myused = J(1, 0, .)
	target = I.X[i,i]
	for (j=i-1; j>=1; --j) {
		if (I.X[i,j] == target) { 
			if (!mt_nested_inuse(j, myused)) {
				if (I.X[j,j]==target) {
					newused = addrules(I, i, j)
					mt_nested_combineused(myused, newused)
				}
				else {
					newused = addrules(I, i, j)
					mt_nested_combineused(myused, newused)
				}
			}
		}
	}
	if (myused == J(1, 0, .)) {
		mt_nested_add_to_rules(I, i, &(mt_nested_cp(i)))
	}
	else {
		I.used[i] = &myused
	}
}

transmorphic mt_nested_cp(transmorphic x)
{
	transmorphic	cp

	cp = x 
	return(cp)
}


`boolean' mt_nested_inuse(`RS' val, `RR' list)
{
	return(sum(val :== list) ? `True' : `False')
}

void mt_nested_combineused(`RR' uplist, `RR' toadd)
{
	uplist = uplist, toadd
	_transpose(uplist)
	uplist = uniqrows(uplist)
	_transpose(uplist)
}


void mt_nested_add_to_rules(`Info' I, `RS' i, `Ruleptr' r)
{
	if ((++I.n) > length(I.pv)) {
		I.pv = I.pv \ J(`ALCSIZE', 1, NULL)
	}
	I.pv[I.n] = r 
	I.vn[i]   = I.vn[i] + 1
}
	

`RR' addrules(`Info' I, `RS' i, `RS' j)
{
	`RS'	jidx0, jidx1, jidx

	jidx0 = I.vep[j]
	jidx1 = jidx0 + I.vn[j] - 1

	for (jidx = jidx0; jidx<=jidx1; jidx++) {
		mt_nested_add_to_rules(I, i, &(i, *(I.pv[jidx])))
	}
	return((j, *(I.used[j])))
}
		
			

`boolean' mt_var_not_in_vs(`RS' var, `PV' pv)
{
	`RS'	i

	for (i=1; i<=length(pv); i++) {
		if (pv[i]) { 
			if (v1_in_v2(var, *(pv[i]))) return(0)
		}
	}
	return(1)
}
	

void mt_nested_statement_print(`RR' v, `RM' X, `SR' vars)
{
	`RS'	ci, i, i1

	i = v[1]
	printf("{res:%s}(%g)", vars[i], X[i,i])
	for (ci=2; ci<=length(v); ci++) { 
		i1 = i
		i  = v[ci]
		printf(X[i,i] == X[i1,i1] ? " <-> " : " -> ")
		printf("{res:%s}(%g)", vars[i], X[i,i])
	}
	printf("\n")
}

string scalar mt_nested_statement_get(`RR' v, `RM' X, `SR' vars, `RS' inclcnt)
{
	`RS'	ci, i, i1
	`SS'	res 

	i   = v[1]
	res = (inclcnt ? sprintf("%s(%g)", vars[i], X[i,i]) : vars[i])
	for (ci=2; ci<=length(v); ci++) {
		i1 = i 
		i  = v[ci]
		res = res + (X[i,i]==X[i1,i1] ? " <-> " : " -> ") + 
		      (inclcnt ? sprintf("%s(%g)", vars[i], X[i,i]): vars[i])
	}
	return(res)
}



`boolean' v1_in_v2(`RR' v1, `RR' v2)
{
	`RS'	i1, i2 

	if ( (i1=length(v1)) > (i2=length(v2)) ) return(0)
	if (  i1            ==  i2             ) return(v1==v2)

	for (; i1>0; --i1) {
		while (1) {
			if (i2==0) return(0)
			if (v2[i2]==v1[i1]) break
			if (v2[i2]> v1[i1]) return(0)
			--i2
		}
	}
	return(1)
}

/*
void mt_nested_dumpinfo(`Info' I)
{
	`RS'	i, j, k
	`RC'	v

	printf("\n") 
	printf("dumpinfo:\n") 
	"vars are"
	I.vars
	printf("\n") 
	printf("No. of rules n=%g\n", I.n)
	"vep and vn are:"
	I.vep' \ I.vn'
	printf("\n") 

	for (i=1; i<=length(I.vars); i++) {
		printf("rules for %g(%s) contain", i, I.vars[i])
		v = *(I.used[i])
		if (length(v)==0) printf(" nothing\n") 
		else {
			for (j=1; j<=length(v); j++) {
				printf(" %g(%s)", v[j], I.vars[v[j]])
			}
			printf("\n") 
		}

		for (j=I.vep[i]; j<I.vep[i]+I.vn[i]; j++) {
			printf("%g.  ", j) 
			if (I.pv[j]!=NULL) {
				v = *(I.pv[j])
				for (k=1; k<=length(v); k++) { 
					printf(" %g(%s)", v[k], I.vars[v[k]])
				}
				printf("\n") 
			}
			else {
				printf("NULLED\n")
			}
		}
	}
}
*/



end
		

						/* subcommand nested	*/
/* -------------------------------------------------------------------- */
						/* subcommand tree	*/
/*
	misstable tree [varlist] [if] [in]
		       [, 
			    ASIS
			    EXOK
			    FREQuency
			  noPRESERVE
		       ]

	saves in r():
	    macros:
		r(vars)		variables used in order used

	    scalars:
*/

program misstable_tree, rclass
	tempvar touse
	mt_std_parse done vlist options exok N : `touse' `"`0'"' 1 -1
	local 0 `", `options'"'
	syntax [, FREQuency noPRESERVE]

	return local vars `vlist'

	if (`done') {
		exit
	}

	if ("`preserve'"=="") {
		preserve
	}
	tempvar freq
	mt_make_01_data `freq' `exok' "`vlist'" `touse'

	mata: mt_tree("`freq'", "vlist", "`frequency'", `N')
end

version 11

mata:
void mt_tree(`SS' freqvar, `SS' vlistname, `SS' freqop, `RS' N)
{
	`RS'	i, sumfreqs, Ncomplete
	`RS'	indent, dofreq
	`SR'	vlist
	`SS'	indentstr
	`RC'	freqs

	indent = 2

	dofreq = (freqop!="")

	vlist = tokens(st_local(vlistname))
	if (length(vlist)>7) { 
		vlist = vlist[|1\7|]
		printf("{txt}(only 7 variables shown)\n")
	}
	printf("{txt}\n") 

	indentstr = sprintf("{space %g}", indent)

	printf(indentstr) ; printf("Nested pattern of missing values\n")

	printf("{space %g}", indent-1)
	for (i=1; i<=length(vlist); i++) { 
		printf("%11uds", abbrev(vlist[i], 10))
	}
	printf("\n") ; 

	printf(indentstr) ; 
	printf("{hline %g}\n", 11*length(vlist)-1)

	pragma unset freqs
	st_view(freqs, ., freqvar)
	printf(indentstr)
	sumfreqs = colsum(freqs)
	Ncomplete = N - sumfreqs
	mt_tree_line(indent, J(rows(freqs),1,1), freqs, colsum(freqs)+Ncomplete,
		    vlist, 1, 
		    dofreq, 1, colsum(freqs)+Ncomplete)
	printf(indentstr) ; printf("{hline %g}\n", 11*length(vlist)-1)
	printf("{p %g %g 2}\n", indent-1, indent)
	printf(dofreq ? "(number" : "(percent")
	printf(" missing listed first)\n") 
	printf("{p_end}\n")
}

void mt_tree_line(`RS' indent, `RC' touse, `RC' freqs, `RS' overalldenom,
		 `SR' vlist, `RS' j0, 
		 `RS' dofreq, `RS' firstline, `RS' denom)

{
	`RC'	v, subtouse
	`RS'	thiscount, restcount


	if (j0>length(vlist)) {
		printf("\n") 
		firstline = 0
		return
	}

	pragma unset v
	st_view(v, ., vlist[j0])

	/* line 1 is missings */
	/* no indentation necessary */
	subtouse = touse :& v
	thiscount = subtouse'freqs
	restcount = denom - thiscount
	print_a_number(thiscount, overalldenom, dofreq, firstline)
	mt_tree_line(indent+11, subtouse, freqs, overalldenom, 
		    vlist, j0+1, 
		    dofreq, firstline, thiscount)

	/* line 2 is nonmissings */
	printf("{space %g}", indent)
	subtouse = touse :& (!v)
	print_a_number(restcount, overalldenom, dofreq, firstline)
	mt_tree_line(indent+11, subtouse, freqs, overalldenom, 
		    vlist, j0+1, 
		    dofreq, firstline, restcount)
}
	
void print_a_number(`RS' count, `RS' sum, `RS' dofreq, `RS' firstline)
{
	`RS'	per

	if (dofreq) {
		printf("{res:%10.0fc} ", count)
	}
	else {
		per = (count/sum)*100
		if ((per<1) & per) printf("{res:%10s}", "<1")
		else               printf("{res:%10.0f}", per)

		printf("%s", firstline ? "%" : " ")
	}
}

		
end

/* -------------------------------------------------------------------- */
					/* utilities for subcommands	*/
/*
	mt_make_01_data <freqvar> <exok> <vlist> <tousevar>

	Inputs:
		<freqvar>	new (undefined) tempvar to contain frequencies
		<exok>	        0|1 -- whether .a, ..., .z not missing
		<vlist>         existing variables
		<tousevar>	filled in touse variable
	Outputs:
		<freqvar>	filled in.

		<dataset>	!<tousevar> obs dropped.
				vars other than <vlist> and <freqvar> dropped.
				dup obs <vlist> removed; <freqvar> defined.
				dataset sorted by <freqvar> <vlist>

	Example:
		tempvar freq
		mt_make_01_data `freq' `exok' "`vlist'" `touse'
*/
				
program mt_make_01_data
	args freq exok vlist touse 

	local op = cond(`exok', "==", ">=")

	quietly {
		keep `vlist' `touse'
		keep if `touse' 
		drop `touse'

		foreach v of local vlist {
			replace `v' = (`v'`op'.)
		}
		sort `vlist'
		by `vlist': gen `c(obs_t)' `freq' = _N
		by `vlist': keep if _n==_N
		sort `freq' `vlist'
	}
end
			

					/* utilities for subcommands	*/
/* -------------------------------------------------------------------- */
						/* parsing		*/

program mt_std_parse
	args r_done r_varlist r_options r_exok r_N  ///
	     colon  					  ///
	     touse 0 allowasis desire

	c_local `r_done' 1
	c_local `r_varlist'
	c_local `r_options' 
	c_local `r_exok'
	c_local `r_N' .

	local asisopt = cond(`allowasis', "ASIS", "")

	syntax [varlist(default=none)] [if] [in] [, `asisopt' EXOK *]
	qui count `if' `in'
	c_local `r_N' `r(N)'
	c_local `r_options' `"`options'"'

	if (c(k)==0) {
		exit
	}

	if ("`varlist'"=="") {
		unab varlist : _all
		if ("`varlist'"=="") {
			exit
		}
	}
	local varlist : list uniq varlist

	mt_getstrvars strvars
	local varlist : list varlist - strvars
	local strvars
	if ("`varlist'"=="") {
		di as txt "(no numeric variables)"
		exit
	}
						/* parse		*/
	/* ------------------------------------------------------------ */
						/* id sample		*/

	mark `touse' `if' `in'
	qui count if `touse'
	local N = r(N)
	if (r(N)==0) {
		di as txt "(no observations)"
		exit
	}

	tempvar complete
	quietly {
		gen byte `complete' = 1 if `touse'
		local op = cond("`exok'"=="", ">=", "==")
		foreach v of local varlist {
			replace `complete'=0 if `v'`op'. & `touse'
		}
		replace `touse' = 0 if `touse' & `complete'
		drop `complete'
	}
	quietly count if `touse'
	if (r(N)==0) { 
		di as txt "(no missing values)"
		exit
	}
						/* id sample		*/
	/* ------------------------------------------------------------ */
						/* order varlist	*/
			
	mata: reduce_and_sort("varlist", "`touse'", ///
			"`exok'", "`asis'", `desire')
						/* order varlist	*/
	/* ------------------------------------------------------------ */
						/* return results	*/
	c_local `r_done' 0
	c_local `r_varlist' `varlist'
	c_local `r_options' `"`options'"'
	c_local `r_exok' = ("`exok'"!="")
	c_local `r_N' `N'
end

program mt_getstrvars
	args macname

	unab all : _all
	local strvars
	foreach v of local all {
		local typ : type `v'
		if (bsubstr("`typ'",1,3)=="str") {
			local strvars `strvars' `v'
		}
	}
	c_local `macname' `strvars'
end


version 11
mata:

void reduce_and_sort(`SS' varlistname, `SS' tousename, `SS' exok, 
			`SS' nosort, `RS' desire)
{
	`RS'	i, n, N
	`SR'	varlist
	`SC'	vlist
	`RM'	D
	`RR'	nmiss 
	`RC'	count, o

	varlist = tokens(st_local(varlistname))
	pragma unset D
	st_view(D, ., varlist, tousename)
	nmiss = colsum(exok=="" ? (D :>= .) : (D :== .))
	D = .

	/* ------------------------------------------------------------ */
							/* reduce	*/
	N = length(varlist)
	n = 0 
	vlist = J(N, 1, "")
	count = J(N, 1, .)
	for (i=1; i<=N; i++) {
		if (nmiss[i]) {
			vlist[++n] = varlist[i]
			count[n]   = nmiss[i]
		}
	}
	if (n==0) {
		st_local(varlistname, "")
		return
	}
	count = count[|1\n|]
	vlist = vlist[|1\n|]

	/* ------------------------------------------------------------ */
							/* sort		*/
	if (nosort=="") {
		o = order(count, desire)
		_collate(count, o)
		_collate(vlist, o)

		fixruns(count, vlist, tousename, exok)
	}
	/* ------------------------------------------------------------ */
	st_local(varlistname, invtokens(vlist'))
}

void fixruns(`RC' count, `SC' vlist, `SS' tousename, `SS' exok)
{
	`RS'	i

	for (i=1; i<rows(count); i++) { 
		if (count[i] == count[i+1]) {
			i = fixruns_u(i, count, vlist, tousename, exok)
		}
	}
}

`RS' fixruns_u(`RS' i0, `RC' count, `SC' vlist, `SS' tousename, `SS' exok)
{
	`RS'	i1
	`RS'	c

	c = count[i0]
	for(i1=i0+1; i1<=rows(count); i1++) { 
		if (count[i1]!=c) break 
	}
	fixruns_u2(i0, i1-1, vlist, tousename, exok)
	return(i1-1)
}

void fixruns_u2(`RS' i0, `RS' i1, `SC' vlist, `SS' tousename, `SS' exok)
{
	`RS'	i, imax, j
	`RS'	runs, runsi, runsij
	`RM'	Dmid
	`RC'	D0, D1


	
	if (i0==i1) return 

	if (i0 > 1) {
		Dmid = getD(i0, i1, vlist, tousename, exok)
		D0 = getD(i0-1, i0-1, vlist, tousename, exok)
		imax = maxruns(runsof(Dmid, D0), vlist[|i0\i1|]) + i0 - 1
		Dmid = D0 = .
		swapvlist(vlist, i0, imax)
		fixruns_u2(i0+1, i1, vlist, tousename, exok)
	}
	else {
		runs = -1
		for (i=i0; i<=i1; i++) { 
			D0 = getD(i, i, vlist, tousename, exok)
			runsi = -1
			for (j=i0; j<=i1; j++) { 
				if (i!=j) {
					D1 = getD(j, j, vlist, tousename, 
						exok)
					runsij = runsof(D1, D0)
					if (runsij>runsi) runsi = runsij
				}
			}
			if (runsi > runs) {
				imax = i
				runs = runsi
			}
			else if (runsi == runs) { 
				if (vlist[imax]>vlist[i]) imax = i 
			}
		}
		swapvlist(vlist, 1, imax)
		fixruns_u2(i0+1, i1, vlist, tousename, exok)
	}
}

void swapvlist(`SC' vlist, `RS' i0, `RS' i1)
{
	`SS'	hold 

	hold = vlist[i0]
	vlist[i0] = vlist[i1]
	vlist[i1] = hold
}
	

`RR' runsof(`RM' D, `RM' D0)
{
	`RS'	j
	`RR'	runs

	runs = J(1, cols(D), .)
	for (j=1; j<=cols(D); j++) runs[j] = colsum(D0 :& D[,j])
	return(runs)
}

`RS' maxruns(`RR' runs, `SC' names)
{
	`RS'	j, jmax, rmax
	`SS'	minname

	rmax = -1 
	for (j=1; j<=cols(runs); j++) {
		if (runs[j]>rmax) rmax = runs[j]
	}

	minname = ""
	jmax = -1 
	for (j=1; j<=cols(runs); j++) { 
		if (runs[j]==rmax) { 
			if (names[j]<minname | minname=="") {
				minname = names[jmax=j]
			}
		}
	}
	return(jmax)
}
	

`RM' getD(`RS' i0, `RS' i1, `SC' vlist, `SS' tousename, `SS' exok)
{
	`RM'	V

	pragma unset V
	st_view(V, ., vlist[|i0\i1|]', tousename)
	return(exok=="" ? (V :>= .) : (V :== .))
}
end
