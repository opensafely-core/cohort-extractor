*! version 1.3.4  01nov2018
program define histogram
	version 8.0, missing

	syntax varname(numeric) [fw] [if] [in] [,	///
		Discrete				///
		BIN(passthru)				///
		START(passthru)				///
		Width(passthru)				///
		DENsity FRACtion FREQuency		///
		percent					///
		KDENsity				///
		NORMal					///
		ADDLabels				///
		BARWidth(real -99)			///
		HORizontal				///
		BINRESCALE				///
		*					///
	]

	if _N == 0 {
		error 2000
	}

	_gs_by_combine by options : `"`options'"'

	// note: options discrete and bin() are mutually exclusive

	if `"`discrete'"' != "" & `"`bin'"' != "" {
		di as error "options discrete and bin() may not be combined"
		exit 198
	}

	// note: bin() and width() are mutually exclusive

	if `"`bin'"' != "" & `"`width'"' != "" {
		di as err "options bin() and width() may not be combined"
		exit 198
	}

	// note: options density, fraction and frequency are mutually
	// exclusive

	local type `density' `fraction' `frequency' `percent'
	local k : word count `type'
	if `k' > 1 {
		local type : list retok type
		di as err "options `type' may not be combined"
		exit 198
	}
	else if `k' == 0 {
		local type density
	}

	local yttl = upper(bsubstr("`type'",1,1))+bsubstr("`type'",2,.)
	local xttl : var label `varlist'
	if `"`xttl'"' == "" {
		local xttl `varlist'
	}

	tempname touse
	mark `touse' `if' `in'

	quietly count if `touse'
	if r(N) == 0 {
		error 2000
	}

	local wgt [`weight'`exp']
	local ifin if `touse'
	local histopts `discrete' `type' `bin' `start' `width'

	_get_gropts , graphopts(`options' `by')		///
		grbyable total missing			///
		getbyallowed(legend)			///
		getallowed(KDENOPts NORMOPts ADDLABOPts PLOT ADDPLOT)

	local by `"`s(varlist)'"'
	local bylegend `"`s(by_legend)'"'
	local byopts `"`s(total)' `s(missing)' `s(byopts)'"'
	if `"`by'"' == "" & strtrim(`"`byopts'"') != "" {
		di as error "option by() requires a varlist"
		exit 198
	}
	if `"`by'"' != "" {
		local BYIFIN : copy local ifin
	}
	else	local IFIN : copy local ifin
	local options `"`s(graphopts)'"'
	local kdenopts `"`s(kdenopts)'"'
	local normopts `"`s(normopts)'"'
	local addlabopts `"`s(addlabopts)'"'
	local plot `"`s(plot)'"'
	local addplot `"`s(addplot)'"'
	_check4gropts kdenopts, opt(`kdenopts')
	if `"`kdenopts'"' != "" {
		local kdensity kdensity
	}
	_check4gropts normopts, opt(`normopts')
	if `"`normopts'"' != "" {
		local normal normal
	}
	_check4gropts addlabopts, opt(`addlabopts')
	if `"`addlabopts'"' != "" {
		local addlabels addlabels
	}
	if `"`by'"' != "" & ///
		`"`frequency'"' != "" & ///
		`"`normal'`kdensity'"' != "" {
		local dens `normal' `kdensity'
		if 0`:word count `dens'' != 1 {
			local s s
		}
		di as err "{p}option frequency"	///
			" may not be combined with the `dens'"	///
			" and by() option`s'{p_end}"
		exit 191
	}
	if "`by'" != "" {
		local qui qui
	}
	local othtypes fraction percent
	foreach othtype of local othtypes {
		if `"`by'"' != "" & ///
			`"``othtype''"' != "" & ///
			`"`normal'`kdensity'"' != "" & ///
			"`binrescale'" == "binrescale" {
			local dens `normal' `kdensity'
			if 0`:word count `dens'' != 1 {
				local s s
			}
			di as err "{p}option {bf:`othtype'}"	///
			" may not be combined with the `dens'"	///
			" and by() option`s' when"		///	
			" {bf:binrescale} is specified{p_end}"
			exit 191
		}
	}
	 
	// gen common histogram parameters, and display a little note
	`qui' twoway__histogram_gen `varlist' `wgt' `ifin', `histopts' display
	local histopts `r(type)'
	if `"`binrescale'"' != "" &  `"`by'"' != "" {
		if "`bin'" != "" {
			local histopts `histopts' bin(`r(bin)')
		}
		if "`start'" != "" {
			local histopts `histopts' start(`r(start)')
		}
		if "`width'" != "" {
			local histopts `histopts' width(`r(width)')
		}
		local histopts `histopts' `discrete'
		local rangeopt "range(`varlist')"
	}
	else if `"`by'`discrete'`width'"' == "" {
		local histopts `histopts' start(`r(min)') bin(`r(bin)')
		local rangeopt "range(`r(min)' `r(max)')"	
	}
	else {
		local histopts `histopts' start(`r(min)') width(`r(width)')
		local rangeopt "range(`r(min)' `r(max)')"
	}	
	if `"`type'"' != "density" {
		local area = r(area)
		local areaopt area(`r(area)')
	}
	else	local area 1

	if `"`kdensity'"' != "" {
		local KDEgraph				///
		(kdensity `varlist'			///
			`IFIN' `wgt',			///
			lstyle(refline)			///
			yvarlab("kdensity `varlist'")	///
			`horizontal'			///
			`rangeopt'			///
			`areaopt'			///
			`kdenopts'			///
		)
	}
	if `"`normal'"' != "" {
		qui sum `varlist' `wgt' `ifin'
		local Ngraph					///
		(fn_normden `varlist'				///
			`IFIN' `wgt',				///
			yvarlab("normal `varlist'")		///
			lstyle(refline)				///
			`rangeopt'				///
			`areaopt'				///
			`horizontal'				///
			`normopts'				///
		)
	}
	if `"`addlabels'"' != "" {
		if `"`horizontal'"' == "" {
			local Lgraph			///
			(histogram `varlist'		///
				`IFIN' `wgt',		///
				`histopts'		///
				`horizontal'		///
				recastas(scatter)	///
				msymbol(none)		///
				mlabel(_height)		///
				mlabposition(12)	///
				`addlabopts'		///
			)
		}
		else {
			tempname h c
			`qui' twoway__histogram_gen	///
				`varlist' `wgt' `ifin',	///
				`histopts' gen(`h' `c')
			format %6.4g `h'
			local Lgraph			///
			(scatter `c' `h',		///
				msymbol(none)		///
				mlabel(`h')		///
				mlabposition(3)		///
				mlabstyle(default)	///
				`addlabopts'		///
			)
		}
	}

	if `"`bylegend'`plot'`addplot'"' == "" {
		local legend legend(nodraw)
	}
	if `"`by'"' != "" {
		local byopt `"by(`by', `bylegend' `byopts')"'
	}
	if `"`horizontal'"' != "" {
		local zz `"`yttl'"'
		local yttl `"`xttl'"'
		local xttl `"`zz'"'
	}

	if _caller() >= 9 {
		if "`horizontal'" == "" {
			local bmarg plotregion(margin(b=0))
		}
		else	local bmarg plotregion(margin(l=0))
	}

	graph twoway			///
	(histogram `varlist'		///
		`IFIN' `wgt',		///
		ytitle(`"`yttl'"')	///
		xtitle(`"`xttl'"')	///
		legend(cols(1))		///
		barwidth(`barwidth')	///
		`bmarg'			///
		`horizontal'		///
		`byopt'			///
		`legend'		///
		`histopts'		///
		`options'		///
	)				///
	`KDEgraph'			///
	`Ngraph'			///
	`Lgraph'			///
	`BYIFIN'			///
	|| `plot' || `addplot'		///
	// blank
end

exit
