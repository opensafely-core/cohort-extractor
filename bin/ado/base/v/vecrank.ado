*! version 1.1.0  26feb2007
program define vecrank, eclass sort byable(recall) 
	version 8.2

	if replay() {

		if "`e(cmd)'" != "vecrank" {
			di as err "{cmd:vecrank} results not found"
			exit 301
		}

		syntax , [level99 levela noTRace max ic]

		_vec_dreduced 

		Disp1 ,	`trace' `max' `ic' `level99' `levela'
		exit
	}

local m1 = _N
	syntax varlist(ts numeric min=2) [if] [in]	///
		[ ,  					///
		Trend(string)				///
		LAgs(numlist integer max=1 >0 <`m1')	///
		SIndicators(varlist numeric)    	///
		Seasonal				/// undocumented
		noTRace					///
		Max					///
		Ic					///
		level99					///
		levela					///
		noreduce				///
		]

	marksample touse
	
	tempname oldest oldsmp 


	_vecu `varlist' if `touse', trend(`trend') lags(`lags')	///
		sindicators(`sindicators') `seasonal' `trace' ///
		`max' `ic' `level99' `levela' `reduce'
	ereturn local cmdline `"vecrank `0'"'

	capture drop _trend
	capture drop $S_DROP_sindicators
	capture macro drop S_DROP_sindicators

	Disp1 ,	`trace' `max' `ic' `level99' `levela'

end	

program define Disp1
	
	syntax , [level99 levela noTRace max ic]

	if "`level99'" == "" & "`levela'" == "" {
			local disp95 disp95
			local disp99 nodisp99
		}
		
		if "`level99'" != "" & "`levela'" == "" {
			local disp95 nodisp95
			local disp99 disp99
		}
		
		if "`levela'" != "" {
			local disp95 disp95
			local disp99 disp99
		}
	
		local nhead head
		if "`trace'" == "" {
			Disp trace head noic `disp95' `disp99' 
			local nhead noheader
		}	
	
		
		if "`max'" != "" {
			Disp max `nhead' noic `disp95' `disp99' 
			local nhead noheader
		}
	
		if "`ic'" != "" {
			Disp notest `nhead' ic nodisp95 nodisp99 
		}	


end

program define Disp

	local test  `1'
	local head   `2'
	local ic     `3'
	local disp95 `4'
	local disp99 `5'

	local tmin : di `e(tsfmt)' e(tmin)
	local tmax : di `e(tsfmt)' e(tmax)

	if "`disp99'" == "disp99" {
		local selrank 99
	}
	else {
		local selrank 95
	}
	

	if "`disp95'" == "disp95" & "`disp99'" == "disp99" {
		local dboth dboth
		local selr99 99
		local selr95 95
	}
	

// test is test name, must be either "max", "trace", or "notest"
// head determines printing out of header, print 

	tempname max vals cv95 cv99 testv llv parms

	_vecgetcv `test'

	mat `cv95' = r(cv95)
	mat `cv99' = r(cv99)

	if "`dboth'" == "" {
		if "`disp95'" == "disp95" {
			local cv `cv95'
			local dlevel 5
		}
		else {
			local cv `cv99'
			local dlevel 1
		}
	}

	mat `vals'  = e(lambda)
	mat `llv' = e(ll)
	mat `parms' = e(k_rank)

	if "`test'" == "max" {
		mat `testv' = e(max)
		local tname "Max-Eigenvalue"
	}
	else {
		mat `testv' = e(trace)
		local tname "Trace"
	}

	if "`test'" == "max" {
		local test " max"
	}

	local T = e(N)
	local n = e(k_eq)
	local trendtype  "`e(trend)'"

	_vecgtn `trendtype'
	local trend = r(trendnumber)
	local ttext = "`r(ttext)'"

	if "`head'" == "head" {
		di
		di as txt "{center 79:Johansen tests for cointegration}"
		di as txt "`ttext'{col 57}Number of obs = " 		///
			as res _col(6) %7.0f `T'
		di as txt "Sample:  " as res 			///
			`"`=strtrim(`"`tmin'"')'"'		///
			" - "					///
			`"`=strtrim(`"`tmax'"')'"'		///
			as txt "{col 66}Lags = " as res %7.0f e(n_lags)
		di as txt "{hline 79}"
	}

	if "`ic'" != "ic" {
		if "`dboth'" != "" {
di as txt "maximum{col 46}`test'"/*
	*/ "{col 56}5% critical{col 69}1% critical"
di as txt "  rank{col 11}parms{col 23}LL{col 32}eigenvalue"/*
	*/ "{col 44}statistic{col 59}value{col 72}value"
		}
		else {
di as txt "{col 58}`dlevel'%"
di as txt "maximum{col 46}`test'"/*
	*/ "{col 55}critical"
di as txt "  rank{col 11}parms{col 23}LL{col 32}eigenvalue"/*
	*/ "{col 44}statistic{col 57}value"
		}
		forvalues i=0/`n' {
			local im1 = `i'-1
			local ip1 = `i'+1

			if "`test'" == "trace" {
				if e(k_ce`selrank') == `i' {
local rs "{help vecrankstar##|_new:*}"
				}	
				else {
local rs 
				}

				if "`selr99'" != "" {
					if e(k_ce99) == `i' {
local rs99 "{help vecrankstar##|_new:*1}"
					}	
					else {
local rs99 
					}
				}
				if "`selr95'" != "" {
					if e(k_ce95) == `i' {
local rs95 "{help vecrankstar##|_new:*5}"
					}	
					else {
local rs95 
					}
				}
			}	
			else {
				local rs 
				local rs99 
				local rs95 
			}


			if `i' == 0 {
				if "`dboth'" != "" {
di _col(3) as res %3.0f `i'  _col(12) %-4.0f `parms'[1,`ip1']		/*
	*/ _col(19) %10.9g `llv'[1,`ip1'] 				/*
	*/ _col(44) %9.4f `testv'[1,`ip1'] "`rs99'`rs95'"		/*
	*/ _col(57) %7.2f `cv95'[`n'-`ip1'+1,`trend'] 			/*
	*/ _col(70) %7.2f `cv99'[`n'-`ip1'+1,`trend']  
				}
				else {
di _col(3) as res %3.0f `i'  _col(12) %-4.0f `parms'[1,`ip1']		/*
	*/ _col(19) %10.9g `llv'[1,`ip1'] 				/*
	*/ _col(33) %8.5f `vals'[1,`i'] 				/*
	*/ _col(44) %9.4f `testv'[1,`ip1'] "`rs'"	 		/*
	*/ _col(55) %7.2f `cv'[`n'-`ip1'+1,`trend']

				}
			}
			if `i' > 0 & `i' < `n' {
				if "`dboth'" != "" {
di _col(3) as res %3.0f `i' /*
	*/ _col(12) %-4.0f `parms'[1,`ip1']				/*
	*/ _col(19) %10.9g `llv'[1,`ip1'] 				/*
	*/ _col(33) %8.5f `vals'[1,`i'] 				/*
	*/ _col(44) %9.4f `testv'[1,`ip1'] "`rs99'`rs95'" 		/*
	*/ _col(57) %7.2f `cv95'[`n'-`ip1'+1,`trend'] 			/*
	*/ _col(70) %7.2f `cv99'[`n'-`ip1'+1,`trend'] 
				}
				else {
di _col(3) as res %3.0f `i' 						/*
	*/ _col(12) %-4.0f `parms'[1,`ip1']				/*
	*/ _col(19) %10.9g `llv'[1,`ip1'] 				/*
	*/ _col(33) %8.5f `vals'[1,`i'] 				/*
	*/ _col(44) %9.4f `testv'[1,`ip1'] "`rs'"			/*
	*/ _col(55) %7.2f `cv'[`n'-`ip1'+1,`trend'] 
				}
			}	
			if `i' == `n' {
				di _col(3) as res %3.0f `i' 		/*
					*/ _col(12) %-4.0f `parms'[1,`ip1'] /*
					*/ _col(19) %10.9g `llv'[1,`ip1']   /*
					*/ _col(33) %8.5f `vals'[1,`i']  
			}	
		}
	}
	else {
		di as txt "maximum"
		di as txt "  rank{col 11}parms{col 23}LL"	/*	
			*/ "{col 32}eigenvalue{col 47}SBIC"/*
			*/"{col 58}HQIC{col 69}AIC"

		tempname bic hqic aic
		mat `bic'  = e(sbic)
		mat `hqic' = e(hqic)
		mat `aic'  = e(aic)


		forvalues i=0/`n' {
			local im1 = `i'-1
			local ip1 = `i'+1
			
			if e(k_cesbic) == `i' {
				local rb "*"
			}
			else {
				local rb
			}

			if e(k_cehqic) == `i' {
				local rh "*"
			}
			else {
				local rh
			}
			if `i' == 0 {
				di _col(3) as res %3.0f `i' 		/*
				*/ _col(12) %-4.0f `parms'[1,`ip1']	/*
				*/ _col(19) %10.9g `llv'[1,`ip1']  	/*
				*/ _col(44) %9.8g `bic'[1,`ip1'] "`rb'"	/*
				*/ _col(55) %9.8g `hqic'[1,`ip1'] "`rh'" /*
				*/ _col(66) %9.8g `aic'[1,`ip1']  
			}

			if `i' > 0 & `i' < `n' {
				di _col(3) as res %3.0f `i' 		/*
				*/ _col(12) %-4.0f `parms'[1,`ip1']	/*
				*/ _col(19) %10.9g `llv'[1,`ip1'] 	/*
				*/ _col(33) %8.5f `vals'[1,`i'] 	/*
				*/ _col(44) %9.8g `bic'[1,`ip1'] "`rb'"	/*
				*/ _col(55) %9.8g `hqic'[1,`ip1'] "`rh'" /*
				*/ _col(66) %9.8g `aic'[1,`ip1']  
			}	

			if `i' == `n' {
				di _col(3) as res %3.0f `i' 		/*
				*/ _col(12) %-4.0f `parms'[1,`ip1']	/*
				*/ _col(19) %10.9g `llv'[1,`ip1'] 	/*
				*/ _col(33) %8.5f `vals'[1,`i'] 	/*
				*/ _col(44) %9.8g `bic'[1,`ip1'] "`rb'"	/*
				*/ _col(55) %9.8g `hqic'[1,`ip1'] "`rh'" /*
				*/ _col(66) %9.8g `aic'[1,`ip1']  

			}
		}

	}
	di as txt "{hline 79}"
end

exit

