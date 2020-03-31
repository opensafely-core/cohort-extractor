*! version 1.0.1  11aug2002
program define profiler
	version 8

	gettoken cmd 0 : 0

	if `"`0'"' != "" {
		di as error `"`0' not allowed"'
		exit 198
	}

	if "`cmd'" == "on" {
		set profiling on
		exit
	}

	if "`cmd'" == "off" {
		set profiling off
		exit
	}

	if "`cmd'" == "clear" {
		local stat = "`:set profiling'"
		set profiling off
		_cls free __profile
		if "`stat'" == "on" {
			set profiling on
		}
		exit
	}

	if "`cmd'" == "report" {
		Report
		exit
	}

	if "`cmd'" == "" {
		di as error "must specify on, off, clear, or report"
		exit 198
	}

	di as error "`cmd' is not a subcommand of profiling"
	exit 198
end

program define Report

	local grand = 0
	local tct   = 0
	forvalues i = 1/0`.__profile.dynamicmv.arrnels' {
		_cls nameof .__profile dynamicmv[`i']
		di in gr "`r(name)'"
		local total 0
		forvalues j = 1/0`.__profile.dynamicmv[`i'].dynamicmv.arrnels' {
			_cls nameof .__profile.dynamicmv[`i'] dynamicmv[`j']
			local name `r(name)'
			gettoken P name : name , parse(P)
			di in ye 					    /*
			*/ %6.0f `.__profile.dynamicmv[`i'].dynamicmv[`j'].n' /*
			*/ %9.3f `.__profile.dynamicmv[`i'].dynamicmv[`j'].t' /*
		        */ in gr "  `name'"
			local total = `total' + /*
			   */ `.__profile.dynamicmv[`i'].dynamicmv[`j'].t'
			local tct = `tct' + /*
			   */ `.__profile.dynamicmv[`i'].dynamicmv[`j'].n'
		}

		if 0`.__profile.dynamicmv[`i'].dynamicmv.arrnels' > 1 {
			di in ye "      " %9.3f `total' in gr "  Total"
		}

		local grand = `grand' + `total'
	}

	di in gr "Overall total count = " in ye %6.0f   `tct'
	di in gr "Overall total time  = " in ye %10.3f `grand' in gr " (sec)"
end
