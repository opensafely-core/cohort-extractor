*! version 3.1.5  18sep2009
program define ml_plot /* parmname # [# [#]] */
	version 6

	gettoken parm 0 : 0, parse(" ,")
	if "`parm'" == "," | "`parm'"=="" { error 198 }

	gettoken comma : 0, parse(" ,")
	if "`comma'"!="," { 
		gettoken x0 0 : 0, parse(" ,")
		gettoken comma : 0, parse(" ,")
		if "`comma'"!="," {
			gettoken x1 0 : 0, parse(" ,")
			gettoken comma: 0, parse(" ,")
			if "`comma'"!="," { 
				gettoken n 0 : 0, parse(" ,")
			}
		}
	}
	syntax [, NAME(string asis) SAVing(string asis)]

	*args parm x0 x1 n

	GetName `parm'
	local colname `"`r(colname)'"'
	local colnumb = r(colnumb)

	tempname xorg
	scalar `xorg' = $ML_b[1,`colnumb']

	if "`x0'"=="" {
		tempname x0 x1
		scalar `x0' = `xorg' - 1
		scalar `x1' = `xorg' + 1
	}
	else if "`x1'"=="" {
		local pm `x0'
		confirm number `pm'
		tempname x0 x1
		scalar `x0' = `xorg' - abs(`pm')
		scalar `x1' = `xorg' + abs(`pm')
	}
	else {
		confirm number `x0'
		confirm number `x1'
	}

	if "`n'"=="" {
		local n 20
	}
	else {
		confirm integer number `n'
		if `n' < 1 {
			di in red "n=`n' must be positive"
			exit 198
		}
	}

	tempname b f newb newf
	if scalar($ML_f)==. {
		$ML_eval 0
	}

	nobreak {
		matrix `b' = $ML_b
		scalar `f' = scalar($ML_f)
		capture mat drop $ML_g
		capture mat drop $ML_V
		capture noisily break Graphit `"`name'"' `"`saving'"' /*
					*/ `parm' `colnumb' `x0' `x1' `n'
		local rc = _rc
		matrix $ML_b = `b'
		scalar $ML_f = `f'
	}
	if `rc'==0 {
		if r(b)!=. & reldif(r(b),`xorg') > 1e-15 & r(lnf)!=. /*
		*/ & (r(lnf)>scalar($ML_f) | scalar($ML_f)==.) {
			
			scalar `newb' = r(b)
			scalar `newf' = r(lnf)
			ml init `parm' = `r(b)'
			scalar $ML_f = `newf'
			local skip = max(0,27 - length("reset `parm'"))
			di _n in gr _skip(`skip') "reset `parm' = " /*
			*/ in ye %10.0g `newb' in gr "  (was " /*
			*/ in ye %10.0g `b'[1,`colnumb'] in gr ")"
			local skip = max(0,27 - length("$ML_crtyp"))
			di in gr _skip(`skip') "$ML_crtyp = " /*
			*/ in ye %10.0g scalar($ML_f) in gr "  (was " _c
			if `f'==. {
				di in ye "    -<inf>" in gr ")"
			}
			else	di in ye %10.0g `f' in gr ")"
		}
		else {
			local skip = max(0, 27 - length("keeping `parm'"))
		 	di _n in gr _skip(`skip') "keeping `parm' = " /*
			*/ in ye %10.0g $ML_b[1,`colnumb']
			local skip = max(0, 27 - length("$ML_crtyp"))
			di in gr _skip(`skip') "$ML_crtyp = " /*
			*/ in ye %10.0g scalar($ML_f)
		}
	}
	exit `rc'
end

program define Graphit /* saving parm colnumb x0 x1 n */, rclass
	args name saving parm colnumb x0 x1 n

	if `"`name'"' != "" {
		local name `"name(`name')"'
	}
	if `"`saving'"' != "" {
		local saving `"saving(`saving')"'
	}

	tempname xorg min max
	tempvar x lnf

	local N = `n' + 1

	if min(`x0',`x1') <= $ML_b[1,`colnumb'] /*
	*/ & $ML_b[1,`colnumb'] <= max(`x0',`x1') {
	   	local xval = $ML_b[1,`colnumb']
	   	local xline "xline(`xval')"
		local yval = scalar($ML_f)
		local yline "yline(`yval')"
	}

	local i 1
	while `i' <= `N' {
		mat $ML_b[1,`colnumb'] = `x0' + (`x1'-`x0')*((`i'-1)/`n')
		$ML_eval 0
		tempname f`i'
		scalar `f`i'' = scalar($ML_f)
		local i = `i' + 1
	}

	quietly {
		preserve
		drop _all
		set obs `N'

		gen double x = `x0' + (`x1'-`x0')*((_n-1)/`n')
		gen double lnf = . in 1

		label var x "`parm'"
		label var lnf "$ML_crtyp"

		local i 1
		while `i' <= `N' {
			replace lnf = `f`i'' in `i'
			local i = `i' + 1
		}


		summarize lnf

		if r(N) == 0 {
			noi di in blu "(all $ML_crtyp values are missing)"
			exit
		}

		scalar `min' = r(min)
		scalar `max' = r(max)

		if r(N) == `N' {
			version 8: graph twoway		///
			(connected lnf x,		///
				ytitle("$ML_crtyp")	///
				`yline'			///
				`xline'			///
				`saving'		///
				`name'			///
			)				///
			// blank
		}
		else {
			gen good    = lnf   if lnf!=.
			gen bad     = `min' if lnf==.
			replace lnf = `min' if lnf==.

			label var good "$ML_crtyp value"
			label var bad  "$ML_crtyp could not be evaluated"

			version 8: graph twoway		///
			(connected lnf good bad x,	///
				msymbol(none		///
					circle		///
					plus		///
				)			///
				clpattern(. dot dot)	///
				ytitle("$ML_crtyp")	///
				`yline'			///
				`xline'			///
				`saving'		///
				`name'			///
			)				///
			// blank

			replace lnf = . if good==. /* in case `min'==`max' */
		}

		summarize x if lnf==`max'

		return scalar b = r(min)
		return scalar lnf = `max'
	}
end

program define GetName /* */, rclass
	tokenize `"`0'"', parse(" :/")
	if "`2'"==":" {
		local eqname "`1'"
		local colname "`3'"
	}
	else if "`1'"=="/" {
		local eqname "`2'"
		local colname _cons
	}
	else {
		local eqname "${ML_eq1}"
		local colname "`1'"
	}
	if "`colname'" != "_cons" {
		tsunab colname: `colname', max(1)
	}
	local colnumb = colnumb(matrix($ML_b),"`eqname':`colname'")
	if `colnumb'==. {
		di in red "parameter `eqname':`colname' not found"
		exit 111
	}
	ret local colname `"`eqname':`colname'"'
	ret scalar colnumb = `colnumb'
end
