*! version 1.0.2  01mar2005
program define _vec_ckgraph, sclass
	version 8.2

	syntax [, Dlabel MODlabel GRAph * ]

	_get_gropts , graphopts(`options')	///
			getallowed(RLOPts plot addplot)
	local options `"`s(graphopts)'"'
	local rlopts `"`s(rlopts)'"'
	local plot `"`s(plot)'"'
	local addplot `"`s(addplot)'"'
	_check4gropts rlopts, opt(`rlopts')


	if "`graph'" == "" {
		_vec_opck , optname(rlopts) opts(`rlopts')
		_vec_opck , optname(ptopts) opts(`ptopts')
		_vec_opck , opts(`dlabel') 
		_vec_opck , opts(`modlabel') 
		_vec_opck , opts(`options')
	}

	if "`dlabel'" != "" & "`modlabel'" != "" {
di as err "{cmd:dlabel} cannot be specified with {cmd:modlabel}"
exit 198
	}

	sreturn clear
	sreturn local options `"`options'"'
	sreturn local rlopts `"`rlopts'"'
	sreturn local plot `"`plot'"'
	sreturn local addplot `"`addplot'"'

end
