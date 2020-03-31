*! version 1.0.1  07oct019
program meta__esize_desc
	version 16
	syntax, [ eslab(string) col(real 1) showstudlbl data ]
	local esvar : char _dta[_meta_esvar]
	if missing("`esvar'") local esvar "_meta_es"
	local sevar : char _dta[_meta_sevar]
	if missing("`sevar'") local sevar "_meta_se"
	local idvar : char _dta[_meta_studylabel]
	if missing("`idvar'") local idvar "Generic"
	
	local estyp : char _dta[_meta_estyp]
	if missing("`eslab'") local eslab : char _dta[_meta_eslabel]
	
	di as txt _col(`col') "Effect-size label:  " as txt "`eslab'"
	di as txt _col(`=`col'+6') "Effect size:  " as res "`esvar'"
	di as txt _col(`=`col'+8') "Std. Err.:  " as res "`sevar'"
	
	if "`idvar'" != "Generic" & !missing("`showstudlbl'") {
		di as txt _col(`=`col'+6') "Study label:  " as res "`idvar'"
	}
	if !missing("`data'") {
		local datavars : char _dta[_meta_datavars] 
		di as txt _col(`=`col'+5') "Summary data:  " as res "`datavars'"
	}
	
end
