*! version 1.0.0  13dec2016
program sem_group_header
	version 15

	local OPTS	c1(int 1)	///
			c2(int 20)	///
			c3(int 49)	///
			c4(int 67)	///
			c4wfmt(int 10)	///
			gidx(int 0)	///
			noHEADer

	syntax [, left(name) right(name) `OPTS' ]

	if `gidx' == 0 {
		exit
	}
	if "`e(groupvalue)'" == "" {
		exit
	}

	local kmg : colsof e(groupvalue)

	if "`left'`right'" != "" {
		syntax , left(name) right(name) [ `OPTS' ]
		BALANCE `left' `right'
		local DISPLAY "*"
	}
	else {
		tempname left right
		.`left' = {}
		.`right' = {}
		local DISPLAY DISPLAY
	}

	if `"`e(nobs)'"' != "matrix" {
		exit
	}
	local kdv : colsof e(nobs)

	if `kdv' > 1 {
		local BLANK BLANK
	}
	else	local BLANK "*"

	_ms_element_info, matrix(e(groupvalue)) el(`gidx')
	local gval "`r(level)'"
	local glen = udstrlen("`gval'")
	local maxlen = `c3' - `c2' - 4
	if `glen' > `maxlen' {
		local gval = udsubstr("`gval'",1,`maxlen'-2) + ".."
	}
	RESPONSE `left' `c2' "`gval'" "Group" 0
	.`right'.Arrpush			///
		as txt				///
		_col(`c3') "Number of obs"	///
		_col(`c4') "= "			///
		as res %`c4wfmt'.0fc el(e(nobs),1,`gidx')
	BLANK `left' `right'
	`DISPLAY' `left' `right'

end

program BLANK
	args left right

	.`left'.Arrpush ""
	.`right'.Arrpush ""
end

program BALANCE
	args left right

	local nl = `.`left'.arrnels'
	local nr = `.`right'.arrnels'
	local diff = `nr' - `nl'
	if `diff' > 0 {
		local arr : copy local left
	}
	else if `diff' < 0 {
		local diff = abs(`diff')
		local arr : copy local right
	}
	forval i = 1/`diff' {
		.`arr'.Arrpush ""
	}
end

program RESPONSE
	args left c2 dv title abbrev

	if "`title'" == "" {
		local title Response
	}
	if "`abbrev'" == "" {
		local abbrev 20
	}

	if `abbrev' == 0 {
		.`left'.Arrpush				///
			as txt				///
			"`title'"			///
			_col(`c2') ": "			///
			as res "`dv'"
		exit
	}

	.`left'.Arrpush				///
		as txt				///
		"`title'"			///
		_col(`c2') ": "			///
		as res abbrev("`dv'", `abbrev')
end

program DISPLAY
	args left right

	local nl = `.`left'.arrnels'
	local nr = `.`right'.arrnels'
	local K = max(`nl', `nr')

	forval i = 1/`K' {
		di as txt `.`left'[`i']' as txt `.`right'[`i']'
	}
end

exit
