*! version 1.1.4  12feb2015
* see notes at end of file
program define _getxel, sclass
	version 6, missing
	sret clear 
	sret local found 0

	gettoken first 0 : 0
	gettoken stub 0 : 0 

	if `"`first'"' == "newfirst" | `"`first'"' == "newsecond" {
		local first = bsubstr("`first'",4,.)
		local new New
	}
	else if `"`first'"' == "postfirst" | `"`first'"' == "postsecond" { 
		local first = bsubstr("`first'",5,.)
	}

	if `"`first'"' != "first" & `"`first'"'!="second" {
		di in red "_getxeq:  caller error"
		exit 197
	}
	if `"`stub'"' != "" {
		capture confirm name `stub'
		if _rc {
			di in red `"_getxeq:  caller error, stub="`stub'""'
			exit 197
		}
	}

	if "`first'"=="first" {
		global S_getxel 0
	}

	gettoken tok 0 : 0, parse(`" ,="') quotes match(par)

	if `"`tok'"'=="," | `"`tok'"'=="if" | `"`tok'"'=="in" | `"`tok'"'=="" {
		exit
	}

	gettoken eqsgn : 0, parse(" ,=") quotes
	if `"`eqsgn'"'=="=" {
		confirm name `tok'
		local name `tok'
		gettoken eqsgn 0 : 0, parse(" ,=") quotes match(par)
		gettoken tok 0 : 0, parse(" ,") quotes match(par)
	}
	else	local name ""

	/* In `tok' is a potential exp or eexp */
	sret local rest `"`0'"'

	MatchEE `tok'
	if `s(found)' { 
		Set`new'Name "`stub'" `name'
		exit
	}
	if "`par'"=="(" { 
		sret local exp `"`tok'"'
		sret local found 1
		Set`new'Name "`stub'" `name'
		exit
	}

	if bsubstr(`"`tok'"',1,1)=="[" { 
		exit
	}
	ChkExp `tok'
	if `s(bad)' {
		di in red "expression must be bound in parenthesis:"
		di in red `"not `tok'"'
		di in red `"but (`tok')"'
		exit 198
	}
	sret local bad
	sret local exp `"`tok'"'
	Set`new'Name "`stub'" `name'
	sret local found 1
	if `"`s(exp)'`s(eexp)'"' == "" {
		if "`name'" != "" {
			local name "`name'="
		}
		di as err "'`name'' found where expression expected"
		exit 198
	}
end

program define ChkExp, sclass
	sret local bad 1
	if index(`"`0'"',"+") { exit }
	if index(`"`0'"',"-") { exit }
	if index(`"`0'"',"*") { exit }
	if index(`"`0'"',"/") { exit }
	if index(`"`0'"',"^") { exit }
	if index(`"`0'"',"~") { exit }
	if index(`"`0'"',"|") { exit }
	if index(`"`0'"',"&") { exit }
	if index(`"`0'"',">") { exit }
	if index(`"`0'"',"<") { exit }
	if index(`"`0'"',"=") { exit }
	sret local bad 0
end

program define SetNewName, sclass
	args stub name
	if "`stub'"'=="" | `"`name'"' != "" { 
		sret local name `name'
		exit
	}
	global S_getxel = $S_getxel + 1 
	capture confirm new var `stub'$S_getxel
	while _rc { 
		global S_getxel = $S_getxel + 1 
		capture confirm new var `stub'$S_getxel
	}
	sret local name `stub'$S_getxel
end

program define SetName, sclass
	args stub name
	if "`stub'"'=="" | `"`name'"' != "" { 
		sret local name `name'
		exit
	}
	global S_getxel = $S_getxel + 1 
	sret local name `stub'$S_getxel
end

program define MatchEE, sclass
	local orig `"`0'"'
	Is_b_se `0'
	if "`s(class)'"!="" { 
		sret local eexp "`s(class)'"
		sret local found 1
		sret local class
		exit
	}

	gettoken lbrac 0 : 0, parse("[] ")
	gettoken name 0 : 0, parse("[] ")
	if `"`lbrac'"'=="[" & `"`name'"'=="]" { 
		local name ""
		local rbrac "]"
	}
	else 	gettoken rbrac 0 : 0, parse("[] ")
	if `"`lbrac'"'!="[" | `"`rbrac'"'!="]" {
		exit
	}

	Is_b_se `0'
	if "`s(class)'"=="" { 
		exit
	}
	sret local eexp `"`s(class)' "`name'""'
	sret local class

	if bsubstr(`"`name'"',1,1)=="#" {
		local chk = bsubstr(`"`name'"',2,.)
		capture confirm integer num `chk'
		if _rc { 
			di in red `"`orig' invalid"'
			exit 198
		}
		if `chk'<1 | `chk'>9999 {
			di in red `"`orig' invalid"'
			exit 198
		}
	}
	sret local found 1
end



program define Is_b_se, sclass
	if `"`0'"'=="_b" | `"`0'"'=="_b[]" {
		sret local class _b
	}
	else if `"`0'"'=="_se" | `"`0'"'=="_se[]" {
		sret local class _se
	}
	else	sret local class
end
exit


Syntax
------

	_getxeq {first|second} <stubname> `0'


Returns:
	s(found)	1 means xel found,  0 means not found

if s(found), 
	s(name)		name for element.
			name constructed out of stub if not specified.
			name always filled in, even in eexp case, 
			but you can ignore.

	s(exp)		"<exp>" or nothing
	s(eexp)		nothing or `"{_b|_se} ["name"]"'
			Note:  one of s(exp) or s(eexp) filled in.
	s(rest)		`0' with removal of xel.

	In addition, _getxeq will produce nonzero return codes and 
	appropriate error messages.


Example
-------

	local nxel 0
	_getxel first _jk `0'
	while `s(found)' { 
		local nxel = `nxel' + 1
		local name = `"`s(name)'"'
		local exp`nxel' `"`s(exp)'"'
		local eexp`nxel' `"`s(eexp)'"'
		local 0 : `s(rest)'
		_getxel second _jk `0'
	}
				/* include if xlist required: */
	if `nxel'==0 { 
		error 198 
	}
				/* end include if xlist required: */
				/* parse remaining syntax */
	syntax [if] [in] ...



Description of xlist and xel
----------------------------

<xlist> := 	<xel> <xlist>
		<nothing>

<xel> :=	<name> = <eexp>
		<name> = <exp>                    (see note 1)
		<name> = (<exp>)
		<eexp>
		<exp>
		(<exp>)

<eexp> :=	<specname>
		[<eq>]<specname>

<specname> :=	_b
		_b[]
		_se
		_se[]

<eq> :=		<name>
		#<#>

Note 1:
	In this case, the exp must be simple -- must contain no spaces.



<end>
