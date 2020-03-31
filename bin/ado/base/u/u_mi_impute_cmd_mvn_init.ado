*! version 1.0.0  12jan2011
program u_mi_impute_cmd_mvn_init
	version 12
	args impobj mstart
	mata: `impobj'.da_burnin(`mstart', 1); `impobj'.post_misvals()
end
