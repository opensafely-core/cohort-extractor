*! version 1.6.2  12jan2018
program define _mkvec, sclass
/* Syntax:
	_mkvec matname [, FROM(this:that=# that=# /this=# matrix #, COPY SKIP)
                          UPdate COLnames(string) ERRor(string) FIRST ]
*/
	local vv : display "version " string(_caller()) ":"
	version 6

/* Parse. */

	gettoken matout 0 : 0, parse(", ")
	if "`matout'"=="" | "`matout'"=="," {
		error 198
	}

	syntax [, FROM(str) UPdate COLnames(str) ERRor(str) FIRST ]

	if "`update'"!="" {
		if "`colname'"!="" {
			di in red "update and colnames() cannot both be " /*
			*/ "specified"
			exit 198
		}
		capture local colname : colfullnames `matout'
		if _rc {
			di in red "matrix `matout' not found"
			exit 111
		}
		if rowsof(matrix(`matout')) != 1 {
			di in red "`matout' matrix to be updated must be " /*
			*/ "a row vector"
			exit 503
		}
		local matin `matout'
	}
	if `"`error'"'!="" {
		local error `"`error': "'
	}

	tempname mat

	if `"`from'"'!="" {

/* Split off [, COPY SKIP ] options from -from(..., copy skip)-. */

		From `from'
		local copy `s(copy)'
		local skip `s(skip)'

/* Copy vector. */

		if "`copy'"!="" {
			CopyMat `mat' `"`error'"' `s(from)'
			if `"`colname'"'!="" {
				local dim : list sizeof colname
				if `dim' != colsof(matrix(`mat')) {
					di in red `"`error'matrix must "' /*
					*/ `"be dimension "' `dim'
					exit 503
				}
				`vv' mat colnames `mat' = `colname'
			}
		}

