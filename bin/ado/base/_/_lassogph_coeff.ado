*! version 1.0.9  16jul2019
program _lassogph_coeff
	version 16.0
	if (`"`e(cmd)'"'!="lasso" &		///
		`"`e(cmd)'"' != "elasticnet"  & ///
		`"`e(cmd)'"' != "sqrtlasso" ) {
		di as err "last estimates not found"
		exit 301
		// NotReached
	}
						//  store eclass results
	tempname est
	qui _estimates hold `est', copy restore
						// draw	graph
	cap noi Draw `0'
	local rc = _rc
						// unhold est
	_est unhold `est'
						// exit errors if happens
	if `rc' exit `rc'
end
					//----------------------------//
					// Draw coefficient path
					//----------------------------//
program Draw, sclass
	preserve	 			// preserve start

	syntax [anything(everything)]	///
		[, laout(passthru)	/// Not Documented
		subspace(passthru)	/// Not Documented
		*]

	local oecmd `e(oecmd)'
	_lasso_useresult, clear	`laout' `subspace'	//  load result
							//  syntax

	syntax [name]			///
		[if] [in]		///
		[, LABELPATH1		///		//Not Documented
		labelpath(passthru)	///		//Not Documented
		norefline		///
		legend(passthru)	///
		note(passthru)		///
		mono			///
		monoopts(string)	///
		RLOPts(string)		///
		YTItle(passthru)	///
		i(passthru)		/// Not Documented
		get_xvar		/// Not Documented
		xytitle			/// Not Documented
		laout(passthru)		/// Not Documented
		subspace(passthru)	/// Not Documented
		data(string asis)	///
		minmax			///
		RAWcoefs		///
		TItle(passthru)		///
		SUBTItle(passthru)	///
		XUNITs(string)	*]	

	if ("`title'" == "") {
		if inlist("`oecmd'","lasso","sqrtlasso","elasticnet","") {
			local title "Coefficient paths"
		}
		else {
			local varabbrev = abbrev("`e(depvar)'",15)
			local title ///
				"Coefficient paths for `varabbrev'"
		}
		if "`subtitle'" == "" {
			if !missing(e(xfold_idx))  {
				local numxfold = e(xfold_idx)
				local subtitle "Cross-fitting fold: `numxfold'"
			}
			if !missing(e(resample_idx)) {
				local numresample = e(resample_idx)
				local subtitle ///
					"`subtitle', Resample: `numresample'" 
			}
			local subtitle subtitle(`"`subtitle'"')
		}
		local title title(`"`title'"')
	}

	if "`namelist'" != "" & "`xunits'" != "" {
		di as error "cannot specify c.v. input option with name"
		exit 198
	}
	
	if "`xunits'" == "" {
		local xunits l1norm
		local namelist l1norm
	}
	else if "`xunits'" == "l1norm" {
		local namelist l1norm 
	}
	else if "`xunits'" == "l1normraw" {
		local namelist l1normraw
	}
	else if "`xunits'" == "lnlambda" {
		local namelist lnlambda
	}
	else {
		ParseXunit, `xunits' 
		local namelist `r(nlist)'
	}
	if "`namelist'" == "rlnlambda" | "`namelist'" == "lnlambda" {
		qui sum lambda
		tempname max min
		scalar `max' = r(max)
		scalar `min' = r(min)
		if "`minmax'" != "" {
			local omin = r(min)
			local omax = r(max)
			local minmax			
		}
		// determine two points in 10 powers around max
		tempname maxabove maxbelow log10max
		scalar `log10max' = log10(`max')
		scalar `maxbelow' = floor(`log10max')
		scalar `maxabove' = ceil(`log10max')
		// determine two points in 10 powers around min
		tempname minabove minbelow log10min
		scalar `log10min' = log10(`min')
		scalar `minbelow' = floor(`log10min')
		scalar `minabove' = ceil(`log10min')

		local dist = `maxabove'-`minbelow'
                if `dist' > 4 {
                        local xperc .9
                }
                else {
                        local xperc .25
                }
		local xperchigh `xperc'
		local xperclow `xperc'
		if `dist' > 2 {
			local xperclow .95
		}
		// determine point that is x% below minabove in the range
		// 10^minbelow to 10^minabove
		tempname lowpointcutoff 
		scalar `lowpointcutoff' = 10^`minabove' - ///
			`xperclow'*(10^`minabove'-10^`minbelow')
		tempname scalemin
		if `min' < `lowpointcutoff' {
			local scalemin = `minbelow'
		}
		else {
			local scalemin = `minabove'
		}
		// determine point that is x% above maxbelow in the range
		// 10^maxbelow to 10^maxabove
		tempname highpointcutoff 
		scalar `highpointcutoff' = 10^`maxbelow' + ///
			`xperchigh'*(10^`maxabove'-10^`maxbelow')
		if `max' > `highpointcutoff' {
			local scalemax = `maxabove'
		}
		else {
			local scalemax = `maxbelow'
		}
		forvalues k = `scalemin'/`scalemax' {
			local num = 10^`k'
			if "`omin'" != "" {
				if `num' < `omin' {
					local num 
				}
				else if `num' > `omax' {
					local num
				}
			}
			local lrange `lrange' `num'
		}
		if "`omin'" != "" {
			local first: word 1 of `lrange'
			if reldif(`first',`omin') < .001 {
				gettoken first lrange: lrange
			}
		}
		if wordcount("`lrange'") == 1  & "`omin'" == "" {
			local log10 = log10(`lrange')
			local extra1 = 10^(`log10'-1)
			local extra2 = 10^(`log10'+1)
			if reldif(`extra1',`lrange') < ///
				reldif(`extra2',`lrange') {
				local lrange `lrange' `extra1'
			}
			else {
				local lrange `lrange' `extra2'
			}		
		}
		if "`omin'" != "" {
			if "`first'" == "" {
				local first: word 1 of `lrange'
			}
			local fc = wordcount("`lrange'")
			local last: word `fc' of `lrange'
			if round(`first',1) == `first' {
				local omin = ///
				round(`omin',.01) 
			}
			else {
				if `omin' < `first' {
					local omin = 		///
						round(`omin',   ///
						10^(log10(`first')-1))
				}
				else {
					local omin = 		///
						round(`omin',   ///
						10^(log10(`first')))
				}
			}
			if round(`last',1) == `last' {
				local omax = ///
				round(`omax',.01) 				
			}
			else {
				if `omax' > `last' {
					local omax =	///
					round(`omax',	///
					10^(log10(`last')))
				}
				else {
					local omax = 	///
					round(`omax',	///
					10^(log10(`last')-1))
				}
			}			
			local lrange `omin' `omax' `lrange' 
		}	
		if "`namelist'" == "rlnlambda" {
			local scalemin = 10^`scalemin'
			local scalemax = 10^`scalemax'
			local ranger
			if wordcount("`lrange'") == 2 {
				local ranger range(`scalemin' `scalemax')
			}
			local xaxisopts xscale(log reverse `ranger') ///
				xtitle("{&lambda}")
		}
		else {
			local scalemin = 10^`scalemin'
			local scalemax = 10^`scalemax'
			local ranger
			if wordcount("`lrange'") == 2 {
				local ranger range(`scalemin' `scalemax')
			}
			local xaxisopts xscale(log `ranger') ///
				xtitle("{&lambda}")
		}
		local xaxisopts `xaxisopts' xlabel(`lrange')	
		local namelist lambda
	}
	else if "`minmax'" != "" {
		qui sum `namelist' 
		local omin = r(min)
		local omax = r(max)
		local omin = strofreal(`omin',"%9.2f")
 		local omax = strofreal(`omax',"%9.2f")
		local minmax xlabel(`omin' `omax')		
	}
						//  common options
	marksample touse	
	_lassogph_common_parse  `namelist' ,	///
		touse(`touse')			///
		`i'				///
		`legend'			///
		`note'		
	local xvar `s(xvar)'
	local iff `s(iff)'
	local iff_enp `s(iff_enp)'
	local legend `s(legend)'
	local note `s(note)'

						// get xvar
	if ("`get_xvar'" == "get_xvar") {
		sret local xvar `xvar'
		exit
		// NotReached
	}
						//  coeff_name
	ParseCoefname, `subspace'
	local coef_name `s(coef_name)'
	local wc = wordcount("`coef_name'")
	if `wc' > 99 {
		local mono mono
	}
	// Standardize coefficients
	if "`rawcoefs'" == "" {
		_lasso_get_lchar, `subspace'
		local scales `s(sd_X)'
		local coef_names `coef_name'
		local wc = wordcount("`coef_name'")		
		forvalues i = 1/`wc' {
			gettoken scale scales: scales
			gettoken coefname coef_names: coef_names
			qui replace `coefname' = `coefname'*`scale'
			if `i' == 1 {
				local first `coefname'
			}
			if `i' == `wc' {
				local last `coefname'
			}
		}
		local dnote "All of the coefficients stored in "
		local dnote "`dnote'{bf:`first'}-{bf:`last'} are "
		local dnote "`dnote'standardized."  
		note: `dnote'
	}
	else {
		local coef_names `coef_name'
		local wc = wordcount("`coef_name'")	
		forvalues i = 1/`wc' {
			gettoken coefname coef_names: coef_names
			if `i' == 1 {
				local first `coefname'
			}
			if `i' == `wc' {
				local last `coefname'
			}
		}
		local dnote "All of the coefficients stored in "
		local dnote "`dnote'{bf:`first'}-{bf:`last'} are "
		local dnote "`dnote'unstandardized."  
		note: `dnote'
	}	
	if `"`data'"' != "" {
		label data "Data saved by coefpath"
		noi save `data'
	}	

						//  ytitle
	ParseYtitle , `ytitle' `rawcoefs'
	local ytitle `s(ytitle)'
	local ytitle_short `s(ytitle_short)'
						//  xytitle
	if(`"`xytitle'"' == "xytitle") {
		local enp_title b1title("`:var label `xvar''", size(small)) ///
			l1title(`ytitle_short', size(small))
		sret local enp_title `enp_title'
		exit
		// NotReached
	}
						// check if xscale	
	CheckReverse , `options'
	local reverse `s(reverse)'
						//  labelpath
	ParseLabelpath , xvar(`xvar') 		///
		coef_name(`coef_name')		///
		reverse(`reverse')		///
		`labelpath1' 			///
		`labelpath'
	local lbpath_opts `s(lbpath_opts)'
	if "`mono'" == "" {
		local wc = wordcount("`coef_name'")
		local parseit `parseit' lineopts(string)
		forvalues i = 1/`wc' {
			local parseit `parseit' line`i'opts(string)
		}
	}
	local parseit `parseit' *
	local 0, `options'
	syntax, [`parseit']

	_get_gropts, graphopts(`options')
	local options `"`s(graphopts)'"'
	_check4gropts rlopts, opt(`rlopts')
	if "`mono'" == "" {
		local wc = wordcount("`coef_name'")
		_check4gropts lineopts, opt(`lineopts')
		forvalues i = 1/`wc' {
			_check4gropts line`i'opts, opt(`line`i'opts')
		}
	}
	else {
		_check4gropts monoopts, opt(`monoopts')
	}
					//  parse norefline
	ParseRefline , `refline' rlopts(`rlopts')
	local yline `s(yline)'

	if "`mono'" != "" {
		qui keep `iff'
		local wcp1 = wordcount("`coef_name'")+1
		tempname varnum
		qui reshape long var, i(id) j(`varnum')
		sort `varnum', stable
		tempvar exper
		qui by `varnum': gen `exper' = _n == _N
		qui replace `exper' = `exper'*2
		qui expand `exper'
		sort `varnum' `exper', stable
		qui by `varnum': replace var = . if _n == _N
		line var `xvar' if `varnum' != `wcp1', 	///
			cmissing(n) lcolor(blue%35) ///
			`monoopts' `yline' `ytitle' ///
			`legend' `note' `options' ///
			`xaxisopts' `minmax' `title' `subtitle'			
	}
	else {
		local wc = wordcount("`coef_name'")
		local plots 
		local dv `coef_name'
		forvalues i = 1/`wc' {
			gettoken dv1 dv: dv
			local plots `plots' (line `dv1' `xvar', ///
				`lineopts' `line`i'opts')
		}
						//  draw coefficients path
		twoway `plots' `iff',		///
			`yline'			///
			`ytitle'		///
			`legend'		///
			`note'			///
			`lbpath_opts'		///
			`xaxisopts'		///
			`title'			///
			`subtitle'		///
			`options' `minmax'			
	}
		
	restore		// preserve end
end
					//----------------------------//
					// Parse yline
					//----------------------------//
program ParseRefline, sclass
	syntax [, noREFline rlopts(string)]
	if "`refline'" == "norefline" & `"`rlopts'"' != "" {
		opts_exclusive "norefline rlopts()"
	}
	else if `"`refline'"' != "norefline" & `"`rlopts'"' == "" {
		local yline yline(0, lcolor("scheme foreground")) 
	}
	else if `"`refline'"' != "norefline" {
		local yline yline(0, `rlopts')
	}	
	sret local yline `yline'
end
					//----------------------------//
					// Parse ytitle
					//----------------------------//
program ParseYtitle, sclass
	syntax [, ytitle(passthru) rawcoefs]

	if (`"`ytitle'"' == "") {
		if "`rawcoefs'" != "" {
			local ytitle_short Coefficients
		}
		else {
			local ytitle_short Standardized coefficients
		}
		local ytitle ytitle(`ytitle_short')
	}
	sret local ytitle `ytitle'
	sret local ytitle_short `ytitle_short'
end
					//----------------------------//
					// ParseShownonzero
					//----------------------------//
program ParseShownonzero, sclass
	syntax [if] , xvar(string) [shownonzero]
	if (`"`shownonzero'"' == "") {
		exit
		// NotReached
	}

	local xaxis xaxis(1 2)	
	sum id `if', meanonly
	local min = r(min)
	local max = r(max)
	local df0 = -1 
	forvalues i=`min'/`max' {
		local df1 `=nonzero[`i']'
		if (`df1' > `df0') {
			local lbl	///
			`"`lbl' `=`xvar'[`i']' "`=nonzero[`i']'" "'
		}
		local df0 = `df1'
	}
	local xlabel2 xlabel(`lbl', axis(2) labsize(tiny))
	local xtitle2 xtitle("", axis(2))

	sret local nonzero_opts `xaxis' `xlabel2' `xtitle2'
end
					//----------------------------//
					// parse labelpath
					//----------------------------//
program ParseLabelpath, sclass
	syntax , xvar(string)		///
		coef_name(string)	///
		reverse(string)		///
		[labelpath1		///
		labelpath(string)]

	if (`"`labelpath1'"' == "" & `"`labelpath'"' == "") {
		exit
		// NotReached
	}

	if (`"`labelpath'"' !="") {
		local 0 , `labelpath'
		cap syntax , label
		if _rc {
			di as err "option {bf:labelpath(label)} "	///
				"incorrectly specified"
			exit 198
		}
		local lb = 1
	}
	else {
		local lb = 0
	}

	qui sum `xvar'
	local xmax = r(max)
	local xmin = r(min)

	if ("`xvar'" != "lambda" & "`xvar'" != "lnlambda") {
		local xvalue `xmax'
		local xscale xscale(range(`xmin' `=1.2*`xmax''))
		local place place(e)
		if (`reverse') {
			local place place(w)
		}
	}
	else if (`"`xvar'"' == "lnlambda" ) {
		local xvalue `xmin'
		local xscale xscale(range(`=1.2*`xmin'' `xmax'))
		local place place(w)
		if (`reverse') {
			local place place(e)
		}
	}
	else if (`"`xvar'"' == "lambda") {
		local xvalue `xmin'
		local xscale xscale(range(-0.5 `xmax'))
		local place place(w)
		if (`reverse') {
			local place place(e)
		}
	}

	mata : get_ymax(`"`coef_name'"', `=_N')
	foreach var of local coef_name {
		local yvalue `=`var'[_N]'
		if (`lb'== 0) {
			local path_name `var'
		}
		else {
			local path_name : variable label `var'
		}
		if ( `=abs(`yvalue')/`ymax'' > 0.1) {
			local size size(small)
		}
		else {
			local size size(tiny)   
		}
		local text `text' text(`yvalue' `xvalue'	///
			"`path_name'",  `size' `place')	
	}

	sret local lbpath_opts `xscale' `text'
end

					//----------------------------//
					// check if xscale is reverse
					//----------------------------//
program CheckReverse, sclass
	syntax [, *]

	local reverse = regexm("`options'", ".*xscale(.*reverse.*).*")
	local noreverse = 0

	if (`reverse') {
		local noreverse = 	///
			regexm("`options'", ".*xscale(.*noreverse.*).*")
	}

	if (`noreverse') {
		local reverse = 0
	}

	sret local reverse `reverse'
end
					//----------------------------//
					// parse coefname
					//----------------------------//
program ParseCoefname, sclass
	syntax [, subspace(passthru) ]
	_lasso_get_lchar, `subspace'
	local coef_name `s(coef_name)'

	local n_k : word count `coef_name'
	sret local coef_name `coef_name'
end

program ParseXunit, rclass
	capture syntax [, RLNLAMbda LNLAMbda]
	if _rc {
		di as error "{bf:xunits()} invalid`0' is not a valid scale"
		exit 198	
	}
	if "`rlnlambda'" != "" & "`lnlambda'" != "" {
		opts_exclusive "lnlambda rlnlambda"
	}
	return local nlist `rlnlambda'`lnlambda'	
end

mata :
mata set matastrict on
					//----------------------------//
					// get the right end point of y
					//----------------------------//
void get_ymax(			///
	string scalar ys, 	///
	real scalar idx)
{
	real vector	yvec
	real scalar	ymax

	yvec = st_data(idx, ys)
	ymax = max(abs(yvec))
	st_local("ymax", strofreal(ymax))
}
end
