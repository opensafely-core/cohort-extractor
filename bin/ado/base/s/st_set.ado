*! version 6.2.10  02feb2018
program define st_set
	version 6, missing
/* { */
	if ("`1'"=="clear") {
		Clear 
		exit
	}
	if ("`1'" != "set") { exit 198 }

	#delimit ;
	args
		cmd
		chkvars			/* * or u_mi_...	*/
		stopts	/* 		"" or "notable"		*/
		id	/* id:  	<varname> | <nothing> 	*/
		bt	/* base time:	<varname>		*/
		bt0	/* enter time:	<exp> | <nothing>	*/
		failure /* failure	varname[=[=]numlist) | <nothing> */
		bs	/* scale:	<#>			*/

		enter	/* 1st enter:	"t[ime] <exp>" |
					"e[vent] <numlist>" |
					<nothing>		*/
		exit	/* last exit:	"t[ime] <exp>" |
					"e[vent] <numlist>" |
					<nothing> |		*/
		origin	/* origin:	"t[ime] <exp>" |
					"e[vent] <numlist>" |
					<nothing> 		*/
					

		ifexp	/* if exp:	<exp> | <nothing>	*/
		if	/* if():	<exp> | <nothing>	*/
		ever	/* ever():	<exp> | <nothing>	*/
		never	/* never():	<exp> | <nothing>	*/
		after	/* after():	<exp> | <nothing>	*/
		before	/* before():	<exp> | <nothing>	*/

		wt	/* wgt type:	<wgttype>		*/
		wv	/* wgt var:	<varname> | <#>		*/
		show	/* show:	"show"   |
					"noshow" | 
					<nothing>		*/
		full	/* marker:	<nothing> | "past" | 
					"future"  | "past future" */
	;
	#delimit cr

	if ("`chkvars'"=="") {
		local chkvars "*"
	}
	`chkvars' `id' `bt'

	if ("`full'"!="") {
			/* save everything possibly relevant */
		local fenter `"`enter'"'
		local fexit `"`exit'"'
		local forig `"`origin'"'
		local fif `"`if'"'
		local fever `"`ever'"'
		local fbefor `"`before'"'
		local fafter `"`after'"'

			/* now fill in what is appropriate */
		tempvar ever 
		qui gen byte `ever' = _st
		local if
		if "`full'"=="past future" | "`full'"=="past" {
			local origin "min"
			local enter
			local after
		}
		if "`full'"=="past future" | "`full'"=="future" {
			local exit "time ."
			local before
		}
	}


