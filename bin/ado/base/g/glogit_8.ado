*! version 3.3.10  20dec2004
program define glogit_8, eclass byable(recall)
	version 6.0, missing
	local options `"or Level(cilevel)"'
	if replay() {
		if `"`e(cmd)'"'!=`"glogit"' { error 301 } 
		if _by() { error 190 }
		syntax [, `options']
	}
	else { 
		syntax varlist(min=2) [if] [in] [, `options']
		marksample touse
		tokenize `varlist'
		local lhs1 "`1'"
		local lhs "`1' `2'"
		tempvar S F LOGIT
		quietly {
			gen double `S'=`1' if `1'>=0
			gen double `F'=`2'-`1' if `2'>=0 & `2'>`1'
			gen double `LOGIT'=log(`S'/`F') if `touse'
			mac shift 2
			reg `LOGIT' `*' [aw=(`S'*`F')/(`S'+`F')] if `touse', /*
				*/ depname(`lhs1')
		}
		est local cmd
		est local depvar "`lhs'"
		est local wexp
		est local wtype
		est local ll
		est local ll_0
		est local predict "glogit_p"
		est local cmd "glogit"   /* double save in e() and S_E_ */
		global S_E_cmd "glogit"
	}
	if `"`or'"'!=`""' { local or `"eform(Odds Ratio)"' }
	di _n in gr /*
		*/ `"Weighted least-squares logit estimates for grouped data"'
	regress, level(`level') `or'
end
