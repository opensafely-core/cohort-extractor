*! version 1.0.1  29jan2015
program _exp_list_parse, sclass
	version 9
	syntax [anything(name=exp_list id="exp_list" equalok)],	///
		stub(name) [ GEQname(name) ]

	if "`geqname'" == "" {
		local geqname _eq
	}
	local i  0		// counter for each <exp>
	local ii 0		// counter for each <eexp>
	local j	 0		// within group id for <exp>
	local gj 0		// id for global <exp>
	local e  0		// counter for each (<eq>:)
	local ge 0		// indicator for global <exp>

	while `"`exp_list'"' != "" {
		// Look for <eexp>:
		// create locals from input:
		// 	eexp_b xor eexp_se
		//	eexp
		//	rest
		Check4EExp `exp_list'
		if `"`eexp'"' != "" {
			if `:list eexp in ueexplist' {
				di as err `"eexp `eexp' already specified"'
				exit 110
			}
			else	local ueexplist `"`ueexplist' `eexp'"'
		}
		local prob 0
		if `"`eexp_b'"' != "" {
			local ++ii
			if "`eexp_b'" == "_b" {
				if "`b_list'" != "" {
					local prob 1
				}
				else	local b_list (_b)
			}
			else {
				if "`b_list'" == "(_b)" {
					local prob 1
					local b_list `eexp_b'
				}
				else	local b_list `b_list' (`eexp_b')
			}
			if `prob' == 1 {
				di as err "eexp _b specified multiple times"
				exit 110
			}
			local exp_list `"`rest'"'
			continue
		}
		else if `"`eexp_se'"' != "" {
			local ++ii
			if "`eexp_se'" == "_se" {
				if "`se_list'" != "" {
					local prob 1
				}
				else	local se_list (_se)
			}
			else {
				if "`se_list'" == "(_se)" {
					local prob 1
					local se_list `eexp_se'
				}
				else	local se_list `se_list' (`eexp_se')
			}
			if `prob' == 1 {
				di as err "eexp _se specified multiple times"
				exit 110
			}
			local exp_list `"`rest'"'
			continue
		}
		gettoken tok : exp_list, parse(" =()") bind match(par)
		if "`par'" != "" {
			// Parse: (<eq>: <elist>)
			// create locals from input:
			//	eq
			//	elist
			//	exp_list
			NameColonElist `exp_list'
			if `"`elist'"' == "" {
				di as err	///
				"nothing found where expression expected"
				exit 7
			}
			if "`eq'" == "`geqname'" {
				di as err "name `eq' is reserved"
				exit 198
			}
			if "`eq'" == "" {
				// global expression found
				local eq `geqname'
			}
			else {
				if `: list eq in eqlist' {
					di as err ///
					"name `eq' already specified"
					exit 110
				}
				local ++e
				local j 0
				local eqidlist
			}
		}
		else {
			// Parse global <elist> element
			// create locals from input:
			// 	elist
			//	rest
			GetElist `exp_list'
			local exp_list `"`rest'"'
			// global expression found
			local eq `geqname'
		}

		// Parse:	<elist> := [<name> =] (<exp>)
		local rest `"`elist'"'
		while `"`rest'"' != "" {
			// create locals from input:
			// 	elist
			//	rest
			GetElist `rest'
			// create locals from input:
			// 	id
			//	exp
			ParseElist `elist'
			// create locals from input:
			//	exp
			CheckExp `exp'

			local ++i
			if "`eq'" == "`geqname'" {
				// new global expression
				local ++gj
				local ge 1
				if "`id'" == "" {
					local id `stub'`gj'
				}
				if `:list id in geqidlist' {
					di as err ///
					"name `id' already specified"
					exit 110
				}
				local geqidlist `geqidlist' `id'
				local gidlist `gidlist' `id'
				local geqlist `geqlist' `eq'
				local gexplist `"`gexplist' `:list retok exp'"'
			}
			else {
				// new local expression
				local ++j
				if "`id'" == "" {
					local id `stub'`j'
				}
				if `:list id in eqidlist' {
					di as err ///
					"name `id' already specified in `eq'"
					exit 110
				}
				local eqidlist `eqidlist' `id'
				local idlist `idlist' `id'
				local eqlist `eqlist' `eq'
				local explist `"`explist' `:list retok exp'"'
			}
		}
		if "`eq'" != "`geqname'" {
			local curreq `eq'
		}
	}
	local ngexp : word count `geqidlist'

	sreturn clear
	sreturn local n_exp `i'
	if `e' >= 1 | `ii' > 0 {
		if `e' >= 1 {
			local geqlist : subinstr local geqlist	///
				"`geqname'" "`geqname'`++e'",	///
				all word
		}
		sreturn local eqlist `eqlist' `geqlist'
	}
	sreturn local idlist `idlist' `gidlist'
	local explist `"`:list retok explist' `:list retok gexplist'"'
	sreturn local explist `"`:list retok explist'"'
	sreturn local n_eexp `ii'
	local eexplist `"`:list retok b_list' `:list retok se_list'"'
	sreturn local eexplist `"`:list retok eexplist'"'
end

// Parse: (<eq>: <elist>)
// create locals from input:
// 	eq
// 	elist
// 	exp_list
program NameColonElist
	gettoken tok 0 : 0, parse("()") bind match(par)
	capture _on_colon_parse `tok'
	if !c(rc) {
		local eq `s(before)'
		if `:word count `eq'' != 1 {
			di as err ///
			"'`eq'' found where a single name is required"
			exit 7
		}
		confirm name `eq'
		local elist `"`s(after)'"'
		// only change callers `eq' if a new one is supplied
		c_local eq `eq'
	}
	else {
		c_local eq
		local elist `"(`tok')"'
	}

	c_local elist `"`:list retok elist'"'
	c_local exp_list `"`:list retok 0'"'
