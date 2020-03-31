*! version 1.1.4  05dec2012
program _mixed_parseifin
	version 9
	gettoken cmdname 0 : 0
	tokenize `"`0'"'
	local n `1'
	forvalues k=1/`1' {				// allow if/in anywhere
		local 0 `"``=`k'+1''"'
		if "`cmdname'"=="xtmixed" | "`cmdname'"=="mixed" {
			syntax [anything] [pw fw] [if] [in] [, * ]
		}
		else {
			syntax [anything] [if] [in] [, * ]
		}
		if `"`if'"' != `""' {
			if `"`glob_if'"' != `""' {
				di as error "multiple if conditions not allowed"
				exit 198
			}
			local glob_if `"`if'"'
		}
		if `"`in'"' != `""' {
			if `"`glob_in'"' != `""' {
				di as error "multiple in ranges not allowed"
				exit 198
			}
			local glob_in `"`in'"'
		}
		if `"`weight'"' != `""' {
			if `"`glob_wt'"' != `""' {
				di as error "multiple observation weights " _c
				di as error "not allowed"
				exit 198
			}
			local glob_wt `"[`weight'`exp']"'
		}
	}
	c_local glob_if `"`glob_if'"'
	c_local glob_in `"`glob_in'"'
	c_local glob_wt `"`glob_wt'"'
end

exit
