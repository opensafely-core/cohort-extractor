*! version 1.0.2  23jun2017
program define _unicode_convertfile
	gettoken filefrom 0 :  0
	gettoken fileto 0 : 0, parse(" ,")

	if trim(`"`filefrom'"') == "" {
		di as err "input file required"
		exit(198)
	}

	if trim(`"`fileto'"') == "" {
		di as err "output file required"
		exit(198)
	}
	
	syntax	[, SRCENCoding(string)  				///
		SRCCALLback(string),					///
		DSTENCoding(string), 					///
		DSTCALLback(string), 					///
		TRANSliteration(string),				///
		FALLBack, 						///
		REMOVESIGnature, 					///
		ADDSIGnature, 						///
		REPlace]

	qui cap confirm file `"`filefrom'"'
	if _rc {
		di as err `"file {bf:"`filefrom'"} not found"'
		exit(601)
	}

	local rep = 0
	if "`replace'" != "" {
		local rep = 1
	}
	
	if "`rep'" != "1" {
		qui cap confirm file `"`fileto'"'
		if _rc == 0 {
			di as err `"file {bf:"`fileto'"} already exists, specify {bf:replace} to overwrite"'
			exit(602)
		}
	}
	
	if "`srcencoding'" == "" {
		local srcencoding = "utf-8"
	}

	if "`srccallback'" == "" {
		local srccallback = "stop"
	}
	
	if "`dstencoding'" == "" {
		local dstencoding = "utf-8"
	}
	
	if "`dstcallback'" == "" {
		local dstcallback = "stop"
	}

	if "`fallback'" != "" {
		local fallb = 1
	}
	else {
		local fallb = 0
	}
	
	
	if "`addsignature'" != "" & "`removesignature'" != "" {
		di in red "options {bf:addsignature} and {bf:removesignature} may not be combined"
		exit(184)	
	}

	local sig = 0 
	if "`addsignature'" != "" {
		local sig = 1
	}
	
	if "`removesignature'" != "" {
		local sig = -1
	}

	cap qui mata:checksamefile("`filefrom'", "`fileto'")
	if _rc {
		di as err `"file {bf:"`filefrom'"} can not be converted to the same file"'
		exit(602)
	}

	cap noi mata:ufile_convte("`filefrom'",	/// 
			"`fileto'", 		///
			"`srcencoding'",		/// 
			"`dstencoding'", 		///
			"`srccallback'", 	///
			"`dstcallback'", 	///
			"`transliteration'", 	///
			`fallb', 		///
			`sig')
	if _rc {
		qui cap confirm file `"`filefrom'"'
		if _rc {
			di as err `"error during conversion, file {bf:"`filefrom'"} not written"'
			exit(601)
		}
		else {
			di as err `"file {bf:"`filefrom'"} partially converted to file {bf:"`fileto'"}"' 
			exit(198)
		}
	}
	
	di as txt "{p 0 6 2}"
	di as txt `"note: file {bf:"`filefrom'"} converted to file {bf:"`fileto'"}"' 
end

mata:
void ufile_convte(string scalar filefrom, 
		string scalar fileto, 
		string scalar encodefrom,
		string scalar encodeto,
		string scalar callbackto, 
		string scalar callbackfrom, 
		string scalar transliter,
		real scalar fallback,
		real scalar sig)
{
	real scalar res 
	res = ufileconv(filefrom, 
			fileto, 
			encodefrom,
			encodeto,
			callbackto,
			callbackfrom,
			transliter,
			fallback,
			sig,
			0)
	if(res != 0) {
		exit(error(-1))
	}
}

void checksamefile(string scalar f1, string scalar f2)
{
	real scalar res 
	res = issamefile(f1, f2) 
	if(res != 0) {
		exit(error(-1))
	}	
}
end
