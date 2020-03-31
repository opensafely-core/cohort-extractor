*! version 1.0.4  16feb2015
program mcaprojection, sortpreserve
	version 9.0

	if ("`e(cmd)'"!="mca") {
		error 301
	}

	local names `e(names)'
	local nnames : list sizeof names
	local f = `e(f)'

	#del ;
	syntax  [anything]
	[,
		DIMensions(numlist integer >=1 <=`f' sort) /// doc as dim()
		FActors(numlist integer >=1 <=`f' sort)    /// undoc synonym
		NORMalize(str)
		ALTernate
		MAXlength(numlist integer max=1 >0 <32)
		*
	] ;
	#del cr
	local gropts `options'
	local dim `dimensions'
	if ("`dim'"!="" & "`factors'"!="") {
		dis as err "options dim() and factors() may not be combined"
		exit 198
	}
	else if ("`factors'"!="") {
		local dim `factors'
	}

	if (`"`normalize'"'!="") {
		mca_parse_normalize `"`normalize'"'
		local norm `s(norm)'
	}
	else	local norm `e(norm)'

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
				syntax  name(name=name) [,	///
					MLABel(varname)		///
					MLABVposition(varname)	///
					MLABPosition(string)	///
					SCHeme(passthru)	///
					LEGend(passthru)	///
					* ]
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
				local `name'_scheme `scheme'
				local `name'_legend `legend'
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
				while "`1'" !="" {
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

// global graphics options -----------------------------------------------------

	if (`npoints'>1) {
		local getcombine getcombine
	}

	_get_gropts , graphopts(`gropts' ) `getcombine'
	local goptions `"`s(graphopts)'"'
	local gcopts   `"`s(combineopts)'"'
	_get_gropts , graphopts(`goptions') gettwoway
	local gtopts `"`s(twowayopts)'"'
	local goptions `"`s(graphopts)'"'

// initialize dim and axis stuff -----------------------------------------------

	if ("`dim'"=="") {
		forvalues i = 1/`f' {
			local dim `dim' `i'
		}
	}
	local ndim : list sizeof dim
	local maxdim : word `ndim' of `dim'

	local xlow  : word 1 of `dim'
	local xhigh = `maxdim'
	local Xlow  = `xlow'  - 0.5
	local Xhigh = `xhigh' + 0.5
	if ("`maxlength'"=="") {
		local maxlength = 12
	}
	foreach i of numlist `dim' {
		local xlab `xlab' `i' "`i'"
	}

// ensure that c(N) is large enough --------------------------------------------
// this is needed to allow the mlabel option ....

	tempname C Ci Coding
	tempvar  touse

	gen byte `touse' = e(sample)

	if ("`norm'" == "principal") {
		matrix `C' = e(F)
	}
	else	matrix `C'  = e(A)

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

// prepare MCA variables in proper coding --------------------------------------
// this is needed to allow the mlabel option ....

	forvalues i = 1/`npoints' {
		tempvar v`i'

		local ip  : word `i' of `indexpoints'
		local name: word `i' of `points'

		matrix `Coding' = e(Coding`ip')
		local np = rowsof(`Coding')

		if ("``name'_mlabel'"=="" & "``name'_mvpos'"=="") {
			// no need to recreate codings
			qui gen `v`i'' = _n in 1/`np'
		}
		else {
			qui _applycoding `v`i'' if `touse' , coding(`Coding')

			if (r(unusedcodes) > 0) {
				Msg some values of `name' that did occur in ///
				    the estimation sample do not occur in   ///
				    the current data; these will not be plotted
			}
			if (r(uncodedobs) > 0) {
				Msg some values of `name' that did not occur ///
				    in the estimation sample do occur in the ///
				    current data; these will not be plotted
			}

// check plotting enhancement options
if "``name'_mlabel'"!="" {
	capt bys `touse' `v`i'': assert ``name'_mlabel'[1]==``name'_mlabel' ///
	                                if !missing(`v`i'') & `touse'
	if _rc {
		dis as txt ///
		    "(``name'_mlabel' not constant within `name'; ignored)"
		local `name'_mlabel
	}
}
if ("``name'_mvpos'"!="") {
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

	local note `"`norm' normalization"'
	local supp `e(supp)'
	foreach word of local points {
		foreach word2 of local supp {
			if "`word'" == "`word2'" {
				local mysupp `mysupp' `word'
			}
		}
	}
	if `"`mysupp'"' != "" {
		local wc : word count `mysupp'
		if `wc' > 1 {
			local note ///
		    `""`note'" "supplementary (passive) variables: `mysupp'""'
		}
		else {
			local note ///
		     `""`note'" "supplementary (passive) variable: `mysupp'""'
		}
	}
	local notes note(`note')

	tempvar id Markers

	local vlist
	forvalues i = 1/`npoints' {
		local pnum = mod(`i'- 1,15) + 1
		local pstyle pstyle(p`pnum')
		capture drop `a'
		capture drop `id'
		capture drop `Markers'

		local name : word `i' of `points'
		local v `v`i''

		matrix `Ci' = `C'["`name':",1...]
		local np = rowsof(`Ci')

		qui bys `v' : replace `v' = . if _n>1
		sort `v'
		qui gen `id' = _n
		local vlist `Markers' `id'

		// plot points names
		if ("``name'_mlabel'" == "") {
			local RowNames : rownames `Ci'
			qui gen `Markers' = ""
			forvalues ii = 1/`np' {
				gettoken rname RowNames : RowNames
				qui replace `Markers' = `"`rname'"' in `ii'
			}
		}
		else {
			// copy labels into new variable to allow truncation
			qui gen `Markers' = ``name'_mlabel' in 1/`np'
		}
		qui replace `Markers' = ///
		            usubstr(`Markers',1,`maxlength') in 1/`np'

		local opt mlabel(`Markers') ///
		          ``name'_opts' `goptions' `pstyle'
		local sclist
		forvalues d = 1/`ndim' {
			local idim : word `d' of `dim'

			tempvar y`d' x`d' pos`d'
			local vlist `vlist' `y`d'' `x`d''

			quietly gen `x`d'' = `idim'
			quietly gen `y`d'' = `Ci'[`v',`idim']  in 1/`np'

			if ("`alternate'" != "") {
				if ("``name'_mpos'" != "") {
					local mpos_arg ``name'_mpos'
				}
				else if ("``name'_mvpos'" != "") {
					local mpos_arg ``name'_mvpos'
				}
				else {
					local mpos_arg = 3
				}
	sort `y`d'' `id'                                            in 1/`np'
	capture drop `pos`d''
	qui gen byte `pos`d'' = `mpos_arg'                          in 1/`np'
	qui replace `pos`d'' = mod(`mpos_arg'+6,12) if mod(_n,2)==0 in 1/`np'

				sort `id' in 1/`np' // restore sort order
				local pos mlabvpos(`pos`d'')
			}
			else if ("``name'_mpos'"!="") {
				local pos mlabvpos(``name'_mpos')
			}
			else if ("``name'_mvpos'"!="") {
				local pos mlabvpos(``name'_mvpos')
			}
			else {
				local pos mlabpos(3)
			}
			local ytitle ytitle("Score")

			local gcmd  scatter `y`d'' `x`d'',         ///
				    xtitle(Dimensions) `ytitle'   ///
				    xline(`idim', lcolor(black))   ///
				    legend(label(1 `name') order(1)) `pos' `opt'

			local sclist `sclist' (`gcmd')
		}

		if (`npoints'==1) {
			local oneplot_opts `notes' 		///
				title(MCA dimension projection plot) `gtopts'
		}
		else {
			tempname `name'_plot
			local plotnames     `plotnames' ``name'_plot'
			local oneplot_opts  name(``name'_plot') 	///
				``name'_scheme' nodraw ``name'_legend'
		}
		twoway `sclist', 				///
		   xscale(range(`Xlow' `Xhigh')) 		///
		   xlabel(`xlab', notick labsize(small))	///
		   legend(on) `oneplot_opts'
		if (`"`restore'"'!="") {
			`restore'
		}
	}


// combine plot

	if (`npoints'>1) {
		graph combine `plotnames', 		///
		   title(MCA dimension projection plot)	///
		   ycommon `notes' `gcopts' `gtopts'
		graph drop `plotnames'
	}
end

program Msg
	dis as txt `"{p 0 1}(`0'){p_end}"'
end
exit

