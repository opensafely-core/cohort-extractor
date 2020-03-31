*! version 1.0.2  21oct2019
program cmclogit, eclass byable(onecall) prop(cm)
	version 16

	if (_by()) {
		local BY `"by `_byvars'`_byyrc0':"'
	}

	if (replay()) {
		if (`"`BY'"' != "") {
			error 190
		}

		if ("`e(cmd)'" != "cmclogit") {
			error 301
		}

		asclogit `0'
		exit
	}

	local cmdline : copy local 0

	syntax varlist(numeric fv min=1) [fw pw iw] [if] [in] [, ///
		CASE(passthru)					 ///
		ALTernatives(passthru)				 ///
		VCE(passthru)					 ///
		TEMPCASEID(varname numeric)			 ///
		* ]
		
	// tempcaseid() is an undocumented option for use by bootstrap
	// and jackknife to pass a temporary caseid variable.

	if (`"`case'`alternatives'"' != "") {

		if (`"`case'"' != "") {
			di as error "option {bf:case()} not allowed"
		}

		if (`"`alternatives'"' != "") {
			di as error "option {bf:alternatives()} not allowed"
		}

		cap cmset
		if (c(rc) == 459) {

di as error "{p 4 4 2}Data must be {bf:cmset}. " ///
	    "Use {bf:cmset} {it:caseidvar} {it:altvar}{p_end}"

		}

		exit 198
	}

	_cm, altrequired

	if ("`tempcaseid'" != "") {
		local caseid `tempcaseid'
	}
	else {
		local caseid `r(caseid)'
	}

	local altvar       `r(altvar)'
	local origpanelvar `r(origpanelvar)'  // only if panel data

	// When `origpanelvar' exists, vce() may be altered.
	
	local prefix `c(prefix)'
	
	local isboot : list posof "bootstrap" in prefix 
	local isjack : list posof "jackknife" in prefix

	if ("`origpanelvar'" != "" & !`isboot' & !`isjack') {
	     
		_cm_vcepanel `origpanelvar', cmd(cmclogit) `vce' ///
			allowed("oim robust cluster bootstrap jackknife")
		local vce `"`s(vce)'"'
	}
	
	// oneonly = allow only one positive value of depvar per case.

	`BY' asclogit `varlist' [`weight'`exp'] `if' `in', ///
		case(`caseid')                    	   ///
		alternatives(`altvar')            	   ///
		`vce'				   	   ///
		cm					   ///
		oneonly					   /// 
		`options'

	tempname table level

	scalar `level' = r(level)
	mat `table' = r(table)

	ereturn hidden local marginsj1 default Pr
	ereturn hidden local marginsj2 default Pr
	ereturn hidden local casevars  `e(casevars)'
	ereturn hidden local altspvars `e(indvars)'
	ereturn hidden local indvars   `e(indvars)'
	
	_ms_varnames `e(casevars)'
	ereturn hidden local casevars_cat  `s(fvars)'
	ereturn hidden local casevars_cont `s(cvars)'

	_ms_varnames `e(altspvars)'
	ereturn hidden local altspvars_cat  `s(fvars)'
	ereturn hidden local altspvars_cont `s(cvars)'
		
	ereturn hidden local case   `caseid'  // asclogit's name
	ereturn        local caseid `caseid'  // cmset's name	
	
	local cmdline : list retokenize cmdline
	ereturn local cmdline `"cmclogit `cmdline'"'	

	RepostTable, table(`table') level(`level')
end

program define RepostTable, rclass
	syntax, table(name) level(name)

	return scalar level = `level'
	return matrix table = `table'
end

exit
