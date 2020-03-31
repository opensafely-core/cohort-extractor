*! version 1.0.0  09jan2008
program _gs_rec_rdfilehdr
	args filename filehndl

							// Stata file header
	file read `filehndl' line
	gettoken stfile        line : line , parse(:)
	gettoken colon         line : line , parse(:)
	gettoken fileversion   line : line , parse(:)
	gettoken colon         line : line , parse(:)
	gettoken filetype_id   line : line , parse(:)
	gettoken colon         line : line , parse(:)
	gettoken filetype_name line : line , parse(:)

	if `"`stfile'"'        != `"StataFileTM"' |		///
	   `"`filetype_id'"'   != "01100"	  |		///
	   `"`filetype_name'"' != "GREC" {
		di as error `"`filename' is not a Graph Recorder file"'
		exit 198
	}

							// Recorder file header
							// Ignored for now
	file read `filehndl' line
	gettoken gversion    line : line , parse(:)
	gettoken colon       line : line , parse(:)
	gettoken clsversion  line : line , parse(:)
	gettoken colon       line : line , parse(:)
	gettoken grecversion line : line , parse(:)

							// header comments
							// ignored for now

	while `"`line'"' != `"*! end"' {
		file read `filehndl' line
	}
end

exit

/* Graph header contents:

	file read `filehndl' line		// graph classname:
	file read `filehndl' line		// graph familyname:
	file read `filehndl' line		// recording date:
	file read `filehndl' line		// recording time:
	file read `filehndl' line		// graph scheme:
	file read `filehndl' line		// naturallywhite:
*/