/*
	di `"cmd      |`cmd'|"'
	di `"stopts   |`stopts'|"'
	di `"id       |`id'|"'
	di `"bt       |`bt'|"'
	di `"bt0      |`bt0'|"'
	di `"failure  |`failure'|"'
	di `"bs       |`bs'|"'
	di `"enter    |`enter'|"'
	di `"exit     |`exit'|"'
	di `"origin   |`origin'|"'
	di `"ifexp    |`ifexp'|"'
	di `"if       |`if'|"'
	di `"ever     |`ever'|"'
	di `"never    |`never'|"'
	di `"after    |`after'|"'
	di `"before   |`before'|"'
	di `"wt       |`wt'|"'
	di `"wv       |`wv'|"'
	di `"show     |`show'|"'
*/


					/* edit options			*/
	if `"`bt0'"'=="." 	{ local bt0 }
	if `"`enter'"'=="." 	{ local enter }
	if `"`exit'"'=="." 	{ local exit }
	if `"`origin'"'=="." 	{ local origin }
	if `"`scale'"'=="." 	{ local scale 1 }
	if `"`if'"'=="." 	{ local if }
	if `"`if'"'=="1" 	{ local if }
	if `"`ever'"'=="."	{ local ever }
	if `"`ever'"'=="1"	{ local ever }
	if `"`never'"'=="."	{ local never }
	if `"`never'"'=="0"	{ local never }
	if `"`before'"'=="."	{ local before }
	if `"`ifexp'"'=="."	{ local ifexp }
	if `"`ifexp'"'=="1"	{ local ifexp }
					/* end edit options		*/


	if "`id'"!="" {
		if `"`failure'"'=="" {
			di in red /*
	*/ "specifying option id() requires you also specify option failure()"
			exit 198
		}
	}

	if "`bt0'" != "" {
		unab bt0: `bt0', max(1) name(time0())
		`chkvars' `bt0'
	}
		

	if (`"`failure'"'!="1" & `"`failure'"'!=".") | `"`id'"'!="" {
		Failure "`chkvars'" `failure'
		local bd `s(bd)'
		local event `s(event)'
	}



				/* interpret enter(), exit(), origin() */
	Iop "`chkvars'" "`id'" "enter" `"`enter'"'
	if `"`s(texp)'"' != "0" {
		local en_exp `s(texp)'
	}
	local en_ivar `s(ivar)'
	local en_list `s(ilist)'


	if `"`exit'"'!="failure" {
		Iop "`chkvars'" "`id'" "exit" `"`exit'"'
		local ex_exp `s(texp)'
		local ex_ivar `s(ivar)'
		local ex_list `s(ilist)'
	}

	if `"`origin'"'!="min" {
		Iop "`chkvars'" "`id'" "origin" `"`origin'"'
		if `"`s(texp)'"' != "0" {
			local or_exp `s(texp)'
		}
		local or_ivar `s(ivar)'
		local or_list `s(ilist)'
	}
	else	local or_cl "min"

				/* clear weight if weight=1	*/
	if `"`wv'"'=="1" {
		local wt
		local wv
	}
	else if "`wv'"!="" {
		unab wv: `wv', max(1) 
		`chkvars' `wv'
	}

	quietly {

				/* 
				   Step 1.  apply restrictions before we
					    interpret base time
				*/
		if (`"`ifexp'"' != "") {
			local ifif `"if `ifexp'"'
		}
		if ("`wt'" != "") {
			tempvar goodwgt
			mark `goodwgt' `ifif' [`wt'=`wv']
		}
		tempvar touse
		mark `touse' `ifif'
		local ifif
		count if `touse'==0
		local L_ifexp = r(N)

		local L_id 0
		if "`id'"!="" {
			count if missing(`id') & `touse'
			local L_id = r(N)
			replace `touse' = 0 if missing(`id')
		}

		count if `bt'>=. & `touse'
		local L_bt = r(N)
		replace `touse' = 0 if `bt'>=.


		if "`wt'"!="" & "`id'"!="" {
			sort `touse' `id' `bt'
			capture by `touse' `id':  /*
				*/ assert `wv'==`wv'[1] if `touse'
			if _rc { 
				di in red "weight not constant within `id'"
				exit 459
			}
		}

				/*
				    Step 2.  Construct d
				*/
		tempvar d
		if `"`event'"'!="" {
			gen byte `d' = 0 if `touse'
			tokenize `event'
			while "`1'"!="" {
				replace `d' = 1 if `bd'==`1' & `touse'
				mac shift
			}
		}
		else {
			if "`bd'"!="" {
				gen byte `d' = (`bd'!=0 & `bd'<.) if `touse'
			}
			else	gen byte `d' = 1 if `touse'
		}
		


				/*
				    Step 3.  construct origin
				*/
if "`or_cl'"=="" {
		if `"`or_exp'"'!="" | `"`or_ivar'"'!="" {
			tempvar zero
			if `"`or_exp'"' != "" {
				tempvar z1
				Smallest `z1' `"`or_exp'"' `touse' "`id'" `bt'
			}
			if "`or_ivar'" != "" {
				tempvar z2
				FirstEv `z2' /*
				*/ `"`or_list'"' `touse' "`id'" `bt' `or_ivar'
			}
			Choose `zero' max "`z1'" "`z2'" `touse'
			compress `zero'
		}
		else 	local zero 0
}
else {
	tempvar zero
	if `"`bt0'"'!="" {
		summarize `bt0' if `touse'
		gen double `zero' = r(min) if `touse'
	}
	else {
		summarize `bt' if `touse'
		gen double `zero' = r(min)-1 if `touse'
	}
	compress `zero'
}
		/* note, `zero'<0 | `zero'>=. are possible at this point */



				/*
				   Step 4.  Make t
				*/
		tempvar t 
		gen double `t' = (`bt'-`zero')/`bs' if `touse'
		compress `t'
		/* note:  `t' < 0 | `t'>=. are possible at this point */


				/*
				   Step 5.  make t0
				   make 2nd touse, touse2, update it for 
				   t0() problems
				*/
		tempvar t0 touse2
		gen byte `touse2' = `touse'
		local L_ut0m 0
		local L_ut0t 0
		local L_order 0
		local L_ord2 0
		if "`bt0'"!="" {
			count if (`bt0')>=. & `touse2'
			local L_ut0m = r(N)
			replace `touse2' = 0 if (`bt0')>=.

			count if (`bt0')>=`bt' & `touse2'
			local L_ut0t = r(N)
			replace `touse2' = 0 if (`bt0')>=`bt' 

			gen double `t0' = ((`bt0')-`zero')/`bs' if `touse2'
			if "`id'"!="" { 
				tempvar bad
				sort `touse2' `id' `bt'
				by `touse2' `id': gen byte `bad' = /*
				*/ (`bt'[_n-1]>`bt0' & _n>1) | /*
				*/ `bt0'>`bt'[_n+1] /*
				*/ if `touse2'
				count if `bad'==1
				local L_ord2 = r(N)
				replace `touse2'=0 if `bad'==1
				drop `bad'
			}
		}
		else {
			if "`id'"!="" {
				sort `touse2' `id' `bt'
				tempvar bad
				by `touse2' `id': gen byte `bad' = /*
				*/ `bt'==`bt'[_n-1] | `bt'==`bt'[_n+1] /*
				*/ if `touse2'
				count if `bad'==1
				local L_order = r(N)
				by `touse2' `id': gen double `t0' = /*
				*/ cond(_n==1,	/*
				*/ 	cond(`t'[2]<=0, 2*`t'[1], 0), /*
				*/	`t'[_n-1])   if `touse2'
				replace `touse2' = 0 if `bad'==1
				replace `t0' = . if `bad'==1
				drop `bad'
			}
			else	gen double `t0' = 0 if `touse2'
		}
		/* note:  `t0' < 0 | `t0'>=. are possible at this point */



				/* 
				   Step 6.  make first enter time 
				   going to use obs touse, not touse2, 
				   but do not double count 
				*/

		if `"`en_ivar'"'!="" | `"`en_exp'"'!="" {
			tempvar t_en
			if `"`en_exp'"'!="" {
				tempvar t1
				Smallest `t1' `"`en_exp'"' `touse' "`id'" `bt'
			}
			if `"`en_ivar'"'!="" {
				tempvar t2
				FirstEv `t2'  /*
				*/ `"`en_list'"' `touse' "`id'" `bt' `en_ivar'
			}
			Choose `t_en' max "`t1'" "`t2'" `touse'
			replace `t_en' = (`t_en'-`zero')/`bs' 
			compress `t_en'
		}
		else 	local t_en 0


				/*
				   Step 7.  make last exit time 
				   use touse rather than touse2, but 
				   do not double count
				*/
		if `"`ex_ivar'"'!="" | `"`ex_exp'"'!="" { 
			tempvar t_ex
			if `"`ex_exp'"'!="" {
				tempvar tex1
				Smallest `tex1' /*
				*/ `"`ex_exp'"' `touse' "`id'" `bt'
			}
			if `"`ex_ivar'"'!="" {
				tempvar tex2
				FirstEv `tex2'  /*
				*/ `"`ex_list'"' `touse' "`id'" `bt' `ex_ivar'
			}
			Choose `t_ex' min "`tex1'" "`tex2'" `touse'
			replace `t_ex' = (`t_ex'-`zero')/`bs'
			compress `t_ex'
		}
		else {
			if "`id'"!="" {
				/* use first failure event */
				tempvar t_ex
				FirstEv `t_ex' "1" `touse' "`id'" `bt' `d'
				replace `t_ex' = (`t_ex'-`zero')/`bs'
				compress `t_ex'
			}
			else	local t_ex .
		}

		/* bring touse and touse2 back together */
		replace `touse' = 0 if `touse2'==0
		drop `touse2'


				/*
				   Step 8.  apply other restrictions.
				   Performed in bt space because t might 
				   have missing values
				*/
		tempvar alsorm wrk
		gen byte `alsorm' = 0
		if `"`if'"'!="" {
			replace `alsorm'=1 if (`if')==0
		}

		if `"`ever'"'!="" {
			HasId ever `id'
			sort `touse' `id' `bt'
			by `touse' `id': gen float `wrk'=/*
				*/ sum(cond(`ever',1,0)) if `touse'
			by `touse' `id': replace `alsorm'=1 if `wrk'[_N]==0
			drop `wrk'
		}
		if `"`never'"' != "" {
			HasId never `id'
			sort `touse' `id' `bt'
			by `touse' `id': gen float `wrk'=/*
				*/ sum(cond(`never',1,0)) if `touse'
			by `touse' `id': replace `alsorm'=1 if `wrk'[_N]
			drop `wrk'
		}
		if `"`after'"' != "" {
			HasId after `id'
			sort `touse' `id' `bt'
			by `touse' `id': gen float `wrk' = /*
				*/ sum(cond(`after',1,0)) if `touse'
			by `touse' `id': replace `alsorm'=1 if `wrk'==0
			drop `wrk'
		}
		if `"`before'"' != "" {
			HasId before `id'
			sort `touse' `id' `bt'
			by `touse' `id': gen float `wrk' = /*
				*/ sum(cond(`before',1,0)) if `touse'
			by `touse' `id': replace `alsorm'=1 if `wrk'
			drop `wrk'
		}
		count if `alsorm' & `touse'
		local L_res = r(N)
		replace `touse'=0 if `alsorm'
		drop `alsorm'


				/* 
				   Step 9.  apply restrictions due to 
					    enter and exit times 
				*/
		/* cannot enter sample until variable enter.
		   Ergo, enter<0 or enter>=. are okay.  
		   if t0=5 and enter<0 or enter>=., they still enter at 5
		*/

		/* records that have no entry time are excluded */
		count if (`t_en'>=. | `zero'>=.) & `touse' 
		local L_never = r(N)
		replace `touse'=0 if `t_en'>=. | `zero'>=.

		/* records that end prior to enter time are excluded */
		count if `t'<=`t_en' & `t_en'<. & `touse'
		local L_prior = r(N)
		replace `touse'=0 if `t'<=`t_en' & `t_en'<.

		/* records that begin before enter and end after need 
		   resetting
		*/
		replace `t0' = `t_en' if `t0'<=`t_en' & `t'>`t_en' & `touse'


		/* exit times:  missings just mean infinity */
		count if `t0'>=`t_ex' & `touse'
		local L_after = r(N)
		replace `touse'=0 if `t0'>=`t_ex'

		replace `d' = 0      if `t0'<`t_ex' & `t'>`t_ex'
		replace `t' = `t_ex' if `t0'<`t_ex' & `t'>`t_ex'

		replace `t0' = 0 if `t0'<0 & `touse'
		
				/* 
				    Step 10.  apply implied restrictions
				*/ 



		count if `t0' >= `t' & `touse'
		local L_t0t = r(N)
		replace `touse'=0 if `t0'>=`t'

