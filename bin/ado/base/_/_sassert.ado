*! version 1.0.2  22aug2016

program _sassert
	version 11
	syntax anything(id="scalars"), [ tol(real 1E-8) noSTOP ///
		RELdif(real 1.0) INTeger EQual ]

	gettoken s1 s2 : anything, bind

 	tempname ts1 ts2 diff
	scalar `ts1' = `s1'
	scalar `ts2' = `s2'
	local rc = 0

	if "`equal'" != "" {
		if `ts1' != `ts2' {
			di as err "{p 0 19 }assertion failure: " /// 
			 `ts1' " != " `ts2'  "{p_end}"
			local rc = 9
		}
	}
	else if "`integer'" != "" {
		if int(`ts1') != `ts1' {
			di as err "{p 0 19 }assertion failure: " /// 
			 `ts1' " not an integer{p_end}"
			local rc = 9
		}
		else if int(`ts2') != `ts2' {
			di as err "{p 0 19 }assertion failure: " /// 
			 `ts2' " not an integer{p_end}"
			local rc = 9
		}
		else if int(`ts1') != int(`ts2') {
			di as err "{p 0 19 }assertion failure: " /// 
			 `ts1' " != " `ts2'  "{p_end}"
			local rc = 9
		}
	}
	else {
		if `reldif' < 1.0 {
			tempname teps

			if (`reldif' < 0.0) scalar `teps' = c(epsdouble)
			else scalar `teps' = `reldif'

			scalar `diff' = abs(`ts1'-`ts2')
			scalar `ts2' = abs(`ts2')+`teps'
			if (`ts2'>0.0) scalar `diff' = `diff'/`ts2'
		}
		else  scalar `diff' = reldif(`ts1', `ts2')

		cap assert `diff' <= `tol'
		local rc = c(rc)

		if `rc' == 9 {
			di as err "{p 0 19 }assertion failure: reldif(" ///
			 `ts1' ", " `ts2' ") = " `diff' " >" %7.1g `tol' _c 
			if `reldif' < 1.0 {
				di as err " (denominator eps = " ///
				 %9.3e `teps' ")" _c
			}
			di "{p_end}"
		}
	}
	if ("`stop'"=="") exit `rc'
end
exit
