*! version 1.0.3  16feb2015
program define frac_ddp, rclass
	version 6
	* 1=input number, 2=decimal places required.
	* Output in (string) r(ddp).
	* `1' and `2' allowed to be scalars.
	local n=`1'
	local dp=int(`2')
	if `dp'<0 | `dp'>20 {
		ret local ddp `n'
		exit
	}
	local z=int(abs(`n')*(10^`dp')+.5)
	if `z'>1e15 { /* can't cope with number this large --
			E notation messes it up */
		ret local ddp `n'
		exit
	}
	local lz=length("`z'")
	if `lz'<`dp' {
		local z=bsubstr("00000000000000000000",1,`dp'-`lz')+"`z'"
	}
	if `dp'>0 { 
		local f=length("`z'")-`dp'
		ret local ddp=bsubstr("`z'",1,`f')+"."+bsubstr("`z'",`f'+1,`dp')
					/* add leading zero */
		if abs(`n')<1 { ret local ddp 0`return(ddp)' }	
	}
	else 	ret local ddp `z'
	if `n'<0 { ret local ddp -`return(ddp)' }

	* failsafe check
	cap confirm num `return(ddp)'
	if _rc { ret local ddp `n' }

end
