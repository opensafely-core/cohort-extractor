*! version 1.0.1  08apr2015
program _prefix_run_error
	version 9
	args rc caller cmdname

	di as err ///
	`"an error occurred when {bf:`caller'} executed {bf:`cmdname'}"'
	exit `rc'
end
exit
