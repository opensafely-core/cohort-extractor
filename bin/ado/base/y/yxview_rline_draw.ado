*! version 1.0.0  19oct2002

// ---------------------------------------------------------------------------
//  Drawing program for the rlines type of yxview.

program yxview_rline_draw


	.style.area.linestyle.setgdifull
	if "`.bar_drop_to.stylename'" == "x" {
		._draw_line
		nobreak {
			local yhold `.yvar'
			.yvar = .y2var
			._draw_line
			.yvar = `yhold'
		}
	}
	else {
		nobreak {
			local holdx `.xvar'
			.xvar = .yvar
			.yvar = `holdx'
			._draw_line
			.yvar = .xvar
			.xvar = `holdx'
		}
		nobreak {
			local holdy `.yvar'
			.xvar = .y2var
			.yvar = `holdx'
			._draw_line
			.yvar = `holdy'
			.xvar = `holdx'
		}
	}
end
