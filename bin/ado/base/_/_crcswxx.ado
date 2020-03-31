*! version 2.1.1  29jan2015
program define _crcswxx
	version 3.1 
	local ttl `1'
	local cmd0 `2'
	local cmd1 `3'
	mac shift 3
	if "`*'"=="" | bsubstr("`1'",1,1)=="," { 
		`cmd1' `*'
		exit
	}
	local varlist "req ex min(3)"
	local if "opt"
	local in "opt"
	local weight "fweight aweight"
	local options /*
	*/ "Level(cilevel) LOg PE(real .2) PR(real .4) Forward LOCK *"
	parse "`*'"
	if `pe'>=`pr' | `pe'<0 | `pr'>1 { 
		di in red "pe(`pe') and pr(`pr') invalid"
		exit 198
	}

	if "`forward'"=="" { 
		local forward "backward"
		local ttl0 "Backward"
	}
	else	local ttl0 "Forward"
	if "`lock'"!="" { 
		local ttl0 "`ttl0' only"
	}
	if "`weight'"~="" { 
		local weight "[`weight'`exp']"
	}
	parse "`varlist'", parse(" ") 
	local lhs `1'
	mac shift
	tempvar hat 
	quietly { 
		`cmd0' `lhs' `*' `weight' `if' `in', `options'
		capture predict `hat' `if' `in'
		if _rc { 
			noisily error 2000
		}
		drop `hat'
	}
	preserve
	quietly { 
		predict `hat' `if' `in'
		drop if `hat'==. | `lhs'==. 
		noisily di in gr "`ttl0' stepwise `ttl':"
		noisily _crcstep `forward' "`lock'" `cmd0' "`pe'" "`pr'" /*
			*/ `lhs' "`*'" "`options'" "`weight'"
		noisily `cmd1' `lhs' $S_1 `weight' `if' `in', /*
			*/ nolog level(`level') `options'
	}
end

program define _crcstep
	version 3.0
	local flavor `1'	/* backward or forward	*/
	local lock   `2'	/* lock or nothing	*/
	mac def S_13 `3'	/* cmd		*/
	mac def S_10 `4'	/* Pe		*/
	mac def S_11 `5'	/* Pr		*/
	mac def S_12 `6'	/* lhs		*/
	mac def S_20 `7'	/* varlist	*/
	mac def S_14 `8'	/* cmd options	*/
	mac def S_15 `9'	/* weight	*/
	mac def S_21		/* clear to-add */
	if "`lock'"=="" | "`flavor'"!="forward" { 
		di in gr "Significance level for removing = " in ye $S_11
	}
	if "`lock'"=="" | "`flavor'"=="forward" { 
		di in gr "Significance level for entering = " in ye $S_10
	}

				/* cleanup varlist	*/
	parse "$S_20", parse(" ")
	local i 1
	while "``i''"!="" { 
		capture local b = _b[``i'']
		if _rc { 
			di in blu ///
			"(note: ``i'' dropped because of collinearity)"
			local `i' " " 
		}
		local i=`i'+1
	}
	mac def S_20 "`*'"

	if "`flavor'"=="forward" { 
		if "`lock'"=="" { 
			capture noisily _crcsfd
		}
		else	capture noisily _crcsfdo
	}
	else {
		if "`lock'"=="" { 
			capture noisily _crcsbw
		}
		else	capture noisily _crcsbwo
	}
	mac def S_1 "$S_20"
	mac def S_13
	mac def S_10
	mac def S_11
	mac def S_12
	mac def S_20
	mac def S_21
	mac def S_14
	mac def S_15
	exit _rc
end

program define _crcsfd
	mac def S_21 "$S_20"
	mac def S_20		/* swap to-add and current	*/
	_crcswad
	if $S_30==0 { 
		exit
	}
	_crcswad
	if $S_30==0 { 
		exit 
	}
	while (1) { 
		_crcswrm
		local added $S_30
		_crcswad
		if $S_30==0 & `added'==0 { 
			exit
		}
	}
end

program define _crcsfdo
	mac def S_21 "$S_20"
	mac def S_20		/* swap to-add and current	*/
	while (1) { 
		_crcswad
		if $S_30==0 { 
			exit
		}
	}
end

program define _crcsbw
	_crcswrm
	if $S_30==0 { 
		exit
	}
	_crcswrm
	if $S_30==0 { 
		exit 
	}
	while (1) { 
		_crcswad
		local added $S_30
		_crcswrm
		if $S_30==0 & `added'==0 { 
			exit
		}
	}
