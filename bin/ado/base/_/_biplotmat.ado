*! version 1.3.0  01nov2017

program _biplotmat, rclass sortpreserve

	if _caller() < 11 {
		_biplotmat_10 `0'
		ret add
		exit
	}
	
	version 11.0
	syntax varlist					///
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
		touse1(varname)				///
		rowover(varlist)			///
		GENerate(namelist min=2 max=2)		///
		STD					///
		NOROWLABel				///
		ROWLABEL(varname)			///
		*					///
	]

	_nostrl error : `rowover' `rowlabel'
	
	local varlistMata `varlist'

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
	if (`"`row'"' == "norow" & `"`rowover'"' != "") {
		di as err "norow and rowover() may not be specified together"
		exit 198
	}
	if (`"`separate'"' != "" & `"`rowover'"' != "") {
		di as err "separate and rowover() may not be specified together"
		exit 198
	}
	_parse combop options : options, option(ROWopts) opsin
	_parse combop options : options, option(COLopts) opsin
	_parse combop options : options, option(NEGCOLopts) opsin

	tempvar id	// variable for labeling observations (default) 
	qui gen `c(obs_t)' `id' = _n
	if ("`touse1'"=="") {
		tempvar touse
		qui gen byte `touse' = 1
	}
	else {
		local touse `touse1'
	}

	//rowover
	if (`"`rowover'"' != "") {
		// handle numeric, string, and multiple variables in rowover()
		local allgroupvar `rowover'
		tempvar rowgroupvar	// grouping variable
		local countrowover : word count `allgroupvar'
		if (`countrowover' > 1) {
			qui egen `rowgroupvar' = group(`allgroupvar') ///
							if `touse', missing
			local rowover_is_varlist "yes"
		}
		else {
			capture confirm numeric  variable `rowover'
			if (!_rc) { 	//numeric
				qui gen `rowgroupvar' = `rowover' if `touse'
				local thislab : value label `rowover'
				label values `rowgroupvar' `thislab'
			}
			else { 		//string
				qui encode `rowover' if `touse' , ///
							gen(`rowgroupvar')
				local rowover_is_string "yes"
			}
		}
		// parse row#opts()
		qui levelsof `rowgroupvar' if `touse', local(rowgroup) missing    
		local groupnumber : word count `rowgroup'
		forvalues i = 1/`groupnumber' {
			_parse combop options : options, ///
					option(ROW`i'opts) opsin rightmost
		}
	}

	// parse graphic options
	_get_gropts , graphopts(`options') 			///
	       getallowed(ROWopts COLopts NEGCOLopts) `getcombine'

	local goptions   `"`s(graphopts)'"'
	local negcoloptions `"`s(negcolopts)'"'
	local coloptions `"`s(colopts)'"'
	local rowoptions `"`s(rowopts)'"'
	local gcopts   `"`s(combineopts)'"'

	//scheme options for separate graphs
	local 0, `gcopts'
	syntax , [SCHeme(passthru) *]
	local schemedef `scheme'

	if "`aspectratio'" != "" & "`autoaspect'" != "" {
		display as error				///
		    "aspectratio() and autoaspect may not be specified together"
		exit 198
	}
	if (`"`norowlabel'"' != "" & `"`rowlabel'"' != "" ) {
		di as err ///
		    "norowlabel and rowlabel() may not be specified together"
		exit 198
	}

	//prepare label variable for data and output matrices and tables
	tempvar labvar 
	qui gen `labvar' = ""
	
	//rowoptions
	if (`"`rowover'"' == "") {
		// set default or defined names of rows
		local default name("Observations")
		local rowoptions `default' `rowoptions'
		
		_parse combop rowoptions : rowoptions, ///
				 	   option(NAME) opsin rightmost

		local 0 , `rowoptions'
		syntax , [noLABel NAME(str) MLABPosition(passthru) 	///
		   MLABVPosition(passthru) MLabel(str) * ]
		// nolabel() is deprecated; -norowlabel- must be used instead
		if ("`label'" != "") {
			local norowlabel norowlabel
			local label
		}
		// mlabel() is deprecated; rowlabel() must be used instead
		if ("`mlabel'" != "" & "`rowlabel'"!="" ) {
			display as error ///
		    "mlabel() in rowopts() may not be combined with rowlabel()"
			exit 198
		}
		else if ("`mlabel'" != "") {
			local rowlabel `mlabel'
			local mlabel
		}
		qui GenerateLabelVar `"`labvar'"' `"`rowlabel'"' `"`id'"' ///
			`"`touse'"'
		local rname `"`name'"'
		local rowoptions `options' `mlabposition' `mlabvposition'
		if (`"`norowlabel'"' == "") {
			local rowoptions mlabel(`labvar') `rowoptions'
		}
		if "`mlabposition'" != "" | "`mlabvposition'" != "" {
			local rowposition_flag "yes"
		}
	}
	else {
		// set default or defined names of rows for every group
		//priority of labeling: name, value label, value
		qui GenerateLabelVar `"`labvar'"' `"`rowlabel'"' `"`id'"' ///
			`"`touse'"'
		local 0 , `goptions'
		local i = 1
		foreach singlegroup of local rowgroup {
			if ("`rowover_is_varlist'" != "") {
				qui GetGroupLabel `allgroupvar' ///
							if `rowgroupvar'==`i'
				local default name(`"`s(thisgrouplabel)'"')
				local labforlegend`i' `"`s(thisgrouplabel)'"'
			}
			else {
				qui GetSingleLabel `rowgroupvar' `rowover', ///
                                             singlegroup(`"`singlegroup'"') ///
                                             isstr(`"`rowover_is_string'"') ///
                                             i(`i') ///
                                             rowgroup(`"`rowgroup'"')
				local default name(`"`s(thisvarlabel)'"')
				local labforlegend`i' `"`s(thisvarlabel)'"'

			}	
			syntax [, ROW`i'opts(string) *]
			local goptions `options'
			local row`i'options `default' `rowoptions' `row`i'opts'

			_parse combop row`i'options : row`i'options, ///
						option(NAME) opsin rightmost

			local 0 , `row`i'options'
			syntax , [noLABel NAME(str) MLABPosition(passthru) ///
				   MLABVPosition(passthru) MLabel(str) * ]
			if (`"`mlabel'"' != "" ) {
				display as error ///
				    "mlabel() is not allowed with row`i'opts()"
				exit 198
			}
			local rname`i' `"`name'"'
			if `"`name'"' == "" {
				local rname`i' `"`labforlegend`i''"'
			}
			local rowoptions`i' `options' `mlabposition' ///
						      `mlabvposition'
			if (`"`norowlabel'"' == "" & `"`label'"' == "") {
				local rowoptions`i' `rowoptions`i''  mlabel(`labvar')
			}
			if "`mlabposition'" != "" | "`mlabvposition'" != "" {
                   	     local rowposition_flag`i' "yes"
	                }
			local ++i
			local 0 , `goptions'
		}
	}
	
	//column options	
	_parse combop coloptions : coloptions, option(NAME) opsin rightmost
	_parse combop negcoloptions : negcoloptions, option(NAME) opsin rightmost

	local 0 , `coloptions'
	syntax , [ noLABel NAME(str) MLABPosition(passthru) 		///
		   MLABVPosition(passthru) MLabel(str) * ]
	local cname `"`name'"'
	local nolabel_cols `label'
	local coloptions `options' `mlabposition' `mlabvposition'
	
	if "`mlabel'" != "" {
		display as error "mlabel() is not allowed with colopts()"
		exit 198
	}
	if "`mlabposition'" != "" | "`mlabvposition'" != "" {
		local colposition_flag "yes"
	}
	
	//neg column options
	local 0 , `negcoloptions'
	syntax , [ noLABel NAME(str) MLABPosition(passthru) 		///
		   MLABVPosition(passthru) MLabel(str) * ]
	local ncname `"`name'"'
	local nolabel_negcols `label'
	local negcoloptions `options' `mlabposition' `mlabvposition'
	
	if "`mlabel'" != "" {
		di as error "mlabel() is not allowed with negcolopts()"
		exit 198
	}
	if "`mlabposition'" != "" | "`mlabvposition'" != "" {
		local negcolposition_flag "yes"
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
	// validate input
	if "`multanddiv'" != "" {
		if `multanddiv' == 0 {
			di as error "multanddiv() may not be zero"
			exit 198
		}
	}

	if "`alpha'" == "" {
		local alpha = 0.5
	}
	
	// if name() id defines as "" default name must be set
	if (`"`rowover'"' == "") {
		if (`"`rname'"'  == "")  local rname   Observations
	}
	if (`"`cname'"'  == "")  local cname   Variables
	if (`"`ncname'"'  == "")  local ncname   -Variables

	//create variables containing observations coordinates
	if (`"`generate'"' != "") {
		tokenize `generate'
		local rowcoord1 `1'
		local rowcoord2 `2'

		confirm new variable `rowcoord1'
		confirm new variable `rowcoord2'
	}
	

// create biplot matrices
	// prepare data
	//store mean and sd for every variable
	local varlistlength : word count `varlistMata'
	local x = 1
	if ("`touse1'" != "") {
		local condition if `touse'
	}
	
	tempname st_meanVec st_sdVec
	qui foreach var of local varlistMata {
		summ `var' `condition'
		mat `st_meanVec' = (nullmat(`st_meanVec'), r(mean))
		mat `st_sdVec'   = (nullmat(`st_sdVec')  , r(sd))
	}

	//dimensions to use
	if "`dim'"=="" {
		local dim 2 1
	}
	local ii : word 2 of `dim'
	local jj : word 1 of `dim'
	
	//variables for observations
	tempvar dim1 dim2
	quietly gen `dim1' = .
	quietly gen `dim2' = .
	
	tempname V VnoStretch
	mata: _biplot_coord("`varlistMata'", "`touse'", "`dim1'", "`dim2'")
	
	//names for matrices
	matrix colnames `V' = dim`ii' dim`jj'
	if "`stretch'" != "" {
		matrix  rownames `VnoStretch' = `varlistMata' 
		matrix colnames `VnoStretch' = dim`ii' dim`jj'
	}
	matrix rownames  `V' = `varlistMata'
	local Vnames : rownames `V'
	local nr = _N

	local nc = rowsof(`V')

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

	tempvar obs touse2
	if "`touse1'" != "" {
		quietly gen `c(obs_t)' `obs' = _n
		quietly gen byte `touse2' = -`touse'
		sort `touse2' `obs'
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
	if "`nolabel_cols'" != "nolabel" {
		local coloptions mlabel(`labvar') `coloptions'
	}

	if "`nolabel_negcols'" != "nolabel" {
		local negcoloptions mlabel(`labvar') `negcoloptions'
	}
	tempvar origin
	qui generate byte `origin' = 0
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
	
	local legopt legend(label(1 `"`cname'"') label(2 `"`rname'"') span)
	if "`negcol'" != "" {
		if "`separate'" != "" {
			local legpcar legend(off)
		}
		local negplot pcarrow `origin' `origin' `dim2' 	///
			`dim1' in `=`nrc'+1'/`nrc2',		///
			`legpcar' pstyle(p1arrow) 		///
			lpattern(dash)	headlabel 		///
			`negcol_mlabvpos' `negcoloptions'	
		local legopt legend(label(1 `"`cname'"') label(2 `"`ncname'"') label(3 `"`rname'"') span)
	}
	if "`column'"=="nocolumn" {
		local colplot 
	}
	else {
		local colplot	pcarrow `origin' `origin' `dim2' `dim1' ///
				in `=`nr'+1'/`nrc' ,			///
				headlabel `col_mlabvpos' `coloptions'	
	}
	if "`row'"=="norow" {
		local rowplot
	}
	else if `"`rowover'"' == "" {
		local rowplot scatter `dim2' `dim1' in 1/`nr' if `touse', ///
			`row_mlabvpos' pstyle(p1) `rowoptions'	
	}
	else { // plot with rowover()
		forvalues i=1/`groupnumber' {
			if "`rowposition_flag`i''" == "" {
				local row_mlabvpos`i'  "mlabvpos(`pos')"
			}
			// labels for legend
			local legendvalue = `i' + 1
			if ("`column'" == "nocolumn") {
				local legendvalue = `i'
			}
			if (`"`negcol'"' != "") {
				local ++legendvalue
			}
			local rowlegendlabel `rowlegendlabel' ///
			     label(`legendvalue' `"`rname`i''"')
		}
		local legopt legend(label(1 `"`cname'"') `rowlegendlabel' span)
		if "`negcol'" != "" {
			local legopt legend(label(1 `"`cname'"') label(2 `"`ncname'"') ///
			    `rowlegendlabel' span)
		}
		tempvar rowgroupid
		qui egen long `rowgroupid' = group(`rowgroupvar'), missing
		forvalues i=1/`groupnumber' {
			local rowplot `rowplot' scatter `dim2' `dim1' 	  ///
					in 1/`nr'			  ///
				 	if `rowgroupid' == `i' & `touse', ///
					`row_mlabvpos`i'' `rowoptions`i'' 
			if (`i' < `groupnumber') {
				local rowplot `rowplot' ||
			}
		}
	} //end of plot with rowover

 	if "`separate'" == "" {
		// row and column categories are overlaid
		cap noi twoway  `colplot'				///
	            ||                                          	///
	                `negplot'                               	///
	            ||                                          	///
			`rowplot'					///
                    || ,                                        	///
	                title("Biplot") `legopt'               		///
    	                xtitle(Dimension `ii') ytitle(Dimension `jj')   ///
	                `scales' `aspect'                               ///
	                `goptions'
		/* resulting twoway legend legopt has too many labels */
		if _rc==1003 { 
			di as err "too many different groups identified " ///
				  "by variables specified in rowover()"
			exit 1003
		}
		else if _rc!=0 {
			exit _rc
		}	
		
	}
        else {
		// row and column categories in separate plots 
		// separate not allowed with rowover
		tempname rplot cplot
		local title

		scatter `dim2' `dim1' in 1/`nr' if `touse',		///
                        `rowoptions'					///
                    || ,						///
                        `scales' `aspect'                               ///
                        name(`rplot') nodraw                            ///
                        xtitle(Dimension `ii') ytitle(Dimension `jj')   ///
                        title(`"`rname'"')  `goptions' `legopt' 	///
			`schemedef'

                twoway pcarrow `origin' `origin' `dim2' `dim1'          ///
                        in `=`nr'+1'/`nrc' ,                            ///
                         mlabvpos(`pos') headlabel `coloptions'         ///
                        || `negplot'    || ,                            ///
                        name(`cplot') nodraw                            ///
                        `scales' `aspect'                               ///
                        xtitle(Dimension `ii') ytitle(Dimension `jj')   ///
                        title(`"`cname'"') `goptions'			///
			`schemedef'

                graph combine `rplot' `cplot' ,                         ///
                        title("Two panel biplot")                       ///
                        `gcopts'
        }
	restore 
} // end of if nograph
	// header 
	qui count if `touse'
	local nr = r(N)
	local cnamelow = lower(`"`cname'"')
	if (`"`rowover'"' == "") {
		local rnamelow = lower(`"`rname'"')
		display _n as txt ///
		   `"Biplot of {res:`nr'} `rnamelow' and {res:`nc'} `cnamelow'"'
	}
	else {
		local rname Observations
		display _n as txt ///
		 `"Biplot of {res:`nr'} observations and {res:`nc'} `cnamelow'"'
	}
	display _n as txt  "    Explained variance by component `ii' " as res %7.4f rho1
	display    as txt  "    Explained variance by component `jj' " as res %7.4f rho2
	display    as txt  "             Total explained variance " as res %7.4f rho

// table output
	tempvar rownamesmat
	qui gen `rownamesmat' = `labvar'
	cap confirm string variable `rowlabel'
	if _rc {
		qui replace `rownamesmat' = string(_n)
	}
	else {
		qui replace `rownamesmat' = string(_n) if `labvar' == ""
 		qui replace `rownamesmat' = subinstr(`rownamesmat',".","",.)
	 	qui replace `rownamesmat' = subinstr(`rownamesmat'," ","_",.)
	}
	if ("`table'" != "") { 
		local len1 = length(`"`rname'"')
		local len2 = length(`"`cname'"')
		local length = max(`len1', `len2', 12)
		local tabopts rowtitle(`"`rname'"') underscore format(%8.4f) left(4) twidth(`length')
		display _n as txt "Biplot coordinates"
	}
	if (c(N)< c(max_matdim)) {
			// if data smaller than max matdim then save r(U)
		tempname U
		mkmat `dim1' `dim2' if `touse', matrix(`U') ///
						rownames(`rownamesmat')
		matrix colnames `U' = dim`ii' dim`jj'
		if ("`table'" != ""){ 
			matlist `U', `tabopts' border(bot)  	
		}
		return matrix U = `U'
	}
	else {
	    // table for large matrices are built using small partial matrices
		if ("`table'" != "") { 
			local matslice = c(max_matdim)
			qui count if `touse'
			local touseNumber = r(N)
			// minimal number of small matrices
			local slicesNumber = ceil(`touseNumber'/`matslice')
			tempname sliceMat
			tempvar currentSliceMarker touseCounter
			qui gen byte `currentSliceMarker' = 0
			qui gen `touseCounter' = sum(`touse') if `touse'
			local rangeCounter = 0
			forvalues i =1/`slicesNumber' {
				local lower = `rangeCounter++' * `matslice' + 1
				local upper = `rangeCounter' * `matslice'
				qui replace `currentSliceMarker' = 1 if ///
				     inrange(`touseCounter', `lower', `upper')  
 				qui mkmat `dim1' `dim2' 	 ///
				     if `currentSliceMarker', ///
				     matrix(`sliceMat') rownames(`rownamesmat')
				matrix rownames  `sliceMat' = `labSlice'
				matrix colnames `sliceMat' = dim`ii' dim`jj'
				if (`i'==`slicesNumber') {
					local border border(bot)
				}
				matlist `sliceMat', `rows' `blank' ///
						    `tabopts' `border' 
				local rows names(rows)
				local blank noblan
				qui replace `currentSliceMarker' = 0
			}
		}
	}
	
	if ("`table'" != "") {
		matlist `V' , rowtitle(`"`cname'"')			/// 
			format(%8.4f) left(4) border(bot) twidth(`length') 
		display
	}	

// save return values
	return scalar rho   = rho
	return scalar rho`ii'  = rho1
	return scalar rho`jj'  = rho2

	if "`stretch'" != "" {
		return matrix V = `VnoStretch'
		return matrix Vstretch = `V'
	}
	else {
		return matrix V = `V'
	}
	return scalar alpha = `alpha'

// coordinates variable
	if (`"`generate'"' != "") {
		rename `dim1' `rowcoord1'
		rename `dim2' `rowcoord2'
		label variable `rowcoord1' "Observations dim `ii'"
		label variable `rowcoord2' "Observations dim `jj'"
	}
end

// build labels for all values of group variable
// Priority: value label, value
program define GetGroupLabel, sclass
	version 11.0
	syntax varlist [if]

	tempvar	index
	qui gen `index'=_n
	qui sum `index'  `if', mean
	local n = r(min)
	foreach var of local varlist {
		cap confirm numeric var `var'
		if (_rc) { //string variable: string or ""
			local ll = usubstr(`var'[`n'],1,20)
			if `"`ll'"' == "" {
				local ll `""""'
			}
		}
		else { 
		//numeric variable: varname = value label, value or .
			local varvalue = `var'[`n']
			if (`varvalue' < .) {
				qui sum `var' `if', mean
				local thisvarvalue = r(min)
				local thisvaluelabel : value label `var'
		 		if (`"`thisvaluelabel'"' == "" ) {
					local ll `"`var' = `=string(round(r(min),0.01))'"'
				}
				else { //extract value label name
					local ll : label `thisvaluelabel' `thisvarvalue'
					local ll `"`var' = `ll'"'
				}
			}
			else {
				local ll `"`var' = `varvalue'"'
			}
		}
		local lab `"`lab'`sep'`ll'"'
		local sep `"/"'
        }
	sreturn local thisgrouplabel `"`lab'"'
end

// build labels for values of single rowover variable
program define GetSingleLabel, sclass
	version 11.0
	syntax varlist(min=2 max=2) ///
		[ , singlegroup(string) isstr(string) ///
		i(integer 0) rowgroup(string)]

	tokenize `varlist'	
	local rowgroupvar `1'
	local rowover `2'
	local rowover_is_string `isstr'
	local rowvarlab : value label `rowgroupvar'
	if (`"`rowvarlab'"' != "") {
		local rowvaluelab: label `rowvarlab' `singlegroup'
	}	
	if (`"`rowvaluelab'"' == "") {
		local varvalue : word `i' of `rowgroup'
		local rname `"`rowover' = `=string(round(`varvalue',0.01))'"'
		if (`"`rowover_is_string'"' != "") {
			local rname `""""'			
		}
	}
	else {
		if (`"`rowover_is_string'"' != "") { //string
			local rname  `"`rowvaluelab'"'
			if (`"`rowvaluelab'"' == ".") {
				local rname `""""'	
			}
		}
		else { //numeric
			local rname `"`rowover' = `rowvaluelab'"'
		}
	}
	sreturn local thisvarlabel `"`rname'"'
end

// generate label variable for observations
// default: current number
// Priority: value label, value
program define GenerateLabelVar
	version 11.0
	args labvar mlabel id touse
	if "`mlabel'" != "" {
		capture confirm string variable `mlabel'
		if (_rc) { //numeric
			local labvarlab : value label `mlabel'
			qui replace `labvar' = string(`mlabel',"%9.2f") ///
								if `touse'
			if (`"`labvarlab'"' != "") {
				tempvar strlabvar
				qui decode `mlabel', gen(`strlabvar')
				qui replace `labvar' = `strlabvar' 	///
						if `touse' & `strlabvar' != ""
			}
		}
		else { //string
			qui replace `labvar' = `mlabel' if `touse'
		}
	}
	else {
		qui replace `labvar' = string(`id') if `touse'
	}
