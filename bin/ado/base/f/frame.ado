*! version 1.0.8  13jan2020

/*
	frame[s] <subcmd> ... 

	frame[s] <name> [, new]: <any Stata command>

	frame[s] pwf

	frame[s] create <newname> [ <newvarlist> ]
	frame[s] post <name> (<expr>) (<expr>) ... (<expr>)

	frame[s] change <name>

	frame[s] copy <name> <newname> [ , replace ]
	frame[s] cp   <name> <newname> [ , replace ]

	frame[s] drop <name>

	frame[s] rename <oldname> <newname>

	frame[s] put <varlist>, into(<newname>)
	frame[s] put [<varlist>] if <exp>, into(<newname>)
	frame[s] put [<varlist>] in <range> [if <exp>], into(<newname>)

	frame[s] reset

	Note that below, -frames- is not r-class.  That is so 
	whatever is set by what is to the right of the colon 
	passes through back to the user.  Other subcommands of
        -frame- do post r-class results.
*/

program frame, byable(onecall)
	version 16

	gettoken subcmd 0 : 0

	if ("`subcmd'" == "put") {
		frame_put `"`_byvars'"' `0'
		exit
	}

	if ("`_byvars'" != "") {
		error 190
	}

	if ("`subcmd'" == "post") {
		frame_post `0'
		exit
	}

	if ("`subcmd'" == "create") {
		frame_create `0'
		exit
	}

	if ("`subcmd'" == "change") {
		frame_change `0'
		exit
	}

	if ("`subcmd'" == "cwf") {
		frame_change `0'
		exit
	}

	if ("`subcmd'" == "drop") {
		frame_drop `0'
		exit
	}

	if ("`subcmd'" == "rename") {
		frame_rename `0'
		exit
	}

	if ("`subcmd'" == "reset") {
		frame_reset `0'
		exit
	}


	if ("`subcmd'" == "copy" | "`subcmd'" == "cp") {
		frame_copy `0'
		exit
	}

	if ("`subcmd'" == "dir" | "`subcmd'" == "list") {
		frame_dir `0'
		exit
	}

	if ("`subcmd'" == "pwf") {
		frame_nothing
		exit
	}

						// frames <nothing>
	if ("`subcmd'" == "") {
		frame_nothing
		exit
	}

	di as err "subcommand {bf:`subcmd'} is unrecognized"
	exit 198
end


program frame_nothing, rclass
	local name = c(frame)
	di as txt "  (current frame is {bf:{res:`name'}})"
	return local currentframe `name'
end


program frame_post
	gettoken POSTNAME 0 : 0

	confirm frame `POSTNAME'

	local i 0
	while `"`0'"' != "" {
		gettoken expr 0 : 0, match(found) quotes
		if ("`found'"!="(") {
			di as err ///
"frame post command requires expressions be bound in parentheses"
			exit 198
		}
		local ++i
		tempname expr`i'
		scalar `expr`i'' = `expr'
	}
	frame `POSTNAME' {
		local N = c(N)
		local k = c(k)
	}
	if `k' != `i' {
		if `k' > 1 {
			local s "s"
		}
		if `k' > `i' {
			display as err ///
			"`k' expression`s' expected and only `i' found"
		}
		else {
			display as err ///
			"`k' expression`s' expected and more than `k' found"
		}
		exit 198
	}
	frame `POSTNAME' {
		local newobs = `N' + 1
		qui set obs `newobs'
		local i 0
		capture noisily foreach var of varlist _all {
			local ++i
			qui replace `var' = `expr`i'' in `newobs', nopromote
		}
		local rc = _rc
		if `rc' {
			drop in `newobs'
			exit `rc'
		}
	}
end


program frame_create
	gettoken newframe 0 : 0, parse(", ")
	confirm new frame `newframe'
	_frame create `newframe'

	if (substr(strtrim(`"`0'"'),1,1)==",") {
		capture noisily syntax [, CHange]
		local rc = _rc
		if `rc' {
			_frame drop `newframe'
			exit `rc'
		}
		if ("`change'"!="") {
			frame change `newframe'
		}
	}
	else if `"`0'"' != "" {
		capture noisily frame_create_newvars `newframe' `0'
		local rc = _rc
		if `rc' {
			_frame drop `newframe'
			exit `rc'
		}
	}
end

program frame_create_newvars
	gettoken POSTNAME 0 : 0

	frame `POSTNAME' {
		syntax newvarlist [, CHange]
		qui set obs 0

		foreach newvar of local varlist {
			gettoken type typlist : typlist
			if (substr("`type'",1,3)=="str") {
				gen `type' `newvar' = ""
			}
			else {
				gen `type' `newvar' = .
			}
		}
	}

	if ("`change'"!="") {
		frame change `POSTNAME'
	}
end

program frame_change
	confirm frame `0'

	_frame change `0'
end

program frame_drop
	confirm frame `0'

	_frame drop `0'
end

program frame_put
	gettoken byvars 0 : 0
	if (`"`byvars'"' != "") {
		local by "by `byvars' : "
	}
	syntax [varlist] [if] [in] , into(name)
	if (`"`if'"' != "" | `"`in'"' != "") {
		confirm new frame `into'
		`by' _frame put `varlist' `if' `in', frame(`into')
	}
	else {
		syntax varlist(min=1) , into(name)
		confirm new frame `into'
		`by' _frame put `varlist', frame(`into')
	}
end

program frame_rename
	args oldframe newframe
	confirm frame `oldframe'
	confirm new frame `newframe'

	_frame rename `oldframe' `newframe'
end

program frame_reset
	* get appropriate err msg if cmdline is specified
	syntax

	_frame reset
end

program frame_copy
	gettoken curname 0 : 0, parse(" ,")
	gettoken newname 0 : 0, parse(" ,")
	syntax [, replace]

	confirm frame `curname'
	if "`replace'"=="" {
		confirm new frame `newname'
	}
	else {
		capture confirm new frame `newname'
		if _rc==0 {
			di as txt "(note: frame {bf:`newname'} not found)"
		}
	}

	if "`newname'" == "`curname'" {
		di as err ///
		`"may not copy frame {bf:`curname'} to itself"'
		exit 110
	}

	nobreak {
		frame `curname' {
			if "`replace'" != "" {
				capture _frame drop `newname'
			}
			_frame create `newname'
			_frame copy `curname' `newname'
		}
	}
