*! version 1.0.0  19oct2002

// ---------------------------------------------------------------------------
//  Drawing program for the rconnected type of yxview.

program yxview_rconnected_draw


	if "`.bar_drop_to.stylename'" == "x" {
		.style.area.linestyle.setgdifull
		._draw_line
		._draw_points
		nobreak {
			local yhold `.yvar'
			.yvar = .y2var
			.style.area.linestyle.setgdifull
			._draw_line
			._draw_points
			.yvar = `yhold'
		}
	}
	else {
		nobreak {
			local holdx `.xvar'
			.xvar = .yvar
			.yvar = `holdx'
			.style.area.linestyle.setgdifull
			._draw_line
			._draw_points
			.yvar = .xvar
			.xvar = `holdx'
		}
		nobreak {
			local holdy `.yvar'
			.xvar = .y2var
			.yvar = `holdx'
			.style.area.linestyle.setgdifull
			._draw_line
			._draw_points
			.yvar = `holdy'
			.xvar = `holdx'
		}
	}
end
