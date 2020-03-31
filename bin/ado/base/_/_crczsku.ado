*! version 3.0.2  11nov1997
program define _crczsku, rclass
* touched by kth
	version 3.0
/*
	Args: 1=skewness or z(skewness),
	2=#obs, 3=0 (find Z), ~0(find skewness, i.e. invert).
	Result returned in r(target)
*/

	local invert = (`3'~=0)
	local an13 = (`2'+1)*(`2'+3)
	local an2 = `2'-2
	local Beta2= (3*(`2'*`2'+27*`2'-70)*`an13')/ /*
			*/ (`an2'*(`2'+5)*(`2'+7)*(`2'+9))
	local W2 = -1 + sqrt(2*(`Beta2'-1))
	local delta = 1/sqrt(log(sqrt(`W2')))
	local alpha = sqrt(2/(`W2'-1))
	if `invert' {
		local Y = `1'/`delta'
		ret scalar target = 0.5*(exp(`Y')-exp(-`Y'))*`alpha'/ /*
				*/ sqrt(`an13'/(6*`an2'))
	}
	else {
		local Y = `1'*sqrt(`an13'/(6*`an2'))/`alpha'
		ret scalar target = `delta'*log(`Y'+sqrt(`Y'^2+1))
	}
end
