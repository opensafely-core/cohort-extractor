*! version 3.3.3 18feb2004
program ksm
	version 8.0
	syntax varlist(min=2 max=2 numeric)	///
		[if] [in] [,			///
		LOWess				///
		Line				///
		Weight				///
		*				/// other lowess opts
	]

	local vv : display "version " string(_caller()) ":"

	if "`lowess'" != "" {
		local line line
		local weight weight
	}
	if "`weight'" == "" {
		local wgt noweight
	}
	if "`line'" == "" {
		local mean mean
	}
	`vv' lowess `varlist' `if' `in' , `mean' `wgt' `options'
end

exit