end

// --------------------------MATA-------------------------------------------
version 11.0

mata:

void _biplot_coord( string scalar varlist, string scalar touse, 
		    string scalar dim1, string scalar dim2 )
{

	real matrix 		allDatM, dataM, A, U, s, V, VNoStretchM
	real rowvector		flipV
	real scalar		alphaS, alphaMinS, colNumberS, rowNumberS,
				dimension1S, dimension2S,
				multanddivS, stretchS
	string scalar		stdS, xnegateS, ynegateS 

	//Obtain data from Stata
	allDatM = A = U = s = V = .
	st_view(allDatM, ., tokens(varlist), touse)
	// extract biplot variables
	dataM = allDatM[.,(1..cols(allDatM))]
	// options
	dimension1S = strtoreal(st_local("ii"))
	dimension2S = strtoreal(st_local("jj"))
	stdS = st_local("std")	
	alphaS = strtoreal(st_local("alpha"))
	alphaMinS = 1 - alphaS
	xnegateS = st_local("xnegate")
	ynegateS = st_local("ynegate")
	multanddivS = strtoreal(st_local("multanddiv"))
	stretchS = strtoreal(st_local("stretch"))

	colNumberS = cols(dataM)
	rowNumberS = rows(dataM)
	// prepare data for SVD	
	dataM = prepareData(dataM, stdS)	
	//SVD
	svd(dataM, A, s, V)
	areSingValuesUnique(s)
	if (colNumberS > rowNumberS) {	
		U = V'
		s = s'
		V = A
	}
	else {
		U = A
		s = s' 
		V = V'
	}
	// flip 1 or -1 to minimize ambiguity of SVD results
	flipV = computeFlip(U, dimension1S, dimension2S)
	// rescale data
	U = computeCoord(U, s, dimension1S, dimension2S, alphaS, flipV)
	V = computeCoord(V, s, dimension1S, dimension2S, alphaMinS, flipV)
	if (xnegateS != "" || ynegateS != ""  ) {
		U = rescaleCoord(U, xnegateS, ynegateS)	
		V = rescaleCoord(V, xnegateS, ynegateS)	
	}
	if (multanddivS != .) {
		U = U * multanddivS
		if (abs(multanddivS) > 0) {
			V = V / multanddivS
		}
	}
	if (stretchS != .) {
	   	VNoStretchM = V
		V = V * stretchS
	}
	//explained variance
	computeExplainedVariance(s, dimension1S, dimension2S)

	//results to Stata
	st_matrix(st_local("V"), V)
	if (stretchS != .) {
		st_matrix(st_local("VnoStretch"), VNoStretchM)
	}
	st_store(., dim1, touse, U[.,1])
	st_store(., dim2, touse, U[.,2])
}

