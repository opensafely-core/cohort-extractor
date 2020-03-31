*! version 1.0.4  07mar2005
program define _vec_pgridplots, sclass
	version 8.2

	syntax [ , GRAph * ]
	local 0  `", `options' "'

	if "`graph'" == "" {
		syntax [, PGrid(string) noGRId * ]
		_vec_opck , optname(pgrid) opts(`pgrid')
		_vec_opck , opts(`grid')
	}
	else {
		local pgridplots
		local pg_ck 1
		local first 1
		while `pg_ck' == 1 {
			syntax [, PGrid(string) noGRId * ]
			local 0  `", `options' "'

			if `"`pgrid'"' != "" & "`grid'" != "" {
				di as err "{cmd:pgrid()} cannot be "	///
					"specified with {cmd:nogrid}"
				exit 198
			}
		
			if `"`pgrid'"' == "" & `first' == 1 & "`grid'" == "" {
				local pgrid " .1(.1).9 "
			}
		
			local first 0

			if `"`pgrid'"' == "" {
				local pg_ck 0
				if "`grid'" != "" {
local grid "xlabel( , nogrid) ylabel( , nogrid ) "
				}
				local options `" `grid' `options' "'
			}
			else {
				capture noi _vec_pgparse `pgrid'
				if _rc > 0 {
					di as err "{cmd:pgrid(`pgrid')} invalid"
					exit _rc
				}
				local pnumlist  "`s(numlist)'"
				local popts  `"`s(popts)'"'
				foreach rad of local pnumlist {
local rad2 = `rad'^2
local val1 = -1*`rad'			
local val2 = `rad'			
local func1 " `rad2'-x*x "
local func2 " sqrt(`func1') "
local func3 "cond(`func1'>0, `func2', `func1') "
local func4 "cond(`func1'>0, -1*`func2', `func1') "
local bopts " range(`val1' `val2')  lstyle(grid)"
local uplot `" (function y = `func3' , `bopts' `popts' ) "'
local lplot `" (function y = `func4' , `bopts' `popts' ) "'
local pgridplots `"`pgridplots' `uplot' `lplot' "' 
				}	
			
				local gopts `" xlabel(-1(.5)1, nogrid)  "'
				local gopts `" `gopts' ylabel(-1(.5)1, nogrid) "'
				local gopts `" `gopts' xtick(0, grid) ytick(0, grid) "' 

				local options `" `gopts' `options' "'

			}
		}
	}

	sreturn clear
	sreturn local options     `"`options'"'
	sreturn local pgridplots  `"`pgridplots'"'

end

