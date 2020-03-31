*! version 1.1.3  13feb2015 
program _get_offopt, sclass
	version 9

	sreturn clear
	syntax [anything(name=offset id="offset option")] [, NOCONFIRM]

	if (`"`offset'"' == "") exit

	local len0 = length(trim(`"`offset'"'))
	if bsubstr("`offset'",1,3) == "ln(" {
		local offopt = bsubstr("`offset'",4,`=`len0'-4')
		if !`:length local noconfirm' {
			capture confirm name `offopt'
			if c(rc) {
				exit
			}
			confirm numeric variable `offopt'
		}
		sreturn local offopt exposure(`offopt')
		sreturn local offvar `offopt'
	}
	else {
		if !`:length local noconfirm' {
			capture confirm name `offset'
			if c(rc) {
				exit
			}
			confirm numeric variable `offset'
		}
		sreturn local offopt offset(`offset')
		sreturn local offvar `offset'
	}
end
exit
