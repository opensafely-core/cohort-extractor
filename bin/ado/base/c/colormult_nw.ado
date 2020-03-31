program colormult_nw, rclass
	version 8
	args r g b m

	local m = cond(`m'<0, 0, cond(`m'>255,255,`m'))

	if `m'>1 {
		colormult_nb `r' `g' `b' `=1/`m''
		ret local color `r(color)'
		exit
	}

	local rp = round(`r'*`m' + 255*(1-`m'))
	local gp = round(`g'*`m' + 255*(1-`m'))
	local bp = round(`b'*`m' + 255*(1-`m')) 

	if `rp'>255 | `gp'>255 | `bp'> 255 { 	/* return max color */
		local max = max(`rp',`gp',`bp')/255
		local rp = round((`r'*`m' + 255*(1-`m'))/`max')
		local gp = round((`g'*`m' + 255*(1-`m'))/`max')
		local bp = round((`b'*`m' + 255*(1-`m'))/`max')
	}
	ret local color `rp' `gp' `bp'
end
