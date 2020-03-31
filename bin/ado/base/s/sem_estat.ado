*! version 1.1.2  20jan2015
program sem_estat
	version 12
	local ver : di "version " string(_caller()) ", missing :"

	if "`e(cmd)'"!="sem" {
		error 301
	}	
	if _by() {
		error 190
	}	

	if e(estimates) == 0 {
		di as err ///
		"estat not allowed after sem with noestimate option"
		exit 198
	}

	local issvy = "`e(prefix)'" == "svy"

	gettoken key args : 0, parse(", ")
	local lkey = length(`"`key'"')

	if `"`key'"'==bsubstr("eqgof",1,max(3,`lkey')) {
		sem_estat_eqgof `args'
		exit
	}
	
	if `"`key'"'==bsubstr("eqtest",1,max(3,`lkey')) {
		sem_estat_eqtest `args'
		exit
	}

	if `"`key'"'==bsubstr("framework",1,max(3,`lkey')) {
		sem_estat_framework `args'
		exit
	}
	
	if `"`key'"'=="gof" { 
		`ver' sem_estat_gof `args'
		exit
	}

	if `"`key'"'=="ggof" { 
		`ver' sem_estat_ggof `args'
		exit
	}

	if `"`key'"'==bsubstr("mindices",1,max(2,`lkey'))	///
	 | `"`key'"'==bsubstr("mindex",1,max(2,`lkey')) {
		if `issvy' {
		  di as err "estat mindices is not allowed after svy: sem"
		  exit 198
		}
		sem_estat_mindices `args'
		exit
	}
	if `"`key'"'==bsubstr("scoretests",1,max(5,`lkey')) {
		if `issvy' {
		  di as err "estat scoretests is not allowed after svy: sem"
		  exit 198
		}
		sem_estat_scoretests `args'
		exit
	}
	
	if `"`key'"'==bsubstr("residuals",1,max(3,`lkey')) {
		sem_estat_residuals `args'
		exit
	}
	
	if `"`key'"'==bsubstr("ginvariant",1,max(3,`lkey')) {
		if `issvy' {
		  di as err "estat ginvariant is not allowed after svy: sem"
		  exit 198
		}
		sem_estat_ginvariant `args'
		exit
	}
	
	if `"`key'"'==bsubstr("stable",1,max(3,`lkey')) {
		sem_estat_stable `args'
		exit
	}
	
	if `"`key'"'==bsubstr("summarize",1,max(2,`lkey')) { 
		// override default handler
		sem_estat_summ `args'
		exit
	}
	
	if `"`key'"'==bsubstr("teffects",1,max(3,`lkey')) {
		sem_estat_teffects `args'
		exit
	}
	
	if `"`key'"'==bsubstr("stdize:",1,max(3,`lkey')) {
		if `"`key'"' == "stdize:" local col ":"
		sem_estat_stdize `col' `args'
		exit
	}

	if `"`key'"'==bsubstr("ic",1,max(2,`lkey')) {
		if strpos("`0'",",") == 0 {
			local df = ", df(`e(df_m)')"
		}
		else {
			local df = " df(`e(df_m)')"
		}
		estat_default `0' `df'
		exit
	}
	
	estat_default `0'
end
exit
