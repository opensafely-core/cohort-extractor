*! version 1.3.4  16aug2019
program define _ttest, rclass
	version 6.0
/*
    This command consists of a group of helper commands for ttest and sdtest.

    _ttest one
    _ttest two
    _ttest by
    _ttest check
    _ttest header
    _ttest table
    _ttest center
    _ttest center2
    _ttest center3
    _ttest botline
    _ttest divline
*/
	gettoken cmd 0 : 0

	if "`cmd'"=="center" {
		tokenize `"`0'"'
		_center `"`1'"' `"`2'"' `"`3'"'
	}
	else if "`cmd'"=="center2" {
		tokenize `"`0'"'
		_center2 `"`1'"' `"`2'"' `"`3'"'
	}
	else if "`cmd'"=="center3" {
		tokenize `"`0'"'
		_center3 `"`1'"' `"`2'"' `"`3'"'
	}
	else {
		gettoken t1 0 : 0
		gettoken t2 0 : 0
		_`cmd' `"`t1'"' `"`t2'"' `0'
		ret add
	}
end

program define _one, rclass
/*
   Computes #obs, mean, sd of a variable for a one-sample test.
   Then calls -ttesti- or -sdtesti-.

   Syntax:

           _one {ttesti|sdtesti} level touse xvar Ho

   The first group is defined to be the lesser value of the -by- variable.
*/
	args cmd level touse xvar Ho s

	quietly summarize `xvar' if `touse'
        local n = r(N)
        local m = r(mean)
	if `"`s'"' == "" {
		local s = sqrt(r(Var))
	}


        `cmd' `n' `m' `s' `Ho', xname("`xvar'") level(`level')
	ret add
end

