*! version 1.0.6  09feb2015
program define _gs_bygraph , sortpreserve
	gettoken name     cmd : 0
	gettoken do       cmd : cmd
	gettoken by       cmd : cmd
	gettoken glob_if  cmd : cmd
	gettoken glob_in  cmd : cmd
	gettoken glob_op  cmd : cmd

	local 0 `by'						// parse by 
	syntax [varlist] [ , STYLE(passthru)				///
		TOTal SEPTOTal						///
		Columns(numlist integer >0 min=0 max=1)			///
		Rows(numlist integer >0 min=0 max=1) COLFirst 		///
		TitleHowToOpts 						///
		AxisHowToOpts 						///
		SHOWXTitles SHOWYTitles					///
		noTEXTRescale noCOMMONSCheme noCOMMONXaxis noCOMMONYaxis * ]

	.`name' = .bygraph_g.new , `style'		// create graph

							// style edits
	if "`septotal'" != "" {
		`name'.style.separate_total.set01 `="`septotal'"=="septotal"
	}

	tempname grarr					// array of by graphs
	.`grarr' = {}				
							// fill array
	bysort `varlist': RunGraph `grarr' `do' `"`glob_if'"'		///
			 `"`glob_in'"' `"`glob_op'"' "`commonscheme'" `cmd'

	if "`total'" != "" {				// total option
		tempname one lblone
		qui gen byte `one' = 1
		label define `lblone' 1 Total
		label values `one' `lblone'
		bysort `one': RunGraph `grarr' `do' `"`glob_if'"'	///
			 `"`glob_in'"' `"`glob_op'"' "`commonscheme'" `cmd'
		label drop `lblone'
	}

	local n = 0`.`grarr'.arrnels' + ("`total'"!="")	// # of by graphs

	if 0`columns' {					// # of rows and cols
		local rows    = 1 + int((`n' - 1) / `columns')
	} 
	else if 0`rows' {
		local columns = 1 + int((`n' - 1) / `rows')
	}
	else {
		local r = sqrt(`n')
		local columns = int(`r') + ((`r' - int(`r')) > .01)
		local rows = 1 + int((`n' - 1) / `columns')
	}

	.`name'.insert (plotregion1 = .grid.new) new
	local preg `name'.plotregion1

	local r `rows'					// put by graphs in grid
	local c 1
	local n  = 0`.`grarr'.arrnels' 
	forvalues i=1/`=`n'-0`.style.separate_total'' {
	    if "`colfirst'" == "" {
		.`preg'.insert (graph`i' = .`grarr'[`i'].ref) at `r' `c++'
		if `c' > `columns' {
			local c 1
			local `r--'
		}
	    }
	    else {
		.`preg'.insert (graph`i' = .`grarr'[`i'].ref) at `r--' `c'
		if `r' == 0 {
		    local r `rows'
		    local `c++'
		}
	    }
	}
	
	if 0`.style.separate_total' {
		.`preg'.insert (graph`n' = .`grarr'[`n'].ref)		///
			at `=`rows'-1' `=`columns'+1'
	}

	if "`textrescale'" != "" {			// graphs are subviews
		forvalues i=1/0`.`grarr'.arrnels' {
			.`grarr'[`i'].subview.set_true
		}
	}

							// turn off axis titles
	if `:word count `showxtitles' `showytitles'' != 2 {
	    forvalues i=1/0`.`grarr'.arrnels' {
		foreach d in x y {
		    if "`show`d'titles'" == "" {
		      forvalues j = 1/2 {
		    	cap .`grarr'[`i'].`d'axis`j'.title.draw_view.set_false
		      }
		    }
		}
	    }
	}
						// put our titles at the front
						// of options so they can be
						// superseded by typed options

	SetByList bylist : `varlist'				// title
	local options `"title("Graphs by `bylist'") `options'"'
	foreach d in x y {					// "axis" titles
		if "`show`d'titles'" == "" {
			local text `"`.`grarr'[1].`d'axis1.title.get_text'"'
			if `"`text'"' != `""' {
			    local p = cond("`d'"=="x", "b", "l")
			    local options `"`p'1title(`text') `options'"'
			}
		}
	}

	tempname log				// parse standard title opts
	.`log' = {}
	.`name'.parse_and_log_titles `log' "" `options'
	local options `"`r(rest)'"'
	.`name'.runlog `log'				      // always logging
							
	local 0 `", `options'"'
	syntax [, FAKE_OPT_FOR_BETTER_MSG ]

end


// ---------------------------------------------------------------------------
program define RunGraph , byable(recall, noheader)
	gettoken grarr      cmd_1 : 0
	gettoken do         cmd_1 : cmd_1
	gettoken glob_if    cmd_1 : cmd_1
	gettoken glob_in    cmd_1 : cmd_1
	gettoken glob_op    cmd_1 : cmd_1
	gettoken uniq_schm  cmd_1 : cmd_1

							// add to global if
	if `"`glob_if'"' == `""' {			// the by restriction
		local glob_if if `_byindex' == `=_byindex()'
	}
	else {
		local 0 `"`glob_if'"'
		syntax [if/]
		local glob_if `"if (`if') & (`_byindex' == `=_byindex()')"'
	}

	qui count `glob_if'
	if r(N) == 0 {
		exit					// if excludes group
	}

							// by titles
	tempname n
	gen `c(obs_t)' `n' = _n
	sum `n' if `_byindex' == _byindex() , meanonly
	local obs `r(min)'
	foreach var of local _byvars {
		if bsubstr("`:type `var''", 1, 3) == "str" {
		     local title `"`title'`sep'`=`var'[`obs']"'
		}
		else {
		     local title  ///
		     `"`title'`sep'`: label (`var') `=`var'[`obs']''"'
		}

		local sep ", "
	}

	local glob_op `"`glob_op' subtitle(`title')"'	// fully canonicalize
	local cmd_n 1
	_parse canonicalize full : cmd glob		

	if "`uniq_schm'" != "" {
		gr_setscheme				// graph has own scheme
	}
	
	.`grarr'[`.`grarr'.arrnels'+1] = .`do'graph_g.new `full'

end


// ---------------------------------------------------------------------------
program SetByList
	gettoken mac   0      : 0
	gettoken colon bylist : 0

	local ct : word count `bylist'

	if `ct' < 2 {
		c_local `mac' `bylist'
		exit
	}

	tokenize `bylist'

	if `ct' == 2 {
		c_local `mac' "``1'' and ``2''"
		exit
	}

	local list `1'
	forvalues i=2/`=`ct'-1' {
		local list "`list', ``i''"
	}
	local list "`list', and ``ct''"

	c_local `mac' `list'
end
