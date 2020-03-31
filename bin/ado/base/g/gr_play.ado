*! version 1.0.1  03jan2008

program gr_play
	version 10.0

	local 00 `0'

	local 0 `0'
	local 0 `0'					// sic
	mata: _gred_maybe_add_grec("0", `"`0'"')

	local curgraph "`._Gr_Global.current_graph_resync'"

	if  "`curgraph'" == "" {
		di as error "No current graph on which to play recording"
		exit 198
	}

	local 0 `0'

	capture confirm file `"`0'"'
	if _rc {
		local 0 `"`:sysdir PERSONAL'grec/`0'"'
		capture confirm file `"`0'"'

		local rc _rc
		if _rc {
			di as error `"{p 0 6} recording `00' not found in"' ///
				" either PERSONAL or working directory{p_end}"
			exit `rc'
		}
	}

	.`curgraph'.RecorderPlay `"`0'"'
end

version 10.0

mata:
void _gred_maybe_add_grec(string scalar localnm, string scalar filenm) {

	string rowvector toks
	string scalar    last_tok

	toks = tokens(filenm, "/")
	toks = tokens(toks[1,cols(toks)], "\")
	last_tok = toks[1,cols(toks)]

	if (strpos(last_tok, "."))
		st_local(localnm, filenm)
	else	st_local(localnm, filenm + ".grec")
}
end
