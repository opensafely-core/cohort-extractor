*! version 1.0.0  06mar2009

/*
	u_mi_time_diff <lmac> : <recent_time> <earlier_time>

	Returns in local <lmac> "5 seconds ago", "approximately 10 hours ago", 
	etc.

	<recent_time> and <earlier_time> are as given by -u_mi_curtime-.
*/

program u_mi_time_diff, rclass
	version 11

	args toret colon  now before
	local d = (`now' - `before')
	return scalar secs = `d'
	if (`d'<60) { 
		local seconds = cond(`d'==1, "second", "seconds")
		c_local `toret' "`d' `seconds' ago"
		exit
	}

	local d = int(`d'/60)
	if (`d'<60) { 
		local minutes = cond(`d'==1, "minute", "minutes")
		c_local `toret' "approximately `d' `minutes' ago"
		exit
	}

	local d = int(`d'/60)
	if (`d'<60) { 
		local hours = cond(`d'==1, "hours", "hours")
		c_local `toret' "approximately `d' `hours' ago"
		exit
	}

	local d = int(`d'/60)
	local days = cond(`d'==1, "day", "days")
	c_local `toret' "`d' `days' ago"
end
