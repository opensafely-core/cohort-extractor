*! version 1.0.0  29jan2007
program expoisson_estat, rclass
	version 10

	if "`e(cmd)'" != "expoisson" {
		di as err "{help expoisson##|_new:expoisson} estimation " ///
		 "results not found"
		exit 301
	}

	gettoken sub rest: 0, parse(" ,")

	local lsub = length("`sub'")
	if "`sub'" == "ic" | "`sub'" == "vce" {
		di as error "{p}options ic, information criterion, or vce, " ///
		 "variance-covariance estimate, are not valid estat "	     ///
		 "options after {cmd:expoisson}{p_end}"
		exit 198
	}
	if "`sub'" == "se" {
		_exactreg_replayse `rest'
		return add
	}
	else estat_default `0'
end

exit
