*! version 1.3.0  13mar2016
program _score_spec, sclass
	version 9
	syntax [anything(name=vlist)] [if] [in]	///
	[,					///
		b(name)				///
		SCores				/// ignored
		EQuation(string)		///
		SCore(string)			///
		OLDOLOGit			/// do not document
		ignoreeq			/// NOT documented
		strict				/// NOT documented
		pr				/// NOT documented
	]

	if `"`equation'"' != "" & `"`score'"' != "" {
		di as err "options equation() and score() cannot be combined"
		exit 198
	}
	local equation `equation' `score'
	if `:length local ignoreeq' & `:length local equation' {
		di as err "option equation() not allowed"
		exit 198
	}
	if "`b'" == "" {
		local bopt e(b)
	}
	else {
		confirm matrix `b'
		local bopt `b'
	}
	tempname b
	matrix `b' = `bopt'

	// equations in `b' matrix
	if "`oldologit'" != "" {
		local neq = e(k_cat)
		local j 0
		local coleq `e(depvar)'
		local eq`++j' `e(depvar)'
		forval i = 1/`=`neq'-1' {
			local coleq `coleq' _cut`i'
			local eq`++j' _cut`i'
		}
		local zero zero
	}
	else {
		_ms_lf_info, matrix(`b')
		local neq = r(k_lf)
		forval i = 1/`neq' {
			local eq`i' "`r(lf`i')'"
			local coleq `"`coleq' "`r(lf`i')'""'
		}
		
		local coleq : list clean coleq
		if `:length local ignoreeq' {
			local neq = colsof(`b')
		}
		if inlist("`e(cmd)'", "ologit", "oprobit") {
			if "`pr'" == "pr" {
				if `"`equation'"' != "" {
					di as err ///
"option {bf:equation()} is not allowed with option {bf:pr}"
					exit 198
				}
				local neq = e(k_cat)
			}
			else { // scores
				local neq = e(k_eq)
				if e(k_eq) == e(k_cat) {
					local zero zero
				}
			}
		}
	}

	// parse the vlist, allow <newvarlist> and <stub>*
	_stubstar2names `vlist', nvars(`neq') single `zero'
	local varlist	`s(varlist)'
	local typlist	`s(typlist)'
	local stub	`s(stub)'
	confirm new var `varlist'
	local nvars : word count `varlist'

	if `stub' | `nvars' > 1 {
		if `"`equation'"' != "" {
			di as err ///
"option equation() is not allowed when generating multiple scores"
			exit 198
		}
		ChkCount `nvars' `neq' `ignoreeq'
	}
	else {
		if "`strict'" != "" {
			ChkCount `nvars' `neq' `ignoreeq'
		}
		if `"`equation'"' == "" {
			if (`nvars' == 1) local eqspec #1
		}
		else	local eqspec `equation'
	
		// verify -score()- option
		gettoken POUND eqnum : eqspec, parse("#")
		if "`POUND'" != "#" {
			local eqnum = coleqnumb(`b', "`eqspec'")
		}
		if "`eqnum'" != "." {
			capture {
				confirm integer number `eqnum'
				assert 0 < `eqnum' & `eqnum' <= `neq'
			}
			if c(rc) == 0 {
				local eqspec `"#`eqnum'"'
				local eqname `"`eq`eqnum''"'
			}
		}
		if "`eqname'" == "" {
			InvalidEq `eqspec'
		}
	}

	// save results
	sreturn clear
	sreturn local eqspec	`eqspec'
	if `"`eqname'"' != "_" {
		sreturn local eqname	`eqname'
	}
	if `"`coleq'"' != "_" {
		sreturn local coleq	`"`coleq'"'
	}
	sreturn local varlist	`varlist'
	sreturn local typlist	`typlist'
	sreturn local if `"`if'"'
	sreturn local in `"`in'"'
end

program InvalidEq
	di as err "equation [`0'] not found"
	exit 303
end

program ChkCount
	args nvars neq ignoreeq

	if `nvars' != `neq' {
		local cmd2 = "`e(mecmd)'"=="1" | "`e(xtcmd)'"=="1" | ///
			"`e(irtcmd)'"=="1"
		if `cmd2' & !missing("`e(cmd2)'") {
			local for "for `e(cmd2)' "
		}
		else if "`e(cmd)'" != "" {
			local for "for `e(cmd)' "
		}
		if "`ignoreeq'" != "" {
			di as err ///
"{p}the current estimation results `for'have `neq' elements in e(b) so you " ///
"must specify `neq' new variables{p_end}"
		}
		else {
			di as err ///
"{p}the current estimation results `for'have `neq' equations so you " ///
"must specify `neq' new variables, or you can use the equation() " ///
"option and specify one variable at a time{p_end}"
		}
		if `nvars' < `neq' {
			exit 102
		}
		else	exit 103
	}
end

exit