end

program frame_dir, rclass
	syntax [anything]

	local haschanged = 0

	qui _frame dir
	local framelist = r(contents)

	frame `=c(frame)' {
		local maxlen 1
		if (`"`anything'"') != "" {
			foreach frame of local framelist {
				foreach pat of local anything {
					if (strmatch("`frame'",`"`pat'"')) {
						local newframelist "`newframelist' `frame'"
					}
				}
			}
			if ("`newframelist'" == "") {
				di as err `"frame(s) `anything' not found"'
				exit 111
			}
			local framelist "`newframelist'"
		}
		return local frames=strtrim(`"`framelist'"')
		foreach frame of local framelist {
			if (strlen("`frame'") > `maxlen') {
				local maxlen = strlen("`frame'")
			}
			local par1 = `maxlen' + 5
			local par2 = `maxlen' + 7
			local par3 = `maxlen' + 4
			local par4 = `maxlen' + 6
		}
		foreach frame of local framelist {
			frame `frame' {
				local changed = cond(c(changed),"* ", "  ")
				local N = c(N)
				local k = c(k)
				if (`"`changed'"' == "* ") {
					local haschanged = 1
					local changedres "`changedres'1 "
				}
				else {
					local changedres "`changedres'0 "
				}
				qui describe
				local dtalbl : data label
				if (`"`dtalbl'"' == "") {
					local dtalbl = c(filename)
					if (`"`dtalbl'"' != "") {
						mata: st_local("dtalbl", pathbasename(`"`dtalbl'"'))
					}
				}
			}
			if (`"`dtalbl'"' == "") {
				local colon = " "
			}
			else {
				local dtalbl `"{txt:;} `dtalbl'"'
				local colon = " " /* sic */
			}
			if (strlen("`frame'") <= 14 | 1) {
				if (`"`changed'"' == "* ") {
display "{p2col 1 `par1' `par2' 2:{res}`changed'{txt}`frame'`colon'}" _continue
				}
				else {
display "{p2col 3 `par1' `par2' 2:{txt}`frame'`colon'}" _continue
				}
				display `"{res}`N' {txt:{it:x}} `k'`dtalbl'"'
				display "{p_end}"
			}
			else {
				display "{res}`changed'{txt}`frame'`colon'"
				display "{p `par3' `par4' 2}"
				display `"{res}`N' {txt:{it:x}} `k'`dtalbl'"'
				display "{p_end}"
			}
		}
	}

	return local changed = strtrim("`changedres'")

	if (`haschanged') {
		display
		display "{txt}Note: frames marked with {res:*} contain unsaved data"
	}
end
