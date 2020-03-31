*! version 1.0.0  27nov2006

// ---------------------------------------------------------------------------
//  Drawing program for the rbarm (marker sized bars) type of yxview.

program yxview_rbarm_draw

	.style.area.setgdifull				// set the style

	local sz2  = `.style.marker.size.gmval' / 2

	if "`.bar_drop_to.stylename'" == "x" {
		local xtrans = `gdi(gbeta)' / `gdi(xbeta)'
		local sz2 = `sz2' * `xtrans'

		forvalues j = 1/`:serset N' {
			if ("`.obs_styles[`j'].isa'" != "")		///
				.obs_styles[`j'].area.setgdifull
			local x = serset(`.xvar', `j')
			gdi rectangle `=`x'-`sz2'' `=serset(`.yvar',  `j')' ///
				      `=`x'+`sz2''  `=serset(`.y2var', `j')'
			if ("`.obs_styles[`j'].isa'" != "")		///
				.style.area.setgdifull	
		}
	}
	else {
		local ytrans = `gdi(gbeta)' / `gdi(ybeta)'
		local sz2 = `sz2' * `ytrans'

		forvalues j = 1/`:serset N' {
			if ("`.obs_styles[`j'].isa'" != "")		///
				.obs_styles[`j'].area.setgdifull
			local y = serset(`.xvar', `j')
			gdi rectangle `=serset(`.yvar',  `j')' `=`y'-`sz2'' ///
				      `=serset(`.y2var', `j')' `=`y'+`sz2''  
			if ("`.obs_styles[`j'].isa'" != "")		///
				.style.area.setgdifull	
		}
	}
end
