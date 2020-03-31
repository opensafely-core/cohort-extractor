*! version 1.1.1  30jul2018
program define export_excel
	version 12

	if ("`c(excelsupport)'" != "1") {
		dis as err `"export excel is not supported on this platform."'
		exit 198
	}

	capture syntax [varlist] using/ [if] [in] [, *]
	if _rc {
		local orig0 `"`macval(0)'"'
		local 0 `"using `macval(0)'"'
		cap syntax using/ [if] [in] [, *]
		if _rc {
			if _rc == 111 {
				dis as err `"variable(s) not defined."'
				exit 111
			}
			local 0 `"`macval(orig0)'"'
			syntax [varlist] using/ [if] [in]		///
				[, SHeet(string asis)			/// 
				SHEETMODify				///
				SHEETREPlace				///
				cell(string)				///
				FIRSTrow(string)			/// 
				DATEstring(string)			///
				MISSing(string)				///
				locale(string)				///
				NOLabel					///
				KEEPCELLFmt				///
				REPLACE]
		}
		else {
			syntax using/ [if] [in]				///
				[, SHeet(string asis)			///
				SHEETMODify				///
				SHEETREPlace				///
				cell(string)				///  
				FIRSTrow(string)			///
				DATEstring(string)			///
				MISSing(string)				///
				locale(string)				///
				NOLabel					///
				KEEPCELLFmt				///
				REPLACE]
		}
	}
	else {
		syntax [varlist] using/ [if] [in]			/// 
			[, SHeet(string asis)				///
			SHEETMODify					///
			SHEETREPlace					///
			cell(string)					///
			FIRSTrow(string)				///
			DATEstring(string)				///
			MISSing(string)					///
			locale(string)					///
			NOLabel						///
			KEEPCELLFmt					///
			REPLACE]
	}
	if (`"`varlist'"'=="") {
		unab varlist : _all
	}

	marksample touse, novarlist

	mata : export_excel_export_file("`touse'")
end
