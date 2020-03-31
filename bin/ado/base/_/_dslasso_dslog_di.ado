*! version 1.0.1  19may2019
program _dslasso_dslog_di
	version 16.0

	syntax [, dslog relog]

	if (`"`dslog'"' != "" & `"`relog'"' != "") {
		// do nothing
	}
	else if (`"`dslog'"' != "") {
		di
	}
end
