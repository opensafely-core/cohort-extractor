*! version 1.1.0  09may2019
program define _matrix_cmds
	version 11.0
	
	gettoken sub rest : 0, parse(" ,")
	local lsub : length local sub

	if "`sub'" == substr("list",1,max(1,`lsub')) {
		List `rest'
		exit
	}

	if "`sub'" == substr("rowjoinbyname",1,max(7,`lsub')) {
		JoinByName row `rest'
		exit
	}

	if "`sub'" == substr("coljoinbyname",1,max(7,`lsub')) {
		JoinByName col `rest'
		exit
	}

	error 501
end

program List
	version 11
	syntax anything(id="matrix name" name=mname) [,	///
		noBlank					///
		noHAlf					///
		noHeader				///
		noNames					///
		Format(string)				///
		TItle(string)				///
		nodotz					///
	]

	confirm matrix `mname'
	if `"`format'"' != "" {
		confirm numeric format `format'
	}
	local bl = "`blank'" == ""
	local ha = "`half'" == ""
	local he = "`header'" == ""
	local na = "`names'" == ""
	local dz = "`dotz'" == ""
	local title : list clean title
	mata: st_matrix_list(	"`mname'",		///
				"`format'",		///
				`"`title'"',		///
				`bl',`ha',`he',`na',`dz')
end

program JoinByName
	gettoken type	0 : 0, parse(" =")
	gettoken mname	0 : 0, parse(" =")
	gettoken EQ	0 : 0, parse(" =")

	if `"`EQ'"' != "=" {
		error 198
	}
	syntax [anything] [,				///
		MISsing(numlist missingok max=1)	///
		noConsolidate				///
		code					///
		NOIGNOREOMIT				///
	]
	if `"`missing'"' == "" {
		local missing .
	}
	local consolidate = "`consolidate'" == ""
	local code = "`code'" != ""
	local ignoreomit = "`noignoreomit'" == ""
	mata: st_matrix__join_by_name(	///
		"`type'",		///
		"`mname'",		///
		`"`anything'"',		///
		`missing',		///
		`consolidate',		///
		`code',			///
		`ignoreomit')
end

exit
