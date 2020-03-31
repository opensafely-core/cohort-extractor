*! version 1.0.0  16aug2002
program _gr_drawrect
	args x0 y0 x1 y1

	gdi line `x0' `y0' `x1' `y0'
	gdi lineto `x1' `y1'
	gdi lineto `x0' `y1'
	gdi lineto `x0' `y0'
end
