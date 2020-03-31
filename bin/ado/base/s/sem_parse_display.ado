*! version 1.3.0  30nov2016
program sem_parse_display
	version 12

	syntax	namelist(max=2)			///
		[,	STANDardized		///
			SHOWGinvariant		///
			noLABel			///
			NOFVLABel		///
			FVLABel			///
			noHEADer		///
			noTABle			///
			noFOOTnote		///
			wrap(numlist max=1)	///
			fvwrap(passthru)	///
			BYPARM			///
			*			///
	]
	local K : list sizeof namelist
	gettoken c_diopts c_opts : namelist

	if "`wrap'" != "" {
		opts_exclusive `"wrap(`wrap') `fvwrap'"'
		local fvwrap fvwrap(`wrap')
	}
	if "`label'" != "" {
		opts_exclusive "`label' `fvlabel'"
		local fvlabel nofvlabel
	}
	else {
		local fvlabel `nofvlabel' `fvlabel'
	}

	if `K' == 2 {
		_get_diopts diopts options, `options' `fvwrap' `fvlabel'
	}
	else {
		_get_diopts diopts, `options' `fvwrap' `fvlabel'
	}
	local diopts	`diopts'		///
			`standardized'		///
			`showginvariant'	///
			`header'		///
			`table'			///
			`footnote'		///
			`byparm'		///
						 // blank

	c_local `c_diopts' `"`diopts'"'
	if `K' == 2 {
		c_local `c_opts' `"`options'"'
	}
end
