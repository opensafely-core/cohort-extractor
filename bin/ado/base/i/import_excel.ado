*! version 1.0.15  20sep2019
program define import_excel
	version 12

	if ("`c(excelsupport)'" != "1") {
		dis as err `"import excel is not supported on this platform."'
		exit 198
	}

	gettoken filename rest : 0, parse(" ,")
	gettoken comma : rest, parse(" ,")

	if (`"`filename'"' != "" & (trim(`"`comma'"') == "," |		///
		trim(`"`comma'"') == "")) {
		local 0 `"using `macval(0)'"'
	}

	capture syntax using/, DESCribe
	if _rc {
		capture syntax using/					///
			[,  ALLSTRING(string) *]
		local fmtstring `"`allstring'"'
		capture syntax using/					///
			[, SHeet(string)				///
			CELLRAnge(string)				///
			FIRSTrow					///
			ALLstring(string)				///
			ALLstring					///
			detail						///
			case(string)					///
			locale(string)					///
			clear]
		if _rc {
		syntax [anything(name=extvarlist id="extvarlist" equalok)] ///
				using/ [,  ALLSTRING(string) *]
		local fmtstring `"`allstring'"'
		syntax [anything(name=extvarlist id="extvarlist" equalok)] ///
			using/						///
			[, SHeet(string)				///
			CELLRAnge(string)				///
			FIRSTrow					///
			ALLstring(string)				///
			ALLstring					///
			detail						///
			locale(string)					///
			clear]
		}
	}
	if ("`allstring'" != "" & "`fmtstring'" != "") {
		opts_exclusive "allstring allstring()"
	}
	mata : import_excel_import_file()
end

