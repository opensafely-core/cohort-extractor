*! version 3.0.1  09/14/92
program define _crcunit /* varname */
	version 3.0
	local p 1
	capture assert `1'==. 
	if _rc==0 { 
		mac def S_1 .
		mac def S_2 . 
		mac def S_3 .
		exit
	}
	capture assert `1'==. | `1'==0
	if _rc==0 { 
		mac def S_1 0
		mac def S_2 0
		mac def S_3 0
		exit
	}
	capture assert float(`1')==float(round(`1',1))
	if _rc == 0 { 
		while _rc==0 { 
			local p=`p'*10
			capture assert float(`1')==float(round(`1',`p'))
		}
		local p=`p'/10
	}
	else {
		while _rc { 
			local p=`p'/10
			capture assert float(`1')==float(round(`1',`p'))
		}
	}
	qui summ `1'
	mac def S_1 `p'
	mac def S_2 = round(_result(5),`p')
	mac def S_3 = round(_result(6),`p')
end
exit
/*
	_crcunits varname

	for numeric variable varname, returns
		S_1	units
		S_2	min
		S_3	max
*/
