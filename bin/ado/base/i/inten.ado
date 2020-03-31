*! version 1.0.3  16feb2015
program define inten, rclass
	version 6
	args b x nothing

	capture confirm integer number `b'
	if _rc { 
		di in red `"inten:  "`b'" invalid base"'
		exit 198
	}
	capture confirm existence `x'
	if _rc { 
		di in red "inten:  number to be converted not specified"
		exit 198
	}
	capture confirm existence `nothing'
	if _rc==0 { 
		di in red `"inten:  "`nothing'" found where nothing expected"'
		exit 198
	}


	if `b'>62 | `b'<2 {
		di in red "inbase:  base must be between 2 and 62"
		exit 198
	}

	*local x = lower("`x'")
	local l = length("`x'") 

	tempname res p 
	scalar `res' = 0 
	scalar `p' = 1

	local i = `l'
	while `i' > 0 { 
		local dig = bsubstr("`x'",`i',1)
		if "`dig'" >= "A" {
			local dig = /*
*/ index("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ","`dig'")+ 9
		}
		scalar `res' = `res' + (`dig')*`p'
		scalar `p' = `p' * `b'
		local i = `i' - 1
	}
	return scalar ten = `res'
	di `res'
end
