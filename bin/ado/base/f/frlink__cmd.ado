*! version 1.0.0  16apr2019

/*
    frlink__cmd macname : <varname> debug|nodebug [subfname2]

	Return in <macname> the -frlink {1:1|m:1} ...- command
	for creating <varname>.

	Caller has already verified that <varname> is frlink 
	variable using -frlink__var-. 

	Arguments:

	    If -debug-, 
		include -debug()- option in returned result.

            If <subfname2>=="", 
		returned command is to be the shortest command the user 
		could have typed that would create (or recreate) variable 
		<varname>.

            If <subfname2>!="", returned command is the shortest command
                the user could have typed if he/she wanted to link to
                <subfname2> instead of <fname2>.  
*/

program frlink__cmd
	version 16

	args macname colon varname incldebug subfname2

	/* ------------------------------------------------------------ */
					// set up to construct command

	/*
		<cmd> := frlink <mtyp> <vl1>, <options>

	    <options> :=   frame(<fname2> <vl2>)
			 [ generate(<gen>) ]    <- iff <fname2>!=<gen>
			 [ debug(<dbug>)   ]    <- iff -debug-
	*/

	local gen      `varname'			
	local mtyp    ``gen'[frlink_mtyp]'
	local vl1     ``gen'[frlink_vl1]'

	// -- fname2 ---------------------------------
	if ("`subfname2'" !="") {
		local fname2 `subfname2'
	}
	else {
		local fname2 ``gen'[frlink_fname2]'
	}
	// -------------------------------------------

	local vl2    ``gen'[frlink_vl2]'
	local dbug   ``gen'[frlink_debug]'

	/* ------------------------------------------------------------ */
					// create <options>

	if ("`vl2'"!="") {
		local options frame(`fname2' `vl2')
	}
	else {
		local options frame(`fname2')
	}

	if ("`fname2'"!="`gen'") {
		local options `options' generate(`gen')
	}

	if ("`incldebug'"=="debug" & "`dbug'"!="") {
		local options `options' debug(`dbug')
	}

	/* ------------------------------------------------------------ */
					// create <cmd>

	local cmd frlink `mtyp' `vl1', `options'

	
	/* ------------------------------------------------------------ */
					// return <cmd>

	c_local `macname' `cmd'
end
