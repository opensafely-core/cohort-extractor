*! version 1.0.0  02jul2011
program u_mi_impute_cmd_chained_init
	version 12
	args impobj noisily dots chaindots notitle
	if ("`chaindots'`dots'"=="") {
		local ending " ..."
	}
	else {
		local ending ":"
	}
	if ("`noisily'`notitle'"=="") {
		di as txt "Performing chained iterations`ending'"
	}
end
