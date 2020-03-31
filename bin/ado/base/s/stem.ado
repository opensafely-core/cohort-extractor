*! version 3.3.13  16feb2015
program define stem, rclass byable(recall) sort
	version 6.0, missing
	syntax varlist [if] [in] [, /*
		*/ Width(string) Lines(string) Digits(integer 1) /*
		*/ Round(string) Short Prune Truncate(string) ]
	local x "`varlist'"

/* Check values of options. */

	if "`short'" != "" { /* old-style syntax */
		local prune "prune"
	}

	if `digits' <= 0 {
		di in red "digits() must be greater than zero"
		exit 198
	}

	local tend = round(10^`digits', 1)

	/* Note: 10^d may not return perfect integers. */

	if "`width'" != "" & "`lines'" != "" {
		di in red "only one of width() or lines() may be specified"
		exit 198
	}
	if "`lines'" != "" {
		local check lines
		local width = `tend'/`lines'
	}
	else local check width
	
	if "`width'" != "" {
		capture confirm integer number ``check''
		if _rc {
			di in red "`check' must be an integer"
			exit 198
		}
		if ``check'' <= 0 {
			di in red "`check' must be greater than zero"
			exit 198
		}
		if ``check'' > `tend' {
			di in red "`check' must be less than or equal to `tend'"
			exit 198
		}
		if mod(`tend', ``check'') != 0 {
			di in red /*
			*/ "`check' must divide `tend'"
			exit 198
		}
	}

	if "`round'" != "" & "`truncat'" != "" {
		di in red /*
		*/ "only one of round() or truncate() may be specified"
		exit 198
	}
	
	if "`round'" != "" {
		confirm number `round'
		if `round' == 0 {
			di in red /*
			*/ "round() cannot be 0"
			exit 198
		}
	}
	if "`truncat'" != "" {
		confirm number `truncat'
		if `truncat' == 0 {
			di in red /*
			*/ "truncate() cannot be 0"
			exit 198
		}
	}
	
/* Markout. */
	
	tempvar doit
	mark `doit' `if' `in'
	markout `doit' `x'
	qui count if `doit'
	if r(N) == 0 { error 2000 }

/* Round or truncate x. */
	
	if "`round'" == "" & "`truncat'" == "" {
		rd_stem `doit' `x'
		local round "$S_1" /* S_1 is empty if `x' integer */
		local meth "round"
	}

	if "`round'" != "" {
		tempvar y
		qui gen double `y' = round(`x'/`round', 1) if `doit'
		local meth "round"
	}
	else if "`truncat'" != "" {
		tempvar y
		qui gen double `y' = int(`x'/`truncat') if `doit'
		local meth "truncat"
	}
	else local y `x'

/* Choose value of `width' and `digits' if `width' is missing. */

	if "`width'" == "" {
		wth_stem `doit' `y' `digits'
		local digits "$S_1"
		local width  "$S_2"
	}

/* Print header. */

	di _n in gr "Stem-and-leaf plot for `x'" _c
	local varlab : variable label `x'
	if "`varlab'" != "" {
		if length("`varlab'")>49 {
			di _n in gr "(`varlab')" _n
		}
		else	di in gr " (`varlab')" _n
	}
	else	di _n

	if "`round'" != "" | "`truncat'" != "" {
		if "`round'" == "1" | "`truncat'" == "1" {
			local typ : type `x'
			if !inlist("`typ'","byte","int","long") {
				di in gr "`x' `meth'ed to integers" _n
			}
		}
		else {
			#delimit ;
			di in gr "`x' `meth'ed to nearest multiple of "
			   in ye "`round'`truncat'" _n
			   in gr "plot in units of "
			   in ye "`round'`truncat'" _n ;
			#delimit cr
		}
	}

