*! version 1.0.1  17feb2015

/*
	_nostrl {<macname>|error} : <varlist> 

	    Verifies that <varlist> does not contain a strL variable. 
	    <varlist> may be empty. 

	    Returns:
		If error specified, 
			nothing		<varlist> does not contain strL
			does not return	<varlist> does     contain strL

		Otherwise
			<macname>=0	<varlist> does not contain strL
			<macname>=1	<varlist> does     contain strL
*/


program _nostrl /* {<macname>|error} : <varlist> */
	version 13.0

	gettoken name  0 : 0
	gettoken colon 0 : 0

	if (`"`colon'"' != ":") {
		error 198
	}

	syntax [varlist(default=none)]

	foreach varname of local varlist {
		if ("`:type `varname''"=="strL") {
			errormessage `varname'
			/*NOTREACHED*/
		}
	}

	if ("`name'"!="error") {
		c_local `name' 0
	}
end

program errormessage
	args	varname

	di as err as smcl "strL variables not allowed"
	di as err as smcl "{p 4 4 2}"
	di as err as smcl "{bf:`varname'} is a strL variable and strL"
	di as err as smcl "variables are not allowed in this context."
	di as err as smcl "If the first 2,045 bytes of {bf:`varname'}"
	di as err as smcl "would be sufficient, one solution would be"
	di as err as smcl 
	di as err as smcl _skip(8) ///
		"{bf:. generate str newvar = substr(`varname', 1, 2045)}"
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

