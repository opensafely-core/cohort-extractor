*! version 1.0.0  05jul2006

// Returns a transformed value given the current gdi transform setting.
// dim is "x" or "y"

program _gr_applytrans
	args target colon dim val

	if "`gdi(`dim'transform)'" == "ln" {
		c_local `target' `=ln(`val')'
	}
	else	c_local `target' `val'
end
