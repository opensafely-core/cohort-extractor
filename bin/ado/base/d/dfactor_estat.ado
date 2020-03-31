*! version 1.0.0  20feb2009

program define dfactor_estat
	version 11

	if "`e(cmd)'" != "dfactor" {
		di as err "{help dfactor##|_new:sspace} estimation results " ///
		 "not found"
		exit 301
	}
	_sspace_estat `0'
end

exit
