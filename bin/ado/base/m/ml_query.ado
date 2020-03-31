*! version 7.0.5  28feb2002 
program define ml_query
	version 6 
	syntax [, SYStem]
	if "`system'"!="" { 
		MLqsys
		exit
	}
	if `"`0'"' != "" { 
		error 198 
	}
	if "$ML_stat"!="model" { 
		if "`e(opt)'"=="ml" { 
			di in gr /*
		*/ "ml model estimated; type -ml display- to display results"
			exit
		}
		di in gr "no ml model defined"
		exit
	}
	di
	di in gr "Method:" in ye _col(19) `"${ML_meth}$ML_tech"'
	di in gr "Program:" in ye _col(19) "$ML_user"
	if `"$ML_title"'!="" {
		di in gr "Title:" in ye _col(19) `"$ML_title"'
	}

	if $ML_yn!=1 { 
		local s s 
	}
	else	local s
	di in gr "Dep. variable`s':" _col(19) _c
	if $ML_yn==0 { 
		di in gr "(none)"
	}
	else	di in ye "$ML_y"
	if $ML_n>1 { 
		local s s
	}
	else	local s
	di in gr "$ML_n equation`s':"
	local i 1
	while `i' <= $ML_n { 
		Peqname `i'
		if "${ML_x`i'}"=="" { 
			di in ye _col(8) "`s(name)'"
		}
		else {
			local suffix
			if "${ML_xc`i'}"=="nocons" { 
				local suffix ", nocons"
			}
			if "${ML_xo`i'}"!="" {
				if "`suffix'"=="" { local suffix ", " }
				local suffix "`suffix' offset(${ML_xo`i'})"
			}
			if "${ML_xe`i'}"!="" {
				if "`suffix'"=="" { local suffix ", " }
				local suffix "`suffix' exposure(${ML_xe`i'})"
			}
			if "${ML_xl`i'}"!="" {
				if "`suffix'"=="" { local suffix ", " }
				local suffix "`suffix' ${ML_xl`i'}"
			}
			di in ye _col(8) "`s(name)'" _col(19) /*
			*/ "${ML_x`i'}`suffix'"
		}
		local i = `i' + 1
	}
	di in gr "Search bounds:"
	local i 1
	while `i' <= $ML_n { 
		Peqname `i'
		if "${ML_lb`i'}"!="" { 
			di in ye _col(8) "`s(name)'" /*
				*/ _col(19) %9.0g ${ML_lb`i'} /*
				*/ _col(30) %9.0g ${ML_ub`i'}
		}
		else	di in ye _col(8) "`s(name)'" in gr /*
				*/ _col(24) "-inf" _col(35) "+inf"
		local i = `i' + 1
	}

	di in gr "Current (initial) values:"
	local eqs : coleq($ML_b)
	local nms : colnames($ML_b)
	local i 1 
	local any 0
        local haszero 0
	while `i' <= $ML_k { 
		if $ML_b[1,`i']!=0 { 
			local any 1
			local eq : word `i' of `eqs'
			local nm : word `i' of `nms' 
			di in gr "   `eq':`nm'" _col(22) in ye /*
			*/ %10.0g $ML_b[1,`i']
		}
		else	local haszero 1
		local i = `i' + 1
	}
	if `any' {
		if `haszero' {
			di in gr "    remaining values are zero"
		}
	}
	else	di _col(9) in gr "(zero)"
	if scalar($ML_f)!=. { 
		di in gr "lnL(current values) = " in ye %10.0g scalar($ML_f)
	}
end

program define Peqname /* # */, sclass
	local i `1'
	if "${ML_x`i'}"=="" { 
		sreturn local name "/${ML_eq`i'}"
	}
	else 	sreturn local name " ${ML_eq`i'}:" 
end