/*
		count if `t0'<0 & `touse'
		local L_neg = r(N)
		replace `touse' = 0 if `t0'<0 | `t'<0
*/

		if "`goodwgt'"!="" {
			count if `goodwgt'==0 & `touse'
			local L_wgt = r(N)
			replace `touse'=0 if `goodwgt'==0
		}
		else	local L_wgt 0



				/* 
				    Step 11.  Clean up
				*/ 
		replace `t'=. if !`touse'
		replace `t0'=. if !`touse'
		replace `d' = . if !`touse'
		compress `t0'

/*
		if "`id'"=="" { 
			count if `t0'!=0 & `touse'
			if r(N)==0 { 
				drop `t0'
			}
		}
*/
	} /* quietly */

	Clear
	confirm new var _st _d _t _t0 _origin _insmpl

	nobreak {
		rename `touse' _st
		rename `d' _d
		rename `t' _t
		rename `t0' _t0
		lab var _st "1 if record is to be used; 0 otherwise"
		lab var _d "1 if failure; 0 if censored"
		lab var _t0 "analysis time when record begins"
		lab var _t "analysis time when record ends"

				/* save "full" option copies */
		char _dta[st_fente] `"`fenter'"'
		char _dta[st_fexit] `"`fexit'"'
		char _dta[st_forig] `"`forig'"'
		char _dta[st_fif] `"`fif'"'
		char _dta[st_fever] `"`fever'"'
		char _dta[st_fbefo] `"`fbefor'"'
		char _dta[st_fafte] `"`fafter'"'
		char _dta[st_full] `"`full'"'
				/* end save "full" option copies */

				/* save ver. 1 compatibility 	*/
		char _dta[st_t] "_t"
		char _dta[st_t0] "_t0"
		char _dta[st_d] "_d"
				/* endsave ver. 1 compatibility	*/

				/* save selection criteria	*/
		char _dta[st_ifexp] 	`"`ifexp'"'
		char _dta[st_if]	`"`if'"'
		if `"`full'"' != "" {
			rename `ever' _insmpl
			char _dta[st_ever] _insmpl
		}
		else	char _dta[st_ever]	`"`ever'"'
		char _dta[st_never]	`"`never'"'
		char _dta[st_after]	`"`after'"'
		char _dta[st_befor]	`"`before'"'
				/* end save selection criteria	*/

				/* save weights			*/
		char _dta[st_wt]	"`wt'"
		char _dta[st_wv]	"`wv'"
		if "`wt'"!="" {
			char _dta[st_w] `"[`wt'=`wv']"'
		}
				/* end save weights		*/

				/* save exit() and enter() 	*/
		Combine st_exit `"`ex_ivar'"' `"`ex_list'"' `"`ex_exp'"'
		Combine st_enter `"`en_ivar'"' `"`en_list'"' `"`en_exp'"'
				/* end save exit() and enter() 	*/

				/* save scale()			*/
		char _dta[st_bs]	"`bs'"
		char _dta[st_s] `_dta[st_bs]'		/* for time being */
				/* end save scale()		*/


				/* save origin()		*/
		if "`or_cl'"!="" {
			char _dta[st_orig] "min"
		}
		else	Combine st_orig `"`or_ivar'"' `"`or_list'"' `"`or_exp'"'

		if "`zero'"!="0" {
			qui summarize `zero' if _st
			local zmin = r(min)
			if !(r(min)==r(max) & r(min)<. & r(min)==`zmin') {
				rename `zero' _origin
				lab var _origin "evaluated value of origin()"
				char _dta[st_o] "_origin"
			}
			else	char _dta[st_o] `zmin'
			local zmin
		}
		else	char _dta[st_o] "0"
				/* end save origin()		*/

				/* save key variables		*/
		char _dta[st_ev]	`"`event'"'
		char _dta[st_bd]	`"`bd'"'
		char _dta[st_bt] 	"`bt'"
		char _dta[st_bt0] 	`"`bt0'"'
		char _dta[st_id] 	"`id'"
				/* end save key variables	*/
	


				/* save show/noshow		*/
		if "`show'"=="noshow" {
			char _dta[st_show] "noshow"
		}
				/* end save show/noshow		*/

				/* save marker			*/
		char _dta[st_ver] 2
		char _dta[_dta] "st"
				/* end save marker		*/
	}

	if ("`chkvars'"=="*") {
		st, `stopts'
	}
	else {
		st, `stopts' mi
	}

	di in smcl _n in gr "{hline 78}"
	local obs="observation"+cond(_N==1,"","s")	
	Di1 _N "total `obs'"
	qui count if _st==0
	local Left = _N - r(N)
	if r(N) { 
		Di2 `L_ifexp' "ignored at outset because of -if <exp>-"
		Di2 `L_id'   `"ignored because `_dta[st_id]' missing"'
		Di2h `L_bt' "event time missing" "(`_dta[st_bt]'>=.)" 
		Di2h `L_ut0m' "entry time missing" "(`_dta[st_bt0]'>=.)"
		Di2h `L_ut0t' /*
		*/ "entry on or after exit" `"(`_dta[st_bt0]'>`_dta[st_bt]')"'
		Di2h `L_order' `"multiple records at same instant"' "" /*
		*/ `"(`_dta[st_bt]'[_n-1]==`_dta[st_bt]')"'
		Di2h `L_ord2' "overlapping records" /*
			*/ `"(`_dta[st_bt]'[_n-1]>`_dta[st_bt0]')"'
		Di2 `L_res' "ignored per request (if(), etc.)"
		Di2 `L_never' "ignored because never entered"

		if (`L_prior'==1) {
			Di2 `L_prior' "observation ends on or before enter()"
		}
		else Di2 `L_prior' "observations end on or before enter()"
		
		if (`L_t0t'==1) {
			Di2 `L_t0t' "observation ends on or before origin()"
		}
		else Di2 `L_t0t' "observations end on or before origin()"

		if `L_after' {
			if `"`exit'"'=="" | `"`exit'"'=="failure" {
				local m "(first) failure"
			}
			else	local m "exit"

			if (`L_after'==1) {
			Di1 `L_after' "observation begins on or after `m'"
			}
			else Di1 `L_after' "observations begin on or after `m'"
		}
		Di2h `L_wgt' "weights invalid"
	}
	else	Di1 0 "exclusions"
	di in smcl in gr "{hline 78}"

	if "`_dta[st_wt]'" == "fweight" { 
		local obs = "observation"+ cond(`Left'==1,"","s")
		Di1 `Left' "physical `obs' remaining, equal to"
		local wv `_dta[st_wv]'
		qui sum `wv' if _st, meanonly
		local obs = "observation"+cond(`r(sum)'==1,"","s")
		Di1 `r(sum)' "weighted `obs', representing"
	}
	else {
		local obs = "observation"+ cond(`Left'==1,"","s")
		Di1 `Left' "`obs' remaining, representing"
		tempvar wv 
		qui gen byte `wv'=1 if _st
	}
	tempvar wrk
	if "`_dta[st_id]'" != "" {
		sort _st `_dta[st_id]' _t 
		qui by _st `_dta[st_id]': gen byte `wrk' = 1 if _n==1 & _st
		qui sum `wv' if `wrk'==1, meanonly
		local msg = "subject" + cond(r(sum)==1,"","s")
		Di1 `r(sum)' "`msg'"
		drop `wrk'
	}


	if "`_dta[st_id]'" != "" {
		capture by _st `_dta[st_id]': assert sum(_d)<=1 if _st
		if _rc == 0 {
			local m "in single-failure-per-subject data"
			local chk yes
		}	
		else 	local m "in multiple-failure-per-subject data"
	}
	else	local m "in single-record/single-failure data"

	qui sum `wv' if _d & _st, meanonly
	local msg = "failure" + cond(r(sum)==1,"","s")
	Di1 `r(sum)' "`msg' `m'"

	if "`chk'"=="yes" { 
		qui by _st `_dta[st_id]': gen float `wrk' = /*
			*/ sum(_d) & _n<_N if _st
		qui by _st `_dta[st_id]': replace `wrk' = /*
			*/ sum(`wrk')
		capture assert `wrk'==0 if _st
		if _rc { 
			qui by _st `_dta[st_id]': replace `wrk'=0 if _n!=_N
			qui sum `wv' if `wrk', meanonly
			local msg = cond(r(sum)~=1,"subjects remain",/*
						*/ "subject remains")
			Di1 `r(sum)' "`msg' at risk after failure"
		}
		drop `wrk'
	}


	qui gen double `wrk' = `wv'*(_t - _t0) if _st 
	qui sum `wrk', meanonly 
	
	di in ye %11.0gc round(r(sum),0.001) in gr /*
	*/ "  total analysis time at risk and under observation"
     	di in gr _col(49) "at risk from t = " in ye %9.0gc 0
	drop `wrk'
	qui sum _t0 if _st, meanonly
	di in gr _col(38) "earliest observed entry t = " in ye %9.0gc r(min)
	qui sum _t if _st, meanonly
	di in gr _col(43) "last observed exit t = " in ye %9.0gc r(max)
end

program define Combine 
	args chname ivar ilist texp
	local abb = usubstr(`"`chname'"',1,5)
	if `"`ivar'"'=="" & `"`texp'"'=="" { exit }
	if `"`ivar'"' != "" {
		char _dta[`chname'] `"`ivar'==`ilist'"'
		char _dta[`abb'vn] `"`ivar'"'
		char _dta[`abb'nl] `"`ilist'"'
		if `"`texp'"'!="" {
			char _dta[`abb'exp] `"`texp'"'
			char _dta[`chname'] `"`_dta[`chname']' time `texp'"'
		}
		exit
	}
	char _dta[`abb'exp] `"`texp'"'
	char _dta[`chname'] `"time `texp'"'
end


program define Choose
	args newvar minmax t1 t2 touse
	if "`t2'"=="" { 
		rename `t1' `newvar'
	}
	else if "`t1'"=="" { 
		rename `t2' `newvar'
	}
	else {
		replace `t1' = `minmax'(`t1',`t2') if `touse'
		drop `t2'
		rename `t1' `newvar'
	}
end



program define Failure, sclass
	sret clear
	gettoken chkvars 0 : 0
	if (strtrim(`"`0'"')) == "" { exit } 
	gettoken name 0 : 0, parse(" =")
	gettoken eqsign 0 : 0, parse(" =")
	if !(`"`eqsign'"'=="" | `"`eqsign'"'=="=" | `"`eqsign'"'=="==") {
		di in red "option failure():  syntax error"
		exit 198
	}
	unab name: `name', max(1)
	`chkvars' `name'
	sret local bd `name'
	if `"`eqsign'"'=="" { exit }
	numlist `"`0'"', missingok
	sret local event `"`r(numlist)'"'
end
	

program define Di1
	di in ye %11.0gc round(`1',0.001) in gr `"  `2'"'
	mac shift 2 
	while `"`1'"' != "" {
		di in gr _skip(13) `"`1'"'
		mac shift 
	}
end

program define Di2
	if (`1')==0 { exit }
	di in ye %11.0gc round(`1',0.001) in gr `"  `2'"'
	mac shift 2 
	while `"`1'"' != "" {
		di in gr _skip(13) `"`1'"'
		mac shift 
	}
end

program define Di2h
	if (`1')==0 { exit }
	di in ye %11.0gc round(`1',0.001) in gr `"  `2'"' in gr " `3'" /* 
		*/ _col(65) "PROBABLE ERROR"
	mac shift 3 
	while `"`1'"' != "" {
		di in gr _skip(13) `"`1'"'
		mac shift 
	}
end

/*
program define Di2
	if (`1')==0 { exit }
	di in ye _skip(11) %9.0g (`1') in gr `" `2'"'
	mac shift 2 
	while `"`1'"' != "" {
		di in gr _skip(11) _skip(10) `"`1'"'
		mac shift 
	}
end
*/

program define Di2z
	di in ye _skip(13) %9.0gc (`1') in gr `" `2'"'
	mac shift 2 
	while `"`1'"' != "" {
		di in gr _skip(13) _skip(10) `"`1'"'
		mac shift 
	}
end



/* 
origin(varname=3 4 5 time exp)
origin(time exp)
origin(varname)
*/

program define Iop, sclass
	args chkvars idvar opname cnts 
	/* returns texp, ivar, ilist */
	sret clear
	if `"`cnts'"' == "" { exit }

	gettoken word cnts : cnts, parse(" =")
	gettoken eqsign : cnts, parse(" =")

	if `"`eqsign'"'=="" {
		unab word : `word', max(1) name(`opname'())
		`chkvars' `word'
		sret local texp `word'
		exit
	}

	if `"`eqsign'"'=="=" | `"`eqsign'"'=="==" { 
		gettoken eqsign cnts : cnts, parse(" =")
		unab ivar : `word', max(1)
		`chkvars' `ivar'
		sret local ivar `ivar'

		gettoken word cnts: cnts
		while `"`word'"' != "" & /*
		*/ bsubstr("time",1,length(`"`word'"'))!=`"`word'"' {
			local list `list' `word'
			gettoken word cnts: cnts
		}
		numlist `"`list'"', missingok
		sret local ilist `r(numlist)'
		if `"`word'"' == "" { exit }
	}

	if bsubstr("time",1,length("`word'")) == "`word'" { 
		local ivar "`s(ivar)'"		/* hold values because ... */
		local ilist "`s(ilist)'"	/* ... unabbrev clears     */
		capture unabbrev `cnts', max(1)
		if _rc==0 {
			`chkvars' `cnts'
			local cnts `cnts'
		}
		sret local ivar `ivar'
		sret local ilist `ilist'
		sret local texp `cnts'
		exit
	}

	di in red "option `opname'() invalid"
	exit 198
end
	


program define HasId 
	args opname id
	if "`id'"=="" {
		di in red "option `opname'() requires option id()"
		exit 198
	}
end


program define Smallest
	args newvar exp touse id bt
	if "`id'"!="" {
		sort `touse' `id' `bt'
		by `touse' `id': gen double `newvar'=`exp' if `touse'
		sort `touse' `id' `newvar'
		by `touse' `id': replace `newvar' = `newvar'[1]
	}
	else	gen double `newvar' = `exp' if `touse'
end

program define FirstEv
	args newvar list touse id bt bd

	sort `touse' `id' `bt'
	gen double `newvar' = .

	tokenize `list'
	while "`1'"!="" {
		replace `newvar' = `bt' if `bd'==`1' & `touse'
		mac shift
	}
	by `touse' `id': replace `newvar' = `newvar'[_n-1] /*
			*/ if `touse' & `newvar'[_n-1]<.
	by `touse' `id': replace `newvar' = `newvar'[_N] if `touse'
end

			
program define Clear
	nobreak {
		char _dta[_dta] 
		char _dta[st_set]
		char _dta[st_ver]
		char _dta[st_id] 

		char _dta[st_bt0]
		char _dta[st_bt]
		char _dta[st_bd]
		char _dta[st_ev]

		char _dta[st_enter]
		char _dta[st_enexp]
		char _dta[st_envn] 
		char _dta[st_ennl] 
		char _dta[st_exit]
		char _dta[st_exexp]
		char _dta[st_exvn] 
		char _dta[st_exnl] 
		char _dta[st_orig]
		char _dta[st_orexp]
		char _dta[st_orvn] 
		char _dta[st_ornl] 

		char _dta[st_bs]

		char _dta[st_ifexp]
		char _dta[st_if]
		char _dta[st_ever]
		char _dta[st_never]
		char _dta[st_after]
		char _dta[st_befor]

		char _dta[st_wt]
		char _dta[st_wv]
		char _dta[st_w]
		char _dta[st_show]

		capture drop `_dta[st_o]'
		char _dta[st_o]
		char _dta[st_s]

		Drop _dta[st_t] _t
		Drop _dta[st_t0] _t0
		Drop _dta[st_d] _d
		novarabbrev {
			capture drop _st
		}

		capture confirm integer number `_dta[st_n0]'
		if _rc == 0 { 
			local i 1 
			while `i' <= `_dta[st_n0]' {
				char _dta[st_n`i']
				local i = `i' + 1 
			}
		}
		char _dta[st_n0]

		char _dta[st_fev]
		char _dta[st_fente]
		char _dta[st_fexit]
		char _dta[st_forig]
		char _dta[st_fif]
		char _dta[st_fever]
		char _dta[st_fafte]
		char _dta[st_fbefo]
		char _dta[st_full]
		capture drop _insmpl
		capture drop _origin
	}
end

program define Drop
	args char default
	if "``char''" == "`default'" {
		capture drop `default'
	}
	char `char'
end
		
exit
}
