*! version 1.0.1  09oct2003
program _fr_draw_rect
	args style x0 y0 x1 y1 preset

	if 0`.`style'.linestyle.patterned_line' {
		.`style'.setgdifull
		tempname linesty
		.`linesty' = .linestyle.new, style(background)
		.`linesty'.setgdifull
		gdi rectangle `x0' `y0' `x1' `y1'
		.`style'.linestyle.setgdifull
		_draw_rect `x0' `y0' `x1' `y1'
	}
	else {
		if "`preset'" == "" {
			.`style'.setgdifull
		}
		gdi rectangle `x0' `y0' `x1' `y1'
	}
end


program _draw_rect
	args x0 y0 x1 y1

	gdi moveto  `x0'  `y0'
	gdi lineto  `x1'  `y0' 
	gdi lineto  `x1'  `y1'
	gdi lineto  `x0'  `y1'
	gdi lineto  `x0'  `y0'

				// pattern does not wrap around corners,
				// gdi rectangle could honor pattern.
end
