*! version 1.1.8  01may2019
program regress_estat, rclass
	version 9

	local ver : di "version " string(_caller()) ", missing :"

	if "`e(cmd)'" != "regress" {
		error 301
	}

	gettoken key rest : 0, parse(", ")
	local lkey = length(`"`key'"')

/* Regular */
	if `"`key'"' == bsubstr("ovtest",1,max(3,`lkey')) {
		`ver' ovtest `rest'
	}
	else if `"`key'"' == bsubstr("hettest",1,max(4,`lkey')) {
		hettest `rest'
	}
	else if `"`key'"' == bsubstr("szroeter",1,max(3,`lkey')) {
		szroeter `rest'
	}
	else if `"`key'"' == bsubstr("vif",1,max(3,`lkey')) {
		`ver' vif `rest'
	}
	else if `"`key'"' == bsubstr("imtest",1,max(3,`lkey')) {
		`ver' imtest `rest'
	}
	else if `"`key'"' == bsubstr("esize",1,max(3,`lkey')) {
		if _caller() < 13 {
			di as err ///
			"estat esize not allowed after regress run with version < 13"
			exit 301
		}
		else {
			`ver' estat_esize `rest'
		}
	}

/* Time series */
	else if `"`key'"' == bsubstr("dwatson",1,max(3,`lkey')) {
		dwstat `rest'
	}
	else if `"`key'"' == bsubstr("durbinalt",1,max(3,`lkey')) {
		durbina `rest'
	}
	else if `"`key'"' == bsubstr("bgodfrey",1,max(3,`lkey')) {
		bgodfrey `rest'
	}
	else if `"`key'"' == bsubstr("archlm",1,max(6,`lkey')) {
		archlm `rest'
	}
	else if `"`key'"' == "sbknown" | `"`key'"' == "sbsingle" {
		if _caller() < 14 {
			di as err "{p}{bf:estat `key'} not allowed after"
			di as err "regress run with version < 14{p_end}"
			exit 301
		}
		else `key' `rest'
	}
	else if `"`key'"' == "sbcusum" {
		if _caller() < 15 {
			di as err "{p}{bf:estat `key'} not allowed after"
			di as err "regress run with version < 15{p_end}"
			exit 301
		}
		else `key' `rest'
	}
/* Spatial */
	else if `"`key'"'==bsubstr("moran", 1, max(3, `lkey')) {
		_estat_moran `rest'
	}
/* Default */
	else {
		estat_default `0'
	}
	return add
end
