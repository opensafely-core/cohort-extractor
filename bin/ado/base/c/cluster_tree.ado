*! version 3.2.0  20feb2019
program define cluster_tree, sortpreserve
	if _caller() < 9 {
		cluster_tree_8 `0'
		exit
	}
	Dendrogram `0'
end

program Dendrogram
	version 9

	syntax [namelist(name=clname id="clname")] [if] [in] [, * ]

	if "`clname'" == "" {
		cluster query
		local clname : word 1 of  `r(names)'
	}
	cluster query `: word 1 of `clname''

	// if a treeprogram is specified within -clname- call that routine
	local i 1
	while `"`r(o`i'_tag)'"' != "" {
		if `"`r(o`i'_tag)'"' == "treeprogram" {
			if `"`r(o`i'_val)'"' == "cluster_tree" {
				continue, break
			} 
			else {
				`r(o`i'_val)' `0'
				exit
			}
		}
		local i = `i' + 1
	}

	if `:word count `clname'' > 1 {
		// let -cluster query- display the error message
		cluster query `clname'
	}

	// otherwise we use the default tree routine
	if "`r(type)'" != "hierarchical" {
		di as err "{p}dendrograms allowed only after hierarchical"
		di as err "clustering{p_end}"
		exit 198
	}

	// max number of leaves that will be allowed
	local maxcutn 100

	local idvar `r(idvar)'
	local ordvar `r(ordervar)'
	local hgtvar `r(heightvar)'

	if "`hgtvar'" == "" {
		di as err "currently can't handle dendrogram reversals"
		exit 198
	}

	local i 1
	while "`r(o`i'_tag)'" != "" {
		if "`r(o`i'_tag)'" == "range" {
			local range `r(o`i'_val)'
			continue, break
		}
		local i = `i' + 1
	}
	if "`range'" == "" {
		local simval 0
	}
	else {
		local simval : word 1 of `range'
	}
	local rsim `r(similarity)'
	local rdis `r(dissimilarity)'

	syntax [anything] [if] [in] [,		///
		LAbels(varname)			///
		SHOWCount			///
		COUNTPrefix(string)		///
		COUNTSuffix(string)		///
		COUNTInline			///
		CUTValue(numlist max=1)		///
		CUTNumber(numlist max=1 >1	///
			<=`maxcutn' int)	///
		quick				///
		HORizontal			/// graph options
		nodraw				///
		*				///
	]

	if "`countprefix'`countsuffix'`countinline'" != "" {
		local showcount showcount
	}

	// the -by()- option is not allowed
	_get_gropts, graphopts(`options') getallowed(addplot)
	local options `"`s(graphopts)'"'
	local addplot `"`s(addplot)'"'

	if "`cutvalue'" != "" & "`cutnumber'" != "" {
		di as err "{p}only one of cutvalue() and cutnumber() may be"
		di as err "specified{p_end}"
		exit 198
	}

	tempvar newid notuse
	if "`cutvalue'`cutnumber'" != "" {
		// We are to trim the lower part of the tree before display
		if "`if'`in'" != "" {
			di as err "{p}cutvalue() and cutnumber() not allowed"
			di as err "with if or in{p_end}"
			exit 198
		}
		quietly gen byte `notuse' = 1

		if "`cutnumber'" != "" {
			qui replace `notuse' = 0 if `idvar' <  . & `hgtvar' >= .
			local cutnm1 = `cutnumber' - 1
			tempvar tmpsort
			qui gen byte `tmpsort' = `idvar' >= .
			if "`rsim'" != "" {
				sort `tmpsort' `hgtvar'
				qui drop `tmpsort'
			}
			else {
				tempvar tmpsort2
				qui gen double `tmpsort2' = -`hgtvar'
				sort `tmpsort' `tmpsort2'
				qui drop `tmpsort2' `tmpsort'
			}
			if `hgtvar'[`cutnm1'] == `hgtvar'[`cutnumber'] {
				di as err "{p}cannot cut exactly `cutnumber'"
				di as err "groups because of ties in the"
				di as err "dendrogram{p_end}"
				exit 198
			}
			qui replace `notuse' = 0 in 1/`cutnm1'
		}
		else { /* cutvalue */
			if "`rsim'" != "" {
				qui replace `notuse' = 0 if `idvar' < . & /*
					*/ (`hgtvar'<=`cutvalue' | `hgtvar'>=.)
			}
			else {
				qui replace `notuse' = 0 if `idvar' < . & /*
					*/ `hgtvar'>=`cutvalue'
			}
			qui count if `notuse' == 0
			if r(N) <= 1 {
				di as err "{p}nothing to display; all tree" /*
					*/ " divisions fall below " /*
					*/ "cutvalue(`cutvalue'){p_end}"
				exit 198
			}
		}

		sort `notuse' `idvar'
		qui gen `c(obs_t)' `newid' = _n if `notuse'==0

		local oldid `idvar'
		local idvar `newid'

		tempvar xlabvar
		if "`labels'" != "" {
			local xvtype : type `labels'

 			sort `oldid'
			qui gen `xvtype' `xlabvar' = `labels'[`ordvar'] /*
							*/ if ~missing(`idvar')
 			sort `idvar'
		}
		else {
			qui gen str1 `xlabvar' = ""
			qui replace `xlabvar' = "G"+string(`idvar') /*
							*/ if `idvar' < .
		}
	}
	else {	// no cut options
		marksample touse
		// As well as -if- & -in- we restrict to obs. from cl. anal.
		markout `touse' `idvar'
		qui count if `touse'
		if `r(N)' < 1 {
			di as err "{p}no observations meet your selection"
			di as err "criteria and are part of `clname'{p_end}"
			exit 2000
		}
		sort `idvar'
		// The [`ordvar'] on `touse' in the line below is crucial
		qui gen long `newid' = `idvar' if `touse'[`ordvar']
		qui compress `newid'
		local oldid `idvar'
		local idvar `newid'

		if "`labels'" != "" {
			tempvar xlabvar
			local xvtype : type `labels'
			qui gen `xvtype' `xlabvar' = `labels'[`ordvar']
		}
		else {
			local xlabvar `ordvar'
		}
		quietly gen byte `notuse' = 1-`touse'
	}

	// impose a limit on the number of leaves allowed
	qui count if `idvar' < .
	if `r(N)' > `maxcutn' {
		if "`cutvalue'`cutnumber'" != "" {
			di as err "{p}too many leaves; use a more restrictive"
			di as err "value for cutvalue() or use the cutnumber()"
			di as err "option{p_end}"
		}
		else {
			di as err "{p}too many leaves; consider using the"
			di as err "cutvalue() or cutnumber() options{p_end}"
		}
		exit 198
	}

	quietly if "`showcount'" != "" {
		if "`countprefix'`countsuffix'" == "" {
			local countprefix "n="
		}
		sort `notuse' `oldid'
		tempvar tmpcnt2 xlabvar2
		gen long `tmpcnt2' = .
		replace `tmpcnt2' = `oldid' - `oldid'[_n-1]	///
			in 2/l if `newid' < .
		replace `tmpcnt2' = `oldid' in 1
		gen str1 `xlabvar2' = ""
		replace `xlabvar2' = "`countprefix'"		///
			+ string(`tmpcnt2')			///
			+ "`countsuffix'"			///
			if `newid' < .
		drop `tmpcnt2'
	}

	tempvar heightv
	local hvtype : type `hgtvar'
	if "`rsim'" != "" {
		// swap the sense of the hgtvar to be like a dissimilarity
		qui gen `hvtype' `heightv' = `simval' - `hgtvar'
		local meastitle `rsim' similarity measure
		local sign "-"  // realh = simval - myh
		local yreverse yscale(reverse)
		local xreverse xscale(reverse)
	}
	else if "`rdis'" != "" {
		qui gen `hvtype' `heightv' = `hgtvar' - `simval'
		local meastitle `rdis' dissimilarity measure
		local sign "+"  // realh = simval + myh
	}
	else {
		di as err "{p}`clname' does not have similarity or"
		di as err "dissimilarity measure set{p_end}"
		exit 198
	}

	sort `newid'

	GetXLabels `newid' `xlabvar' "`xlabvar2'" "`countinline'"
	local xlabels `"`s(xlabels)'"'

	tempname dendroframe
	if "`quick'" != "" {
		GenQuickData "`dendroframe'" `newid' `heightv'
	}
	else {
		// NOTE: GenCenterData modifies the `newid' variable, so make
		// sure to perform all calculations that require this variable
		// prior to the following call.
		GenCenterData "`dendroframe'" `newid' `heightv'
	}

	local xlops nogrid notick
	if "`horizontal'" == "" {
		local bmarg plotregion(margin(b=0))
		local axopts				///
			`yreverse'			///
			xlabel(`xlabels', `xlops')	///
			xscale(lstyle(none))		///
			xtitle("")			///
			ylabel(, nogrid)		///
			ytitle("`meastitle'")		///
			// blank
	}
	else {
		local bmarg plotregion(margin(l=0)) `horizontal'
		local axopts				///
			`xreverse'			///
			ylabel(`xlabels', `xlops')	///
			yscale(lstyle(none))		///
			ytitle("")			///
			xlabel(, nogrid)		///
			xtitle("`meastitle'")		///
			// blank
	}

	if `"`addplot'"' != "" & "`draw'" == "" {
		local draw0 nodraw
	}
	local curframe = c(frame)
	frame `dendroframe' {
		if "`rsim'" != "" {
			quietly replace y1 = `simval' - y1
			quietly replace y2 = `simval' - y2
		}
		else {
			quietly replace y1 = y1 - `simval'
			quietly replace y2 = y2 - `simval'
		}
		graph twoway pcspike y1 x1 y2 x2,			///
			pstyle(dendrogram)				///
			title("Dendrogram for `clname' cluster analysis") ///
			`draw' `draw0'					///
			`bmarg' `axopts'				///
			`options'					///
			// blank
	}
	if `"`addplot'"' != "" {
		graph addplot `addplot' || , norescaling `draw'
	}
end

program GetXLabels, sclass
	args x xlab xlab2 inline
	quietly count if `x' < .
	local n = r(N)
	if "`xlab2'" == "" {
		forval i = 1/`n' {
			local val = `x'[`i']
			local xlabs `"`xlabs' `val' `"`=`xlab'[`i']'"'"'
		}
	}
	else if "`inline'" == "" {
		forval i = 1/`n' {
			local val = `x'[`i']
			local xlabs ///
		`"`xlabs' `val' `"`"`=`xlab'[`i']'"' `"`=`xlab2'[`i']'"'"'"'
		}
	}
	else {
		forval i = 1/`n' {
			local val = `x'[`i']
			local xlabs ///
		`"`xlabs' `val' `"`=`xlab'[`i']' `=`xlab2'[`i']'"'"'
		}
	}
	sreturn local xlabels `"`:list retok xlabs'"'
