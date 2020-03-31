*! version 1.0.1  24feb2013

program fc_problem_must_exist
	
	version 13
	
	args subcmd

	mata: forecast_started("begun")
	if (`begun') {
		exit
	}
	di as err "forecast problem not found"
	di as err "{p 4 4 2}"
	di as err "Before you can issue {bf:forecast `subcmd'}"
	di as err "you must begin the forecast problem by"
	di as err "issuing {bf:forecast create}."
	di as err "{p_end}"
	exit 111

end
