*! version 1.0.2  16feb2015
program proc_time
	version 8
	local 0 `"using `0'"'
	syntax using/ 

	if index("`using'", ".") == 0 {
		local using `"`using'.log"' 
	}

	confirm file "`using'"

	quietly {
		drop _all
		infix str orig 1-80 using "`using'" ///
				if bsubstr(orig,1,8)=="+++TIME "
		compress
		replace orig = substr(orig,9,.) 
		compress
		gen str w1 = word(orig,1) 
		gen str w2 = word(orig,2) 
		gen str w3 = word(orig,3)
		drop orig
		gen double t1 = real(w1) 
		gen double t2 = real(w2) 
		drop w1 w2
		sort w3
		by w3: replace t1 = sum(t1) 
		by w3: replace t2 = sum(t2) 
		by w3: gen `c(obs_t)' N = _N
		by w3: keep if _n==_N
		rename t1 t_tot
		rename t2 t_sub
		gen double t_own = t_tot - t_sub
		rename w3 sub
		order sub N t_tot t_own t_sub

		tempname max sum
		summarize t_tot
		scalar `max' = r(max)
		summarize t_own
		scalar `sum' = r(sum)
		set obs `=_N+1'
		replace sub = "UNALLOC" in l 
		replace N = 1 in l 
		replace t_tot = `sum' - `max' in l 
		replace t_own = t_tot in l 
		replace t_sub = 0 in l 

		tempvar order
		gen `order' = -t_own
		sort `order'
		drop `order'

		label var sub "Routine name"
		label var N "number of calls"
		label var t_tot "total xeq time"
		label var t_own "own xeq time"
		label var t_own "subroutine xeq time"
		
	}
	list, string(28)
end

