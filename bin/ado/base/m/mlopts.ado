*! version 7.7.0  07mar2018
program mlopts, sclass
/*
   Syntax:     mlopts <lmacname> [<lmacname>] [, <options> ]

   Examples:   mlopts mlopts, `options'

               mlopts mlopts options, `options'
*/
	version 8.0

	local maxoptlist			///
		MLOPTs(string) 			///
		TRace				///
		TRACEDIffs			///
		GRADient			///
		HESSian				///
		SHOWSTEP			///
		ITERate(int -1) 		///
		TOLerance(real -1)		///
		LTOLerance(real -1) 		///
		GTOLerance(real -1)		///
		NONRTOLerance			///
		SHOWNRtolerance			///
		SHOWTOLerance			///
		NRTOLerance(real -1)		///
		QTOLerance(real -1)		///
		DIFficult			///
		HALFSTEPonly			///
		CONSTraints(string)		///
		noCNSNOTEs			///
		COLlinear			///
		TECHnique(passthru)		///
		VCE(passthru)			///
		DOTS				///
		depsilon(passthru)		///
		SHOWH				///
		NOTCONCAVE(passthru)		///
		USEVIEWS			///
		NOLOg LOg			///
		// blank
	syntax namelist(id="macro names" min=1 max=2) [, `maxoptlist' * ]
	gettoken dest rest : namelist
	if "`rest'" == "" {
		syntax namelist [, `maxoptlist' ]
	}

	// maximize options
	local mlopts `mlopts'		///
		`trace'			///
		`tracediffs'		///
		`gradient'		///
		`hessian'		///
		`showstep'		///
		`difficult'		///
		`halfsteponly'		///
		`nonrtolerance'		///
		`shownrtolerance'	///
		`showtolerance'		///
		`dots'			///
		`depsilon'		///
		`showh'			///
		`notconcave'		///
		`useviews'		///
		`log' `nolog'		///
		// blank
	if `tolerance'!= -1 {
		local tol "tolerance(`tolerance')"
	}
	if `ltolerance' != -1 {
		local ltol "ltolerance(`ltolerance')"
	}
	if `gtolerance' != -1 {
		local gtol "gtolerance(`gtolerance')"
	}
	if `nrtolerance' != -1 {
		local nrtol "nrtolerance(`nrtolerance')"
	}
	if `qtolerance' != -1 {
		local qtol "qtolerance(`qtolerance')"
	}
	if `iterate' != -1 {
		local iter "iterate(`iterate')"
	}
	sreturn clear
	if "`technique'`vce'" != "" {
		ml_technique, `technique' `vce' nodefault
		if `"`s(technique)'"' != "" {
			local technique "technique(`s(technique)')"
		}
		if "`s(vce)'" != "" {
			local vce "`s(vceopt)'"
		}
		sreturn local technique "`technique'"
		sreturn local vce "`vce'"
	}
	if "`constraints'" != "" {
		capture confirm name `constraints'
		if _rc {
			CheckClist constraints , constraints(`constraints')
		}
		else {
			CheckCmat `constraints'
		}
		local const "constraints(`constraints')"
		sreturn local constraints "`constraints'"
	}
	sreturn local collinear "`collinear'"
	c_local `dest' `mlopts' `tol' `ltol' `gtol' `nrtol' `iter'	///
		`const' `cnsnotes' `collinear' `technique' `vce' `qtol'

	// other options
	if "`rest'" != "" {
		c_local `rest' `"`options'"'
	}
end

program CheckClist
	syntax name , constraints(numlist integer)
	c_local `namelist' `constraints'
end

program CheckCmat
	args mat
	confirm matrix `mat'
end

exit
