*! version 1.0.0  03jul2002
program define dirstats, rclass
	version 8

	local NUMOFLTRSTOLIST 10

	syntax [, BASE LEAVE PLUS UPDATES]

	local cnt = ("`base'"!="") + ("`plus'"!="") + ("`updates'"!="") 
	if `cnt' > 1 { 
		di as err ///
		"may specify only one of options base, plus, or updates"
		exit 198
	}
	if `cnt'==0 {
		local thedir "BASE"
	}
	else {
		if "`plus'"!="" {
			local thedir "PLUS"
		}
		else 	local thedir "UPDATES"
	}

	if "`leave'"=="" {
		preserve
	}
		
	local dirs "_ a b c d e f g h i j k l m n o p q r s t u v w x y z"
	quietly {
		drop _all
		local n : word count `dirs'
		set obs `n'
		gen str1 ltr = ""
		gen long n = 0 
	}

	local i 1
	local base : sysdir `thedir'
	foreach ltr of local dirs {
		capture local x : dir "`base'`ltr'" files "*"
		if _rc {
			if _rc==1 {
				quietly drop _all
				exit 1
			}
			local n 0
		}
		else	local n : word count `x'
		quietly replace ltr = "`ltr'" in `i'
		quietly replace n   = `n' in `i++'
	}

	quietly {
		tempvar negn
		gen `negn' = -n 
		sort `negn'

		sum n, detail 
		ret scalar N_t = r(N)
		ret scalar mean_t = r(mean)
		ret scalar median_t = r(p50)
		ret scalar min_t = r(min)
		ret scalar max_t = r(max)
		ret scalar sum = r(sum)

		sum n if n, detail 
		ret scalar N_d = r(N)
		ret scalar mean_d = r(mean)
		ret scalar median_d = r(p50)
		ret scalar min_d = r(min)
		ret scalar max_d = r(max)

		forvalues i=1(1)`NUMOFLTRSTOLIST' {
			if _N>=`i' {
				ret local l`i' = ltr[`i']
				ret scalar n`i' = n[`i']
				ret scalar p`i' = 100*n[`i']/return(sum)
			}
			else {
				ret local l`i' = " "
				ret scalar n`i' = .
				ret scalar p`i' = .
			}
		}
	}


	di 
	di as txt _col(17) "of defined" _col(36) "of total"
	di as txt "   {hline 40}"
	di as txt _col(4) "# of dirs" as res ///
		_col(18) %9.0g return(N_d) _col(35) %9.0g return(N_t)
	di as txt _col(4) "mean" as res ///
		_col(18) %9.2f return(mean_d) _col(35) %9.2f return(mean_t)
	di as txt _col(4) "median" as res ///
		_col(18) %9.2f return(median_d) _col(35) %9.2f return(median_t)
	di as txt _col(4) "min" as res ///
		_col(18) %9.0gc return(min_d) _col(35) %9.0gc return(min_t)
	di as txt _col(4) "max" as res ///
		_col(18) %9.0gc return(max_d) _col(35) %9.0gc return(max_t)
	di as txt _col(4) "sum" as res ///
		_col(18) %9.0gc return(sum) _col(35) %9.0gc return(sum)


	di as txt _n _col(4) "most frequent"
	forvalues i=1(1)`NUMOFLTRSTOLIST' {
		di as txt _col(8) %2.0f `i' ".  `return(l`i')'" ///
			_col(18) as res %9.0gc return(n`i') ///
			%9.2f return(p`i') "%"

	}
end
exit
----+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
                  of total       of defined
   ----------------------------------------
   # of dirs            26               11
                 123456789        123456789
   mean              11.11            11.11
   median            11.11            11.11
   min                0.00             0.00
   max               10.00            10.00

   most frequent
      1.  s                                10.00
      t                                10.00
      u                                10.00
      v                                10.00


   
    




