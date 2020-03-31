*! version 1.0.5  01feb2012
// parse and optionally generate variables for -graph twoway sunflower-
program twoway__sunflower_gen, rclass sortpreserve
	version 8.0

	// options used by -twoway__sunflower_gen- (data generator)
	_parse combop 0 : 0 , option(BINWidth)		rightmost
	_parse combop 0 : 0 , option(BINAR)		rightmost
	_parse combop 0 : 0 , option(XCENter)		rightmost
	_parse combop 0 : 0 , option(YCENter)		rightmost
	_parse combop 0 : 0 , option(LIght)		rightmost
	_parse combop 0 : 0 , option(DArk)		rightmost
	_parse combop 0 : 0 , option(PETALWeight)	rightmost
	_parse combop 0 : 0 , option(PETALLength)	rightmost

	syntax varlist(numeric min=2 max=2)	///
		[fweight] [if] [in] [,		///
		BINWidth(real -1)		/// -twoway sunflower- opts
		BINAR(string)			///
		YCENter(passthru)		///
		XCENter(passthru)		///
		LIght(int 3)			///
		DArk(int 13)			///
		PETALWeight(int -1)		///
		PETALLength(int 100)		///
		GENerate(string asis)		/// my options
		display				///
		noSINGLEpetal			///
		*				/// other graph options
	]

	return local singlepetal `singlepetal'

	if `light' <= 0 {
		di as err "option light() requires a positive integer"
		exit 198
	}
	if `dark' <= `light' {
		di as err ///
		"option dark() may not be less than or equal to option light()"
		exit 198
	}

	marksample touse

	gettoken y x : varlist
	if r(N) < 2 {
		error 2001
	}

	SUMM `x' if `touse', `xcenter'
	local nobs	= r(N)
	local xc	= r(center)
	local xr	= r(range)
	local xmin	= r(min)
	local xmax	= r(max)

	SUMM `y' if `touse', `ycenter'
	local yc	= r(center)
	local yr	= r(range)
	local ymin	= r(min)
	local ymax	= r(max)

	// default binwidth
	if `binwidth' <= 0 {
		local bin = int(		///
			min(			///
			sqrt(`nobs'),		///
			10*log10(`nobs')	///
			)			///
		)
		local binwidth = max(`xr'/max(1,`bin'), `xr'/40)
		// local binwidth = `xr'/40
	}
	local w	= `binwidth'

	// aspect ratio
	if `"`binar'"' == "" {
		tempname binar
		scalar `binar' = `yr'/`xr'
	}
	confirm number `=`binar''

	// Assumed hexagon:
	//
	//     ^     --+--
	//    / \      |
	//   /   \     |
	//  /     \    |
	// |       |   |
	// |       |
	// |   +   |   h
	// |       |
	// |       |   |
	//  \     /    |
	//   \   /     |
	//    \ /      |
	//     v     --+--
	//
	// <-- w -->

	// height of hexagon
	local h = `binar'*`binwidth'/(sqrt(3)/2)

	// Saved results from the parse
	return local varlist	"`varlist'"
	return local options	`"`options'"'
	if "`weight'" != "" {
		return local wtype	= "`weight'"
		return local wtexp	= "`exp'"
	}
	return scalar binwidth	= `binwidth'
	return scalar binar	= `binar'
	return scalar binheight	= `h'
	return scalar yc	= `yc'
	return scalar yr	= `yr'
	return scalar ymin	= `ymin'
	return scalar ymax	= `ymax'
	return scalar xr	= `xr'
	return scalar xc	= `xc'
	return scalar xmin	= `xmin'
	return scalar xmax	= `xmax'
	return scalar light	= `light'
	return scalar dark	= `dark'
	return scalar pw	= `petalweight'
	return scalar pl	= `petallength'

	// parsing is finished, so exit if no variables to generate

	if ( `"`generate'"' == "" ) exit

	CheckGenOpt `generate'
	local generate `s(varlist)'
	if `"`generate'"' != "" & `"`s(replace)'"' == "" {
		confirm new var `generate'
	}

	// `w' is the distance between centers of horizontally aligned hexagons

	// horizontal shift
	local wo = `w'/2

	// `h' is the distance between centers of vertically aligned hexagons
	local h = `h'*3/2
	// vertical shift
	local ho = `h'/2

	tempvar wgt	/// frequency weight
		binx	/// x position for bin
		biny	/// y position for bin
		binc	/// count for bin
		bind	/// distance from point to nearest bin
		oddx	/// x position for odd bin
		oddy	/// y position for odd bin
		oddd	/// distance from point to nearest bin
		// blank

quietly {

	// find nearest "even" hex bins, and compute the distance
	gen `biny' = `yc' + `h'*round((`y'-`yc')/`h',1)
	gen `binx' = `xc' + `w'*round((`x'-`xc')/`w',1)
	gen `bind' = sqrt( (`x'-`binx')^2 + ((`y'-`biny')/`binar')^2 )

	// find nearest "odd" hex bins, and compute the distance
	gen `oddy' = `yc' + `ho' + `h'*round((`y'-`yc'-`ho')/`h',1)
	gen `oddx' = `xc' + `wo' + `w'*round((`x'-`xc'-`wo')/`w',1)
	gen `oddd' = sqrt( (`x'-`oddx')^2 + ((`y'-`oddy')/`binar')^2 )

	// choose the nearest bin between the "even" and "odd" bins
	replace `binx' = `oddx' if `oddd' < `bind'
	replace `biny' = `oddy' if `oddd' < `bind'
	replace `oddx' = `binx'
	replace `oddy' = `biny'
	drop `oddd' `bind'

	local by `touse' `binx' `biny'
	sort `by' , stable

	// frequency weights for bin counting
	if `"`weight'"' != "" {
		quietly gen `wgt' `exp' if `touse'
	}
	else	quietly gen `wgt' = 1 if `touse'

	// compute the bin counts
	by `by' : gen `binc' = cond(_n==_N,sum(`wgt'),.) if `touse'

	// recover individual points from bins with count < `light'
	by `by' : replace `oddx' = `x' if `binc'[_N] < `light'
	by `by' : replace `oddy' = `y' if `binc'[_N] < `light'
	by `by' : replace `binc' = 1 if `binc'[_N] < `light'
	drop `binx' `biny'

	// Rename the generated variables
	gettoken y x : varlist
	DropGenVars `generate'
	tokenize `generate'
	rename `oddy' `1'
	rename `binc' `2'
	rename `oddx' `3'
	format `:format `y'' `1'
	_crcslbl `1' `y'
	_crcslbl `2' `y'	// give count variable the same label a `y'
	format `:format `x'' `3'
	_crcslbl `3' `x'

} // quietly

