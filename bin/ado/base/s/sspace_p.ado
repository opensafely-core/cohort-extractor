*! version 1.0.0  05may2009

program sspace_p, properties(notxb)
	version 11

	if "`e(cmd)'" != "sspace" {
		di as err "{help sspace##|_new:sspace} estimation results " ///
		 "not found"
		exit 301
	}
	_sspace_p `0'
end

exit