program define _two, rclass
/*
   Computes #obs, mean, sd of variable1 and variable2 for a two-sample test.
   Then calls -ttesti- or -sdtesti-.

   Syntax:

           _two {ttesti|sdtesti} level touse xvar1 xvar2 [options]
*/
	gettoken cmd 0 : 0
	gettoken level 0 : 0
	gettoken touse 0 : 0
	gettoken xvar1 0 : 0
	gettoken xvar2 options : 0

        quietly summarize `xvar1' if `touse'
        local n1 = r(N)
        local m1 = r(mean)
        local s1 = sqrt(r(Var))

        unabbrev `xvar2'
        local xvar2 "`s(varlist)'"
        quietly summarize `xvar2' if `touse'
        local n2 = r(N)
        local m2 = r(mean)
        local s2 = sqrt(r(Var))

        `cmd' `n1' `m1' `s1' `n2' `m2' `s2', xname("`xvar1'") /*
				*/ yname("`xvar2'") level(`level') `options'
	ret add
end

program define _by, rclass
/*
   Computes #obs, mean, sd of a variable for two groups defined by a -by-
   variable.  Then calls -ttesti- or -sdtesti-.

   Syntax:

           _by {ttesti|sdtesti} level touse xvar by [options]

   The first group is defined to be the lesser value of the -by- variable.
*/
	local by "`5'"

	capture confirm string variable `by'
	if _rc { ByNumber `0' }
	else     ByString `0'
	ret add
end

program define ByNumber, rclass
	gettoken cmd 0 : 0
	gettoken level 0 : 0
	gettoken touse 0 : 0
	gettoken xvar 0 : 0
	gettoken by options : 0

	markout `touse' `xvar' `by'

	local reversazo "reverse"
	version 16: local reversa: list options & reversazo 
	
	tempname val1 val2

	quietly {
		summarize `by' if `touse'
		if r(N) == 0 { noisily error 2000 }

		if ("`reversa'"!="") {
			scalar `val2' = r(min)
			scalar `val1' = r(max)
		}
		else {
			scalar `val1' = r(min)
			scalar `val2' = r(max)
		}

	/* Check that there are exactly 2 groups. */

		if `val1' == `val2' {
			di in red "1 group found, 2 required"
			exit 420
		}

		count if `by'!=`val1' & `by'!=`val2' & `touse'
		if r(N) != 0 {
			di in red "more than 2 groups found, only 2 allowed"
			exit 420
		}

	/* Get #obs, mean, and sd for first group. */

		summarize `xvar' if `by'==`val1' & `touse'
		local n1 = r(N)
		local m1 = r(mean)
		local s1 = sqrt(r(Var))

	/* Get #obs, mean, and sd for second group. */

		summarize `xvar' if `by'==`val2' & `touse'
		local n2 = r(N)
		local m2 = r(mean)
		local s2 = sqrt(r(Var))

	/* Get group labels. */

		local lab1 = `val1'
		local lab2 = `val2'

		local bylab : value label `by'

		if "`bylab'"!="" {
			local lab1 : label `bylab' `lab1'
			if `"`lab1'"'=="" {
				local lab1 = `val1'
			}
			local lab2 : label `bylab' `lab2'
			if `"`lab2'"'=="" {
				local lab2 = `val2'
			}
		}

		local lab1 = usubstr(`"`lab1'"',1,8)
		local lab2 = usubstr(`"`lab2'"',1,8)
	}

	`cmd' `n1' `m1' `s1' `n2' `m2' `s2', xname(`"`lab1'"') /*
			*/ yname(`"`lab2'"') level(`level') `options'
	ret add
end

program define ByString, rclass
	gettoken cmd 0 : 0
	gettoken level 0 : 0
	gettoken touse 0 : 0
	gettoken xvar 0 : 0
	gettoken by options : 0

	markout `touse' `xvar'
	markout `touse' `by', strok

	local reversazo "reverse"
	version 16: local reversa: list options & reversazo 
	
	tempvar obs

	quietly {

	/* Get `by' groups without sorting (which is unnecessarily slow!). */

		gen `c(obs_t)' `obs' = _n if `touse'
		summarize `obs', meanonly
		if r(N) == 0 { noisily error 2000 }

		tempname val1 val2
	/* call with modern version to allow string scalars */
		version 13: scalar `val1' = `by'[r(min)]

		replace `obs' = . if `by'==`val1'
		summarize `obs', meanonly
		if r(N) == 0 {
			di in red "1 group found, 2 required"
			exit 420
		}

		version 13: scalar `val2' = `by'[r(min)]

		replace `obs' = . if `by'==`val2'
		summarize `obs', meanonly
		if r(N) != 0 {
			di in red "more than 2 groups found, only 2 allowed"
			exit 420
		}

	/* Make it so that `val1' < `val2'. */

		if ("`reversa'"!="") {
			if `val1' < `val2' {
				tempname temp
				version 13: scalar `temp' = `val1'
				version 13: scalar `val1' = `val2'
				version 13: scalar `val2' = `temp'
			}
		}
		else {
			if `val1' > `val2' {
				tempname temp
				version 13: scalar `temp' = `val1'
				version 13: scalar `val1' = `val2'
				version 13: scalar `val2' = `temp'
			}		
		}

	/* Get #obs, mean, and sd for first group. */

		summarize `xvar' if `by'==`val1' & `touse'
		local n1 = r(N)
		local m1 = r(mean)
		local s1 = sqrt(r(Var))

	/* Get #obs, mean, and sd for second group. */

		summarize `xvar' if `by'==`val2' & `touse'
		local n2 = r(N)
		local m2 = r(mean)
		local s2 = sqrt(r(Var))

	/* Shorten groups labels if necessary. */

		local val1 : display udsubstr(`val1',1,8)
		local val2 : display udsubstr(`val2',1,8)
	/* Take substr() again because binary 0 might have expanded to \0 */
		local val1 = udsubstr(`"`val1'"',1,8)
		local val2 = udsubstr(`"`val2'"',1,8)
	}

	`cmd' `n1' `m1' `s1' `n2' `m2' `s2', xname(`"`val1'"') /*
			*/ yname(`"`val2'"') level(`level') `options'
	ret add
end

program define _check
/*
   This program checks sense of #obs, mean, and standard deviation for
   -ztesti-, -ttesti- and -sdtesti-.

   Syntax:

           _check {ztest|ttest|sdtest} {one|first|second} n m s [h]

   where one, first, or second refers to, respectively, a one-sample test,
   first sample of a two-sample test, or second sample of a two-sample test,
   and n = #obs, m = mean, s = standard deviation, and h = hypothesized
   value (if `sample' is "one").
*/
	args cmd sample n m s h

/* check argument number */
	if (`"`h'"' == "" & `"`sample'"' == "one") | /*
	*/ (`"`s'"' == "" & `"`sample'"' == "second")  {
		version 14:di as err "{p 0 0 2} either four arguments"/*
		*/" for a one-sample test or six arguments for a"/*
		*/" two-sample test must be specified{p_end}"
		exit 198
	}
	
/* Check `n' number of observations. */

	if "`n'"=="." {
		if "`sample'"!="one" {
			di in red "number of observations of `sample' " /*
			*/ "sample is missing"
		}
		else di in red "number of observations is missing"
		exit 416
	}

	confirm integer number `n'

	if `n' < 0 {
		if "`sample'"!="one" {
			di in red "number of observations of `sample' " /*
			*/ "sample is negative"
		}
		else di in red "number of observations is negative"
		exit 411
	}

	if `n' == 0 {
		if "`sample'"!="one" {
			di in red "`sample' sample has no observations"
			exit 2000
		}
		error 2000
	}

