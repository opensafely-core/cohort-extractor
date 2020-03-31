*! version 1.1.0  10apr2019
program _prefix_note
	version 9
	syntax name(name=cmdname id="command name") [, noDOTS ]

	if ("`dots'" != "") exit

	di as txt "(running {bf:`cmdname'} on estimation sample)"
end
exit
