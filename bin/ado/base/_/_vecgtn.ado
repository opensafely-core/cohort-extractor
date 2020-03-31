*! version 1.0.0  02mar2004
program define _vecgtn, rclass
	version 8.2

//  returns column number of critical value matrix (trend number) for
//  a trendtype
//  trendtype 	number
//  none	1
//  rconstant	2
//  constant	3
//  rtrend	4
//  trend	5

	local trendtype `1'

	if "`trendtype'" == "none" {
		local trend = 1 
		local ttext "Trend: `trendtype'"
	}

	if "`trendtype'" == "rconstant" {
		local trend = 2 
		local ttext "Trend: `trendtype'"
	}
	
	if "`trendtype'" == "constant" {
		local trend = 3 
		local ttext "Trend: `trendtype'"
	}
	
	if "`trendtype'" == "rtrend" {
		local trend = 4 
		local ttext "Trend: `trendtype'"
	}
	
	if "`trendtype'" == "trend" {
		local trend = 5 
		local ttext "Trend: `trendtype'"
	}

	ret scalar trendnumber = `trend'
	ret local ttext "`ttext'"

end
