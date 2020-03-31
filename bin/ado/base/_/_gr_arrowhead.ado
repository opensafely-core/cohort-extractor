*! version 1.1.0  24may2007
program _gr_arrowhead

	args ang msz bsz x0 y0 x1 y1

	if (`x0'>=. | `x1'>=. | `y1'>=. | `y0'>=.)  exit		// Exit

	_gr_applytrans xt0 : x `x0'			// linear, log, etc
	_gr_applytrans xt1 : x `x1'			// transform
	_gr_applytrans yt0 : y `y0'
	_gr_applytrans yt1 : y `y1'

	if (`xt0'>=. | `xt1'>=. | `yt1'>=. | `yt0'>=.)  exit		// Exit

	local xtrans = `gdi(gbeta)' / `gdi(xbeta)'	// gmetric
	local ytrans = `gdi(gbeta)' / `gdi(ybeta)'	// transform

	local phi = atan(((`yt1'-`yt0') / (`xt1' - `xt0'))*(`xtrans'/`ytrans'))
	if `phi' >= . {
		local phi = cond(`yt1'-`yt0' > 0, -c(pi)/2, c(pi)/2)
		if (0`gdi(yreverse)')  local phi = `phi' - c(pi)
	}
	else if (0`gdi(xreverse)')  local phi = `phi' - c(pi)

	local sgn = cond(`x1'-`x0'>0, "+" , "-")

	if (`bsz' == 0)  arrowhead_simple `phi' `sgn' `xtrans' `ytrans' `0'
	else		 arrowhead_barb   `phi' `sgn' `xtrans' `ytrans' `0'

end

program arrowhead_simple
	args phi sgn xtrans ytrans ang msz bsz x0 y0 x1 y1

	local ya = `sgn' `msz' * sin(c(pi) + `phi' + `ang')
	local xa = `sgn' `msz' * cos(c(pi) + `phi' + `ang')

	gdi moveto     `x1' `y1'
	gdi gm_rlineto `xa' `ya'

	local ya = `sgn' `msz' * sin(c(pi) + `phi' - `ang')
	local xa = `sgn' `msz' * cos(c(pi) + `phi' - `ang')
	gdi moveto     `x1' `y1'
	gdi gm_rlineto `xa' `ya'
end


program arrowhead_barb
	args phi sgn xtrans ytrans ang msz bsz x0 y0 x1 y1

	local bsz = `bsz' * cos(`ang')
	local osgn = cond("`sgn'"=="-", "+" , "-")

	local ya = `sgn' `msz' * sin(c(pi) + `phi' + `ang')
	local xa = `sgn' `msz' * cos(c(pi) + `phi' + `ang')

	if ("`sgn'" == "+")  local sgn ""
	local yb = `sgn' `bsz' * sin(c(pi) + `phi') - `ya'
	local xb = `sgn' `bsz' * cos(c(pi) + `phi') - `xa'

	gdi moveto `x1' `y1'
	gdi polybegin
	gdi gm_rlineto `xa' `ya'
	gdi gm_rlineto `xb' `yb'

	local ya = `sgn' `msz' * sin(c(pi) + `phi' - `ang') - (`ya'+`yb')
	local xa = `sgn' `msz' * cos(c(pi) + `phi' - `ang') - (`xa'+`xb')
	gdi gm_rlineto `xa' `ya'
	gdi lineto `x1' `y1'

	gdi polyend

end

