*! version 1.0.6  16feb2015
program mcaplot, sortpreserve
	version 9.0

	if ("`e(cmd)'" != "mca") {
		error 301
	}

	local names `e(names)'
	local nnames : list sizeof names
	local f = `e(f)'
	if (`f' == 1) {
		dis as txt "(nothing to do with 1 dimension)"
		exit
	}

	#del ;
	syntax  [ anything ]
	[,
	   DIMensions(numlist integer min=2 max=2 >=1 <=`f') // doc as dim()
	   FActors(numlist integer min=2 max=2 >=1 <=`f')    // undoc syn dim()
	   NORMalize(str)
	   OVERlay
	   XNEGate
	   YNEGate
	   ORigin // same abbv as ORiginlopts if either specified the origin is
	   ORiginlopts(str) // displayed
	   MAXlength(numlist integer max=1 >0 <32)
	   ASPECTratio(str)
	   SCHeme(passthru)
	   *
	] ;
	#del cr

	local holdaspect `aspectratio'
	local gropts `options'

	local dim `dimensions'
	if ("`dim'"!="" & "`factors'"!="") {
		dis as err "options dim() and factors() may not be combined"
		exit 198
	}
	local axes `factors' `dim'
	if ("`axes'"!="") {
		local ax1 : word 2 of `axes'
		local ax2 : word 1 of `axes'
		if (`ax1'==`ax2') {
			dis as "plot dimensions should differ"
			exit 198
		}
	}
	else {
		local ax1 = 1
		local ax2 = 2
	}

	if (`"`normalize'"'!="") {
		mca_parse_normalize `"`normalize'"'
		local norm `s(norm)'
	}
	else	local norm `e(norm)'
	local normnote "coordinates in `norm' normalization"

	tempvar obs
	gen `c(obs_t)' `obs' = _n
// parse "anything" ------------------------------------------------------------

	if (`"`anything'"'=="") {
		local points  `names'
		local npoints `nnames'
	}
	else {
		local points
		local npoints = 0
		gettoken tok anything : anything, match(parens)
		while (`"`tok'"'!="") {
			if ("`parens'"!="") {
				local 0 `tok'
				syntax  name(name=name) [,     ///
					MLABel(varname)        ///
					MLABVposition(varname) ///
					ASPECTratio(passthru)  ///
					MLABPosition(string)   * ]
				if `"`aspectratio'"' != "" {
					noi di as err		///
	 	"aspectratio() not allowed in {it:speclist} plot options"
					exit 198
				}
				local 1
				mca_lookup "`name'" "`names'"
				local name `s(name)'
				if (`:list name in points') {
					dis as err ///
					   "multiple specifications for `name'"
					exit 198
				}
				local ++npoints
				local points `points' `name'
				local `name'_opts   `"`options'"'
				local `name'_mlabel `"`mlabel'"'
				local `name'_mpos   `"`mlabposition'"'
				local `name'_mvpos  `"`mlabvposition'"'
			}
			else {
				local wc : word count tok
				local myvarlist
				foreach word of local tok {
					local 0 `word'
					capture syntax varlist(numeric)
					if _rc == 0 {
						local myvarlist ///
							`myvarlist' `varlist'
					}
					else {
						local myvarlist ///
							`myvarlist' `word'
					}
				}
				tokenize `myvarlist'
				while "`1'" != "" {
					local name `1'
					local options
					local mlabel
					local mlabposition
					local mlabvposition

					mca_lookup "`name'" "`names'"
					local name `s(name)'
					if (`:list name in points') {
						dis as err ///
					   "multiple specifications for `name'"
						exit 198
					}
					local ++npoints
					local points `points' `name'
					macro shift
				}
			}
			gettoken tok anything : anything, match(parens)
		}
	}

	foreach point of local points {
		local ipoint : list posof "`point'" in names
		local indexpoints `indexpoints' `ipoint'
	}

