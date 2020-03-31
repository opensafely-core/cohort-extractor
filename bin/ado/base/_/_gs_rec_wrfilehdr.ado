*! version 1.0.0  09jan2008
program _gs_rec_wrfilehdr , rclass
	args filehndl grname

	file write `filehndl'	///
	     "StataFileTM:00001:01100:GREC:                          :" _n

					// graph file and graph class versions
	local gversion    = string(0`.`grname'.gversion'   , "%05.0f")
	local clsversion  = string(0`.`grname'.clsversion' , "%05.0f")
	local grecversion = string(1                       , "%05.0f")

	file write `filehndl' "`gversion':`clsversion':`grecversion':" _n

						// recorder header comments
	file write `filehndl' `"*! classname: `.`grname'.classname'"' _n
	file write `filehndl' `"*! family: `.`grname'.graphfamily'"' _n
	file write `filehndl' `"*! date: `c(current_date)'"' _n
	file write `filehndl' `"*! time: `c(current_time)'"' _n
	file write `filehndl' 						///
	    `"*! graph_scheme: `.`grname'._scheme.scheme_name'"' _n
	file write `filehndl'						///
	    `"*! naturallywhite: `.`grname'._scheme.system.naturally_white'"' _n
	file write `filehndl' `"*! end"' _n
end
