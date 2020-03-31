*! version 1.0.0  26jan2007
program _mixed_fixupconstant
	version 9
	args beg end s_constant

	forvalues s = `beg'/`=`end'-1' {
		if `s' == `s_constant' {
			c_local constant_`s'
		}
		else {
			c_local constant_`s' noconstant
		}
	}
end

exit
