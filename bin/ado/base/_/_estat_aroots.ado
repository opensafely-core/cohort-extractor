*! version 1.0.1  15oct2013
program define _estat_aroots, rclass sort
	version 13
	
	if "`e(predict)'" != "arima_p" {
		di "{err}aroots can only be run after {helpb arima}"
		exit 198
	}
	
	syntax [, *]
	
	_estat_aroots_w2 , `options'
	
	return add
	
end
exit
