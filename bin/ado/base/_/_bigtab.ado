*! version 1.1.1  16sep2019
program _bigtab, rclass sortpreserve
	version 8

	#del ;
	syntax varlist(numeric min=2 max=2) [if] [in] [aw iw fw/] 
	[, 
		MISSing 
		DEBUG     // not to be documented
	];
	#del cr	
	
	tempname F rcoding ccoding
	
	if `"`weight'"' != "" { 
		local wght [`weight'=`exp']
	}
	
	if ("`missing'" != "") local mopt novarlist
	marksample touse, `mopt'

	local rvar : word 1 of `varlist'
	local cvar : word 2 of `varlist'
	
// try tabulate

	if "`debug'" == "" { 
		local cmd tab `rvar' `cvar' `wght' if `touse', /// 
		          matcell(`F')  matrow(`rcoding')      /// 
		          matcol(`ccoding')  `missing' 

		capture `cmd'
		local rc = _rc
	}
	else { 
		local rc = 134 // fake too many values case
	}	
	
	if `rc' == 0 { 
		local nr = rowsof(`rcoding')
		local nc = colsof(`ccoding')
		
		if max(`nr',`nc') > c(max_matdim) {
			error 915
		}
	}
	else if `rc' == 134 { 
		
// too many values error -- low level generation of table
		
		tempvar irvar icvar freq
		
		capt tab `rvar' if `touse', `missing' matrow(`rcoding') 
		if _rc { 
			dis as err "`rvar' has too many values"
			exit 134
		}
		local nr = rowsof(`rcoding')
		
		capt tab `cvar' if `touse', `missing' matrow(`ccoding')
		if _rc { 
			dis as err "`cvar' has too many values"
			exit 134
		}	
		local nc = rowsof(`ccoding')
		matrix `ccoding' = `ccoding''
		
		if max(`nr',`nc') > c(max_matdim) {
			error 915
		}
		
	// MATA code requires 1..nr, 1..nc coded values
	
		quiet egen `irvar' = group(`rvar') if `touse', `missing' 
		quiet summ `irvar' if `touse' 
		local nr = r(max)
	
		quiet egen `icvar' = group(`cvar') if `touse', `missing' 
		quiet summ `icvar' if `touse' 
		local nc = r(max)

	// pre-allocate matrix
	
		matrix `F' = J(`nr',`nc',0)
	
	// compute frequencies
	
		if "`weight'" == "" { 
			quiet bys `touse' `irvar' `icvar' : ///
			         gen double `freq' = _N
		}
		else {
			if "`weight'" == "aweight" { 
				tempname Scale
				tempvar  wexp
				quiet gen `wexp' = `exp' 
				quiet summ `wexp' if `touse' 
				scalar `Scale' = r(mean)
				drop `wexp' 
			}
			
			quiet bys `touse' `irvar' `icvar' : ///
			         gen double `freq' = sum(`exp')
			         
			if "`weight'" == "aweight" { 
				quiet replace `freq' = `freq' / `Scale' 
			}	
		}
		quiet bys `touse' `irvar' `icvar' : /// 
		         replace `touse' = 0 if _n<_N
	
	// FAST fill of matrix F using MATA
	
		mata: FillF("`F'","`touse'","`irvar'","`icvar'","`freq'")
		
	}			
	else if `rc' != 0 { 
		// rerun to produce error message
		`cmd' 
	}
				
	return matrix F = `F' 
	return matrix rowcoding = `rcoding' 
	return matrix colcoding = `ccoding' 
end


mata: 
function FillF( string scalar Fname,
                     string scalar touse,
                     string scalar irvar,
                     string scalar icvar,
                     string scalar freq )
{
	real scalar i
	real matrix F, D
	
	F = st_matrix(Fname)
	pragma unset D
	st_view(D, ., (irvar,icvar,freq), touse)

	for (i=1; i<=rows(D); i++) {	
		F[D[i,1],D[i,2]] = D[i,3] 
	}
	
	st_replacematrix(Fname,F)
}
end
