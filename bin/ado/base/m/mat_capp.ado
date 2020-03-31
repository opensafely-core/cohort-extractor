*! version 1.2.3  22feb2019
program mat_capp
	version 8

	syntax anything [, miss(str) cons ts]

	local b12   : word 1 of `anything'
	local colon : word 2 of `anything'
	local b1    : word 3 of `anything'
	local b2    : word 4 of `anything'

	if `"`colon'"' != ":" {
		di as err `"colon expected, `colon' found"'
		exit 198
	}
	confirm matrix `b1'
	confirm matrix `b2'

	local Qmatch = ("`miss'" == "")
	if `Qmatch' {
		local miss .
	}
	if `Qmatch' & rowsof(`b1') != rowsof(`b2') {
		error 503
	}

// if same names and same ordering, then do it fast !

	mata: st_local("rnameseq", strofreal(	///
		st_matrixrowstripe("`b1'") == st_matrixrowstripe("`b2'") ))
	if `rnameseq' {
		mat `b12' = `b1', `b2'
		exit
	}

// check whether time-series insertion is requested and needed

	if "`ts'" != "" {
		local rfullb1 : rowfullnames `b1'
		local rfullb2 : rowfullnames `b2'
		local tmp : subinstr local rfullb1 "." "", count(local n1)
		local tmp : subinstr local rfullb2 "." "", count(local n2)
		if `n1'==0 & `n2'==0 {
			local ts
		}
	}

// match

	tempname bb12 bb bb2 bbtemp newrow

	_ms_eq_info, matrix(`b1') row
	forval i = 1/`r(k_eq)' {
		local eq1 `"`eq1' "`r(eq`i')'""'
	}
	_ms_eq_info, matrix(`b2') row
	forval i = 1/`r(k_eq)' {
		local eq2 `"`eq2' "`r(eq`i')'""'
	}

	foreach eq of local eq1 {
		local EQ `"`eq':"'
		mat `bb' = `b1'["`EQ'",1...]
		mat `bb' = `bb' , J(rowsof(`bb'), colsof(`b2'), `miss')

		// eq is removed from eq2 if it exists
		local eq2 : subinstr local eq2 `""`eq'""' "", ///
						word count(local eqinb2)

		if `eqinb2' == 1 {

			// eq occurs also in b2
			mat `bb2' = `b2'["`EQ'", 1...]
			local nbb2 = rowsof(`bb2')
			local namesbb2 : rownames `bb2'
			local namesbb2 : subinstr local namesbb2 "," "*", all
			tokenize `namesbb2'

			forvalues j = 1 / `nbb2' {
				_ms_parse_parts `"``j''"'
				local isvar = r(type) == "variable"
				local ii = rownumb(`bb',"``j''")
				forval col = 1/`=colsof(`bb2')' {
					if `bb'[`ii',colsof(`b1')+`col'] != `miss' {
						local ii = .
						continue, break
					}
				}
				if `ii' != . {
					// found
					mat subst `bb'[`ii',colsof(`b1')+1] ///
							= `bb2'[`j',1...]
				}
				else {
					// append a row to bb
					if `Qmatch' {
						di as err "rowname mismatch"
						exit 503
					}
					mat `newrow' = ///
						J(1,colsof(`b1'),`miss') , ///
						`bb2'[`j',1...]
					version 11: ///
					mat rownames `newrow' = `"`eq':``j''"'
					if "`ts'" != "" & `isvar' {
						TS_Insert `bb' `newrow'
					}
					else {
						mat `bb' = `bb' \ `newrow'
					}
				}
			}

			if "`cons'" != "" {
				ConsLast `bb'
			}
		}

		mat `bb12' = nullmat(`bb12') \ `bb'
	}

	// all equations now left in eq2 cannot exist in eq1/b1

	if `Qmatch' & `"`eq2'"' != "" {
		di as err "rowname mismatch"
		exit 503
	}

	// append remaining equations in eq2

	foreach eq of local eq2 {
		local freeparm = bsubstr("`eq'",1,1) == "/"
		local EQ `"`eq':"'
		mat `bbtemp' = `b2'["`EQ'",1...]
		mat `bb' = J(rowsof(`bbtemp'),colsof(`b1'),`miss') , `bbtemp'
		if !`freeparm' {
			matrix rowna `bb' = `:rowfull `bbtemp', quote'
		}
		else {
			matrix rowna `bb' = `:rowfull `bbtemp''
		}
		mat `bb12' = `bb12' \ `bb'
	}

	mata : st_matrixcolstripe("`bb12'", ///
		st_matrixcolstripe("`b1'") \ st_matrixcolstripe("`b2'"))

	mat `b12' = `bb12'
end


/* ConsLast b

   Moves the row with name _cons to the bottom
*/
program ConsLast
	args b

	local i = rownumb(`b',"_cons")
	local n = rowsof(`b')
	if inlist(`i',.,`n') {
		exit
	}

	if `i' == 1 {
		mat `b' = `b'[2...,1...] \ `b'[1,1...]
		exit
	}

	local im1 = `i'-1
	local ip1 = `i'+1
	mat `b' = `b'[1..`im1',1...] \ (`b'[`ip1'..`n',1...] \ `b'[`i',1...])
end


/* TS_Insert b newrow

   Inserts newrow in b directly after all rows of b with matching varname
   (i.e., with different ts operators), or at the bottom of b if no such
   row is found.
*/
program TS_Insert
	args b newrow

	local vname : rownames `newrow'
	local ip = index("`vname'", ".")
	if `ip' > 0 {
		local vname = bsubstr("`vname'", `ip'+1, .)
	}

	local bnames : rownames `b'
	local nb = rowsof(`b')
	tokenize `"`bnames'"'
	forvalues i = `nb'(-1)1 {
		if index("``i'' ",".`vname' ") > 0 {
			// row should be inserted directly after i
			local ii = `i'
			continue, break
		}
	}

	if "`ii'" == "" | "`ii'" == "`nb'" {
		matrix `b' = `b' \ `newrow'
	}
	else {
		local ip1 = `ii'+1
		matrix `b' = `b'[1..`ii',1...] \ (`newrow' \ `b'[`ip1'...,1...])
	}
end
exit
