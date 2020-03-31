*! version 1.1.1  20jan2015
program define asmprobit_mfx__dlg

	local args `0'
	gettoken cmd : 0, parse(" ,")
	gettoken cmd 0 : 0, parse(" ,")

	local l = length("`cmd'")
	if bsubstr("append",1,`l')==`"`cmd'"' {
		AppendToListControl `0'
	}
	else if bsubstr("setup",1,`l')==`"`cmd'"' {
		SetupList `0'
	}
	else if bsubstr("delete",1,`l')==`"`cmd'"' {
		DeleteItem `0'
	}
	else if bsubstr("build_atlist",1,`l')==`"`cmd'"' {
		GenerateAtCmdList `0'
	}
	else if bsubstr("build_ranklist",1,`l')==`"`cmd'"' {
		GenerateRankCmdList `0'
	}
end

program SetupList
	syntax , DIALOGname(string) CONTROL(string) [RANK]
	local dialog ".`dialogname'_dlg"
	if "`rank'" == "" {
		.__valueList = .dynamic_list_control.new, 	///
			dialog(`dialogname') control(`control')
	}
	else {
		.__rankList = .dynamic_list_control.new, 	///
			dialog(`dialogname') control(`control')
	}
end

program AppendToListControl
	syntax , DIALOGname(string) VALUE(string) [RANK]
	if "`rank'" == "" {
		.__valueList.appendItem, item(`value') unique
	}
	else {
		.__rankList.appendItem, item(`value') unique
	}
end

program DeleteItem
	syntax, DIALOGname(string) VALUE(string) [RANK]
	local dialog ".`dialogname'_dlg"
	if "`rank'" == "" {
		.__valueList.deleteItem, item(`value')
		if `.__valueList.getLength' == 0 {
			`dialog'.Execute "script main_disable_delete"
		}
	}
	else {
		.__rankList.deleteItem, item(`value')
		if `.__valueList.getLength' == 0 {
			`dialog'.Execute "script main_rank_disable_delete"
		}	
	}
end

program GenerateAtCmdList
	syntax, DIALOGname(string) BUFFER(string) 
	local dialog ".`dialogname'_dlg"
	`dialog'.`buffer'.setstring `"`.__valueList.getListContents'"'
end

program GenerateRankCmdList
	syntax, DIALOGname(string) BUFFER(string) 
	local dialog ".`dialogname'_dlg"
	`dialog'.`buffer'.setstring `"`.__rankList.getListContents'"'
end