/* Check `m' mean. */

	if "`m'"=="." {
		if "`cmd'"=="ttest" | "`cmd'"=="ztest" {
			if "`sample'"!="one" {
                        	di in red "mean of `sample' sample is missing"
                	}
                	else di in red "mean is missing"
                	exit 416
		}
	}
	else confirm number `m'

/* Check `s' standard deviation. */

	if "`s'"=="." {
		if `n' != 1 {
			if "`sample'"!="one" {
				di in red "standard deviation of `sample' " /*
				*/ "sample is missing"
			}
			else di in red "standard deviation is missing"
			exit 416
		}
	}
	else {
		confirm number `s'

		if `s' < 0 & "`cmd'"!="ztest" {
			if "`sample'"!="one" {
				di in red "`sample' sample has a negative " /*
				*/ "standard deviation"
			}
			else di in red "standard deviation is negative"
			exit 411
		}

		if `s' <= 0 & "`cmd'"=="ztest" {
			if "`sample'"!="one" {
				di in red "`sample' standard deviation " /*
				*/ "must be positive "
			}
			else di in red "standard deviation must be positive"
			exit 411
		}
		
		if "`cmd'"!="ztest" & `n' == 1 & `s' != 0 {
			if "`sample'"!="one" {
				di in red "`sample' sample has only one " /*
				*/ "observation, but positive standard " /*
				*/ "deviation"

			}
			else di in red "only one observation, but positive " /*
			*/ "standard deviation"
			exit 499
		}
	}

/* Check next number if `sample' is "one". */

	if "`sample'"!="one" { exit }

	if "`h'"=="." {
		di in red "hypothesized value is missing"
		exit 416
	}

	confirm number `h'

	if "`cmd'"=="sdtest" & `h' < 0 {
		di in red "hypothesized standard deviation is negative"
		exit 411
	}
end

