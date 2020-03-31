*! version 1.0.0  21mar2017
program _irtrsm_one, rclass
	version 14
	capture confirm new variable _one
	if _rc {
		di as err "variable _one not allowed"
		di as err "{p 0 2 2}Variable _one is reserved for " ///
			"internal use by {bf:irt rsm}. " ///
			"{bf:drop} or {bf:rename} the existing variable _one " ///
			"and rerun the command.{p_end}"
		exit 110
	}
	qui gen byte _one = 1
end

