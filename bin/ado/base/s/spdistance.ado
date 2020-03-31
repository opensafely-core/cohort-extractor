*! version 1.0.4  09sep2019

/*
	spdistance <#_id> <#_id> [, 
		coordsys(planar | latlong [, miles])

	    saved results 
		scalar r(dist)      = <distance between>
		macro  r(coordsys)  = {"planar" | "latlong"}
		macro  r(dunits)    = {"miles" | "kilometers") if latlong
*/

program spdistance, rclass 
	version 15

	// -------------------------------------------------- parse ---
	syntax anything(name=idvals id="_ID values") ///
	       [, coordsys(string) ]


	getidvals idval1 idval2 : `"`idvals'"'

	if (strtrim("`coordsys'")!="") {
		parsecoordsys coordsys coordunits : `"`coordsys'"'
		di as txt "{p 2 3 2}"
		di as txt "(`coordsys' specified; distance measured in"
		di as txt "`coordunits')"
		di as txt "{p_end}"
	}
	else {
		local coordsys ""
	}
	
	// ----------------------------------------- get spset info ---

	vsp_validate noshapefile
	local idvar     `r(sp_idvar)'
	local cx        `r(sp_cx)'
	local cy        `r(sp_cy)'
	if ("`coordsys'"=="") {
		local coordsys `r(sp_coord_sys)'
		if ("`coordsys'" != "planar") {
			local coordunits `r(sp_coord_sys_dunit)'
		}
		else {
			local coordunits "planar units"
		}
		di as txt "{p 2 3 2}"
		di as txt "(data currently use"
		if ("`coordsys'"=="planar") {
			di as txt "planar coordinates)" 
		}
		else {
			di as txt "latitude and longitude)"
		}
		di as txt "{p_end}"
	}

	// ------------------------------ verify locations recorded ---
	if ("`cx'"=="" | "`cy'"=="") {
		di as err "location not recorded in Sp data"
		exit 459
		// NotReached
	}
			

	// ----------------------------- load all values in scalars ---
	tempname id1 cx1 cy1
	tempname id2 cx2 cy2
	tempname dist 

	getcoord `id1' `cx1' `cy1' : `idval1' `idvar' `cx' `cy'
	getcoord `id2' `cx2' `cy2' : `idval2' `idvar' `cx' `cy'
	

	// ------------------------------------- calculate distance ---
	mata: maindistance("`dist'",          ///
		           "`cx1'", "`cy1'",  ///
		           "`cx2'", "`cy2'",  ///
		           "`coordsys'", "`coordunits'")
	return scalar distance = `dist' 
	return local  coordsys   `coordsys'
	return local    dunits   `coordunits'

	// ----------------------------------------- present output ---

	if ("`coordsys'"=="planar") {
		local hdr "(x, y) (planar)"
	}
	else {
		local hdr "(longitude, latitude)"
	}

	di as txt
	di as txt _col(10) "_ID" _col(20) "`hdr'"
	di as txt "  {hline 39}" 

	vecform vf : `cx1' `cy1'
	di as txt "  " %10.0g `id1' _col(20) "`vf'"

	vecform vf : `cx2' `cy2'
	di as txt "  " %10.0g `id2' _col(20) "`vf'"
	di as txt "  {hline 39}" 

	di as text "    distance" _col(20) `dist' " `coordunits'"
end


program getidvals 
	args midval1 midval2 colon anything

	gettoken idval1 anything : anything 
	gettoken idval2 anything : anything 
	if (strtrim("`anything'") != "") {
		local anything = strtrim("`anything'")
		di as err "{bf:`anything'} found where nothing expected"
		exit 198
	}
	confirm_idval `idval1'
	confirm_idval `idval2'

	c_local `midval1' `idval1'
	c_local `midval2' `idval2'
end
	
program confirm_idval 
	args idval

	if (strtrim("`idval'") == "") {
		di as error "nothing found where _ID value expected"
		exit 198
	}

	capture confirm number `idval'
	if (_rc) {
		di as err `"{bf:`idval'} found where _ID value expected"'
		exit 198
	}
end


/*
	getcoord sid sx sy : <#_idval> _IDvarname _CXvarname _CYvarname

	sid, sx, sy scalars, set to:

		scalar sid = <#_idval>
		scalar sx  = value of _CXvarname for _IDvarname==<#_idval>
		scalar sy  = value of _CYvarname for _IDvarname==<#_idval>
*/

program getcoord 
	args sid sx sy colon idval idvar cx cy

	scalar `sid' = `idval'
	quietly summarize `cx' if `idvar'==`idval' 
	if (r(N)) {
		scalar `sx' = r(min)
		quietly summarize `cy' if `idvar'==`idval'
		scalar `sy' = r(min)
		exit
	}
	di as error "`idvar'==`idval' not found"
	exit 111
end
	


program vecform
	args macname colon cx cy	// numeric scalars

	local px = strtrim(string(`cx', "%9.0g"))
	local py = strtrim(string(`cy', "%9.0g"))
	local r  = "(`px', `py')"
	c_local `macname' `r'
end
		

program parsecoordsys 
	args coordsys coordunits colon str

	/* 
		str :=   planar
			 latlong
                         latlong, miles
	*/

	local str = strtrim(`"`str'"')
	if ("`str'"=="planar") {
		c_local `coordsys' planar 
		c_local `coordunits' "planar units"
		exit
	}
	local 0 `"`str'"'
	capture syntax anything [, MILES]
	if ("`anything'" != "latlong") {
		parsecoordsys_invalid `"`str'"'
		// NotReached
	}
	local units = cond("`miles'"=="", "kilometers", "miles")
	c_local `coordsys'   latlong
	c_local `coordunits' `units'
end 


program parsecoordsys_invalid
	args str

	di as err `"{bf:coordsys(`str')} invalid"'
	di as err "    Allowed are"
	di as err "        {bf:coordsys(planar)}"
	di as err "        {bf:coordsys(latlong)}"
	di as err "        {bf:coordsys(latlong, miles)}"
	exit 198
end



version 15
set matastrict on


local SS        string scalar
local RS        real   scalar 
local NumScalar `SS'


mata:


void maindistance(`NumScalar' cresult, 
	         `NumScalar' cx1, `NumScalar' cy1, 
	         `NumScalar' cx2, `NumScalar' cy2, 
	         `SS'   coordsys,  `SS'       coordunits) 
{
	`RS'	x1, y1
	`RS'    x2, y2
	`RS'	dist 
	real matrix	Z

	pragma unset dist

	x1 = st_numscalar(cx1)
	y1 = st_numscalar(cy1)

	x2 = st_numscalar(cx2)
	y2 = st_numscalar(cy2)

	Z = ( x2, y2 \	///
		x1, y1)

	if (coordsys=="planar") { 
		_SPMATRIX_Euclidean_dist(Z, 2, dist)
		dist = dist[1,2]
	}
	else {
		_SPMATRIX_Haversine_dist("degrees", coordunits, Z, dist)
		dist = dist[1,2]
	}

	st_numscalar(cresult, dist)
}

end
