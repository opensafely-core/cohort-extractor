*! version 1.0.1  05jun2003
program gdi_spokes
	version 8.0
	args x y r h n
	forval i = 1/`n' {
		gdi moveto `x' `y'
		local angle = c(pi)/2 + 2*c(pi)*(`i'-1)/(`n')
		gdi rlineto `=`r'*cos(`angle')' `=`h'*sin(`angle')'
	}
end
exit
