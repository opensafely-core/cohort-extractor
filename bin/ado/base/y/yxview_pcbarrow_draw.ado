*! version 1.1.0  27nov2006

// ---------------------------------------------------------------------------
//  Drawing program for the pcbarrow type of y2x2view.

program yxview_pcbarrow_draw

	yxview_pcarrow_draw

	.style.marker.setgdifull			// set the style
	local ang    `.style.marker.angle.radians'
	local msz `.style.marker.size.val'
	local barbsz `.style.marker.backsize.val'

	if "`.bar_drop_to.stylename'" == "x" {
	    forvalues j = 1/`:serset N' {
		if ("`.obs_styles[`j'].isa'" != "") {
			.obs_styles[`j'].area.linestyle.setgdifull
			.obs_styles[`j'].marker.setgdifull
			local ang    `.obs_styles[`j'].marker.angle.radians'
			local msz    `.obs_styles[`j'].marker.size.val'
			local barbsz `.obs_styles[`j'].marker.backsize.val'
		}
		_gr_arrowhead `ang' `msz' `barbsz'			   ///
			`=serset(`.x2var', `j')' `=serset(`.y2var', `j')'  ///
			`=serset(`.xvar', `j')'  `=serset(`.yvar',  `j')' 
		if ("`.obs_styles[`j'].isa'" != "") {
			.style.area.linestyle.setgdifull
			.style.marker.setgdifull
			local ang    `.style.marker.angle.radians'
			local msz    `.style.marker.size.val'
			local barbsz `.style.marker.backsize.val'
		}
	    }
	}
	else {
	    forvalues j = 1/`:serset N' {
		if ("`.obs_styles[`j'].isa'" != "") {
			.obs_styles[`j'].area.linestyle.setgdifull
			.obs_styles[`j'].marker.setgdifull
			local ang    `.obs_styles[`j'].marker.angle.radians'
			local msz    `.obs_styles[`j'].marker.size.val'
			local barbsz `.obs_styles[`j'].marker.backsize.val'
		}
		_gr_arrowhead `ang' `msz' `barbsz'			   ///
			`=serset(`.y2var', `j')' `=serset(`.x2var', `j')'  ///
			`=serset(`.yvar',  `j')' `=serset(`.xvar', `j')'
		if ("`.obs_styles[`j'].isa'" != "") {
			.style.area.linestyle.setgdifull
			.style.marker.setgdifull
			local ang    `.style.marker.angle.radians'
			local msz    `.style.marker.size.val'
			local barbsz `.style.marker.backsize.val'
		}
	    }
	}
end
