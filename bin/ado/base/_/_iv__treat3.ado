*! version 1.0.3  25mar2016
program _iv__treat3
	version 14
	syntax varlist if [fweight iweight pweight], 		///
			at(name) 				///
			y0(varlist) 				///
			y1(varlist)				///                      
			ty(varlist) 				///
			stat(string)				///
			tn(string)				///
			nn(string)				///
			[					///
			fin(integer -1)				///
			derivatives(varlist)			///
			uhat(varname)				///
			*					///
			]
			
	quietly {
		if "`stat'"=="ate" {
			tempvar mut mub0 mub1 muate muatet muy0 muy1	///
				muhat0 muhat1 xb0 xb1
			tokenize `varlist'
			local bate  `1'
			local bp0   `2'
			local bt    `3'
			local by0   `4'
			local by1   `5'
			local bp1   `6'		
			local batet `7'
			local buh0  `8'
			local buh1  `9'
			local N  = `nn'
			local nt = `tn'
			matrix score double `mut'    = `at' `if', eq(#3)
			qui replace `bt'    = 				///
				`ty'*normalden(`mut')/normal(`mut')- 	/// 
				(1-`ty')*normalden(`mut')/(1- normal(`mut')) ///
				`if'
			replace `uhat' = (`ty' - normal(`mut'))
			matrix score double `muate'  = `at' `if', eq(#1) 
			matrix score double `muy0'   = `at' `if', eq(#2) 
			matrix score double `mub0'   = `at' `if', eq(#4)  
			matrix score double `mub1'   = `at' `if', eq(#5) 
			matrix score double `muy1'   = `at' `if', eq(#6) 
			matrix score double `muatet' = `at' `if', eq(#7) 
			matrix score double `muhat0' = `at' `if', eq(#8)  
			matrix score double `muhat1' = `at' `if', eq(#9) 
			
			generate double `xb0' = exp(`mub0' + `muhat0')
			generate double `xb1' = exp(`mub1' + `muhat1')
			
			replace `by0'   = (`y0'-`xb0')*(1-`ty') `if'
			replace `by1'   = (`y1'-`xb1')*(`ty')   `if'
			replace `bate'  = `xb1'-`xb0'- `muate' `if'
			replace `batet' =(`xb1'-`xb0')*(`N'*`ty'/`nt') ///
					  - `muatet' `if'
			replace `bp0'   = `xb0'-`muy0' `if'
			replace `bp1'   = `xb1'-`muy1' `if'
			replace `buh0'  = (`y0'-`xb0')*(1-`ty')*`uhat' `if'
			replace `buh1'  = (`y1'-`xb1')*(`ty')*`uhat' `if'

			if "`derivatives'" == "" {
				exit
			}

		// Getting derivatives for 9 equations and 9 xb parameters 
		
			forvalues i=1/81 {
				local d`i': word `i' of `derivatives'
			}
			
			local u0 = `fin'-1
			local u1 = `fin'
			
			// Local for derivatives w.r.t  probit 
			tempvar nl1 nl2 den1 nl3 nl4 den2 dtd
			generate double `nl1'  = ///
				`ty'*normalden(`mut')*normal(`mut')*(-`mut')
			generate double `nl2'  = `ty'*normalden(`mut')^2 
			generate double `den1' = normal(`mut')^2 
			generate double `nl3'  = ///
			(1-`ty')*normalden(`mut')*(1-normal(`mut'))*(-`mut')
			generate double `nl4'  = (1-`ty')*normalden(`mut')^2 
			generate double `den2' = (1-normal(`mut'))^2
			generate double `dtd'  = ///
				((`nl1'-`nl2')/`den1') -((`nl3'+ `nl4')/`den2')
			
			// muate 
			quietly {
			replace `d1'   =-1 `if'
			replace `d2'   = 0 `if'
			replace `d3'   = normalden(`mut')*( ///
					 `at'[1,`u0']*`xb0' - ///
					 `at'[1,`u1']*`xb1') `if'
			replace `d4'   =-`xb0' `if'
			replace `d5'   = `xb1' `if'
			replace `d6'   = 0 `if'
			replace `d7'   = 0 `if'
			replace `d8'   = -`xb0' `if'
			replace `d9'   = `xb1' `if'
			
			// muy0
			replace `d10'   = 0 `if'
			replace `d11'   =-1 `if'
			replace `d12'  = ///
				-`xb0'*normalden(`mut')*`at'[1,`u0'] `if'
			replace `d13'  = `xb0' `if'
			replace `d14'  = 0 `if'
			replace `d15'  = 0 `if'
			replace `d16'  = 0 `if'
			replace `d17'  = `xb0' `if'
			replace `d18'  = 0 `if'
			
			//mut 
			replace `d19'  = 0 `if'
			replace `d20'  = 0 `if'
			replace `d21'  = `dtd' `if'
			replace `d22'  = 0 `if'
			replace `d23'  = 0 `if'
			replace `d24'  = 0 `if'
			replace `d25'  = 0 `if'
			replace `d26'  = 0 `if'
			replace `d27'  = 0 `if'
			
			//mub0
			replace `d28'  = 0 `if'
			replace `d29'  = 0 `if'
			replace `d30'  = ///
			      (1-`ty')*`xb0'*normalden(`mut')*`at'[1,`u0'] `if'
			replace `d31'  = -(1-`ty')*`xb0' `if'
			replace `d32'  = 0 `if'
			replace `d33'  = 0 `if'
			replace `d34'  = 0 `if'
			replace `d35'  = -(1-`ty')*`xb0' `if'
			replace `d36'  = 0 `if'
			
			//mub1
			replace `d37'  = 0 `if'
			replace `d38'  = 0 `if'
			replace `d39'  = ///
			      `ty'*`xb1'*normalden(`mut')*`at'[1,`u1'] `if'
			replace `d40'  = 0 `if'
			replace `d41'  = -`ty'*`xb1' `if'
			replace `d42'  = 0 `if'
			replace `d43'  = 0 `if'
			replace `d44'  = 0 `if'
			replace `d45'  = -`ty'*`xb1' `if'
			
			// muy1
			replace `d46'  = 0 `if'
			replace `d47'  = 0 `if'
			replace `d48'  = ///
				-`xb1'*normalden(`mut')*`at'[1,`u1'] `if'
			replace `d49'  = 0 `if'
			replace `d50'  = `xb1' `if'
			replace `d51'  = -1 `if'
			replace `d52'  = 0  `if'
			replace `d53'  = 0 `if'
			replace `d54'  = `xb1' `if'
			
			// muatet
			replace `d55'  = 0  `if'
			replace `d56'  = 0  `if'
			replace `d57'  = (`N'*`ty'/`nt')*normalden(`mut')*( ///
					 `at'[1,`u0']*`xb0' - ///
					 `at'[1,`u1']*`xb1') `if'
			replace `d58'  =-(`N'*`ty'/`nt')*`xb0'  `if'
			replace `d59'  = (`N'*`ty'/`nt')*`xb1'  `if'
			replace `d60'  = 0 `if'
			replace `d61'  =-1  `if'
			replace `d62'  = -(`N'*`ty'/`nt')*`xb0' `if'
			replace `d63'  =  (`N'*`ty'/`nt')*`xb1' `if'
			
			//muhat0
			replace `d64'  = 0 `if'
			replace `d65'  = 0 `if'
			replace `d66'  = -`by0'*normalden(`mut') + ///
					 `d30'*`uhat' `if'
			replace `d67'  = -(1-`ty')*`xb0'*`uhat' `if'
			replace `d68'  = 0 `if'
			replace `d69'  = 0 `if'
			replace `d70'  = 0 `if'
			replace `d71'  = -(1-`ty')*`xb0'*`uhat' `if'
			replace `d72'  = 0 `if'
			
			//muhat1
			replace `d73'  = 0 `if'
			replace `d74'  = 0 `if'
			replace `d75'  = -`by1'*normalden(`mut') + ///
					 `d39'*`uhat' `if'
			replace `d76'  = 0 `if'
			replace `d77'  = -`ty'*`xb1'*`uhat' `if'
			replace `d78'  = 0 `if'
			replace `d79'  = 0 `if'
			replace `d80'  = 0 `if'
			replace `d81'  = -`ty'*`xb1'*`uhat' `if'
			}
		}
		if "`stat'"=="atet" {
			tempvar mut mub0 mub1 muate muatet muy0 muy1	///
				muhat0 muhat1 xb0 xb1 
			tokenize `varlist'
			local batet `1'
			local bp0   `2'
			local bt    `3'
			local by0   `4'
			local by1   `5'
			local bp1   `6'		
			local bate  `7'
			local buh0  `8'
			local buh1  `9'
			local N  = `nn'
			local nt = `tn'
			matrix score double `mut'    = `at' `if', eq(#3)
			qui replace `bt'    = 				///
				`ty'*normalden(`mut')/normal(`mut')- 	/// 
				(1-`ty')*normalden(`mut')/(1- normal(`mut')) ///
				`if'
			replace `uhat' = (`ty' - normal(`mut'))
			matrix score double `muatet' = `at' `if', eq(#1) 
			matrix score double `muy0'   = `at' `if', eq(#2) 
			matrix score double `mub0'   = `at' `if', eq(#4)  
			matrix score double `mub1'   = `at' `if', eq(#5) 
			matrix score double `muy1'   = `at' `if', eq(#6) 
			matrix score double `muate'  = `at' `if', eq(#7) 
			matrix score double `muhat0' = `at' `if', eq(#8)  
			matrix score double `muhat1' = `at' `if', eq(#9) 

			generate double `xb0' = exp(`mub0' + `muhat0')
			generate double `xb1' = exp(`mub1' + `muhat1')
			
			replace `by0'   = (`y0'-`xb0')*(1-`ty') `if'
			replace `by1'   = (`y1'-`xb1')*(`ty') `if'
			replace `bate'  = `xb1'-`xb0'- `muate' `if'
			replace `batet' = (`xb1'-`xb0')*(`N'*`ty'/`nt') ///
						- `muatet' `if'
			replace `bp0'   = (`xb0'-`muy0')*`ty' `if'
			replace `bp1'   = (`xb1'-`muy1')*`ty' `if'
			replace `buh0'   = (`y0'-`xb0')*(1-`ty')*`uhat' `if'
			replace `buh1'   = (`y1'-`xb1')*(`ty')*`uhat' `if'
			
			if "`derivatives'" == "" {
				exit
			}
		// Getting derivatives for 9 equations and 9 xb parameters 
		
			forvalues i=1/81 {
				local d`i': word `i' of `derivatives'
			}
			
			local u0 = `fin'-1
			local u1 = `fin'
			
			// Local for derivatives w.r.t  probit 
			tempvar nl1 nl2 den1 nl3 nl4 den2 dtd
			generate double `nl1'  = ///
				`ty'*normalden(`mut')*normal(`mut')*(-`mut')
			generate double `nl2'  = `ty'*normalden(`mut')^2 
			generate double `den1' = normal(`mut')^2 
			generate double `nl3'  = ///
			(1-`ty')*normalden(`mut')*(1-normal(`mut'))*(-`mut')
			generate double `nl4'  = (1-`ty')*normalden(`mut')^2 
			generate double `den2' = (1-normal(`mut'))^2
			generate double `dtd'  = ///
				((`nl1'-`nl2')/`den1') -((`nl3'+ `nl4')/`den2')
			
			// muatet 
			
			replace `d1'   =-1 `if'
			replace `d2'   = 0 `if'
			replace `d3'   = (`N'*`ty'/`nt')*normalden(`mut')*( ///
					 `at'[1,`u0']*`xb0' - ///
					 `at'[1,`u1']*`xb1') `if'
			replace `d4'   =-`xb0'*(`N'*`ty'/`nt') `if'
			replace `d5'   = `xb1'*(`N'*`ty'/`nt') `if'
			replace `d6'   = 0 `if'
			replace `d7'   = 0 `if'
			replace `d8'   = -`xb0'*(`N'*`ty'/`nt') `if'
			replace `d9'   = `xb1'*(`N'*`ty'/`nt') `if'
			
			// muy0
			replace `d10'   = 0 `if'
			replace `d11'   =-`ty' `if'
			replace `d12'  = ///
				-`ty'*`xb0'*normalden(`mut')*`at'[1,`u0'] `if'
			replace `d13'  = `ty'*`xb0' `if'
			replace `d14'  = 0 `if'
			replace `d15'  = 0 `if'
			replace `d16'  = 0 `if'
			replace `d17'  = `xb0'*`ty' `if'
			replace `d18'  = 0 `if'
			
			//mut 
			replace `d19'  = 0 `if'
			replace `d20'  = 0 `if'
			replace `d21'  = `dtd' `if'
			replace `d22'  = 0 `if'
			replace `d23'  = 0 `if'
			replace `d24'  = 0 `if'
			replace `d25'  = 0 `if'
			replace `d26'  = 0 `if'
			replace `d27'  = 0 `if'
			
			//mub0
			replace `d28'  = 0 `if'
			replace `d29'  = 0 `if'
			replace `d30'  = ///
			      (1-`ty')*`xb0'*normalden(`mut')*`at'[1,`u0'] `if'
			replace `d31'  = -(1-`ty')*`xb0' `if'
			replace `d32'  = 0 `if'
			replace `d33'  = 0 `if'
			replace `d34'  = 0 `if'
			replace `d35'  = -(1-`ty')*`xb0' `if'
			replace `d36'  = 0 `if'
			
			//mub1
			replace `d37'  = 0 `if'
			replace `d38'  = 0 `if'
			replace `d39'  = ///
			      `ty'*`xb1'*normalden(`mut')*`at'[1,`u1'] `if'
			replace `d40'  = 0 `if'
			replace `d41'  = -`ty'*`xb1' `if'
			replace `d42'  = 0 `if'
			replace `d43'  = 0 `if'
			replace `d44'  = 0 `if'
			replace `d45'  = -`ty'*`xb1' `if'
			
			// muy1
			replace `d46'  = 0 `if'
			replace `d47'  = 0 `if'
			replace `d48'  = ///
				-`ty'*`xb1'*normalden(`mut')*`at'[1,`u1'] `if'
			replace `d49'  = 0 `if'
			replace `d50'  = `ty'*`xb1' `if'
			replace `d51'  = -`ty' `if'
			replace `d52'  = 0  `if'
			replace `d53'  = 0 `if'
			replace `d54'  = `xb1'*`ty' `if'
			
			// muate
			replace `d55'  = 0  `if'
			replace `d56'  = 0  `if'
			replace `d57'  = normalden(`mut')*( ///
					 `at'[1,`u0']*`xb0' - ///
					 `at'[1,`u1']*`xb1') `if'
			replace `d58'  =-`xb0'  `if'
			replace `d59'  = `xb1'  `if'
			replace `d60'  = 0 `if'
			replace `d61'  =-1  `if'
			replace `d62'  = -`xb0' `if'
			replace `d63'  = `xb1' `if'
			
			//muhat0
			replace `d64'  = 0 `if'
			replace `d65'  = 0 `if'
			replace `d66'  = -`by0'*normalden(`mut') + ///
					 (`d30')*`uhat' `if'
			replace `d67'  = -(1-`ty')*`xb0'*`uhat' `if'
			replace `d68'  = 0 `if'
			replace `d69'  = 0 `if'
			replace `d70'  = 0 `if'
			replace `d71'  = -(1-`ty')*`xb0'*`uhat' `if'
			replace `d72'  = 0 `if'
			
			//muhat1
			replace `d73'  = 0 `if'
			replace `d74'  = 0 `if'
			replace `d75'  = -`by1'*normalden(`mut') + ///
					 (`d39')*`uhat' `if'
			replace `d76'  = 0 `if'
			replace `d77'  = -`ty'*`xb1'*`uhat' `if'
			replace `d78'  = 0 `if'
			replace `d79'  = 0 `if'
			replace `d80'  = 0 `if'
			replace `d81'  = -`ty'*`xb1'*`uhat' `if'
		}
		if "`stat'"=="pomeans" {
			tempvar mut mub0 mub1 muate muatet muy0 muy1	///
				muhat0 muhat1 xb0 xb1		
			tokenize `varlist'
			local bp0   `1'
			local bp1   `2'	
			local bt    `3'	
			local by0   `4'
			local by1   `5'
			local bate  `6'
			local batet `7'
			local buh0  `8'
			local buh1  `9'
			local N  = `nn'
			local nt = `tn'

			matrix score double `mut'    = `at' `if', eq(#3)
			qui replace `bt'    = 				///
				`ty'*normalden(`mut')/normal(`mut')- 	/// 
				(1-`ty')*normalden(`mut')/(1- normal(`mut')) ///
				`if'
			replace `uhat' = (`ty' - normal(`mut'))
			matrix score double `muy0'   = `at' `if', eq(#1) 
			matrix score double `muy1'   = `at' `if', eq(#2)
			matrix score double `mub0'   = `at' `if', eq(#4)  
			matrix score double `mub1'   = `at' `if', eq(#5) 
			matrix score double `muate'  = `at' `if', eq(#6)  
			matrix score double `muatet' = `at' `if', eq(#7) 
			matrix score double `muhat0' = `at' `if', eq(#8)  
			matrix score double `muhat1' = `at' `if', eq(#9) 
			
			generate double `xb0' = exp(`mub0' + `muhat0')
			generate double `xb1' = exp(`mub1' + `muhat1')
			 
			replace `by1'   = (`y1'-`xb1')*(`ty') `if'
			replace `by0'   = (`y0'-`xb0')*(1-`ty') `if'
			replace `bate'  = `xb1'-`xb0'- `muate' `if'
			replace `batet' = (`xb1'- `xb0')*(`N'*`ty'/`nt') ///
						- `muatet' `if'
			replace `bp0'   = `xb0'-`muy0' `if'
			replace `bp1'   = `xb1'-`muy1' `if'
			qui replace `buh0'   = (`y0'-`xb0')*(1-`ty')*`uhat' `if'
			qui replace `buh1'   = (`y1'-`xb1')*(`ty')*`uhat' `if'
			
			if "`derivatives'" == "" {
				exit
			}
			
		// Getting derivatives for 9 equations and 9 xb parameters 
		
			forvalues i=1/81 {
				local d`i': word `i' of `derivatives'
			}
			
			local u0 = `fin'-1
			local u1 = `fin'
			
			// Local for derivatives w.r.t  probit 
			tempvar nl1 nl2 den1 nl3 nl4 den2 dtd
			generate double `nl1'  = ///
				`ty'*normalden(`mut')*normal(`mut')*(-`mut')
			generate double `nl2'  = `ty'*normalden(`mut')^2 
			generate double `den1' = normal(`mut')^2 
			generate double `nl3'  = ///
			(1-`ty')*normalden(`mut')*(1-normal(`mut'))*(-`mut')
			generate double `nl4'  = (1-`ty')*normalden(`mut')^2 
			generate double `den2' = (1-normal(`mut'))^2
			generate double `dtd'  = ///
				((`nl1'-`nl2')/`den1') -((`nl3'+ `nl4')/`den2')
			
			// muy0 
			replace `d1'   =-1 `if'
			replace `d2'   = 0 `if'
			replace `d3'   = ///
				-`xb0'*normalden(`mut')*`at'[1,`u0'] `if'
			replace `d4'   =`xb0' `if'
			replace `d5'   = 0 `if'
			replace `d6'   = 0 `if'
			replace `d7'   = 0 `if'
			replace `d8'   = `xb0' `if'
			replace `d9'   = 0 `if'
			
			// muy1
			replace `d10'   = 0 `if'
			replace `d11'   =-1 `if'
			replace `d12'  = ///
				-`xb1'*normalden(`mut')*`at'[1,`u1'] `if'
			replace `d13'  = 0 `if'
			replace `d14'  = `xb1' `if'
			replace `d15'  = 0 `if'
			replace `d16'  = 0 `if'
			replace `d17'  = 0 `if'
			replace `d18'  = `xb1' `if'
			
			//mut 
			replace `d19'  = 0 `if'
			replace `d20'  = 0 `if'
			replace `d21'  = `dtd' `if'
			replace `d22'  = 0 `if'
			replace `d23'  = 0 `if'
			replace `d24'  = 0 `if'
			replace `d25'  = 0 `if'
			replace `d26'  = 0 `if'
			replace `d27'  = 0 `if'
			
			//mub0
			replace `d28'  = 0 `if'
			replace `d29'  = 0 `if'
			replace `d30'  = ///
			      (1-`ty')*`xb0'*normalden(`mut')*`at'[1,`u0'] `if'
			replace `d31'  = -(1-`ty')*`xb0' `if'
			replace `d32'  = 0 `if'
			replace `d33'  = 0 `if'
			replace `d34'  = 0 `if'
			replace `d35'  = -(1-`ty')*`xb0' `if'
			replace `d36'  = 0 `if'
			
			//mub1
			replace `d37'  = 0 `if'
			replace `d38'  = 0 `if'
			replace `d39'  = ///
			      `ty'*`xb1'*normalden(`mut')*`at'[1,`u1'] `if'
			replace `d40'  = 0 `if'
			replace `d41'  = -`ty'*`xb1' `if'
			replace `d42'  = 0 `if'
			replace `d43'  = 0 `if'
			replace `d44'  = 0 `if'
			replace `d45'  = -`ty'*`xb1' `if'
			
			// muate
			replace `d46'  = 0 `if'
			replace `d47'  = 0 `if'
			replace `d48'  =  normalden(`mut')*( ///
					 `at'[1,`u0']*`xb0' - ///
					 `at'[1,`u1']*`xb1') `if'
			replace `d49'  = -`xb0' `if'
			replace `d50'  = `xb1' `if'
			replace `d51'  = -1 `if'
			replace `d52'  = 0  `if'
			replace `d53'  = -`xb0' `if'
			replace `d54'  = `xb1' `if'
			
			// muatet
			replace `d55'  = 0  `if'
			replace `d56'  = 0  `if'
			replace `d57'  = (`N'*`ty'/`nt')*normalden(`mut')*( ///
					 `at'[1,`u0']*`xb0' - ///
					 `at'[1,`u1']*`xb1') `if'
			replace `d58'  =-(`N'*`ty'/`nt')*`xb0'  `if'
			replace `d59'  = (`N'*`ty'/`nt')*`xb1'  `if'
			replace `d60'  = 0 `if'
			replace `d61'  =-1  `if'
			replace `d62'  = -(`N'*`ty'/`nt')*`xb0' `if'
			replace `d63'  =  (`N'*`ty'/`nt')*`xb1' `if'
			
			//muhat0
			replace `d64'  = 0 `if'
			replace `d65'  = 0 `if'
			replace `d66'  = -`by0'*normalden(`mut') + ///
					 `d30'*`uhat' `if'
			replace `d67'  = -(1-`ty')*`xb0'*`uhat' `if'
			replace `d68'  = 0 `if'
			replace `d69'  = 0 `if'
			replace `d70'  = 0 `if'
			replace `d71'  = -(1-`ty')*`xb0'*`uhat' `if'
			replace `d72'  = 0 `if'
			
			//muhat1
			replace `d73'  = 0 `if'
			replace `d74'  = 0 `if'
			replace `d75'  = -`by1'*normalden(`mut') + ///
					 `d39'*`uhat' `if'
			replace `d76'  = 0 `if'
			replace `d77'  = -`ty'*`xb1'*`uhat' `if'
			replace `d78'  = 0 `if'
			replace `d79'  = 0 `if'
			replace `d80'  = 0 `if'
			replace `d81'  = -`ty'*`xb1'*`uhat' `if'
		}
	}
end
