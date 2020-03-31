*! version 1.4.0  20apr2019
program _matrix_table
	version 12
	syntax anything(id="matrix name" name=matrix) [, cmdextras *]
	if "`cmdextras'" != "" {
		local nolabel		NOLABel
		local WRAP		wrap(numlist max=1)	///
					fvwrap(passthru)
		local pclassmatrix	PCLASSMATrix(string)
	}
	syntax anything(id="matrix name" name=matrix)	///
		[,	sort				///
			FORMATs(string asis)		///
			cmdextras			/// NOT DOCUMENTED
			`nolabel'			///
			`WRAP'				///
			`pclassmatrix'			///
			noTITLEs			///
			codes				/// NOT DOCUMENTED
			center				/// NOT DOCUMENTED
			puttab				/// NOT DOCUMENTED
			puttabsuffix(string)		/// NOT DOCUMENTED
			Level(passthru)			/// NOT ALLOWED
			noCNSReport			/// NOT ALLOWED
			FULLCNSReport			/// NOT ALLOWED
			COEFLegend			/// NOT ALLOWED
			SELEGEND			/// NOT ALLOWED
			cformat(passthru)		/// NOT ALLOWED
			sformat(passthru)		/// NOT ALLOWED
			pformat(passthru)		/// NOT ALLOWED
			NOCI				/// NOT ALLOWED
			NOPValues			/// NOT ALLOWED
			*				/// diopts
		]

	local DISALLOW	`level'			///
			`cnsreport'		///
			`fullcnsreport'		///
			`coeflegend'		///
			`selegend'		///
			`cformat'		///
			`sformat'		///
			`pformat'		///
			`noci'			///
			`nopvalues'
	if `"`DISALLOW'"' != "" {
		local 0 `", `DISALLOW'"'
		syntax [, NULLOP]
		exit 198	// [sic]
	}

	if `"`fvwrap'"' == "" & "`wrap'" != "" {
		local fvwrap fvwrap(`wrap')
	}
	if "`nolabel'`label'" != "" {
		opts_exclusive "`nolabel' `label'"
		opts_exclusive "`nofvlabel' `fvlabel'"
		opts_exclusive "`nolabel' `fvlabel'"
		opts_exclusive "`nofvlabel' `label'"
		if "`nolabel'" != "" {
			local fvlabel nofvlabel
		}
		else {
			local fvlabel fvlabel
		}
	}
	else	local fvlabel `nofvlabel' `fvlabel'

	if inlist("`matrix'", "e(b)", "e(V)", "e(Cns)") {
		di as err "matrix `matrix' not allowed"
		exit 198
	}
	_get_diopts diopts, `options'
	local lstretch lstretch nolstretch
	local lstretch : list lstretch & diopts
	local diopts : list diopts - lstretch

	// NOTE: hold/restore the current -r()- results; otherwise,
	// '_matrix_table()' calls to -_ms_display- it will change the
	// contents of -r()-

	if `"`puttabsuffix'"' != "" {
		local puttab puttab
	}

	if `"`puttab'"' == "" {
		tempname hold
		_return hold `hold'
	}
	capture noisily mata: _matrix_table()
	local rc = c(rc)
	if `"`puttab'"' == "" {
		_return restore `hold'
	}
	exit `rc'
end

exit