end

// Get: <elist> := [<name> =] (<exp>)
// create locals from input:
// 	elist
// 	rest
program GetElist
	Check4Special 0 `0'
	gettoken tok rest : 0, parse(" =()") bind match(par)
	if "`par'" != "" {
		c_local elist `"(`tok')"'
	}
	else {
		gettoken equal rest2 : rest, parse("=")
		if `"`equal'"' == "=" {
			confirm name `tok'
			Check4Special rest `rest2'
			gettoken exp rest : rest,	///
				parse(" ()") match(par)
			if "`par'" != "" {
				c_local elist `"`tok'=(`exp')"'
			}
			else	c_local elist `"`tok'=`exp'"'
		}
		else {
			local x : subinstr local tok "[" "", count(local cl)
			local x : subinstr local tok "]" "", count(local cr)
			if `cr' > `cl' {
				di as err "too many ']'"
				exit 132
			}
			// make a try at closing the square brackets
			if `cl' > `cr' {
				// try to balance the square brackets
				gettoken tok2 rest : rest, parse("]")
				if `"`tok2'"' != "]" {
					local tok `"`tok'`tok2'"'
					gettoken tok2 rest : rest, parse("]")
					if `"`tok2'"' != "]" {
						di as err "too few ']'"
						exit 132
					}
				}
				local tok `"`:list retok tok']"'
				gettoken tok2 : rest, parse("[]")
				if inlist(`"`tok2'"',"_b","_se") {
					gettoken tok2 rest : rest, bind
					local tok `"`tok'`tok2'"'

				}
			}
			c_local elist `"`tok'"'
		}
	}
	c_local rest `"`:list retok rest'"'
end

// Syntax: c_name <stuff>
// Look for <name>(<exp>) as the next token in <stuff> and surround
// it with parentheses if found.
program Check4Special
	gettoken c_name 0 : 0
	gettoken tok rest : 0, parse(" ()") bind match(par)
	capture confirm name `tok'
	if !c(rc) & "`par'" == "" & bsubstr(`"`rest'"',1,1) == "(" {
		gettoken name rest : rest, parse("()") bind match(par)
		if "`par'" != "" {
			c_local `c_name' `"(`tok'(`name')) `:list retok rest'"'
			exit
		}
	}
	c_local `c_name' `"`0'"'
end

