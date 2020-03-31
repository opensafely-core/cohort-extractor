*! version 1.0.0  03oct2018
program java, rclass
	version 16.0
	
	local version : di "version " string(_caller()) ":"

	gettoken subcmd 0 : 0, parse(" ,")
	
	local len = length("`subcmd'")

	if "`subcmd'" == bsubstr("query", 1, max(1,`len')) { 
		`version' Query
	}
	else if "`subcmd'" == bsubstr("initialize", 1, max(4,`len')) {
		if ! c(java_initialized) {
			`version' capture noisily jniinit
			if _rc == 0 {
				di "JVM is now up and running"
			}
		}
		else {
			di "nothing to do; the JVM was already initialized"
		}
	}
	else if "`subcmd'" == "set" {    
		`version' Set `macval(0)'
	}
	else {
		display as error `"java: unknown subcommand {cmd:`subcmd'}"'
		exit 198
	}

	return hidden local system_java `"`c(java_system_java)'"'

	return local system_classpath `"`c(java_system_classpath)'"'
	return local plugin_classpath `"`c(java_javacall_classpath)'"'
	return local home `"`c(java_home)'"'
	return local version `"`c(java_version)'"'
	return local vendor `"`c(java_vendor)'"'
	return local heapmax "`c(java_heapmax)'"
	
	return scalar max = .
	return scalar committed = .
	return scalar usage = .
	if (c(java_initialized)) {
		return scalar max = c(java_heap_max)
		return scalar committed = c(java_heap_committed)
		return scalar usage = c(java_heap_usage)
	}
	return scalar initialized = c(java_initialized)
end

program Query
	local version : di "version " string(_caller()) ":"
	`version' query java, detail
end

program Set
	local version : di "version " string(_caller()) ":"
	gettoken subcmd 0 : 0, parse(" ,")

	if `"`subcmd'"' == "home" {
		syntax anything(id="java_home")
		`version' set java_home `anything'
	}
	else if `"`subcmd'"' == "heapmax" {
		syntax anything(id="size")
		`version' set java_heapmax `anything'
	}
	else {
		display as error `"java set: unknown subcommand {cmd:`subcmd'}"'
		exit 198
	}
end