program define MLqsys
	if `"`0'"' != "" {
		error 198
	}
	di _n in gr "Base:"
	di in gr "    $" `"ML_stat   (status)          = "$ML_stat""'
	di in gr "    $" `"ML_meth   (method)          = "$ML_meth""'
	di in gr "    $" `"ML_tech   (technique)       = "$ML_tech""'
	di in gr "    $" `"ML_user   (program)         = "$ML_user""'
	di in gr "    $" `"ML_vers   (caller's version)= "$ML_vers""'
	di in gr "    $" `"ML_eval   (evaluator)       = "$ML_eval""'
	di in gr "    $" `"ML_evalf  (evaluator final) = "$ML_evalf""'
	di in gr "    $" `"ML_evali  (evaluator int.)  = "$ML_evali""'
	di in gr "    $" `"ML_noinv  (H inverted)      = "$ML_noinv""'
	di in gr "    $" `"ML_noinf  (H inv. final)    = "$ML_noinf""'
	di in gr "    $" `"ML_score  (score program)   = "$ML_score""'
	di in gr "    $" `"ML_vscr   (scores by var)   = "$ML_vscr""'
	di in gr "    $" `"ML_opt    (optimizer)       = "$ML_opt""'
	di in gr "    $" `"ML_tol    (beta tolerance)  = "$ML_tol""'
	di in gr "    $" `"ML_ltol   (LL tolerance)    = "$ML_ltol""'
	di in gr "    $" `"ML_gtol   (gradient tol)    = "$ML_gtol""'
	di in gr "    $" `"ML_nrtol  (gHg' tolerance)  = "$ML_nrtol""'
	di in gr "    $" `"ML_iter   (max iterations)  = "$ML_iter""'
	di in gr "    $" `"ML_brack  (bracket deltas)  = "$ML_brack""'
	di in gr "    $" `"ML_ibhhh  (bhhh iterations) = "$ML_ibhhh""'
	di in gr "    $" `"ML_ibfgs  (bfgs iterations) = "$ML_ibfgs""'
	di in gr "    $" `"ML_idfp   (dfp iterations)  = "$ML_idfp""'
	di in gr "    $" `"ML_inr    (nr iterations)   = "$ML_inr""'
	di _n /*
	*/ in gr "    $" `"ML_samp   (sample variable) =  $ML_samp"'
	di in gr "    $" `"ML_w      (weight variable) =  $ML_w"'
	di in gr "    $" `"ML_wtyp   (weight type)     = "$ML_wtyp""'
	di in gr "    $" `"ML_wexp   (weight exp)      = "$ML_wexp""'
	di in gr "    $" `"ML_vce    (VCE type)        = "$ML_vce""'
	di in gr "    $" `"ML_vce2   (VCE type 2)      = "$ML_vceid""'
	di in gr "    $" `"ML_clust  (cluster var)     = "$ML_clust""'
	di in gr "    $" `"ML_mksc   (need score vars) = "$ML_mksc""'
	di in gr "    $" `"ML_wald   (wald test)       = "$ML_wald""'
	di _n /*
	*/ in gr "    $" `"ML_b      (coef. vector)    =  $ML_b"'
	di in gr "    $" `"ML_f      (lnf scalar)      =  $ML_f"'
	di in gr "    $" `"ML_g      (grad. vector)    =  $ML_g"'
	di in gr "    $" `"ML_V      (Var. matrix)     =  $ML_V"'
	di _n /*
	*/ in gr "    $" `"ML_k      (# of parameters) =  $ML_k"'
	di _n in gr "Dependent Variables:"
	di in gr "    $" `"ML_yn     (count)           =  $ML_yn"'
        di in gr "    $" `"ML_y      (names)           = "$ML_y""'
	local n $ML_yn
	capture confirm integer number `n'
	if _rc { local n 0 } 
	local i 1 
	while `i' <= `n' { 
		di in gr "    $" "ML_y`i'" _col(16) "(dep. var.)" /*
		*/ _col(34) `"= "${ML_y`i'}""'
		local i = `i' + 1
	}

	di _n in gr "Equations:"
	di in gr "    $" `"ML_n      (count)           =  $ML_n"'
	local i 1
	local n $ML_n
	capture confirm integer number `n'
	if _rc { 
		local n 0
	}
	while `i' <= `n' { 
		di in gr "    $" "ML_eq`i'" _col(16) "(name)" /*
		*/ _col(34) `"= "${ML_eq`i'}""'
		di in gr "    $" "ML_x`i'" _col(16) "(contents)" /*
		*/ _col(34) `"= "${ML_x`i'}""'
		di in gr "    $" "ML_xc`i'" _col(16) "(nocons option)" /*
		*/ _col(34) `"= "${ML_xc`i'}""'
		di in gr "    $" "ML_k`i'" _col(16) "(# of parameters)" /*
		*/ _col(34) `"=  ${ML_k`i'}"'
		di in gr "    $" "ML_ip`i'" _col(16) "(is parameter)" /*
		*/ _col(34) `"=  ${ML_ip`i'}"'
		di in gr "    $" "ML_fp`i'" _col(16) "(first position)" /*
		*/ _col(34) `"=  ${ML_fp`i'}"'
		di in gr "    $" "ML_lp`i'" _col(16) "(last position)" /*
		*/ _col(34) `"=  ${ML_lp`i'}"'
		di in gr "    $" "ML_xo`i'" _col(16) "(offset)" /*
		*/ _col(34) `"= "${ML_xo`i'}""'
		di in gr "    $" "ML_xe`i'" _col(16) "(exposure)" /*
		*/ _col(34) `"= "${ML_xe`i'}""'
		di in gr "    $" "ML_xl`i'" _col(16) "(linear)" /*
		*/ _col(34) `"= "${ML_xl`i'}""'
		
		local i = `i' + 1
	}
	di in gr _n "Constraints"
	di in gr "    $" `"ML_C      (constraint)      = "$ML_C""'
	if $ML_C == 1 {
		di in gr "    $" `"ML_CT     (project matrix)    = ML_CT"'
		di in gr "    $" `"ML_Ca     (offset matrix)     = ML_Ca"'
		di in gr "    $" `"ML_CC     (constraint matrix) = ML_CC"'
	}
	di in gr _n "Current values:"
	if "$ML_b"!="" { 
		mat list $ML_b
	}
	if "$ML_f"!="" {
		di
		scalar list $ML_f
	}
end