/* Construct and print plot. */

	di_stem `doit' `y' `width' `digits' `prune'

	ret scalar digits = `digits'
	ret scalar width  = `width'
	if "`round'" != "" { ret local round "`round'" }
	else ret local truncate "`truncate'"

	global S_1 "`return(digits)'"	/* double saves */
	global S_2 "`return(width)'"	/* double saves */
	global S_3 "`return(round)'"	/* double saves */
end


program define rd_stem
/*
   Computes value of `round' when not specified by user.
   Output: global S_1 = `round' or S_1 empty if `x' integer.
   Note: We never automatically set `round' > 1.
*/
	version 4.0
	local doit    "`1'"      /* mark variable        */
	local x       "`2'"      /* user's data variable */

	capture assert `x' == round(`x',1) if `doit'
	if _rc == 0 {
		global S_1
		exit
	}

	qui summarize `x' if `doit'
	local range = r(max) - r(min)
	if `range' == 0 { local range = r(max) }

	local logrd = log10(`range') 

	if      `logrd' > 2 { local logrd  0 }
	else if `logrd' > 1 { local logrd -1 }
	else if `logrd' > 0 { local logrd -2 }
	else {
		local logrd = int(`logrd') - 3
	}

	global S_1 = 10^`logrd'  /* = round */

	while `logrd' < 0 {
		capture assert abs(round(`x',$S_1) - round(`x',10*$S_1)) /*
		*/	       < 0.5*$S_1  if `doit'

		if _rc { exit /* cannot round any less */ }

		local logrd = `logrd' + 1
		global S_1 = 10^`logrd'
	}
end


program define wth_stem
/*
   Computes values of `digits' and `width'
   when `width' not specified by user.
   Output: global S_1 = `digits'
           global S_2 = `width'
*/
	version 4.0
	local doit    "`1'"      /* mark variable   */
	local y       "`2'"      /* x or rounded x  */
	local d       "`3'"      /* digits per leaf */
	local tend  = round(10^`d', 1)

	qui summarize `y' if `doit'
	local range = r(max) - r(min)
	local n = r(N)

	if `range' == 0 {
		global S_1  1  /* digits */
		global S_2 10  /* width  */
		exit
	}

	local width = int(1+`range'/sqrt(2*`n'*`d'))

	if `width' > `tend' {
		if `d' > 1 { /* do not change user's value of digits */
			global S_1 "`d'"     /* digits */
			global S_2 "`tend'"  /* width  */
			exit
		}
		while `width' > round(10^`d', 1) {
			local d = `d' + 1
			local width = int(1+`range'/sqrt(2*`n'*`d'))
		}
	}

/* Make `width' one of 1, 2, 5, 10 times 10^(`d' - 1). */
	
	local td1 = round(10^(`d' - 1), 1)

	if abs(`width'-2*`td1') < abs(`width'-5*`td1') {
		if abs(`width'-`td1') < abs(`width'-2*`td1') {
			local width = `td1'
			if `d' > 1 {
				local d = `d' - 1
			}
		}
		else local width = 2*`td1'
	}
	else {
		if abs(`width'-5*`td1') < abs(`width'-10*`td1') {
			local width = 5*`td1'
		}
		else local width = 10*`td1'
	}
	if `width'==1 & `d'==1 & `n'<=`range'*min(`range',10) {
		local width 2
	}

	global S_1 "`d'"      /* digits */
	global S_2 "`width'"  /* width  */
end


program define di_stem
/*
   Constructs and prints stem-and-leaf plot.
*/
	version 4.0
	local doit    "`1'"      /* mark variable          */
	local y       "`2'"      /* x or rounded x         */
	local width   "`3'"      /* width of stem          */ 
	local d       "`4'"      /* digits per leaf        */
	local prune   "`5'"      /* do not di empty leaves */
	local tend  = round(10^`d', 1)
		
	tempvar stem leaves count printit
	quietly {

	/* Compute `stem'.  `stem' = multiple of `width'. */

		gen double `stem' = `y' - sign(`y')*mod(abs(`y'),`width') /*
		*/ if `doit'

	/* Differentiate `stem' for -0 from 0 if necessary. */

		if `width' > 1 {
			replace `stem' = -1 if `stem'==0 & `y'<0 & `doit'
		}

	/* Compute format (fmt) of `stem'. */

		summarize `stem' if `doit'
		local fmt = int(max(abs(r(min)),abs(r(max)))/`tend')
		local fmt = length("`fmt'") + 2
		local skip = `fmt' - 2 /* for printing -0 stem */

	/* Compute string length for `leaves'. */

		sort `doit' `stem' `y'

		by `doit' `stem': gen `c(obs_t)' `count' = _N if `doit' 
		summarize `count' if `doit'
		local nstr = r(max)
		if `d' > 1 {
			local nstr = (`d' + 1)*`nstr'
			local comma ","
		}

		if `fmt' + `d' + 3 + `nstr' > 79 {
			local nstr = 76 - `fmt' - `d'
			local trunc 1
		}

	/* Compute `leaves'. */
		
		#delimit ;
		gen str`nstr' `leaves' = substr(
			string(`tend' + mod(abs(`y'),`tend')),
			2,.) if `doit' ;
		
		by `doit' `stem': replace `leaves' =
			substr(`leaves'[_n-1] + "`comma'" + `leaves',
			1, `nstr') if _n > 1 & `doit' ;
		#delimit cr

	/* Note: nopromote could be used above instead of substr,
	   but it does not work with "by" in version 4.0.
	*/

	/* Put in counts for truncated stems. */

		if "`trunc'" != "" {
			if `d' > 1 { local dd = `d' + 1 }
			else local dd 1
			
			#delimit ;
			by `doit' `stem': replace `leaves' =
				substr(`leaves', 1,
				`nstr'-7-length(string(`count'))
				- sign(`nstr'-7-length(string(`count')))
				* mod(abs(`nstr'-7-length(string(`count'))),
					 `dd'))
				+ " ... (" + string(`count') + ")"
				if `dd'*`count' > `nstr'
				   & _n == _N & `doit' ;
			#delimit cr
		}

	/* Put the lines to print out at the beginning of the data set.  */
		
		by `doit' `stem': gen byte `printit' = !(`doit'&_n==_N)
		count if !`printit'
		local n = r(N)
		sort `printit' `stem' /* print first n obs */
	}
	
/* Build place holders for stem. */

	if `d' == 1 & (`width' == 2 | `width' == 5) {
		local special 1
		local hold0 "*"
		if `width' == 2 {
			local hold1 "t"
			local hold2 "f"
			local hold3 "s"
			local hold4 "."
		}
		else local hold1 "."
	}
	else {
		local special 0
		local i 1
		while `i' <= `d' {
			local place "`place'*"
			local i = `i' + 1
		}
	}

/* Print. */
		
	local next = `stem'[1]
	local i 1
	while `i' <= `n' {

	/* Decide whether to print leaves on stem. */
		
		if `stem'[`i'] == `next' | "`prune'"!="" {
			local next = `stem'[`i']
			local prleav "in ye `leaves'[`i']"
			local i = `i' + 1
		}
		else local prleav
		
	/* Determine special placeholders if d = 1 and width = 2 or 5. */
	
		if `special' {
			local iplace = int(mod(abs(`next'), 10)/`width')
			local place "`hold`iplace''"
		}
			
	/* Print.  Stem with -0 is a special case. */
		
		if int(`next'/`tend') == 0 & `next' < 0 {
			di in smcl in ye _skip(`skip') "-0`place'" /*
			*/	in gr " {c |} " `prleav' 
		}
		else di in smcl in ye %`fmt'.0f int(`next'/`tend') /*
		*/	"`place'" in gr " {c |} " `prleav'

	/* Increment `next'.  If `prune', change in `next' is ignored. */

		if `next' >= 0 | `next' < -`width' | `width' == 1 {
			local next = `next' + `width'
		}
		else if `next' == -1 {
			local next 0
		}
		else if `next' == -`width' {
			local next -1
		}
	}
end
