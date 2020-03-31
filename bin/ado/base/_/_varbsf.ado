*! version 1.7.3  01apr2005
program define _varbsf
	version 8.0
	syntax using/ , 				/*
		*/ Step(integer) 			/*
		*/ LASTob(integer) 			/*
		*/ [REPS(integer 200) 			/*
		*/ prefix(name)				/*
		*/ BSP 					/*
		*/ REPLACE 				/*
		*/ fsamp(varname)			/*
		*/ QUIetly				/*
		*/ noDOts 				]
		
/* if prefix() not specified, called by old _varfcast_compute so use
 *  old naming convention; otherwise called by fcast work routine so use 
 *  new naming convention.
*/    
	local s "`step'"

	if "`quietly'" == "" {
		local fnoi noi
	}
	else {
		local fnoi qui
	}	
	tempname b base crep cstep
	
	if "`e(cmd)'" != "var" & "`e(cmd)'" != "svar" {
		di as err "di as err "_varbsf only works with "	/*	
	*/ "estimates from {help var##|_new:var} and " /*
			*/ "{help svar##|_new:svar}"
		exit 498
	}	


	if "`e(cmd)'" == "svar" {
		local svar _var
	}

	local neqs = e(neqs`svar')
	local vlist "`e(endog`svar')'"
	local eqlist "`e(eqnames`svar')'"

	local fcast "rep step "
	local fcastp " (`crep') (`cstep') "
	local j 1
	foreach v of local eqlist {
		tempname scalar`j'
		if "`prefix'" != "" {
			local fcast "`fcast' `prefix'`v' "
		}
		else {
			local fcast "`fcast' `v'_f "
		}

		local fcastp "`fcastp' (`scalar`j'') "
		local j = `j' +1
	}
	
	tempname results
	`fnoi' postfile `results' `fcast' using "`using'" , double `replace'


/* make endog_ts and b_ts that are safe with ts op on rhs */
	tempname b_ts
	mat `b_ts' = e(b`svar')
	local i 1

	foreach v of local vlist {
		local vt : subinstr local v "." "_"
		tempvar tv`i'
		qui gen double `tv`i'' = `v' 
		op_colnm `b_ts' `v' `tv`i''
		local endog_ts "`endog_ts' `tv`i'' "
		local i = `i' + 1
	}

	forvalues cnt=1(1)`reps' {
		scalar `crep' = `cnt'
		preserve
		if "`dots'" == "" {
			di as txt " ." _c
		}	

		if `cnt' == `reps' {
			di as txt  ""
		}	

		_varsim `endog_ts' , neqs(`neqs') b(`b_ts') `bsp' /*
			*/ fsamp(`fsamp') eqlist(`eqlist')	

						/* program to generate
						   simulated var data */
		forvalues i = 1(1)`s' {
			scalar `cstep' = `i'
			local j 1
			foreach v of local endog_ts {
				local cur_ob=`lastob' + `i'
				scalar `scalar`j''=`v'[`cur_ob']
				local j = `j' + 1
			}	
			post `results' `fcastp'
		}

		restore
	}	
	postclose `results'
end
