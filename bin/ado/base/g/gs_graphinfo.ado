*! version 1.1.1  14nov2002
program gs_graphinfo, rclass
	version 8
	args name nothing
	if "`name'"=="" {
		di as err "nothing found where graph name expected"
		exit 198
	}
	if "`nothing'"!="" {
		error 198
	}
	gs_stat exists `name'

	ret local fn `name'
	ret local ft live
	ret local command `.`name'.command'
	ret local command_date `.`name'.date'
	ret local command_time `.`name'.time'
	ret local family `.`name'.graphfamily'
	ret local dtafile `.`name'.dta_file'
	ret local dtafile_date `.`name'.dta_date'
	ret local scheme `.`name'._scheme.scheme_name'
	ret local ysize `.`name'.style.declared_ysize.val'
	ret local xsize `.`name'.style.declared_xsize.val'
end
