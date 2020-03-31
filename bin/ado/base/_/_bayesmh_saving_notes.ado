*! version 1.0.0  01mar2015
program _bayesmh_saving_notes
	version 14.0
	args replacenote fname
	if (`replacenote') {
		di as txt `"file `fname' not found; file saved"'
	}
	else {
		di as txt `"file `fname' saved"'
	}
end
