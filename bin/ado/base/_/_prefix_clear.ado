*! version 1.0.0  13jul2004
program _prefix_clear
	version 8.2
	syntax [, Eclass Rclass ]

	if "`eclass'" != "" {
		ClearE
	}
	if "`rclass'" != "" {
		ClearR
	}
end

program ClearE, eclass
	ereturn clear
end

program ClearR, rclass
	return clear
end

exit
