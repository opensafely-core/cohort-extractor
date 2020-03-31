*! version 2.2.7  27feb2019  
program compare, byable(recall)
	version 6, missing
	syntax varlist(min=2 max=2) [if] [in]
	tokenize `varlist'
	tempvar touse 
	mark `touse' `if' `in'
	/* we do not markout the missing values */

	tempvar MISS1 MISS2 DIFF
	local nd "noisily di"
	quietly { 
		local type1 : type `1'
		local type2 : type `2'
		if (bsubstr(`"`type1'"',1,3)=="str") { 
			gen byte `MISS1' = `1'=="" if `touse'
			local type1 "s"
		}
		else {
			gen byte `MISS1' = `1'>=. if `touse'
			local type1 "n"
		}
		if (bsubstr(`"`type2'"',1,3)=="str") { 
			gen byte `MISS2' = `2'=="" if `touse'
			local type2 "s"
		}
		else {
			gen byte `MISS2' = `2'>=. if `touse'
			local type2 "n"
		}

		local vn1 = abbrev("`1'",9) 
		local vn2 = abbrev("`2'",9) 

		if `"`type1'"'=="s" | `"`type2'"'=="s" { 
			`nd' in smcl _n in gr _col(29) "count" _n "{hline 33}"
		}
		else {
			local dodif "y"
			`nd' in smcl _n in gr /*
			*/ _col(41) "{hline 10} difference {hline 10}" _n /* 
			*/ _col(29) "count" _col(41) "minimum" /* 
			*/ _col(54) "average" /*
			*/ _col(66) "maximum" _n /*
			*/ "{hline 72}"
		}
		count if `MISS1'==0 & `MISS2'==0
		local joint = r(N)
		if `joint' & `"`type1'"'==`"`type2'"' { 
			if `"`dodif'"'=="y" {
				gen float `DIFF' = `1'-`2' if `MISS1'==0 /* 
				*/ & `MISS2'==0
				count if missing(`DIFF') & `MISS1'==0 ///
								& `MISS2'==0
				if (r(N)>0) {
					tempvar DIFF2
					gen double `DIFF2' = `1' - `2'	///
						if missing(`DIFF')	///
						   & `MISS1'==0 & `MISS2'==0
					replace `DIFF2'=`DIFF'		///
						 if !missing(`DIFF')
					drop `DIFF'
					rename `DIFF2' `DIFF'
				}
			}
			count if `1'<`2' & `MISS1'==0 & `MISS2'==0
			if r(N) { 
				local c = r(N)
				if `"`dodif'"'=="y" { 
					sum `DIFF' if `DIFF'<0 & `DIFF'<., /*
						*/ meanonly
					`nd' in gr "`vn1'<`vn2'" _col(25) /*
					*/ in ye %9.0f `c' _col(39) /*
					*/ %9.0g r(min) _col(52) /*
					*/ %9.0g r(mean) _col(64) /*
					*/ %9.0g r(max)
				}
				else {
					`nd' in gr `"`vn1'<`vn2'"' _col(25) /*
					*/ in ye %9.0f `c'
				}
			}
			count if `1'==`2' & `MISS1'==0 & `MISS2'==0
			if r(N) {
				`nd' in gr `"`vn1'=`vn2'"' _col(25) in ye /*
				*/ %9.0f r(N)
			}
			count if `1'>`2' & `MISS1'==0 & `MISS2'==0
			if r(N) {
				local c = r(N)
				if `"`dodif'"'=="y" { 
					sum `DIFF' if `DIFF'>0 & `DIFF'<., /*
						*/ meanonly
					`nd' in gr `"`vn1'>`vn2'"' _col(25) /*
					*/ in ye %9.0f `c' _col(39) /*
					*/ %9.0g r(min) _col(52) /*
					*/ %9.0g r(mean) _col(64) /*
					*/ %9.0g r(max)
				}
				else {
					`nd' in gr `"`vn1'>`vn2'"' _col(25) /*
					*/ in ye %9.0f `c'
				}
			}
			`nd' in smcl in gr _col(24) "{hline 10}"
		}		/* end of joint detail	*/
		if `joint' {
			if `"`dodif'"'=="y" {
				sum `DIFF', meanonly 
				`nd' in gr "jointly defined" _col(25) /*
				*/ in ye %9.0f `joint' _col(39) /*
				*/ %9.0g r(min) _col(52) /*
				*/ %9.0g r(mean) _col(64) /*
				*/ %9.0g r(max)
			}
			else {
				`nd' in gr "jointly defined" _col(25) /*
				*/ in ye %9.0f `joint' 
			}
		}
		count if `MISS1'==1 & `MISS2'==0
		if r(N) {
			`nd' in gr `"`vn1' missing only"' _col(25) /*
			*/ in ye %9.0f r(N)
		}
		count if `MISS1'==0 & `MISS2'==1
		if r(N) { 
			`nd' in gr `"`vn2' missing only"' _col(25) /*
			*/ in ye %9.0f r(N)
		}
		count if `MISS1'==1 & `MISS2'==1
		if r(N) {
			`nd' in gr "jointly missing" _col(25) /*
			*/ in ye %9.0f r(N)
		}
		`nd' in smcl in gr _col(24) "{hline 10}"
		count if `MISS1'<. & `MISS2'<.
		`nd' in gr "total" _col(25) in ye %9.0f r(N)
	}
end
