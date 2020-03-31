*! version 1.0.5  09feb2015
program _biplotmat_10, rclass sortpreserve
	version 9.0

	syntax anything(id=matrix name=m)		///
	[,						///
		DIM(numlist integer min=2 max=2 >=1) 	///
		ALPha(numlist max=1 >=0 <=1)		///
		MULTANDDIV(numlist max=1)		/// undocumented
		STretch(numlist max=1 >0)		///
		TABle 					///
		SEParate				///
		NEGCol					///
		noROW					///
		noCOlumn				///
		XNEGate YNEGate 			///
		AUTOaspect				///
		ASPECTratio(str)			///
		noGraph					///
		touse(varname)				///
		*					///
	]
	
	if "`separate'" != "" {
		local getcombine getcombine
		if "`row'" == "norow" || "`column'" == "nocolumn" {
			di as err ///
			  "separate may not be specified with norow or nocolumn"
			exit 198
		}
	}
	if "`row'"=="norow" && "`column'"=="nocolumn" {
		di as err "norow and nocolumn may not be specified together"
		exit 198
	}
	if "`column'"=="nocolumn" & "`negcol'"!="" {
		di as err "negcol and nocolumn may not be specified together"
		exit 198
	}

	_parse combop options : options, option(ROWopts) opsin
	_parse combop options : options, option(COLopts) opsin
	_parse combop options : options, option(NEGCOLopts) opsin
	_get_gropts , graphopts(`options') 			///
		getallowed(ROWopts COLopts NEGCOLopts) `getcombine'
		
	local goptions   `"`s(graphopts)'"'
	local negcoloptions `"`s(negcolopts)'"'
	local coloptions `"`s(colopts)'"'
	local rowoptions `"`s(rowopts)'"'
	local gcopts   `"`s(combineopts)'"'

	if "`aspectratio'" != "" & "`autoaspect'" != "" {
		display as error				///
	    "options aspectratio() and autoaspect may not be specified together"
		exit 198
	}

	_parse combop rowoptions : rowoptions, option(NAME) opsin rightmost
	_parse combop coloptions : coloptions, option(NAME) opsin rightmost
	_parse combop negcoloptions : negcoloptions, option(NAME) opsin rightmost

	local 0 , `coloptions'
	syntax , [ noLABel NAME(str) MLABPosition(passthru) 		///
		   MLABVPosition(passthru) MLabel(str) * ]
	local cname `name'
	local nolabel_cols `label'
	local coloptions `options' `mlabposition' `mlabvposition'
	
	if "`mlabel'" != "" {
		display as error "option mlabel() is not allowed with colopts()"
		exit 198
	}
	if "`mlabposition'" != "" | "`mlabvposition'" != "" {
		local colposition_flag "yes"
	}
	
	local 0 , `negcoloptions'
	syntax , [ noLABel NAME(str) MLABPosition(passthru) 		///
		   MLABVPosition(passthru) MLabel(str) * ]
	local ncname `name'
	local nolabel_negcols `label'
	local negcoloptions `options' `mlabposition' `mlabvposition'
	
	if "`mlabel'" != "" {
		display as error ///
			"option mlabel() is not allowed with negcolopts()"
		exit 198
	}
	if "`mlabposition'" != "" | "`mlabvposition'" != "" {
		local negcolposition_flag "yes"
	}

	local 0 , `rowoptions'
	syntax , [ noLABel NAME(str) MLABPosition(passthru) 		///
		   MLABVPosition(passthru) MLabel(str) * ]
	local rname `name'
	local nolabel_rows `label'
	local rowoptions `options' `mlabposition' `mlabvposition'

	if "`mlabel'" != "" {
		local rowoptions `rowoptions' mlabel(`mlabel')
		local rlabvar `mlabel'
	}
	if "`mlabposition'" != "" | "`mlabvposition'" != "" {
		local rowposition_flag "yes"
	}
	
	.atk = .aspect_axis_toolkit.new
	.atk.setPreferredLabelCount 7
	
	_parse comma aspect_ratio placement : aspectratio
	if "`aspect_ratio'" != "" {
		confirm number `aspect_ratio'
		.atk.setPreferredAspect `aspect_ratio'
		.atk.setShowAspectTrue
	}
	
	if "`autoaspect'" != "" {
		.atk.setAutoAspectTrue
	}	

