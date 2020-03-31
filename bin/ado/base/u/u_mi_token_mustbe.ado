*! version 1.0.0  10mar2009

/*
	u_mi_token_mustbe "<is>" "<shouldbe>"

	issues error message 
		<shouldbe> found where nothing expected
	if <is> != <shouldbe>
*/
		

program u_mi_token_mustbe
	version 11
	args is should

	if (`"`is'"'==`"`should'"') { 
		exit
	}
	if (`"`is'"'=="") {
		di as err "nothing found where `should' expected"
		exit 198
	}
	if (`"`should'"'=="") { 
		di as err "`is' found where nothing expected"
		exit 198
	}
	di as err "`is' found where `should' expected"
	exit 198
end
