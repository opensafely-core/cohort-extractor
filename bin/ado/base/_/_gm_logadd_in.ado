*! version 1.1.1  23aug2007
program _gm_logadd_in
	version 10
				// Log something into a designated object
				// Unlike _gm_log, does not log to schemes.

	gettoken logobj tolog : 0

	if ("`.`logobj'.__LOG.isa'" != "array" )  exit		// Exit

	local undo "`._Gr_Global.edit_graph'.undo"

	.`logobj'.__LOG.Arrpush `tolog'

	if 0`.`undo'.isofclass _gm_undo' {
		.`undo'.add `macval(logobj)'.__LOG 1
	}

	if 0`_gedi(recording)' {
		.`._Gr_Global.edit_graph'.recorder.Arrpush `0'
	}

end

exit

NOTE:  Cannot check if the edit is valid, do not call this program with an
       invalid editing command.
<end>
