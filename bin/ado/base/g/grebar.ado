*! version 2.0.2  07/23/91 updated 09sep2002
program define grebar
	version 3.0
	mac def _varlist "req ex min(4) max(4)"
	mac def _if "opt"
	mac def _in "opt"
	mac def _options "*"
	parse "%_*"
	parse "%_varlist", parse(" ")
	tempvar bot top
	quietly {
		gen %_bot = %_1 - %_3
		gen %_top = %_1 + %_3
	}
	gr7 %_1 %_bot %_top %_4, c(.II) s(Oii) %_options
end
