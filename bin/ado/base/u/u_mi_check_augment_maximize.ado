*! version 1.0.0  18mar2014
program u_mi_check_augment_maximize
	version 13

	syntax [, DIFficult TECHnique(string) GRADient showstep HESSian ///
                  SHOWTOLerance from(string) * ]

	local notallowed "`difficult'`technique'`gradient'`showstep'`hessian'"
	local notallowed "`notallowed'`showtolerance'`from'"
	if ("`notallowed'"!="") {
		di as err "{p 0 0 2}{bf:difficult}, {bf:technique()},"
		di as err "{bf:gradient}, {bf:showstep}, {bf:hessian},"
		di as err "{bf:showtolerance}, and {bf:from()} are not allowed"
		di as err "in combination with {bf:augment}.{p_end}"
		exit 198	
	}
end
