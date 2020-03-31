*! version 1.0.22  07aug2017
program define spmatrix
	version 15.0
	
	gettoken sub 0 : 0 , parse(" ,")
	local 0 = subinstr(`"`0'"', `","' , `" , "' , .)
	
 	local len = length(`"`sub'"')
        if `len'==0 {
               di as err "No subcommand specified"
               exit 198
        }
        
	// some spmatrix subcommands create tempnames used by Mata
	// make sure to drop the tempnames after a subcommand is terminated
	
	if (`"`sub'"'=="create") {
 		gettoken sub 0 : 0 
 		local len = length(`"`sub'"')
		if (`"`sub'"'==substr("idistance", 1, max(5, `len')) ) {
			SPMAT_idistance `0'
		}
		else if (`"`sub'"'==substr("contiguity", 1, max(4, `len')) ) {
			cap noi SPMAT_contiguity `0'
			SPMAT_drop_tempnames `matanames'
		}
		else {
                	di as error `"`sub' unknown subcommand"'
                	exit 198
		}
 	}
	else if (`"`sub'"'== substr("summarize",1,max(3, `len')) ) {
		SPMAT_summarize `0'
	}
	else if (`"`sub'"'== "use") {
		SPMAT_read `0'
	}
	else if (`"`sub'"'== "import") {
                SPMAT_import `0'
        }
	else if (`"`sub'"'== "export") {
                SPMAT_export `0'
        }
	else if (`"`sub'"'== "save") {
                SPMAT_save `0'
        }
	else if (`"`sub'"'=="drop") {
                SPMAT_drop `0'
        }
        else if (`"`sub'"'== "note") {
                cap noi SPMAT_note `0'
                SPMAT_drop_tempnames `matanames'
        }
	else if (`"`sub'"'=="dir") {
		SPMAT_dir `0'
	}
	else if (`"`sub'"'== "copy") {
		SPMAT_copy `0'
	}
	else if (`"`sub'"'== "spfrommata") {
		SPMAT_spfrommata `0'
	}
	else if (`"`sub'"'== "matafromsp") {
		SPMAT_matafromsp `0'
	}
	else if (`"`sub'"'== "fromdata") {
                cap noi SPMAT_fromdata `0'	
                SPMAT_drop_tempnames `matanames'
	}
	else if (`"`sub'"'== substr("normalize",1, max(4, `len')) ) {
		SPMAT_normalize `0'	
	}
	else if (`"`sub'"'== "userdefined") {
		spmatrix_userdefined `0'	
	}
	else if (`"`sub'"'=="clear") {
		SPMAT_clear		// NOT DOCUMENTED
	}
        else if (`"`sub'"'== "idmatch") {
                SPMAT_idmatch `0'	// NOT DOCUMENTED
        }
        else if (`"`sub'"'== "xtidmatch") {
                SPMAT_xtidmatch `0'	// NOT DOCUMENTED
        }
        else if (`"`sub'"'== "lag") {
                SPMAT_lag `0'		// NOT DOCUMENTED
        }
 	else {
                di as error `"`sub' unknown subcommand"'
                exit 198
        }
end

program define SPMAT_drop_tempnames
	
	syntax [anything]
	
	local rc = c(rc)
	
        foreach m of local 0 {
		capture mata: mata drop `m'
	}
	if `rc' exit `rc'
	
end
					//-- SPMAT_contiguity --//
program define SPMAT_contiguity, sortpreserve
						//  substitute second to
						//  second(1) 
	gettoken before after : 0, parse(",")
	gettoken tmp after : after, parse(",")
	local after = subinword(`"`after'"', "second", "second(1)", 1)
	local 0 `before', `after'
						//  parse syntax
	syntax name(id="weighting matrix name")	///
		[if] [in] 			///
		[, 				///
		rook				///
		NORMalize(string)		///
		replace				///
		first				///
		SECond(string)			///
		tolerance(real 1E-7)		///	NOT DOCUMENTED
		]

	marksample touse
						// Parse id	
	__sp_parse_id, id(`id')
	local id `"`s(id)'"'
						// Parse shapefile
	vsp_validate shapefile
	local using `"`r(sp_shp_dta)'"'
						// parse normalize	
	SPMAT_normparse,  `normalize'
	local normalize `s(normalize)'
						// id signature
	ID_Signature, id(`id') touse(`touse')
	local id_sig `s(id_sig)'
						// Parse Replace
	ParseReplace , replace(`replace')
	local isreplace = `s(isreplace)'
						// Check Exists weighting matrix
	CheckExistsW, objname(`namelist') isreplace(`isreplace')
						// Parse order
	ParseOrder , `first' second(`second')
	local order_list `s(order_list)'
						// preserve START	
	qui preserve
	tempvar index index2 gr N
	tempname map
	tempfile mapping 
	c_local matanames `map'
	
	qui keep if `touse'
						// mapping
	keep `id'
	qui gen double `index' = _n
	qui save `"`mapping'"'
	mata : `map'=st_data(.,"`id' `index'")
	sort `id'
						// Parse Rook or Queen
	if (`"`rook'"'=="") {
		ParseQueen, id(`id')		///
			using(`using')		///
			index(`index')		///
			tolerance(`tolerance')	///
			gr(`gr')		///
			nvar(`N')		
	}
	else if (`"`rook'"'=="rook") {
		tempvar v minX maxX minY maxY 
		ParseRook, id(`id')		///
			using(`using')		///
			index(`index')		///
			tolerance(`tolerance')	///
			gr(`gr')		///
			nvar(`N')		///
			mapping(`mapping')	///
			v(`v')			///
			minX(`minX')		///
			maxX(`maxX')		///
			minY(`minY')		///
			maxY(`maxY')		
	}
						// mata computation	
	cap noi mata : _SPMATRIX_contiguity(	///
		"`namelist'",			///
		`map',				///
		"`normalize'", 			///
		"`rook'",			///
		"`id_sig'", 			///
		`isreplace',			///
		`"`order_list'"')
	local rc = _rc
	spmatrix_safe_drop, rc(`rc') objname(`namelist')
						// preserve finished
	restore
end
					//-- CheckExists W--//
program	CheckExistsW
	syntax [,objname(string)	///
		isreplace(string)]

	cap mata : _SPMATRIX_findexternal_safe(`"`objname'"')	
	if _rc {
		local exists = 0
	}
	else {
		local exists = 1
	}

	if (`exists' == 1 & `isreplace' == 0) {
		di as err `"weighting matrix {bf:`objname'} already exists"'
		exit 110
	}
end
					//-- Parse Order --//
program ParseOrder, sclass
	syntax [, first		///
		second(string)	///
		]
	
	if (`"`second'"'!="") {
		capture confirm number `second'
		local rc = _rc
		capture assert `second' > 0
		local rc = _rc + `rc'
		if `rc' {
			di as err "option {bf:second()} must "	///
				"be a positive number"
			exit 198
		}

	}
	
	if (`"`second'"'=="") {
		local order_list 1
	}

	if (`"`second'"'!="" & `"`first'"' == "") {
		local order_list 0 `second'
	}

	if (`"`second'"'!="" & `"`first'"'!="") {
		local order_list 1 `second'
	}

	sret local order_list `order_list'
end
					//--  Parse Queen --//
program	ParseQueen
	syntax , id(string)		///
		using(string)		///
		index(string)		///
		tolerance(string)	///
		gr(string)		///
		nvar(string)		
		
		capture rename `id' _ID
		qui merge 1:n _ID using `"`using'"'
		qui count if _merge == 1
		if r(N) > 0 {
			di as err "Some observations in master dataset "    ///
				"are not in coordinates dataset"
			exit 498
		}
		qui keep if _merge==3
		keep `index' _X _Y
		order `index' _X _Y
		
		qui drop if _X==.

		sort _X _Y
		qui by _X _Y: gen double `gr'=_n==1
		qui replace `gr'=sum(`gr')
		
		drop _X _Y
		
		sort `gr' 		// there will still be multiple 
					// obs per `gr' `index'
					// but mata will process them faster 

		qui by `gr': gen `nvar'=_N
		qui drop if `nvar'==1
		
		qui count
		if `r(N)'==0 {
			di
			di "{res}No neighbors found"
			di
			exit 100
		}
		
		qui replace `nvar' = `nvar'==2		
end
					//-- ParseRook --//
program ParseRook
	syntax , id(string)		///
		using(string)		///
		index(string)		///
		tolerance(string)	///
		gr(string)		///
		nvar(string)		///
		mapping(string)		///
		v(string)		///
		minX(string)		///
		maxX(string)		///
		minY(string)		///
		maxY(string)		

	 tempvar orderu _X2 _Y2 slope intercept vline 
	
	// +++++++++++ shp2dta does not create an order var, create one
	qui use _ID _X _Y using `"`using'"', clear
	capture rename _ID `id'
	qui gen double `orderu' = _n
	sort `id'
	qui merge n:1 `id' using `"`mapping'"'
	qui count if _merge == 2
	if r(N) > 0 {
		di as err "Some observations in master dataset "    ///
			"are not in coordinates dataset"
		exit 498
	}
	qui keep if _merge==3
	drop _merge
	qui assert `index'!=.
	keep `index' `orderu' _X _Y
	sort `index' `orderu'
	drop `orderu'
	
	qui gen double `_X2' = _X[_n-1]
	qui gen double `_Y2' = _Y[_n-1]
	qui drop if _X==. | `_X2'==.
	
	qui gen double `slope' = (_Y-`_Y2') / (_X-`_X2')
	qui gen double `intercept' = _Y-`slope'*_X
	qui gen double `vline' = _X if `slope'==.
	
	qui replace `slope' = round(`slope',`tolerance')
	qui replace `intercept' = round(`intercept',`tolerance')
	qui replace `vline' = round(`vline',`tolerance')
	
	sort `intercept' `slope' `vline'
	qui by `intercept' `slope' `vline': gen double `gr' = _n==1
	qui replace `gr'=sum(`gr')
	
	drop `slope' `intercept'
	qui gen byte `v' = `vline'==.
	drop `vline'

	sort `gr'
	qui by `gr': gen `nvar'=_N
	qui drop if `nvar'==1
	
	qui count
	if `r(N)'==0 {
		di
		di "{res}No neighbors found"
		di
		exit 0
	}
	
	qui keep `index' _X _Y `gr' `_X2' `_Y2' `v' `nvar'
	
	qui gen double `minX' = min(_X,`_X2')
	qui gen double `maxX' = max(_X,`_X2')
	qui gen double `minY' = min(_Y,`_Y2')
	qui gen double `maxY' = max(_Y,`_Y2')
	
	drop _X `_X2' _Y `_Y2'
	sort `gr'
	
	qui replace `nvar' = `nvar'==2
	keep `index' `gr' `nvar' `v' `minX' `maxX' `minY' `maxY'
	order `index' `gr' `nvar' `v' `minX' `maxX' `minY' `maxY'
end


program define SPMAT_idistance, sortpreserve
	
	syntax name(id="weighting matrix name")		///
		[if] [in] , 				///
		[					///
		NORMalize(string)			///
		replace					///
		VTRUNCate(string)			/// 
		]

	__sp_parse_id, id(`id')
	local id `"`s(id)'"'
						// parse replace	
	ParseReplace , replace(`replace')
	local isreplace = `s(isreplace)'
						// marksample	
	marksample touse, novarlist
	gettoken objname coordinates : namelist
						//  Check Exists W
	CheckExistsW, objname(`objname') isreplace(`isreplace')
						// parse coordinates
	ParseCoords, coordinates(`coordinates') touse(`touse')
	local coordinates `s(coordinates)'
	local ncoor `s(ncoor)'
	local sp_coord_sys `s(sp_coord_sys)'
	local sp_coord_sys_dunit `s(sp_coord_sys_dunit)'
						// markout
	markout `touse' `coordinates'
						// Parse truncation
	ParseTruncate, vtruncate(`vtruncate')
	local trtype `s(trtype)'
	local num1 = `s(num1)'
	local num2 = `s(num2)'
						// parse normalize()	
	SPMAT_normparse,  `normalize'
	local normalize `s(normalize)'
						// parse dfunction()
	ParseDfunction, ncoor(`ncoor') 		///
		coordsys(`sp_coord_sys')	///
		coordsys_dunit(`sp_coord_sys_dunit')
	local type `s(type)'
	local power `s(power)' 
	local dscale `s(dscale)'
						// parse id signature
	ID_Signature, id(`id') touse(`touse')
	local id_sig `s(id_sig)'
						// computation
	preserve
	quietly keep if `touse'
	
	cap noi mata : _SPMATRIX_idistance("`objname'" ,"`id'" , 	///
			"`coordinates'", "`normalize'", `trtype', 	///
			`num1', `num2', "`type'",`power',"`dscale'", 	///
			"`id_sig'", `isreplace')
	local rc = _rc
	spmatrix_safe_drop, rc(`rc') objname(`objname')
	restore
end
						// ParseReplace //
program ParseReplace, sclass
	syntax [, replace(string)]

	if "`replace'"=="replace" {
		local isreplace = 1
	}
	else {
		local isreplace = 0
	}

	sret local isreplace `isreplace'
end
					//-- Parse coordinates() --//
program ParseCoords, sclass
	syntax [, coordinates(string) 	///
		touse(string)]	
	
	vsp_validate noshapefile
	local sp_cx `r(sp_cx)'
	local sp_cy `r(sp_cy)'
	local sp_coord_sys `r(sp_coord_sys)'
	local sp_coord_sys_dunit `r(sp_coord_sys_dunit)'

	if "`coordinates'"=="" {
		local coordinates `sp_cx' `sp_cy'
	}
	capture confirm numeric variable `coordinates'
	if _rc {
		di "{err}coordinate variables must be numeric"
		exit 498
	}
	foreach c of local coordinates {
		capture assert !missing(`c') if `touse'
		if _rc {
		       di "{err}coordinate variable {bf:`c'} has missing values"
			exit 198
		}
	}
	
	tempvar dup
	qui duplicates tag `coordinates' if `touse', gen(`dup')
	cap assert `dup' == 0 if `touse'
	if (_rc) {
		di "{err}Two or more observations have the same coordinates"
		exit 498
	}
	
	local ncoor : word count `coordinates'

	sret local coordinates `coordinates'
	sret local ncoor `ncoor'
	sret local sp_coord_sys `sp_coord_sys'
	sret local sp_coord_sys_dunit `sp_coord_sys_dunit'
end
					//-- Parse dfunction() --//
program ParseDfunction, sclass
	
	// for either haversine the number of coordinates must =2
	// miles can be specified only with haversine
	syntax [, ncoor(string) 	///
		coordsys(string)	///
		coordsys_dunit(string)	///
		]
						//  dfunction
	if (`"`coordsys'"'=="planar") {
		local dfunction "euclidean"
		local type "reals"
	}
	else if ("`coordsys'"'=="latlong") {
		local dfunction "dhaversine"
		local type "degrees"
	}
	else {
		local dfunction "euclidean"
		local type "reals"
	}

	if ("`dfunction'"=="dhaversine" & `ncoor'!=2) {
		di as err "Haversine distance requires "  ///
			"two coordinate variables"
		exit 198
	}
						//  power 2	
	local power 2
						//  dscale	
	if "`coordsys_dunit'"=="" {
		local dscale = "km"
	}
	else if "`coordsys_dunit'"=="kilometers" {
		local dscale = "km"
	}
	else if "`coordsys_dunit'"=="miles" {
		local dscale = "miles"
	}

	sret local type `type'
	sret local power `power'
	sret local dscale `dscale'
end
					//-- SPMAT_summarize  --//
program define SPMAT_summarize, rclass sortpreserve
	
	syntax name(name=objname id="weighting matrix")		///	
		[ , GENerate(string)]

	capture mata : _SPMATRIX_assert_object("`objname'")
	if _rc SPMAT_error `objname'

						//  UpdateTouse
	marksample touse, novarlist
						//  Parse generate()
	tempvar tmp
	ParseGen, varname(`"`generate'"')	///
		objname(`objname')		/// 
		tmp(`tmp')			///
		touse(`touse')
	local varname `s(varname)'
	local tmp_varname `s(tmp_varname)'
	local panelvar `s(panelvar)'
	local timevar `s(timevar)'
	local timevalues `s(timevalues)'
						//  compute and print summarize	
	cap noi mata : _SPMATRIX_summarize(	///
		"`objname'", 			///
		`"`touse'"',			///
		`"`tmp_varname'"', 		///
		`"`timevar'"',			///
		`"`timevalues'"')
						//  post variable
	if _rc {
		exit _rc
	}
	else if (`"`tmp_varname'"'!="") {
		rename `tmp_varname' `varname'
		label var `varname' "Number of neighbors"
	}
end
					//-- UpdateTouse --//
program UpdateTouse
	syntax , touse(string)	///
		objname(string)	///
		id(string)
						//  get wid	
	tempfile  wid
	preserve	
	clear 
	qui gen float `id' = .
	mata : _SPMATRIX_post_id(`"`objname'"', `"`id'"')	
	qui save `"`wid'"'
	restore
						//  merge wid with data
	tempvar tmp_merge
	qui merge m:1 `id' using `"`wid'"', generate(`tmp_merge')
	qui count if `tmp_merge' == 2	
	local n_using = `r(N)'

	if (`n_using' >0 ) {
		di "{p 0 2 2}"
		di as err "_IDs found in weighting matrix that "	///
			"do not exist in data"
		di "{p_end}"
		exit 198
	}

	qui replace `touse' = 0 if `tmp_merge' != 3
end

					//-- ParseGen --//
program ParseGen, sclass
	syntax	, 			///
		[ varname(string) ]	///
		objname(string)		///
		tmp(string)		///
		touse(string)
	
	local n_var : list sizeof varname

	if (`n_var' >=2) {
		di as err "option {bf:generate()} requires a new "	///
			"variable name"
		exit 198
	}

	if (`"`varname'"' == "") {
		sret local varname 
		sret local tmp_varname
		exit
		//NotReached
	}
						//  check new varname
	cap confirm new variable `varname'
	if _rc {
		di as error "variable {bf:`varname'} already defined "	
		exit 110
	}
						//  check spset
	cap vsp_validate noshapefile
	if _rc {
		di as err "option {bf:generate()} requires "	///
			"data to be {bf:spset}"
		exit _rc
	}
	local id `r(sp_idvar)'
						//  check if panel data
	cap vsp_validate is_xtset
	if _rc {
		di as err "option {bf:generate()} requires "	///
			"data to be {bf:xtset}"
		exit _rc
	}
	local panelvar `r(panelvar)'
	local timevar `r(timevar)'
	local balanced `r(balanced)'
						//  update touse
	UpdateTouse , touse(`touse') 		///
		objname(`objname') 		///
		id(`id')
						//  get timevalues if panel
	GetTimevalues, timevar(`timevar') touse(`touse') 
	local timevalues `s(timevalues)'
						//  check if strongly balanced
	if (`"`panelvar'"' !="" & `"`balanced'"' != "strongly balanced") {
		di as err "option {bf:generate()} requires "	///
			"data to be {bf:xtset} and strongly balanced"
		exit 198
	}
						//  sort data to match id in W
	if (`"`panelvar'"' == "" & `"`timevar'"'=="") {
		_spreg_match_id , 		///
			id(`id') 		///
			touse(`touse') 		///
			lag_list(`objname')
	}
	else if (`"`panelvar'"'!="" & `"`timevar'"' != "" ) {
		_spxtreg_match_id,		///
			id(`id')		///
			touse(`touse')		///
			lag_list(`objname')	///
			timevar(`timevar')	///
			timevalues(`timevalues')
	}

	sret local varname `varname'
	sret local panelvar `panelvar'
	sret local timevar `timevar'
	sret local timevalues `timevalues'
	sret local tmp_varname `tmp'
end
					//-- get time values --//
program GetTimevalues, sclass
	syntax , touse(string)		///
		[ timevar(string)]	
	
	if (`"`timevar'"'!="") {
		tempname tmp
		qui tabulate `timevar' if `touse', matrow(`tmp')	
		forvalues i=1/`=rowsof(`tmp')' {
			local timevalues `timevalues' `=`tmp'[`i', 1]'
		}
		sret local timevalues `timevalues'
	}
	else {
		sret local timevalues
	}
end

program define SPMAT_note
/*
	spmatrix note <Wname> : <text>    add new note to end of notes. 
	spmatrix note <Wname> :        
	spmatrix note <Wname>		list notes for <Wname> 
*/
	gettoken obj rest : 0, parse(": ")
	gettoken colon rest : rest, parse(": ")

	local 0 `obj'
	syntax anything(id="weighting matrix")
	
	if !("`colon'"=="" | "`colon'"==":") {
		di "{err}invalid syntax"
		exit 198
	}
	
	if "`colon'"=="" { // ++++++++++++++++++++++++++++++++++++ display note
		mata : _SPMATRIX_display_note(`"`obj'"')
		exit 
	}
	else if "`colon'"==":" {	//+++++++++++++++++++++++++ replace note
		local 0 `"`rest'"'
		syntax [anything(name=note id="text")]
		capture mata : _SPMATRIX_note("`obj'", `"`note'"', "replace")
		if _rc SPMAT_error `obj'
	}
	else {
		di "{err}invalid syntax"
		exit 198
	}
	
end
					//-- SPMAT_fromdata --//
program define SPMAT_fromdata
	
	syntax anything(id="<Wname> = <varlist>" 	///
		equalok name=eq)			///
		[if] [in] ,				///
		[ 					///
		NORMalize(string)			///
		replace 				///
	      	IDISTance 				///	
	    	]

	marksample touse

	__sp_parse_id, id(`id') 
	local id `s(id)'

	ParseEqfromdata, eq(`eq')
	local objname `s(objname)'
	local varlist `s(varlist)'
	
	SPMAT_normparse,  `normalize'
	local normalize `s(normalize)'

	ID_Signature, id(`id') touse(`touse')	
	local id_sig `"`s(id_sig)'"'
	
	tempname mat vec
	c_local matanames `mat' `vec'
	mata : `mat' = st_data(.,"`varlist'","`touse'")

	if ("`id'" != "") {
		mata: `vec' = st_data(.,"`id'","`touse'")
	}
	else mata: `vec' = J(0,1,0)
	
	if ("`replace'" == "replace") {
		local isreplace = 1
	}
	else {
		local isreplace = 0
	}

	cap noi mata : _SPMATRIX_fromdata(	///
		`"`objname'"',			///
		`mat',				///
		"`idistance'",			///
		"`normalize'",			///
		`vec',				///
		`"`id_sig'"',			///
		`isreplace')
	local rc = _rc
	spmatrix_safe_drop, rc(`rc') objname(`objname')

end
					//-- ParseEqfromdata --//
program ParseEqfromdata, sclass
	syntax , eq(string)

	gettoken objname vars : eq, parse("=")
	gettoken equal vars : vars, parse("=")

	if (`"`equal'"'!="=") {
		ErrorInvalidSyntax
	}

	local 0 `objname'
	syntax name(id="weighting matrix" name=objname)

	unab varlist : `vars'
	local 0 `varlist'
	syntax varlist(numeric)

	sret local objname `objname'
	sret local varlist `varlist'
end
					//-- SPMAT_read --//
program define SPMAT_read
	
 	syntax [anything(name=before everything)] [, replace]

 	ParseUsing `before' 
 	local namelist `s(namelist)'
	local fname `s(fname)'

	local suffix .stswm
	ParseFname, fname(`fname') suffix(`suffix')
	local fname `s(fname)'

	confirm file `"`fname'"'
	
	if "`replace'" == "replace" {
		local isreplace = 1
	}
	else {
		local isreplace = 0
	}
	cap noi mata : _SPMATRIX_read_u("`namelist'",`"`fname'"',`isreplace') 
	local rc = _rc
	spmatrix_safe_drop, rc(`rc') objname(`namelist')
end
					//-- SPMAT import --//
program define SPMAT_import

 	syntax [anything(name=before everything)] [, replace]

	ParseUsing `before'
	local namelist `s(namelist)'
	local fname `s(fname)'

	local suffix .txt
	ParseFname, fname(`fname') suffix(`suffix')
	local fname `s(fname)'

	confirm file `"`fname'"'
	
	if "`replace'" == "replace" {
		local isreplace = 1
	}
	else {
		local isreplace = 0
	}
	
	cap noi mata : _SPMATRIX_import_txt(	///
		"`namelist'",			///
		`isreplace',			///
		`"`fname'"')
	local rc = _rc
	spmatrix_safe_drop, rc(`rc') objname(`namelist')
end
					//-- SPMAT_export --//
program define SPMAT_export

 	syntax [anything(name=before everything)] [, replace]

	ParseUsing `before'
	local namelist `s(namelist)'
	local fname `s(fname)'

	local suffix .txt
	ParseFname, fname(`fname') suffix(`suffix')
	local fname `s(fname)'

	if "`replace'" != "" {
		local isreplace 1
	}
	else local isreplace 0
	
	capture mata : _SPMATRIX_assert_object("`namelist'")
	if _rc SPMAT_error `namelist'
	
	mata : _SPMATRIX_export_txt(	///
		"`namelist'",		///
		`"`fname'"',		///
		`isreplace')
end
					//-- spmat save --//
program define SPMAT_save
 	syntax [anything(name=before everything)] [, replace]

	ParseUsing `before'
	local namelist `s(namelist)'
	local fname `s(fname)'

	local suffix .stswm
	ParseFname, fname(`fname') suffix(`suffix')
	local fname `"`s(fname)'"'

	if "`replace'" == "" {
		local replace 0
	}
	else local replace 1
	
	capture mata : _SPMATRIX_assert_object("`namelist'")
	if _rc SPMAT_error `namelist'
	
	mata : _SPMATRIX_save_u("`namelist'",`"`fname'"',`replace')

end
					//-- Parse Txt fname --//
program ParseFname, sclass
	syntax , fname(string)	///
		suffix(string)
	
	if (!ustrregexm(`"`fname'"', "\.")){
		local fname `"`fname'`suffix'"'
	}
		
	sret local fname `fname'
end


program define SPMAT_drop

	syntax name(id="weighting matrix")	
	
	capture mata : _SPMATRIX_assert_object("`namelist'")
	local rc = _rc
	
	if (`rc') {
		di as err "weighting matrix {bf:`namelist'} not found"
		exit 111
	}

	mata : _SPMATRIX_drop(`"`namelist'"')
end

program define SPMAT_normparse, sclass

	capture syntax [, 	///
		row 		///
		SPEctral 	///
		MINmax		///
		NONE]

	if _rc {
		local 0 : subinstr local 0 "," ""
		local 0  = trim("`0'")
		di as err `"unrecognized {bf:normalize()} : `0' "'
		exit 199
	}

	local norm_opt `row' `spectral' `minmax' `none'
	local case : word count `norm_opt'

	if (`case' > 1) {
		di as err "only one {it:normalization} may be specified"
		exit 198
	}

	if (`case' == 0) {
		local norm_opt spectral
	}

	if ("`norm_opt'" == "spectral") {
		local normalize spectral
	}
	else if ("`norm_opt'" == "row") {
		local normalize row
	}
	else if ("`norm_opt'" == "minmax") {
		local normalize minmax
	}
	else if ("`norm_opt'" == "none") {
		local normalize 
	}

	sret local normalize `normalize'
end

program define SPMAT_lag

	syntax anything [if] [in], [id(string)]

	marksample touse

	local n : word count `anything'
		
	if (`n'<3 | `n'>4) {
		di "{err}invalid syntax"
		error 498
	}
	
	local type : word 1 of `anything'
	
	if (`n'==4 & "`type'"!="double" & "`type'"!="float") {
		di "{err}invalid type"
		exit 498
	}
	
	if `n'==4 {
		gettoken type anything : anything
	}
	else {
		local type = "float"
	}
	
	gettoken newvar anything : anything
	gettoken objname oldvar : anything
	local oldvar = trim("`oldvar'")
	confirm new variable `newvar'
	
	capture mata : _SPMATRIX_assert_object("`objname'")
	if _rc SPMAT_error `objname'
 
 	__sp_parse_id, id(`id')
	local id `s(id)'
	mata : _SPMATRIX_check_id("`objname'", "`id'", "`touse'")
	mata : _SPMATRIX_lag("`type'","`newvar'",	///
		"`objname'","`oldvar'", "`touse'")
	
end

program define SPMAT_idmatch
	
	syntax anything , 		///
		id(varname numeric)	///
		idsig_dta(string)	///
		touse(string)
	
	/* sorts the dataset in memory on id variable such that the 
		id variable matches the ids contained in weighting matrix */
	
	local n : word count `anything'
		
	if `n'>1 {
		di "{err}invalid syntax"
		error 498
	}
	
	local objname : word 1 of `anything'
	
	capture mata : _SPMATRIX_assert_object("`objname'")
	if _rc {
		di "{err}weighting matrix {bf:`objname'} not found"
		exit 498
	}
	
	capture assert `id' != . if `touse'
	if _rc {
		di "{err}`id' contains missing values"
		exit 498
	}

	mata : _SPMATRIX_idmatch(	///
		"`objname'",		///
		"`id'",			///
		`"`idsig_dta'"',	///
		`"`touse'"')
end
					//-- id match for panel data  --//
					// called by _spxtreg_match_id
program define SPMAT_xtidmatch
	
	syntax anything , 		///
		id(varname numeric)	///
		idsig_dta(string)	///
		touse(string)		///
		timevar(string)		///
		timevalues(string)
	
	/* sorts the dataset in memory on id variable such that the 
		id variable matches the ids contained in weighting matrix */
	
	local n : word count `anything'
		
	if `n'>1 {
		di "{err}invalid syntax"
		error 498
	}
	
	local objname : word 1 of `anything'
	
	capture mata : _SPMATRIX_assert_object("`objname'")
	if _rc {
		di "{err}weighting matrix {bf:`objname'} not found"
		exit 498
	}
	
	capture assert `id' != . if `touse'
	if _rc {
		di "{err}`id' contains missing values"
		exit 498
	}

	mata : _SPMATRIX_xtidmatch(	///
		"`objname'",		///
		"`id'",			///
		`"`idsig_dta'"',	///
		`"`touse'"',		///
		`"`timevar'"',		///
		`"`timevalues'"')
end

program define SPMAT_error

	args objname
	
	di "{err}weighting matrix {bf:`objname'} not found"
	exit 111
end
					//-- SPMAT_dir : list existing spmat
					//objects in memory --//
program SPMAT_dir, rclass
/*
spmat dir 

          . spmat dir 
--------------------------------------------------------------------------
           weighting matrix name   N x N      type     normalization
--------------------------------------------------------------------------
                               W   99999    idistance      none
                               W   99999    idistance      none
                                            general        spectral
                                                           row
                                                           minmax
--------------------------------------------------------------------------

	. spmat dir
          (no weighting matrices found)
*/
	cap syntax 
	if (_rc) {
		di as err "invalid syntax"
		exit 198
	}
	mata : _SPMATRIX_direxternal()
	return local names `spmat_dir'
end


program ID_Signature, sclass
	syntax , id(string) [touse(string)]

	tempvar tmp_id

	qui gen double `tmp_id' = `id'
	
	if (`"`touse'"'!="") {
		qui _datasignature `tmp_id' if `touse', nonames
	}
	else {
		qui _datasignature `tmp_id', nonames
	}
	sret local id_sig `"`r(datasignature)'"'
end
					//-- parseUsing --//
program ParseUsing, sclass
	args namelist using fname

	local n_args : list sizeof 0

	if (`n_args'<1) {
		di as err "weighting matrix required"
		exit 100
	}

	if (`"`using'"' != "using") {
		di as err "{bf:using} required"
		exit 198
	}

	if (`n_args' ==1 | `n_args'==2) {
		di as err "{it:filename} required"
		exit 198
	}
		
	if (`n_args' >=4) {
		di as err "invalid syntax"
		exit 198
	}

	if (`"`fname'"'=="") {
		di as err "{it:filename} required"
		exit 198
	}
	
	local 0 `namelist'
	syntax name(id="weighting matrix")

	sret local namelist `namelist'
	sret local fname `fname'
end
					//-- SPMAT_copy --//
program SPMAT_copy
	syntax namelist(min=2 max=2 id="weighting matrices")
	args old_obj new_obj	
	
	capture mata : _SPMATRIX_assert_object("`old_obj'")
	if _rc SPMAT_error `old_obj'
	
	cap noi mata : _SPMATRIX_copy(`"`old_obj'"', `"`new_obj'"')
	local rc = _rc
	spmatrix_safe_drop, rc(`rc') objname(`new_obj')
end
					//--  SPMAT_normalize --//
program define SPMAT_normalize
/*
spmat normalize <Wname> [, options]     
	<options> := 
		normalize()
*/
	syntax namelist(max=1 min=1 				///
		name=objname id="weighting matrix") 	///
		[ , NORMalize(string) ]

	SPMAT_normparse,  `normalize'
	local normalize `s(normalize)'

	capture mata : _SPMATRIX_assert_object("`objname'")
	if _rc SPMAT_error `objname'

	mata: _SPMATRIX_normalize_matrix(	///
		`"`objname'"',			///
		`"`normalize'"')
end
					//-- Parse truncation --//
program ParseTruncate, sclass
	syntax  [ ,						///
		BTRuncate(numlist >=0 min=2 max=2)		///
		DTRuncate(numlist >=0 integer min=1 max=2)	///
		VTRuncate(string)				///
		]

	local btr = ("`btruncate'"!="")
	local dtr = ("`dtruncate'"!="")
	local vtr = ("`vtruncate'"!="")
	local trs = `btr'+`dtr'+`vtr'
	
	if `trs'>1 {
		di "{err}only one of btruncate, dtruncate, "		///
			"or vtruncate is allowed"
		exit 498
	}

	local trtype = ("`btruncate'"!="")*1 + ("`dtruncate'"!="")*2 + ///
		("`vtruncate'"!="")*3
	
	local num1 = 0
	local num2 = 0
	
	if "`btruncate'"!="" {
		local num1 : word 1 of `btruncate'
		local num2 : word 2 of `btruncate'
		if `num2' <= `num1' {
			di "{err}number of bins must be greater than the " _c
				di "bin you are truncating at"
			exit 498
		}
	}
	
	if "`dtruncate'"!="" {
		local num1 : word 1 of `dtruncate'
		local num2 : word 2 of `dtruncate'
		if "`num2'"=="" local num2 = `num1'
	}
	
	if "`vtruncate'"!="" {
		local nval : word count `vtruncate'
		if `nval'>1 {
			di "{err}{bf:vtruncate()} accepts only one number"
			exit 198
		}
		capture local num1 = `vtruncate'
		if _rc {
			di "{err}{bf:vtruncate()} must be a positive number"
			exit 198
		}
		capture confirm number `num1'
		if _rc {
			di "{err}{bf:vtruncate()} must be a positive number"
			exit 198
		}
		if (`num1' < 0) {
			di "{err}{bf:vtruncate()} must be a positive number"
			exit 198
		}
		local num2 = 0
	}

	sret local trtype = `trtype'
	sret local num1 = `num1'
	sret local num2 = `num2'
end
					//-- spfrommata --//
program SPMAT_spfrommata
/*
	spmat spfrommata <Wname> = <Matamatname> {<Matavecname> | _ID}
		_ID means that spmat spfrommata obtains v for itself 
		via v = data(., "_ID")
*/
	syntax anything(name=eq 			///
		id="<Wname> = <Matname> <vecname>" 	///
		equalok)				///
		[, replace				///
		NORMalize(string)			///
		]

	ParseFrommataEq , eq(`eq') `replace'
	local objname `s(objname)'
	local matname `s(matname)'
	local idvec `s(idvec)'
	local replace = `s(replace)'

	tempname vecname
	ParseIdvec, vecname(`vecname') idvec(`idvec')
						// parse normalize	
	SPMAT_normparse,  `normalize'
	local normalize `s(normalize)'
	
	cap noi mata : _SPMATRIX_spfrommata(	///
		`"`objname'"',			///
		`"`replace'"',			///
		"`normalize'",			///
		`matname',			///
		`vecname')
		
	local rc = _rc
	capture mata mata drop `vecname'
	spmatrix_safe_drop, rc(`rc') objname(`objname')
end

program ParseIdvec
	syntax , vecname(string)	///
		idvec(string)

	if (`"`idvec'"'== "_ID") {
		mata : `vecname' = st_data(.,"`idvec'")
	}
	else {
		mata : `vecname' = `idvec'
	}
end
					//-- ParseTomataEq --//
program ParseTomataEq, sclass
	syntax , eq(string) [replace]
	
	gettoken lhs rhs : eq , parse("=")
	gettoken equal rhs : rhs, parse("=")

	if (`"`equal'"'!="=") {
		ErrorInvalidSyntax
	}

	local n_lhs : list sizeof lhs
	if (`n_lhs'!=2) {
		ErrorInvalidSyntax
	}

	local n_rhs : list sizeof rhs
	
	if (`n_rhs'!=1) {
		ErrorInvalidSyntax
	}

	ConfirmNames , names(`rhs' `lhs')
	local objname `rhs'
	local matname : word 1 of `lhs'
	local idvec : word 2 of `lhs'

	capture mata : _SPMATRIX_assert_object("`objname'")
	if _rc SPMAT_error `objname'
						// check if names exist in both
						// Stata and Mata
	CheckMatanames, matname(`matname') idvec(`idvec')

	sret local objname `objname'
	sret local matname `matname'
	sret local idvec `idvec'
end
					//-- ConfirmNames --//
program ConfirmNames
	syntax , names(string)

	foreach name of local names {
		capture confirm names `name'
		if _rc {
			di as err "invalid name {it:`name'}
			exit 198
		}
	}
end

					//-- ParseFrommataEq --//
program ParseFrommataEq, sclass
	syntax , eq(string) [replace]
	
	gettoken lhs rhs : eq , parse("=")
	gettoken equal rhs : rhs, parse("=")

	if (`"`equal'"'!="=") {
		ErrorInvalidSyntax
	}

	local n_lhs : list sizeof lhs
	if (`n_lhs'!=1) {
		ErrorInvalidSyntax
	}

	local n_rhs : list sizeof rhs
	
	if (`n_rhs'!=2) {
		ErrorInvalidSyntax
	}


	ConfirmNames , names(`rhs' `lhs')
	local objname `lhs'
	local matname : word 1 of `rhs'
	local idvec : word 2 of `rhs'

	CheckEq, objname(`objname')	///
		matname(`matname') 	///
		idvec(`idvec')		///
		`replace'
	local replace = `s(replace)'

	sret local objname `objname'
	sret local matname `matname'
	sret local idvec `idvec'
	sret local replace = `replace'
end

program CheckEq, sclass
	syntax , objname(string)	///
		matname(string)		///
		idvec(string)		///
		[replace]
						// check objname
	capture mata : _SPMATRIX_assert_object("`objname'")
	if (`"`replace'"'=="") {
		if !_rc {
			di "{err}weighting matrix {bf:`objname'} "	///
				"already exists"
			exit 111
		}
		local replace 0
	}
	else {
		if _rc local replace 0		
		else local replace 1	
	}
						// check matname
	capture mata mata describe `matname'		
	if _rc {
		di "{err}matrix `matname' not found"
		exit 498
	}
	capture mata : assert(eltype(`matname')=="real")
	local rc = _rc
	capture mata : assert(orgtype(`matname')=="matrix")
	local rc = `rc' + _rc
	if `rc' {
		di as err "`matname' is not a real matrix" 
		exit 498
	}


						// check idvec
	if (`"`idvec'"'!="_ID") {

		capture mata mata describe `idvec'
		local mid = _rc

		if (`mid') {
			di as err "mata vector `idvec' not found"
			exit 498
		}
		capture mata : assert(eltype(`idvec')=="real")
		local rc = _rc
		capture mata : assert(orgtype(`idvec')== "colvector")
		local rc = `rc' + _rc
		if `rc' {
			di as err "`idvec' is not a real colvector" 
			exit 498
		}
	}
	else if (`"`idvec'"'=="_ID") {
		confirm numeric variable _ID	
		capture assert `idvec' != .
		if _rc {
			di "{err}`idvec' contains missing values"
			exit 416
		}		
	}
						// check if names exist in both
						// Stata and Mata
	CheckMatanames, matname(`matname') idvec(`idvec')

	sret local replace = `replace'
end

program CheckMatanames
	syntax , matname(string)		///
		idvec(string)

	if ("`matname'"=="`idvec'") {
		di "{err}idvec must be different from matname"
		exit 498
	}
end

program ErrorInvalidSyntax
	di as err "invalid syntax"
	exit 198
end
					//-- matafromsp --//
program SPMAT_matafromsp
/*
	spmatrix matafromsp <Mataname> <Mataname> = <Wname>
*/
	syntax anything(name=eq 	///
		equalok			///
		id = "<Matname> <vecname> = <Wname>")

	ParseTomataEq, eq(`eq')
	local objname `s(objname)'
	local matname `s(matname)'
	local idvec `s(idvec)'

	if "`idvec'"!="" mata : `idvec' = _SPMATRIX_getsel("`objname'",1)
	if "`matname'"!="" mata : `matname' = _SPMATRIX_getsel("`objname'",2)
end
					//-- spmatrix clear --//
program SPMAT_clear
	mata : _SPSYS_destroy()
end
					//-- spmatrix drop safely  --//
program spmatrix_safe_drop
	syntax , rc(string)	///
		objname(string)	

	if (`rc') {
		cap spmatrix drop `objname'
		exit `rc'
	}
end
