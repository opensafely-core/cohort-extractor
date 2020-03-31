*! version 1.1.1  20mar2018
program irt_estat
	version 14

	_irtrsm_check
	
	gettoken cmd : 0, parse(" ,")
	local lcmd = length(`"`cmd'"')

	if `"`cmd'"'==bsubstr("report",1,max(3,`lcmd')) {
		gettoken cmd 0 : 0, parse(", ")
		irt_report `0'
		exit
	}

	if `"`cmd'"'==bsubstr("greport",1,max(4,`lcmd')) {
		gettoken cmd 0 : 0, parse(", ")
		irt_greport `0'
		exit
	}

	if `"`cmd'"'==bsubstr("summarize",1,max(2,`lcmd')) { 
		gettoken cmd 0 : 0, parse(", ")
		gsem_estat_summ `0'
		exit
	}

	estat_default `0'
end

exit
