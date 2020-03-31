*! version 3.0.10  20jan2015
program define irf, sort
	local vv : di "version " string(_caller()) ":"
	version 8.2

	gettoken sub 0 : 0 , parse(" ,")

	local l = length(`"`sub'"')
	if `l'==0 {
		varirf_set 
		exit
	}
	if `"`sub'"'==bsubstr("create",1,max(2,`l')) {		/* CReate */
		irf_create `0'
	}
	else if `"`sub'"'=="set" {
		varirf_set `0'
	}
	else if `"`sub'"'==bsubstr("describe",1,max(1,`l')) {	/* Describe */
		varirf_describe `0'
	}
	else if `"`sub'"'=="drop" {				/* drop */
		varirf_drop `0'
	}
	else if `"`sub'"'==bsubstr("rename",1,max(3,`l')) {	/* REName */
		varirf_rename `0'
	}
	else if `"`sub'"'==bsubstr("graph",1,max(1,`l')) {	/* Graph */
		`vv' varirf_graph `0'
	}
	else if `"`sub'"'==bsubstr("cgraph",1,max(2,`l')) {	/* CGraph */
		`vv' varirf_cgraph `0'
	}
	else if `"`sub'"'==bsubstr("ograph",1,max(2,`l')) {	/* OGraph */
		`vv' varirf_ograph `0'
	}
	else if `"`sub'"'==bsubstr("table",1,max(1,`l')) {	/* Table */
		varirf_table `0'
	}
	else if `"`sub'"'==bsubstr("ctable",1,max(2,`l')) {	/* CTable */
		varirf_ctable `0'
	}
	else if `"`sub'"'==bsubstr("add",1,max(1,`l')) {		/* Add */
		varirf_add `0'
	}
	else {
		di as error "`sub' unknown subcommand"
		exit 198
	}
end

exit