// check input is valid

	confirm matrix `m'
	local nr = rowsof(`m')
	local nc = colsof(`m')
	if `nr'<2 | `nc'<2 {
		dis as err "biplot requires at least 2 rows and columns"
		exit 503
	}

	if "`multanddiv'" != "" {
		if `multanddiv' == 0 {
			di as error "multanddiv() may not be zero"
			exit 198
		}
	}

	if "`alpha'" == "" {
		local alpha = 0.5
	}

	if (`"`rname'"'  == "")  local rname   Rows
	if (`"`cname'"'  == "")  local cname   Columns
	if (`"`ncname'"'  == "")  local ncname   -Columns

// create biplot matrices

	tempname U V Vhold W rho rho1 rho2 w2
	if `nr' > `nc' {
		matrix svd `U' `W' `V' = `m'
	}
	else {
		tempname mt
		matrix `mt' = `m''
		matrix svd `V' `W' `U' = `mt'
		matrix drop `mt'
	}

	// sort the singular values
	
	local msg 1
	local nw = colsof(`W')
	tempname sW sIdx temp /* sorted W */
	mat `sIdx' = (1)
	forv i = 2/`nw' {
		mat `sIdx' = `sIdx', (`i')
	}
	mat `sW' = `W'
	forv i = 1/`=`nw'-1' { 
		local n`i' = 1
		forv j = `=`i'+1'/`nw' {
			if `sW'[1,`j'] == `sW'[1,`i'] {
				local n`i' = `n`i''+ 1
			}
			if `sW'[1,`j'] > `sW'[1,`i'] {
				scalar `temp' = el(`sW',1,`j')
				mat `sW'[1,`j'] = `sW'[1,`i']
				mat `sW'[1,`i']=`temp'
				scalar `temp' = `sIdx'[1,`j']
				mat `sIdx'[1,`j'] = `sIdx'[1,`i']
				mat `sIdx'[1,`i']=`temp'
			}
		}
		if `n`i''>1 & `msg' == 1 {
			di as err "singular values not unique"
			mat list `W', nonames
			local msg = `msg'+1
		}
	}


	// For each column of U (and associated column of V) it is arbitrary
	// if it is +1 or -1 times it (i.e. sign flip of the column).  To
	// minimize differences across different platforms / runs, we take the
	// first nonzero element (starting from the top of a column of U) and
	// make it positive.  We arbitrarily use a threshold of 1e-10 for
	// determining if something is zero or not for this exercise (the
	// threshold makes little difference).  It should be very rare for
	// sign flip differences to appear between platforms using this rule
	// (e.g. first element is very close to our arbitrary threshold and
	// lands either side of it on the 2 platforms).

		local i1 = `sIdx'[1,1]
		local i2 = `sIdx'[1,2]


	// check it for column i1
	forvalues i = 1 / `=rowsof(`U')' { // rare to loop over more than a few
		if abs(`U'[`i',`i1']) > 1e-10 {
			if `U'[`i',`i1'] < 0 {
				local flip1 "-1*"
			}
			continue, break
		}
	}

	// check it for column i2
	forvalues i = 1 / `=rowsof(`U')' { // rare to loop over more than a few
		if abs(`U'[`i',`i2']) > 1e-10 {
			if `U'[`i',`i2'] < 0 {
				local flip2 "-1*"
			}
			continue, break
		}
	}

	if "`dim'"=="" {
		local dim 2 1
	}
	local ii : word 2 of `dim'
	local jj : word 1 of `dim'
	local i1 = `sIdx'[1,`ii']
	local i2 = `sIdx'[1,`jj']

