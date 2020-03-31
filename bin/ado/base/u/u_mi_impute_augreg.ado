*! version 1.0.2  04feb2015
/*
	augmented regression for -logit-, -ologit-, and -mlogit-
	used by -mi impute, augment-
	Usage:
		u_mi_impute_augreg <cmdline>
	where the first token of the -cmdline- is -logit-, 
	-ologit-, or -mlogit-
*/
program u_mi_impute_augreg
	version 12
	gettoken cmd 0 : 0
	syntax varlist(fv) [if] [in] [fw pw] ,	FVSTUB(string) 		///
					     [  NOCONStant 		///
						NOFVLEGend		///
						didata(string asis)	///
						expnames(string)	///
						dropfvvars		///
						fvvars(varlist)		///
						*			///
					     ]
	local options `noconstant' `options'
	marksample touse

	gettoken dv varlist : varlist
	tempvar wgtaug toaug
	if ("`weight'"=="") {
		qui gen byte `wgtaug' = 1
		local wtype iweight
	}
	else {
		if ("`weight'"=="fweight") {
			local wtype iweight
		}
		else {
			local wtype `weight'
		}
		qui gen double `wgtaug' `exp'
		qui compress `wgtaug'
	}
	if (bsubstr("`cmd'",1,1)!="_") {
		local cmd _`cmd'
	}
	di
	if (`"`didata'"'=="") {
		local didata "on augmented data"
	}
	di as txt `"Running {bf:`cmd'} `didata':"'
	// handle FVs
	if ("`fvvars'"=="") {
		u_mi_impute_fv2var `varlist' if `touse', ///
						fvstub(`fvstub') `dropfvvars'
		local vars "`s(fvrevarlist)'"
		local fvvars "`s(fvvars)'"
	}
	else {
		local vars `varlist'
	}
	//_rmcoll call for output purpose
	_rmcoll `vars' if `touse' [`wtype'=`wgtaug'], forcedrop `noconstant'
	local vars `r(varlist)'
	u_mi_impute_diexpheader "`expnames'"
	// FV legend
	if ("`nofvlegend'"=="") {
		di
		u_mi_impute_difvheader "`fvvars'"
	}
	preserve
	qui _augment_data "`dv'" "`vars'" "`touse'" 	///
			  "`wtype'" "`wgtaug'" "`toaug'"
	qui count if `toaug'
	local Nadded = r(N)
	qui summ `wgtaug' if `toaug'
	local wgtsum = string(r(sum),"%9.0g")
	`cmd' `dv' `vars'  if `touse' | `toaug' [`wtype'=`wgtaug'], `options' 
	di as txt "{p 0 1 1}({res}`Nadded' {txt}pseudo observations"
	di as txt "with total weight {res}`wgtsum' {txt}used during"
	di as txt "estimation){p_end}"
end

program _augment_data
	args yvar xvars touse wtype wgtaug toaug
	if ("`wtype'"=="pweight") {
		local wtype aweight 
	}
	else { /* fweight */
		local wtype iweight
	}
	gen byte `toaug' = 0
	local p : word count `xvars'
	qui levelsof `yvar' if `touse', local(ylevels)
	local nlevels : word count `ylevels'
	local N = c(N)+2*`nlevels'*`p'
	local start = c(N)+1
	qui set obs `N'
	
	qui replace `touse' = 0 if `touse'==.
	qui replace `toaug' = 1 if `toaug'==.
	qui replace `wgtaug' = (`p'+1)/(2*`p'*`nlevels') if `toaug'==1
	mata: st_store(	range(`start',`N',1), 	///
			"`yvar'", 		///
			J(2*`p',1,1)#strtoreal(tokens(st_local("ylevels")))')
	if ("`e(offset)'"!="") {
		qui summ `e(offset)' if `touse' [`wtype'=`wgtaug']
		qui replace `e(offset)' = r(mean) if `toaug'
	}
	local end = `start'+`nlevels'-1
	foreach var of varlist `xvars' {
		qui summ `var' if `touse' [`wtype'=`wgtaug']
		qui replace `var' = r(mean) if `toaug'
		qui replace `var' = `var'+ r(sd) in `start'/`end'
		local start = `end'+1
		local end = `start'+`nlevels'-1
		qui replace `var' = `var'-r(sd) in `start'/`end'
		local start = `end'+1
		local end = `start'+`nlevels'-1
	}
end
