*! version 1.1.11  09feb2012
program _get_gropts, sclass
	version 8.0

	syntax [,				///
		graphopts(string asis)		/// graph options
		grbyable			/// -by()- is allowed
		nobycheck			///
		TOTALallowed			/// -by(, total)- is allowed
		MISSINGallowed			/// -by(, missing)- is allowed
		getbyallowed(namelist local)	/// get -<opt>()- from -by()-
		getcombine			/// get -graph combine- options
		gettwoway			/// get -twoway_options-
		getallowed(namelist local)	/// get -<opt>()-
	]

	local globalopts `getcombine' `gettwoway'
	if `: word count `globalopts'' > 1 {
		di as err ///
		"options `globalopts' may not be combined"
		exit 198
	}

	// The following options are all supposed to be unique
	foreach ALLOWED of local getallowed {
		local allow_opts `"`allow_opts' `ALLOWED'(string asis)"'
		local RGETALL `"`RGETALL' `=lower("`ALLOWED'")'"'
	}
	foreach ALLOWED of local getbyallowed {
		local byallow_opts `"`byallow_opts' `ALLOWED'(passthru)"'
		local RGETBY `"`RGETBY' `=lower("`ALLOWED'")'"'
	}

	local 0 `", `graphopts'"'
	syntax [,			///
		by(string asis)		///
		`allow_opts'		/// -getallowed()- options
		*			///
	]
	local graphopts `"`options'"'

	if `"`grbyable'"' == "" & `"`by'"' != "" {
		di as err `"option by() not allowed"'
		exit 191
	}

	// parse the -by()-
	local 0 `by'
	syntax [varlist(default=none)] [,	///
		total				///
		MISSing				///
		*				///
	]

	local byvars `varlist'
	local bytotal `total'
	local bymissing `missing'

	if `"`bycheck'"' == "" &	///
	   `"`byvars'"'  == "" &	///
	   `"`bytotal'`bymissing'`options'"' != "" {
		di as err `"invalid syntax: by(`0')"'
		exit 198
	}
	local 0 , `options'
	syntax [,			///
		`byallow_opts'		/// -getbyallowed()- options
		*			///
	]
	local byopts `"`options'"'

	if `"`totalallowed'"' == "" & `"`bytotal'"' != "" {
		di as err ///
`"total option not allowed inside the by() option"'
		exit 191
	}

	if `"`missingallowed'"' == "" & `"`bymissing'"' != "" {
		di as err ///
`"missing option not allowed inside the by() option"'
		exit 191
	}

	// Get -graph_combine- options
	if "`getcombine'" != "" {
		GetPassThruOptions ,			///
			uniqueargopts(			///
				Rows			///
				Cols			///
				HOLes			///
				IMargins		///
				SCALE			///
				ISCALE			///
				SCHeme			///
				name			///
				SAVing			///
				SPACErs			///
			)				///
			switchopts(			///
				COLFirst		///
				altshrink		///
				YCOMmon			///
				XCOMmon			///
				COPies			///
				COMmonscheme		///
				NODRAW			///
			)				///
			repeatargopts(			///
				R1title			///
				R2title			///
				L1title			///
				L2title			///
				T1title			///
				T2title			///
				B1title			///
				B2title			///
				NOTE			///
				CAPtion			///
				SUBtitle		///
				Title			///
				YSIZe			///
				XSIZe			///
				GRAPHRegion		///
				PLOTRegion		///
			)				///
			graphopts(`graphopts')		///
			// blank
		local combineopts `"`s(found)'"'
		local graphopts `"`s(graphopts)'"'
	}

	// Get -twoway_options-
	if "`gettwoway'" != "" {
		// repeatable argumented options are automatically handled by
		// by -graph twoway-
		GetPassThruOptions ,			///
			uniqueargopts(			///
				SCALE			///
				SCHeme			///
				name			///
				SAVing			///
			)				///
			switchopts(			///
				NODRAW			///
			)				///
			repeatargopts(			///
				R1title			///
				R2title			///
				L1title			///
				L2title			///
				T1title			///
				T2title			///
				B1title			///
				B2title			///
				NOTE			///
				CAPtion			///
				SUBtitle		///
				Title			///
				YSIZe			///
				XSIZe			///
				GRAPHRegion		///
				PLOTRegion		///
				ASPECTratio		///
				YLine			///
				XLine			///
				TLine			///
				TEXT			///
				TTEXT			///
				YSCale			///
				XSCale			///
				TSCale			///
				YLABel			///
				XLABel			///
				TLABel			///
				YTICk			///
				XTICk			///
				TTICk			///
				YMLABel			///
				XMLABel			///
				TMLABel			///
				YMTICk			///
				XMTICk			///
				TMTICk			///
				YTItle			///
				XTItle			///
				TTItle			///
			)				///
			graphopts(`graphopts')		///
			// blank
		local twowayopts `"`s(found)'"'
		local graphopts `"`s(graphopts)'"'
	}

	// Saved results
	sreturn clear
	foreach ALLOWED of local RGETALL {
		sreturn local `ALLOWED' `"``ALLOWED''"'
	}
	sreturn local combineopts `"`combineopts'"'
	sreturn local twowayopts `"`twowayopts'"'
	sreturn local graphopts `"`graphopts'"'
	sreturn local byopts `"`byopts'"'
	foreach ALLOWED of local RGETBY {
		sreturn local by_`ALLOWED' `"``ALLOWED''"'
	}
	sreturn local missing `"`bymissing'"'
	sreturn local total `"`bytotal'"'
	sreturn local varlist `"`byvars'"'
end

program GetPassThruOptions, sclass
	syntax [,			///
		uniqueargopts(string)	///
		switchopts(string)	///
		repeatargopts(string)	///
		graphopts(string asis)	///
	]

	foreach opt of local uniqueargopts {
		local USPECS `"`USPECS' `opt'(passthru)"'
		local UNAMES `"`UNAMES' `=lower("`opt'")'"'
	}
	foreach opt of local switchopts {
		local USPECS `"`USPECS' `opt'"'
		local UNAMES `"`UNAMES' `=lower("`opt'")'"'
	}
	foreach opt of local repeatargopts {
		local RSPECS `"`RSPECS' `opt'(passthru)"'
		local RNAMES `"`RNAMES' `=lower("`opt'")'"'
	}

	// parse unique (argumented) and switch options
	local 0 `", `graphopts'"'
	syntax [, `USPECS' * ]
	foreach opt of local UNAMES {
		if `"``opt''"' != "" {
			local UFOUND `"`UFOUND' ``opt''"'
		}
	}

	// parse repeatable argumented options
	local 0 `", `options'"'
	local FOUND 1
	while `FOUND' {
		local FOUND 0
		syntax [, `RSPECS' * ]
		foreach opt of local RNAMES {
			if `"``opt''"' != "" {
				local RFOUND `"`RFOUND' ``opt''"'
				local FOUND 1
			}
		}
		if `"`options'"' == "" {
			local FOUND 0
		}
		else {
			local 0 `", `options'"'
		}
	}
	if `"`UFOUND'"' != "" & `"`RFOUND'"' != "" {
		sreturn local found `"`UFOUND' `RFOUND'"'
	}
	else {
		sreturn local found `"`UFOUND'`RFOUND'"'
	}
	sreturn local graphopts `"`options'"'
end

exit
