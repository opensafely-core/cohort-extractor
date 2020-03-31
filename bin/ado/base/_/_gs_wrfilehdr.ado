*! version 1.0.2  02jan2004
program _gs_wrfilehdr , rclass
	args filehndl name

	file write `filehndl'	///
	     "StataFileTM:00001:01000:LiveGPH:                       :" _n

					// graph file and graph class versions
	local gversion   = string(0`.`name'.gversion'   , "%05.0f")
	local clsversion = string(0`.`name'.clsversion' , "%05.0f")

	file write `filehndl' "`gversion':`clsversion':" _n		

							// graph header comments
	file write `filehndl' `"*! classname: `.`name'.classname'"' _n
	file write `filehndl' `"*! family: `.`name'.graphfamily'"' _n
	file write `filehndl' `"*! command: `.`name'.command'"' _n
	file write `filehndl' `"*! command_date: `.`name'.date'"' _n
	file write `filehndl' `"*! command_time: `.`name'.time'"' _n
	file write `filehndl' `"*! datafile: `.`name'.dta_file'"' _n
	file write `filehndl' `"*! datafile_date: `.`name'.dta_date'"' _n
	file write `filehndl' `"*! scheme: `.`name'._scheme.scheme_name'"' _n
	file write `filehndl'						///
	     `"*! naturallywhite: `.`name'._scheme.system.naturally_white'"' _n
	file write `filehndl'						///
	     `"*! xsize: `.`name'.style.declared_xsize.val'"' _n
	file write `filehndl'						///
	     `"*! ysize: `.`name'.style.declared_ysize.val'"' _n
	file write `filehndl' `"*! end"' _n
end
