*! version 1.0.1  30apr2019

program _mcmc_getfilename
	version 16
	args fname colon stub
	local i 1
	while `i'<=1000 {
		capture confirm new file `"`stub'`i'.dta"'
		if (_rc==0) {
			c_local `fname' `"`stub'`i'.dta"'
			exit
		}
		local ++i
	}
	di as err "{p 0 0 2}"
	di as err ///
  "could not find a filename for temporary {bf:bayesmh} file"
	di as err "{p_end}"
	di as err "{p 4 4 2}"
	di as err ///
  `"I tried {bf:`stub'1.dta} through {bf:stub`i'.dta}."'
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
end
