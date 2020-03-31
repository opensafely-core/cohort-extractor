*! version 1.0.0  09feb1997
program define spline_x  /* 2nd_deriv_var yvar xvar markvar byvars */
	version 5.0
	local s    "`1'"
	local y    "`2'"
	local x    "`3'"
	local doit "`4'"
	macro shift 4
	local by "by `doit' `*':"
	
	tempvar z w
	
	quietly {
		#delimit ;
		`by' gen double `s' = -0.5 if _n==1 & `doit' ;
		`by' gen double `z' = (3/(`x'[2]-`x'[1]))
			*(  (`y'[2]-`y'[3])/(`x'[2]-`x'[3])
			  - (`y'[1]-`y'[3])/(`x'[1]-`x'[3]))
			if _n==1 & `doit' ;
		
		`by' gen double `w' = (`x'-`x'[_n-1])/(`x'[_n+1]-`x'[_n-1]) 
			if `doit' ;
	
		`by' replace `s' = (`w'-1)/(`w'*`s'[_n-1]+2) 
			if 1<_n & _n<_N & `doit' ;
		
		`by' replace `z' = (6*((`y'[_n+1]-`y')/(`x'[_n+1]-`x')
			-(`y'-`y'[_n-1])/(`x'-`x'[_n-1]))
			/(`x'[_n+1]-`x'[_n-1]) - `w'*`z'[_n-1])
			/(`w'*`s'[_n-1]+2)
			if 1<_n & _n<_N & `doit' ;
					
		`by' replace `w' = ((6/(`x'[_N]-`x'[_N-1]))
			*(  (`y'[_N]-`y'[_N-2])/(`x'[_N]-`x'[_N-2])
			  - (`y'[_N-1]-`y'[_N-2])/(`x'[_N-1]-`x'[_N-2]) )
			-`z'[_N-1])/(`s'[_N-1]+2)
			if _n==1 & `doit' ;

		`by' replace `w' = `s'[_N-_n+1]*`w'[_n-1]+`z'[_N-_n+1] 
			if _n>1 & `doit' ;
		
		`by' replace `s' = `w'[_N-_n+1] if `doit' ;
		
		#delimit cr
	}
end