// Parse: <elist> := [<name> =] (<exp>)
// create locals from input:
// 	id
//	exp
program ParseElist
	Check4Special 0 `0'
	gettoken tok rest : 0, parse(" =()") bind match(par)
	if "`par'" != "" {
		gettoken tok rest : tok, parse(" =")
		capture confirm name `tok'
		if !c(rc) {
			gettoken equal rest : rest, parse("=")
			if `"`equal'"' == "=" {
				di as err ///
"invalid elist: '`tok'=' is not allowed to be bound in parentheses"
				exit 7
			}
			else	local exp `"`0'"'
		}
		else {
			local exp `"`0'"'
		}
	}
	else {
		capture confirm name `tok'
		if !c(rc) {
			gettoken equal : rest, parse("=")
			if `"`equal'"' == "=" {
				gettoken equal rest : rest, parse("=")
				local id `tok'
				local exp `"`rest'"'
			}
			else {
				local exp `"`tok'"'
			}
		}
		else {
			local exp `"`tok'"'
		}
	}
	c_local id `id'
	c_local exp `"`:list retok exp'"'
end

// create one of the following locals from input:
//	exp
program CheckExp
	// <eexp> are not allowed here
	Check4EExp `0'
	if `"`eexp_b'`eexp_se'"' != "" {
		di as err "invalid expression: `0'"
		exit 198
	}

	gettoken exp rest : 0, parse("()") bind match(par)
	if `"`:list retok rest'"' != "" {
		di as err "expressions must be bound in parentheses"
		exit 198
	}
	if `"`:list retok exp'"' == "" {
		di as err "nothing found where expression expected"
		exit 7
	}
	if "`par'" == "" {
		NeedParens `exp'
	}
	c_local exp `"(`:list retok exp')"'
end

// Look for <eexp>:
// create the following locals from input:
//	eexp_b or eexp_se
//	rest
program Check4EExp
	gettoken tok rest : 0, parse(" []") bind
	if `"`tok'"' == "[" {
		gettoken name rest : rest, parse("]")
		gettoken tok rest : rest, parse("]")
		if `"`tok'"' == "]" {
			local eqno " `name'"
		}
		gettoken tok rest : rest, parse(" []") bind
	}
	if inlist(`"`tok'"',"_b","_se") {
		if bsubstr(`"`rest'"',1,1) == "[" {
			gettoken br rest2 : rest, parse("[")
			gettoken br rest2 : rest2, parse("]")
			if `"`br'"' == "]" {
				local rest `"`rest2'"'
			}
			else {
				local tok
			}
		}
	}
	else	local tok
	c_local eexp
	c_local eexp_b
	c_local eexp_se
	if inlist(`"`tok'"',"_b","_se") {
		if "`eqno'" == "" {
			c_local eexp `tok'
		}
		else	c_local eexp [`name']`tok'
		if bsubstr(`"`tok'"',1,2) == "_b" {
			c_local eexp_b "`tok'`eqno'"
			c_local rest `"`:list retok rest'"'
		}
		else {
			c_local eexp_se "`tok'`eqno'"
			c_local rest `"`:list retok rest'"'
		}
	}
	else	c_local rest `"`0'"'
end

program NeedParens
	local operators "+ 1 * / ^ ~ | & > < ="
	local x : subinstr local 0 "+" "", count(local c1)
	local x : subinstr local 0 "-" "", count(local c2)
	local x : subinstr local 0 "*" "", count(local c3)
	local x : subinstr local 0 "^" "", count(local c4)
	local x : subinstr local 0 "~" "", count(local c5)
	local x : subinstr local 0 "|" "", count(local c6)
	local x : subinstr local 0 "&" "", count(local c7)
	local x : subinstr local 0 ">" "", count(local c8)
	local x : subinstr local 0 "<" "", count(local c9)
	local x : subinstr local 0 "=" "", count(local c10)
	local x = `c1'+`c2'+`c3'+`c4'+`c5'+`c6'+`c7'+`c8'+`c9'+`c10'
	if `x' > 0 {
		di as err "expressions must be bound in parentheses"
		exit 198
	}
end
exit
