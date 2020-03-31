*! version 1.0.4  01nov2006
program xtline_ex
	set more off
	`0'
end

program Msg
	di as txt
	di as txt "-> " as res `"`0'"'
end

program Xeq
	di as txt
	di as txt `"-> "' as res `"`0'"'
	`0'
end

program caloriesby
	Msg preserve
	preserve
	Xeq sysuse xtline1, clear
	Xeq xtset person day
	Xeq xtline calories, tlabel(#3)
	Msg restore
end

program caloriesover
	Msg preserve
	preserve
	Xeq sysuse xtline1, clear
	Xeq xtset person day
	Xeq xtline calories, overlay
	Msg restore
end

