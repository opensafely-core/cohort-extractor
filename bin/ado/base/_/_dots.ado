*! version 1.1.1  01jul2016
program _dots
	version 8.2
	syntax [anything] [, title(string) reps(integer -1) NODOTS ///
		DOTS(numlist >0 integer max=1)]
	if "`dots'"=="" local dots 1
	tokenize `anything'
	args i rc
	if "`i'" == "0" {
		if `"`title'"' != "" {
			if `reps' > 0 {
				di as txt "`title' ("	///
				   as res `reps' as txt ")"
			}
			else {
				di as txt "`title'"
			}
		}
		if "`nodots'" == "" {
			di as txt "{hline 4}{c +}{hline 3} 1 "	///
				  "{hline 3}{c +}{hline 3} 2 "	///
				  "{hline 3}{c +}{hline 3} 3 "	///
				  "{hline 3}{c +}{hline 3} 4 "	///
				  "{hline 3}{c +}{hline 3} 5 "
		}
		exit
	}
	else if "`i'" != "" & "`rc'" == "" {
		if mod(`i',50*`dots') != 0 {
			di
		}
		exit
	}
	else if "`i'`rc'" == "" {
		di
		exit
	}
	else if mod(`i',`dots') {
		exit
	}
	else if inlist("`rc'", "0", "text") {
		di as txt "." _c
	}
	else if "`rc'" == "result" {
		di as result "." _c
	}
	else if "`rc'" == "input" {
		di as input "{bf:.}" _c
	}
	else if "`rc'" == "-1" {
		di as txt "s" _c
	}
	else if inlist("`rc'", "1", "error") {
		di as err "x" _c
	}
	else if "`rc'" == "2" {
		di as err "e" _c
	}
	else if "`rc'" == "3" {
		di as err "n" _c
	}
	else {
		di as err "?" _c
	}
	if mod(`i',50*`dots') == 0 {
		di as txt " " %5.0f `i'
	}
end

