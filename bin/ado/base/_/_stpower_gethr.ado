*! version 1.0.1  30mar2007
program _stpower_gethr
	version 10
	args fncval colon curlnhr
	tempname s2 hr pr
	scalar `hr'	= exp(`curlnhr')
	scalar `s2'	= exp(`hr'*ln($STPOW_S1))
	scalar `pr'	= 1-($STPOW_S1+$STPOW_LMB*`s2')/(1+$STPOW_LMB)
	scalar `fncval'	= abs($STPOW_CV*($STPOW_LMB*`hr'+1)/(`hr'-1))/ ///
			  sqrt($STPOW_LMB*`pr')
	scalar `fncval'	= -(sqrt($STPOW_N)-`fncval')^2 
end
