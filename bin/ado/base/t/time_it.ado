*! version 1.0.0  05nov2002
program time_it
	version 8
	set more off
	set tracecode off
	set tracetime on
	capture log close
	log using time_it.log, replace
	set trace on
	capture noisily `0'
	set trace off
	log close
	set more on
	set tracecode on
	set tracetime off
	proc_time time_it.log
end
