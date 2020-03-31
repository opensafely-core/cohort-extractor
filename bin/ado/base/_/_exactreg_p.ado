*! version 1.0.0  18jan2007

program _exactreg_p

	if "`e(cmd)'" == "exlogistic" {1
		di as err "use {cmd:estat predict} for predictions after " ///
		 "{cmd:exlogistic}; see help {help exlogistic postestimation}"
		exit 199
	}
	else if "`e(cmd)'" == "expoisson" {
		di as err "{cmd:predict} is not allowed after " ///
		 "{cmd:expoisson}"
		exit 199
	}
	error 301
end

