*! version 1.0.1  18dec2004

// ---------------------------------------------------------------------------
//  Drawing program for the rlines type of yxview.

program yxview_pcscatter_draw

	if (0`.headlbl.istrue')	local labels1 nolabels
	else			local labels2 nolabels

	.style.area.linestyle.setgdifull
	if "`.bar_drop_to.stylename'" == "x" {
		._draw_points `labels1'
		nobreak {
			local yhold `.yvar'
			local xhold `.xvar'
			.yvar = .y2var
			.xvar = .x2var
			._draw_points `labels2'
			.yvar = `yhold'
			.xvar = `xhold'
		}
	}
	else {
		nobreak {
			local holdx `.xvar'
			.xvar = .yvar
			.yvar = `holdx'
			._draw_points `labels1'
			.yvar = .xvar
			.xvar = `holdx'
		}
		nobreak {
			local holdy `.yvar'
			local holdx `.xvar'
			.xvar = .y2var
			.yvar = .x2var
			._draw_points `labels2'
			.yvar = `holdy'
			.xvar = `holdx'
		}
	}
end