end

program define _crcsbwo
	while (1) { 
		_crcswrm
		if $S_30==0 { 
			exit
		}
	}
end

program define _crcswrm
	version 3.1
	quietly $S_13 $S_12 $S_20 $S_15, $S_14
	if "$S_E_tdf"=="" { 
		local df = _result(5)
	}
	else	local df $S_E_tdf
	parse "$S_20", parse(" ")
	local j 1 		/* smallest */
	if `df'==. {
		local sig = 2*normprob(-abs(_b[`1']/_se[`1']))
	}
	else	local sig=tprob(`df',_b[`1']/_se[`1'])
	local i 2
	while "``i''"!="" { 
		if `df'==. {
			local newsig=2*normprob(-abs(_b[``i'']/_se[``i'']))
		}
		else	local newsig=tprob(`df',_b[``i'']/_se[``i''])
		if `newsig'>`sig' { 
			local j `i'
			local sig `newsig'
		}
		local i=`i'+1
	}
	if `sig'>$S_11 { 
		di in gr "dropping ``j''" _col(21) "p =" in ye %6.3f `sig'
		global S_21 "$S_21 ``j''"
		local `j' " " 
		global S_20 "`*'"
		global S_30 1
	}
	else	global S_30 0
end

program define _crcswad
	version 3.1
	global S_30 0
	parse "$S_21", parse(" ")
	if "`1'"=="" { 		/* empty to-add list	*/
		exit
	}
	local j 0 		/* smallest */
	local sig .
	local i 1
	while "``i''"!="" { 
		quietly $S_13 $S_12 $S_20 ``i'' $S_15, $S_14
		if "$S_E_tdf"=="" { 
			local df = _result(5)
		}
		else	local df $S_E_tdf
		if `df'==. {
			local newsig=2*normprob(-abs(_b[``i'']/_se[``i'']))
		}
		else	local newsig=tprob(`df',_b[``i'']/_se[``i''])
		if `newsig'<`sig' { 
			local j `i'
			local sig `newsig'
		}
		local i=`i'+1
	}
	if `sig'<$S_10 { 
		di in gr "adding   ``j''" _col(21) "p =" in ye %6.3f `sig'
		global S_20 "$S_20 ``j''"
		local `j' " " 
		global S_21 "`*'"
		global S_30 1
	}
end
exit


/* 
Re:  _crcstep:

_crcstep can be used with any estimation command.

Arguments are as shown at the top of the program.

It is assumed that, before calling this routine:

	1)	You have run the model on all the variables and 
		_b[] contains the current coefficients

	2)	The only data in memory is the data relevant for estimation.
		Thus, adding or dropping a variable will NOT change the
		sample.

	3)	dof for t is calculated as _result(1)-_result(3) after
		executing the estimation command.

The final varlist is returned in S_1.

_crcstep understands that some of the variables may have been dropped by 
the estimation routine.  These variables are immediately dropped from
further consideration.

_crcstep calls a strategy routine which, using _crcswrm and _crcswad
removes and adds variables.

Macros are used as follows:

	S_10	Pe	Entry significance level
	S_11	Pr	Remove significance level
	S_12	lhs	lhs variable
	S_13	cmd	estimation command
	S_14	opts	estimation options
	S_15	wgt	weight

	S_20	vl	current varlist (variables in model)
	S_21	vl2	potential to-add list (variables not in model)
	S_30		modification flag

_crcswrm and _crcswad set S_30 to 1 if they move variables between vl and vl2.
*/

/*
Re:  _crcsfd

_crcsfd is the "forward stepwise" strategy routine called by _crcstep.
Upon call, it assumes that all variables are in the current varlist and 
no variables in the to-add list.

It takes two backward steps and then alternates between adding and 
stepping back.
*/
/*
Re:  _crcsbw
_crcsbw is the "backward stepwise" strategy routine called by _crcstep.
Upon call, it assumes that all variables are in the current varlist and 
no variables in the to-add list.

It takes two backward steps and then alternates between adding and 
stepping back.
*/
/*
Re:  _crcswrm:
_crcswrm is the consider-removing-a-variable _crcstep utility.

If a variable is moved from the current to the to-add list (S_20 to S_21),
S_30 is set to 1, otherwise it is 0.
*/
/*
Re:  _crcswad:
_crcswad is the consider-adding-a-variable _crcstep utility.
If a variable is moved from the to-add list to the current list (S_21 to S_20),
S_30 is set to 1, otherwise it is 0.
*/
