*! version 3.3.8  28jan2015  
program define gprobit_8, eclass byable(recall)
	version 6.0, missing
	local options `"Level(cilevel)"'
	if `"`*'"'==`""' | bsubstr(`"`1'"',1,1)==`","' { 
		if `"`e(cmd)'"'!=`"gprobit"' { error 301 } 
		if _by() { error 190 }
		syntax [, `options']
		parse
	}
	else { 
		syntax varlist(min=2) [if] [in] [, `options']
		marksample touse
		tokenize `varlist'
		local lhs1 "`1'"
		local lhs "`1' `2'"
		tempvar S P PROBIT
		quietly {
			gen long `S'=`1' if `1'>=0
			gen long `P'=`2' if `2'>=0 & `1'<=`2'
			gen double `PROBIT'=invnorm(`S'/`P') if `touse'
			mac shift 2
			reg `PROBIT' `*' /*
	*/ [aw=(exp(-`PROBIT'^2)/(2*_pi))*(`P'/((`S'/`P')*((`P'-`S')/`P')))] /*
			*/ if `touse', depname(`lhs1')
		}
		est local cmd
		est local wexp
		est local wtype 
		est local ll
		est local ll_0
		est local depvar "`lhs'"
		est local predict "gprobi_p"
		est local cmd "gprobit"
		global S_E_cmd "gprobit"   /* double save */
	}
	noisily di _n in gr /*
		*/ `"Weighted least-squares probit estimates for grouped data"'
	regress, level(`level')
end
