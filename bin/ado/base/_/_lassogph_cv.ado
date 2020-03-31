*! version 1.0.8  13jun2019
program _lassogph_cv
	version 16.0

	if (`"`e(cmd)'"'!="lasso" &		///
		`"`e(cmd)'"' != "sqrtlasso"  &	///
		`"`e(cmd)'"' != "elasticnet" ) {
		di as err "last estimates not found"
		exit 301
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
					// Draw C.V graph
					//----------------------------//
program Draw, sclass

	preserve				// preserve start

	syntax [anything(everything)]	///
		[, laout(passthru)	/// Not Documented
		subspace(passthru)	///
		*]

	local oecmd `e(oecmd)'
	_lasso_useresult, clear `laout'	`subspace'	//  load result

						//  syntax
	syntax [name] [if] [in],[ SELINEe *]
	
	syntax [name]			/// Not Documented
		[if] [in]		/// Not Documented
		[,			///
		i(passthru)		/// Not Documented
		get_xvar		/// Not Documented
		xytitle			/// Not Documented
		laout(passthru)		/// Not Documented
		subspace(passthru)	/// Not Documented
		legend(passthru)	///
		note(passthru)		///
		YTItle(passthru)	///
		XUNITs(string)		///
		noSELINE		///
		nolsline		///
		nocvline		///
		data(string asis)	///
		hrefline		///
		minmax			///
		TItle(passthru)		///
		SUBTItle(passthru)	///
		se	*]

	local drawcv
	if "`cvline'" != "nocvline" {
		local drawcv drawcv
	}

	if "`selinee'" != ""  & "`seline'" != "" {
		opts_exclusive "seline noseline"
		exit 198
	}
	if "`selinee'" != "" {
		local seline seline
	}
	else if "`seline'" == "noseline" {
		local seline 
	}
	else if (e(serule))  {
		local seline seline
	}

	if ("`title'" == "") {
		if inlist("`oecmd'","lasso","sqrtlasso","elasticnet","") {
			if "`se'" == "" {
				local title "Cross-validation plot"
			}
			else {
				local title ///
				"Cross-validation plot with 1 SE bounds"
			}			
		}
		else {
			local varabbrev = abbrev("`e(depvar)'",15)
			if "`se'" == "" {
				local title ///
				"Cross-validation plot for `varabbrev'"
			}
			else {
				local title ///
		"Cross-validation plot for `varabbrev' with 1 SE bounds"
			}				
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

	local onote `"`note'"'

	if `"`data'"' != "" {
		label data "Data saved by cvplot"
		qui save `data'
	}	

	if "`namelist'" != "" & "`xunits'" != "" {
		di as error "cannot specify c.v. input option with name"
		exit 198
	}
	
	if "`xunits'" == "" {
		local namelist rlnlambda
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
		local namelist  `r(nlist)'
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
		if wordcount("`lrange'") == 1 & "`omin'" == "" {
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

	CheckCV					// check cv

	marksample touse			// marksample

						//  common options
	_lassogph_common_parse  `namelist' ,	///
		`drawcv'			///
		touse(`touse')			///
		`i'				///
		`legend'			///
		`note'				
	local snote `s(snote)'
	local xvar `s(xvar)'
	local iff `s(iff)'
	local note `s(note)'
	local legend `s(legend)'
						//  get xvar
	if ("`get_xvar'" == "get_xvar") {
		sret local xvar `xvar'
		exit
		// NotReached
	}

						//  ytitle
	ParseYtitle , `ytitle'
	local ytitle `s(ytitle)'
	local ytitle_short `s(ytitle_short)'

	_get_gropts, graphopts(`options') 	///
		getallowed(SEOPts SELINEOPts 	///
		LSLINEOPts CVLINEOPts RLABelopts LINEOPts) 
	local options `"`s(graphopts)'"'
	local seopts `"`s(seopts)'"'
	local selineopts `"`s(selineopts)'"'
	local cvlineopts `"`s(cvlineopts)'"'
	local lslineopts `"`s(lslineopts)'"'
	local rlabelopts `"`s(rlabelopts)'"'
	local lineopts  `"`s(lineopts)'"'
	if "`lslineopts'" != "" & "`lsline'" == "nolsline" {
		opts_exclusive "nolsline lslineopts()"
	}
	if "`cvlineopts'" != "" & "`cvline'" == "nocvline" {
		opts_exclusive "nocvline cvlineopts()"
	}

	local rcap
	if "`by'" != "" {
		di as error "option {bf:by()} not allowed"
		exit 198		
	}
	_check4gropts seopts, opt(`seopts')
	_check4gropts selineopts, opt(`selineopts')
	_check4gropts cvlineopts, opt(`cvlineopts')
	_check4gropts lslineopts, opt(`lslineopts')
	_check4gropts rlabelopts, opt(`rlabelopts')
	_check4gropts lineopts, opt(`lineopts')
	if "`se'" != "" {
		local rcap ///
		(rcap cvmp1sd cvmm1sd `xvar' `iff', msize(vsmall) `seopts')
	}
	
					//  nonzero options
	ParseNonzero , xvar(`xvar') `i' 	///
		selineopts(`selineopts')	///
		cvlineopts(`cvlineopts')	///
		lslineopts(`lslineopts')	///
		rlabelopts(`rlabelopts')	///
		`seline' `note' `lsline' 	///
		`snote'				///
		`cvline' `hrefline' onote(`onote')

	local nonzero_opts `s(nonzero_opts)'
	local ytitle_short `s(ytitle_short)'
						//  xytitle
	if(`"`xytitle'"' == "xytitle") {
		local enp_title b1title("`:var label `xvar''", size(small)) ///
			l1title(`ytitle_short', size(small))
		sret local enp_title `enp_title'
		sret local xvar `xvar'
		exit
		// NotReached
	}
						// draw CV
	twoway (line cvm `xvar' `iff', `xaxisopts' `minmax' 	///
		xaxis(1 2) `lineopts' xscale(noline axis(2)))	///
		`rcap',  `ytitle' 				///
		`legend'					///
		`nonzero_opts'					///
		`options'					///
		`title' `subtitle'

	restore					// preserve end
end
					//----------------------------//
					// Parse ytitle
					//----------------------------//
program ParseYtitle, sclass
	syntax [, ytitle(passthru)]

	if (`"`ytitle'"' == "") {
		local ytitle_short "Cross-validation function"
		local ytitle ytitle(`ytitle_short')
	}
	sret local ytitle `ytitle' 
	sret local ytitle_short `ytitle_short'
end
					//----------------------------//
					// Parse nonzero
					//----------------------------//
program ParseNonzero, sclass
	syntax , xvar(string) [i(string) 		///
				selineopts(string) 	///
				cvlineopts(string)	///
				lslineopts(string)	///
				rlabelopts(string) 	///
				seline 			///
				nolsline		///
				nocvline		///
				note(string)		///
				onote(string)		///
				hrefline snote]
	local select 
	local drawcv
	if "`cvline'" != "nocvline"  & "`e(sel_crit_orig)'" != "not sel." {
		local drawcv drawcv
	}
	// check for serule and ls
	if (~missing(e(ID_sel))  & "`lsline'" != "nolsline") & ///
		"`e(sel_criterion)'" == "user" {
		local select select 
	} 
	local id_cv : char _dta[ID_cv`i']
	if "`seline'" != "" {
		local id_sd1 : char _dta[ID_serule`i']
	}
	if "`select'" != "" {	
		local sel_idx : char _dta[sel_idx]
	}

	if "`select'" != "" & ("`sel_idx'" == "`i'" | "`i'" == "") {
		local id_sel : char _dta[ID_sel]
	}
	else {
		local select
	}
	local seliscv
	if "`id_sel'" == "`id_cv'" & "`drawcv'" != "" {
		local seliscv seliscv
	}
	local selisse
	if "`id_sd1'" == "`id_sel'" & "`seline'" != "" {
		local selisse selisse
	}

	local selineopts lstyle(cvseline) `selineopts'
	local lslineopts lstyle(cvlsline) `lslineopts'
	local cvlineopts lstyle(cvcvline) `cvlineopts'	

	if "`drawcv'" != "" {
		local xline xline(`=`xvar'[`id_cv']' , `cvlineopts') 
	}
	if "`seline'" != ""  {
		local xline `xline' xline(`=`xvar'[`id_sd1']' , `selineopts')	
	}
	
	if (("`select'" != "" & (`"`id_sel'"' != "" ///
		& `"`id_sel'"' != `"`id_cv'"')) | ///
		("`select'" != "" & "`drawcv'" == "")) & /// 
		"`selisse'`seliscv'" == "" {
		local xline `xline'	///
			xline(`=`xvar'[`id_sel']' , `lslineopts')	
	}
						//  yline
	local cvm_sd1 : char _dta[cvm_serule`i']
	local cvm_min : char _dta[cvm_min`i']
	if ("`seline'" != ""  & "`hrefline'" != "")  {
		local yline yline(`cvm_sd1' , 	///
			`selineopts')		
	}
	if "`drawcv'" != "" & "`hrefline'" != "" {
		local yline `yline' yline(`cvm_min' , `cvlineopts')
	}
	if ((("`select'" != "" & (`"`id_sel'"' != "" & 		///
			`"`id_sel'"' != `"`id_cv'"')) | 	///
 		("`select'" != "" & "`drawcv'" == "")) & 	///
		"`hrefline'"!="") & "`selisse'`seliscv'" == "" {
		local charsel = cvm[`id_sel']
		local yline `yline'	///
			yline(`charsel' , `lslineopts')	
	}
	if "`drawcv'" != "" {
		if "`e(sel_crit_orig)'" == "CV min." {
			local lbl ///
			`"`lbl' `=`xvar'[`id_cv']' "{&lambda}{sub:CV}" "'
		}
		else if "`e(sel_crit_orig)'" == "stop" {
			local lbl ///
			`"`lbl' `=`xvar'[`id_cv']' "{&lambda}{sub:stop}" "'
		}
		else if "`e(sel_crit_orig)'" == "grid min." {
			local lbl ///
			`"`lbl' `=`xvar'[`id_cv']' "{&lambda}{sub:gmin}" "'
		}
		else {
			local lbl ///
			`"`lbl' `=`xvar'[`id_cv']' "{&lambda}{sub:CV}" "'
		}
	}
	if (("`select'" != "" & (`"`id_sel'"' != "" & 		///
			`"`id_sel'"' != `"`id_cv'"')) | 	///
		("`select'" != "" & "`drawcv'" == "")) & 	///
		"`selisse'`seliscv'" == "" {
		local lbl `"`lbl' `=`xvar'[`id_sel']' "{&lambda}{sub:LS}" "'
	}
	if "`seline'" != "" {
		local lbl `"`lbl' `=`xvar'[`id_sd1']' "{&lambda}{sub:SE}" "'
	}
	if `"`lbl'"' != "" {
		local xlabel2 xlabel(`lbl', axis(2) noticks `rlabelopts') 
	}
	else {
		local xlabel2 xlabel("", axis(2) noticks `rlabelopts') 
	}

	
	local xtitle2 xtitle("", axis(2))
	local l2 = `xvar'[`id_cv']
	local l: display %9.2g `l2'
	local l = ltrim("`l'")
	local nnz = "`=k_selected[`id_cv']'"
	if "`drawcv'" != "" {
		if "`e(sel_crit_orig)'" == "CV min." {
			local cvm ///
			`"{&lambda}{sub:CV}  Cross-validation minimum lambda.  {&lambda}=`l', # Coefficients=`nnz'."'
		}
		else if "`e(sel_crit_orig)'" == "stop" {
			local cvm ///
			`"{&lambda}{sub:stop}  Stopping tolerance reached.  {&lambda}=`l', # Coefficients=`nnz'."'
		}
		else if "`e(sel_crit_orig)'" == "grid min." {
			local cvm ///
			`"{&lambda}{sub:gmin}  Grid minimum reached.  {&lambda}=`l', # Coefficients=`nnz'."'
		}
		else {
			local cvm ///
			`"{&lambda}{sub:CV}  Cross-validation minimum lambda.  {&lambda}=`l', # Coefficients=`nnz'."'
		}
	}

	if "`select'" != "" & "`seliscv'" != "" {
		local l2 = `xvar'[`id_cv']
		local l: display %9.2g `l2'
		local l = ltrim("`l'")
		local nnz = "`=k_selected[`id_cv']'"
		if "`e(sel_crit_orig)'" == "CV min." {
			local cvsel ///
			`"{&lambda}{sub:CV}  {bf:lassoselect} specified lambda.  {&lambda}=`l', # Coefficients=`nnz'."'
		}
		else if "`e(sel_crit_orig)'" == "stop" {
			local cvsel ///
			`"{&lambda}{sub:stop}  {bf:lassoselect} specified lambda.  {&lambda}=`l', # Coefficients=`nnz'."'
		}
		else if "`e(sel_crit_orig)'" == "grid min." {
			local cvsel ///
			`"{&lambda}{sub:gmin}  {bf:lassoselect} specified lambda.  {&lambda}=`l', # Coefficients=`nnz'."'
		}
		else {
			local cvsel ///
			`"{&lambda}{sub:CV}  {bf:lassoselect} specified lambda.  {&lambda}=`l', # Coefficients=`nnz'."'
		}		
	}
	else if ("`select'" != "" & "`selisse'" != "")  & "`drawcv'" != "" {
		local l2 = `xvar'[`id_sel']
		local l: display %9.2g `l2'
		local l = ltrim("`l'")
		local nnz = "`=k_selected[`id_sel']'"
	 	if "`e(sel_crit_orig)'" == "CV min." {
			local cvsel ///
			`"{&lambda}{sub:SE}  {bf:lassoselect} specified lambda.  {&lambda}=`l', # Coefficients=`nnz'."'
		}
		else if "`e(sel_crit_orig)'" == "stop" {
			local cvsel ///
			`"{&lambda}{sub:SE}   {bf:lassoselect} specified lambda.  {&lambda}=`l', # Coefficients=`nnz'."'
		}
		else if "`e(sel_crit_orig)'" == "grid min." {
			local cvsel ///
			`"{&lambda}{sub:SE}   {bf:lassoselect} specified lambda.  {&lambda}=`l', # Coefficients=`nnz'."'
		}
		else {
			local cvsel ///
			`"{&lambda}{sub:SE}  {bf:lassoselect} specified lambda.  {&lambda}=`l', # Coefficients=`nnz'."'
		}	
	}
	else if ("`select'" != "" & "`selisse'" != "") {
		local l2 = `xvar'[`id_sel']
		local l: display %9.2g `l2'
		local l = ltrim("`l'")
		local nnz = "`=k_selected[`id_sel']'"
		if "`snote'" != "" {
			if "`e(sel_crit_orig)'" == "grid min." {
			local cvsel ///
		`"{&lambda}{sub:SE}    {bf:lassoselect} specified lambda.  {&lambda}=`l', # Coefficients=`nnz'."'
			}
			else {
			local cvsel ///
		`"{&lambda}{sub:SE}   {bf:lassoselect} specified lambda.  {&lambda}=`l', # Coefficients=`nnz'."'
			}
		}
		else {
			local cvsel ///
		`"{&lambda}{sub:SE}  {bf:lassoselect} specified lambda.  {&lambda}=`l', # Coefficients=`nnz'."'
		}
				
	}
	else if "`select'" != "" & "`drawcv'" != "" {
		local l2 = `xvar'[`id_sel']
		local l: display %9.2g `l2'
		local l = ltrim("`l'")
		local nnz = "`=k_selected[`id_sel']'"
	 	if "`e(sel_crit_orig)'" == "CV min." {
			local cvsel ///
			`"{&lambda}{sub:LS}   {bf:lassoselect} specified lambda.  {&lambda}=`l', # Coefficients=`nnz'."'
		}
		else if "`e(sel_crit_orig)'" == "stop" {
			local cvsel ///
			`"{&lambda}{sub:LS}    {bf:lassoselect} specified lambda.  {&lambda}=`l', # Coefficients=`nnz'."'
		}
		else if "`e(sel_crit_orig)'" == "grid min." {
			local cvsel ///
			`"{&lambda}{sub:LS}    {bf:lassoselect} specified lambda.  {&lambda}=`l', # Coefficients=`nnz'."'
		}
		else {
			local cvsel ///
`"{&lambda}{sub:LS}   {bf:lassoselect} specified lambda.  {&lambda}=`l', # Coefficients=`nnz'."'
		}	
	}
	else if "`select'" != "" {
		local l2 = `xvar'[`id_sel']
		local l: display %9.2g `l2'
		local l = ltrim("`l'")
		local nnz = "`=k_selected[`id_sel']'"
		if "`snote'" != "" {
			if "`e(sel_crit_orig)'" == "grid min." {
			local cvsel ///
		`"{&lambda}{sub:LS}    {bf:lassoselect} specified lambda.  {&lambda}=`l', # Coefficients=`nnz'."'
			}
			else {
			local cvsel ///
		`"{&lambda}{sub:LS}   {bf:lassoselect} specified lambda.  {&lambda}=`l', # Coefficients=`nnz'."'
			}
		}
		else {
			local cvsel ///
		`"{&lambda}{sub:LS}  {bf:lassoselect} specified lambda.  {&lambda}=`l', # Coefficients=`nnz'."'
		}
	}

	if "`seline'" != "" & "`drawcv'" != "" {
		local l2 = `xvar'[`id_sd1']
		local l: display %9.2g `l2'
		local l = ltrim("`l'")
		local nnz = "`=k_selected[`id_sd1']'"
	 	if "`e(sel_crit_orig)'" == "CV min." {
			local cvse ///
			`"{&lambda}{sub:SE}  Standard-error-rule lambda.  {&lambda}=`l', # Coefficients=`nnz'."'
		}
		else if "`e(sel_crit_orig)'" == "stop" {
			local cvse ///
			`"{&lambda}{sub:SE}   Standard-error-rule lambda.  {&lambda}=`l', # Coefficients=`nnz'."'
		}
		else if "`e(sel_crit_orig)'" == "grid min." {
			local cvse ///
			`"{&lambda}{sub:SE }   Standard-error-rule lambda.  {&lambda}=`l', # Coefficients=`nnz'."'
		}
		else {
			local cvse ///
`"{&lambda}{sub:SE}  Standard-error-rule lambda.  {&lambda}=`l', # Coefficients=`nnz'."'
		}					
	}
	else if "`seline'" != "" {
		local l2 = `xvar'[`id_sd1']
		local l: display %9.2g `l2'
		local l = ltrim("`l'")
		local nnz = "`=k_selected[`id_sd1']'"
		if "`snote'" != "" {
			if "`e(sel_crit_orig)'" == "grid min." {
			local cvse ///
`"{&lambda}{sub:SE}    Standard-error-rule lambda.  {&lambda}=`l', # Coefficients=`nnz'."'
			}
			else {
			local cvse ///
`"{&lambda}{sub:SE}   Standard-error-rule lambda.  {&lambda}=`l', # Coefficients=`nnz'."'
			}
		}
		else {
			local cvse ///
`"{&lambda}{sub:SE}  Standard-error-rule lambda.  {&lambda}=`l', # Coefficients=`nnz'."'
		}
	}

	if "`note'" == "" & "`cvm'" == "" & "`cvsel'" == "" & "`cvse'" == "" {
		local note 
	}
	else if "`note'" == "" & ///
		"`cvm'" == "" & "`cvsel'" != "" & "`cvse'" == "" {
		local note note(`"`cvsel'"')
	}
	else if "`note'" == "" & ///
		"`cvm'" != "" & "`cvsel'" == "" & "`cvse'" == "" {
		local note note(`"`cvm'"')
	}
	else if "`note'" == "" & ///
		"`cvm'" != "" & "`cvsel'" != "" & "`cvse'" == "" {
		local note note(`"`cvm'"' `"`cvsel'"')
	}
	else if "`note'" != "" & ///
		"`cvm'" == "" & "`cvsel'" == "" & "`cvse'" == "" {
		local note note(`"`note'"')
	}
	else if "`note'" != "" & ///
		"`cvm'" == "" & "`cvsel'" != "" & "`cvse'" == "" {
		local note note(`"`note'"' `"`cvsel'"')
	}
	else if "`note'" != "" & ///
		"`cvm'" != "" & "`cvsel'" == "" & "`cvse'" == "" {
		local note note(`"`note'"' `"`cvm'"')
	}
	else if "`note'" != "" & ///
		"`cvm'" != "" & "`cvsel'" != "" & "`cvse'" == "" {
		local note note(`"`note'"' `"`cvm'"' `"`cvsel'"')
	}
	else if "`note'" == "" & ///
		"`cvm'" == "" & "`cvsel'" == "" & "`cvse'" != "" {
		local note note(`"`cvse'"')
	}
	else if "`note'" == "" & ///
		"`cvm'" == "" & "`cvsel'" != "" & "`cvse'" != "" {
		local note note(`"`cvse'"' `"`cvsel'"')
	}
	else if "`note'" == "" & ///
		"`cvm'" != "" & "`cvsel'" == "" & "`cvse'" != "" {
		local note note(`"`cvm'"' `"`cvse'"')
	}
	else if "`note'" == "" & ///
		"`cvm'" != "" & "`cvsel'" != "" & "`cvse'" != "" {
		local note note(`"`cvm'"' `"`cvse'"' `"`cvsel'"')
	}
	else if "`note'" != "" & ///
		"`cvm'" == "" & "`cvsel'" == "" & "`cvse'" != "" {
		local note note(`"`note'"' `"`cvse'"')
	}
	else if "`note'" != "" & ///
		"`cvm'" == "" & "`cvsel'" != "" & "`cvse'" != "" {
		local note note(`"`note'"' `"`cvse'"' `"`cvsel'"')
	}
	else if "`note'" != "" & ///
		"`cvm'" != "" & "`cvsel'" == "" & "`cvse'" != "" {
		local note note(`"`note'"' `"`cvm'"' `"`cvse'"')
	}
	else if "`note'" != "" & ///
		"`cvm'" != "" & "`cvsel'" != "" & "`cvse'"!="" {
		local note note(`"`note'"' `"`cvm'"' `"`cvse'"' `"`cvsel'"')
	}
	if "`onote'" != "" {
		sret local nonzero_opts `xline' `yline' `xlabel2' ///
			`xtitle2' `onote'	
	}
	else {
		sret local nonzero_opts `xline' `yline' `xlabel2' ///
			`xtitle2' `note'	
	}
end
					//----------------------------//
					// Check CV
					//----------------------------//
program CheckCV
	if (e(cv) == 0) {
		di as err "{p 0 4 2}{bf:cvplot} requires "
		di as err "{bf:selection(cv)} or "
		di as err "{bf:selection(adaptive)}{p_end}"
		exit 498
	}
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
