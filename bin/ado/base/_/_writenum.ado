*! version 1.0.1  21mar2017
program define _writenum
	version 8

	args filehndl attrib

	if "`.`attrib'.isa'" == "double" {
		if `.`attrib'' < . {
			file write `filehndl' ".`attrib' =  `.`attrib''" _n
			exit					/* EXIT */
		}
	}

	file write `filehndl' ".`attrib' = (.)" _n

end


/*
   Given a file handle and an attribute, writes to filehandle

	.<attrib> = <attrib_value>

   If attrib_value is missing writes,

	.<attrib> = (.)

   Missings cannot be directly assigned to numeric class values because
   the . for missing conflicts with the . as a class name separator.


*/
