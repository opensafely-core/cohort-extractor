*! version 1.1.0  09feb2015
program _tvc_notallowed
	version 10
	args optname optval
	if `:length local optval' {
		if "`optname'" == "svy" {
			di as err "{p 0 0 2}" ///
`"option {bf:tvc()} not allowed with the {bf:svy} prefix;{break}"'
		}
		else if "`optname'" == "scores" {
			di as err "{p 0 0 2}" ///
`"predicting scores is not allowed after estimation with {bf:tvc()};{break}"'
		}
		else if "`optname'" == "predict" {
			di as err "{p 0 0 2}" ///
`"this prediction is not allowed after estimation with {bf:tvc()};{break}"'
		}
		else if "`optname'" == "command" {
			di as err "{p 0 0 2}" ///
`"this post-estimation command is not allowed after estimation with {bf:tvc()};{break}"'
		}
		else {
			di as err "{p 0 0 2}" ///
`"option {bf:`optname'} may not be combined with option {bf:tvc()};{break}"'
		}
		di as err ///
`"see {help tvc note} for an alternative to the {bf:tvc()} option"'
		di as err "{p_end}"
		exit 198
	}
end
exit
