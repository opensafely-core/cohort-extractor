*! version 1.0.0  25feb2005
program define _prefix_vcenotallowed
	version 9
	args vcetype optname optval
	if `"`vcetype'"' != "" & `"`optval'"' != "" {
		opts_exclusive "vce(`vcetype') `optname'"
	}
end
