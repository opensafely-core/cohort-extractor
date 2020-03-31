*! version 1.0.1  18jan2017
program define _pred_se_ic /* "unique-options" <rest> */, sclass
	version 15
	sret clear

	gettoken ouser 0 : 0 		/* user options */
	local orig `"`0'"'
	gettoken left right: 0, parse(",")

	local 0 `left'
	gettoken typ 0 : 0, parse(" ")
	syntax newvarlist(min=1 max=2) [if] [in]
	local varn `varlist'

	local 0 `right'
	syntax [, `ouser' CONStant(varname numeric) noOFFset *]

	if `"`options'"' != "" {
		_predict `orig'
		sret local done 1
		exit
	}

	tokenize `varn'
	local var1 `1'
	local var2 `2'

	if "`var2'" == "" {
		confirm new var `var1'
		sret local done 0
		sret local typ `"`typ'"'
		sret local varn `"`varn'"'
		sret local rest `"`0'"'
		sret local nvar 1
	}
	else {
		confirm new var `var1'
		confirm new var `var2'
		sret local done 0
		sret local typ `"`typ'"'	
		sret local varn `"`varn'"'
		sret local rest `"`0'"'
		sret local nvar 2
	}

end
exit
