*! version 1.1.0  27nov2006

// ---------------------------------------------------------------------------
//  Drawing program for the rbar type of yxview.

program yxview_rbar_draw

	.style.area.setgdifull				// set the style

	local sz2  = `.bar_size' / 2

	if "`.bar_drop_to.stylename'" == "x" {

		forvalues j = 1/`:serset N' {
			if ("`.obs_styles[`j'].isa'" != "")		///
				.obs_styles[`j'].area.setgdifull
			local x = serset(`.xvar', `j')
			_fr_draw_rect style.area			    ///
				      `=`x'-`sz2'' `=serset(`.yvar',  `j')' ///
				      `=`x'+`sz2'' `=serset(`.y2var', `j')' ///
				      preset
			if ("`.obs_styles[`j'].isa'" != "")		///
				.style.area.setgdifull	
		}
	}
	else {
		forvalues j = 1/`:serset N' {
			if ("`.obs_styles[`j'].isa'" != "")		///
				.obs_styles[`j'].area.setgdifull
			local y = serset(`.xvar', `j')
			_fr_draw_rect style.area			    ///
				      `=serset(`.yvar',  `j')' `=`y'-`sz2'' ///
				      `=serset(`.y2var', `j')' `=`y'+`sz2'' ///
				      preset
			if ("`.obs_styles[`j'].isa'" != "")		///
				.style.area.setgdifull	
		}
	}
end
