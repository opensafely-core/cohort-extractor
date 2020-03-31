*! version 1.0.1  22jun2011

// ---------------------------------------------------------------------------
//  Drawing program for the contour type of yxview (zyxview2).

program yxview_patch_draw
	.style.area.setgdifull				// set the style
	.serset.set
	draw_our_areas2 
end


// ---------------------------------------------------------------------------
program draw_our_areas2

	forvalues i = 1/`.style.levels.val' {
		.style.line.setgdifull
		.style.cstyles[`i'].setgdifull
		draw_an_area `i'
	}
end


// ---------------------------------------------------------------------------

program draw_an_area
	args lev

	local n : serset N
	while `n' > 0 &							///
	     (`=serset(`.xvar', `n')' >= . | 				///
	      `=serset(`.yvar', `n')' >= . |				///
	      `=serset(4, `n')' >= .) {
		local --n
	}

	local beg 1
	while `beg' <= `n' &						///
	     (`=serset(`.xvar', `beg')' >= . |				///
	      `=serset(`.yvar', `beg')' >= . |				///
	      `=serset(4, `beg')' >= .) {
		local ++beg
	}

	if `beg' >= `n' {
		exit
	}

	local j `beg'
	local inpoly 0 

	local dropx = "`.bar_drop_to.stylename'" == "x"

	if `dropx' {
	    while `j' <= `n' {
		if `=serset(4, `j')' != `lev' {
			local ++j
			continue
		}
	    	local beg0 `j'

		gdi moveto `=serset(`.xvar', `beg0')' `=serset(`.yvar', `beg0')'
		gdi polybegin

		while `j' <= `n' {
		    if (`=serset(`.xvar', `j')' >= . |			///
		    	`=serset(`.yvar', `j')' >= . |			///
			`=serset(4, `j')' != `lev') {
			local ++j
			continue, break
		    }
		    gdi lineto `=serset(`.xvar', `j')' `=serset(`.yvar', `j')'
		    local inpoly 1
		    local j0 `j'
		    local ++j
		}

		if `inpoly' {
		    if `.drop_base.istrue' {
			local jdrop = cond(`j'==`n', `n', `j0')
			gdi lineto `=serset(`.xvar', `jdrop')' `base'
			gdi lineto `=serset(`.xvar',  `beg0')' `base'
		    }
		    gdi lineto  `=serset(`.xvar', `beg0')'		///
		    		`=serset(`.yvar', `beg0')'
		    local inpoly 0
		}

		gdi polyend
	    }

	}
	else {
	    while `j' <= `n' {
		if `=serset(4, `j')' != `lev' {
			local ++j
			continue
		}
	    	local beg0 `j'

		gdi moveto `=serset(`.yvar', `beg0')' `=serset(`.xvar', `beg0')'
		gdi polybegin

		while `j' <= `n' {
		    if (`=serset(`.xvar', `j')' >= . |		///
		    	`=serset(`.yvar', `j')' >= . |		///
			`=serset(4, `j')' != `lev') {
			local ++j
			continue, break
		    }
		    gdi lineto `=serset(`.yvar', `j')' `=serset(`.xvar', `j')'
		    local inpoly 1
		    local j0 `j'
		    local ++j
		}

		if `inpoly' {
		    if `.drop_base.istrue' {
			local jdrop = cond(`j'==`n', `n', `j0')
			gdi lineto `base' `=serset(`.xvar', `jdrop')'
			gdi lineto `base' `=serset(`.xvar',  `beg0')'
		    }
		    gdi lineto  `=serset(`.yvar', `beg0')'		///
		    		`=serset(`.xvar', `beg0')'
		    local inpoly 0
		}

		gdi polyend
	    }
	}
end
