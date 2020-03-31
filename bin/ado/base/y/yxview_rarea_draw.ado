*! version 1.1.0  21mar2007

// ---------------------------------------------------------------------------
//  Drawing program for the rarea type of yxview.

program yxview_rarea_draw

	.style.area.setgdifull				// set the style


	local n : serset N
	while `n' > 0 &							///
	     (`=serset(`.xvar', `n')' >= . | `=serset(`.yvar', `n')' >= .) {
		local --n
	}

	local beg 1
	while `beg' <= `n' &						///
	     (`=serset(`.xvar', `beg')' >= . | `=serset(`.yvar', `beg')' >= .) {
		local ++beg
	}

	if 0`.style.connect_missings.istrue' {
		DrawRpoly `beg' `n'
		exit							// Exit
	}

	local j0 `beg'
	local j  `beg'
	while `j' < `n' {
		local ++j

		if `=serset(`.xvar',  `j')' >= . | 			///
		   `=serset(`.yvar',  `j')' >= . | 			///
		   `=serset(`.y2var', `j')' >= . {

			DrawRpoly `j0' `=`j'-1'

			local j0 `n'
			while `++j' < `n' {
				if `=serset(`.xvar', `j')'  < . & 	///
				   `=serset(`.yvar', `j')'  < . & 	///
				   `=serset(`.y2var', `j')' < . {
					local j0 `j'
					continue, break
				}

			}
		}
	}

	DrawRpoly `j0' `n'
end

program DrawRpoly
	args beg n


	if `beg' >= `n' {
		exit
	}

	if 0`.style.area.linestyle.patterned_line' {		// pattern line
		tempname linesty
		.`linesty' = .linestyle.new, style(background)
		.`linesty'.setgdifull
	}

	local cstyle "`.style.connect.stylename'"

	local xofj   \`=serset(`.xvar',  \`j')'		// observation macros
	local yofj   \`=serset(`.yvar',  \`j')'
	local y2ofj  \`=serset(`.y2var', \`j')'
	local xofj1  \`=serset(`.xvar',  \`j'-1)'		// prior
	local yofj1  \`=serset(`.yvar',  \`j'-1)'
	local xofjn  \`=serset(`.xvar',  \`j'+1)'		// next
	local yofjn  \`=serset(`.yvar',  \`j'+1)'
	local y2ofjn \`=serset(`.y2var', \`j'+1)'

	if "`.bar_drop_to.stylename'" == "x" {

		gdi moveto `=serset(`.xvar', `beg')' `=serset(`.yvar', `beg')'
		gdi polybegin

		forvalues j = `beg'/`n' {
			if "`cstyle'" == "stairstep" {
				Stair   `yofj1' `xofj' `yofj'
			}
			else if "`cstyle'" == "stairstep_up" {
				StairUp `xofj1' `xofj' `yofj'
			}
			else {
				gdi lineto `xofj' `yofj'
			}
		}

		gdi lineto `=serset(`.xvar', `n')' `=serset(`.y2var', `n')'

		forvalues j = `=`n'-1'(-1)`beg' {
			if "`cstyle'" == "stairstep" {
				StairUp `xofjn' `xofj' `y2ofj'
			}
			else if "`cstyle'" == "stairstep_up" {
				Stair   `y2ofjn' `xofj' `y2ofj'
			}
			else {
				gdi lineto `xofj' `y2ofj'
			}
		}

		gdi lineto `=serset(`.xvar', `beg')' `=serset(`.yvar', `beg')'
		gdi polyend

		if 0`.style.area.linestyle.patterned_line' {	// pattern line
		   .style.area.linestyle.setgdifull
		   gdi moveto `=serset(`.xvar',`beg')' `=serset(`.yvar',`beg')'
		   forvalues j = `beg'/`n' {
			if "`cstyle'" == "stairstep" {
				Stair   `yofj1' `xofj' `yofj'
			}
			else if "`cstyle'" == "stairstep_up" {
				StairUp `xofj1' `xofj' `yofj'
			}
			else {
				gdi lineto `xofj' `yofj'
			}
		   }
		   gdi lineto `=serset(`.xvar', `n')' `=serset(`.y2var', `n')'
		   forvalues j = `=`n'-1'(-1)`beg' {
			if "`cstyle'" == "stairstep" {
				StairUp `xofjn' `xofj' `y2ofj'
			}
			else if "`cstyle'" == "stairstep_up" {
				Stair   `y2ofjn' `xofj' `y2ofj'
			}
			else {
				gdi lineto `xofj' `y2ofj'
			}
		   }
		   gdi lineto `=serset(`.xvar',`beg')' `=serset(`.yvar',`beg')'
		}

	}
	else {

		gdi moveto `=serset(`.yvar', `beg')' `=serset(`.xvar', `beg')'
		gdi polybegin

		forvalues j = `beg'/`n' {
			if "`cstyle'" == "stairstep" {
				Stair   `xofj1' `yofj' `xofj'
			}
			else if "`cstyle'" == "stairstep_up" {
				StairUp `yofj1' `yofj' `xofj'
			}
			else {
				gdi lineto `yofj' `xofj'
			}
		}

		gdi lineto `=serset(`.y2var', `n')' `=serset(`.xvar', `n')'

		forvalues j = `=`n'-1'(-1)`beg' {
			if "`cstyle'" == "stairstep" {
				StairUp `y2ofjn' `y2ofj' `xofj'
			}
			else if "`cstyle'" == "stairstep_up" {
				Stair   `xofjn' `y2ofj' `xofj'
			}
			else {
				gdi lineto `y2ofj' `xofj'
			}
		}

		gdi lineto `=serset(`.yvar', `beg')' `=serset(`.xvar', `beg')'
		gdi polyend

		if 0`.style.area.linestyle.patterned_line' {	// pattern line
		   .style.area.linestyle.setgdifull
		   gdi moveto `=serset(`.yvar',`beg')' `=serset(`.xvar',`beg')'
		   forvalues j = `beg'/`n' {
			if "`cstyle'" == "stairstep" {
				Stair   `xofj1' `yofj' `xofj'
			}
			else if "`cstyle'" == "stairstep_up" {
				StairUp `yofj1' `yofj' `xofj'
			}
			else {
				gdi lineto `yofj' `xofj'
			}
		   }
		   gdi lineto `=serset(`.y2var', `n')' `=serset(`.xvar', `n')'
		   forvalues j = `=`n'-1'(-1)`beg' {
			if "`cstyle'" == "stairstep" {
				StairUp `y2ofjn' `y2ofj' `xofj'
			}
			else if "`cstyle'" == "stairstep_up" {
				Stair   `xofjn' `y2ofj' `xofj'
			}
			else {
				gdi lineto `y2ofj' `xofj'
			}
		   }
		   gdi lineto `=serset(`.yvar',`beg')' `=serset(`.xvar',`beg')'
		}
	}
end

program Stair
	args y0 x y

	gdi lineto `x' `y0'
	gdi lineto `x' `y'
end

program StairUp
	args x0 x y

	gdi lineto `x0' `y'
	gdi lineto `x'  `y'
end

program Connect
	args cstyle dir x y

	if "`cstyle'" == "none" | "`cstyle'" == "direct" {
		gdi lineto `x' `y'
		exit
	}

	if "`dir'" == "back" {
		if       ("`cstyle'" == "stairstep")   local cstyle stairstep_up
		else if ("`cstyle'" == "stairstep_up") local cstyle stairstep
	}

	if "`cstyle'" == "stairstep" {
		Stair   `x' `y'
	}
	else if "`cstyle'" == "stairstep_up" {
		StairUp `x' `y'
	}
end

