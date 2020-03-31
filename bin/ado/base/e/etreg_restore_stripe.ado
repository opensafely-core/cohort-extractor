*! version 1.0.0  27jan2013
program etreg_restore_stripe, eclass
	version 11

	if "`e(cmd)'" != "etregress" {
		error 301
	}
	if "`e(method)'" != "twostep" {
		exit
	}
	tempname b
	matrix `b' = e(b)
	local colna : colf `b'
	local k : list sizeof colna
	local --k
	forval i = 1/`k' {
		gettoken x colna : colna
		local new `new' `x'
	}
	local colna : list retok colna
	if `"`colna'"' == "hazard:_cons" {
		matrix colna `b' = `new' hazard:lambda
		ereturn repost b=`b', rename
	}
end
