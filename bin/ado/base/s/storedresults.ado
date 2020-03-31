*! version 1.1.3  16feb2015
program define storedresults
	version 7
	sret clear 
	gettoken cmd 0 : 0

	local l = length("`cmd'")
	if "`cmd'" == bsubstr("save",1,max(3,`l')) {
		Save `0'
	}
	else if "`cmd'" == bsubstr("compare",1,max(4,`l')) {
		Compare `0'
	}
	else if "`cmd'" == "drop" { 
		Drop `0'
	}
	else {
		di as err "`cmd' invalid subcommand"
		exit 199
	}
end

program define Drop
	args name
	CheckName `name'

	foreach x of global SR_dir_`name'_M {
		cap matrix drop SR__`name'_`x' 
	}
	global SR_dir_`name'_M


	foreach x of global SR_dir_`name'_s {
		cap scalar drop scalar SR__`name'_`x'
	}
	global SR_dir_`name'_s

	mac drop SR_`name' SR__`name'_*
	global SR_dir_`name'_m
end


program define Save
	args name thing nothing
	confirm name `name'
	CheckThing "`thing'"
	local ch = bsubstr("`thing'",1,1)
	if "`nothing'" != "" { error 198 }

	global SR_`name' "storedresults"
	global SR_dir_`name'_s : `ch'(scalars)
	foreach x of global SR_dir_`name'_s {
		confirm name SR__`name'_`x'
		scalar SR__`name'_`x' = `ch'(`x')
	}

	global SR_dir_`name'_m : `ch'(macros)
	foreach x of global SR_dir_`name'_m {
		confirm name SR__`name'_`x'
		global SR__`name'_`x' `"``ch'(`x')'"'
	}

	global SR_dir_`name'_M : `ch'(matrices)
	foreach x of global SR_dir_`name'_M {
		confirm name SR__`name'_`x'
		matrix SR__`name'_`x' = `ch'(`x')
	}
end


program define CheckThing
	args thing
	if "`thing'"=="e()" | "`thing'"=="r()" {
		exit
	}
	di as err "`thing':  invalid; must be e() or r()"
	exit 198
end

program define CheckName
	args name
	confirm name `name'
	if "${SR_`name'}" != "storedresults" {
		di as err "storedresults `name' not found"
		exit 111
	}
end


program define Compare, sclass
	gettoken name  0 : 0, parse(" ,")
	gettoken thing 0 : 0, parse(" ,")
	CheckName `name'
	CheckThing "`thing'"
	local ch = bsubstr("`thing'",1,1)

	syntax [, EXclude(string) INclude(string) REVerse /*
		*/ TOLerance(real 0) Verbose ]

	if `tolerance'<0 { 
		di as err "option tolerance() must be >= 0"
		exit 198
	}

	if "`include'"!="" {
		NotAllowed exclude() include() "`exclude'"
		NotAllowed reverse   include() "`reverse'"
		ParseList `include'
		local maclist `s(macros)'
		local scalist `s(scalars)'
		local matlist `s(matrices)'
	}
	else {
		if "`reverse'"=="" {
			local maclist ${SR_dir_`name'_m}
			local scalist ${SR_dir_`name'_s}
			local matlist ${SR_dir_`name'_M}
		}
		else {
			local maclist : `ch'(macros)
			local scalist : `ch'(scalars)
			local matlist : `ch'(matrices)
		}
		if "`exclude'" != "" {
			ParseList `exclude'
			RmList "`maclist'" "`s(macros)'"
			local maclist `s(newlist)'
			RmList "`scalist'" "`s(scalars)'"
			local scalist `s(newlist)'
			RmList "`matlist'" "`s(matrices)'"
			local matlist `s(newlist)'
		}
	}
			

					/* check the macros */
	sret clear 
	sret local rc 0 
	foreach x of local maclist {
		CheckMacro `ch'(`x') /*
			*/ `"${SR__`name'_`x'}"' `"``ch'(`x')'"' /*
			*/ `tolerance' `verbose'
	}

					/* check the scalars */
	foreach x of local scalist {
		CheckScalar `ch'(`x') /*
			*/ `"SR__`name'_`x'"' `"`ch'(`x')"' /* 
			*/ `tolerance' `verbose'
	}


					/* check the matrices */
	foreach x of local matlist {
		CheckMatrix `ch'(`x') /*
			*/ `"SR__`name'_`x'"' `"`ch'(`x')"' /*
			*/ `tolerance' `verbose'
	}

	exit `s(rc)'
end

program define CheckMacro, sclass
	args name orig new tol verbose

	if "`verbose'"!="" {
		di as txt "comparing macro  `name'"
	}

	if `"`orig'"' == `"`new'"' {
		exit
	}

	capture confirm number `orig'
	if _rc==0 { 
		capture confirm number `new'
		if _rc==0 { 
			if reldif(`new',`orig') <= `tol' { 
				exit
			}
			di `"`macro name differs:"'
			di `"original:  |`orig'|"'
			di `"     new:  |`new'|"'
			di "reldif(new,original) = " reldif(`new',`orig')
			sret local rc 9
			exit
		}
	}
	di
	di `"macro `name' differs:"'
	di `"original:  |`orig'|"'
	di `"     new:  |`new'|"'
	sret local rc 9
end

program define CheckScalar, sclass
	args name orig new tol verbose

	if "`verbose'"!="" {
		di as txt "comparing scalar `name'"
	}

	capture local check = `new'
	if _rc == 0 { 
		capture local check = `orig'
		if _rc==0 { 
			if reldif(`new',`orig') <= `tol' { 
				exit 
			}
		}
		else {
			di
			di "scalar `name' did not previously exist:"
			di `"     new:  "' %16.0g `new' 
			sret local rc 9
			exit
		}
	}
	else {
		di 
		di "scalar `name' does not now exist:"
		di `"original:  "' %16.0g `orig'
		sret local rc 9
		exit
	}
	di
	di `"scalar `name' differs:"'
	di `"original:  "' %16.0g `orig' 
	di `"     new:  "' %16.0g `new' 
        di `"  reldif:  "' reldif(`new',`orig')
	sret local rc 9