program define _header
	args level xname

	if `"`xname'"'!="" {
		capture confirm variable `xname'
		if _rc == 0 {
			local col1 "Variable"
		}
		else	local col1 "   Group"
	}
	local cil `=string(`level')'
	local cil `=length("`cil'")'
	local cilabel "Conf. Interval"
	if `cil' == 5 {
		local cilabel "Conf.Interval"
	}
	di in smcl in gr /*
	*/ "{hline 9}{c TT}{hline 68}" _n /*
	*/ "`col1'" _col(10) "{c |}" _col(16) "Obs" /*
	*/ _col(27) "Mean" _col(35) "Std. Err." _col(47) "Std. Dev."     /*
*/ _col(`=61-`cil'+(`cil'==5)') `"[`=strsubdp("`level'")'% `cilabel']"' _n /*
	*/ "{hline 9}{c +}{hline 68}"
end
/*
    5   10   15   20   25   30   35   40   45   50   55   60   65   70   75
++++|++++|++++|++++|++++|++++|++++|++++|++++|++++|++++|++++|++++|++++|++++|++++
Variable |     Obs        Mean    Std. Err.   Std. Dev.   [95% Conf. Interval]
---------+--------------------------------------------------------------------
     mpg | 1234567   123456789   123456789   123456789   123456789   123456789
*/

program define _botline
	di in smcl in gr "{hline 9}{c BT}{hline 68}"
end

program define _divline
	di in smcl in gr "{hline 9}{c +}{hline 68}"
end

program define _table
/*
    This program displays table with information about mean, etc.,
    when std. err. = (std. dev.)/sqrt(n).

    Syntax:
            _table level name #obs mean sd

    Note: expressions without blanks are OK.
*/
	args level name n mean sd ztest se

	if "`ztest'" == "" {
		if (`n') == 1 | (`n') == . {
			local sd = .
		}	
		local q = invt((`n') - 1,`level'/100)
	}
	
	else local q = invnormal((100+`level')/200)
	if ("`ztest'"=="2") {
		local se = `se'
	}	
	else {
		local se = (`sd')/sqrt(`n')
	}
	#delimit ;
	di in smcl in gr %8s abbrev(`"`name'"',8) " {c |}" in ye
		 _col(12) %7.0fc `n'
		 _col(22) %9.0g `mean'
		 _col(34) %9.0g `se'
		 _col(46) %9.0g `sd'
		 _col(58) %9.0g (`mean')-`q'*(`se')
		 _col(70) %9.0g (`mean')+`q'*(`se') ;
	#delimit cr
end

program define _dtable
/*
    This program displays table with information about mean, etc.,
    for std. err. and d.f. specified (i.e., two-sample mean difference).

    This program displays the same items as _table except that #obs and
    std. dev. are NOT displayed.

    Syntax:
            _dtable level name #obs mean se df

    Note: expressions without blanks are OK.
*/
	args level name n mean se df ztest
	
	if ("`ztest'" == "") {
		if (`n') == 1 | (`n') == . {
			local se = .
		}

		local q = invt(`df',`level'/100)
	}
	
	else local q = invnormal((100+`level')/200)

	#delimit ;
	di in smcl in gr %8s abbrev(`"`name'"',8) " {c |}" in ye
		 _col(22) %9.0g `mean'
		 _col(34) %9.0g `se'
		 _col(58) %9.0g (`mean')-`q'*(`se')
		 _col(70) %9.0g (`mean')+`q'*(`se') ;
	#delimit cr
end

program define _center
/*
   Syntax:

   _center "string"                        [displays centered "string"]

   _center "string1" "string2" "string3"   [displays centered in 3 columns]

   @ character in string toggles color from green to yellow (or from yellow
   to green); green is the default and initial color.

   Example: "green @yellow@ green @yellow@"

*/
	local left  12  /* columns centered about these values */
	local mid   39
	local right 66

	if `"`2'"'=="" {
		Display `"`1'"' `mid' 0
		di /* newline */
		exit
	}

	Display `"`1'"' `left'  0
	Display `"`2'"' `mid'   `r(DispAt)'
	Display `"`3'"' `right' `r(DispAt)'
	di /* newline */
end

program define _center2
/*
	Same as _center, but reserved for new ttest
*/
	local left  11  /* columns centered about these values */
	local mid   40 
	local right 70

	if `"`2'"'=="" {
		Display `"`1'"' `mid' 0
		di /* newline */
		exit
	}

	Display `"`1'"' `left'  0
	Display `"`2'"' `mid'   `r(DispAt)'
	if length(`"`3'"') > 20 {
		local right = 79 - int(length(`"`3'"')/2) 
	}
	Display `"`3'"' `right' `r(DispAt)'
	di /* newline */
end

program define _center3
/*
	Same as _center, but reserved for new sdtest
*/
	local left  13  /* columns centered about these values */
	local mid   40 
	local right 67

	if `"`2'"'=="" {
		Display `"`1'"' `mid' 0
		di /* newline */
		exit
	}

	Display `"`1'"' `left'  0
	Display `"`2'"' `mid'   `r(DispAt)'
	Display `"`3'"' `right' `r(DispAt)'
	di /* newline */
end

program define Display, rclass
	args string center last
	/* center = value to center about */
	/* last   = column of last character printed */

	Length `"`string'"'
	local length `r(length)'

	local skip = max((`last'!=0), `center' - int(`length'/2) - 1 - `last')

	di _skip(`skip') _c /* skip spaces */

	Print `"`string'"' /* print out string */

	ret scalar DispAt = `last'+`skip'+`length' /* last character printed */
end

program define Length, rclass
	args string
	local length 0
	while `"`string'"'!="" {
		local i = index(`"`string'"',"@")
		if `i' == 0 {
			local length = `length' + length(`"`string'"')
			local string
		}
		else {
			local length = `length' + `i' - 1
			local iplus1 = `i' + 1
			Substr `"`string'"' `iplus1' .
			local string `"`r(substr)'"'
		}
	}
	ret scalar length = `length'
end

program define Print
	args string
	local color "gr"
	while `"`string'"'!="" {
		local i = index(`"`string'"',"@")
		if `i' == 0 {
			di in `color' `"`string'"' _c
			local string
		}
		else {
			local iminus1 = `i' - 1
			Substr `"`string'"' 1 `iminus1'
			di in `color' `"`r(substr)'"' _c

			if "`color'"=="gr" { local color ye }
			else local color gr

			local iplus1 = `i' + 1
			Substr `"`string'"' `iplus1' .
			local string `"`r(substr)'"'
		}
	}
end

program define Substr, rclass
	args string a b

	if `b' == . {
		local b = length(`"`string'"') - `a' + 1
	}

	local sub = bsubstr(`"`string'"',`a',`b')

	local lsub = length(`"`sub'"')

	if `lsub' < `b' {
		local nblank = `b' - `lsub'
		local blanks : di _skip(`nblank') 
		local sub `"`blanks'`sub'"'
	}

	ret local substr `"`sub'"'
end
