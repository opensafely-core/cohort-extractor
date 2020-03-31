*! version 1.0.5  08feb2015  
program checkdlgfiles
	version 8

	gettoken cmd 0 : 0, parse(" ,")
	syntax [, PATH(string) System]

	if "`system'" != "" {
		if `"`path'"'!="" {
			di as err ///
			"may not combine options -path()- and -system-"
			exit 198
		}
		local path "UPDATES;BASE"
	}
	else if `"`path'"'=="" {
		local path `"`c(adopath)'"'
	}

	preserve

	if "`cmd'"=="ado" {
		DoAdo `"`path'"'
	}
	else	error 198
end

program DoAdo
	args path

	GetFiles adofiles : *.ado `"`path'"'
	GetFiles dlgfiles : *.dlg `"`path'"'
	
	foreach el of local adofiles {
		if index("`el'", "_") {
			local sub `sub' `el'
		}
		else	local main `main' `el'
	}
	local ns : word count `sub'
	local nm : word count `main'
	di as txt "(`ns' adofiles with _; ignored)"
	di as txt "(`nm' adofiles without _)"
	tempfile dlgs ados 
	MakeDs `dlgfiles'
	qui save `"`dlgs'"'
	MakeDs `main'
	qui save `"`ados'"'

	tempfile adds subs
	Process_cmddlg `"`path'"' "`adds'" "`subs'"
	Addto   "`ados'" "`adds'"
	Subfrom "`ados'" "`subs'"

	qui use "`ados'", clear
	qui merge name using "`dlgs'"
	sort name

	di _n as txt "Summary"
	qui count if _merge==3
	di as txt _col(5) "1. have .dlg" as res _col(29) %9.0g r(N)
	qui count if _merge==1
	di as txt _col(5) "2. lack .dlg" as res _col(29) %9.0g r(N)
	qui count if _merge==2 & index(name,"_")==0
	di as txt _col(5) "3. unmatched .dlg w/o _" as res _col(29) %9.0g r(N)
	qui count if _merge==2 & index(name,"_")
	di as txt _col(5) "4. unmatched .dlg w/  _" as res _col(29) %9.0g r(N)

	quietly drop if _merge==3
	preserve

	quietly keep if _merge==1
	di as txt _n "{title:2. lack dlg}"
	list name

	restore, preserve
	quietly keep if _merge==2 & index(name, "_")==0
	di as txt _n "{title:3. unmatched .dlg w/o underscore}"
	list name

	restore, preserve
	quietly keep if _merge==2 & index(name, "_")
	di as txt _n "{title:3. unmatched .dlg w/ underscore}"
	list name
end

program Addto
	args main adds

	quietly {
		use "`main'", clear
		append using `"`adds'"'
		sort name
		by name: keep if _n==1
		save `"`main'"', replace
	}
end

program Subfrom
	args main subs
	quietly {
		use "`main'", clear
		merge name using `"`subs'"', nokeep
		drop if _merge==3
		drop _merge 
		sort name
		save `"`main'"', replace
	}
end
		

program MakeDs
	quietly {
		drop _all
		local n : word count `0'
		if `n'==0 {
			exit
		}
		set obs `n'
		gen str1 name = ""
		local i 0
		foreach el of local 0 {
			replace name = "`el'" in `++i'
		}
		gen int l = index(name, ".") 
		replace name = bsubstr(name,1,l-1) if l
		drop l
		compress
		sort name
	}
end

program GetFiles, rclass
	args result colon suffix path
	local subdirs "_ a b c d e f g h i j k l m n o p q r s t u v w x y z 0 1 2 3 4 5 6 7 8 9"

	gettoken d path : path, parse(" ;")
	while `"`d'"' != "" {
		if `"`d'"' != ";" {
			local d : sysdir `"`d'"'

			capture local x : dir "`d'" files "*`suffix'"
			if _rc==0 {
				local list : list list | x
			}

			foreach l of local subdirs {
				capture local x : dir "`d'`l'" files "*`suffix'"
				if _rc==0 {
					local list : list list | x
				}
			}
		}
		gettoken d path : path, parse(" ;")
	}


	local list : list clean list
	c_local `result' : list sort list
	local n : word count `list'
	ret scalar n = `n' 
	di as txt "(`n' `suffix' files)"
end

program Process_cmddlg
	args path adds subs
	Read_CmddlgMaint_File "`path'"
	qui count if action=="+"
	di as txt "(cmddlg.maint:  " r(N) " commands to be added)"
	qui count if action=="-"
	di as txt "(cmddlg.maint:  " r(N) " commands to be removed)"

	sort name

	preserve 
	quietly keep if action=="+"
	drop action
	qui save `"`adds'"'

	restore
	quietly keep if action=="-"
	drop action
	qui save `"`subs'"'
end


program Read_CmddlgMaint_File
	args path
	ReadMaintFile "`path'" cmddlg.maint
	if _N==0 { 
		exit
	}
	capture assert bsubstr(ref,1,1)=="+" | bsubstr(ref,1,1)=="-"
	if _rc {
		di _n as txt "Errors in cmddlg.maint:  not + or -"
		list ref if !(bsubstr(ref,1,1)=="+" | bsubstr(ref,1,1)=="-")
		drop if !(bsubstr(ref,1,1)=="+" | bsubstr(ref,1,1)=="-")
		di _n as txt "(lines ignored)"
	}
	quietly { 
		gen str1 action = bsubstr(ref,1,1)
		replace ref = bsubstr(ref,2,.)
		compress
		rename ref name
		sort name action
	}

	capture by name action: assert _N==1
	if _rc { 
		di _n as txt "Errors in cmddlg.maint:  duplicates:"
		preserve
		quietly by name action: keep if _N>1
		list action name
		restore
		di _n as txt "duplicates dropped"
		quietly by name action: keep if _n==1
	}
end

program ReadMaintFile 
	args path fn 
	qui drop _all
	capture findfile "`fn'", path("`path'")
	if _rc { 
		di as txt "(note:  file `fn' not found)"
		exit
	}
	local input "`r(fn)'"
	quietly {
		infix str ref 1-240 using `"`input'"'
		gen byte pos = index(ref,"*")
		replace ref = bsubstr(ref,1,pos-1) if pos
		replace ref = trim(ref)
		drop if ref=="" | bsubstr(ref,1,1)=="*"
		drop pos
		compress
	}
end

exit
