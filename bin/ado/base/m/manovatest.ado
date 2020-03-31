*! version 2.0.0  03apr2009
program manovatest /* -rclass-, happens automatically in drop through call */
	version 11

	if "`e(cmd)'" != "manova" {
		error 301
	}

	if "`e(version)'" == "" {
		_manovatest10 `0'	// for old manova
	}
	else {
		_manovatest `0'		// for e(version)==2 manova
	}
end
exit
