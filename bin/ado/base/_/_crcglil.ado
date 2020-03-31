*! version 4.1.0  19feb2019
program define _crcglil
	version 6.0
	local eta `1'
	local mu  `2'
	local pow `3'
	local m   `4'
	local k   `5'
	local bernoul `6'
	local l `"`e(link)'"'
	local f `"`e(family)'"'
	local small 1e-6
	if `"`l'"'=="pow" {
		if abs(`pow')<`small' { replace `mu' = exp(`eta') }
		else if abs(`pow'-1)>`small' { replace `mu' = `eta'^(1/`pow') }
		else replace `mu' = `eta'
		if `"`f'"' == "bin" & !`bernoul' { replace `mu'=`mu'*`m' }
		exit
	}
	if `"`f'"' == "bin" {
		if `"`l'"' == "l" {
			replace `mu' = 1/(1+exp(-`eta'))
		}
		else if `"`l'"' == "p" {
			replace `mu' = normprob(`eta')
		}
		else if `"`l'"' == "c"  {
			replace `mu' = -expm1(-exp(`eta'))
		}
		else if `"`l'"'=="opo" {
			if abs(`pow')<`small' {
				replace `mu' = 1/(1+exp(-`eta'))
			}
			else if abs(`pow'-1)>`small' {
				replace `mu' = 1/(1+(1+`eta'*`pow')^(-1/`pow'))
			}
			else replace `mu' = (1+`eta')/(2+`eta')
		}
		if !`bernoul' { replace `mu'=`mu'*`m' }
		exit
	}
	if `"`f'"' == "poi"  { replace `mu' = exp(`eta') }
	else if `"`f'"' == "gam"  { replace `mu' = 1/`eta' }
	else if `"`f'"' == "ivg" { replace `mu' = 1/sqrt(`eta') }
	else if `"`f'"' == "nb" { replace `mu' = 1/(`k'*(exp(-`eta')-1)) }   
end
