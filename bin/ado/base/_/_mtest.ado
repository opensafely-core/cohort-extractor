*! version 1.4.3  13feb2015 
program define _mtest
	version 8

	gettoken key 0 : 0, parse(" ,")
	local nkey = length(`"`key'"')
	if `"`key'"' == bsubstr("query", 1, `nkey') {
		Query `0'
	}
	else if `"`key'"' == bsubstr("footer", 1, `nkey') {
		Footer `0'
	}
	else if `"`key'"' == bsubstr("syntax", 1, `nkey') {
		Syntax `0'
	}
	else if `"`key'"' == bsubstr("adjust", 1, `nkey') {
		Adjust `0'
	}
	else {
		di as err `"_mtest: unknown subcommand `key'"'
		exit 198
	}
end


/*
	Query
*/
program define Query, rclass
	/* XX ADD DESCRIPTIVE NAME OF METHOD (I suggest alphabetic order)
	   Capitalization indicates minimal abbreviation
	*/
	return local methods  "Bonferroni Holm Sidak"
end


/*
	Footer col method symbol

*/
program define Footer
	args col method symbol

	if "`method'" == "noadjust" {
		local txt "unadjusted"
	}
	else if "`method'" != "" {
		local txt = upper(bsubstr("`method'",1,1)) + ///
		            bsubstr("`method'",2,.) + "-adjusted"
	}

	if "`symbol'" != "" {
		local s "`symbol' "
	}
	di as txt "{ralign `col':{it:`s'`txt' p-values}}"
end


/*
	Syntax [, Mtest[(str)] ]
*/
program define Syntax, rclass
	syntax [, Mtest Mtest2(str) ]

	if `"`mtest2'"' != "" & "`mtest'" != "" {
		di as err "mtest() and mtest may not be specified together"
		exit 198
	}

	if "`mtest'" != "" {
		return local method noadjust
	}
	else if `"`mtest2'"' != "" {
		local 0 , `mtest2'

		/* XX ADD OPTION NAME HERE WITH APPROPRIATE ABBREVIATION */
		capture syntax , [ Bonferroni Holm Sidak NOADJust ]
		if _rc {
			di as err "invalid mtest(): `mtest2'"
			exit 198
		}

		/* XX ADD NAME OF OPTION HERE */
		local opt `bonferroni' `holm' `sidak' `noadjust'

		local nopt : word count `opt'
		if `nopt' != 1 {
			di as err `"invalid option mtest: `mtest2'"'
			exit 198
		}
		return local method `opt'
	}
	else {
		return local method
	}
end


/*
	Adjust matname , mtest[(str)] [ Pindex(#) if(#) replace append ]
*/
program define Adjust, rclass
	gettoken tmat 0 : 0, parse(",")

	confirm matrix `tmat'
	tempname tm
	matrix `tm' = `tmat'

	syntax, [Mtest Mtest2(passthru) Pindex(int 1) if(str) REPlace APPend]

	// recursively use the Syntax subcommand to parse mtest
	Syntax , `mtest' `mtest2'
	local method `r(method)'

	if !inrange(`pindex',1,colsof(`tm')) {
		di as err "_mtest: pindex out of range"
		exit 198
	}
	local ip `pindex'   // I want a short name...

	if `"`if'"' != "" {
		confirm integer number `if'
		if !inrange(`if', 1, colsof(`tm')) {
			di as err "_mtest: if() out of range"
			exit 198
		}
		if `if' == `pindex' {
			di as err "_mtest: if() should not equal pindex()"
			exit 198
		}
	}

	local n = rowsof(`tm')
	forvalues i = 1/`n' {
		if !inrange(`tm'[`i',`ip'],0,1) & !missing(`tm'[`i',`ip']) {
			di as err "_mtest: p-value out-of-range"
			noi mat list `tm' , title(_mtest: matrix with tests)
			exit 198
		}
	}

	// ----------------------------------------------------------
	// extract matrix of selected tests
	// ----------------------------------------------------------

	tempname p index
	mat `p' = J(`n',1,0)
	mat `index' = J(`n',1,0)
	local ii 0
	if "`if'" != "" {
		forvalues i = 1/`n' {
			if !inlist(`tm'[`i',`if'],0,.) ///
			   & !missing(`tm'[`i',`ip']) {
				local ++ii
				matrix `index'[`ii',1] = `i'
				matrix `p'[`ii',1] = `tm'[`i',`ip']
			}
		}
	}
	else {
		forvalues i = 1/`n' {
			if !missing(`tm'[`i',`ip']) {
				local ++ii
				matrix `index'[`ii',1] = `i'
				matrix `p'[`ii',1] = `tm'[`i',`ip']
			}
		}
	}
	if `ii' == 0 {
		di as err "_mtest: 0 valid tests"
		exit 198
	}
	else if `ii' < `n' {
		matrix `p' = `p'[1..`ii',1]
	}

	// ---------------------------------------------------------------------
	// compute the column-vector adjp of adjusted p-values from
	// the column vector p, with m = rowsof(p) is # tests.
	// ---------------------------------------------------------------------

	tempname adjp
	local m = rowsof(`p')
	matrix `adjp' = J(`m',1,0)
	matrix colnames `adjp' = adjustp    // column name

	// Bonferroni

	if "`method'" == "bonferroni" {

		forvalues i = 1/`m' {
			matrix `adjp'[`i',1] = min(1, `m' * `p'[`i',1])
		}
	}

	// Holm

	else if "`method'" == "holm" {

		tempname np
		local tol 1e-8      // multiplicative tolerance for ties
		forvalues i = 1/`m' {
			scalar `np' = 0
			forvalues j = 1/`m' {
				// #tests (excl i) with p smaller p(i)(1+tol)
				if `i' != `j' {
					if `p'[`i',1] <= `p'[`j',1]*(1+`tol') {
						scalar `np' = `np' + 1
					}
				}
			}
			mat `adjp'[`i',1] = min(1, (1+`np') * `p'[`i',1])
		}
	}

	// Sidak

	else if "`method'" == "sidak" {

		forvalues i = 1/`m' {
			mat `adjp'[`i',1] = 1 - (1-`p'[`i',1])^(`m')
		}
	}

	/*
		XX ADD NEW METHODS HERE
	*/

	/* no need to touch code beyond this point */

	else if "`method'" == "noadjust" {
		mat `adjp' = `p'
	}
	else {
		di as err "_mtest: this should not happen"
		exit 9999
	}

	// ---------------------------------------------------------------------
	// return result in r(result)
	// ---------------------------------------------------------------------

	// Add missings where p was missing or not if-selected
	if `m' < `n' {
		tempname adjp2
		mat `adjp2' = J(`n',1,.)
		forvalues it = 1/`m' {
			matrix `adjp2'[`index'[`it',1],1] = `adjp'[`it',1]
		}
		matrix `adjp' = `adjp2'
	}

	if "`replace'`append'" == "" {
		local rnames : rownames(`tm')
		matrix rownames `adjp' = `rnames'
		matrix colnames `adjp' = padjust
		return matrix result `adjp'
	}

	else if "`replace'" != "" {
		matrix `tm'[1,`ip'] = `adjp'
		// modify the column name as well
		local cnames : colnames `tm'
		tokenize "`cnames'"
		local `ip' adjustp
		matrix colnames `tm' = `*'
		return matrix result `tm'
	}

	else if "`append'" != "" {
		matrix `adjp' = `tm' , `adjp'
		return matrix result `adjp'
	}
	return local method `method'
end
exit

Search for XX if you want to add a method
