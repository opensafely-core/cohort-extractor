*! version 1.0.8  30apr2015
program define import_haver
	version 12

	if ("`c(os)'" != "Windows") {
		dis as err "import haver is not supported on this platform."
		exit 198
	}

	capture syntax anything(name=seriesdblist id="seriesdblist"),	///
		DEScribe [DETail SAVing(string)]
	if _rc {
		capture syntax, FROMMEMory [FIn(string asis)		///
			FWithin(string asis) TVar(string)		///
			HMissing(string) case(string) AGGMethod(string) clear]
		if _rc {
		syntax anything(name=seriesdblist id="seriesdblist")	///
			[, FROMMEMory FIn(string asis)			///
			FWithin(string asis) TVar(string)		///
			HMissing(string) case(string) AGGMethod(string) clear]
		}
	}
	mata : import_haver_import_file()
end

