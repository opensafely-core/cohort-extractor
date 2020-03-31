*! version 1.0.0  22feb2015
program _bayesmh_chk_corrlag
	args tocorrlag colon corrlag mcmcsize
	if `corrlag' > `mcmcsize'/2 {
		local corrlag = floor(`mcmcsize'/2)
		_bayesmh_note_maxcorrlag `corrlag'
	}
	c_local `tocorrlag' `corrlag'
end
