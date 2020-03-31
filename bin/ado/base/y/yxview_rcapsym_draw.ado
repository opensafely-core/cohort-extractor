*! version 1.0.0  18oct2002

// ---------------------------------------------------------------------------
//  Drawing program for the rcapsym type of yxview.

program yxview_rcapsym_draw

	yxview_rspike_draw

	if "`.bar_drop_to.stylename'" == "x" {
		._draw_points
		nobreak {
			local yhold `.yvar'
			.yvar = .y2var
			._draw_points
			.yvar = `yhold'
		}
	}
	else {
		nobreak {
			local holdx `.xvar'
			.xvar = .yvar
			.yvar = `holdx'
			._draw_points
			.yvar = .xvar
			.xvar = `holdx'
		}
		nobreak {
			local holdy `.yvar'
			.xvar = .y2var
			.yvar = `holdx'
			._draw_points
			.yvar = `holdy'
			.xvar = `holdx'
		}
	}
end
