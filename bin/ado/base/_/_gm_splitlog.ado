*! version 1.0.0  16nov2006

// Returns the prefix and suffix portions of an object name, where the prefix
// is largest portion where the last object can be logged to (has an __LOG
// member variable) and the suffix is whatever remains.

program _gm_splitlog
	version 10

	args premac sufmac colon origname

	local namesp : subinstr local origname "." " " , all
	local ct : list sizeof namesp
	tokenize `namesp'
	local dot ""
	while "`.`name'.__LOG.isa'" != "array" & `ct' > 0 {
		local suffix "``ct''`dot'`suffix'"
		local dot "."
		local `ct--' ""
		local name `*'
		local name : subinstr local name " " "." , all
	}
			// Found closest container, but
			// do not look for logs within terminal classtypes

	local terminals "bygraph_g"		
	
	gettoken prefix bsuffix : origname , parse(" .")
	while "`bsuffix'" != "" {

		if `:list posof "`.`prefix'.classname'" in terminals' {
			local name "`prefix'"
			gettoken dot suffix : bsuffix , parse(" .")
			continue, break
		}

		gettoken dot   bsuffix : bsuffix , parse(" .")
		gettoken nxtnm bsuffix : bsuffix , parse(" .")
		local prefix "`prefix'.`nxtnm'"
	}

	c_local `premac' "`name'"
	c_local `sufmac' "`suffix'"
end
