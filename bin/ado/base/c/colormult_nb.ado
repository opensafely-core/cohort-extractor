program colormult_nb, rclass
	version 8
	args r g b m

	local m = cond(`m'<0, 0, cond(`m'>255,255,`m'))

	if `r'==0 & `g'==0 & `b'==0 { 
		if `m'<=1 {
			ret local color 0 0 0
			exit
		}
		local r 1
		local g 1
		local b 1
	}

	local rp = round(`r'*`m')
	local gp = round(`g'*`m')
	local bp = round(`b'*`m') 

	if `rp'>255 | `gp'>255 | `bp'> 255 { 	/* return max color */
		local m  = 255/max(`r', `g', `b')
		local rp = min(255,round(`r'*`m'))
		local gp = min(255,round(`g'*`m'))
		local bp = min(255,round(`b'*`m'))
	}
	else if (`r' & `rp'==0) | (`g' & `gp'==0) | (`b' & `bp'==0) {
		local min = 255
		if `r' & `r'<`min' {
			local min `r'
		}
		if `g' & `g'<`min' {
			local min `g'
		}
		if `b' & `b'<`min' {
			local min `b'
		}
		local rp = round(`r'/`min')
		local gp = round(`g'/`min')
		local bp = round(`b'/`min')
	}
	ret local color `rp' `gp' `bp'
end