end
	

program define CheckMatrix, sclass
	args name origname newname tol verbose

	if "`verbose'"!="" {
		di as txt "comparing matrix `name'"
	}

	tempname orig new 
	capture matrix `orig' = `origname'
	if _rc == 0 { 
		capture matrix `new' = `newname'
		if _rc==0 { 
			if mreldif(`new',`orig') <= `tol' { 
				exit 
			}
		}
		else {
			di
			di "matrix `name' did not previously exist:"
			sret local rc 9
			exit
		}
	}
	else {
		di 
		di "matrix `name' does not now exist:"
		sret local rc 9
		exit
	}
	di
	di `"matrix `name' differs:"'
        di `"  reldif:  "' mreldif(`new',`orig')
	sret local rc 9
end

program define ParseList, sclass
	sret local macros
	sret local scalars
	sret local matrices

	ChkClass `1'
	if `s(isclass)'==0 { 
		di as err "exclusion/inclusion list invalid"
		di as err /*
		*/ `"must start with "macros:", "scalars:", or "matrices:""'
		exit 198
	}
	local i 2
	while "``i''" != "" {
		ChkClass ``i''
		if `s(isclass)'==0 { 
			sret local `s(class)' `s(`s(class)')' ``i''
		}
		local i = `i' + 1
	}
	sret local isclass
	sret local class
end

program define ChkClass, sclass
	args thing
	if bsubstr("`thing'",-1,1)!=":" { 
		sret local isclass 0
		exit 
	}
	sret local isclass 1
	if "`thing'" == "scalar:" | "`thing'"=="scalars:" {
		sret local class "scalars"
		exit
	}
	if "`thing'" == "macro:" | "`thing'"=="macros:" {
		sret local class "macros"
		exit
	}
	if "`thing'" == "matrix:" | "`thing'"=="matrices:" {
		sret local class "matrices"
		exit
	}
	di as err `""`thing'" invalid class name"'
	exit 198
end

program define RmList, sclass
	args orig excl

	foreach x of local excl {
		local orig : subinstr local orig "`x'" "", word
	}
	sret local newlist `orig'
end

	

program define NotAllowed 
	args option baseoption contents
	if "`contents'" != "" {
		di as err `"option `option' not allowed with `baseoption'"'
		exit 198
	}
end
	
exit
