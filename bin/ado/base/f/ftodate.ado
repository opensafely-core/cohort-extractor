*! version 2.1.1  08/09/94
program define ftodate
	version 3.1
	local varlist "req ex max(1)"
	local if "opt"
	local in "opt"
	local options "Generate(string)"
	parse "`*'"
	if "`generat'"=="" { error 198 }
	conf new var `generat'
	tempvar yr mo da syr smo sda touse
	quietly { 
		_crcymd `varlist' `yr' `mo' `da' /* define `yr', `mo', `da' */
		_crc2s2 `smo' `mo'
		_crc2s2 `sda' `da'
		_crc2s2 `syr' `yr'
		gen byte `touse' = 1 `if' `in'
	}
	#delimit ; 
	gen str8 `generat'=`smo'+"/"+`sda'+"/"+`syr' if `touse'==1 &
			`mo'>=1 & `mo'<=12 & `da'>=1 & `da'<=31 &
			`yr'>=1 & `yr'<=99 ;
	#delimit cr
end

program define _crc2s2
	version 3.0
	quietly { 
		gen str2 %_1 = string(%_2)
		replace %_1="0"+%_1 if length(%_1)==1
	}
end


*  _crcymd:  Usage:  _crcymd <evar> <newyrvar> <newmovar> <newdavar>
*                               1        2         3          4
program define _crcymd
	version 3.0
	quietly {
		gen int %_2=%_1/10000
		gen byte %_3=int(%_1/100) - %_2*100
		gen byte %_4=%_1-%_2*10000-%_3*100 
	}
end
