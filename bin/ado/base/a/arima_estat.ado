*! version 1.1.2  20jan2015
program arima_estat, rclass
	version 9

	// If conditional ARIMA, then -arch- used for estimation.  Need to
	// doctor up e(cmd) so that -estat- subcommands show "arima" in
	// output.

	local fixcmd ""
	if "`e(cmd)'" == "arch" & "`e(cond)'" == "condition" {
		mata: st_global("e(cmd)", "arima")
		local fixcmd "yes"
	}
	else if "`e(cmd)'" != "arima" {
		exit 301
	}
	
	capture noisily {
		gettoken key rest : 0, parse(", ")
		local lkey = length(`"`key'"')
		if `"`key'"' == "aroots" {
			_estat_aroots `rest'
		}
		else if `"`key'"' == "acplot" {
			_estat_acplot `rest'
		}
		else if `"`key'"' == bsubstr("summarize",1,max(2,`lkey')) {
			ArimaSumm `rest'
		}
		else {
			estat_default `0'
		}
	}
	local myrc _rc
	
	if "`fixcmd'" == "yes" {
		mata: st_global("e(cmd)", "arch")
	}	
	
	return add
	exit `myrc'
	
end

program ArimaSumm, rclass
	// handle the varlist since some non varnames on the e(b) matrix stripe

	syntax [anything(name=eqlist)] [, *]

	if "`eqlist'" == "" {
		local eqlist "(depvar:`e(depvar)')"
		local token : rowfullnames e(V)

		gettoken next token : token
		while (index("`next'","ARMA") != 1 & /// {
		       index("`next'","sigma") != 1) {
			if index("`next'",":_cons") != length("`next'") - 5 {
				local eqlist "`eqlist' (`next')"
			}
			gettoken next token : token
		}
	}

	estat_summ `eqlist', `options'

	return add
end
