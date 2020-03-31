*! version 3.0.1  07jul2000
program define ml_cnt
	version 7
	if "$ML_cnt0"=="" { 
		global ML_cnt0 0
		global ML_cnt1 0
		global ML_cnt2 0
	}
	if "`2'"=="0" | "`2'"=="1" | "`2'"=="2" { 
		global ML_cnt`2' = ${ML_cnt`2'} + 1
	}
	else	global ML_cnt_ = $ML_cnt_ + 1
	$ML_vers `0'
end