end

program GenQuickData
	gettoken frame 0 : 0
	syntax varlist(min=2 max=2)
	args frame x y

	quietly count if `x' < .
	local n = r(N)

	frame create `frame' x1 y1 x2 y2

	local imax 1
	local nm1 = `n' - 1
	forval i = 1/`nm1' {
		frame post `frame' (`x'[`i']) (0) (`x'[`i']) (`y'[`i'])
		local ip1 = `i' + 1
		forval j = `ip1'/`n' {
			if `y'[`j'] >= `y'[`i'] {
				local tox `j'
				continue, break
			}
		}
		frame post `frame' (`x'[`i']) (`y'[`i']) (`x'[`tox']) (`y'[`i'])
		if `y'[`imax'] < `y'[`i'] {
			local imax `i'
		}
	}
	frame post `frame' (`x'[`n']) (0) (`x'[`n']) (`y'[`imax'])
end

program GenCenterData
	gettoken frame 0 : 0
	syntax varlist(min=2 max=2)
	args frame oldx y

	tempvar x
	qui clonevar `x' = `oldx'
	quietly count if `x' < .
	local n = r(N)

	frame create `frame' x1 y1 x2 y2

	tempvar aty diff
	quietly gen double `aty' = 0 if `x' < .
	quietly gen double `diff' = `y' if `x' < .

	local change 1
	local dotcnt 0
	local nm1 = `n' - 1
	while `dotcnt' < `nm1' {
		local atj 0
		forval i = 1/`n' {
			if `x'[`i'] < . {
				if ((`atj' == 0)|(`y'[`i']<`y'[`atj'])) ///
				 & (`diff'[`i'] != 0) {
					frame post `frame'	///
						(`x'[`i'])	///
						(`aty'[`i'])	///
						(`x'[`i'])	///
						(`y'[`i'])	///
						// blank
					qui replace `aty' = `y'[`i'] in `i'
				}
				else if (`diff'[`i'] != 0) ///
				 & (`aty'[`i'] != `y'[`atj']) {
					frame post `frame' 	///
						(`x'[`i'])	///
						(`aty'[`i'])	///
						(`x'[`i'])	///
						(`y'[`atj'])	///
						// blank
					qui replace `aty' = `y'[`atj'] in `i'
				}
				local atj `i'
			}
		}
		quietly replace `diff' = `y' - `aty'
		local atj 0
		forval i = 1/`n' {
			if `x'[`i'] < . {
				if (`diff'[`i'] != 0) & (`diff'[`atj'] == 0) {
					frame post `frame'	///
						(`x'[`atj'])	///
						(`aty'[`atj'])	///
						(`x'[`i'])	///
						(`aty'[`i'])	///
						// blank
					qui replace `x' = (`x'[`i'] + ///
						`x'[`atj'])/2 in `i'
					qui replace `x' = . in `atj'
					local dotcnt = `dotcnt' + 1
				}
				local atj `i'
			}
		}
	}
end

exit
