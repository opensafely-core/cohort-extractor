*! version 1.0.1  13nov2008
program _mat_fill0
	version 11
	syntax name(name=m),			///
		K(numlist int >0 max=1)		///
	[					///
		ROW(numlist int max=1)		///
		COL(numlist int max=1)		///
		value(real 0)			///
	]

	tempname t
	if `:length local col' {
		local r = rowsof(`m')
		if `r' > 1 {
			local rr "1..`r'"
		}
		else	local rr 1
		if `col' == 1 {
			matrix `t' = J(`r',`k',0), `m'
		}
		else if `col' > colsof(`m') {
			matrix `t' = `m', J(`r',`k',0)
		}
		else {
			local col0 = `col' - 1
			local rng0 "1..`col0'"
			local rng1 "`col'..."
			matrix `t' =	`m'[`rr',`rng0']	,	///
					J(`r',`k',`value')	,	///
					`m'[`rr',`rng1']
		}
		matrix drop `m'
		matrix rename `t' `m'
	}
	if `:length local row' {
		local c = colsof(`m')
		if `c' > 1 {
			local cc "1..`c'"
		}
		else	local cc 1
		if `row' == 1 {
			matrix `t' = J(`k',`c',`value') \ `m'
		}
		else if `row' > rowsof(`m') {
			matrix `t' = `m' \ J(`k',`c',`value')
		}
		else {
			local row0 = `row' - 1
			local rng0 "1..`row0'"
			local rng1 "`row'..."
			matrix `t' =	`m'[`rng0',`cc']	\	///
					J(`k',`c',`value')	\	///
					`m'[`rng1',`cc']
		}
		matrix drop `m'
		matrix rename `t' `m'
	}
end
exit
