*! version 1.1.0  31aug2002
program stcox_fr_ll
	version 8.0
	args todo b lnf

	tempname lntheta
	mleval `lntheta' = `b', scalar

	quietly {
		local theta = exp(`lntheta')
		capture mat list $COXFfrom
		if !_rc {
			local matop matfrom($COXFfrom)
		}
		if `theta' < 1e-12 | `theta' >= . {
			$COXFcmd, `matop'
			scalar `lnf' = e(ll)
			exit
		}
		$COXFcmd, gampen($COXFshared) theta(`theta') `matop' norefine
		matrix $COXFfrom = e(b) 
		scalar `lnf' = e(ll) 
	}
end
exit

