*! version 1.0.3  26jan2015
program mixed_estat
	version 13
	
	if "`e(cmd)'" != "mixed" {
		error 301
	}
	
	gettoken sub rest: 0, parse(" ,")
	if `"`sub'"' == bsubstr("wcorrelation",1,max(4,length("`sub'"))) {
		_mixed_wcorr `rest'
		exit
	}
	else if `"`sub'"' == "df" {
		_mixed_ddf `rest'
		exit 
	}
	
	_xtme_estat `0'
	
end

exit
