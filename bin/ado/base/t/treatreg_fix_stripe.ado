*! version 1.0.0  10apr2009
program treatreg_fix_stripe, eclass
	version 11

	if "`e(cmd)'" != "treatreg" {
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
	if `"`colna'"' == "hazard:lambda" {
		matrix colna `b' = `new' hazard:_cons
		ereturn repost b=`b', rename
	}
end
