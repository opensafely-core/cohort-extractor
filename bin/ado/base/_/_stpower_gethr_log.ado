*! version 1.0.1  30mar2007
program _stpower_gethr_log
	version 10
	args fncval colon curlnhr
	tempname s2 pr
	scalar `s2'	= exp(exp(`curlnhr')*ln($STPOW_S1))
	scalar `pr'	= 1-($STPOW_S1+$STPOW_LMB*`s2')/(1+$STPOW_LMB)
	scalar `fncval'	= abs($STPOW_CV*($STPOW_LMB+1)/`curlnhr')/	///
			  sqrt($STPOW_LMB*`pr')
	scalar `fncval'	= -(sqrt($STPOW_N)-`fncval')^2 
end
