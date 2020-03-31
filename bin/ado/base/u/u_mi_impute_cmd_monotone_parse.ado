*! version 1.0.0  04jul2011
program u_mi_impute_cmd_monotone_parse, sclass
	local version : di "version " string(_caller()) ":"
	version 12
	_parse comma lhs rhs : 0
	local 0 `rhs'
	syntax,		impobj(string)		/// //internal
		[	Custom			///
			FORCE			///
			*			///
		]
	if ("`custom'"!="") {
		local mustbeordered mustbeordered
	}
	sret clear
	`version' u_mi_impute_sequential_parse `lhs', impobj(`impobj') 	///
				`custom' `options' 			///
				methodname(monotone) errmonotone `mustbeordered'
	sret local xeqmethod	"monotone"
	local k_eq : word count `s(ivarsincord)'

	// file is created in u_mi_impute_cmd_monotone_init.ado
	u_mi_get_sterfilename estfile : "__mi_impute_estimates"

	mata: `impobj'.setup("`estfile'", "`s(incordid)'")

	if ("`s(nomiss)'"!="") exit

	sret local cmdlineinit `""`k_eq'" "`estfile'""'
	sret local cmdlineimpute `""`impobj'" "`k_eq'" "`estfile'" "`s(ivarsincord)'" "`force'""'
end

program u_mi_get_sterfilename
	args macname colon basename

	local i 1
	while (1) {
		cap confirm new file `basename'`i'.ster
		if _rc==0 {
			c_local `macname' `basename'`i'.ster
			exit
		}
		local ++i
		if (`i'>200) {
			di as err "{p 0 0 2}"
			di as err ///
		"could not find a filename for temporary estimation file"
			di as err "{p_end}"
			di as err "{p 4 4 2}"
			di as err ///
			"I tried `basename'1.ster through `basename'200.ster."
			di as err "Perhaps you do not have write permission"
			di as err "in the current directory.  This may occur,"
			di as err "for example, if you started Stata by"
			di as err "clicking directly on the Stata executable"
			di as err "on a network drive.  You should make sure"
			di as err "you have write permission for the"
			di as err "current directory or use {helpb cd} to"
			di as err "change to a directory that has write"
			di as err "permission.  Use {helpb pwd}"
			di as err "to determine your current directory."
			di as err "{p_end}"
			exit 603
		}
	}
	/*NOTREACHED*/
end

