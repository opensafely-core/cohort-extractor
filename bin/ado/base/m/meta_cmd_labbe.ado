*! version 1.0.0  08may2019
program meta_cmd_labbe, rclass
	version 16
	
        syntax [if] [in], [					///
		random(string) 					///
		RANDOM1						///
		fixed(string)  					///
		FIXED1  					///
		common(string)  				///
		COMMON1  					///
		SQuare						/// Undoc
		REWEIGHTed					///
		NOMETASHOW					///
		METASHOW1					///
		*]
	
	
	cap confirm variable _meta_es _meta_se
	if _rc {
		meta__notset_err	
	}
	
	marksample touse
	
	if !missing("`metashow1'") & !missing("`nometashow'") {
		di as err ///
		"only one of {bf:metashow} or {bf:nometashow} is allowed"
		exit 198
	}
	
	local es   : char _dta[_meta_estype]
	local varlist : char _dta[_meta_datavars]
	if missing("`varlist'") | wordcount("`varlist'") == 2 {
		di as err "unable to construct L'Abbé plot for precomputed " ///
			"effect sizes"
		di as err "{p 4 4 2}Data variables specific to the control " ///
			   "and treatment groups not available. To " ///
			   "construct this plot, you must specify these " ///
			   "variables with {helpb meta esize}.{p_end}"
		exit 198	   	
	}
	
	_get_gropts, graphopts(`options') getallowed(RLopts ESopts addplot)
	local options		`"`s(graphopts)'"'
	local rlopts		`"`s(rlopts)'"'
	local esopts		`"`s(esopts)'"'
	local addplot		`"`s(addplot)'"'
	_check4gropts rlopts, opt(`rlopts')
	_check4gropts esopts, opt(`esopts')
	
	local cctype  : char _dta[_meta_zcadj]
	local cc      : char _dta[_meta_zcvalue]
	if missing("`cctype'") {
		local cctype "only0"
		local cc 0.5
	}
	local dtatype : char _dta[_meta_datatype]
	
	ParseModelAndMethod, random(`random') `random1' `fixed1' ///
		fixed(`fixed') `common1' common(`common')
	
	CheckMethod `method'
	local method = s(method)
	local estype = s(estype)
	local eslabel "Estimated {&theta}{sub:`estype'}"
		
	if "`dtatype'" != "binary" {
		di as err "{p}L'Abbé plot is currently supported for binary" ///
			" data only{p_end}"
		exit 198	
	}
	if "`model'"!="random" & !missing("`reweighted'") {
		di as txt "{p 0 6 2}" 					///
			  "note: option {bf:reweighted} ignored because " ///
			  "default model is common-effect; use "	///
			  "{bf:random} to specify RE model{p_end}"
		local reweighted 
	}
	
	local db double
	tempvar nonzeros a b c d ttot ctot x y 
	
	if "`cctype'" == "only0" | "tacc" == bsubstr("`cctype'", 1, 4) {
		qui egen `nonzeros' = anymatch(`varlist'), v(0)
		qui replace `nonzeros' = 1 - `nonzeros'
				// nonzeros is 0 if there is a 0 cell
	}
	else if "`cctype'" == "all" {
			qui gen byte `nonzeros' = 0 if `touse' 
				// equiv to all 2x2 tables having 0 cells 
	}
	else if "`cctype'" == "allif0" {
		qui egen `nonzeros' = anymatch(`varlist'), v(0)
		cap assert `nonzeros' == 0 // no 0-cell
		
		qui replace `nonzeros' = cond(_rc, 0,1) if `touse'
		
	}
	else if "`cctype'" == "none" {
		qui gen byte `nonzeros' = 1 if `touse'
		local cc 0
				// equiv 2 all 2x2 tbls having no 0 cells
	}								
	
	tokenize `varlist'
	if "tacc" == bsubstr("`cctype'", 1, 4) & "`es'" == "lnoratio" {
		tempvar a b c d kc kt nc nt		
		local h = cond("`cctype'"=="tacc",1,.01)
		qui gen `db' `nt' = `1' + `2'
		qui gen `db' `nc' = `3' + `4'
		qui gen `db' `kc' = `h'*`nc'/(`nc' + `nt')
		qui gen `db' `kt' = `h'*(1 - `kc')
		qui gen `db' `a' = cond(`nonzeros', `1', `1' + `kt')
		qui gen `db' `b' = cond(`nonzeros', `2', `2' + `kt')
		qui gen `db' `c' = cond(`nonzeros', `3', `3' + `kc')
		qui gen `db' `d' = cond(`nonzeros', `4', `4' + `kc')
	}
	else {
cap assert `nonzeros' > 0	// assertion is false if 0 cells exist

qui gen `db' `a' = cond(_rc, cond(`nonzeros', `1', `1' + `cc'), `1')
qui gen `db' `b' = cond(_rc, cond(`nonzeros', `2', `2' + `cc'), `2')
qui gen `db' `c' = cond(_rc, cond(`nonzeros', `3', `3' + `cc'), `3')
qui gen `db' `d' = cond(_rc, cond(`nonzeros', `4', `4' + `cc'), `4')
        }
	
	qui gen `db' `ttot' = `a' + `b'	// treat total
	qui gen `db' `ctot' = `c' + `d'	// control tot
	
	if "`es'" == "lnoratio" {
		qui gen `db' `y' = log(`a'/`b') if `touse'
		qui gen `db' `x' = log(`c'/`d') if `touse'
		local xttl "Log odds (control group)"
		local yttl "Log odds (treatment group)"
	}
	else if "`es'" == "lnrratio" {
		qui gen `db' `y' = log(`a'/`ttot') if `touse'
		qui gen `db' `x' = log(`c'/`ctot') if `touse'	
		local xttl "Log risks (control group)"
		local yttl "Log risks (treatment group)"
	}
	else if "`es'" == "rdiff" {
		qui gen `db' `y' = `a'/`ttot' if `touse'
		qui gen `db' `x' = `c'/`ctot' if `touse'
		local xttl "Risks (control group)"
		local yttl "Risks (treatment group)"
	}
	else {
		di as err "L'Abbé plot not supported with effect size" ///
			" {bf:`es'}"
		exit 198	
	}
	
	// used so it does not clear rclass commands
	tempname  yrange xrange max min  
	mata: st_matrix("`yrange'", minmax(st_data(.,"`y'","`touse'")))
	mata: st_matrix("`xrange'", minmax(st_data(.,"`x'","`touse'")))
	scalar `min' = min(`yrange'[1,1],`xrange'[1,1])
	scalar `max' = max(`yrange'[1,2],`xrange'[1,2])
		
	local ttl "L'Abbé plot"
	
	tempname info th tau2
	if "`method'" != "mhaenszel" {
		mata: st_matrix("`info'", _sma_iv("_meta_es", "_meta_se", ///
			"`method'" , "`touse'"))
	}
	else {
		mata: st_matrix("`info'", _sma_mh("_meta_es","`es'","`touse'"))
	}		
	scalar `th'   = `info'[1,1] // theta and tau2
	scalar `tau2' = `info'[1,5] 
	local xL = floor(`min')
	local xR = ceil(`max')

	if abs(`xL' - `xR') == 1 {
		local range range(`=`min'' `=`max'')
	}
	else {
		local range range(`xL' `xR')
		tempname step
		scalar `step' = (`xR' - `xL')/4
		local yla ylabel(none `xL'(`=`step'')`xR')
		local xla xlabel(none `xL'(`=`step'')`xR')
	}
	
	// if th < 0 , dash line will be to the right of y = x
	//	dashLine.min = y=xLine.min + abs(th)
	if `th' < 0 {
		local rmin = cond(abs(`xL' - `xR')==1, `min' + abs(`th'), ///
			 `xL' + abs(`th')) 
		local rmax = cond(abs(`xL' - `xR')==1, `max', `xR') 
	}
	else {
		local rmin = cond(abs(`xL' - `xR')==1, `min', `xL')
		local rmax = cond(abs(`xL' - `xR')==1, `max'-`th', `xR' - `th')
	}
	
	local rlplot				///
		(function y = x			///
			if `touse',		///
			`range'			///
			n(2)			///
			lstyle(refline)		///
			yvarlabel("No effect")	///
			`rlopts'		///
		)

	local eslplot					///
		(function y = x+`=`th''			///
			if `touse',			///
			range(`rmin' `rmax')		///
			lc(black) lp(dash)      	///
			yvarlabel("`eslabel'")		///
			`esopts'			///
		)
	
	tempname w
	if "`reweighted'" == "" {
		qui gen double `w' = 1/(_meta_se^2) if `touse'
		local wgttype "Inverse-variance"
	}
	else {
		qui gen double `w' = 1/(_meta_se^2 + `tau2') if `touse'
		local wgttype "Random-effects"
	}
	
	local note note("Weights: `wgttype' ")
	
	local issquare = cond(missing("`square'"), "", "aspectratio(1)")
	local plmargin plotregion(margin(zero))
	local labbeplot					///
		(scatter `y' `x' [aw=`w'] 		///
			if `touse',			///
			msize("scheme labbe")		///
			msymbol(Oh)			/// 
			xscale(`range') 		///
			yscale(`range')			///
			yvarlabel("Studies")		///
			`yla' `xla'			///
			title("`ttl'")			///
			xtitle(`xttl')			///
			ytitle(`yttl')			///
			`issquare' 			///
			`plmargin'			///
			`note'				///
			`options'			///	 
		)
	
	local mygraph		///
		`labbeplot'	///
		`rlplot'	///
		`eslplot'	///
		|| `addplot'	
	
	
	
	graph twoway `mygraph'
	
	local global_metashow : char _dta[_meta_show]
	if missing("`nometashow'`global_metashow'") | !missing("`metashow1'") {
			di
			local col = 2
			meta__esize_desc, col(`=`col'+1') data // showstudlbl	
			meta__model_desc, key(`method') meth(`model') ///
			col(`=`col'+13')
	}
	
	return scalar ymax = `yrange'[1,2]	
	return scalar ymin = `yrange'[1,1]
	return scalar xmax = `xrange'[1,2]
	return scalar xmin = `xrange'[1,1]	
	return scalar theta = `th'
			
	return local method "`method'"
	return local model "`model'"
	
end

program CheckMethod, sclass
	args method

	if "`method'" == "" {
		sreturn local method ivariance
		sreturn local estype IV
		exit
	}

	meta__validate_method_graph, meth(method) `method'
	local method `s(method)'

	if inlist("`method'", "ivariance", "invvariance") {
		local estype IV
	}	
	else if ("`method'" == "mhaenszel") {
		local dtyp : char _dta[_meta_datatype]
		if "`dtyp'" == "Generic" {
			di as err "option {bf:method} not valid"
			di as err "{p 4 4 2}The {bf:mhaenszel} " ///
			  "is not valid with generic effect sizes " ///
			  "declared by command {bf: meta set}.{p_end}"
			exit 198  
		}
		local estype MH
	}	
	else {
		local l = strlen("`method'")
		if `l' > 4 {
			local estype=ustrupper(bsubstr("`method'",1,2))
		}
		else local estype = ustrupper("`method'")
	}				
	sreturn local method `method'
	sreturn local estype `estype'
end

program ParseModelAndMethod

	syntax [, random(string) RANDOM1 common(string) COMMON1 ///
		fixed(string) FIXED1 ]
		
	local re = subinstr("`random'", " ", "_", .)
	local fe = subinstr("`fixed'", " ", "_", .)
	local co = subinstr("`common'", " ", "_", .)
	local mod `"`re' `fe' `fixed1' `co' `common1' `random1'"'
	if  (`:word count `mod'' > 1) {
		meta__model_err, mh	  
	}
	else if (`:word count `mod'' == 1) {
		// will create local -model- and -method-
		meta__model_method, random(`random') `random1' `fixed1' ///
		fixed(`fixed') `common1' common(`common')
	}
	else {
		local model common
		local method invvariance
	}
	
	c_local model `model'
	c_local method `method'

end

exit
