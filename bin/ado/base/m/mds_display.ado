*! version 1.0.0  15mar2007
program mds_display
	version 10

	if "`e(method)'" == "classical" {
		mds_display_classical `0'
	}
	else {
		mds_display_modern `0'
	}	
end
