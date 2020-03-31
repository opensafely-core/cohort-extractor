*! version 1.0.3  05apr2006
program define _dm_create

	version 9.1 

	syntax  , dname(name)		///
		mname(name)		///
		[ 			///
		dsename(name)		///
		msename(name)		///
		STep(integer 8) 	///
		noCONStant		///
		]

	tempname exlagsm

	local m      : word count `e(exogvars)'

	mat `exlagsm' = e(exlagsm)

	if "`constant'" == "" {
		local hascons 1
	}
	else {
		local hascons 0
	}

					// minus 1 because 0 in first column
	local exmlag  = colsof(`exlagsm') - 1

	if (`m' < 1 )  {
		di as err "_dm_create requires exogenous variables"
		exit 498
	}	

	mata: _dm_create_work(`e(neqs)', `e(mlag)', `m', `exmlag', 	///
		"`dname'", "`dsename'", "`mname'", "`msename'", 	///
		`step', `hascons' )
	

end

