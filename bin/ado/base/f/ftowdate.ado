*! version 2.1.1  08/09/94
program define ftowdate
	version 3.1
	local varlist "req ex max(1)"
	local if "opt"
	local in "opt"
	local options "Generate(string)"
	parse "`*'"
	if "`generat'"=="" { error 198 }
	conf new var `generat'
	tempvar g yr mo da syr sda touse good
	quietly { 
		_crcymd `varlist' `yr' `mo' `da'
		_crc2s2 `sda' `da'
		_crc2s2 `syr' `yr'
		gen str8 `g' = `sda' 
		replace `g'=`g'+"jan" if `mo'==1
		replace `g'=`g'+"feb" if `mo'==2
		replace `g'=`g'+"mar" if `mo'==3
		replace `g'=`g'+"apr" if `mo'==4
		replace `g'=`g'+"may" if `mo'==5
		replace `g'=`g'+"jun" if `mo'==6
		replace `g'=`g'+"jul" if `mo'==7
		replace `g'=`g'+"aug" if `mo'==8
		replace `g'=`g'+"sep" if `mo'==9
		replace `g'=`g'+"oct" if `mo'==10
		replace `g'=`g'+"nov" if `mo'==11
		replace `g'=`g'+"dec" if `mo'==12
		replace `g'=`g'+`syr'
		gen byte `touse'=1 `if' `in'
	}
	gen byte `good'=1 if `touse'==1 & `mo'>=1 & `mo'<=12 /*
			*/ & `da'>=1 & `da'<=31 & `yr'>=1 & `yr'<=99
	quietly replace `g'="" if `good'==.
	rename `g' `generat'
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
