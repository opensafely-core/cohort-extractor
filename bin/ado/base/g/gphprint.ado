*! version 1.0.8  16feb2015
program define gphprint 
	version 7.0
	syntax [, SAVing(string) COpies(string) noLogo STATAFonts /*
		*/ SHAding(string) thickness(string) Resize( integer 100 )/*
		*/ rx(integer 100) ry(integer 100) Symbols( integer 100) /*
		*/ SO(string) SS(integer 100) ST(integer 100) /*
		*/ SD(integer 100) SP(integer 100) leftmargin(integer 100) /*
		*/ SLCo(integer 100) SUCo(integer 100) topmargin(integer 100) ]

	if "`logo'" != "" {
		local logo "logo(off)"
	}
	else {
		local logo "logo(on)"
	}

	if `topmargin' < 0 | `topmargin' > 1100 {
		di as error "topmargin must be between 10 and 1100 "
		exit 198
	}
	local topmargin = `topmargin'/100
	if `leftmargin' < 0 | `leftmargin' > 1100 {
		di as error "leftmargin must be between 10 and 1100 "
		exit 198
	}
	local leftmargin = `leftmargin'/100

	if `sp' < 10 | `sp' > 500 {
		di as error "sp must be between 10 and 500 "
		exit 198
	}

	if `sd' < 10 | `sd' > 500 {
		di as error "sd must be between 10 and 500 "
		exit 198
	}

	if `st' < 10 | `st' > 500 {
		di as error "st must be between 10 and 500 "
		exit 198
	}

	if `ss' < 10 | `ss' > 500 {
		di as error "ss must be between 10 and 500 "
		exit 198
	}

	if `symbols' < 10 | `symbols' > 500 {
		di as error "symbols must be between 10 and 500 "
		exit 198
	}

	if `slco' < 10 | `slco' > 500 {
		di as error "slco must be between 10 and 500 "
		exit 198
	}

	if `suco' < 10 | `suco' > 500 {
		di as error "suco must be between 10 and 500 "
		exit 198
	}

	if "`so'" != "" {
		di as error "so option invalid"
		di as error "use option slco(integer) for so"
		di as error "use option suco(integer) for sO"
		exit 198
	}

	if `resize' < 10 | `resize' > 500 {
		di as error "resize must be between 10 and 500 "
		exit 198
	}

	if `rx' < 10 | `rx' > 500 {
		di as error "rx must be between 10 and 500 "
		exit 198
	}

	if `ry' < 10 | `ry' > 500 {
		di as error "ry must be between 10 and 500 "
		exit 198
	}


	local thickness : subinstr local thickness " " " ", all count( local n)
	if  `n' > 0 {
		di as error "no spaces allowed in thickness"
		exit 198
	}	
	
	if length("`thickness'") > 9 {
		di as error "only 9 thicknesses allowed"
		exit 198
	}

	local pn = 1
	while "`thickness'" != "" {
		local char1 = bsubstr("`thickness'",1,1)
		local thickness = bsubstr("`thickness'",2,.)
		
		local thick "`thick' pen`pn'_thick(`char1')"
		local pn = `pn' + 1
	}

	if "`statafonts'" != "" {
		di as txt "statafonts not currently implemented"
		di as txt "option ignored"
	}		
	
	if "`shading'" != "" {
		di as error "shading(#) not currently supported"
		exit 198
	}	

	if "`copies'" != "" {
		di as error "copies(#) not supported"
		exit 198
	}	

	if "`saving'" != "" {
		local saving : subinstr local saving "+" "+", all count(local n)
		if `n' > 0 {
			di as error "+ not allowed in file names "
			exit 198 
		}	
		local saving : subinstr local saving "," "+", all count(local n)
		if  `n'>1 {
			error 198
		}	
		if `n' == 0 {
			local fname "`saving'"
		}
		else /* n ==1*/ {
			tokenize `saving' , parse("+")
			local fname "`1'"
			local replace "`3'"

				/* clear out spaces and check replace option */

			tokenize `replace'
			if "`1'" == "replace" {
				local replace "replace"
			}
			else {
				di as error "`2' invalid"
				exit 198
			}	
			
			
		}

		/* parse filename */

		local saving : subinstr local saving "." ".", all count(local n)
		if `n' > 1 {
			di as error "only one period allowed in filename"
			exit 198
		}
		if `n' == 1  {
			tokenize `fname' , p(".")
			local fname "`1'"
			local type "`3'"


			tokenize `type'
			local type "`1'"
			local ext "`1'"
		
							/* All extensions that 
							   are NOT wmf get 
							   mapped to 
							   default printer
							   prn */
		}				
		else {			/* only fname specified but check it 
					    and use default type */
			
					/* set default type */
			local type "prn"		
			local ext "prn"		
			
		}

		if "`type'" != "wmf"  & "`type'" == "pct" /* 
			*/ & "`type'" == "pict" {
				local type "prn"
			local lmarg "lmargin(`leftmargin')"
			local tmarg "tmargin(`topmargin')"
		}	
		else {
			local lmarg ""
			local tmarg ""
			local logo ""
		}	

		local fullname `"`fname'.`ext'"'
		translate @Graph "`fullname'", /*
			*/ translator(Graph2`type') `replace' `logo'/*
			*/ `thick' mag(`resize') xmag(`rx') ymag(`ry')/*
			*/ symmag_all(`symbols') symmag_O(`suco') /*
			*/ symmag_S(`ss') symmag_T(`st') /*
			*/ symmag_d(`sd') symmag_p(`sp') /*
			*/ symmag_o(`slco') /*
			*/ `lmarg' `tmarg'
		exit	
	}	

	print @Graph, /* roc says invalid translator(Graph2prn) */ /*
			*/ `logo' `thick'/*
			*/ mag(`resize') xmag(`rx') ymag(`ry')/*
			*/ symmag_all(`symbols') symmag_O(`suco') /*
			*/ symmag_S(`ss') symmag_T(`st') /*
			*/ symmag_d(`sd') symmag_p(`sp') /* 
			*/ symmag_o(`slco') /*
			*/ `lmarg' `tmarg'
end	
exit
