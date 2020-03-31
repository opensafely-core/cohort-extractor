*! version 1.0.1  13feb2015

/*
	_nobinary {<macname>|error} : <varlist> <if> <in>

	    Verifies that <varlist> does not contain a BINARY strL variable. 
	    <varlist> may be empty. 

	    Returns:
		If error specified, 
			nothing		<varlist> does not contain BINARY strL
			does not return	<varlist> does     contain BINARY strL

		Otherwise
			<macname>=0	<varlist> does not contain BINARY strL
			<macname>=1	<varlist> does     contain BINARY strL
*/


program _nobinary /* {<macname>|error} : <varlist> <if> <in> */
	version 13.0

	gettoken name  0 : 0
	gettoken colon 0 : 0

	if (`"`colon'"' != ":") {
		error 198
	}

	syntax [varlist(default=none)] [if] [in]

	foreach varname of local varlist {
		if ("`:type `varname''"=="strL") {
			capture assert !strpos(`varname', char(0)) `if' `in'
			if (_rc) {
				if (_rc==1) {
					exit 1
				}
				if ("`name'"!="error") {
					c_local `name' 1
					exit 0
				}
				errormessage `varname'
				/*NOTREACHED*/
			}
		}
	}

	if ("`name'"!="error") {
		c_local `name' 0
	}
end

program errormessage
	args	varname

	di as err as smcl "binary strL variables not allowed"
	di as err as smcl "{p 4 4 2}"
	di as err as smcl "strL variable {bf:`varname'} contains char(0)."
	di as err as smcl "If the text after the char(0) is irrelevant,"
	di as err as smcl "one solution would be"
	di as err as smcl 
	di as err as smcl _skip(8) ///
		"{bf:. generate long    pos = strpos(`varname', char(0))}"
	di as err as smcl _skip(8) ///
		"{bf:. generate str  newvar = `varname' if pos==0}"
	di as err as smcl _skip(8) ///
	"{bf:. replace       newvar = bsubstr(`varname', 1, pos-1) if pos}"
	di as err as smcl _skip(8) "{bf:. drop pos}"
	di as err
	di as err as smcl "{p 4 4 2}"
	di as err as smcl "The generic solution is
	di as err
	di as err as smcl _skip(8) ///
		"{bf:. egen newvar = group(`varname')}"
	di as err 
	di as err as smcl "{p 4 4 2}"
	di as err as smcl "Either way, you would then reissue the command using {bf:newvar}"
	di as err as smcl "in place of {bf:`varname'}."
	di as err as smcl "{p_end}"
	exit 109
end

