*! version 1.0.0  09apr2007
program _vce_cluster, sclass
	version 10
	syntax name(name=cmd),			///
		groupvar(varname)		///
		newgroupvar(name)		///
		groptname(name)			///
		vce(string asis)		///
		[ CLuster(varname) ]
	// ParseVCE returns the following in s():
	//
	// s(cluster)	-- varname from cluster() suboption
	// s(vce)	-- -vce()- option without the -cluster()- suboption
	ParseVCE `cmd' `vce'
	local cluster `cluster' `s(cluster)'
	if `:list sizeof cluster' == 2 {
		local cluster : list uniq cluster
		if `:list sizeof cluster' == 2 {
			// let someone else complain that the two -cluster()-
			// options don't match
			exit
		}
	}
	sreturn local idopt idcluster(`newgroupvar')
	if `:list sizeof cluster' == 0 {
		local type : type `groupvar'
		quietly gen `type' `newgroupvar' = `groupvar'
		sreturn local clopt cluster(`groupvar')
		sreturn local gropt `groptname'(`newgroupvar')
	}
	else {
		local type : type `cluster'
		quietly gen `type' `newgroupvar' = `cluster'
		sreturn local clopt cluster(`cluster')
		sreturn local gropt `groptname'(`groupvar')
		sreturn local bsgropt group(`groupvar')
	}
end

program ParseVCE, sclass
	gettoken cmd 0 : 0
	quietly syntax [anything(equalok)]	///
		[if] [in] [fw pw iw aw] [,	///
			CLuster(varname)	///
			IDcluster(name)		///
			*			///
		]
	if `:length local weight' {
		di as err ///
`"`cmd' does not allow weights inside the vce() option"'
		exit 198
	}
	if `: length local idcluster' {
		di as err ///
`"`cmd' does not allow option idcluster() inside the vce() option"'
		exit 198
	}
	sreturn local cluster `cluster'
	local vce `"`anything'"'
	if `:length local if' {
		local vce `"`vce' `if'"'
	}
	if `:length local in' {
		local vce `"`vce' `in'"'
	}
	if `:length local options' {
		local vce `"`vce', `options'"'
	}
	sreturn local vce `"vce(`vce')"'
end
exit
