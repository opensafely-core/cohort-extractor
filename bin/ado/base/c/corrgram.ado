*! version 1.4.0  01nov2017
program define corrgram, rclass
/*
   -ac- requires

   1.  N >= 2,

   2.  lags() <= N - 1.

   -pac- requires

   1.  N >= 6,

   2.  lags() <= int(N/2) - 2.

   If lags() not specified, by default lags() = max(1, min(int(N/2) - 2, 40)).
*/
	version 6, missing
	syntax varname(ts) [if] [in] [, noPLot Lags(integer -999) YW ]
	
	local vv : display "version " string(_caller()) ":"

	_ts tvar panelvar `if' `in', sort onepanel

	quietly {
		marksample touse
		markout `touse' `tvar'
		count if `touse'
		local n = r(N)

		if `lags' == -999 {
			local lags = max(1,min(int(`n'/2)-2,40))
		}
		else if `lags' >= `n' {
			di in red "lags() too large; must be less than " `n'
			exit 498
		}
		else if `lags' <= 0 {
			di in red "lags() must be greater than zero"
			exit 498
		}

		tsreport if `touse' & `varlist'< .

		if r(N_gaps) > 0 {
			if r(N_gaps) > 1 {
				noi di in blu "(note: time series has " /*
				*/ r(N_gaps) " gaps)"
			}
			else	noi di in blu "(note: time series has 1 gap)"
		}

		tempvar ac pac q

		`vv' ac `varlist' if `touse', lags(`lags') gen(`ac') nograph

		if `lags' > int(`n'/2) - 2 {
			local plags = int(`n'/2) - 2
		}
		else	local plags `lags'

		if `plags' > 0 {
			`vv' pac `varlist' if `touse', lags(`plags') /*
			*/ gen(`pac') nograph `yw'
		}
		else	gen byte `pac' = . in 1

		gen double `q' = `n'*(`n'+2)*sum(`ac'^2/(`n'-_n)) /*
		*/ in 1/`lags' if `ac'< .
	}

					/* set r() */
	tempname AC PAC Q
	local dim = c(max_matdim)
	if `lags' < `dim' {
		local dim `lags'
	}
	mat `AC'  = J(1,`dim',0)
	mat `PAC' = J(1,`dim',0)
	mat `Q'   = J(1,`dim',0)
	local i 1
	while `i' <= `lags' {
		if `i' <= 10 {
			ret scalar ac`i'  = `ac'[`i']
			ret scalar pac`i' = `pac'[`i']
			ret scalar q`i'   = `q'[`i']
		}

		if `i' <= `dim' {
			local cname `cname' lag`i'

			if `ac'[`i']< . & "`acmiss'"!="1" {
				mat `AC'[1,`i'] = `ac'[`i']
				local aclast `i'
			}
			else	local acmiss 1

			if `pac'[`i']< . & "`pacmiss'"!="1" {
				mat `PAC'[1,`i'] = `pac'[`i']
				local paclast `i'
			}
			else	local pacmiss 1

			if `q'[`i']< . & "`qmiss'"!="1" {
				mat `Q'[1,`i'] = `q'[`i']
				local qlast `i'
			}
			else	local qmiss 1
		}

		local i = `i' + 1
	}

	if "`aclast'"!="" {
		mat colnames `AC' = `cname'
		mat `AC' = `AC'[1,1..`aclast']
		ret matrix AC `AC'
	}
	if "`paclast'"!="" {
		mat colnames `PAC' = `cname'
		mat `PAC' = `PAC'[1,1..`paclast']
		ret matrix PAC `PAC'
	}
	if "`qlast'"!="" {
		mat colnames `Q' = `cname'
		mat `Q' = `Q'[1,1..`qlast']
		ret matrix Q `Q'
	}

	ret scalar lags = `lags'

	if "`plot'"=="" {
		di in smcl _n in gr _col(43)/*
		*/  "-1       0       1 -1       0       1" /*
		*/ _n " LAG       AC       PAC      Q     Prob>Q" /*
		*/ "  [Autocorrelation]  [Partial Autocor]" /*
		*/ _n "{hline 79}"
	}
	else {
		di in smcl _n in gr /*
		*/ " LAG       AC       PAC      Q     Prob>Q" /*
		*/ _n "{hline 41}"
	}
	local i 1
	while `i' <= `lags' {
		DiLine `i' `ac'[`i'] `pac'[`i'] `q'[`i'] `plot'
		local i = `i'+1
	}
end

program define DiLine
	args lag ac pac q plot

	if "`plot'"=="" {
		MkString `ac'
		local sac `"`r(string)'"'
		MkString `pac'
		local spac `"`r(string)'"'
	}
	di in smcl in gr %-6.0g `lag' in ye /*
		*/ _col(9)  %7.4f `ac' /*
		*/ _col(18) %7.4f `pac' /*
		*/ _col(27) %7.0g `q' /*
		*/ _col(36) %6.4f chiprob(`lag',`q') /*
		*/ _col(44) `"`sac'"' /*
		*/ _col(63) `"`spac'"'
end

program define MkString, rclass
	args corr /* corr = ac  or  corr = pac */
	if `corr'>=. {
		exit
	}

	if `corr' >= 0 {
		local vb = 9
		local ve = int(8*`corr') + `vb'
	}
	else {
		local ve = 9
		local vb = int(8*`corr') + `ve'
	}
	local k 1
	while `k' <= 17 {
		local char " "
		if `vb' <= `k' & `k' <= `ve' {
			local char "{hline 1}"
		}
		if `k'==9 { 
			if `vb' == 9 & `ve' == 9 {
				local char "{c |}"
			}
			if `vb' == 9 & `ve' > 9 {
				local char "{c LT}"
			}
			if `vb' < 9 & `ve' == 9 {
				local char "{c RT}"
			}
		}	
		local s `"`s'`char'"'
		local k = `k' + 1
	}
	ret local string `"`s'"'
end

exit
----+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8

                                          -1       0       1 -1       0       1
 LAG       AC       PAC      Q     Prob>Q  [Autocorrelation]  [Partial Autocor]
######  S#.####  S#.####  ####### S#.####  AAAAAAAAAAAAAAAAA  AAAAAAAAAAAAAAAAA
 %6.0g   %6.4f    %6.4f    %7.0g   %6.4f         %17s                 %17s
