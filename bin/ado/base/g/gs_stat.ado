*! version 1.0.2  30mar2005
program gs_stat
	if "`2'" != ":" {
		Assert `0'
	}
	else {
		args lhs colon name
		Query me `colon' `name' 
		c_local `lhs' = cond("`me'"=="graph", "exists", "!exists")
	}
end

program Assert
	args status name nothing

	if "`nothing'"!="" {
		di as error "`name' `nothing' invalid name"
		exit 198
	}
	assert "`status'"=="exists" | "`status'"=="!exists"

	Stat type : `name'

	if ("`type'"=="graph" & "`status'"== "exists") |	///
	   ("`type'"==""      & "`status'"=="!exists")	exit

	if "`type'"=="graph" {
		di as error "graph `name' already exists"
		exit 110
	}
	if "`type'"=="" {
		di as error "graph `name' not found"
		exit 111
	}

	/* type is other */
	if "`status'"=="exists" {
		di as err ///
		"class object `name' exists but is not a graph"
	}
	else	di as err ///
		"class object `name' (not a graph) already exists"
	exit 110
end

program Query
	args lhs colon name
	assert "`colon'" == ":"

	Stat type : `name'
	if "`type'"=="graph" | "`type'"=="" {
		c_local `lhs' `type'
		exit
	}
	di as err "{p 0 6 2}"
	di as err "object `name' (not a graph) exists:{break}"
	di as err "`name' cannot be used as a graph name"
	exit 110
end


program Stat
	args lhs colon name

	capture noi confirm name `name'
	if (_rc) exit 198

	if "`.`name'.isa'" == "" 		c_local `lhs' ""
	else {
		if      0`.`name'.isofclass graph_g'	c_local `lhs' "graph"
		else if 0`.`name'.isofclass lgrid'	c_local `lhs' "graph"
		else				c_local `lhs' "other"
	}
end
