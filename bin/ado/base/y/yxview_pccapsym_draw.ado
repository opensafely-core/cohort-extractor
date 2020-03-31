*! version 1.1.0  27nov2006

// ---------------------------------------------------------------------------
//  Drawing program for the pccapsym type of y2x2view.

program yxview_pccapsym_draw

	.style.area.setgdifull				// set the style

	if "`.bar_drop_to.stylename'" == "x" {
	    forvalues j = 1/`:serset N' {
		if ("`.obs_styles[`j'].isa'" != "")			///
				.obs_styles[`j'].area.setgdifull
		gdi line `=serset(`.xvar', `j')'  `=serset(`.yvar',  `j')'  ///
			 `=serset(`.x2var', `j')' `=serset(`.y2var', `j')'
		if ("`.obs_styles[`j'].isa'" != "") .style.area.setgdifull	
	    }
	}
	else {
	    forvalues j = 1/`:serset N' {
		if ("`.obs_styles[`j'].isa'" != "")			///
				.obs_styles[`j'].area.setgdifull
		gdi line `=serset(`.yvar',  `j')' `=serset(`.xvar', `j')'  ///
			 `=serset(`.y2var', `j')' `=serset(`.x2var', `j')'
		if ("`.obs_styles[`j'].isa'" != "") .style.area.setgdifull	
	    }
	}

	yxview_pcscatter_draw
end
