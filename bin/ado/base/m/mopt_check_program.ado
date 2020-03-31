*! version 1.0.0  07feb2008
program mopt_check_program
	version 10
	args name
	capture confirm name `name'
	if c(rc) {
		di as err "unrecognized command:   `name' invalid command name"
		exit 199
	}
	capture which `name'
	if !c(rc) {
		exit
	}
	capture program list `name'
	if c(rc) {
		di as err "unrecognized command:   `name'"
		exit 199
	}
end
