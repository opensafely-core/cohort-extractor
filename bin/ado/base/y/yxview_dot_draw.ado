*! version 1.0.0  10oct2002

// ---------------------------------------------------------------------------
//  Drawing program for the bar type of yxview

program yxview_dot_draw
							// find our base point
	local dropx = "`.bar_drop_to.stylename'" == "x"

	if `dropx' {
		local min = `.`.plotregion'.yscale.curmin'
		local max = `.`.plotregion'.yscale.curmax'
	}
	else {
		local min = `.`.plotregion'.xscale.curmin'
		local max = `.`.plotregion'.xscale.curmax'
	}
	if `min' <= 0 & `max' >= 0 {  
		local base 0
	}
	else {
		local base = cond(`max' < 0 , `max' , `min')
	}

	local delta = (`max' - `min') / (`.num_dots'-1)

	.serset.set					// just in case

	.style.dots.setgdifull

	if 0`.dots_extend.istrue' {
		draw_full_dots `dropx' `base' `delta' `min' `max'
	}
	else {
		draw_value_dots `dropx' `base' `delta'
	}

	if `dropx' {
		._draw_points
	}
	else {
		nobreak {
			local holdx `.xvar'
			.xvar = .yvar
			.yvar = `holdx'
			._draw_points
			.yvar = .xvar
			.xvar = `holdx'
		}
	}
end


program draw_value_dots
	args dropx base delta

	if `dropx' {
		forvalues j = 1/`:serset N' {
			draw_dots `dropx' `delta' `=serset(`.xvar', `j')'  ///
				  `base' `=serset(`.yvar', `j')'
		}
	}
	else {
		forvalues j = 1/`:serset N' {
			draw_dots `dropx' `delta' `=serset(`.xvar', `j')'  ///
				  `base' `=serset(`.yvar', `j')'
		}
	}
end


program draw_full_dots
	args dropx base delta min max

	if `dropx' {
		forvalues j = 1/`:serset N' {
			draw_dots `dropx' `delta' `=serset(`.xvar', `j')'  ///
				  `base' `min'
			draw_dots `dropx' `delta' `=serset(`.xvar', `j')'  ///
				  `base' `max'
		}
	}
	else {
		forvalues j = 1/`:serset N' {
			draw_dots `dropx' `delta' `=serset(`.xvar', `j')'  ///
				  `base' `min'
			draw_dots `dropx' `delta' `=serset(`.xvar', `j')'  ///
				  `base' `max'
		}
	}
end


program draw_dots
	args dropx delta pos base end

	if abs(`end' - `base') / `delta' > 10000 {   // avoid endless
		exit
	}

	if `end' < `base' {
		local delta = -`delta'
	}

	if `dropx' {
		forvalues y = `base'(`delta')`end' {
			gdi point `pos' `y'
		}
	}
	else {
		forvalues x = `base'(`delta')`end' {
			gdi point `x' `pos'
		}
	}
end