/* Or build up vector. */

		else {
			`vv' BuildMat `mat' `"`error'"' "`skip'" `s(from)'
			if `"`colname'"'!="" {
				`vv' ChkNames `mat' "`matin'" `"`colname'"' /*
				*/ `"`error'"' "`skip'" "`first'"
				local fill `s(k_fill)'
			}
		}
	}
	else {

/* If here, there is no -from()-. */

		local fill 0

		if "`update'"!="" {
			mat `mat' = `matin'
		}
		else if `"`colname'"'!="" {
			local dim : list sizeof colname
			mat `mat' = J(1,`dim',0)
			`vv' mat colnames `mat' = `colname'
		}
		else {
			di in red "from() must be specified"
			exit 198
		}
	}

	sret clear
	sret local copy `copy'
	sret local skip `skip'
	sret local k = colsof(matrix(`mat'))
	if "`fill'"!="" {
		sret local k_fill `fill'
	}
	else sret local k_fill = colsof(matrix(`mat'))

	matrix rename `mat' `matout', replace
end

program define From, sclass /* split off COPY SKIP options */
	gettoken from 0 : 0, parse(",") bind

	sret clear
	sret local from `from'

	if `"`0'"'!="" {
		syntax [, COPY SKIP ]
	}

	sret local copy `copy'
	sret local skip `skip'
end

program define CopyMat /* matname { matrix | # } ... */
	args matall error
	tempname matadd

	local i 3
	while "``i''"!="" {
		capture di matrix(``i''[1,1])
		if _rc == 0 {
			ChkMat `matadd' ``i'' `"`error'"'
		}
		else {
			capture confirm number ``i''
			if _rc {
				di in red `"`error'copy option requires "' /*
				*/ "either a matrix or a list of numbers"
				exit 198
			}

			mat `matadd' = J(1,1,``i'')
		}

		mat `matall' = nullmat(`matall') , `matadd'

		local i = `i' + 1
	}
end

program define BuildMat /* matname this:that=# that=# /this=# matrix */
	local vv : display "version " string(_caller()) ":"
	version 6
	args matall error skip
	macro shift 3
	tokenize `"`*'"', parse(" =")
	tempname matadd
	local i 1
	while "``i''"!="" {
		local k = `i' + 1
		if "``k''"=="=" {
			local j = `i' + 2
			`vv' MkMat `matadd' ``i'' ``j'' `skip'
			local i = `i' + 3
		}
		else {
			ChkMat `matadd' ``i'' `"`error'"'
			local i = `i' + 1
		}
		mat `matall' = nullmat(`matall') , `matadd'
	}
end

program define ChkMat /* matname matrix */
	args matout matin error
	capture di matrix(`matin'[1,1])
	if _rc {
		capture confirm number `matin'
		if _rc {
			di in red `"`error'matrix `matin' not found"'
			exit 111
		}
		di in red `"`error'list of numbers requires copy option"'
		exit 198
	}
	if matrix(rowsof(`matin')!=1 & colsof(`matin')!=1) {
		di in red "`matin' " matrix(rowsof(`matin')) /*
		*/ " x " matrix(colsof(`matin')) " is not a vector"
		exit 503
	}
	if matrix(rowsof(`matin')) == 1 {
		mat `matout' = `matin'
	}
	else	mat `matout' = `matin''
end

program define MkMat /* matname {[eq:]name | /name} # */
	local vv : display "version " string(_caller()) ":"
	version 6
	args mat el_name z skip
	confirm number `z'

	tokenize "`el_name'", parse(" :/")
	if "`2'"==":" {
		local eqname "`1'"
		local colname "`3'"
	}
	else if "`1'"=="/" & _caller() < 15 {
		local eqname "`2'"
		local colname _cons
	}
	else	local colname "`el_name'"

	if "`colname'" != "_cons" { /* must allow non-vars, but also unab */
		if "`skip'" != "" {
			local cap capture
		}
		`cap' _ms_unab colname : `colname'
	}

	mat `mat' = J(1,1,`z')
	if "`eqname'"!="" {
		`vv' mat coleq `mat' = `eqname'
	}
	`vv' mat colnames `mat' = `colname'
end

program define ChkNames, sclass
	local vv : display "version " string(_caller()) ":"
	version 6
	args mat matin names error skip first
	local dim = colsof(matrix(`mat'))

	if "`first'"!="" { /* get first equation name */
		gettoken name : names
		local eq1 = bsubstr(`"`name'"',1,index(`"`name'"',":"))
	}

	tempname new fill x

	local k : list sizeof names
	if "`matin'"!="" {
		mat `new' = `matin'
	}
	else {
		mat `new' = J(1,`k',0)
		`vv' mat colnames `new' = `names'
	}
	mat `fill' = J(1,`k',0)

	local i 1
	while `i' <= `dim' {
		mat `x' = `mat'[1,`i'..`i']
		local eq   : coleq `x'
		local name : colname `x'
		if "`eq'" == "/" {
			local spec "/`name'"
		}
		else {
			local spec "`eq':`name'"
			if (usubstr("`eq'",1,1) != "/") {
				local sspec "/`eq':`name'"
			}
		}
		local oname
		local ospec
		capture _msparse `name', noomit
		if c(rc) == 0 {
			if r(omit) {
				local oname `"`r(stripe)'"'
				local ospec "`eq':`oname'"
			}
		}
		`vv' local j = colnumb(`new',`"`spec'"')
		if `j' == . & "`oname'" != "" {
			`vv' local j = colnumb(`new',`"`ospec'"')
		}
		if `j' == . & "`sspec'" != "" {
			`vv' local j = colnumb(`new',`"`sspec'"')
		}
		if `j'==. & `"`eq'"'=="_" & `"`eq1'"'!="" {
			`vv' local j = colnumb(`new',`"`eq1'`name'"')
			if `j' == . & "`oname'" != "" {
				`vv' local j = colnumb(`new',`"`eq1'`oname'"')
			}
		}
		if `j'!=. {
			if `fill'[1,`j'] {
			    _ms_parse_parts `name'
			    if !r(omit) {
				if "`eq'"=="_" {
					di in red `"`error'duplicate "' /*
					*/ `"entries for `name' found"'
				}
				else di in red `"`error'"' /*
				*/ `"duplicate entries for `eq':`name' found"'
				exit 507
			    }
			    else if !missing(`new'[1,`j']) {
				// omit elements may only replace missing
				// values
			    	matrix `mat'[1,`i'] = `new'[1,`j']
			    }
			}
			else	mat `fill'[1,`j'] = 1

			mat `new'[1,`j'] = `mat'[1,`i']
		}
		else if "`skip'"=="" {
			if "`eq'"=="_" {
				local spec : copy local name
			}
			di in red `"`error'extra parameter "' /*
				*/ `"`spec' found"' _n /*
				*/ "specify skip option if necessary"
			exit 111
		}

		local i = `i' + 1
	}

	mat `fill' = `fill'*`fill''
	sret clear
	sret local k_fill = `fill'[1,1]

	mat `mat' = `new'
end
