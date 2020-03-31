*! version 1.1.2  14nov2002
program gr_describe, rclass
	version 8

	gettoken name    0 : 0, parse(" ,") qed(quoted)
	if (`"`name'"' == "") gr_current name : `name' , query
	syntax

	nametype type : "`name'" `quoted'
	if ("`type'"=="file") gs_fileinfo  "`name'", suffix
	else 		      gs_graphinfo "`name'"

	return add
	ret local cversion 
	ret local fversion 

	basename bname : "`return(fn)'"

	di as txt _n "{title:`bname' stored " ///
			cond("`type'"=="file", "on disk", "in memory") ///
			"}"

	di _n "{p 8 15}"
	di "name:"
	di as res `"`return(fn)'"'
	di "{p_end}"

	di as txt "{p 6 15}"
	di "format:"
	di as res "`return(ft)'"
	di "{p_end}"

	if ("`return(ft)'"!="live") exit

	di as txt "{p 5 15}"
	di "created:"
	di as res "`return(command_date)' `return(command_time)'"
	di "{p_end}"

	di as txt "{p 6 15}
	di "scheme:"
	if ("`return(scheme)'"=="") 	di as txt "{it:unknown}"
	else 				di as res "`return(scheme)'"
	di "{p_end}"

	di as txt "{p 8 15}"
	di "size:"
	if "`return(ysize)'"=="" | "`return(xsize)'"=="" {
		di as txt "{it:unknown}"
	}
	else di as res "`return(ysize)' {txt:{it:x}} `return(xsize)'"
	di "{p_end}"

	di as txt "{p 4 15}"
	di "dta file:"
	if "`return(dtafile)'" != "" {
		di as res `"`return(dtafile)'"'
		if "`return(dtafile_date)'" != "" {
			di as txt "dated"
			di as res "`return(dtafile_date)'"
		}
	}
	else	di as txt "(none)"
	di "{p_end}"

	di as txt "{p 5 15}"
	di "command:"
	di as res `"`return(command)'"'
	di "{p_end}"
end


program nametype
	args type colon name quoted

	sret clear

	if (`quoted') c_local `type' "file"
	else {
		basename l : "`name'"
		c_local `type' = cond(index("`l'","."), "file", "graph")
	}
end

program basename
	args lhs colon name
	local x : subinstr local name " " "*", all
	local x : subinstr local x    "/" " ", all
	local x : subinstr local x    "\" " ", all
	local n : word count `x'
	local res : word `n' of `x'
	c_local `lhs' : subinstr local res "*" " ", all
end
