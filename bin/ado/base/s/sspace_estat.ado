*! version 1.0.0  20feb2009

program define sspace_estat
	version 11

	if "`e(cmd)'" != "sspace" {
		di as err "{help sspace##|_new:sspace} estimation results " ///
		 "not found"
		exit 301
	}
	_sspace_estat `0'
end

exit
