*! version 1.1.0  21mar2017
program irt_display
	version 14

	if `"`e(cmd2)'"' != "irt" {
		exit 301
	}

	_irtrsm_check

	local is_gsem = `"`e(cmd)'"' == "gsem"
	if `is_gsem' {
		local GSEMOPTS DVHEADER ESTMetric
	}

	syntax [,	`GSEMOPTS'	///
			noHEADer	///
			notable		///
			COEFLegend	///
			*		///
	]

	_get_diopts diops, `options'

	local g_table = ("`dvheader'`estmetric'" != "")

	if "`coeflegend'" != "" {
		local g_table `is_gsem'
	}

	if `g_table' {
		if "`dvheader'" == "" {
			local dvheader "nodvheader"
		}
		gsem,	`header'	///
			`dvheader'	///
			`table'		///
			`coeflegend'	///
			`diops'
	}
	else {
		irt_report, `header' `table' `coeflegend' `diops'
	}
end
exit
