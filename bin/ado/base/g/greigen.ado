*! version 3.0.0  03jan2005
program greigen
	// no version

	if _caller() < 8 {
		greigen_7 `0'
		exit
	}

        if _caller() < 9 {
                greigen_8 `0'
                exit
        }

	screeplot `0'
end
