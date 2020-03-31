*! version 1.0.0  23mar2011
/* 
   saves all variables from 'ivarlist' which are used in the 
   -if- expression 'ifexp' to macro 'vars'
*/
program u_mi_impute_check_condexp
	version 12
	args vars colon ifexp ivarlist

	if (`"`ifexp'"'=="") exit
	local ifexp = trim(`"`ifexp'"')

	tempname rs tmpvar
	cap noi scalar `rs' = (`ifexp')
	if _rc {
		di as err ///
		   `" -- above applies to option {bf:conditional(if `ifexp')}"'
		exit _rc
	}
	gettoken ivar ivarlist : ivarlist
	qui while ("`ivar'"!="") {
		rename `ivar' `tmpvar'
		cap scalar `rs' = (`ifexp')
		if _rc {
			local vlist `vlist' `ivar'
		}
		rename `tmpvar' `ivar'
		gettoken ivar ivarlist : ivarlist
	}
	c_local `vars' `vlist'
end