// select U2 and V2 with columns (i1,i2)

	matrix `U' = `flip1'`W'[1,`i1']^( `alpha' )*`U'[1...,`i1'] , ///
		     `flip2'`W'[1,`i2']^( `alpha' )*`U'[1...,`i2']

	matrix `V' = `flip1'`W'[1,`i1']^(1-`alpha')*`V'[1...,`i1'] , ///
		     `flip2'`W'[1,`i2']^(1-`alpha')*`V'[1...,`i2']
	
	
	matrix colnames `U' = dim`ii' dim`jj'
	matrix colnames `V' = dim`ii' dim`jj'


// Deal with xnegate, ynegate, stretch, and multanddiv

	if "`xnegate'" != "" {
		mat `U' = (-`U'[1...,1]) , (`U'[1...,2])
		mat `V' = (-`V'[1...,1]) , (`V'[1...,2])
	}

	if "`ynegate'" != "" {
		mat `U' = (`U'[1...,1]) , (-`U'[1...,2])
		mat `V' = (`V'[1...,1]) , (-`V'[1...,2])
	}

	if "`multanddiv'" != "" {
		// multiply U by value   and    divide V by value
		mat `U' = `U' * `multanddiv'
		mat `V' = `V' / `multanddiv'	// previously verified not 0
	}

	if "`stretch'" != "" {
		// multiply V by stretch
		mat `Vhold' = `V'	// ... but hold copy of V for later
		mat `V' = `V' * `stretch'
	}
	local Unames : rownames `U'
	local Vnames : rownames `V'

// explained variance by (i1,i2)

	scalar `w2' = 0
	forvalues i = 1 / `=colsof(`W')' {
		scalar `w2' = `w2' + `W'[1,`i']^2
	}
	scalar `rho1' = `W'[1,`i1']^2 / `w2'
	scalar `rho2' = `W'[1,`i2']^2 / `w2'
	scalar `rho'  = `rho1' + `rho2'

	
// override the rowlabel if specified
	if "`rlabvar'" != "" {
		capture confirm string var `rlabvar'
		if _rc == 0 {
			forvalues i = 1 / `c(N)' {
				if `touse'[`i'] {
					local rr = `rlabvar'[`i']
					local rr = subinstr("`rr'",".","",.)
					local rr = subinstr("`rr'"," ","_",.)
					local rownames `rownames' `rr'
				}
			}
			matrix rownames `U' = `rownames'
		}
	}


// turn biplot info into variables for plotting
//
// (Note: dim1/dim2 can be filled with faster code (generate) 
//  but I deem this code clearer)

