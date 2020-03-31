*! version 1.1.1  03jun2011

// ---------------------------------------------------------------------------
//  Drawing program for the pcarrow type of y2x2view.

program yxview_pcarrow_draw

	.style.area.linestyle.setgdifull			// set the style
	local ang    `.style.marker.angle.radians'
	local msz    `.style.marker.size.val'
	local barbsz `.style.marker.backsize.val'

	if "`.bar_drop_to.stylename'" == "x" {
	    forvalues j = 1/`:serset N' {
		if ("`.obs_styles[`j'].isa'" != "")			    ///
			.obs_styles[`j'].area.linestyle.setgdifull
		gdi line `=serset(`.xvar', `j')'  `=serset(`.yvar',  `j')'  ///
			 `=serset(`.x2var', `j')' `=serset(`.y2var', `j')'
		if ("`.obs_styles[`j'].isa'" != "")			    ///
			.style.area.linestyle.setgdifull
	    }

	    .style.marker.setgdifull
	    forvalues j = 1/`:serset N' {
		if ("`.obs_styles[`j'].isa'" != "") {
			.obs_styles[`j'].area.linestyle.setgdifull
			.obs_styles[`j'].marker.setgdifull
			local ang    `.obs_styles[`j'].marker.angle.radians'
			local msz    `.obs_styles[`j'].marker.size.val'
			local barbsz `.obs_styles[`j'].marker.backsize.val'
		}
		_gr_arrowhead `ang' `msz' `barbsz' 			   ///
			`=serset(`.xvar', `j')'  `=serset(`.yvar',  `j')'  ///
			`=serset(`.x2var', `j')' `=serset(`.y2var', `j')'
		if ("`.obs_styles[`j'].isa'" != "") {
			.style.area.linestyle.setgdifull
			.style.marker.setgdifull
			local ang    `.style.marker.angle.radians'
			local msz    `.style.marker.size.val'
			local barbsz `.style.marker.backsize.val'
		}
	    }
	    if 0`.lvar' {					// labeled
	    	if 0`.headlbl.istrue' {
			local y_hold `.yvar'
			local x_hold `.xvar'
			.yvar = .y2var
			.xvar = .x2var
		}
	    	capture noisily ._draw_labeled_points labonly
	    	if 0`.headlbl.istrue' {
			.yvar = `y_hold' 
			.xvar = `x_hold' 
		}
	    }
	}
	else {
	    forvalues j = 1/`:serset N' {
		if ("`.obs_styles[`j'].isa'" != "")			    ///
			.obs_styles[`j'].area.linestyle.setgdifull
		gdi line `=serset(`.yvar',  `j')' `=serset(`.xvar', `j')'   ///
			 `=serset(`.y2var', `j')' `=serset(`.x2var', `j')'
		if ("`.obs_styles[`j'].isa'" != "")			    ///
			.style.area.linestyle.setgdifull
	    }

	    .style.marker.setgdifull
	    forvalues j = 1/`:serset N' {
		if ("`.obs_styles[`j'].isa'" != "") {
			.obs_styles[`j'].area.linestyle.setgdifull
			.obs_styles[`j'].marker.setgdifull
			local ang    `.obs_styles[`j'].marker.angle.radians'
			local msz    `.obs_styles[`j'].marker.size.val'
			local barbsz `.obs_styles[`j'].marker.backsize.val'
		}
		_gr_arrowhead `ang' `msz' `barbsz' 			  ///
			`=serset(`.yvar',  `j')' `=serset(`.xvar', `j')'  ///
			`=serset(`.y2var', `j')' `=serset(`.x2var', `j')'
		if ("`.obs_styles[`j'].isa'" != "") {
			.style.area.linestyle.setgdifull
			.style.marker.setgdifull
			local ang    `.style.marker.angle.radians'
			local msz    `.style.marker.size.val'
			local barbsz `.style.marker.backsize.val'
		}
	    }

	    if 0`.lvar' {					// labeled
	    	if (0`.headlbl.istrue') local two 2
		local y_use `.y`two'var'
		local y_hold `.yvar'
		local x_hold `.xvar'
		.yvar = .x`two'var
		.xvar = `y_use'
		capture noisily ._draw_labeled_points labonly
		.xvar = `x_hold'
		.yvar = `y_hold'
	    }
	}
end

