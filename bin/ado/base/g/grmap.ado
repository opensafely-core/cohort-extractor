*! version 1.1.1  09aug2017
program grmap
	version 15

	syntax [varname(default=none numeric)]	///
		[if] [in] [using/] [,		///
		activate			///
		debug				/// NOT DOCUMENTED
		status				/// NOT DOCUMENTED
		id(string)			///
		FColor(passthru)		///
		*				///
	]

	if "`activate'" != "" {
		local pwd : pwd
		capture noisily Activate , `debug'
		local rc = c(rc)
		quietly cd `"`pwd'"'
		if `rc' {
			exit `rc'
		}
		if "`varlist'`if'`in'`using'`id'`options'" == "" {
			exit
		}
	}
	else	CheckActivated, `status'

	if "`status'" != "" {
		if "`varlist'`if'`in'`using'`id'`options'" == "" {
			exit
		}
	}

	capture xtset
	if c(rc) == 0 {
		local timevar `"`r(timevar)'"'
		GetT , `options'
		local options `"`s(options)'"'
		local t `"`s(t)'"'
		if `"`t'"' == "" {
			di as err "option {bf:t()} required for panel data"
			exit 198
		}
	}
	else if `"`t'"' != "" {
		di as err "option {bf:t()} not allowed"
		exit 198
	}

	if `"`using'"' == "" | `"`id'"' == "" {
		quietly spset
		if `"`using'"' == "" {
			local using `"`r(sp_shp_dta)'"'
		}
		if `"`id'"' == "" {
			local id `"`r(sp_id)'"'
		}
	}
	if `"`using'"' == "" {
		di as err "shapefile not {bf:spset};"
		di as err "{bf:grmap} requires that a shapefile is {bf:spset}"
		exit 459
	}

	if "`varlist'" != "" {
		if `"`fcolor'"' == "" {
			local fcolor fcolor(Blues)
		}
	}

	if "`t'" != "" {
		preserve
		if `"`if'`in'"' != "" {
			keep `if' `in'
			local if
			local in
		}
		keep if `timevar' == `t'
	}

	g_spmap `varlist' `if' `in' using `"`using'"',	///
		id(`id')				///
		`fcolor'				///
		`options'
end

program Activate
	syntax [, debug]
	capture findfile grmap__activated.ado, path(PERSONAL)
	if c(rc) == 0 {
		di as txt "{bf:grmap} already activated"
		exit
	}
	if "`debug'" == "" {
		local show "*"
	}
	local rest : sysdir PERSONAL
	local depth 0
	`show' di as txt "`depth': rest is '`rest''"
	gettoken tok rest : rest , parse("\\/")
	if inlist(`"`tok'"', "\\", "/") {
		quietly cd "/"
	}
	else {
		quietly cd `"`tok'/"'
		gettoken sep rest : rest , parse("\\/")
	}
	while `:length local rest' {
		gettoken dir rest : rest , parse("\\/")
		gettoken sep rest : rest , parse("\\/")
		local ++depth
		`show' di as txt `"`depth': dir is '`dir''"'
		`show' di as txt `"`depth': sep is '`sep''"'
		`show' di as txt `"`depth': rest is '`rest''"'
		capture cd `"`dir'"'
		if c(rc) {
			`show' di as txt `"`depth': calling mkdir"'
			mkdir `"`dir'"'
			quietly cd `"`dir'"'
		}
	}
	tempname hh
	file open `hh' using grmap__activated.ado, write text
	file close `hh'
	di as txt "{bf:grmap} activated"
end

program CheckActivated
	syntax [, status]
	capture findfile grmap__activated.ado, path(PERSONAL)
	if c(rc) == 0 {
		if "`status'" != "" {
			di as txt "{bf:grmap} activated"
		}
		exit
	}
	di as err "{bf:grmap} not yet activated"
	di as err "{p 4 4 2}"
	di as err "{bf:grmap} is community-contributed software.  It is adapted"
	di as err "from Maurizio Pisati's {bf:spmap} command.  In order"
	di as err "to use {bf:grmap}, activate it by clicking or typing"
	di as err "{bf:{stata grmap, activate}}."
	di as err "{p_end}"
	exit 199
end

program GetT, sclass
	syntax, t(integer) [*]
	sreturn local t `"`t'"'
	sreturn local options `"`options'"'
end

exit
