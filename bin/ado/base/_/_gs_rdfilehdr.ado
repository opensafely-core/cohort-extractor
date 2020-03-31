*! version 1.0.1  14nov2003
program _gs_rdfilehdr
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
	   `"`filetype_id'"'   != "01000"	  |		///
	   `"`filetype_name'"' != "LiveGPH" {
		di as error `"`filename' is not a Stata live graph file"'
		exit 198
	}

							// Graph file header
							// Ignored for now
	file read `filehndl' line
	gettoken gversion   line : line , parse(:)
	gettoken colon      line : line , parse(:)
	gettoken clsversion line : line , parse(:)

	._Gr_Cglobal.gversion	= `gversion'
	._Gr_Cglobal.clsversion	= `clsversion'

							// graph header comments
							// ignored for now

	while `"`line'"' != `"*! end"' {
		file read `filehndl' line
	}
end

exit

/* Graph header contents:

	file read `filehndl' line		// graph classname:
	file read `filehndl' line		// graph familyname:
	file read `filehndl' line		// graph command:
	file read `filehndl' line		// graph command_date:
	file read `filehndl' line		// command_time:
	file read `filehndl' line		// datafile: 
	file read `filehndl' line		// datafile_date:
	file read `filehndl' line		// scheme:
	file read `filehndl' line		// naturallywhite:
	file read `filehndl' line		// xsize:
	file read `filehndl' line		// ysize:
*/
