*! version 1.0.2  11jun2019
program lassoinfo, rclass
	version 16.0

	syntax [anything(name=estlist)] 	///
		[, each				///
		nolstretch]

	local default .
						//  parse estimation list
	ParseEstlist , estlist(`estlist') default(`default')
	local namelist `s(namelist)'
						//  parse lstretch
	ParseLstretch , `lstretch'
	local is_stretch = `s(is_stretch)'
						//  parse each
	ParseEach, `each'
	local is_each = `s(is_each)'

						//  do table
	foreach name of local namelist {
 	  	mata : st_lasso_info(		///
 	  		`"`name'"',		///
 	  		`"`default'"',		///
 			`is_stretch',		///
 			`is_each')
		local crit `crit' `s(crit)'
		local width `s(width)'
	}
	
	ret local names `namelist'
	Footnote , crit(`crit') width(`width')
end

					//----------------------------//
					// parse stored estimation list
					//----------------------------//
program ParseEstlist, sclass
	syntax [, estlist(string)	///
		default(string)]

	if (`"`estlist'"' != "") {
		est_expand `"`estlist'"', default(`default')
		local names `r(names)'
	}
	else {
		local names `default'
	}

	foreach est of local names {
		CheckIfLasso `est', default(`default')
	}

	local names : list uniq names 

	sret local namelist `names'
end

					//----------------------------//
					// check if it is lasso
					//----------------------------//
program CheckIfLasso
	syntax [anything(name=est)] 	///
		[, default(string)]

	tempname e_current

	_est hold `e_current', copy restore nullok

	if (`"`est'"' != "" & `"`est'"' != "`default'") {
		qui est restore `est', nostxerfile	
	}
	
	if (`"`e(lasso)'"' == "") {
		di as err "{bf:lassoinfo} not allowed"
		exit 321
	}
end

					//----------------------------//
					// parse lstretch
					//----------------------------//
program ParseLstretch, sclass
	syntax [, nolstretch ]

	if (`"`lstretch'"' == "nolstretch") {
		local is_stretch = 0
		set lstretch off
	}
	else {
		local is_stretch = 1
	}

	if (`"`lstretch'"' == "") {
		if (inlist(c(lstretch), "on", "")) {
			local is_stretch = 1
		}
	}

	if (`"`lstretch'"' == "lstretch") {
		set lstretch on
	}

	sret local is_stretch = `is_stretch'
end
					//----------------------------//
					// parse each
					//----------------------------//
program ParseEach, sclass
	syntax [, each]

	if (`"`each'"' != "") {
		local is_each = 1
	}
	else {
		local is_each = 0
	}
	sret local is_each =`is_each'
end
					//----------------------------//
					// footnote
					//----------------------------//
program Footnote
	syntax [, crit(string) width(string)]
	
	if (`"`crit'"' == "") {
		exit
		// NotReached
	}

	if (strpos("`crit'"', "stop")) {
		di "{p 0 4 2 `width'}"		///
			"Selection criterion {bf:stop} indicates " 	///
			"a minimum for the cross-validation "		///
			"function was not identified. Selected "	///
			"lambda is lambda meeting stopping criterion. "	/// 
			"See {helpb lasso:{bind:[LASSO] lasso}}.{p_end}"
	}

	if (strpos("`crit'"', "grid min.")) {
		di "{p 0 4 2 `width'}"		///
			"Selection criterion {bf:grid min} indicates a " ///
			"minimum for the cross-validation function "	///
			"was not identified. Selected lambda is "	///
			"minimum lambda on grid. "			///
			"See {helpb lasso:{bind:[LASSO] lasso}}.{p_end}"
	}

	if (strpos("`crit'"', "not sel.")) {
		di "{p 0 4 2 `width'}"	///
			"Selection criterion {bf:not sel.} indicates "	///
			"a minimum for the cross-validation function "	///
			"was not identified. No lambda was selected. "	///
			"See {helpb lasso:{bind:[LASSO] lasso}}.{p_end}"
	}
end
