*! version 1.0.0  15mar2004
program define _vec_opck
	version 8.2

	syntax , [ optname(string)  opts(string) ]

	if `"`opts'"' != "" {
		if `"`optname'"' != "" {
di as err `"{cmd:`optname'()} cannot be specified without {cmd:graph}"'
exit 198
		}
		else {
di as err `"{cmd:`opts'} cannot be specified without {cmd:graph}"'
exit 198
		}
	}
end