end

// Saved results:
// Scalars:
// 	r(N)		- number of observations
// 	r(center)	- median or value of -center()- option
//	r(range)	- range or 1 if range==0
program SUMM, rclass
	syntax varname [if] [, xcenter(string) ycenter(string) ]

	local myif `"`if'"'
	local myvar `varlist'

	local center `xcenter'`ycenter'
	local detail = cond("`center'" == "", "detail", "mean")
	if "`center'" == "" {
		quietly summarize `myvar' `myif', detail
		return scalar center = r(p50)
	}
	else {
		if "`xcenter'`ycenter'" != "" {
			// verify the syntax
			local 0 `", xcenter(`xcenter') ycenter(`ycenter')"'
			syntax [,				///
				xcenter(numlist min=1 max=1)	///
				ycenter(numlist min=1 max=1)	///
			]
		}
		quietly sum `myvar' `myif', mean
		return scalar center = `center'
	}
	if r(max) > r(min) {
		return scalar range = r(max) - r(min)
	}
	else	return scalar range = 1
	return add
end

program DropGenVars
	foreach var of local 0 {
		capture confirm var `var'
		if !_rc {
			unab vv : `var'
			if "`vv'" == "`var'" {
				drop `var'
			}
		}
	}
end

program CheckGenOpt, sclass	// CheckGenOpt y x c [, replace]
	syntax [namelist] [, replace]

	if `"`replace'`namelist'"' != "" {
		local n : word count `namelist'
		if `n' < 3 {
			di as err ///
			"too few names specified in generate() option"
			exit 102
		}
		else if `n' > 3 {
			di as err ///
			"too many names specified in generate() option"
			exit 103
		}
	}
	sreturn clear
	sreturn local varlist `namelist'
	sreturn local replace `replace'
end

exit
