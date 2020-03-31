*! version 1.0.1  25jan2010
program sem_util
	version 12
	gettoken cmd 0 : 0

	if "`cmd'" == "parse" {
		sem_parse_spec `0'
		exit
	}
	if "`cmd'" == "drop" {
		Drop `0'
		exit
	}

	di as err "unrecognized sem_util subcommand"
	exit 199
end

program Drop
	syntax name(name=mname id="mname")
	mata: rmexternal("`mname'")
end

exit
