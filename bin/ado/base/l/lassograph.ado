*! version 1.0.7  28jan2020
program lassograph
	version 16.0

	if (`"`e(cmd)'"'!="lasso"		///
		& `"`e(cmd)'"'!="sqrtlasso"	///
		& `"`e(cmd)'"'!="elasticnet"	///
		& `"`e(cmd)'"'!="dsregress"	///
		& `"`e(cmd)'"'!="dslogit"	///
		& `"`e(cmd)'"'!="dspoisson"	///
		& `"`e(cmd)'"'!="poregress"	///
		& `"`e(cmd)'"'!="xporegress"	///
		& `"`e(cmd)'"'!="pologit"	///
		& `"`e(cmd)'"'!="xpologit"	///
		& `"`e(cmd)'"'!="popoisson"	///
		& `"`e(cmd)'"'!="xpopoisson"	///
		& `"`e(cmd)'"'!="poivregress"	///
		& `"`e(cmd)'"'!="xpoivregress" ) {	
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
					// Draw
					//----------------------------//
program Draw
	local ZERO `0'
						//  parse multiple plots
	_parse expand plots tmp : 0
	
	if (`plots_n' == 1) {
		DrawSingleGraph `0'
	}
	else if (`plots_n' > 1) {
		DrawMultiGraph `0'
	}
	else {
		NoGraphError
	}
end
					//----------------------------//
					// NoGraphError
					//----------------------------//
program NoGraphError
	di as err "must specify at least one of {bf:coefpath} " ///
		"or {bf:cvplot} in {bf:lassograph}"
	exit 198
end
					//----------------------------//
					// DrawSingleGraph
					//----------------------------//
program DrawSingleGraph
	_parse expand plots opts : 0
	_parse comma gph gphopts : plots_1
	if (`"`gphopts'"' == "") {
		local 0 `gph' , `opts_op'
	}
	else {
		local 0 `plots_1' `opts_op'
	}

	syntax anything(everything name=gph) ,	///
		[name(string)			///
		saving(string)			///
		ENPenalty(string)		///
		BYEnpenalty1			///
		BYEnpenalty(passthru)		///
		laout(passthru)			///
		for(passthru)			///
		xfold(passthru)			///
		resample(passthru)		///
		alpha(passthru)		*]

	if "`alpha'" != "" & "`e(cmd)'" != "elasticnet" {
		di as error "option {bf:alpha()} not allowed after {bf:`e(cmd)'}"
		exit 498
	}

	if "`alpha'" == "" { 
		if !missing(e(alpha_sel)) {
			local alpha = e(alpha_sel)
			local alpha alpha(`alpha')
		}		
	}
						// parse for	
	_lasso_check_for, estat_cmd(`gph') `for' `xfold' `resample'

	_lasso_est_for, `for' `xfold' `resample'
	local subspace subspace(`r(subspace)')
	
	local gph_opts `options' `laout' `subspace'
						//  parse enpenalty
	ParseEnp, `enpenalty' `laout' `subspace' `alpha'
	local enp_n = `s(enp_n)'
	local enp_list `s(enp_list)'
						//  parse bye	
	ParseBye , `byenpenalty1' `byenpenalty'
	local bye = `s(bye)'
	local bye_opts `s(bye_opts)'
						// n_res
	local n_res = e(n_res)
						//  parse name
	ParseName , bye(`bye') n_res(`n_res') : `name'
	local name_list `s(name_list)'
	local name_replace `s(name_replace)'

						//  parse saving
	ParseSaving, bye(`bye') n_res(`n_res') : `saving'
	local saving_list `s(saving_list)'
	local saving_replace `s(saving_replace)'
						
	if (`bye'==0) {				//  draw single graph separately
		DrawOneTypePlotNobye , 				///
			gph(`gph') 				///
			gph_opts(`gph_opts')			///
			name_list(`name_list')			///
			name_replace(`name_replace')		///
			saving_list(`saving_list')		///
			saving_replace(`saving_replace')	///
			bye(`bye')				///
			n_res(`n_res')				///
			enp_n(`enp_n')				///
			enp_list(`enp_list')			///
			nameorig(`name')			
	}
	else {					// combine bye
		DrawOneTypePlotBye , 				///
			gph(`gph') 				///
			gph_opts(`gph_opts')			///
			name_list(`name_list')			///
			name_replace(`name_replace')		///
			saving_list(`saving_list')		///
			saving_replace(`saving_replace')	///
			bye(`bye')				///
			bye_opts(`bye_opts')			///
			n_res(`n_res')				///
			enp_n(`enp_n')				///
			enp_list(`enp_list')			
	}
end
					//----------------------------//
					// ParseBye
					//----------------------------//
program ParseBye, sclass
	syntax [, byenpenalty1	///
		byenpenalty(string) ]

	if (`"`byenpenalty1'"' == "" & `"`byenpenalty'"' == "") {
		local bye = 0
	}
	else {
		local bye = 1
	}

	local bye_opts `byenpenalty'	// bye graph combine options

	sret local bye = `bye'
	sret local bye_opts `bye_opts'
end
					//----------------------------//
					// ParseName
					//----------------------------//
program ParseName, sclass
	_on_colon_parse `0'
	local before `s(before)'
	local after `s(after)'

	local 0 `before'
	syntax , bye(string) n_res(string)

	local 0 `after'
	syntax [namelist] [, replace]

	local name_replace `replace'
	local namelist : list uniq namelist
	local n_name : word count `namelist'
	local stub `namelist'

	if (`bye' == 1 | `n_res' == 1) {
		if (`n_name' == 0) {
			local name_list Graph__1
			local name_replace replace
		}
		else if (`n_name' == 1) {
			local name_list `stub'
		}
		else if (`n_name' > 1) {
			di as error "only one name is allowed"
			exit 198
		}
	}
	else {
		if (`n_name' == 0) {
			local name_list `name_list' Graph
			local name_replace replace
		}
		else if (`n_name' == 1) {
			forvalues i=1/`n_res' {
				if `n_res' == 1 {
					local name_list `name_list' `stub'
				}
				else {
					local name_list ///
						`name_list' `stub'__`i'
				}
			}
		}
		else if (`n_name' == `n_res') {
			local name_list `stub'
		}
		else {
			di as error "only one of `n_res' names is allowed"
			exit 198
		}
	}
	sret local name_list `name_list'
	sret local name_replace `name_replace'
end
					//----------------------------//
					// Parse Saving
					//----------------------------//
program ParseSaving, sclass
	_on_colon_parse `0'
	local before `s(before)'
	local after `s(after)'

	local 0 `before'
	syntax , bye(string) n_res(string)

	local 0 `after'
	syntax [namelist] [, replace]

	local saving_replace `replace'
	local namelist : list uniq namelist
	local n_name : word count `namelist'
	local stub `namelist'

	if (`bye' == 1 | `n_res' == 1) {
		if (`n_name' == 1) {
			local saving_list `stub'
		}
		else if (`n_name' > 1) {
			di as error "only one name is allowed"
			exit 198
		}
	}
	else {
		if (`n_name' == 1) {
			forvalues i=1/`n_res' {
				local saving_list `saving_list' `stub'__`i'
			}
		}
		else if (`n_name' == `n_res') {
			local saving_list `stub'
		}
		else if (`n_name' !=`n_res' & `n_name'!=0){
			di as error "only one of `n_res' names is allowed"
			exit 198
		}
	}
	sret local saving_list `saving_list'
	sret local saving_replace `saving_replace'
end
					//----------------------------//
					// Draw one plot
					//----------------------------//
program DrawOnePlot
	_on_colon_parse `0'
	local opts_extra `s(before)'
	local plot `s(after)'

	local 0 `plot'
	syntax [anything(everything)] [,*]
	local plot `anything' , `options' `opts_extra'

	gettoken plot_type plot_opts : plot
	ParsePlotType , `plot_type'
	local plot_cmd `s(plot_cmd)'

	`plot_cmd' `plot_opts'
end

					//----------------------------//
					// ParsePlotType
					//----------------------------//
program ParsePlotType, sclass
	cap syntax [, cvplot	///
		coefpath ]
	
	if _rc {
		NoGraphError
		// NotReached
	}
	
	local ptype `cvplot' `coefpath' `coefnumber'
	local ntype : word count `ptype'

	if (`ntype' != 1) {
		di as err "only one of {bf:cvplot} or {bf:coefpath} can " ///
			"be specified as plottype"
		exit 198
	}
	
	if ("`ptype'" == "coefpath") {
		local plot_cmd _lassogph_coeff
	}
	else if ("`ptype'" == "cvplot") {
		local plot_cmd _lassogph_cv
	}
	else if ("`ptype'" == "coefnumber") {
		local plot_cmd _lassogph_nonzero
	}

	sret local plot_cmd `plot_cmd'
end
					//----------------------------//
					// Parse enpenalty
					//----------------------------//
program ParseEnp, sclass
	syntax [, min(real 0)		///
		max(real 1) 		///
		CVonly			///
		laout(passthru)		///
		subspace(passthru)	///
		alpha(string)		] 
	local oecmd `e(cmd)'
	preserve
	_lasso_useresult, clear `laout' `subspace'
	local n_res : char _dta[n_res]	
	local cv : char _dta[cv]
	local enp_n = 0
	forvalues i =1/`n_res'{
		if (`n_res'==1) {
			local enp_i : char _dta[enp]
		}
		else {
			local enp_i : char _dta[enp`i']
		}
		if "`alpha'" != "" {
			if `enp_i' == `alpha' {
				local enp_list `enp_list' `i'
				local enp_n = `enp_n' + 1
				break
			}
		}
		else {
			if (`enp_i'>=`min' & `enp_i' <= `max') {
				local enp_list `enp_list' `i'	
				local enp_n = `enp_n' + 1
			}
		}
	}
	if "`alpha'" != "" & `enp_n' == 0 {
		di as error "invalid value for {bf:alpha()}"
		exit 498
	}	

	if (`"`cvonly'"'!="") {
		local cv : char _dta[cv]
		if (`cv') {
			local cv_idx : char _dta[cv_idx]
			local enp : char _dta[enp`cv_idx']
			if (`n_res'==1) {
				local enp : char _dta[enp]
				local cv_idx = 1
			}
			if (`enp' >=`min' & `enp' <= `max') {
				local enp_list `cv_idx'
				local enp_n = 1
			}
		}
		else {
			di as error "cross-validation results required"
			exit 198
		}
	}

	restore
	mata:st_global("e(oecmd)","`oecmd'","hidden")

	sret local enp_n = `enp_n'
	sret local enp_list `enp_list'
end
					//----------------------------//
					// Draw One plot nobye
					//----------------------------//
program DrawOneTypePlotNobye
	syntax , gph(string)		///
		name_list(string)	///
		bye(string)		///
		n_res(string)		///
		enp_n(string)		///
		enp_list(string)	///
		[gph_opts(string) 	///
		saving_list(string)	///
		name_replace(string)	///
		saving_replace(string) nameorig(string)]

	if (`bye'==1) {
		exit
		// NotReached
	}

	forvalues i=1/`enp_n' {
					// name
		local name_i : word `i' of `name_list'
		local name_spec name(`name_i', `name_replace')
					// saving
		local save_i : word `i' of `saving_list'
		if (`"`save_i'"'!="") {
			local save_spec saving(`save_i', `saving_replace')
		}
					// bye_index
		local enp_i : word `i' of `enp_list'
		if `enp_n' == 1 {
			local enp_i `enp_list'
			local name_spec name(`nameorig',)
		}
		if (`n_res'==1 & `"`enp_i'"'!="") {
			local enp_i
		}
		DrawOnePlot `name_spec' `save_spec' i(`enp_i') ///
			: `gph' , `gph_opts'		
	}
end
					//----------------------------//
					// Draw One plot bye
					//----------------------------//
program DrawOneTypePlotBye
	syntax , gph(string)		///
		name_list(string)	///
		bye(string)		///
		n_res(string)		///
		enp_n(string)		///
		enp_list(string)	///
		[ gph_opts(string) 	///
		saving_list(string)	///
		name_replace(string)	///
		saving_replace(string)	///
		bye_opts(string) ]	
	
	if (`bye'==0) {
		exit
		// NotReached
	}

	forvalues i=1/`enp_n' {
					// bye_index
		local enp_i : word `i' of `enp_list'
		if (`n_res'==1 & `"`enp_i'"'!="") {
			local enp_i
		}
		if `enp_n' == 1 {
			local enp_i `enp_list'
		}

		ParseSubtitle, i(`enp_i')
		local subtitle `s(subtitle)'

		tempname tmp_name

		if (`i' != 1 & `i' != 2) {
			local yscale yscale(off fill) 
		}
		else {
			local yscale yscale(on)
		}

		if (mod(`i',2)==0 | `i' == `enp_n')  {
			local xscale xscale(on)
		}
		else {
			local xscale xscale(off fill) 
		}

		local extra note("_off") nodraw		///
			name(`tmp_name')		///
			xtitle("")			///
			ytitle("")			///
			scale(1.5)			///
			`xscale'			///
			`yscale'			///
			subtitle(`subtitle', box lwidth(none) size(small))

		DrawOnePlot i(`enp_i') `extra' ///
			: `gph' , `gph_opts'		
		local names `names' `tmp_name'
	}

	DrawOnePlot xytitle : `gph', `gph_opts'
	local enp_title `s(enp_title)'

	local name_spec name(`name_list', `name_replace')
	local save_spec saving(`save_list', `saving_replace')

	graph combine `names', `name_spec' `saving_spec'	///
		`bye_opts' `enp_title' colfirst rows(2) 	///
		altshrink imargin(zero)	
end
					//----------------------------//
					// Parse subtitle for one group of
					// enpenalty
					//----------------------------//
program ParseSubtitle, sclass
	syntax [, i(string)]

	local n_res = e(n_res)
	local sel_idx = e(sel_idx)
	tempname enp_v
	mat `enp_v' = e(alpha_v)

	if (`n_res' == 1 | "`i'" == "") {
		local enp = `enp_v'[1,1]
	}
	else {
		local enp = `enp_v'[`i',1]
	}

	local subtitle "enpenalty = `enp'"

	if ("`sel_idx'" == "`i'") {
		local subtitle "enpenalty = `enp' (selected)"
	}
	sret local subtitle `subtitle'
end
					//----------------------------//
					// Draw multiple graphs
					//----------------------------//
program DrawMultiGraph
	local ZERO `0'

	_parse expand plots opts : 0
	local 0 , `opts_op'
	syntax [, name(string)		///
		saving(string)		///
		ENPenalty(string)	///
		laout(passthru)		///
		for(passthru)		///
		*]
						//  parse for
	_lasso_check_for, estat_cmd(lassograph) `for' `xfold' `resample'

	_lasso_est_for, `for' `xfold' `resample'
	local subspace subspace(`r(subspace)')
	
	local gphcom_opts `options'
						//  parse enpenalty
	ParseEnp, `enpenalty' `laout' `subspace'
	local enp_n = `s(enp_n)'
	local enp_list `s(enp_list)'
						// n_res
	local n_res = e(n_res)
	local n_res = min(`n_res',wordcount("`enp_list'"))
						//  parse name
	ParseName , bye(0) n_res(`n_res') : `name'
	local name_list `s(name_list)'
	local name_replace `s(name_replace)'
						//  parse saving
	ParseSaving, bye(0) n_res(`n_res') : `saving'
	local saving_list `s(saving_list)'
	local saving_replace `s(saving_replace)'
						// draw multiple type of graph	
	forvalues i=1/`enp_n' {
		local enp_i : word `i' of `enp_list'
		if (`n_res' == 1) {
			local enp_i
		}
		DrawOneEnp, i(`enp_i')				///
			name_list(`name_list')			///
			name_replace(`name_replace')		///
			saving_list(`saving_list')		///
			saving_replace(`saving_replace')	///
			gphcom_opts(`gphcom_opts')		///
			`subspace'				///
			`laout'					///
			: `ZERO'
	}
end
					//----------------------------//
					// Draw One Enp for multiple graph
					//----------------------------//
program DrawOneEnp
	_on_colon_parse `0'
	local before `s(before)'
	local after `s(after)'

	_parse expand plots tmp : after

	local 0 `before'
	syntax [, i(string)		///
		name_list(string)	///
		name_replace(string)	///
		saving_list(string)	///
		saving_replace(string)	///
		gphcom_opts(string)	///
		laout(passthru)		///
		subspace(passthru)]

	CheckXcommon, plots(`after') `subspace'
	local is_xcommon `s(is_xcommon)'

	
	forvalues k=1/`plots_n' {
		if ((`is_xcommon'==1) & (`k' < `plots_n')) {
			local xscale xscale(off)
		}
		else {
			local xscale
		}
		
		local note note("_off")

		tempname tmp_name
		DrawOnePlot  name(`tmp_name') i(`i') `xscale' 	///
			legend("_off") scale(1.5)		///
			`note'					///
			nodraw					///
			`subspace'				///
			`laout'					///
			: `plots_`k''
		local names `names' `tmp_name'
	}

	ParseSubtitle, i(`i')
	local subtitle `s(subtitle)'

	ParseNameSpec, i(`i') name_list(`name_list') 	///
		name_replace(`name_replace')
	local name_spec `s(name_spec)'

	ParseSavingSpec, i(`i') saving_list(`saving_list')	///
		saving_replace(`saving_replace')
	local saving_spec `s(saving_spec)'

	if (`is_xcommon') {
		local xcommon xcommon
	}
	graph combine `names', `gphcom_opts' 	///
		`xcommon' col(1) altshrink	///
		`name_spec' `saving_spec'	///
		note(`subtitle')
end
					//----------------------------//
					// Check if all the plots have a common
					// xvar
					//----------------------------//
program CheckXcommon, sclass
	syntax [, plots(string) subspace(passthru)]

	_parse expand plots tmp : plots

	forvalues k=1/`plots_n' {
		DrawOnePlot get_xvar `subspace' : `plots_`k''
		local xvar_k `s(xvar)'
		local xvars `xvars' `xvar_k'
	}
	local xvars : list uniq xvars
	local n_xvars : word count `xvars'

	if (`n_xvars' == 1) {
		local is_xcommon = 1
	}
	else {
		local is_xcommon = 0
	}
	sret local is_xcommon `is_xcommon'
end
					//----------------------------//
					// ParseNameSpec
					//----------------------------//
program ParseNameSpec, sclass
	syntax [, i(string)		///
		name_list(string) 	///
		name_replace(string)]

	if (`"`i'"'!= "") {
		local name_i : word `i' of `name_list'
	}
	else {
		local name_i `name_list'
	}
	local name_spec name(`name_i', `name_replace')
	sret local name_spec `name_spec'
end
					//----------------------------//
					// ParseSavingSpec
					//----------------------------//
program ParseSavingSpec, sclass
	syntax [, i(string)		///
		saving_list(string)	///
		saving_replace(string) ]

	if (`"`i'"' != "") {
		local saving_i : word `i' of `saving_list'
	}
	else {
		local saving_i `saving_list'
	}

	if (`"`saving_i'"' != "") {
		local saving_spec saving(`saving_i', `saving_replace')
	}

	sret local saving_spec `saving_spec'
end
