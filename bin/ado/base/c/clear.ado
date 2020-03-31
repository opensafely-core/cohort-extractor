*! version 4.3.1  17apr2019
program clear
	if _caller() < 10 {
		_clear_9 `0'
		exit
	}
	version 10

	syntax [anything]

	tokenize `anything'
	if `"`2'"' != "" {
		display as err "`2' not allowed"
		exit 198
	}

	if "`1'"=="" {
		drop _all
		label drop _all
	}
	else if "`1'"=="frames" {
		frames reset
	}
	else if "`1'"=="mata" {
		mata: mata clear
	}
	else if "`1'"=="python" {
		python clear
	}
	else if inlist("`1'", "results", "matrix") {
		return clear
		clearreturn	/* necessary to clear r() */
		ereturn clear
		sreturn clear
		_return drop _all
		if ("`1'" == "matrix") {
			matrix drop _all
			_est drop _all
		}
	}
	else if "`1'"=="programs" {
		program drop _all
	}
	else if "`1'"=="ado" {
		program drop _allado
	}
	else if "`1'"=="rngstream" | "`1'"=="rngstreams" {
		set rngstream clear
	}
	else if "`1'"=="*" | "`1'"=="all" {
		capture mata: ///
			st_local("semmods", strofreal(sg__global.hasmodels()))
		capture
		if (0`semmods') {
			display as err ///
			"-clear all- not allowed while an SEM Builder is open"
			exit 1
		}
		drop _all
		frames reset
		label drop _all
		matrix drop _all
		scalar drop _all
		constraint drop _all
		eq drop _all
		file close _all
		postutil clear
		_return drop _all
		discard
		program drop _all
		timer clear
		mata: _st__put_cmd_clear()
		mata: mata clear
		python clear
	}
	else {
		display as err "`1' not allowed"
		exit 198
	}
end

program _clear_9
	version 9
	if _caller() >= 9.1 {
		if `"`0'"' != "" {
			di as err `"'`0'' not allowed"'
			exit 198
		}
	}
	drop _all
	label drop _all
	matrix drop _all
	scalar drop _all
	constraint drop _all
	eq drop _all
	file close _all
	postutil clear
	_return drop _all
	discard
	timer clear
	mata: mata clear
end

program clearreturn, rclass
	exit
end
