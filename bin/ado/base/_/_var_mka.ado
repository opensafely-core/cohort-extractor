*! version 2.0.3  10jul2018
program define _var_mka, rclass
	version 8.0
	
	syntax varlist(ts), aname(string)

	if "`e(cmd)'" != "var" & "`e(cmd)'" != "svar" {
		di as err "newmka can only be used with "	///
			"{cmd:var} and {cmd:svar} e() results"
		exit 198
	}	

	if "`e(cmd)'" == "svar" {
		local svar "_var"
	}


	tempname b  b2
	mat `b' = e(b`svar')
	local cols = colsof(`b')
	mat `b2' = J(1,`cols', 0)

/* determine new order */

	local depvars "`e(depvar`svar')'"

	local i 0 
	foreach v of local varlist {
		local ++i
		local order0 `order0' `i'
		
		local pos : list posof "`v'" in depvars
		if `pos' == 0 {
			di as err "`v' is not a depvar in the original model"
			exit 498
		}
		else {
			local order `order' `pos'
		}

	}

	

	local mlag = e(mlag`svar')

	local lags `e(lags`svar')'

	local nlags : word count `lags'

	if `nlags' < 1 {
		di as err "there are no lags in the model, cannot "	///
			"compute impulse-response functions"
		exit 498
	}

	local exog "`e(exog`svar')'"
	local nexog : word count `exog'

	if "`e(nocons`svar')'" == "" {
		local ++nexog
	}

	local neqs = e(neqs)

	local tparms = `nlags'*`neqs' + `nexog'


	local same : list order0 == order 

/* if the order is not the original order re-arrange original e(b) into
 * new b2
 * 
 * if the order is the same, just copy e(b) into b2
 */
	
	if `same' != 1 {
		local ord01 0
		foreach ord1 of local order {
			local ++ord01

			local ord02 0
			foreach ord2 of local order {
				local ++ord02

				forvalues i=1/`nlags' {
local pos1 = `tparms'*(`ord01'-1) + (`ord02'-1)*`nlags' + `i'
local pos0 = `tparms'*(`ord1'-1) + (`ord2'-1)*`nlags' + `i'
mat `b2'[1,`pos1'] = `b'[1,`pos0']
				}

				local endoff = `neqs'*`nlags'
				forvalues i = 1/`nexog' {
local pos1 = `tparms'*(`ord01'-1) + `endoff' + `i'
local pos0 = `tparms'*(`ord1'-1) + `endoff' + `i'
mat `b2'[1,`pos1'] = `b'[1,`pos0']

				}
			}
		}
	}
	else {
		mat `b2' = `b'
	}
		

	forvalues i = 1/`mlag' {
		mat `aname'`i' = J(`neqs', `neqs', 0)
	}
	
/* b2 now has standard ordering so map b2 into A1, A2, ..., Amaxlag
 */

	local lagcnt 0
	foreach lag of local lags {
		local ++lagcnt
		forvalues i = 1/`neqs' {
			local eqoff = (`i'-1)*`tparms'
			forvalues j = 1/`neqs' {
				local pos = `lagcnt' + (`j'-1)*`nlags'	///
					+ `eqoff'
				mat `aname'`lag'[`i',`j'] = `b2'[1,`pos']
			}
		}
	}
	

	ret matrix b2 = `b2'
end
