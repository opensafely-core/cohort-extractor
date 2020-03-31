*! version 1.3.0  28oct2016
// syntax: _prefix_expand <matname> <explist>, stub(<stub>) ...
program _prefix_expand, sclass
	version 9
	syntax anything(id="matnames" name=explist equalok),	///
		stub(name)					///
		[						///
			eqstub(name)				///
			EEXP(string)				///
			COLNames(string)			///
			COLEq(string)				///
			NORUN					///
		]
	
	local vv "version 11: "
	local k_extra : word count `: list uniq coleq'
	local maxstublen = c(namelenchar) - 3
	if `:length local stub' > `maxstublen' {
		di as err "stub length may not be larger than `maxstublen'"
		exit 198
	}
	if "`eqstub'" == "" {
		local eqstub _eq
	}

	// NOTE: do not call any -sclass- commands from here on
	sreturn clear

	tempname v1 v2
	gettoken values explist : explist
	capture confirm name `values'
	if c(rc) {
		di as err "matname required"
		exit 100
	}
	capture matrix drop `values'
	// Expand <eexp> elements:
	local i 0
	local ieq 0
	local foundse 0
	if `"`eexp'"' != "" {
		if "`norun'" != "" | `"`e(b)'"' != "matrix" {
			gettoken invalid : eexp, parse(" ()") bind match(par)
			di as err "invalid expression: `invalid'"
			exit 198
		}
		tempname b mat
		matrix `b' = e(b)
		if colsof(`b') == 0 {
			di as err "e(b) has zero columns"
			exit 322
		}
		local b_coleq : coleq `b', quote
		local b_coleq : list clean b_coleq
		local b_coleq : list uniq b_coleq
		while `"`eexp'"' != "" {
			gettoken tok rest : eexp, parse("()") bind match(par)
			gettoken tok eq : tok
			local eq : list retok eq
			if `"`eq'"' != "" {
				// get eqname from "#eqno" specification
				if bsubstr(`"`eq'"',1,1) == "#" {
					local eqn = bsubstr(`"`eq'"',2,.)
					capture confirm integer number `eqn'
					if c(rc) {
						di as err	///
						`"equation `eq' not found"'
						exit 111
					}
					// check that `eq' is valid
					if `eqn' > `:word count `b_coleq'' {
						di as err	///
						`"equation `eq' not found"'
						exit 111
					}
					local eq : word `eqn' of `b_coleq'
				}
				else if !`:list eq in b_coleq' {
					di as err	///
					`"equation `eq' not found"'
					exit 111
				}
				if `"`eq'"' == `"`b_coleq'"' {
					local eq
				}
			}
			if inlist(`"`tok'"',"_b","_se") {
				gettoken tok2 rest2 : rest, parse("[]") bind
				if `"`tok2'"' == "[]" {
					local eexp `"`rest2'"'
				}
				else	local eexp `"`rest'"'
			}
			else {
				di as err `"invalid eexp: `tok'"'
				exit 198
			}
			if "`eq'" != "" {
				matrix `mat' = `b'[1,"`eq':"]
			}
			else	matrix `mat' = `b'
			local mcoleq : cole `mat', quote
			local mcoleq : list clean mcoleq
			local mcolna : coln `mat'
			local senames

			if "`eq'" != "" {
				local eq " `eq'"
			}
			local ueexp `ueexp' (`tok'`eq')

			forval j = 1/`=colsof(`mat')' {
				local ++i	// index for all expressions
				// it's now ok to replace `eq'
				gettoken eq mcoleq : mcoleq, qed(qed)
				gettoken na mcolna : mcolna
				if "`eq'" != "`oldeq'" {
					local ++ieq
					local oldeq `eq'
				}
				if "`eq'" == "_" {
					local exp `tok'[`na']
					local eq
				}
				else if strpos("`eq'", "[") {
					if `qed' {
						local exp `tok'[`""`eq'":`na'"']
					}
					else {
						local exp `tok'[`eq':`na']
					}
				}
				else {
					if `qed' {
						local exp ["`eq'"]`tok'[`na']
					}
					else {
						local exp [`eq']`tok'[`na']
					}
				}
				sreturn local exp`i' `"`exp'"'
				local list `list' (`exp')
				local ona `"`na'"'
				if bsubstr("`na'",1,1) != "_" {
					local na _`na'
				}
				// generate a varname for current expression
				if "`eq'" != "" {
					capture {
						confirm name `eq'
						assert 1 == `:word count `eq''
					}
					if c(rc) {
						local eq `eqstub'`ieq'
					}
				}
				if "`tok'" == "_se" {
					local foundse 1
					if "`eq'" == "" {
						local senames `senames' se
					}
					else	local senames `senames' `eq'_se
					matrix `mat'[1,`j'] = `exp'
				}
				local id `eq'`tok'`na'
				if `: list id in enames' {
					if "`eq'" != "" {
						local exp "`eq':`ona'"
					}
					else {
						local exp "`ona'"
					}
					di as err ///
			"`exp' present in model more than once"
					exit 322
				}
				if `: list id in names' {
					local id `id'`i'
				}
				capture confirm name `id'
				if c(rc) {
					local id `stub'`i'
				}
				local enames `enames' `id'
			}
			if "`tok'" == "_se" {
				`vv' matrix cole `mat' = `senames'
			}
			matrix `v1' = nullmat(`v1'), `mat'
		}
		if `foundse' {
			local ecoleq : coleq `v1', quote
			local under _
			if `:list under in ecoleq' {
				foreach eq of local ecoleq {
					if "`eq'" == "_" {
						local eq b
					}
					local neweqs `neweqs' `eq'
				}
				`vv' matrix coleq `v1' = `neweqs'
			}
		}
		if "`explist'" != "" {
			local ecoleq : coleq `v1'
			if "`:list uniq ecoleq'" == "_" {
				// make sure there is at least one equation
				// name in `v1' generated from `eexp'
				`vv' matrix coleq `v1' = `eqstub'1
				local ieq 1
			}
		}
	}

	// Add expressions:
	// NOTE: no need to worry about equations with spaces in them,
	// -_prefix_explist- didn't allow them.
	if `"`explist'"' != "" {
		local j 0
		tempname val v_explist
		local oldeq
		while `"`explist'"' != "" {
			local ++j	// index for <elist> expression
			local ++i	// index for all expressions

			// generate a varname for current expression
			local eq : word `j' of `coleq'
			local na : word `j' of `colnames'
			if "`eq'" != "`oldeq'" {
				local ++ieq
				local oldeq `eq'
			}
			if "`eq'" == "`eqstub'" {
				local eq `eqstub'`ieq'
			}
			local coleq2 `coleq2' `eq'
			if "`eq'" != "" & bsubstr("`na'",1,1) != "_" {
				local na _`na'
			}
			local id `eq'`na'
			if `:ustrlen local id' > `c(namelenchar)' {
				local abeq = usubstr("`eq'",1,12)
				local abna = usubstr("`na'",1,12)
				local id `abeq'`abna'
			}
			if `: list id in names' {
				local id `id'`i'
			}
			capture confirm name `id'
			if c(rc) {
				local id `stub'`i'
			}

			local names `names' `id'
			gettoken exp explist : explist,	///
				parse(" ()") bind match(par)
			capture noisily scalar `val' = `exp'
			if c(rc) {
				di as err `"error in expression: `exp'"'
				exit c(rc)
			}
			matrix `v_explist' = nullmat(`v_explist'), `val'
			sreturn local exp`i' `"`exp'"'
			local list `list' (`exp')
		}
		`vv' matrix colnames	`v_explist' = `colnames'
		`vv' matrix coleq	`v_explist' = `coleq2'
		matrix `v2' = nullmat(`v2'), `v_explist'
	}
	local k_eexp	0
	local k_exp	0
	local both	0	// indicates both matrices were generated
	local ecoleq
	local ecolna
	capture confirm matrix `v1'
	if !c(rc) {
		matrix rowname `v1' = y1
		local k_eexp = colsof(`v1')
		local ecoleq : coleq `v1', quote
		local ecoleq : list clean ecoleq
		local ecolna : colna `v1'
		local ++both
		matrix rename `v1' `values'
	}
	local coleq
	local colna
	capture confirm matrix `v2'
	if !c(rc) {
		matrix rowname `v2' = y1
		local k_exp = colsof(`v2')
		local coleq : coleq `v2', quote
		local colna : colna `v2'
		if `both' {
			matrix `values' = `values', `v2'
		}
		else {
			matrix rename `v2' `values'
		}
	}

	// number of expressions expanded from <eexp>
	sreturn local k_eexp	`k_eexp'
	sreturn local ecoleq	`"`ecoleq'"'
	sreturn local ecolna	`"`ecolna'"'
	// total number of expression
	sreturn local k_exp	`k_exp'
	sreturn local coleq	`"`coleq'"'
	sreturn local colna	`"`colna'"'
	// total number of equations
	capture confirm matrix `values'
	if !c(rc) {
		sreturn local k_eq `"`:colnlfs `values''"'
	}
	else	sreturn local k_eq 0

	// number of equations containing <exp>'s
	sreturn local k_extra	`k_extra'

	// expressions from eexp()
	sreturn local enames	`enames'
	sreturn local eexplist	`"`ueexp'"'

	// all expressions, expanded out
	sreturn local names	`names'
	sreturn local explist	`"`list'"'
end
exit
