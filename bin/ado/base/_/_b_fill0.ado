*! version 1.1.0  29mar2007
program _b_fill0
	version 9.2
	syntax anything [, NOEQ]
	local 0 `anything'
	args b xvars

	local nxvars : list sizeof xvars
	if `nxvars' == colsof(`b') {
		exit
	}
	tempname newb
	matrix `newb' = J(1,`nxvars',0)
	if `:length local noeq' {
		local colna : colna `b'
	}
	else	local colna : colful `b'
	local j 0
	local xcopy : copy local xvars
	forval i = 1/`nxvars' {
		gettoken xvar xcopy : xcopy
		gettoken x : colna
		if `:list xvar == x' {
			local ++j
			matrix `newb'[1,`i'] = `b'[1,`j']
			gettoken x colna : colna
		}
	}
	matrix `b' = `newb'
	matrix colna `b' = `xvars'
end
exit
