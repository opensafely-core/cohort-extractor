*! version 3.0.3  24sep2004
program define _pred_se /* "unique-options" <rest> */, sclass
	version 6.0, missing
	sret clear
	gettoken ouser 0 : 0 		/* user options */
	local orig `"`0'"'
	gettoken varn 0 : 0, parse(" ,[")
	gettoken nxt : 0, parse(" ,[(")
	if !(`"`nxt'"'=="" | `"`nxt'"'=="if" | `"`nxt'"'=="in" /*
		*/ | `"`nxt'"'==",") {
		local typ `varn'
		gettoken varn 0 : 0, parse(" ,[")
	}
	syntax [if] [in] [, `ouser' CONStant(varname numeric) noOFFset *]
	if `"`options'"' != "" {
		_predict `orig'
		sret local done 1
		exit
	}
	confirm new var `varn'
	sret local done 0
	sret local typ `"`typ'"'
	sret local varn `"`varn'"'
	sret local rest `"`0'"'
end
exit
