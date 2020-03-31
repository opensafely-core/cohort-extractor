*! version 1.1.0  13feb2015
program cabiplot, sortpreserve
	version 9.0

	if "`e(cmd)'" != "ca" {
		error 301
	}
	local md = `e(f)'

	#del ;
	syntax [,
		noROW noCOlumn
		DIM(numlist integer min=2 max=2 >=1 <=`md')
		FActors(numlist integer min=2 max=2 >=1 <=`md') // undocumented
		XNEGate YNEGate
		MAXlength(numlist integer max=1 >0 <32)
		ROWopts(string)
		COLopts(string)
		ASPECTratio(str)
		ORigin
		ORiginlopts(str)
		*
	] ;
	#del cr

	local gopt `options'

	if "`originlopts'" != "" {
		local origin origin
	}
	if `"`origin'"' != "" {
		local 0, `originlopts'
		syntax, [LColor(str) LWidth(str) * ]

		if ("`lcolor'" == "" ) local lcolor black
		if ("`lwidth'" == "" ) local lwidth vthin
		local otxt lcolor(`lcolor') lwidth(`lwidth') `options'
		local origin xline(0, `otxt') yline(0,`otxt')
	}

	if ("`row'" == "norow" & "`column'" == "nocolumn") {
		display as error	///
			"options norow and nocolumn may not be combined"
		exit 198
	}

	if "`dim'" != "" & "`factors'" != "" {
		dis as err "dim() and factors() are synonyms"
		exit 198
	}
	else if "`factors'" != "" {
		local axes `factors'
	}
	else if "`dim'" != "" {
		local axes `dim'
	}

	if "`axes'" != "" {
		local ax1 : word 2 of `axes'
		local ax2 : word 1 of `axes'
	}
	else {
		local ax1 = 1
		local ax2 = 2
	}

	if "`maxlength'" == "" {
		local maxlength = 12
	}

	// Parse out row-suppopts
	local 0 , `rowopts'
	syntax , [SUPpopts(string) MLABel(varname) *]
	local rowopts `options'
	local rsupp_opt `suppopts'
	local rmlabel `mlabel'

	// Parse out column-suppopts
	local 0 , `colopts'
	syntax , [SUPpopts(string) MLABel(varname) *]
	local colopts `options'
	local csupp_opt `suppopts'
	local cmlabel `mlabel'

	.atk = .aspect_axis_toolkit.new
	.atk.setPreferredLabelCount 6

	_parse comma aspect_ratio placement : aspectratio
	if "`aspect_ratio'" != "" {
		confirm number `aspect_ratio'
		.atk.setPreferredAspect `aspect_ratio'
		.atk.setShowAspectTrue
	}
	else {
		.atk.setAutoAspectTrue
	}

// parsing is done

	tempname R C
	local rn        `e(Rname)'
	local cn        `e(Cname)'
	
	matrix `R' = e(TR)
	matrix `C' = e(TC)
	
	local nr  = rowsof(`R')
	local nc  = rowsof(`C')
	
	// e(sample) is only available after -ca- and NOT -camat-
	local e_function : e(functions)
	local e_function : subinstr local e_function "sample" "sample" , ///
		word count(local cnt)
		
	if ("`rmlabel'"!="" | "`cmlabel'"!="") & ("`e(ca_data)'"=="crossed") {
		dis as txt "with crossed variable, option {opt mlabel()} ignored"
		local rmlabel
		local cmlabel
	}	

	if "`rmlabel'" != "" | "`cmlabel'" != "" {
		if `cnt' == 0 {
			display as smcl ///
				"{cmd:e(sample)} not defined; "		///
				"option {opt mlabel()} ignored"
			local rmlabel
			local cmlabel
		}
	}
		
	if `cnt' == 0 {
		local donotsort true
	}
	if "`donotsort'" == "" {
		capture confirm variable `rn'
		if _rc local donotsort true
		capture confirm variable `cn'
		if _rc local donotsort true
	}
	if "`donotsort'" == "" {
		tempvar touse obs touse2
		quietly generate byte `touse' = -e(sample)
		quietly generate byte `touse2' = .
		quietly generate `c(obs_t)' `obs' = _n
	}
	if "`donotsort'" == "" {
		// The data used in the plot is basically a twoway tabulation 
		//	and therefore we need to verify that marker labels are
		//	consistent within each group (`rn' and `cn').
		if "`rmlabel'" != "" {
			_ca_process_mlabel rmlabel : `rn' `rmlabel' `touse' row
			local rowopts `"`rowopts' `rmlabel'"'
		}
		if "`cmlabel'" != "" {
			_ca_process_mlabel cmlabel : `cn' `cmlabel' `touse' column
			local colopts `"`colopts' `cmlabel'"'
		}		
	}
	
	if colsof(`R') < 2 | colsof(`C') < 2 {
		dis as txt "(no plot with dimension < 2)"
		exit
	}

	local Rnames : rownames `R'
	local Cnames : rownames `C'

	if "`e(PR_supp)'" == "matrix" {
		tempname SR
		matrix `SR' = e(TR_supp)
		local nr_supp = rowsof(`SR')
		local SRnames : rownames `SR'
	}
	else {
		local nr_supp = 0
	}

	if "`e(PC_supp)'" == "matrix" {
		tempname SC
		matrix `SC' = e(TC_supp)
		local nc_supp = rowsof(`SC')
		local SCnames : rownames `SC'
	}
	else {
		local nc_supp = 0
	}

	local nrc = `nr' + `nr_supp' + `nc' + `nc_supp'
	if `nrc' > c(N) {
		preserve
		quietly set obs `nrc'
	}

// we store all coordinates and names in variables,
// even if we plot only rows or columns

	tempvar rdim1 rdim2 rsup1 rsup2 cdim1 cdim2 csup1 csup2 
	tempvar rnames rsup_names cnames csup_names

	quietly gen `rdim1' = .
	quietly gen `rdim2' = .
	quietly gen `rsup1' = .
	quietly gen `rsup2' = .
	quietly gen `cdim1' = .
	quietly gen `cdim2' = .
	quietly gen `csup1' = .
	quietly gen `csup2' = .
	quietly gen str32 `rnames' = ""
	quietly gen str32 `cnames' = ""
	if `nr_supp' > 0 {
		quietly gen str32 `rsup_names' = ""
	}
	if `nc_supp' > 0 {
		quietly gen str32 `csup_names' = ""
	}

	if "`donotsort'" == "" {
		sort `touse' `rn' `obs'
		quietly by `touse' `rn' : 	///
			replace `touse2' = 1 if _n == 1 & `touse'
		sort `touse' `touse2' `rn' `obs'
	}
	forvalues i = 1/`nr' {
		quietly replace `rdim1' = `R'[`i',`ax1']  in `i'
		quietly replace `rdim2' = `R'[`i',`ax2']  in `i'
		gettoken name Rnames : Rnames
		quietly replace `rnames' = `"`name'"'     in `i'
	}

	forvalues i = 1/`nr_supp' {
		quietly replace `rsup1' = `SR'[`i',`ax1']  in `i'
		quietly replace `rsup2' = `SR'[`i',`ax2']  in `i'
		gettoken name SRnames : SRnames
		quietly replace `rsup_names' = `"`name'"'  in `i'
	}

	if "`donotsort'" == "" {
		sort `touse' `cn' `obs'
		quietly replace `touse2' = .
		quietly by `touse' `cn' : 	///
			replace `touse2' = 1 if _n == 1 & `touse'
		sort `touse' `touse2' `cn' `obs'
	}
	forvalues i = 1/`nc' {
		quietly replace `cdim1' = `C'[`i',`ax1'] in `i'
		quietly replace `cdim2' = `C'[`i',`ax2'] in `i'
		gettoken name Cnames : Cnames
		quietly replace `cnames' = `"`name'"' in `i'
	}

	forvalues i = 1/`nc_supp' {
		quietly replace `csup1' = `SC'[`i',`ax1'] in `i'
		quietly replace `csup2' = `SC'[`i',`ax2'] in `i'
		gettoken name SCnames : SCnames
		quietly replace `csup_names' = `"`name'"' in `i'
	}

	if "`xnegate'" != "" {
		quietly replace `rdim1' = -`rdim1'
		quietly replace `cdim1' = -`cdim1'
		if `nr_supp' > 0 {
			quietly replace `rsup1' = -`rsup1'
		}
		if `nc_supp' > 0 {
			quietly replace `csup1' = -`csup1'
		}
	}
	if "`ynegate'" != "" {
		quietly replace `rdim2' = -`rdim2'
		quietly replace `cdim2' = -`cdim2'
		if `nr_supp' > 0 {
			quietly replace `rsup2' = -`rsup2'
		}
		if `nc_supp' > 0 {
			quietly replace `csup2' = -`csup2'
		}
	}

	quietly replace `rnames' = usubstr(`rnames',1,`maxlength')
	quietly replace `cnames' = usubstr(`cnames',1,`maxlength')
	if `nr_supp' > 0 {
	    quietly replace `rsup_names' = usubstr(`rsup_names',1,`maxlength')
	}
	if `nc_supp' > 0 {
	    quietly replace `csup_names' = usubstr(`csup_names',1,`maxlength')
	}
	
	getRange xmin xmax : "`rdim1' `cdim1' `rsup1' `csup1'"
	getRange ymin ymax : "`rdim2' `cdim2' `rsup2' `csup2'"

	local pr1 : display %4.1f `=100*el(e(Sv),1,`ax1')^2/e(inertia)'
	local pr2 : display %4.1f `=100*el(e(Sv),1,`ax2')^2/e(inertia)'

	.atk.getAspectAdjustedScales , xmin(`xmin') 			///
		xmax(`xmax') ymin(`ymin') ymax(`ymax')

	local aspect aspectratio(`s(aspectratio)'`placement')

	local rn        `e(Rname)'
	local cn        `e(Cname)'

	local symbolR   O
	local symbolC   T

	local symbolRS  Oh
	local symbolCS  Th

	local Rscatter	(scatter `rdim2' `rdim1' ,			///
				msymbol(`symbolR') 			///
				pstyle(p1) mlab(`rnames') `rowopts')

	if `nr_supp' > 0 {
		local Rscatter `Rscatter' 				///
			(scatter `rsup2' `rsup1' ,			///
				msymbol(`symbolRS') pstyle(p1) 		///
				mlab(`rsup_names') `rsupp_opt')
	}
	
	local Copt pstyle(p2) mlab(`cnames')
	local Cscatter	(scatter `cdim2' `cdim1' ,			///
				msymbol(`symbolC') 			///
				pstyle(p2) mlab(`cnames') `colopts')

	if `nc_supp' > 0 {
		local Cscatter `Cscatter' 				///
			(scatter `csup2' `csup1' ,			///
				msymbol(`symbolCS') 			///
				pstyle(p2) mlab(`csup_names') `csupp_opt')
	}

	local xytitle	xtitle("Dimension `ax1' (`pr1'%)") 		///
				ytitle("Dimension `ax2' (`pr2'%)")

	local title     Correspondence analysis biplot

	local note1     coordinates in `e(norm)' normalization

	local titles `xytitle' title(`title', span) 			///
		note(`"`note1'"', span)

// row and column points

	if "`row'" != "norow" & "`column'" != "nocolumn" {
		local ij = 1
		local legend label(`ij++' `rn')
		if `nr_supp' {
			local legend `legend' label(`ij++' supplementary `rn')
		}

		local legend `legend' label(`ij++' `cn')
		if `nc_supp' {
			local legend `legend' label(`ij++' supplementary `cn')
		}

		local legend legend(`legend' span)
		twoway `Rscatter' `Cscatter', 		///
			`s(scales)' `aspect' `legend' `titles' `gopt' `origin'
	}

// only row points
	else if "`row'" != "norow" {
		if `nr_supp' {
			local legend legend(label(1 `rn') 	///
			   label(2 supplementary points for `rn') span)
		}
		twoway `Rscatter', 				/// 
			`s(scales)' `aspect' `legend' `titles' `gopt' `origin'
	}

// only column points
	else {
		if `nc_supp' {
			local legend legend(label(1 `cn')	///
			   label(2 supplementary points for `cn') span)
		}
		twoway `Cscatter', 				///
			`s(scales)' `aspect' `legend' `titles' `gopt' `origin'
	}
end

program getRange, sclass
	args ret_min ret_max colon vars
	local i = 0
	tempname min max
	foreach var in `vars' {
		quietly summarize `var' , meanonly
		if (`r(N)' > 0) {
			if (`++i' > 1) {
				scalar `min' = min(`r(min)', `min')
				scalar `max' = max(`r(max)', `max')
			}
			else {
				scalar `min' = r(min)
				scalar `max' = r(max)
			}
		}
	}
	c_local `ret_min' "`=`min''"
	c_local `ret_max' "`=`max''"
end

exit
