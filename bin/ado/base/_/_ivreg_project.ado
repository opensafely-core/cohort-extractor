*! version 1.0.0  03jan2005
program _ivreg_project
	version 9
	syntax [pw iw] [if]
	if "`weight'" != "" {
		local wt `"[iw`exp']"'
	}
	local instd `e(instd)'
	local insts `e(insts)'
	tempname hold
	estimates store `hold'

capture noisily quietly {

	foreach y of local instd {
		tempvar newy
		regress `y' `insts' `wt' `if'
		_predict double `newy' if e(sample)
		replace `newy' = 0 if missing(`newy')
		drop `y'
		rename `newy' `y'
	}

} // capture noisily quietly

nobreak {

	local rc = c(rc)
	estimates restore `hold', drop

} // nobreak

	exit `rc'
end
