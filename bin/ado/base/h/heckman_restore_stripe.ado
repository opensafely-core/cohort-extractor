*! version 1.0.0  10apr2009
program heckman_restore_stripe, eclass
	version 11

	if "`e(cmd)'" != "heckman" {
		error 301
	}
	if "`e(method)'" != "two-step" {
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
	if `"`colna'"' == "mills:_cons" {
		matrix colna `b' = `new' mills:lambda
		ereturn repost b=`b', rename
	}
end
