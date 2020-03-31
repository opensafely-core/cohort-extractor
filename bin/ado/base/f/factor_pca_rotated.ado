*! version 1.0.2  16feb2015
*  used by pca_estat and factor_estat

program factor_pca_rotated
	version 8
	
	syntax , name(str) [ FORmat(str) ]
	
	if "`e(r_criterion)'" == "" { 
		dis as err "rotated `name' loadings are not available" 
		exit 321
	}
	
	if e(f)==0 | e(r_f)==0 { 
		dis as err "no factors retained"
		exit 321
	}	
	
	if "`format'" == "" { 
		local format %9.4f
	}
	
	local Name = upper(bsubstr("`name'",1,1)) + bsubstr("`name'",2,.)
	
	local mopt format(`format') border(row) /// 
	           left(4) tind(0) rowtitle(Variable)
	
	_rotate_text
	local rtext `r(rtext)' 
	
	matlist e(r_T) , `mopt' ///
	   title(Rotation matrix {hline 2} `rtext')
	
	local cwidth = 2+length("`:display `format' 1'")
	if 15+(e(f)+e(r_f))*`cwidth' <= c(linesize) {
	
		tempname L1 L2
		
		matrix `L1' = e(r_L)
		matrix coleq `L1' = Rotated
		
		matrix `L2' = e(L)
		matrix coleq `L2' = Unrotated
		
		matlist (`L1',`L2') , /// 
		   `mopt' title(`Name' loadings) showcoleq(c)
	}
	else {
	
		matlist e(r_L), `mopt' title(Rotated `name' loadings)
		matlist e(L)  , `mopt' title(Unrotated `name' loadings)
	}
end
