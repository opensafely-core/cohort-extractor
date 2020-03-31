program define _tsinchk
	syntax [in] [, Panel ]

	_ts timevar panvar , `panel'
	if "`panel'" != "" & "`panvar'" == "" {
	   di in red "panel variable not set, use -tsset panelvar timevar ...-"
	   exit 111
	}

	if "`in'" != ""  {
		local sortvar : sortedby
		tokenize `sortvar'

		if "`panel'" != "" {
			if "`1'" != "`panvar'" | "`2'" != "`timevar'" {
				di in red "data must be -tsset panelvar " /*
					*/ "timevar ... - and be in"
				di in red "panelvar timevar sort order "  /*
					*/ "to use in range"
				exit 111
			}
		}
		else {
			if "`1'" != "`timevar'" {
				di in red "data must be -tsset panelvar " /*
					*/ "... - and be in timevar "     /*
					*/ "sort order to use in range"
				exit 111
			}
		}
	}

end

exit

	_tsinchk [in , panel]

	/* note if panel is specified, the data MUST be panel data */