//center or standardize data matrix
real matrix prepareData(real matrix dataM, string scalar std)
{
	real rowvector 		meanV, stdV
	real matrix		newdatM

	meanV = st_matrix(st_local("st_meanVec"))	
	newdatM = dataM:-meanV
	if (std != "") {
		stdV = st_matrix(st_local("st_sdVec"))
		newdatM = newdatM:/stdV
	}
	if (cols(newdatM) > rows(newdatM)) {
		newdatM = newdatM'
	}
	return(newdatM)
}

//check the uniqueness of singular values
void areSingValuesUnique(real colvector singularV)
{
	real scalar i

	// assertion: singular values are sorted
	for(i=1; i<rows(singularV); i++) {
		if (singularV[i]==singularV[i+1]) {
			printf("Note: Singular values not unique.\n")
			break
		}
	}
}	

//compute coordinates for the biplot
real matrix computeCoord( real matrix M, real rowvector singV,
			  real scalar dimension1, real scalar dimension2,
			  real scalar alph, real rowvector flip )
{

	real matrix 		colM, coordM
	real rowvector 		colSingV

	colM = M[., (dimension1, dimension2)]
	if (alph == 0) {
		colSingV = (1,1)
	}
	else {
		colSingV = singV[., (dimension1, dimension2)]
		colSingV = colSingV :^ alph
	}
	coordM = colM :* flip
	coordM = coordM :* colSingV
	return(coordM)
}

 // For each column of U (and associated column of V) it is arbitrary
        // if it is +1 or -1 times it (i.e. sign flip of the column).  To
        // minimize differences across different platforms / runs, we take the
        // first nonzero element (starting from the top of a column of U) and
        // make it positive.  We arbitrarily use a threshold of 1e-10 for
        // determining if something is zero or not for this exercise 
	//  It should be very rare for
        // sign flip differences to appear between platforms using this rule
        // (e.g. first element is very close to our arbitrary threshold and
        // lands either side of it on the 2 platforms).
