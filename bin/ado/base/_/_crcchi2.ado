*! version 3.0.2  14nov1997
program define _crcchi2, rclass /* a b c d */ 
* touched by kth -- all done 
	version 6.0
	local a `1'
	local b `2'
	local c `3'
	local d `4'

	tempname t p11 p12 p21 p22 p1x p2x px1 px2
	scalar `t' = `a'+`c' + `b'+`d'

	scalar `p11'=`a'/`t'
	scalar `p12'=`b'/`t'
	scalar `p21'=`c'/`t'
	scalar `p22'=`d'/`t'
	scalar `p1x'=(`a'+`b')/`t'
	scalar `p2x'=(`c'+`d')/`t'
	scalar `px1'=(`a'+`c')/`t'
	scalar `px2'=(`b'+`d')/`t'
	* local c = 1/(2*`t')
	local c 0 
	ret scalar chi2 = `t'*( /*
	*/	(abs(`p11'-`p1x'*`px1')-`c')^2/(`p1x'*`px1') + /*
	*/	(abs(`p12'-`p1x'*`px2')-`c')^2/(`p1x'*`px2') + /*
	*/	(abs(`p21'-`p2x'*`px1')-`c')^2/(`p2x'*`px1') + /*
	*/	(abs(`p22'-`p2x'*`px2')-`c')^2/(`p2x'*`px2'))
end
exit
cumulative incidence data, risk difference
F-22	chi2 value with[out] continuity correction
