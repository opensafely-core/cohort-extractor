*! version 1.0.2  06nov2009
program tsline_ex
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

program arma
	Msg preserve
	preserve
	Xeq sysuse tsline1, clear
	Xeq tsset lags
	Xeq tsline ar ma
	Msg restore
end

program calories
	Msg preserve
	preserve
	Xeq sysuse tsline2, clear
	Xeq tsset day
	Xeq tsline calories, ttick(28nov2002 25dec2002 , tpos(in))	///
		ttext(							///
			3470 28nov2002 "thanks"				///
			3470 25dec2002 "x-mas"				///
			, orient(vert)					///
		)							///
		// blank
	Msg restore
end

program calories2
	Msg preserve
	preserve
	Xeq sysuse tsline2, clear
	Xeq tsset day
	Xeq tsline calories, tline(28nov2002 25dec2002)
	Msg restore
end

program calories3
	Msg preserve
	preserve
	Xeq sysuse tsline2, clear
	Xeq tsset day
	Xeq tsline calories, tlabel(, format(%tdmd)) ttitle("Date (2002)")
	Msg restore
end

program rcalories
	Msg preserve
	preserve
	Xeq sysuse tsline2, clear
	Xeq tsset day
	Xeq tsrline lcalories ucalories	///
		|| tsline calories	///
		|| if tin(1may2002,31aug2002), ytitle(Calories)
	Msg restore
end

