*! version 2.1.1  13dec1998
program define range 
	version 3.1
	if "`3'"=="" | "`5'"!="" { error 198 }
	confirm new var `1'
	if _N==0 { 
		if "`4'"=="" { error 198 } 
		set obs `4'
		local o "`4'"
	}
	else { 
		if "`4'"!="" { 
			local o "`4'"
			if `4' > _N { set obs `4' }
		}
		else	local o=_N
	}
	gen `1'=(_n-1)/(`o'-1)*((`3')-(`2'))+(`2') in 1/`o'
end
