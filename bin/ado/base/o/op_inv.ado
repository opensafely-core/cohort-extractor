*! version 1.0.5  13feb2015
program define op_inv
	version 6, missing
	syntax varlist(ts min=2 max=2) if, Generate(string) [Dynamic(string)]
	confirm new var `generate'
	tempvar touse X
	mark `touse' `if'

	if "`dynamic'" != "" {
		local dynamic = `dynamic'
		capture confirm integer number `dynamic'
		if _rc { 
			di in red "option dynamic() misspecified"
			exit 198
		}
	}
	else	local dynamic .

	tokenize `varlist'
	local i = index("`1'",".")
	if `i'==0 { 
		qui gen double `generate' = `2' if `touse'
		exit 
	}
	local ops = bsubstr("`1'",1,`i'-1)
	local base = bsubstr("`1'",`i'+1,.)

	if "`dynamic'"=="" { 
		local dynamic "static"
	}

	qui gen double `X' = `2' if `touse'
	rmOPLIST `dynamic' "`ops'" `base' `X' `touse'
	qui replace `X' = . if !`touse'
	rename `X' `generat'
end


program define rmD 
	args dyn R Y0 X touse
	quietly { 
		gen double `R' = `Y0'
		replace `R' = cond(l.`_dta[_TStvar]'>=`dyn', l.`R', l.`Y0') /*
				*/ + `X' if `touse'
	}
end

program define rmS
	args dyn snum R Y0 X touse
	quietly { 
		gen double `R' = `Y0'
		replace `R' = cond(l`snum'.`_dta[_TStvar]'>=`dyn', /*
			*/ l`snum'.`R', l`snum'.`Y0') + `X' if `touse'
	}
end

program define rmDS
	args dyn op R Y0 X touse
	if lower("`op'") == "d" { 
		rmD `dyn' `R' `Y0' `X' `touse'
	}
	else { 
		local pnum = bsubstr("`op'",2,.)
		if "`pnum'" == "" {
			local pnum 1
		}
		rmS `dyn' "`pnum'" `R' `Y0' `X' `touse'
	}
end

program define OpSplit, sclass
	args ops
	sret clear 
	if "`ops'" == "" { exit }
	local opltr = bsubstr("`ops'",1,1)

	local id = index(bsubstr("`ops'",2,.),"D")
	local is = index(bsubstr("`ops'",2,.),"S")
	if `id'==0 & `is'==0 { 
		local id = length("`ops'")
	}
	else if `id'==0 { 
		local id `is'
	}
	local num = bsubstr("`ops'",2,`id'-1)
	local rest = bsubstr("`ops'",`id'+1,.)

	if "`num'"=="" { 
		sret local lhs `opltr'
		sret local rhs = bsubstr("`ops'",2,.)
		exit
	}
	if "`opltr'"=="D" { 
		local num = `num' - 1
		if `num'>0 { 
			local rest  D`num'`rest'
		}
		sret local lhs `opltr'
		sret local rhs `rest'
	}
	else {
		sret local lhs S`num'
		sret local rhs `rest'
	}
end

program define rmOPLIST 
	args dyn oplist Y0 X touse
	tempvar curY R

	LagSplit `oplist' 
	local lagop `s(lhs)'
	local oplist `s(rhs)'

	if "`lagop'"!="" { 
		/* I know X is tempvar */
		tempvar oldX
		quietly { 
			rename `X' `oldX' 
			gen double `X' = `lagop'.`oldX'
			drop `oldX'
		}
	}
			

	while "`oplist'"!="" {
		OpSplit `oplist'
		local oplist `s(rhs)'
		local op `s(lhs)'
		if "`oplist'"=="" { 
			quietly gen double `curY' = `Y0'
		}
		else 	quietly gen double `curY' = `oplist'.`Y0'
		rmDS `dyn' `op' `R' `curY' `X' `touse'
		drop `X' `curY'
		rename `R' `X'
	}
end



program define LagSplit, sclass
	args ops
	sret clear 
	if "`ops'" == "" { exit }
	local opltr = bsubstr("`ops'",1,1)
	if "`opltr'" != "F" & "`opltr'" != "L" { 
		sret local rhs "`ops'"
		exit
	}

	local id = index(bsubstr("`ops'",2,.),"D")
	local is = index(bsubstr("`ops'",2,.),"S")
	if `id'==0 & `is'==0 { 
		local id = length("`ops'")
	}
	else if `id'==0 { 
		local id `is'
	}
	local num = bsubstr("`ops'",2,`id'-1)
	local rest = bsubstr("`ops'",`id'+1,.)

	sret local lhs = cond("`opltr'"=="F", "L", "F") 
	if "`num'"=="" { 
		sret local rhs = bsubstr("`ops'",2,.)
		exit
	}
	else {
		sret local lhs `s(lhs)'`num'
		sret local rhs `rest'
	}
end
exit
