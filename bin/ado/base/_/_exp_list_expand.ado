*! version 1.0.4  12feb2015
program _exp_list_expand, sclass
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

	if "`eqstub'" == "" {
		local eqstub _eq
	}

	// NOTE: do not call any -sclass- commands from here on
	sreturn clear

	gettoken evalues explist : explist
	gettoken values explist : explist
	capture {
		confirm name `evalues'
		confirm name `values'
	}
	if c(rc) {
		di as err "matnames required"
		exit 100
	}
	capture matrix drop `evalues'
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
				if bsubstr("`na'",1,1) != "_" {
					local na _`na'
				}
				if "`tok'" == "_se" {
					local foundse 1
					if "`eq'" == "" {
						local senames `senames' se
					}
					else	local senames `senames' `eq'_se
					matrix `mat'[1,`j'] = `exp'
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
				local id `eq'`tok'`na'
				if `:ustrlen local id' > `c(namelenchar)' {
					local abeq = usubstr("`eq'",1,12)
					local abna = usubstr("`na'",1,12)
					local id `abeq'`tok'`abna'				
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
				matrix cole `mat' = `senames'
			}
			matrix `evalues' = nullmat(`evalues'), `mat'
		}
		if `foundse' {
			local ecoleq : coleq `evalues', quote
			local under _
			if `:list under in ecoleq' {
				foreach eq of local ecoleq {
					if "`eq'" == "_" {
						local eq b
					}
					local neweqs `neweqs' `eq'
				}
				matrix coleq `evalues' = `neweqs'
			}
		}
		if "`explist'" != "" {
			local ecoleq : coleq `evalues'
			if "`:list uniq ecoleq'" == "_" {
				// make sure there is at least one equation
				// name in `evalues' generated from `eexp'
				matrix coleq `evalues' = `eqstub'1
				local ieq 1
			}
		}
	}

	// Add expressions:
	// NOTE: no need to worry about equations with spaces in them,
	// -_exp_list_parse- didn't allow them.
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
			scalar `val' = `exp'
			matrix `v_explist' = nullmat(`v_explist'), `val'
			sreturn local exp`i' `"`exp'"'
			local list `list' (`exp')
		}
		matrix colnames	`v_explist' = `colnames'
		matrix coleq	`v_explist' = `coleq2'
		matrix `values' = nullmat(`values'), `v_explist'
	}
	local both 0
	capture confirm matrix `evalues'
	if !c(rc) {
		matrix rowname `evalues' = y1
		local ++both
	}
	capture confirm matrix `values'
	if !c(rc) {
		matrix rowname `values' = y1
		local ++both
	}
	sreturn local n_exp `i'
	sreturn local enames `enames'
	sreturn local names `names'
	sreturn local explist `"`list'"'
	sreturn local eexp `"`ueexp'"'
end
exit