if "`graph'" != "nograph" {

	local nrc = `nr'+`nc'
	if "`negcol'" != "" {
		local nrc = `nrc' + `nc'
	}
	if `nrc' > _N {
		preserve
		quietly set obs `nrc'
	}

	tempvar dim1 dim2 labvar obs touse2

	quietly gen `dim1' = .
	quietly gen `dim2' = .
	quietly gen `labvar' = ""
	if "`touse'" != "" {
		quietly gen `c(obs_t)' `obs' = _n
		quietly gen byte `touse2' = -`touse'
		sort `touse2' `obs'
	}

	forvalues i = 1 / `nr' {
		gettoken lab Unames : Unames

		quietly replace `dim1'   = `U'[`i',1] in `i'
		quietly replace `dim2'   = `U'[`i',2] in `i'
		quietly replace `labvar' = `"`lab'"'  in `i'
	}	

	forvalues j = 1 / `nc' {
		local jnr = `nr' + `j'
		gettoken lab Vnames : Vnames

		quietly replace `dim1'   = `V'[`j',1] in `jnr'
		quietly replace `dim2'   = `V'[`j',2] in `jnr'
		quietly replace `labvar' = `"`lab'"'  in `jnr'
	}
	if "`negcol'" != "" {
		local jnr = `nr' + `nc' 
		qui replace `dim1' = -`dim1'[_n- `nc'] in `=`jnr'+1'/`nrc'
		qui replace `dim2' = -`dim2'[_n- `nc'] in `=`jnr'+1'/`nrc'
		qui replace `labvar' = `labvar'[_n-`nc'] in `=`jnr'+1'/`nrc'
	}

// output and plot
			
	summarize `dim1', meanonly
	local dim1_max = `r(max)'
	local dim1_min = `r(min)'

	summarize `dim2', meanonly
	local dim2_max = `r(max)'
	local dim2_min = `r(min)'

	.atk.getAspectAdjustedScales , xmin(`dim1_min') 	///
		xmax(`dim1_max') ymin(`dim2_min') ymax(`dim2_max')
		
	local aspect aspectratio(`s(aspectratio)'`placement')
	local scales `s(scales)'		
	
	tempvar pos
	_plotpos `dim1' `dim2' , gen(`pos') arrows

	if "`nolabel_rows'" != "nolabel" {
		local rowoptions mlabel(`labvar') `rowoptions'
	}

	if "`nolabel_cols'" != "nolabel" {
		local coloptions mlabel(`labvar') `coloptions'
	}

	if "`nolabel_negcols'" != "nolabel" {
		local negcoloptions mlabel(`labvar') `negcoloptions'
	}
	
	tempvar origin
	generate `origin' = 0
	
	if "`colposition_flag'" == "" {
		local col_mlabvpos "mlabvpos(`pos')"
	}
	if "`negcolposition_flag'" == "" {
		local negcol_mlabvpos "mlabvpos(`pos')"
	}
	if "`rowposition_flag'" == "" {
		local row_mlabvpos "mlabvpos(`pos')"
	}

	local nrc `= `nr' + `nc''
	local nrc2 `= `nrc' + `nc''
	
	local legopt legend(label(1 `cname') label(2 `rname') span)
	if "`negcol'" != "" {
		if "`separate'" != "" {
			local legpcar legend(off)
		}
		local negplot pcarrow `origin' `origin' `dim2' 	///
			`dim1' in `=`nrc'+1'/`nrc2',		///
			`legpcar' pstyle(p1arrow) 		///
			lpattern(dash)	headlabel 		///
			`negcol_mlabvpos' `negcoloptions'	
		local legopt legend(label(1 `cname') label(2 `ncname') label(3 `rname') span)
	}

	if "`column'"=="nocolumn" {
		local colplot 
	}
	else {
	local colplot	pcarrow `origin' `origin' `dim2' `dim1' 	///
			in `=`nr'+1'/`nrc' ,				///
			headlabel `col_mlabvpos' `coloptions'	
	}

	if "`row'"=="norow" {
		local rowplot
	}
	else {
		local rowplot scatter `dim2' `dim1' in 1/`nr' ,		///
			`row_mlabvpos' pstyle(p1) `rowoptions'	
	}
	if "`separate'" == "" {
		// row and column categories are overlaid
		twoway	`colplot'					///
		    || 							///
		    	`negplot'					///
		    ||							///
		    	`rowplot'					///
		    || ,						///
		    	title("Biplot") `legopt'			///
			xtitle(Dimension `ii') ytitle(Dimension `jj')	///
			`scales' `aspect'				///
			`goptions' 
	}
	else {

		// row and column categories in separate plots	
		tempname rplot cplot
		local title

		scatter `dim2' `dim1' in 1/`nr',			///
			`rowoptions'					///
		    || ,						///
		    	`scales' `aspect'				///
			name(`rplot') nodraw				///
			xtitle(Dimension `ii') ytitle(Dimension `jj')	///
			title(`"`rname'"')  `goptions'
 
		twoway pcarrow `origin' `origin' `dim2' `dim1' 		///
			in `=`nr'+1'/`nrc' ,				///
			 mlabvpos(`pos') headlabel `coloptions'		///
		    	|| `negplot'  	|| ,				///
			name(`cplot') nodraw 				///
			`scales' `aspect' 				///
			xtitle(Dimension `ii') ytitle(Dimension `jj') 	///
			title(`"`cname'"') `goptions'

		graph combine `rplot' `cplot' , 			///
			title("Two panel biplot")			///
			`gcopts'
	}
	
} // end of if nograph
	
// header 

	display _n as txt `"Biplot of {res:`nr'} `=lower("`rname'")' and {res:`nc'} `=lower("`cname'")'"'
	display _n as txt  "    Explained variance by component `ii' " as res %7.4f `rho1'
	display    as txt  "    Explained variance by component `jj' " as res %7.4f `rho2'
	display    as txt  "             Total explained variance " as res %7.4f `rho'
	
// table output

	if "`table'" != "" { 
		local len1 = length("`rname'")
		local len2 = length("`cname'")
		local length = max(`len1', `len2', 12)
		
		display _n as txt "Biplot coordinates"
		
		matlist `U' , rowtitle(`rname') underscore 	/// 
			format(%8.4f) left(4) border(bot) twidth(`length') 
		   
		matlist `V' , rowtitle(`cname')			/// 
			format(%8.4f) left(4) border(bot) twidth(`length') 
		display
	}	

// save values


	return scalar rho   = `rho'
	return scalar rho`ii'  = `rho1'
	return scalar rho`jj'  = `rho2'

	return matrix U = `U'
	if "`stretch'" != "" {
		return matrix V = `Vhold'
		return matrix Vstretch = `V'
	}
	else {
		return matrix V = `V'
	}

	return scalar alpha = `alpha'

end

exit
