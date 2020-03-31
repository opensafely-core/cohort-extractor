*! version 1.0.0  17feb2009

program _xtstrbal, rclass sortpreserve

	args panvar tvar touse
	
	qui {
		// Check all panels have same # of obs
		tempvar np
		bys `panvar': generate `np' = `touse'
		by  `panvar': replace `np' = sum(`np')
		by  `panvar': replace `np' = `np'[_N]
		summ `np' if `touse', mean
		capture assert r(min)==r(max)
		if _rc {
			return local strbal "no"
			exit
		}
		else {
			local capT = r(min)
		}
		
		// Check all times have same # of obs
		tempvar nt
		bys `tvar': gen `nt' = `touse'
		by  `tvar': replace `nt' = sum(`nt')
		by  `tvar': replace `nt' = `nt'[_N]
		summ `nt' if `touse', mean
		capture assert r(min)==r(max)
		if _rc {
			return local strbal "no"
			exit
		}
		return scalar capN = r(min)
		return scalar capT = `capT'
		return local strbal "yes"
	}
		
end