real rowvector computeFlip( real matrix M, 
			    real scalar dimension1,
			    real scalar dimension2 ) 
{
	real scalar 	i, flip1, flip2, element
	real rowvector	result

	flip1 = 1 
	flip2 = 1
	// two loop due to different number of iterations (break)
	for (i=1; i<=rows(M); i++) {
		element = M[i,dimension1]
		if (abs(element) > 1e-10) { //nonzero element
			if (element < 0) { //negative
				flip1 = -1
			}
			break
		}
	}
	for (i=1; i<=rows(M); i++) {
		element = M[i,dimension2]
		if (abs(element) > 1e-10) { //nonzero element
			if (element < 0) { //negative
				flip2 = -1
			}
			break
		}
	}
	result = (flip1, flip2)
	return(result)	
}

real matrix rescaleCoord(real matrix M, string scalar xneg, string scalar yneg)
{
	real matrix 		coordM
	real rowvector		neg
	
	coordM = M
	if (xneg != "") {
		neg = (-1,1)
		coordM = coordM :* neg
	}
	if (yneg != "") {
		neg = (1,-1)
		coordM = coordM :* neg
	}
	return(coordM)
}

// computes the Variance explained by the components
void computeExplainedVariance( real rowvector rowS,
			       real scalar dimension1, 
			       real scalar dimension2 )
{
	
	real scalar 	rhoS1, rhoS2, sumRhoS
	real rowvector	rowVariance

	rowVariance = rowS :^ 2
	sumRhoS = sum(rowVariance)
	rhoS1 = rowVariance[dimension1]/sumRhoS
	rhoS2 = rowVariance[dimension2]/sumRhoS
	
	st_numscalar("rho1", rhoS1)
	st_numscalar("rho2", rhoS2)
	st_numscalar("rho", rhoS1 + rhoS2)
}
end
exit

