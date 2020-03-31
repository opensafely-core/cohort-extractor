*! version 1.0.1  22jun2011
program sem_estat_stable, rclass
	version 12
	
	if "`e(cmd)'"!="sem"{ 
		error 301
	}	
	
	syntax [, Detail ]
	
	if (e(k_ly) + e(k_oy) == 0) {
		di as txt "(model has no endogenous variables)"
		exit 
	}
	tempname Beta evals st Re Im Mod nobs
	
	local ng = e(N_groups)
	matrix `nobs' = e(nobs)

	dis
	dis as txt ///
	    "Stability analysis of simultaneous equation systems"
	
	forvalues g = 1/`ng' {
		if `ng'>1 {
			sem_groupheader `g'
			local gstr "_`g'"
		}
		else {
			dis
		}
	
		mata: st_sem_estat_stable(`g', "`Beta'", "`evals'", "`st'") 
		
		local inside = cond(`st'<1, 1,0)  
		
		matrix `Re'  = `evals'[1...,1]'
		matrix `Im'  = `evals'[1...,2]' 
		matrix `Mod' = `evals'[1...,3]' 
		
		DISP , real(`Re') complex(`Im') modulus(`Mod')
		
		dis as txt "   stability index = "	///
		    as res %9.0g `st' "
		
		if `inside' {
			di as txt "{col 4}All the eigenvalues lie "	///
				"inside the unit circle."
			di as txt "{col 4}SEM satisfies stability condition."
		}
		else {
			di as txt "{col 4}At least one eigenvalue "	///
				"is at least 1.0."
			di as txt "{col 4}SEM does not satisfy "	///
				"stability condition."
		}
	
		if "`detail'"!="" {
			dis
			dis as txt "   Endogenous variables on" ///
				" endogenous variables"
			local copt left(4) border(bottom) twidth(12)
			local ceq colorcoleq(res)
			matlist `Beta' , `copt' rowtitle(Beta) `ceq' 
		}	
		
		return scalar stindex`gstr'	= `st'
		return matrix Beta`gstr'       	= `Beta' 
		return matrix Re`gstr'         	= `Re' 
		return matrix Im`gstr'         	= `Im'
		return matrix Modulus`gstr'    	= `Mod' 
	} 
	return scalar N_groups = `ng'
	return matrix nobs = `nobs'
end

program define DISP
	
	syntax , real(name) complex(name) modulus(name) 

	tempname table1 table2
	.`table1' = ._tab.new, col(2) 
	.`table1'.width |26|13| 


	.`table2' = ._tab.new, col(3)
	.`table2'.width |12 14|13|
	
	.`table2'.strcolor . yellow .
	.`table2'.numcolor  yellow  . yellow 
	.`table2'.numfmt %10.7g .  %8.7g
	.`table2'.pad 1 . 2


	di  as text "{col 4}Eigenvalue stability condition"
	.`table1'.sep, top
	.`table1'.titles	"Eigenvalue       "	/// 1
				"Modulus  "	
	.`table1'.sep, mid
	
	local dim = colsof(`complex')

	forvalues i=1(1)`dim' {
		if reldif(`complex'[1,`i'] , 0) > 1e-10 {
			if  `complex'[1,`i'] < 0 {
local c_el : display "-" %10.7g  -1*`complex'[1,`i'] "{it:i}"  
			}
			else {
local c_el : display "+" %10.7g  `complex'[1,`i'] "{it:i}"  
			}	
			.`table2'.row	`real'[1,`i']	///
					"`c_el'"	///
					`modulus'[1,`i']
		}
		else {
			.`table2'.row	`real'[1,`i']	///
					""		///
					`modulus'[1,`i']
		}
	}	
	.`table1'.sep, bot
				
	mat `real' = `real''
	mat `complex' = `complex''
	mat `modulus' = `modulus''
end				
exit

