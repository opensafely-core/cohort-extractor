*! version 1.1.0  17jul2014
program _pred_missings
	version 9
	syntax varname
	if (!c(noisily)) {
		exit
	}
	quietly count if missing(`varlist')
	if r(N) {
		di as txt "(`r(N)' missing values generated)"
	}
end
exit