// global graphics options  ----------------------------------------------------

	if ((`npoints'>1) & ("`overlay'"=="")) {
		local getcombine getcombine
	}

	_get_gropts , graphopts(`gropts') `getcombine'
	local goptions `"`s(graphopts)'"'
	local gcopts   `"`s(combineopts)'"'
	_get_gropts, graphopts(`goptions') gettwoway
	local goptions `"`s(twowayopts)'"'
	local glocopt	`"`s(graphopts)'"'
// ensure that c(N) is large enough --------------------------------------------

	tempname Coding Ci C
	tempvar  touse

	gen byte `touse' = e(sample)

	if ("`norm'" == "principal") {
		matrix `C' = e(F)
	}
	else	matrix `C' = e(A)

	local npmax = 0
	foreach name of local points {
		matrix `Ci' = `C'["`name':",1...]
		local npmax = max(`npmax',rowsof(`Ci'))
	}
	if (`npmax'>c(N)) {
		preserve
		local restore restore
		quietly set obs `npmax'
	}

// aspect ratio ---------------------------------------------------------------
	local aspectratio `holdaspect'
	if ("`xnegate'"   != "") local xneg -
	if ("`ynegate'"   != "") local yneg -

	.atk = .aspect_axis_toolkit.new
	.atk.setPreferredLabelCount 6
	_parse comma aspect_ratio placement : aspectratio

	if ("`aspect_ratio'"!="") {
		confirm number `aspect_ratio'
		.atk.setPreferredAspect `aspect_ratio'
		.atk.setShowAspectTrue
	}
	else {
		.atk.setAutoAspectTrue
	}

	tempname xmin ymin xmax ymax

	// min/max computed over ALL variables to ensure comparability
	scalar `xmin' = `xneg' `C'[1,`ax1']
	scalar `xmax' = `xneg' `C'[1,`ax1']
	scalar `ymin' = `yneg' `C'[1,`ax2']
	scalar `ymax' = `yneg' `C'[1,`ax2']
	forvalues i = 2/`=rowsof(`C')' {
		scalar `xmin' = min(`xmin', `xneg' `C'[`i',`ax1'])
		scalar `xmax' = max(`xmax', `xneg' `C'[`i',`ax1'])
		scalar `ymin' = min(`ymin', `yneg' `C'[`i',`ax2'])
		scalar `ymax' = max(`ymax', `yneg' `C'[`i',`ax2'])
	}

	.atk.getAspectAdjustedScales , ///
	     xmin(`=`xmin'') xmax(`=`xmax'') ymin(`=`ymin'') ymax(`=`ymax'')
	local aspect aspectratio(`s(aspectratio)'`placement')
	local scales `s(scales)'

// prepare MCA variables in proper coding --------------------------------------
// this is needed to allow the mlabel() option ....

	forvalues i = 1/`npoints' {
		tempvar v`i'

		local ip   : word `i' of `indexpoints'
		local name : word `i' of `points'

		matrix `Coding' = e(Coding`ip')
		local np = rowsof(`Coding')

		if ("``name'_mlabel'"=="" & "``name'_mvpos'"=="") {
			// no need to recreate codings
			qui gen `v`i'' = _n in 1/`np'
		}
		else {
			qui _applycoding `v`i'' if `touse' , coding(`Coding')

			// check reconstruction of coding
			if (r(unusedcodes)>0) {
				Msg some values of `name' that did occur in ///
				    the estimation sample do not occur in   ///
				    the current data; these will not be plotted
			}
			if (r(uncodedobs)>0) {
				Msg some values of `name' that did not occur ///
				    in the estimation sample do occur in the ///
				    current data; these will not be plotted
			}
		sort `touse' `v`i'' `obs'
// check plotting enhancement options
if ("``name'_mlabel'"!="") {
	capt bys `touse' `v`i'': assert ``name'_mlabel'[1]==``name'_mlabel' ///
	                                if !missing(`v`i'') & `touse'
	if (_rc) {
		dis as txt ///
		    "(``name'_mlabel' not constant within `name'; ignored)"
		local `name'_mlabel
	}
}
if "``name'_mvpos'" != "" {
	capt bys `touse' `v`i'': assert ``name'_mvpos'[1]==``name'_mvpos' ///
	                                if !missing(`v`i'') * `touse'
	if _rc {
		dis as txt ///
		    "(``name'_mvpos' not constant within `name'; ignored)"
		local `name'_mvpos
	}
}

		}
	}

// generate plots --------------------------------------------------------------

	if ("`xnegate'"   != "") local xneg -
	if ("`ynegate'"   != "") local yneg -
	if ("`maxlength'" == "") local maxlength = 12

	// display explained inertias in labels or note
	local pr1 : display %4.1f el(e(inertia_e),1,`ax1')
	local pr2 : display %4.1f el(e(inertia_e),1,`ax2')

	if (`npoints' > 1 & "`overlay'" == "") {
		local htxt " (horizontal)"
		local vtxt " (vertical)"
	}
	local xtext `"dimension `ax1'`htxt' explains `pr1'% inertia"'
	local ytext `"dimension `ax2'`vtxt' explains `pr2'% inertia"'
	local xtext2 `"dimension `ax1' (`pr1'%)"'
	local ytext2 `"dimension `ax2' (`pr2'%)"'

	if (`"`originlopts'"' != "") {
		local origin origin
	}
	if ("`origin'" != "") {
		local 0 ,`originlopts'
		syntax [, LColor(str) LWidth(str) * ]

		if ("`lcolor'" == "") local lcolor black
		if ("`lwidth'" == "") local lwidth vthin

		local otxt lcolor(`lcolor') lwidth(`lwidth') `options'
		local orig xline(0,`otxt') yline(0,`otxt')
	}

	forvalues i = 1/`npoints'  {
		tempvar Markers`i' pos`i' x`i' y`i'

		local name : word `i' of `points'
		matrix `Ci' = `C'["`name':",1...]
		local np = rowsof(`Ci')

		sort `v`i'' `obs'
		qui bys `v`i'' : replace `v`i'' = . if _n>1
		sort `v`i'' `obs' 
		qui gen `x`i'' = `xneg' `Ci'[`v`i'', `ax1'] in 1/`np'
		qui gen `y`i'' = `yneg' `Ci'[`v`i'', `ax2'] in 1/`np'
		label variable `y`i'' `: word `i' of `points''

	     // marker labels

		if ("``name'_mlabel'"=="") {
			local RowNames : rownames `Ci'
			qui gen `Markers`i'' = ""
			forvalues ip = 1/`np' {
				gettoken rname RowNames : RowNames
				qui replace `Markers`i'' = `"`rname'"' in `ip'
			}
		}
		else {
			// copy labels into new variable to allow truncation

			local mtype : type ``name'_mlabel'
			if bsubstr("`mtype'",1,3)=="str" {
				qui gen `Markers`i'' = ``name'_mlabel'	///
					 in 1/`np'
			}
			else {
				qui gen `Markers`i'' =			///
					 string(``name'_mlabel') in 1/`np'
			}
		}
		qui replace `Markers`i'' = ///
		            usubstr(`Markers`i'',1,`maxlength') in 1/`np'

	     // marker positions

		if ("``name'_mpos'"!="") {
			local pos mlabpos(``name'_mpos')
		}
		else if ("``name'_mvpos'"!="") {
			local pos mlabvpos(``name'_mvpos')
		}
		else {
			local pos
		}

	     // other options

		local opt mlabel(`Markers`i'') `pos' `orig' `colopt' 	///
			``name'_opts' `glocopt'
		local xytitles title(`name', span) xtitle("") ytitle("")

	     // draw plots

		if (`npoints'==1) {
			#del ;
			twoway scatter `y`i'' `x`i'' in 1/`np',
			   `aspect' `scales'
			   legend(off)
			   note(`normnote', span)
			   xtitle(`xtext2')
			   ytitle(`ytext2')
			   title(MCA coordinate plot of `name', span)
			    `opt' `scheme' `goptions';
			#del cr
			exit
		}

		if ("`overlay'"=="") {
			// combined plot
			tempname `name'_plot
			local plotnames `plotnames' ``name'_plot'
			#del ;
			twoway scatter `y`i'' `x`i'' in 1/`np',
			   `aspect' `scales'
			   legend(off)
			   `xytitles'
			   nodraw name(``name'_plot')
			   `opt' ;
			#del cr
			drop `y`i'' `x`i''
		}
		else {
			// overlaid plot
			local legend `legend' label(`i' `name')
			// -in- clause omitted on purpose
			local scatterlist `scatterlist' ///
			                  (scatter `y`i'' `x`i'',`opt')
		}
	}
	local esupp `e(supp)'
	foreach word of local points {
		foreach word2 of local esupp {
			if "`word'" == "`word2'" {
				local mysupp `mysupp' `word'
			}
		}
	}
	if `"`mysupp'"' != "" {
		local wc : word count `mysupp'
		if `wc' > 1 {
local symbmsg `"supplementary (passive) variables: `mysupp'"'
		}
		else {
local symbmsg `"supplementary (passive) variable: `mysupp'"'
		}
	}

// combine or overlaid plot (npoint==1 is already handled)

	if `"`symbmsg'"' != "" {
		local snormnote "`"`symbmsg'"' `"`normnote'"'"
	}
	else {
		local snormnote "`"`normnote'"'"
	}
	if ("`overlay'"=="") {
		#del ;
		graph combine `plotnames',
		   title(MCA coordinate plot, span)
		   note(`"`xtext'"' `"`ytext'"' `snormnote', span)
		   xcommon ycommon
		   `gcopts' `scheme' `goptions';
		#del cr
		graph drop `plotnames'
	}
	else {
		// overlaid plot
		#del ;
		graph twoway `scatterlist',
		   legend(`legend' span)
		   xtitle(`xtext2')
		   ytitle(`ytext2')
		   title(MCA coordinate plot, span)
		   note(`snormnote', span) `scheme' `aspect' `scales' `goptions';
		#del cr
	}
end

program Msg
	dis as txt `"{p 0 1}(`0'){p_end}"'
end
exit
