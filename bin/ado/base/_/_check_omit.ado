*! version 1.1.0  15mar2016
program _check_omit
	version 11
	syntax namelist(name=matname min=1 max=1) [, Get Check Result(name) ]
	
	opts_exclusive "`get' `check'"
	
	if "`get'" != "" {
		GetMat, matrix(`matname')
		if "`result'" != "" {
			c_local `result' 
		}
	}
	else {
		capture confirm matrix `matname'
		if _rc {
			di as error "`matname' must be a matrix in memory"
			exit 198
		}
		if "`result'" == "" {
			di as error "must specify option result"
			exit 198
		}
		/* CheckMat checks matrix e(b) and `matname' and returns 
 		0 if they do not match */

		/* need to change later for svy_sum commands */
		local SvySum mean prop proportion ratio total
		local cmd `e(cmd)'
		if "`cmd'" != "" & `:list cmd in SvySum' {
			c_local `result' 0
			exit
		}
		CheckMat, matrix(`matname') check(check)
		c_local `result' `check'
	}

end

program GetMat
	syntax , matrix(name)
	
	/* create matrix of 0's and 1's */
	if "`e(b)'" != "matrix" {
		di as error "e(b) not found"
		exit 301
	}
	if "`e(V)'" != "matrix" {
		di as error "e(V) not found"
		exit 301
	}

	tempname matomit
	matrix `matomit' = e(b)
	local dim = colsof(`matomit')
	local coleq : coleq e(b), quote
	local colna : colna e(b), quote
	local j 0
	forval i = 1/`dim' {
		gettoken eq coleq : coleq
		gettoken na colna : colna
		if `"`eq'"' != "_" {
			if `"`eq'"' != `"`oldeq'"' {
				local ++j
				local oldeq : copy local eq
			}
			local beq [#`j']
		}
		local b  `beq'_b[`na']
		local se `beq'_se[`na']
		matrix `matomit'[1,`i'] = (`b'!=0 | `se' !=0)
	}
	matrix rename `matomit' `matrix'
end

program CheckMat
	syntax , matrix(name) check(name)
	/* check if current e(b) follows omit pattern in `matrix' */
	if "`e(b)'" != "matrix" {
		di as error "e(b) not found"
		exit 301
	}
	if "`e(V)'" != "matrix" {
		di as error "e(V) not found"
		exit 301
	}

	local dim : colsof e(b)
	if `dim' != colsof(`matrix') {
		c_local `check' 1
		exit
	}

	local retcheck 0
	local coleq : coleq e(b), quote
	local colna : colna e(b), quote
	local j 0
	forval i = 1/`dim' {
		gettoken eq coleq : coleq
		gettoken na colna : colna
		if "`eq'" != "_" {
			if `"`eq'"' != `"`oldeq'"' {
				local ++j
				local oldeq : copy local eq
			}
			local beq [#`j']
		}
		local b  `beq'_b[`na']
		local se `beq'_se[`na']
		if `b'==0 & `se'==0 {
			if `matrix'[1,`i'] != 0 {	
				local retcheck 1
				continue, break 
			}
		}
		else {
			if `matrix'[1,`i'] != 1 {
				local retcheck 1
				continue, break
			}
		}
	}
	c_local `check' `retcheck'
end

exit
