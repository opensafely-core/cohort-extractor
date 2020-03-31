*! version 1.0.3  05mar2019
program _vce_parse, rclass
	version 10
	_on_colon_parse `0'
	local 0		`"`s(before)'"'
	local user	`"`s(after)'"'

	syntax [varname(default=none)],	[	///
		OPTlist(namelist)		///
		ARGOPTlist(namelist)		///
		PWallowed(namelist)		///
		OLD_is_ok			///
		NOARGOPT_is_ok			///
	]
	local touse `varlist'

	tempname o a
	.`o' = ._optlist.new
	local optlist : list uniq optlist
	foreach name of local optlist {
		.`o'.addopt `name'
	}
	.`a' = ._optlist.new
	local argoptlist : list uniq argoptlist
	foreach name of local argoptlist {
		.`a'.addopt `name'
	}
	local OPTNAMES `"`.`o'.dumpnames'"'
	local ARGOPTNAMES `"`.`a'.dumpnames'"'
	local AND : list OPTNAMES & ARGOPTNAMES
	if `:list sizeof AND' {
		di as err "vcetype '`:word 1 of `AND''' specified twice"
		exit 198
	}

	local pwallowed : list uniq pwallowed
	local pwlist robust cluster
	foreach n of local pwallowed {
		local lc = lower("`n'")
		local pwlist `pwlist' `lc'
	}

	if "`old_is_ok'" != "" {
		local ROBUST	robust
		if `:list ROBUST in OPTNAMES' {
			local robust Robust
		}
		local CLUSTER	cluster
		if `:list CLUSTER in ARGOPTNAMES' {
			local cluster CLuster(varname)
		}
	}

	local 0	`"`user'"'
	syntax [fw aw pw iw] [,		///
		VCE(string asis)	///
		`robust'		///
		`cluster'		///
	]

	if `"`vce'"' != "" {
		gettoken name args : vce, parse(" ,")
		local args : list retok args
		capture ParseVCE `o' `a' , `name'
		if c(rc) {
			di as err "vcetype '`name'' not allowed"
			exit 198
		}
		local name `r(vce)'
		if "`weight'" == "pweight" & !`:list name in pwlist' {
			di as err "pweights are not allowed with vce(`name')"
			exit 198
		}
		return add
		if `"`robust'"' != ""	///
		 & !inlist("`name'","","robust","eim","oim","cluster") {
			opts_exclusive "`robust' vce(`name')"
		}
		if "`name'" == "cluster" {
			if `"`args'"' == "" {
				di as err "invalid vce(cluster) option"
				exit 198
			}
			confirm var `args'
			unab args : `args'
			local markout `args'
			if "`cluster'" != "" {
				if !`:list args == cluster' {
					di as err ///
"options cluster() and vce(cluster) are in conflict"
					exit 100
				}
			}
		}
		else if "`cluster'" != "" & !inlist("`name'","eim","oim") {
			opts_exclusive "cluster() vce(`name')"
		}
		if `"`args'"' != "" {
			if ! `:list name in ARGOPTNAMES' {
				di as err "invalid vce() option"
				exit 198
			}
			return local vceargs `"`:list retok args'"'
		}
		else if `:list name in ARGOPTNAMES' {
			if "`noargopt_is_ok'" == "" {
				di as err "invalid vce() option"
				exit 198
			}
		}
	}
	else {
		if "`weight'" == "pweight" | "`robust'" != "" {
			local vce robust
		}
		if "`cluster'" != "" {
			local vce cluster
			local args `cluster'
			local markout `cluster'
		}
		return local vce	`"`vce'"'
		return local vceargs	`"`args'"'
	}
	if "`return(vce)'" != "" {
		if `"`return(vceargs)'"' != "" {
			local ss " "
		}
		return local vceopt `"vce(`return(vce)'`ss'`return(vceargs)')"'
	}
	if "`return(vce)'" == "cluster" {
		return local cluster `return(vceargs)'
	}
	if inlist("`return(vce)'", "robust", "cluster") {
		return local robust robust
	}
	if "`touse'" != "" {
		if "`markout'" != "" {
			markout `touse' `markout', strok
		}
	}
end

program ParseVCE, rclass
	gettoken O 0 : 0, parse(" ,")
	gettoken A 0 : 0, parse(" ,")
	local OPTSPECS `"`.`O'.dumpoptions' `.`A'.dumpoptions'"'
	local OPTNAMES `"`.`O'.dumpnames' `.`A'.dumpnames'"'
	syntax [, `OPTSPECS']
	foreach OPT of local OPTNAMES {
		if `"``OPT''"' != "" {
			return local vce `OPT'
			continue, break
		}
	}
end
exit
