*! version 1.1.0  27nov2006

// ---------------------------------------------------------------------------
//  Drawing program for the rcap type of yxview.

program yxview_rcap_draw

	.style.area.setgdifull				// set the style

	local sz  = `.style.marker.size.gmval'
	local sz2 = `sz' / 2

	if "`.bar_drop_to.stylename'" == "x" {
		forvalues j = 1/`:serset N' {
			if ("`.obs_styles[`j'].isa'" != "")		///
				.obs_styles[`j'].area.setgdifull
			local x = serset(`.xvar', `j')
			if (`x'                       >= .) continue
			if (`=serset(`.yvar' ,  `j')' >= .) continue
			if (`=serset(`.y2var',  `j')' >= .) continue
			gdi line `x' `=serset(`.yvar',  `j')'		///
				 `x' `=serset(`.y2var', `j')'
			gdi gm_rmoveto  -`sz2' 0
			gdi gm_rlineto   `sz'  0
			gdi moveto       `x'   `=serset(`.yvar',  `j')'
			gdi gm_rmoveto  -`sz2' 0
			gdi gm_rlineto   `sz' 0
			if ("`.obs_styles[`j'].isa'" != "")		///
				.style.area.setgdifull	
		}
	}
	else {
		forvalues j = 1/`:serset N' {
			if ("`.obs_styles[`j'].isa'" != "")		///
				.obs_styles[`j'].area.setgdifull
			local y = serset(`.xvar', `j')
			if (`y'                       >= .) continue
			if (`=serset(`.yvar' ,  `j')' >= .) continue
			if (`=serset(`.y2var',  `j')' >= .) continue
			gdi line `=serset(`.yvar',  `j')' `y'		///
				 `=serset(`.y2var', `j')' `y'
			gdi gm_rmoveto  0 -`sz2'
			gdi gm_rlineto  0  `sz'
			gdi moveto      `=serset(`.yvar',  `j')'  `y'
			gdi gm_rmoveto  0 -`sz2'
			gdi gm_rlineto  0  `sz'
			if ("`.obs_styles[`j'].isa'" != "")		///
				.style.area.setgdifull	
		}
	}
end
