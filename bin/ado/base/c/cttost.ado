*! version 2.0.1  14feb2007 
program define cttost
	version 9.2
	syntax [, CLEAR noPreserve Wvar(string) T0var(string) ]

	ct_is

	if `"`clear'"'=="" {
		qui desc
		if r(changed) { 
			error 4 
		}
	}
	if ("`preserve'"=="") preserve


	MakeVar "wvar()" `"`wvar'"' w pop weight wgt 
	local w `"`s(newvar)'"'
	local t : char _dta[ct_t]
	local die : char _dta[ct_d]
	local cens : char _dta[ct_c]
	local ent : char _dta[ct_e]
	local by : char _dta[ct_by]

	if "`ent'" !=""{
		MakeVar "t0()" `"`t0var'"' t0 time0 etime
		local t0 `"`s(newvar)'"'
	}
	else{
		tempvar t0
		unab original: *
	}
	if "`by'" !=""{
		sort `by'
		local by0 "by `by':"
		local bys0 "bysort `by':"
	}
	qui{
		gen double `t0'=.
		gen double `w' = .

		tempvar dfail dcens dent
		gen double `dfail' = `die'

		if "`cens'" != ""{
			gen double `dcens' = `cens' 
		}
		else{
			gen double `dcens' = 0
		}

		if "`ent'" != ""{
			gen double `dent' = `ent' 
		}
		else{
			gen double `dent' = 0
			`by0' FillEnter  `t' `dfail' `dcens' `dent'
		}

		tempvar  t1 d 
		gen double `t1' = .
		gen double `d' = .

		`bys0' MakeSt `t' `dent' `dfail' `dcens', /// 
				t0("`t0'") t1(`t1') d(`d') w(`w')
		*varlist are existent variables
		*options are variables to be filled in.
		replace `t'=`t1'
		replace `die' =`d'
		drop if `w' == .
	}
	if "`ent'" != "" {
		keep `by' `t' `w' `t0' `die'
		if _caller()<6 {
			noi  ztset_5 `t' `die' [fw=`w'], t0(`t0')
		}
		else {
			noi stset `t' [fw =`w'], enter(`t0') fail(`die')
		}
	}
	else {
		keep `by' `t' `w' `die' `original'
		if _caller()<6 {
			noi  ztset_5 `t' `die' [fw=`w']
		}
		else {
			noi stset `t' [fw =`w'], fail(`die')
		}
	}
	if ("`preserve'" == "") restore, not

end



program MakeSt, byable(recall)
	*for each group, creates st observations at the bottom of the dataset
	syntax varlist [if] [in], t0(string) t1(string) d(string) w(string)
	*varlist are ct variables: time dent dfail dcens
	* dent duplicate of enter, etc
	*options are st variables
	tempname time dent dfail dcens 
	tempvar dout
	tokenize `varlist'
	marksample touse
	local time `1'
	local dent `2'
	local dfail `3'
	local dcens `4'
	gen  double `dout' = `dfail' + `dcens'
	gsort  -`touse'  +`time' 
	 *now usable obs are at the top
	qui count if `touse'
	local N = r(N)
	local R = _N

	local i = 1
	forvalues j = 2(1)`N'{
		if `dout'[`j']>0{
			while `dfail'[`j']>0{
				while `dent'[`i'] == 0 {
					local i = `i'+1	
				}
				expand 2 in `j'
				local R = `R'+1
				local  m = min(`dfail'[`j'], `dent'[`i']) in `R'
				replace `w' = `m' in `R'
				replace `d' = 1 in `R'
				replace `t0' = `time'[`i'] in `R'
				replace `t1' = `time'[`j'] in `R'
				replace `dent' = `dent' -`m' in `i'
				replace `dfail' = `dfail' -`m' in `j'
			}
			while `dcens'[`j']>0{
				while `dent'[`i'] == 0 {
					local i = `i'+1	
				}
				expand 2 in `j'
				local R = `R'+1
				local  m = min(`dcens'[`j'], `dent'[`i']) in `R'
				replace `w' = `m' in `R'
				replace `d' = 0 in `R'
				replace `t0' = `time'[`i'] in `R'
				replace `t1' = `time'[`j'] in `R'
				replace `dent' = `dent' -`m' in `i'
				replace `dcens' = `dcens' -`m' in `j'
			}
		}
	}
end


program FillEnter, byable(recall)
/*adds one observation and fills the enter
variable when there is not "enter" from cttost*/
		syntax varlist [if] [in]  
		marksample touse
		local t: word 1 of `varlist'
		local dfail: word 2 of `varlist'
		local dcens: word 3 of `varlist'
		local enter: word 4 of `varlist'
		local npu = _N+1
		set obs `npu'
		qui summ `dfail' if `touse'
		local c1 = r(sum)
		qui summ `dcens' if `touse'
		local c2 = r(sum)
		replace `t' = 0 in `npu'
		replace `enter' = `c1'+`c2' in `npu'
		replace `dfail' = 0 in `npu'
		replace `dcens' = 0 in `npu'
		if "`_byvars'"!=""{
			replace `touse' = 1 in `npu'
			foreach var of local _byvars {
				tempvar temp2
				egen double `temp2' = min(`var') if `touse'  
				replace `var' =`temp2' in `npu'
			}
                }
end

program define MakeVar, sclass /* opname "[var]" <potential-name-list> */
	local option `"`1'"'
	if `"`2'"'!="" {
		local n : word count `"`2'"'
		if `n'!=1 {
			di in red `"`option' invalid"'
			exit 198
		}
		confirm new var `2'
		sret local newvar `"`2'"'
		exit
	}
	mac shift 2
	local list `"`*'"'
	while `"`1'"'!="" {
		capture confirm new var `1'
		if _rc==0 {
			sret local newvar `"`1'"'
			exit
		}
		mac shift
	}
	di in red `"could not find variable name for `option'"'
	di in red `"      tried:  `list'"'
	di in red `"      specify `option' explicitly"'
	exit 110
end

