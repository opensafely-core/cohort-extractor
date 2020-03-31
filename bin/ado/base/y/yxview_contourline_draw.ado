*! version 1.0.4  25jun2011

// ---------------------------------------------------------------------------
//  Drawing program for the contourline type of yxview (zyxview2).

program yxview_contourline_draw

	.reset_dserset `.`.zaxis'.major.tick_values'
	.dserset.set

	draw_our_lines 
end

// ---------------------------------------------------------------------------
program draw_our_lines

	if 0`.style.colorlines.istrue' {
		forvalues i = 1/`=`.style.levels.val'-1' {
			.style.line.setgdifull
			gdi clinepenset = `i' `.style.cstyles[`i'].color.setting'
			if 0`.style.lwstyles[`i'].isofclass linewidth' {
				gdi clinepenwidth `i' = `.style.lwstyles[`i'].gmval'
			}
		}
		local color = 1
		draw_lines `color'
	}
	else {
		local color = 0
		draw_lines `color'
	}
end

// ---------------------------------------------------------------------------
program draw_lines
	args color

	local id : serset id	

	local n : serset N

        //In serset, 4 is level, 2 is yvar, and 3 is xvar
	//zvar is no longer needed for drawing.
        gdi linecontour `id' 4 2 3 `color'
end
