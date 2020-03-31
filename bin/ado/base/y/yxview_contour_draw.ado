*! version 1.0.3  25jun2011

// ---------------------------------------------------------------------------
//  Drawing program for the contour type of yxview (zyxview2).

program yxview_contour_draw

	.reset_dserset `.`.zaxis'.major.tick_values'
	.dserset.set

	.style.area.setgdifull
	draw_our_areas 
end


// ---------------------------------------------------------------------------
// Placeholder 

program draw_our_areas

	forvalues i = 1/`.style.levels.val' {
		gdi gm_linewidth = .001
		gdi cshadeset = `i' `.style.cstyles[`i'].color.setting'
	}
	draw_areas

end


program draw_areas
	local id : serset id	

	local n : serset N
	//In serset, 4 is level, 2 is yvar, and 3 is xvar
	//zvar is no longer needed for drawing.
	gdi filledcontour `id' 4 2 3

end
