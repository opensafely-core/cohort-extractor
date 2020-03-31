*! version 1.0.1  08dec2004
program _prefix_relabel_eqns, sclass
	args b V Vmsp

	tempname cuts
	local dim = colsof(`b')
	local cut1 = colnumb(`b',"_cut1")
	matrix `cuts' = `b'[1,`cut1'...]
	local ncut = colsof(`cuts')
	local mdf = `dim' - `ncut'
	forval i = 1/`ncut' {
		local names "`names' cut`i'"
	}
	matrix coleq	`cuts' = `names'
	matrix colnames `cuts' = _cons
	if `mdf' > 0 {
		matrix `b' = `b'[1,1..`mdf']
		matrix coleq `b' = `e(depvar)'
		matrix `b' = `b' , `cuts'
	}
	else	matrix `b' = `cuts'
	local vlist `V' `Vmsp'
	foreach vv of local vlist {
		local names : colnames `b'
		matrix colnames	`vv' = `names'
		matrix rownames	`vv' = `names'
		local names : coleq `b'
		matrix coleq	`vv' = `names'
		matrix roweq	`vv' = `names'
	}
	if `cut1' == 1 {
		sreturn local k_eq = `ncut'
	}
	else {
		sreturn local k_eq = `ncut'+1
	}
	sreturn local k_aux = `ncut'
end
exit
