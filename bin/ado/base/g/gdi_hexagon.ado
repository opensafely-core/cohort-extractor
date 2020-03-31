*! version 1.0.2  12jan2007
program gdi_hexagon
	version 8.0
	args x y w h angle
	if (`"`angle'"' == "") local angle 0
	local px = `x' + `w'*cos(`angle')
	local py = `y' + `h'*sin(`angle')
	// move counter clockwise from 3 o'clock (if angle==0)
	gdi moveto `px' `py'
	gdi polybegin
	forval i = 1/5 {
		local rx = `x' + `w'*cos(`angle'+`i'*c(pi)/3)
		local ry = `y' + `h'*sin(`angle'+`i'*c(pi)/3)
		gdi lineto `rx' `ry'
	}
	gdi lineto `px' `py'
	gdi polyend
end
exit
