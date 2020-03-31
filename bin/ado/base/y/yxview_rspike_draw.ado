*! version 1.0.0  27nov2006

// ---------------------------------------------------------------------------
//  Drawing program for the rspike type of yxview.

program yxview_rspike_draw

	.style.area.setgdifull				// set the style

	if "`.bar_drop_to.stylename'" == "x" {
		forvalues j = 1/`:serset N' {
			if ("`.obs_styles[`j'].isa'" != "")		///
				.obs_styles[`j'].area.setgdifull
			local x = serset(`.xvar', `j')
			gdi line `x' `=serset(`.yvar',  `j')'		///
				 `x' `=serset(`.y2var', `j')'
			if ("`.obs_styles[`j'].isa'" != "")		///
				.style.area.setgdifull	
		}
	}
	else {
		forvalues j = 1/`:serset N' {
			if ("`.obs_styles[`j'].isa'" != "")		///
				.obs_styles[`j'].area.setgdifull
			local y = serset(`.xvar', `j')
			gdi line `=serset(`.yvar',  `j')' `y'		///
				 `=serset(`.y2var', `j')' `y'
			if ("`.obs_styles[`j'].isa'" != "")		///
				.style.area.setgdifull	
		}
	}
end
