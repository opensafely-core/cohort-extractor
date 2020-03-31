*! version 1.0.8  10sep2019

/*
	unicode analyze   <filespec>   [, ...]

	unicode    encoding  <encoding>
	unicode   translate <filespec> [, ...]
	unicode retranslate <filespec> [, ...]

	unicode restore     <filespec>
*/

program z_unicodetrans, rclass
	version 14 

	if (_N | c(k)) {
		capture noisily error 4
		error_syntax
		exit 4
		/*NOTREACHED*/
	}

	preserve /*sic*/
		
	gettoken cmd 0 : 0, parse(" ,")

	getcmd xeqcmd : "`cmd'"

	`xeqcmd' `0'
	return add 
end

program getcmd 
	args xeqcmd colon cmd
	assert "`colon'"==":"


	local l = strlen("`cmd'") 
	if ("`cmd'"==substr("analyze", 1, max(2, `l'))) {
		c_local `xeqcmd' "unicode_analyze"
		exit
	}
	if ("`cmd'"==substr("encoding", 1, max(2, `l'))) {
		c_local `xeqcmd' "unicode_encoding"
		exit
	}
	if ("`cmd'"=="erasebackups") {
		c_local `xeqcmd' unicode_erasebackups
		exit
	}
	if ("`cmd'"==substr("translate", 1, max(2, `l'))) {
		c_local `xeqcmd' "unicode_translate"
		exit
	}
	if ("`cmd'"==substr("retranslate", 1, max(4, `l'))) {
		c_local `xeqcmd' "unicode_retranslate"
		exit
	}
	if ("`cmd'"==substr("restore", 1, 7)) {
		c_local `xeqcmd' "unicode_restore"
		exit
	}


	if ("`cmd'"!="") {
		di as err "{bf:`cmd'} is an invalid {bf:unicode} subcommand"
		local rc = 197
	}
	else {
		di as err "nothing found where {bf:unicode} subcommand expected"
		local rc = 198 
	}

	error_syntax
	exit `rc'
end


program error_syntax
	di as err _col(5) "{bf:unicode} syntax is"
	di as err _col(9) "{bf:unicode analyze}      {it:filespec}"
	di as err _col(9) "{bf:unicode encoding set} {it:encoding}"
	di as err _col(9) "{bf:unicode translate}    {it:filespec} [, ...]"
	di as err _col(9) "{bf:unicode retranslate}  {it:filespec} [, ...]"
	di as err _col(9) "{bf:unicode restore}      {it:filespec} [, ...]"
	di as err
	di as err "{p 4 4 2}"
	di as err "{bf:analyze} and [{bf:re}]{bf:translate} can handle Stata"
	di as err "datasets as well as text files such as do-files,"
	di as err "ado-files, help files, {it:etc.}"
	di as err
	di as err "{p 4 4 2}"
	di as err "There must be no data in memory."
	di as err "See {help unicode:help unicode}."
	di as err "{p_end}"
	/* DO NOT EXIT; CALLER DOES THAT */
end

					/* unicode			*/
/* -------------------------------------------------------------------- */


/* -------------------------------------------------------------------- */
					/* unicode restore		*/
					/* unicode analyze		*/
					/* unicode translate		*/

program unicode_restore, rclass
	syntax anything(id="filename or pattern") [,	///
		BACKupdir(string)			///
		REPLACE					///
		]

	local cmd "unicode restore"
				/* strip quotes:		*/
	local anything `anything'

	Certify_Filespec `"`anything'"'
	Get_Backupdir backdir  : "`cmd'" `"`backupdir'"'

	mata: unicode_restore(`"`anything'"', `"`backdir'"', 	///
				"`replace'"!="")
	return add
end


program unicode_analyze, rclass
	syntax anything(id="filename or pattern") [,	///
		BACKupdir(string)			///
	      noDATA					///
		REdo					///
		]

	local cmd "unicode analyze"
				/* strip quotes:		*/
	local anything `anything'

	Certify_Filespec `"`anything'"'
	Get_Backupdir backdir  : "`cmd'" `"`backupdir'"'

	mata: unicode_analyze(`"`anything'"', `"`backdir'"', "`redo'", "`data'")
	return add
end


program unicode_translate, rclass
	syntax anything(id="filename or pattern") [,	///
		BACKupdir(string)			///
	      noDATA					///
		ENcoding(string)			///
		TRANSUTF8				///
		INVALID					///
		INVALIDdtl(string)			///
		/* REPLACE */				///
		]

	local cmd "unicode translate"
				/* strip quotes:		*/
	local anything `anything'

	Certify_Filespec `"`anything'"'
	Get_Encoding  encoding : "`cmd'" "`encoding'" 
	Get_Backupdir backdir  : "`cmd'" `"`backupdir'"'
	Get_Invalid   invalid  : "`cmd'" "`invalid'" "`invaliddtl'"


	mata: unicode_translate(`"`anything'"', 	   	///
				`"`backdir'"', "`encoding'", 	///
				"`transutf8'",   "`invalid'", 	///
				"`replace'"!="", 0, "`data'")
	return add
end

program unicode_retranslate, rclass
	syntax anything(id="filename or pattern") [,	///
		BACKupdir(string)			///
	      noDATA					///
		ENcoding(string)			///
		TRANSUTF8				///
		INVALID					///
		INVALIDdtl(string)			///
		REPLACE					///
		]

	local cmd "unicode translate"
				/* strip quotes:		*/
	local anything `anything'

	Certify_Filespec `"`anything'"'
	Get_Encoding  encoding : "`cmd'" "`encoding'" 
	Get_Backupdir backdir  : "`cmd'" `"`backupdir'"'
	Get_Invalid   invalid  : "`cmd'" "`invalid'" "`invaliddtl'"


	mata: unicode_translate(`"`anything'"',		   	///
				`"`backdir'"', "`encoding'", 	///
				"`transutf8'",   "`invalid'", 	///
				"`replace'"!="", 1, "`data'")
	return add
end
	


					/* unicode translate		*/
					/* unicode analyze		*/
/* -------------------------------------------------------------------- */


/* -------------------------------------------------------------------- */
					/* unicode encoding		*/


program unicode_encoding
	gettoken subcmd 0 : 0
	if ("`subcmd'" != "set") { 
		capture noi error 198
		error_syntax
		exit 198
	}
		
	syntax anything(id="encoding" equalok)

				/* strip quotes:		*/
	local anything `anything'

	Get_Encoding  encoding : "unicode encoding" "`anything'" 
end


					/* unicode encoding		*/
/* -------------------------------------------------------------------- */

/* -------------------------------------------------------------------- */
					/* unicode erasebackups		*/
program unicode_erasebackups
	syntax , badidea

	mata: unicode_erasebackups()
end

					/* unicode erasebackups		*/
/* -------------------------------------------------------------------- */

/* -------------------------------------------------------------------- */
					/* Certify_Filespec		*/

program Certify_Filespec
	args filespec 

	if (strpos(`"`filespec'"', "/")==0 & ///
	    strpos(`"`filespec'"', "\")==0) {
		exit
	}

	di as err "{it:filespec} invalid"
	di as err "{p 4 4 2}"
	di as err `"You specified {bf:`filespec'}."'
	di as err "All files to be analyzed or translated must be in the"
	di as err "current (working) directory (folder)." 
	di as err "Use the {bf:cd} command to change directories."
	di as err "{p_end}"
	exit 198
end
	

/* -------------------------------------------------------------------- */
					/* Get_Encoding			*/
				
program Get_Encoding
	args encoding colon cmdname option

	if ("`option'" != "") {
		Certify_Encoding "`option'"
		if ("`cmdname'" == "unicode encoding") {
			global UnicodeEncoding "`option'"
			di as txt "  (default encoding now `option')"
			c_local `encoding' "`option'"
		}
		else {
			di as txt "  (using `option' encoding)"
			c_local `encoding' "`option'"
		}
		exit
	}

	if ("$UnicodeEncoding" != "") {
		di as txt "  (using $UnicodeEncoding encoding)"
		c_local `encoding' "$UnicodeEncoding"
		exit
	}

	di as err "encoding not set"
	di as err "{p 4 4 2}"
	di as err "Before using {bf:unicode translate}, you must"
	di as err "set the character encoding you believe is being used,"
	di as err "such as {bf:latin1}.  There are lots of encodings."
	di as err "You set the encoding using the {bf:unicode encoding set}"
	di as err "command."
	di as err "You can set and reset the encoding and repeat"
	di as err "the {bf:unicode translate} command to see"
	di as err "which works best."
	di as err "{p_end}"
	exit 198
end

program Certify_Encoding
	args encoding 

	mata: st_local("x", strofreal(isvalidconverter("`encoding'")))

	if (`x'==1) {
		exit
	}

	di as err "`encoding' invalid encoding"
	exit 198

end

/* -------------------------------------------------------------------- */
					/* Get_Backupdir		*/


program Get_Backupdir
	args backdir colon cmd option 

	if ("`option'" != "") {
		local option = subinstr(`"`option'"', "\", "/", .)
		local l = strlen(`"`option'"') 
		if substr(`"`option'"', `l', 1) == '/') {
			local option = substr(`"`option'"', 1, `l'-1)
		}
		c_local `backdir' `"`option'"'
	}
	else {
		c_local `backdir' 
	}
end
		
					/* Get_Backupdir		*/
/* -------------------------------------------------------------------- */

/* -------------------------------------------------------------------- */
					/* Get_Invalid			*/



program Get_Invalid 
	args invalid colon cmd invalid invaliddtl 

	if ("`invaliddtl'" != "") {
		if ("`invaliddtl'"=="ignore") {
			c_local invalid ignore 
			exit
		}
		if ("`invaliddtl'"=="mark") {
			c_local invalid mark 
			exit
		}
		if ("`invaliddtl'"=="escape") {
			c_local invalid escape
			exit
		}
		error_invalid "`invaliddtl'"
		/*NOTREACHED*/
	}
	if ("`invalid'" != "") {
		c_local invalid escape
		exit
	}
	c_local invalid 
end


program error_invalid
	args 	op
	di as err "invalid(`op') not allowed"
	exit 198
end


					/* Get_Invalid			*/
/* -------------------------------------------------------------------- */


/* ==================================================================== */
					/* MATA CODE			*/



version 14

set matastrict on
	
local DefaultBackdir	"./bak.stunicode"
local OkaySubDirname	"status.stunicode"

local UVersion	1

/* -------------------------------------------------------------------- */
					/* Shorthands for types		*/
local RS	real scalar
local RR	real rowvector
local RC	real colvector
local RM	real matrix

local SS	string scalar
local SR	string rowvector
local SC	string colvector
local SM	string matrix


/* -------------------------------------------------------------------- */
					/* Derived types 		*/
local RetcodeS	`RS'

local booleanS	`RS'

local booleanR	`RR'
local 	True	1
local 	False	0


local FildesS	`RS'

set matastrict on

/* -------------------------------------------------------------------- */
					/* Derived type:  Transcode	*/

/* Transcodes are ordered, OK_Ascii < OK_Utf8 < ... < T_needed */

local TranscodeS	`RS'
local TranscodeR	`RR'
local OK_Ascii		1
local OK_Utf8		2
/* OK_Binary */
local T_suc		4
local T_sub 		5
local T_fail		6

local T_needed		7

local TranscodeInit	0
local TranscodeMax	7


local Suffix_OK_Ascii	.oka
local Suffix_OK_Utf8	.oku
local Suffix_T_suc	.t


local ExTranscodeS	`TranscodeS'
local OK_Binary		3

/* -------------------------------------------------------------------- */
					/* Derived type:  Transcode	*/
/* dtasubcode is sub-category of T_fail for files with *.dta extension  */
/* 1 - a dataset has too many variables    */
/* 2 - a file can not be used for some reason */				
local T_dta_toobig 	1
local T_dta_fail	2
local DtaSubTranscodeS	`RS'
local DtaSubTranscodeR	`RR'


mata:
`booleanS' Transcode_OK(`TranscodeS' tc)
{
	return(tc==`OK_Ascii' | tc==`OK_Utf8')
}

void Transcode_MustBe_OK(`TranscodeS' tc)
{
	if (Transcode_OK(tc)) return 
	errprintf("assertion is false 1\n") 
	exit(9)
}

end


					/* Derived type:  Transcode	*/
/* -------------------------------------------------------------------- */


/* -------------------------------------------------------------------- */
					/* Derived type:  FileStatus  	*/

/* FileStatus is unordered; they are just codes */

local FileStatusS `RS'
local FileStatusR `RR'

local 	File_U			0	/* transitory code	*/
local   File_U_validA 		1	/* ./bak/=.oka exists 	*/
local   File_U_validU 		2	/* ./bak/=.oku exists 	*/
local	File_T			3	/* ./bak/=    exists 	*/
local 	File_irrel		4	

local   File_U_dta		5
local   File_U_txt		6


					/* Derived type:  FileStatus  	*/
/* -------------------------------------------------------------------- */
local ChksumContentsName	chksumcntsdf
local ChksumContents		struct `ChksumContentsName'
local ChksumCOntentsS		`ChksumContents' scalar
mata:
`ChksumContents' {
	`TranscodeS' 	tc
	`SS' 		datetime
	`RR'		chksum1		/* (chksum, len) 	*/
	`RS'		chksum2 	/* only if tc==T_suc	*/
}
end

/* -------------------------------------------------------------------- */
					/* Derived type:  Textfile  	*/
local MAXLINELEN	(100*1024*1024)
local BUFLEN		1024
local LF		char(10)
local CR		char(13)

local Textfilename	textfiledf
local Textfile		struct `Textfilename'
local TextfileS		`Textfile' scalar

mata:
`Textfile' {
	`FildesS'	fh
	`booleanS'	isopen
	`SS' 		buf
	`RS'		len	/* kept up to date */
	`RS'		lino
}
end


					/* Derived type:  FileStatus  	*/
/* -------------------------------------------------------------------- */

/* -------------------------------------------------------------------- */
					/* Utility			*/

local OpenQuote		("`" + `"""')
local CloseQuote	(`"""' + "'")



/* -------------------------------------------------------------------- */
					/* Derived type:  Problem	*/


local Problemname	problemdf
local Problem		struct `Problemname'
local ProblemS		`Problem' scalar

mata:

`Problem' {
	/* ----------------------------- provided by ado ado file	*/
	`booleanS'	translate
	`SS'		backdir
	`SS'		filespec
	`SS'		encoding
	`SS'		invalid		
	`booleanS'	reanalyze
	`booleanS'	retranslate
	`booleanS'	transutf8
	`booleanS' 	replace
	`booleanS'	data

	/* ----------------------------- derived 			*/
	`booleanS'	filespec_explicit
	`SC'		filelist
	`FileStatusR'	filestatus
	`booleanS'	inv_fail, inv_ignore, inv_mark, inv_esc
	`SR'		origvarnames
	`SS'		tmpfn
	/* ------------------------------ build during 			*/
	`RS'		files_skipped
	`TranscodeR'	finalstatus
	`DtaSubTranscodeR'	dtasubstatus

	`SM'		utf8_example
		
}
void `Problemname'_init(`ProblemS' pr) 
{
	pr.translate   = `False' 	/* -unicode translate-		*/
	pr.retranslate = `False' 	/* -unicode retranslate-	*/
	pr.reanalyze   = `False' 	/* -unicode analyze, redo-	*/
	pr.backdir     = "`DefaultBackdir'"
	pr.filespec    = "" 
	pr.encoding    = "" 
	pr.transutf8   = `False'
	pr.replace     = `False' 
	pr.invalid     = ""
	pr.data        = `True'
	pr.inv_fail = pr.inv_ignore = pr.inv_mark = pr.inv_esc = `False'

	pr.utf8_example = J(0, 2, "")
	pr.files_skipped = 0 

	pr.tmpfn = st_tempfilename()
}

 
					/* Derived type:  Problem	*/
/* -------------------------------------------------------------------- */







/* ==================================================================== */
					/* CODE BEGINS			*/






/* -------------------------------------------------------------------- */
					/* Entry points 		*/

/*
	unicode_restore(filespec, backdir, replace)

	    Entry point for -unicode restore-
*/


void unicode_restore(`SS' filespec, `SS' backdir, `booleanS' replace)
{
	`RS'		i
	`RetcodeS'	rc
	`ProblemS'	pr

	`Problemname'_init(pr) 

	pr.filespec    = filespec 
	if (backdir!="") {
		pr.backdir     = backdir 
	}
	pr.encoding    = ""
	pr.translate   = `False' 
	pr.retranslate = `False'
	pr.transutf8   = `False'
	pr.replace     = replace

	pr.filespec_explicit = filespec_is_explicit(pr.filespec) 

	if (!direxists(pr.backdir)) {
		errprintf("{txt}no originals to restore\n") 
		errprintf("{p 4 4 2}\n") 
		errprintf("{bf:unicode restore} restores backups of\n") 
		errprintf("of translated files.  You haven't\n") 
		errprintf("translated any files yet.\n") 
		errprintf("{p_end}\n") 
		exit(459)
	}
	setup_backdir(pr)

	get_filelist(pr) 
	get_filestatus(pr, `True') 
	restore_set_filelist(pr) 
	/* pr.flistlist now contains files to be restored */

	if (length(pr.filelist)==0) {
		printf("{txt}no files to restore\n") 
		printf("{p 4 4 2}\n") 
		printf("No files have yet been translated or\n") 
		printf("or the original files have been previously restored.\n") 
		printf("{p_end}\n") ;
		return
		/*NOTREACHED*/
	}


	for (i=1; i<=length(pr.filelist); i++) {
		if ((rc=verify_backup(pr, pr.filelist[i], pr.replace))) {
			errprintf("no files restored\n") 
			exit(rc)
			/*NOTREACHED*/
		}
	}

	for (i=1; i<=length(pr.filelist); i++) {
		printf("{txt}   restoring %s\n", pr.filelist[i])
		restore_and_erase_backupfile(pr, pr.filelist[i]) 
	}
}

/*
	(void) unicode_analyze(filespec, backdir, redo, data)

	    Entry point for -unicode analyze-
*/

void unicode_analyze(`SS' filespec, `SS' backdir, `SS' redo, `SS' data)
{
	`ProblemS'	pr

	`Problemname'_init(pr) 

	pr.filespec    = filespec 
	if (backdir!="") {
		pr.backdir     = backdir 
	}
	pr.encoding    = ""
	pr.translate   = `False' 
	pr.retranslate = `False'
	pr.transutf8   = `False'
	pr.reanalyze   = (redo!="") 
	pr.data        = (data=="") 

	unicode_do(pr) 
}

/*
	(void) unicode_translate(filespec, backdir, encoding,
				 transutf8, invalid, replace, retranslate)

	    Entry point for -unicode translate-
*/



void unicode_translate(`SS' filespec, `SS' backdir, `SS' encoding, 
					`SS' transutf8, `SS' invalid, 
					`booleanS' replace,
					`booleanS' retranslate, 
					`SS' data) 
{
	`ProblemS'	pr

	`Problemname'_init(pr) 

	pr.filespec = filespec
	pr.translate   = `True' 

	if (backdir!="") {
		pr.backdir     = backdir 
	}
	pr.encoding    = encoding 
	pr.transutf8   = (transutf8!="") 
	pr.invalid     = invalid
	pr.retranslate = retranslate 
	pr.replace     = replace
	pr.data        = (data=="") 

	unicode_do(pr) 
}


void unicode_erasebackups()
{
	`ProblemS'	pr
	`SS'		subdir
	`SC'		filelist
	`RS'		i

	`Problemname'_init(pr) 

	pr.filespec    = "" 
	pr.translate   = `False' 

/*
	if (backdir!="") {
		pr.backdir     = backdir 
	}
*/

	if (!direxists(pr.backdir)) {
		errprintf("nothing to erase\n") 
		exit(601)
		/*NOTREACHED*/
	}

	subdir = pathjoin(pr.backdir, "`OkaySubDirname'")

	if (direxists(subdir)) {
		filelist = dir(subdir, "files", "*", 1) 
		for (i=1; i<=length(filelist); i++) {
			erasefile(filelist[i]) 
		}
		rmdir(subdir)
	}

	filelist = dir(pr.backdir, "files", "*", 1) 
	for (i=1; i<=length(filelist); i++) {
			erasefile(filelist[i]) 
	}
	rmdir(pr.backdir)
	printf("{txt}   done\n")
}
	


					/* Entry points 		*/
/* -------------------------------------------------------------------- */


/* -------------------------------------------------------------------- */
				/* Mid level				*/

	
/*
	(void) restore_set_filelist(pr) 

		-unicode restore-
*/

void restore_set_filelist(`ProblemS' pr)
{
	`RS'	i, j
	`SR'	fulllist
	`SR'	flist1, flist2


	/* ------------------------------------------------------------ */
			/* flist1 := File_T files			*/

	flist1 = J(1, length(pr.filelist), "") 
	j = 0 
	for (i=1; i<=length(pr.filelist); i++) { 
		if (pr.filestatus[i]==`File_T') flist1[++j] = pr.filelist[i]
	}
	flist1 = ( j ? flist1[| (1,1) \ (1,j) |] : J(1, 0, "") )

	/* ------------------------------------------------------------ */
			/* look in bak for more files			*/
	

	fulllist = dir(pr.backdir, "files", pr.filespec)
	flist2   = J(1, length(fulllist), "") 
	j = 0 
	for (i=1; i<=length(fulllist); i++) {
		if (substr(fulllist[i], -4, .) == ".dta") {
			flist2[++j] = pathbasename(fulllist[i])
		}
	}
	flist2 = ( j ? flist2[| (1,1) \ (1,j) |] : J(1, 0, "") )

	/* ------------------------------------------------------------ */
			/* Take unique names   				*/
	pr.filelist = uniqrows((flist1, flist2)')'
	pr.filestatus = J(1, length(pr.filelist), `File_T') 
}

		
				/* Mid level				*/
/* -------------------------------------------------------------------- */

/* -------------------------------------------------------------------- */
				/* Mid level: unicode_do()		*/
			
/*		
	(void) unicode_do(pr)

	   Handles 
		!pr.translate & !pr.retranslate:
			-unicode analyze-

		pr.translate & !pr.retranslate:
			-unicode translate-

		pr.translate & pr.retranslate:
			-unicode retranslate-
*/


void unicode_do(`ProblemS' pr) 
{
	pr.filespec_explicit = filespec_is_explicit(pr.filespec) 
	set_invflags(pr) 

	get_filelist(pr) 
	setup_backdir(pr)
	get_filestatus(pr, `False') 

	if (pr.translate & !pr.retranslate & pr.transutf8) {
		verify_no_retrans(pr) 
	}


	if (pr.retranslate | pr.transutf8) {
		do_undo_translations(pr, pr.replace)
		pr.filestatus = J(1, 0, .) 
		get_filestatus(pr, `False') 
	}
	if (pr.reanalyze) {
		do_undo_analyses(pr)
		pr.filestatus = J(1, 0, .) 
		get_filestatus(pr, `False') 
	}

	do_opening_msg(pr) 
	if (sum(pr.filestatus :== `File_U')==0) {
		printf("  (nothing to do)\n") 
	}
	else {
		do_examine_files(pr) 
	}
	do_set_r_results(pr) 
}

void verify_no_retrans(`ProblemS' pr) 
{
	`RS'		i
	`RS'		n

	n = 0 
	for (i=1; i<=length(pr.filelist); i++) {
		if (pr.filestatus[i]==`File_T') {
			(void) ++n 
			errprintf("file %s has already been translated\n", 
				pr.filelist[i]) 
		}
	}
	if (n==0) return 
	errprintf("{p 4 4 2}\n")  
	errprintf("You specified {bf:unicode translate, transutf8}.\n") 
	errprintf("{bf:transutf8} specifies how files are translated;\n") 
	errprintf("it forces strings that appear to be UTF-8\n") 
	errprintf("to be translated anyway.\n")
	errprintf("If you want the file(s) listed above retranslated\n")
	errprintf("using {bf:transutf8},\n") ;
	errprintf("use {bf:unicode retranslate, transutf8}.\n")
	errprintf("{bf:unicode retranslate} will also\n") 
	errprintf("translate files for the first time.\n") 
	errprintf("{p_end}\n") 
	errprintf("\n") 
	errprintf("{p 4 4 2}\n")  
	errprintf("The safe way to proceed is to translate files\n") 
	errprintf("first using {bf:unicode} {bf:translate} without\n") 
	errprintf("the {bf:transutf8} option, and then retranslate\n") 
	errprintf("any files that need it using\n") 
	errprintf("{bf:unicode retranslate, transutf8}.\n") 
	errprintf("{p_end}\n") 
	exit(459) 
	/*NOTREACHED*/
}
		



void do_set_r_results(`ProblemS' pr)
{
	`RS'	i
	`RS'	nnee, nsub, nfai, nsuc 

	st_rclear()

	st_numscalar("r(N_ascii)",   sum(pr.finalstatus:==`OK_Ascii'))
	st_numscalar("r(N_utf8)" ,   sum(pr.finalstatus:==`OK_Utf8'))
	st_numscalar("r(N_success)", sum(pr.finalstatus:==`T_suc')) 
	st_numscalar("r(N_failure)", sum(pr.finalstatus:==`T_fail'))
	st_numscalar("r(N_subed)",   sum(pr.finalstatus:==`T_sub'))
	st_numscalar("r(N_needed)",  sum(pr.finalstatus:==`T_needed'))

	nnee = nsub = nfai = nsuc = 0
	for (i=1; i<=length(pr.finalstatus); i++) {
		if (pr.finalstatus[i]==`T_suc') {
			st_global(r_result_name("success", ++nsuc),
				pr.filelist[i])
		}
		else if (pr.finalstatus[i]==`T_fail') {
			st_global(r_result_name("failure", ++nfai),
				pr.filelist[i])
		}
		else if (pr.finalstatus[i]==`T_sub') {
			st_global(r_result_name("subed", ++nsub),
				pr.filelist[i])
		}
		else if (pr.finalstatus[i]==`T_needed') {
			st_global(r_result_name("needed", ++nnee),
				pr.filelist[i])
		}
	}
}


`SS' r_result_name(`SS' basename, `RS' i)
{
	return(sprintf("r(%s%g)", basename, i))
}


void do_undo_analyses(`ProblemS' pr) 
{
	`RS'		i
	`FileStatusS'	fs

	for (i=1; i<=length(pr.filelist); i++) { 
		fs = pr.filestatus[i]
		if (fs == `File_U_validA') {
			erasefile(okay_filename(pr, pr.filelist[i], `OK_Ascii'))
		}
		else if (fs == `File_U_validU') {
			erasefile(okay_filename(pr, pr.filelist[i], `OK_Utf8'))
		}
	}
}


void do_undo_translations(`ProblemS' pr, `boolean' replace)
{
	`RetcodeS'	rc
	`RS'		i

	for (i=1; i<=length(pr.filelist); i++) {
		if (pr.filestatus[i]==`File_T') { 
			if ((rc=verify_backup(pr, pr.filelist[i], replace))) {
				errprintf("no retranslations made\n") ;
				exit(rc)
				/*NOTREACHED*/
			}
		}
	}

	for (i=1; i<=length(pr.filelist); i++) {
		if (pr.filestatus[i]!=`File_irrel') {
			undo_translation(pr, pr.filelist[i], pr.filestatus[i])
		}
	}
}






void undo_translation(`ProblemS' pr, `SS' fn, `FileStatusS' fs) 
{
	if (fs == `File_U_validA') {
		erasefile(okay_filename(pr, fn, `OK_Ascii'))
	}
	else if (fs == `File_U_validU') {
		erasefile(okay_filename(pr, fn, `OK_Utf8'))
	}
	else if (fs == `File_T') {
		restore_and_erase_backupfile(pr, fn) 
	}
}

	


/*
	do_opening_msg(pr)
		Called by unicode_do() 
*/

void do_opening_msg(`ProblemS' pr) 
{
	`RS'	n

	printf("{txt}\n") ; 
	printf("  File summary (before starting):\n")
	printf("%9.0g  file(s) specified\n", 
			length(pr.filelist)) 

	n = sum(pr.filestatus :== `File_irrel')
	if (n) {
		printf("%9.0g  file(s) not Stata\n", n) ; 
	}

	n = sum(pr.filestatus :== `File_U_validA')
	if (n) {
		printf(
		"%9.0g  file(s) already known to be ASCII in previous runs\n", 
		n)
	}

	n = sum(pr.filestatus :== `File_U_validU')
	if (n) {
		printf(
		"%9.0g  file(s) already known to be UTF8  in previous runs\n", 
		n)
	}

	n = sum(pr.filestatus :== `File_T')
	if (n) {
		printf(
		"%9.0g  file(s) already translated        in previous runs\n", 
 		n)
	}

	n = sum(pr.filestatus :== `File_U')
	printf("%9.0g  file(s) to be examined ...\n", n) ; 
}


/*
	do_examine_files() is the main driver. 
	It files in pr.finalstatus[], too.
*/

void do_examine_files(`ProblemS' pr)
{
	`RS'		i
	`RR'		cnt 
	`TranscodeS'	tc
	`DtaSubTranscodeS' subtc
	
	pr.utf8_example= J(0, 2, "") 		/* clear examples	*/
	pr.finalstatus = J(1, length(pr.filelist), .)
	pr.dtasubstatus = J(1, length(pr.filelist), 0)
	cnt            = J(1, `TranscodeMax', 0) 

	subtc = 0
	for (i=1; i<=length(pr.filelist); i++) {
		if (pr.filestatus[i] == `File_U') {
			pr.finalstatus[i] = tc = examine_file(pr, i, subtc) 
			pr.dtasubstatus[i] = subtc
			cnt[tc] = cnt[tc] + 1 
		}
		else {
			(void) ++pr.files_skipped 
			/*
			if (!pr.translate & 
			     (
			         pr.filestatus[i]==`File_U_validA' | 
			         pr.filestatus[i]==`File_U_validU'
                             )
			   ) mention_previous(pr, i)
			*/
			}
	}

	files_final_summary_list(pr)

	files_final_summary_table(pr, cnt)
}

/*
void mention_previous(`ProblemS' pr, `RS' i)
{
	printf("{txt}\n") ; 
	printf("   File %s (text file)\n", pr.filelist[i]) 
	printf("{col 11}{hline}\n")
	if (pr.filestatus[i]==`File_U_validA') {
		printf("{col 11}{bf:File does not need translation}\n")
		printf("{p 10 10 2}\n")
	}
	else {
		printf(
		"{col 11}{bf:File does not need translation, except ...}\n")
		printf("{p 10 10 2}\n")
		printf("The file appears to be UTF-8 already.\n") 
		printf("Sometimes files that need translating\n")
		printf("can look like UTF-8.\n") 
	}
	printf("This is based on a previous run; the file is known\n")
	printf("to be unchanged since then.\n")
	if (pr.filestatus[i]!=`File_U_validA') { 
		printf("To see the detailed messages on this UTF-8\n")
		printf("file, type\n")
		printf("{p_end}\n")
		printf("{p 14 14 2}\n")
		printf(". {bf:unicode retranslate %s}\n", pr.filelist[i]) 
		printf("{p_end}\n")
		printf("{p 10 10 2}\n")
		printf("The file will not be translated, but the analysis\n") 
		printf("step will repeat the detailed UTF-8 information.\n")
	}
	printf("{p_end}\n") 
}
*/


void files_final_summary_list(`ProblemS' pr) 
{
	`TranscodeS'	tc
	`RS'		i, n, nignore 
	`booleanS'	wc

	wc = filespec_has_wildcards(pr.filespec) 

	tc = (pr.translate ? `T_fail' : `T_needed') 
	n  = sum(pr.finalstatus :== tc) 
	nignore  = sum(pr.dtasubstatus :!= 0) 

	/* ---------------------------------------------------- */

	if (n==0) return

	/* ---------------------------------------------------- */
	if(n > nignore) {
		printf("\n") 
		printf("  ") 
		if (!wc) printf("File %s ", pr.filespec) 
		else     printf("File(s) matching %s that ", pr.filespec) 
		if (pr.translate) printf("still ") 
		if (!wc) {
			printf("needs translation\n") 
		}
		else {
			printf("need translation:\n") 
			if (n==0) {
				printf("        (none)\n") 
				return
				/*NOTREACHED*/
			}
			for (i=1; i<=length(pr.filelist); i++) { 
				if (pr.finalstatus[i]==tc && pr.dtasubstatus[i] == 0) {
					printf("        %s\n", pr.filelist[i])
				}
			}
		}
	}
	
 	
	if(nignore > 0) {
		printf("\n") 
		printf("  ") 
		if (!wc) printf("File %s ", pr.filespec) 
		else     printf("File(s) matching %s that ", pr.filespec)
					
		if (!wc) {
			printf("is ignored\n") 
		}
		else {
			printf("are ignored:\n") 
			if (nignore==0) {
				printf("        (none)\n") 
				return
				/*NOTREACHED*/
			}
			for (i=1; i<=length(pr.filelist); i++) { 
				if (pr.finalstatus[i]==`T_fail' && pr.dtasubstatus[i] != 0) {
					printf("        %s\n", pr.filelist[i])
				}
			}
		}		
	}
}


void files_final_summary_table(`ProblemS' pr, `RR' tc) 
{
	`RS'	n, sum, nignore, nfail

	sum = sum(tc) + pr.files_skipped
	if (sum==0) return

	printf("\n") 
	printf("  File summary:\n") 

	if (pr.files_skipped) {
		printf(
		"%9.0f file(s) skipped (known okay from previous runs)\n",
					pr.files_skipped) 
	}

	n = tc[`OK_Ascii'] + tc[`OK_Utf8'] 
	if (n) {
		if (n==sum) {
			printf("      all files okay\n")
			return
		}
		printf("%9.0f file(s) do not need translation\n", n) 
	}

	n = tc[`T_suc'] + tc[`T_sub'] 
	if (n) {
		if (n==sum) {
			printf("      all files successfully translated\n")
			return
		}
		printf("{bf:%9.0f file(s) successfully translated}\n", n) 
	}

	n = tc[`T_needed']
	if (n) { 
		if (n==sum && sum!=1) {
			printf("{bf:      all files need translation}\n")
			return
		}
		printf("{bf:%9.0f file(s) need translation}\n", n) 
	}

	n = tc[`T_fail']
	nignore  = sum(pr.dtasubstatus :!= 0) 
	if (nignore > 0) { 
		if(nignore == 1) {
			printf("{bf:{err:%9.0f file ignored (too big or not Stata)}}\n", 1)
		}
		else {
			printf("{bf:{err:%9.0f files ignored (too big or not Stata)}}\n", nignore)			
		}
	}

	if (n > nignore) { 
		nfail = n-nignore
		if (nfail==sum) {
			printf("{bf:{err:      all files not translated because they contain unconvertable characters;}}\n") 
		}
		else {
			printf("{bf:{err:%9.0f file(s) not translated because they contain unconvertable characters;}}\n", nfail) 
		}
		printf("{p 13 13 2}\n")
		printf("you might need to specify a different encoding,\n")
		printf("but more likely you need to run\n") 
		printf("{bf:unicode translate} with the {bf:invalid} option.\n")
		printf("{p_end}\n")
	}
}


`TranscodeS' examine_file(`ProblemS' pr, `RS' i, `RS' dtasubcode)
{
	`SS'		fn 
	`TranscodeS'	tc
	`RetcodeS'	rc
	`RS'		maxvar, kvar, isse	

	pr.utf8_example= J(0, 2, "") 		/* clear examples	*/
	fn = pr.filelist[i]

	printf("{txt}\n") ; 

	dtasubcode = 0
	if (file_is_dta(fn, pr.origvarnames)) { 
		printf("  File " + fn) 
		printf(" (Stata dataset)\n")
		tc = examine_dta_file(pr, fn) ; 
	}
	else {
		/* file may still be Stata dataset, but can not be opened in 
		   this version Stata. For example, file contains more variables
		   than current maxvar, or file is of a newer dta format */
		if(file_is_stata_binary_suffix(fn)) {
			dtasubcode = `T_dta_fail'
		
			rc = _stata("desc using " + `OpenQuote' + fn + `CloseQuote' + ", short"', 
					1, 1)
			if(rc == 0) {
				printf("  File " + fn + " (Stata dataset)\n")

				maxvar = st_numscalar("c(maxvar)")
				kvar = st_numscalar("r(k)")
				if(maxvar < kvar) {
					dtasubcode = `T_dta_toobig'
					isse = st_numscalar("c(SE)")
					printf("{p 8 8 2}\n")
					printf("{bf:{err:File ignored.}}  File contains too many variables.\n") 
					if(isse) {
						printf("Type {bf:set maxvar %g} to process this file.\n", kvar)
					}
					else {
						printf("File can not be processed by Stata/IC.\n")						
					}
					printf("{p_end}\n")
				}
			}
			else {
				printf("  File " + fn + " (Stata dataset?)\n")

				printf("{p 8 8 2}\n")
					printf("{bf:{err:File ignored.}}  ")
					printf("The file could not be used because ")
					printf("it is either not a Stata dataset ")
					printf("or it is a dataset from a newer version of Stata.\n")
					printf("{p_end}\n")
			}			
			return(`T_fail')
		}		
		printf("  File " + fn) 
		printf(" (text file)\n") ; 
		tc = examine_txt_file(pr, fn) ; 
	}
	return(tc) 
}

					/* mid level: unicode_do()	*/
/* -------------------------------------------------------------------- */




/* -------------------------------------------------------------------- */
					/* mid level: unicode_do()	*/
					/* mid level for .dta files	*/

		
`TranscodeS' examine_dta_file(`ProblemS' pr, `SS' fn) 
{
	`TranscodeS'	overall 


	overall = `TranscodeInit'

	accum_tc(overall, examine_dta_varnames(pr))
	accum_tc(overall, examine_dta_dtalbl(pr))
	accum_tc(overall, examine_dta_varlabs(pr))
	accum_tc(overall, examine_dta_vallabs_names(pr))
	accum_tc(overall, examine_dta_vallabs_content(pr))
	accum_tc(overall, examine_dta_char_names(pr))
	accum_tc(overall, examine_dta_char_contents(pr))
/* 
	accum_tc(overall, examine_dta_fmts(pr))
*/
	if (pr.data) {
		accum_tc(overall, examine_dta_strL(pr))  
		accum_tc(overall, examine_dta_strN(pr)) /* must be done */
							/* after strL   */
	}
	else {
		if (pr.translate) {
			printf(
"{col 8}no string variables examined or translated (nodata specified)\n")
		}
		else {
			printf(
		"{col 8}no string variables examined (nodata specified)\n")
		}
	}

	if (overall==`OK_Ascii' | overall==`OK_Utf8') { 
		write_okayfile(pr, fn, overall) 
	}
	else if (overall == `T_suc' | overall==`T_sub') {
		set_translate_dta_char(pr) 
		write_file_and_backupfile(pr, fn, "dta") 
	}

	drop_currentfile() 

	return(dta_1file_summary(pr, fn, overall))
}




`TranscodeS' dta_1file_summary(`ProblemS' pr, `SS' fn, `TranscodeS' overall)
{

	printf("{col 11}{hline}\n")

	if (overall==`OK_Ascii') { 
		printf("{col 11}{bf:File does not need translation}\n")
		return(overall)
	}


	else if (overall==`OK_Utf8') { 
		printf(
		"{col 11}{bf:File does not need translation, except ...}\n")
		utf8_dta_report(pr, fn, overall)
		return(overall)
	}


	if (overall != `T_fail' & length(pr.utf8_example)) {
		utf8_dta_report(pr, fn, overall) 
		printf("{col 11}{hline}\n")
		/* no return */
	}


	if (!(pr.translate)) { 
		printf("{p 10 12 2}\n")
		printf("{bf:{err:File needs translation.}}\n") 
		printf("Use {bf:unicode translate} on this file.\n")
		printf("{p_end}\n")
		return(overall) 
	}

	else if (overall == `T_suc' | overall==`T_sub') {
		printf("{p 10 12 2}\n")
		printf("{bf:File successfully translated}\n") 
		printf("{p_end}\n")
		return(overall) 
	}


	else if (overall == `T_fail') {
		printf("{p 10 12 2}\n")
		printf("{bf:{err:File not translated because it contains}}\n") 
		printf("{bf:{err:unconvertable characters;}}\n")
		printf("{p_end}\n")
		printf("{p 13 13 2}\n")
		printf("you might need to specify a different encoding,\n")
		printf("but more likely you need to run\n") 
		printf("{bf:unicode translate} with the {bf:invalid} option\n")
		printf("{p_end}\n")
		return(overall)
	}


}




void utf8_dta_report(`ProblemS' pr, `SS' fn, `TranscodeS' overall)
{
	`RS'	i 

	printf("{p 10 10 2}\n")
	if (overall == `OK_Utf8') {
		printf("The file appears to be UTF-8 already.\n") 
		printf("Sometimes files that need translating\n")
	}
	else {
		printf("Some elements of the file appear to be\n") 
		printf("UTF-8 already.\n") 
		printf("Sometimes elements that need translating\n")
	}
	printf("can look like UTF-8.  Look at these example(s):\n") 
	printf("{p_end}\n")
	for (i=1; i<=rows(pr.utf8_example); i++) {
		printf("{p 14 16 2}\n")
		printf("%s\n", pr.utf8_example[i, 1])
		if (pr.utf8_example[i, 2]!="") {
			printf(`""%s"\n"', pr.utf8_example[i, 2])
		}
		printf("{p_end}\n")
	}
	printf("{p 10 10 2}\n")
	printf("{bf:{err:Do they look okay to you?}}\n") 
	printf("{p_end}\n")
	printf("{p 10 10 2}\n")
	printf("{bf:{err:If not}}, the file needs\n") 
	printf("translating or retranslating\n") 
	printf("with the {bf:transutf8} option.  Type\n") 
	printf("{p_end}\n")
	printf("{p 14 16 2}\n")
	printf("{bf:. unicode{bind:   }translate}\n") 
	printf(`"{bf:"%s", transutf8}\n"', fn) 
	printf("{p_end}\n")
	printf("{p 14 16 2}\n")
	printf("{bf:. unicode retranslate}\n") 
	printf(`"{bf:"%s", transutf8}\n"', fn) 
	printf("{p_end}\n")

}

void dta_1element_summary(`ProblemS' pr, `RR' cnt, `SS' element, `RR' strLs)

{
	`RS'	sum
	`RS'	n

	sum = sum(cnt) 
	if (sum==0) return 

	if (pr.translate) { 
		n = cnt[`OK_Ascii']
		if (n==sum) {
			printf("      all %s okay, ASCII\n", plural(2, element))
			return
		}
		n = cnt[`OK_Utf8']
		if (n==sum) {
			printf("      all %s okay, already UTF-8\n", 
							plural(2, element))
			return
		}

		if (sum == cnt[`T_suc']) {
			printf("      all %s translated\n", plural(2,element)) 
			return 
		}

		n = cnt[`OK_Ascii'] 
		printf("%9.0f %s okay, ASCII\n", n, plural(n, element)) 

		n = cnt[`OK_Utf8'] 
		printf("%9.0f %s okay, already UTF-8\n", n, plural(n, element)) 
/*
		n = cnt[`OK_Ascii'] + cnt[`OK_Utf8']
		printf("%9.0f %s okay\n", n, plural(n, element)) 
*/

		if ((n = cnt[`OK_Binary'])) { 
			printf(
			"%9.0f strL variable(s) have {err:binary values}\n",n) 
			msg_concerns(strLs)
			printf("{p 13 13 2}\n") 
			printf("StrL variables that contain binary\n")
			printf("values in even one observation are not\n") 
			printf("translated by {bf:unicode}.\n") 
			printf("Translating binary values is inappropriate.\n") 
			printf("Rarely, however,\n") 
			printf(`""binary" values are just text or the\n"')
			printf("variable contains binary values in some\n") 
			printf("observations and\n") 
			printf("nonbinary values in others.\n")
			printf("You translate\n")
			printf(`"such variables using\n"') 
			printf("{bf:generate} or {bf:replace}; see \n") 
	printf("{help unicode_translate##binary:translating binary strLs}.\n")
			printf("{p_end}\n")
		}

		if ((n = cnt[`T_suc'])) {
			printf("%9.0f %s translated\n", n, plural(n, element)) 
		}

		if ((n = cnt[`T_sub'])) {
			printf(" %9.0f %s with invalid characters translated\n",
				n, plural(n, element)) 
		}
		if ((n = cnt[`T_fail'])) {
			printf("{bf:%9.0f %s cannot be translated}\n", 
				n, plural(n, element)) 
		}
	}
	else {
					/* analyze		*/
		if ((n = cnt[`OK_Binary'])) { 
			printf(
			"%9.0f strL variable(s) have {err:binary values}\n",n) 
			msg_concerns(strLs)
			printf("{p 13 13 2}\n") 
			printf("Even if you translate this dataset,\n") 
			printf("these variable(s) would not be translated.\n")
			printf("Translating binary values is inappropriate.\n")
			printf("Rarely, however,\n") 
			printf(`""binary" values are just text or the\n"')
			printf("variable contains binary values in some\n") 
			printf("observations and\n") 
			printf("nonbinary values in others.\n")
			printf("You translate\n")
			printf(`"such variables using\n"') 
			printf("{bf:generate} or {bf:replace}; see \n") 
	printf("{help unicode_translate##binary:translating binary strLs}.\n")
			printf("Before doing that, use\n") 
			printf("{bf:unicode translate}\n")  
			printf("if recommended below.\n") 
			printf("{p_end}\n")
		}

		if ((n = cnt[`T_needed'])) {
			printf("%9.0f %s %s translation\n", 
				n, plural(n, element), 
				(n==1 ? "needs" : "need") )
		}
	}
}


void msg_concerns(`RR' strLs)
{
	`RS'	i
	printf("{p 13 13 2}\n") 

	if (length(strLs)==1) {
		printf("This concerns strL variable %s.\n", st_varname(strLs))
	}
	else if (length(strLs)==2) {
		printf("This concerns strL variables %s and %s.\n", 
			st_varname(strLs[1]), st_varname(strLs[2]))
	}
	else {
		printf("This concerns strL variables\n") 
		for (i=1; i<length(strLs)/*sic*/; i++) {
			printf("%s,\n", st_varname(strLs[i]))
		}
		printf("and %s.\n", st_varname(strLs[i]))
	}
	printf("{p_end}\n") 
}

					/* mid level for .dta files	*/
					/* mid level: unicode_do()	*/
/* -------------------------------------------------------------------- */


/* -------------------------------------------------------------------- */
					/* examine_dta_varnames()	*/

`TranscodeS' examine_dta_varnames(`ProblemS' pr)
{
	`RS'		i, K
	`TranscodeS'	tc, overall
	`RR'		cnt
	`booleanS'	noexample 
	`SS'		orig


	noexample = `True'
	cnt       = J(1, `TranscodeMax', 0) 
	overall   = `TranscodeInit'

	K = st_nvar() 
	for (i=1; i<=K; i++) {
		orig = st_varname(i) 
		tc = examine_dta_varname(pr, i)
		cnt[tc] = cnt[tc] + 1
		if (tc > overall) overall = tc 
		if (tc==`OK_Utf8' & noexample) { 
			pr.utf8_example = pr.utf8_example \ 
					    ("variable name", orig)
			noexample = `False'
		}

	}
	dta_1element_summary(pr, cnt, "variable name", .) 

	return(overall) 
}

`TranscodeS' examine_dta_varname(`ProblemS' pr, `RS' i) 
{
	`SS'		origname, newname, emergname
	`TranscodeS'	tc

	pragma unset newname
	tc = translate_string(newname, pr, origname=st_varname(i)) 

	if (!pr.translate) return(tc) 

					/* translation mode follows 	*/

	if (tc==`T_fail') {
		failmsg(sprintf("variable %f's", i))
		return(tc) 
	}

	if (newname == origname) return(tc) 

	if (tc==`T_sub') {
		printf("{p 4 8 2}\n") 
		printf("variable %f\n", i) 
		printf("contained unconvertable characters;\n") ; 
		printf("renaming to %s\n", newname) ; 
		printf("{p_end}\n") 
	}

	emergname = varname_of_suggestion(i, newname) 
	if (emergname==newname) {
		st_varrename(i, newname) 
	}
	else {
		st_varrename(i, emergname) 
		printf("{p 4 8 2}\n") 
		printf("could not rename variable %f to %s;\n", i, newname) 
		printf("renamed to %s\n", emergname) 
		printf("{p_end}\n") 

	}

	return(tc) 
}

`SS' varname_of_suggestion(`RS' i, `SS' news)
{
	`RS'	j 
	`SS'	toret

	if (st_isname(news)) {
		if (_st_varindex(news)==.) return(news)
	}

	toret = sprintf("var%f", i)
	for (j=1; _st_varindex(toret)!=.; j++) {
		toret = sprintf("var%f_%f", i, j) 
	}
	return(toret)
}

					/* examine_dta_varnames()	*/
/* -------------------------------------------------------------------- */



/* -------------------------------------------------------------------- */
					/* examine_dta_dtalbl()		*/

`TranscodeS' examine_dta_dtalbl(`ProblemS' pr)
{
	`TranscodeS'	tc
	`RR'		cnt

	cnt    = J(1, `TranscodeMax', 0) 

	tc = examine_dta_dtalbl_u(pr) 
	cnt[tc] = cnt[tc] + 1
	
	dta_1element_summary(pr, cnt, "data label", .) 

	return(tc) 
}


`TranscodeS' examine_dta_dtalbl_u(`ProblemS' pr)
{
	`SS'		origlab, newlab
	`TranscodeS'	tc

	pragma unset newlab
	tc = translate_string(newlab, pr, origlab=get_dta_label())
	if (tc==`OK_Utf8') {
		pr.utf8_example = pr.utf8_example \
				("data label", origlab)
	}


	if (!pr.translate) return(tc) 

					/* translation mode follows 	*/

	if (tc==`T_fail') {
		failmsg("data label") 
		return(tc) 
	}

	if (newlab == origlab) return(tc) 

	set_dta_label(newlab)

	if (tc==`T_sub') {
		stdsubmsg("data label") 
	}

	return(tc) 

}


					/* examine_dtalbl()		*/
/* -------------------------------------------------------------------- */



/* -------------------------------------------------------------------- */
					/* examine_dta_varlabs()	*/

`TranscodeS' examine_dta_varlabs(`ProblemS' pr)
{
	`RS'		i, K
	`TranscodeS'	tc, overall
	`RR'		cnt
	`booleanS'	noexample
	`SS'		orig 

	noexample = `True'
	cnt       = J(1, `TranscodeMax', 0) 
	overall   = `TranscodeInit'

	K = st_nvar() 
	for (i=1; i<=K; i++) {
		orig = get_variable_label(i) 
		tc = examine_dta_varlab(pr, i)
		cnt[tc] = cnt[tc] + 1
		if (tc > overall) overall = tc 
		if (tc==`OK_Utf8' & noexample) {
			pr.utf8_example = pr.utf8_example \
				("variable label", orig)
			noexample = `False'
		}
	}

	dta_1element_summary(pr, cnt, "variable label", .) 

	return(overall) 
}




`TranscodeS' examine_dta_varlab(`ProblemS' pr, `RS' i) 
{
	`SS'		origlab, newlab
	`TranscodeS'	tc

	pragma unset newlab
	tc = translate_string(newlab, pr, origlab=get_variable_label(i)) 

	if (!pr.translate) return(tc) 

					/* translation mode follows 	*/

	if (tc==`T_fail') {
		failmsg(sprintf("label for variable %f (%s)", 
					i, st_varname(i)))
		return(tc) 
	}

	if (newlab == origlab) return(tc) 

	set_variable_label(i, newlab) 

	if (tc==`T_sub') {
		stdsubmsg(sprintf("label for variable %f (%s)", 
						i, st_varname(i)))
	}

	return(tc) 
}


					/* examine_dta_varlabs()	*/
/* -------------------------------------------------------------------- */


/* -------------------------------------------------------------------- */
					/* examine_dta_vallabs_names()	*/

`TranscodeS' examine_dta_vallabs_names(`ProblemS' pr)
{
	`RS'		i
	`TranscodeS'	overall, tc
	`RR'		lbldvars
	`SR'		vallabnames
	`RR'		cnt
	`booleanS'	noexample
	`SS'		orig

	noexample = `True'
	cnt       = J(1, `TranscodeMax', 0) 
	overall   = `TranscodeInit'


	vallabnames = get_vallab_names()
	lbldvars    = get_varidx_with_vallabs()

	for (i=1; i<=length(vallabnames); i++) {
		orig = vallabnames[i]
		tc = examine_dta_vallabs_name(pr, i, vallabnames, lbldvars)
		cnt[tc] = cnt[tc] + 1
		if (overall < tc) overall = tc 
		if (tc==`OK_Utf8' & noexample) {
			pr.utf8_example = pr.utf8_example \
				("value-label name", orig)
			noexample = `False'
		}

	}
		
	dta_1element_summary(pr, cnt, "value-label name", .)
	return(overall) 
}


`TranscodeS' examine_dta_vallabs_name(`ProblemS' pr, `RS' i, 
				`SR' allvallabnames, `RR' lbldvars)
{
	`SS'		origname, newname, emergname
	`TranscodeS'	tc

	origname = allvallabnames[i]

	pragma unset newname
	tc = translate_string(newname, pr, origname)

	if (!pr.translate) return(tc) 

					/* translation mode follows 	*/

	if (tc==`T_fail') {
		/* Message would refer to value label 1, 2, 3, ... */
		return(tc) 
	}

	if (newname == origname) {
		/* Message would refer to value label 1, 2, 3, ... */
		return(tc) 
	}


	if (tc==`T_sub') {
		printf("{p 4 8 2}\n") 
		printf("value-label name\n")
		printf("contained unconvertable characters;\n") ; 
		printf("renaming to %s\n", newname) ; 
		printf("{p_end}\n") 
	}

	emergname = vallabname_of_suggestion(newname, allvallabnames) 
	if (emergname==newname) {
		vallab_rename(allvallabnames, i, newname, lbldvars) 
	}
	else {
		vallab_rename(allvallabnames, i, emergname, lbldvars) 
		printf("{p 4 8 2}\n") 
		printf("could not rename value label to %s;\n", newname) 
		printf("renamed to %s\n", emergname) 
		printf("{p_end}\n") 

	}

	return(tc) 
}

/*		      ________              ________
	vallab_rename(allnames, i, newname, lbldvars)
		      --------  -  -------  --------

	Rename value label allnames[i] to newname. 
	Fix any labeled vars to references newname
	Update allnames[] so that names of value labels is correct
*/


void vallab_rename(`SR' allvallabnames, `RR' i, `SS' newname, `RR' lbldvars)
{
	`RetcodeS'	rc
	`RS'		j, idx
	`SS'		oname
	
	oname = allvallabnames[i]


					/* rename value label		*/
	rc = _stata("label copy " + oname + " " + newname, 1, 1)
	if (rc) exit(rc) 
	rc = _stata("label drop " + oname, 1, 1)
	if (rc) exit(rc) 

					/* fix variables		*/
	for (j=1; j<=length(lbldvars); j++) { 
		idx = lbldvars[j] 
		if (get_vallab_name_of_var(idx)==oname) {
			rc = _stata("label values " + 
					st_varname(idx) + " " +
					newname, 1, 1)
			if (rc) exit(rc) 
		}
	}

					/* update allvallabnames	*/
	allvallabnames[i] = newname
}
					


`SS' vallabname_of_suggestion(`SS' suggestion, `SR' allvallabnames)
{
	`RS'	j 
	`SS'	toret

	if (st_isname(suggestion)) {
		if (vallab_name_new(suggestion, allvallabnames)) {
			return(suggestion)
		}
	}

	for (j=1; j<=2*rows(allvallabnames); j++) {
		toret = sprintf("vallab%f", j) 
		if (vallab_name_new(toret, allvallabnames)) {
			return(toret) 
			/*NOTREACHED*/
		}
	}
	errprintf("assertion is false 3\n") 
	exit(9) 
	/*NOTREACHED*/
}


`booleanS' vallab_name_new(`SS' newname, `SR' allvallabnames) 
{
	`RS'	i

	for (i=1; i<=length(allvallabnames); i++) { 
		if (newname == allvallabnames[i]) return(`False') 
	}
	return(`True')
}
	

/* -------------------------------------------------------------------- */


	
/* -------------------------------------------------------------------- */
				/* examine_dta_vallabs_content()	*/

`TranscodeS' examine_dta_vallabs_content(`ProblemS' pr)
{
	`RS'		i
	`TranscodeS'	overall, tc
	`SR'		vallabnames
	`RR'		cnt
	`booleanS'	noexample

	noexample = `True'
	cnt       = J(1, `TranscodeMax', 0) 
	overall   = `TranscodeInit'

	vallabnames = get_vallab_names()

	for (i=1; i<=length(vallabnames); i++) {
		tc = examine_dta_vallab_content(pr, vallabnames[i], noexample)
		cnt[tc] = cnt[tc] + 1
		if (overall < tc) overall = tc 
	}
		
	dta_1element_summary(pr, cnt, "value-label content", .)
	return(overall) 
}


`TranscodeS' examine_dta_vallab_content(`ProblemS' pr, `SS' vallabname, 
					`booleanS' noexample)
{
	`RS'		i
	`TranscodeS'	tc, overall
	`RC'		values
	`SC'		text

	overall = `TranscodeInit'

	pragma unset values
	pragma unset text 
	st_vlload(vallabname, values, text)

	if(length(text) == 0) {
		return(`OK_Utf8')		
	}
	
	for (i=1; i<=length(text); i++) {
		tc = examine_vallab_content(pr, vallabname, values[i], text[i])
		if (tc>overall) overall = tc 
		if (tc==`OK_Utf8' & noexample) { 
			pr.utf8_example = pr.utf8_example \
					("value-label contents", text[i])
			noexample = `False'
		}
	}

	if (overall == `T_fail') {
		failmsg(sprintf("value label %s's contents", vallabname))
	}
	else if (overall == `T_sub') {
		stdsubmsg(sprintf("value label %s's contents", vallabname))
	}

	return(overall) 
}

`TranscodeS' examine_vallab_content(`ProblemS' pr, 
				`SS' vallabname, `RS' value, `SS' origtext)
{
	`RetcodeS'	rc
	`SS'		newtext 
	`TranscodeS'	tc

	pragma unset newtext
	tc = translate_string(newtext, pr, origtext) 
	if (!pr.translate) return(tc) 

					/* translation mode follows 	*/
	if (tc==`T_fail') {
		/* message appears in caller */
		return(tc) 
	}

	if (newtext == origtext) {
		return(tc) 
	}

	rc = _stata("label define " + vallabname + " " + 
			sprintf("%f", value) + " " +
			`OpenQuote' + newtext + `CloseQuote' + 
			", modify", 1, 1)
	if (rc) exit(rc) 
	
	/*
	if (tc==`T_sub') {
		MESSAGE APPEARS IN CALLER
	}
	*/

	return(tc) 
}

				/* examine_dta_vallabs_content()	*/
/* -------------------------------------------------------------------- */


/* -------------------------------------------------------------------- */
					/* examine_dta_char_names()	*/

`TranscodeS' examine_dta_char_names(`ProblemS' pr)
{
	`RS'		i, j
	`TranscodeS'	overall, tc
	`SR'		level1name
	`SC'		level2name
	`RR'		cnt
	`booleanS'	noexample
	`SS'		orig

	noexample = `True'
	cnt       = J(1, `TranscodeMax', 0) 
	overall   = `TranscodeInit'

	level1name = get_char_level1() 
	for (i=1; i<=length(level1name); i++) {
		level2name = st_dir("char", level1name[i], "*") 
		for (j=1; j<=length(level2name); j++) {
			orig = level2name[j]
			tc = examine_char_name(pr, level1name[i], 
						   level2name[j])
			cnt[tc] = cnt[tc] + 1
			if (overall < tc) overall = tc 
			if (tc==`OK_Utf8' & noexample) {
				pr.utf8_example = pr.utf8_example \
					("characteristic name", orig)
				noexample = `False'
			}
		}
	}
			
	dta_1element_summary(pr, cnt, "characteristic name", .)
	return(overall) 
}


`TranscodeS' examine_char_name(`ProblemS' pr, `SS' top, `SS' origname)
{
	`SS'		newname, emergname
	`TranscodeS'	tc

	pragma unset newname
	tc = translate_string(newname, pr, origname)

	if (!pr.translate) return(tc) 

					/* translation mode follows 	*/
	if (tc==`T_fail') {
		failmsg(sprintf("{it:name} of characteristic %s[{it:name}]", top))
		return(tc) 
	}

	if (newname == origname) return(tc) 

	if (tc==`T_sub') {
		stdsubmsg(sprintf("{it:name} of characteristic %s[{it:name}]", top))
	}

	emergname = charname_of_suggestion(top, newname ) 
	if (emergname==newname) {
		char_rename(top, origname, newname) 
	}
	else {
		char_rename(top, origname, newname) 
		printf("{p 4 8 2}\n") 
		printf("could not rename value label to %s[%s];\n", 
					top, newname) 
		printf("renamed to %s[%s]\n", top, emergname) 
		printf("{p_end}\n") 

	}

	return(tc) 
}


`SS' charname_of_suggestion(`SS' top, `SS' suggestion)
{
	`RS'	j 
	`SS'	toret
	`SC'	existingnames 

	if (st_isname(suggestion)) {
		if (charname_is_new(top, suggestion)) return(suggestion) 
	}

	existingnames = st_dir("char", top, "*")
	for (j=1; j<=2*length(existingnames); j++) {
		toret = sprintf("char%f", j)
		if (charname_is_new(top, toret)) return(toret) 
	}
	errprintf("assertion is false 4\n") 
	exit(9)
	/*NOTREACHED*/
}
		
`booleanS' charname_is_new(`SS' top, `SS' name)
{
	return(st_global(sprintf("%s[%s]", top, name))=="")
}

					/* examine_dta_char_names()	*/
/* -------------------------------------------------------------------- */



/* -------------------------------------------------------------------- */
					/* examine_dta_char_contents()	*/

`TranscodeS' examine_dta_char_contents(`ProblemS' pr)
{
	`RS'		i, j
	`TranscodeS'	overall, tc
	`SR'		level1name
	`SC'		level2name
	`RR'		cnt
	`booleanS'	noexample


	noexample = `True'
	cnt       = J(1, `TranscodeMax', 0) 
	overall   = `TranscodeInit'

	level1name = get_char_level1() 
	for (i=1; i<=length(level1name); i++) {
		level2name = st_dir("char", level1name[i], "*") 
		for (j=1; j<=length(level2name); j++) {
			tc = examine_char_content(pr, level1name[i], 
						   level2name[j])

			cnt[tc] = cnt[tc] + 1
			if (overall < tc) overall = tc 
			if (tc==`OK_Utf8' & noexample) { 
				pr.utf8_example = pr.utf8_example \
				("characteristic contents", 
					st_global(sprintf("%s[%s]", 
					level1name[i], level2name[j])))
				noexample = `False'
			}
		}
	}
			
	dta_1element_summary(pr, cnt, "characteristic content", .)
	return(overall) 
}

`TranscodeS' examine_char_content(`ProblemS' pr, `SS' name1, `SS' name2)
{
	`TranscodeS'	tc
	`SS'		fullname 
	`SS'		origcontent, newcontent

	fullname     = sprintf("%s[%s]", name1, name2) 
	origcontent  = st_global(fullname) 

	pragma unset newcontent
	tc = translate_string(newcontent, pr, origcontent)

	if (!pr.translate) return(tc) 

					/* translation mode follows 	*/
	if (tc==`T_fail') {
		failmsg(sprintf("contents of characteristic %s", fullname))
		return(tc) 
	}

	if (newcontent == origcontent) return(tc) 

	if (tc==`T_sub') {
		stdsubmsg(sprintf("contents of characteristic %s", fullname))
	}

	st_global(fullname, newcontent)

	return(tc) 
}


					/* examine_dta_char_contents()	*/
/* -------------------------------------------------------------------- */


/* -------------------------------------------------------------------- */
					/* examine_dta_fmts()		*/


`TranscodeS' examine_dta_fmts(`ProblemS' pr)
{
	`RS'		i, K
	`TranscodeS'	overall, tc
	`RR'		cnt
	`booleanS'	noexample
	`SS'		orig 


	noexample = `True'
	cnt       = J(1, `TranscodeMax', 0) 
	overall   = `TranscodeInit'

	K = st_nvar()
	for (i=1; i<=K; i++) { 
		orig = st_varformat(i)
		tc = examine_dta_fmt(pr, i) 
		cnt[tc] = cnt[tc] + 1
		if (tc>overall) overall=tc 
		if (tc==`OK_Utf8' & noexample) {
			pr.utf8_example = pr.utf8_example \
				("%fmt",orig)
			noexample = `False'
		}
	}

	dta_1element_summary(pr, cnt, "%fmt", .)
	return(overall) 
}
		

`TranscodeS' examine_dta_fmt(`ProblemS' pr, `RS' i)
{
	`TranscodeS'	tc
	`SS'		origfmt, newfmt

	origfmt = st_varformat(i) 

	pragma unset newfmt
	tc = translate_string(newfmt, pr, origfmt)

	if (!pr.translate) return(tc) 

					/* translation mode follows 	*/
	if (tc==`T_fail') {
		failmsg("variable " + st_varname(i) + "'s %fmt")
		return(tc) 
	}

	if (newfmt == origfmt) return(tc) 

	if (tc==`T_sub') {
		stdsubmsg("variable " + st_varname(i) + "'s %fmt")
	}

	/* we use Stata to reset format so we can ignore failure */
	(void) _stata("format " + st_varname(i) + " " + newfmt, 1, 1)

	return(tc) 
}



					/* examine_dta_fmts()		*/
/* -------------------------------------------------------------------- */

/* -------------------------------------------------------------------- */
					/* examine_dta_strN()		*/

`TranscodeS' examine_dta_strN(`ProblemS' pr)
{
	`RS'		i
	`TranscodeS'	overall, tc
	`RR'		strN_vars
	`RR'		cnt
	`booleanS'	noexample


	noexample = `True'
	strN_vars = get_strN_vars()
	cnt       = J(1, `TranscodeMax', 0) 
	overall   = `TranscodeInit'

	for (i=1; i<=length(strN_vars); i++) { 
		tc = examine_strN_var(pr, strN_vars[i])
		cnt[tc] = cnt[tc] + 1
		if (tc>overall) overall=tc 
		if (tc==`OK_Utf8' & noexample) {
			pr.utf8_example = pr.utf8_example \ 
				("contents of str# variable " +
				pr.origvarnames[strN_vars[i]],
				""
				)
			noexample = `False'
		}
	}

	dta_1element_summary(pr, cnt, "str# variable", .)
	return(overall) 
}




`TranscodeS' examine_strN_var(`ProblemS' pr, `RS' i)
{
	`TranscodeS'	tc
	`SS'		vn

	vn = st_varname(i) 

	tc = translate_string_for_strvar(pr, vn) 

	if (!pr.translate) return(tc) 

					/* translation mode follows 	*/


	if (tc==`T_fail') {
		failmsgplural(sprintf("contents of variable %f (%s)", i, vn))
		return(tc) 
	}

	if (tc==`T_sub') {
		stdsubmsg(sprintf("contents of variable %f (%s)", i, vn))
	}

	return(tc) 
}




					/* examine_dta_strN()		*/
/* -------------------------------------------------------------------- */


/* -------------------------------------------------------------------- */
					/* examine_dta_strL()		*/

`TranscodeS' examine_dta_strL(`ProblemS' pr)
{
	`RS'		i
	`TranscodeS'	overall, tc
	`RR'		strL_vars
	`RR'		cnt
	`booleanS'	noexample

	noexample = `True'
	strL_vars = get_strL_vars()
	cnt       = J(1, `TranscodeMax', 0) 
	overall   = `TranscodeInit'
	for (i=1; i<=length(strL_vars); i++) { 
		tc = examine_strL_var(pr, strL_vars[i])
		cnt[tc] = cnt[tc] + 1
		if (tc>overall & tc!=`OK_Binary') overall=tc 
		if (tc==`OK_Utf8' & noexample) {
			pr.utf8_example = pr.utf8_example \ 
				("contents of strL variable " +
				pr.origvarnames[strL_vars[i]],
				"")
			noexample = `False'
		}
	}

	/* wwg*/
	dta_1element_summary(pr, cnt, "strL variable", strL_vars)
	return(overall) 
}


`TranscodeS' examine_strL_var(`ProblemS' pr, i)
{
	`TranscodeS'	tc
	`SS'		vn

	vn = st_varname(i) 

	tc = translate_string_for_strvar(pr, vn) 

	if (!pr.translate) return(tc) 

					/* translation mode follows 	*/


	if (tc==`T_fail') {
		failmsgplural(sprintf("contents of variable %f (%s)", i, vn))
		return(tc) 
	}

	if (tc==`T_sub') {
		stdsubmsg(sprintf("contents of variable %f (%s)", i, vn))
	}

	return(tc) 
}


					/* examine_dta_strL()		*/
/* -------------------------------------------------------------------- */


/* -------------------------------------------------------------------- */
					/* mid level for text files	*/

end

local   NoTextExamples		5
local	TextExamplesName	TextExamplesdf
local	TextExamples		struct `TextExamplesName'
local	TextExamplesS		`TextExamples' scalar

mata:
`TextExamples' {
	`RS'	lino
	`RR'	cnt
	`RM'	ex
}
void TextExamples_init(`TextExamplesS' e)
{
	e.lino = 0 
	e.ex   = J(`NoTextExamples', `TranscodeMax', 0)
	e.cnt  = J(              1 , `TranscodeMax', 0) 
}


`TranscodeS' examine_txt_file(`ProblemS' pr, `SS' fn) 
{
	`TranscodeS' 	tc
	`TextfileS'	t
	`FildesS'	fh
	`TextExamplesS'	e


	t  = textfile_open(fn) 
	fh = (pr.translate ? fopen(pr.tmpfn, "w") : .) 
	TextExamples_init(e)

	tc = examine_open_txt_file(pr, t, fh, e) 

	textfile_close(t) 
	if (pr.translate) fclose(fh) 

	if (tc==`OK_Ascii' | tc==`OK_Utf8') { 
		write_okayfile(pr, fn, tc) 
	}
	else if (tc == `T_suc' | tc==`T_sub') {
		write_file_and_backupfile(pr, fn, "text") 
	}

	if (pr.translate) erasefile(pr.tmpfn)

	/* ------------------------------------------------------------ */

	txt_report(e) 

	if (tc == `OK_Utf8') utf8_text_report(e) 

	return(txt_1file_summary(pr, fn, tc, e))
}


void txt_report(`TextExamplesS' e)
{
	`RS'	i, l

	printf("{col 11}%8.0f lines in file\n", l=sum(e.cnt)) 
	if (l==0) return 

	i = e.cnt[`OK_Ascii'] 
	if (i) printf("{col 11}%8.0f lines ASCII\n", i) 

	i = e.cnt[`OK_Utf8'] 
	if (i) printf("{col 11}%8.0f lines UTF-8\n", i) 

	i = e.cnt[`T_suc'] 
	if (i) printf("{col 11}%8.0f lines translated\n", i) 

	i = e.cnt[`T_sub'] 
	if (i) printf("{col 11}%8.0f lines w/ invalid chars translated\n", i) 

	i = e.cnt[`T_fail'] 
	if (i) printf("{col 11}%8.0f lines w/ invalid chars not translated\n", i) 

	i = e.cnt[`T_needed'] 
	if (i) printf("{col 11}%8.0f lines need translation\n", i) 

}
	



void utf8_text_report(`TextExamplesS' e) 
{
	`RS'	i, nex
	`RS'	j
	`RS'	n

	j = `OK_Utf8'

	printf("{col 11}{bf:File does not need translation, except ...}\n")
	printf("{p 10 10 2}\n")
	printf("The file appears to be UTF-8 already.\n") 
	printf("Sometimes files that still need translating\n")
	printf("can look like UTF-8.\n") 

	if ((nex = e.cnt[j])==1) {
		if (nex==1) printf("See line %g\n", e.ex[1, j])
	}
	else if (nex==2) {
		printf("See lines %g and %g.\n", 
			e.ex[1, `OK_Utf8'], e.ex[2, j]) 
	}
	else {
		if (nex>`NoTextExamples') nex = `NoTextExamples'
		printf("See lines\n") 
		for (i=1; i<=nex-1; i++) { 
			printf("%g,\n", e.ex[i, j]) 
		}
		printf("and %g.\n", e.ex[nex, j])
	}

	printf("A total of %g\n", n=e.cnt[j])
	printf(n==1 ? "line" : "lines\n") 
	printf("out of %g\n", e.lino) 
	printf("appear to be UTF8.\n")
	printf("{p_end}\n") 
}


`TranscodeS' txt_1file_summary(`ProblemS' pr, `SS' fn, `TranscodeS' overall,
					`TextExamplesS'	e)
{

	printf("{col 11}{hline}\n")

	if (overall==`OK_Ascii') { 
		printf("{col 11}{bf:File does not need translation}\n")
		return(overall)
	}


	else if (overall==`OK_Utf8') { 
		return(overall)
	}


	if (overall != `T_fail' & length(pr.utf8_example)) {
		utf8_dta_report(pr, fn, overall) 
		printf("{col 11}{hline}\n")
		/* no return */
	}


	if (!(pr.translate)) { 
		printf("{p 10 12 2}\n")
		printf("{bf:{err:File needs translation.}}\n") 
		printf("Use {bf:unicode translate} on this file.\n")
		if (e.cnt[`OK_Ascii'] & e.cnt[`OK_Utf8']) {
			printf("By default, {bf:unicode translate} will\n") 
			printf("not translate the UTF-8 lines.\n") 
			printf("The interesting question is how the\n") 
			printf("lines needing translation should be\n") 
			printf("translated.  Are the lines UTF-8 with\n") 
			printf(" invalid characters or are they\n") 
			printf("encoded with an extended ASCII encoding?\n") 
			printf("We suggest that you consider\n") 
			printf("translating the file with encoding\n") 
			printf("{bf:utf8}, and specifying option\n")
			printf("{bf:invalid(ignore)} in addition to\n")
			printf("the obvious solution of simply translating\n")
			printf("the file using an Extended ASCII encoding.\n")
		}
		printf("{p_end}\n")
		return(overall) 
	}

	else if (overall == `T_suc' | overall==`T_sub') {
		printf("{p 10 12 2}\n")
		printf("{bf:File successfully translated}\n") 
		printf("{p_end}\n")
		return(overall) 
	}


	else if (overall == `T_fail') {
		printf("{p 10 12 2}\n")
		printf("{bf:{err:File not translated because it contains}}\n") 
		printf("{bf:{err:unconvertable characters;}}\n")
		printf("{p_end}\n")
		printf("{p 13 13 2}\n")
		printf("you might need to specify a different encoding,\n")
		printf("but more likely you need to run\n") 
		printf("{bf:unicode translate} with the {bf:invalid} option\n")
		printf("{p_end}\n")
		return(overall)
	}


}
		


`TranscodeS' examine_open_txt_file(`ProblemS' pr, 
			`TextfileS' t, `FildesS' fh, 
			`TextExamplesS' e)
{
	`TranscodeS'	tc, overall
	`SM'		line, eof
	`SS'		newline


	overall = `TranscodeInit'

	eof = J(0, 0, "") 
	while ((line=textfile_get(t)) != eof) {
		(void) e.lino = e.lino + 1
		pragma unset newline
		tc = examine_txt_line(newline, pr, line)
		if (tc>overall) overall = tc 
		if ((e.cnt[tc] = e.cnt[tc] + 1) <= `NoTextExamples') { 
			e.ex[e.cnt[tc], tc] = e.lino
		}
		if (pr.translate & overall != `T_fail') {
			fwrite(fh, newline) 
		}
	}
	if (e.lino == 0) overall = `OK_Ascii'


	return(overall)
}


`TranscodeS' examine_txt_line(`SS' newline, `ProblemS' pr, `SS' origline) 
{
	`TranscodeS'	tc

	tc = translate_string(newline, pr, origline) 

	if (!pr.translate) return(tc) 
	return(tc) 
}


					/* mid level for text files	*/
/* -------------------------------------------------------------------- */



/* -------------------------------------------------------------------- */
					/* Transcode accumulation	*/


void accum_tc(`TranscodeS' accumulated, `TranscodeS' tc)
{
	if (tc > accumulated) accumulated = tc 
}


					/* Transcode accumulation	*/
/* -------------------------------------------------------------------- */



/* -------------------------------------------------------------------- */
				/* String examination/translation	*/
				/* low level				*/

/*	_________                  ___
	Transcode translate_string(news, pr, s)
				         --  -

	translate_string has two modes.

	if (pr.translate) 

		1.  Determine whether s is ASCII, UTF8, OTHER_CLEAN OR 
		    OTHER_INVALID. 

		2.  IF OTHER_CLEAN
			set news = translated s
			return(T_SUC)

		3.  if OTHER_INVALID
			if fail_on_invalid_chars
		            set news = s and return T_fail. 
			else
		            set news = translated ss and T_sub. 

		4.  If UTF8, 
		        set news = translated s (might == s) and 
			   if transutf8, return(T_SUC)
			   else      return(OK_Utf8)

		5.  If ASCII, 
		        set news = translated s (likely ==s) and 
			    if transutf8, return(T_SUC)
			    else      return(OK_Ascii)
	else
		1.  Determine whether s is ASCII, UTF8, OTHER

		2. if ASCII, return OK_Ascii

		3.  if UTF8, return OK_Utf8

		4.  return T_needed
*/

end

local StrtypeS	`RS'
local 	Str_ASCII	1
local	Str_UTF8	2
local	Str_OTHER	3
local   Str_BINARY	4

mata:
`StrtypeS' strtype(`SS' s)
{

	if (s=="") return(`Str_ASCII')
	if (isascii(s)) return(`Str_ASCII')
	if (ustrinvalidcnt(s)==0) return(`Str_UTF8')
	return(`Str_OTHER')
}



`TranscodeS' translate_string(`SS' news, `ProblemS' pr, `SS' s)
{
	`StrtypeS'	stype

	stype = strtype(s) 

	if (pr.translate) {
		news = s 


		/* ---------------------------------------------------- */
						/* ASCII		*/

		if (stype==`Str_ASCII') {
			if (pr.transutf8) { 
				return(convert_to_utf8(pr, news, s))
			}
			return(`OK_Ascii') 
		}
			
		/* ---------------------------------------------------- */
						/* UTF8			*/

		if (stype==`Str_UTF8') {
			if (pr.transutf8) {
				return(convert_to_utf8(pr, news, s))
			}
			return(`OK_Utf8') 
		}

		/* ---------------------------------------------------- */

	
		return(convert_to_utf8(pr, news, s))
	}
	else {
						/* analyze mode		*/
		news = s
		if (stype==`Str_ASCII')		return(`OK_Ascii')
		if (stype==`Str_UTF8')		return(`OK_Utf8')
		return(`T_needed')
	}
	/*NOTREACHED*/
}



`TranscodeS' convert_to_utf8(`ProblemS' pr, `SS' d, `SS' s) 
{
	if (s=="") {
		d = s 
		return(`T_suc') 
	}

	if (pr.inv_fail) {
		d = ustrfrom(s, pr.encoding, 3) 
		if (d=="") { 
			d = s 
			return(`T_fail') 
		}
		return(`T_suc') 
	}

	d = ustrfrom(s, pr.encoding, 3) 
	if (d!="") return(`T_suc') 
		
	if (pr.inv_ignore) {
		d = ustrfrom(s, pr.encoding, 2) 
		return(`T_sub') 
	}

	if (pr.inv_mark) { 
		d = ustrfrom(s, pr.encoding, 1) 
		return(`T_sub') 
	}


	/* else pr.inv_esc */
	d = ustrfrom(s, pr.encoding, 4) 
	return(`T_sub') 
}



`TranscodeS' convert_strvar_to_utf8(`ProblemS' pr, `SS' varname) 
{
	`RS'	rc


	if (pr.inv_fail) {
		rc = _stata(
			sprintf(
			  `"count if ustrfrom(%s,"%s",3)=="" & %s!="""',
			  varname, pr.encoding, varname)
			,1 ,1)
		if (rc) exit(rc) 

		if (st_numscalar("r(N)") != 0) return(`T_fail') 

		rc = _stata(
			sprintf(
			  `"replace %s = ustrfrom(%s, "%s", 3) if %s!="""',
			  varname, varname, pr.encoding, varname)
			,1 ,1)
		if (rc) exit(rc) 
		return(`T_suc')
	}

				/* if invalid() is specified, we still
				   need to distinguish between T_suc
				   (invalid() wasn't really needed) and
				   T_sub (invalid() affected how some
				   values were translated).
				*/
	rc = _stata(
		sprintf(
		  `"count if ustrfrom(%s,"%s",3)=="" & %s!="""',
		  varname, pr.encoding, varname)
		,1 ,1)
	if (rc) exit(rc) 

	if (st_numscalar("r(N)") == 0) {
		rc = _stata(
			sprintf(
			  `"replace %s = ustrfrom(%s, "%s", 3) if %s!="""',
			  varname, varname, pr.encoding, varname)
			,1 ,1)
		if (rc) exit(rc) 
		return(`T_suc')
	}

	if (pr.inv_ignore) {
		rc = _stata(
			sprintf(
			  `"replace %s = ustrfrom(%s, "%s", 2) if %s!="""',
			  varname, varname, pr.encoding, varname)
			,1 ,1)
		if (rc) exit(rc) 
		return(`T_sub') 
	}

	if (pr.inv_mark) { 
		rc = _stata(
			sprintf(
			  `"replace %s = ustrfrom(%s, "%s", 1) if %s!="""',
			  varname, varname, pr.encoding, varname)
			,1 ,1)
		if (rc) exit(rc) 
		return(`T_sub') 
	}


	/* else pr.inv_esc */
	rc = _stata(
		sprintf(
		  `"replace %s = ustrfrom(%s, "%s", 4) if %s!="""',
		  varname, varname, pr.encoding, varname)
		,1 ,1)
	if (rc) exit(rc) 
	return(`T_sub') 
}




`StrtypeS' strtype_for_strvar(`SS' varname) 
{
	`RetcodeS'	rc
	`RS'		Nobs

	Nobs = st_nobs() 

	/* ------------------------------------------------------------ */
				/* count if _strisbinary(varname)	*/

	if (st_vartype(varname) == "strL") {
		rc = _stata("count if _strisbinary(" + 
				varname + ")", 1, 1) 
		if (rc) exit(rc) 
		if (st_numscalar("r(N)")) return(`Str_BINARY') 
	}


	/* ------------------------------------------------------------ */
				/* count if s==""			*/

	rc = _stata("count if " + varname + `" =="""', 1, 1) 
	if (rc) exit(rc) 

	if (st_numscalar("r(N)") == Nobs) return(`Str_ASCII') 


	/* ------------------------------------------------------------ */
				/* count if isascii(s) | s==""		*/

	rc = _stata(
		sprintf(`"count if isascii(%s) | %s=="""', 
			varname, varname)
		 , 1, 1)
	if (rc) exit(rc) 

	if (st_numscalar("r(N)") == Nobs) return(`Str_ASCII') 

	/* ------------------------------------------------------------ */
		/* count if ustrinvalidcnt(s)==0 | isascii(s) | s==""	*/


	rc = _stata(
		sprintf(
		`"count if ustrinvalidcnt(%s)==0 | isascii(%s) | %s=="""',
			varname, varname, varname) 
		 , 1, 1)
	if (rc) exit(rc) 

	if (st_numscalar("r(N)") == Nobs) return(`Str_UTF8') 
			

	/* ------------------------------------------------------------ */
	return(`Str_OTHER') 
}



`ExTranscodeS' translate_string_for_strvar(`ProblemS' pr, `SS' varname)
{
	`StrtypeS'	stype

	stype = strtype_for_strvar(varname) 

	if (pr.translate) {
		/* ---------------------------------------------------- */
						/* BINARY		*/
		if (stype==`Str_BINARY') {
			return(`OK_Binary')
		}
			
		/* ---------------------------------------------------- */
						/* ASCII		*/

		if (stype==`Str_ASCII') {
			if (pr.transutf8) {
				return(convert_strvar_to_utf8(pr, varname))
			}
			return(`OK_Ascii') 
		}
			
		/* ---------------------------------------------------- */
						/* UTF8			*/

		if (stype==`Str_UTF8') {
			if (pr.transutf8) {
				return(convert_strvar_to_utf8(pr, varname))
			}
			return(`OK_Utf8') 
		}

		/* ---------------------------------------------------- */

	
		return(convert_strvar_to_utf8(pr, varname))
	}
	else {
						/* analyze mode	*/

		if (stype==`Str_ASCII')		return(`OK_Ascii')
		if (stype==`Str_UTF8')		return(`OK_Utf8')
		if (stype==`Str_BINARY')	return(`OK_Binary')
		return(`T_needed')
	}
	/*NOTREACHED*/
}



				/* low level				*/
				/* String examination/translation	*/
/* -------------------------------------------------------------------- */



/* -------------------------------------------------------------------- */
					/* backdir utilities		*/


/*
	setup_backdir(pr)
		      --

	    Create if necessary directories <pr.backdir>/ and 
	    <pr.backdir>/`OkaySubDirname'/

	_______
	boolean = confirm_backdir_exists(pr)
			                 --

	    Confirm existence of <pr.backdir>/ and 
	    <pr.backdir>/`OkaySubDirname'/
*/


`booleanS' confirm_backdir_exists(`ProblemS' pr, `booleanS' noisy) 
{
	`SS'	subdir

	if (!direxists(pr.backdir)) {
		if (noisy) {
			errprintf("directory %s not found\n", pr.backdir) 
			errprintf("{p 4 4 2}\n") 
			errprintf("You have not run the {bf:unicode}\n") 
			errprintf("analyze and translate commands in\n") 
			errprintf("this directory.\n") 
			errprintf("p_end\n") 
		}
		return(`False') 
	}


	subdir = pathjoin(pr.backdir, "`OkaySubDirname'") 
	if (!direxists(subdir)) {
		if (noisy) {
			errprintf("file %s not found\n", subdir) 
			errprintf("{p 4 4 2}\n") 
			errprintf("This file is an important {bf:unicode}\n")
			errprintf("system file and somebody deleted it.\n")
			errprintf("{p_end}\n") 
		}
		return(`False') 
	}
	return(`True') 
}


void setup_backdir(`ProblemS' pr) 
{
	`RetcodeS'	rc ; 
	`SS'		subdir

	setup_backdir_itself(pr) 


	subdir = pathjoin(pr.backdir, "`OkaySubDirname'") 
	if (direxists(subdir)) return 

	if (fileexists(subdir)) { 
		error_backdir_exists_as_file(subdir)
		/*NOTREACHED*/
	}

	if ((rc=_mkdir(subdir, 0))) {
		errprintf("could not create " + subdir) 
		exit(rc) 
	}
}


void setup_backdir_itself(`ProblemS' pr) 
{
	`RetcodeS'	rc

	if (direxists(pr.backdir)) return 
	if (fileexists(pr.backdir)) { 
		error_backdir_exists_as_file(pr.backdir) 
		/*NOTREACHED*/
	}

	if ((rc=_mkdir(pr.backdir, 0))) {
		errprintf("could not create " + pr.backdir) 
		exit(rc) 
	}
	printf("  {txt}(Directory " + pr.backdir + " created; please do not delete)\n")
}


void error_backdir_exists_as_file(`SS' backdir)
{
	errprintf(backdir + " already exists as a file\n") 
	errprintf("{p 4 4 2}\n")
	errprintf("{bf:unicode analyze} and {bf:unicode translate}\n")
	errprintf("create a subdirectory for backups of original\n") 
	errprintf("files and for notes to themselves.\n") 
	errprintf("By default, that directory is named\n") 
	errprintf("{bf:`DefaultBackdir'},\n")
	errprintf("although you might have specified an option\n")
	errprintf("to override that.\n") ; 
	errprintf("\n") ; 
	errprintf("{p 4 4 2}\n")
	errprintf("Anyway, {bf:unicode} wanted to create a backup\n") 
	errprintf("directory named {bf:" + backdir + "} but discovered\n")
	errprintf("that a regular file exists with that name!\n") 
	errprintf("We recommend you delete, rename, or move the file,\n") 
	errprintf("but you could specify option {bf:backupdir()}\n")
	errprintf("to specify a different directory.\n")
	errprintf("{p_end}\n") 
	exit(602)
}


					/* backdir utilities		*/
/* -------------------------------------------------------------------- */



/* -------------------------------------------------------------------- */
					/* okayfiles			*/

/*		       __
	get_filestatus(pr, isrestore)
		       --  ---------

	set pr.filestatus[i] based on pr.filelist[i] for all i.

	get_filestatus() is based on okayfiles. 


	(`FileStatus') is:

		File_U			file is untranslated

		File_U_validA		file valid ASCII
		File_U_validU		file valid UTF8

		File_T			file is translated
		File_irrel		file not Stata

	<filename> 
	    1.  is File_U_validA if ./bak/subdir/<filename>.oka exists
	    2.  is File_U_validU if ./bak/subdir/<filename>.oku exists
            3.  is File_T        if ./bak/subdir/<filename>     exists
	    4.  is File_U        if is Stata (or option specified)
	    5.  is File_irrel    otherwise

	The files existing in ./bak/subdir/ are jointly known 
	as okayfiles. 
*/


void get_filestatus(`ProblemS' pr, `booleanS' isrestore)
{
	`RS'	i 

	pr.filestatus = J(1, length(pr.filelist), .)

	for (i=1; i<=length(pr.filelist); i++) { 
		pr.filestatus[i] = filestatus_of_file(pr, pr.filelist[i], 
					isrestore)
	}
}

`FileStatusS' filestatus_of_file(`ProblemS' pr, `SS' fname, `booleanS' isrestore)
{

	if (!isrestore) {
		if (!pr.filespec_explicit) { 
			if (!file_is_stata(fname)) return(`File_irrel') 
		}
	}

	if (pr.transutf8) { 
		erasefile(okay_filename(pr, fname, `OK_Ascii'))
		erasefile(okay_filename(pr, fname, `OK_Utf8'))
	}
	else {
		if (check_okayfile(pr, fname, `OK_Ascii')) {
			return(`File_U_validA')
		}
		if (check_okayfile(pr, fname, `OK_Utf8') ) {
			return(`File_U_validU') 
		}
	}

	if (fileexists(backup_filename(pr, fname))) return(`File_T')

	return(`File_U') 
}


/*
	(void) write_okayfile(pr, simplefn, tc)

		erase existing okay file if necessary.
		write indicated okayfile. 
		tc must be OK_*
*/

	

void write_okayfile(`ProblemS' pr, `SS' simplefn, `TranscodeS' tc)
{
	`FildesS'	fh
	`RR'		chksums
	`SS'		contents
	`RS'		intr

	Transcode_MustBe_OK(tc) 

	chksums = chksum_of_file(simplefn) 

	contents = str_of_checksum(chksums) 

	intr = setbreakintr(0) 		/* -------------- Break off --- */
	erasefile(okay_filename(pr, simplefn, `OK_Ascii'))
	erasefile(okay_filename(pr, simplefn, `OK_Utf8' ))

	fh = fopen(okay_filename(pr, simplefn, tc), "w")
	fput(fh, contents) 
	fclose(fh) 
	(void) setbreakintr(intr)	/* --------- Break restored --- */
}


`SS' str_of_checksum(`RR' chksum)
{
	return("`UVersion' " + 
			strtrim(sprintf("%15.0g", chksum[1])) + " " +
			strtrim(sprintf("%15.0g", chksum[2]))
	      )
}


`RR' checksum_of_str(`SS' str, `booleanS' checkversion)
{
	`RR'	tokens

	tokens = strtoreal(tokens(str))

	if (length(tokens)!=3) return(.) 

	if (checkversion) {
		if (tokens[1]<`UVersion') return(.) 
	}
	return( (tokens[2], tokens[3]) )
}
	


/*
	(void) write_file_and_backupfile(pr, simplefn, caller)

	caller = "dta" or "text"

	    Write backup and associated files.
	    if caller == "dta" 
	    	-save- data in memory.
	    else	
		cp file from pr.tmpfn

	    Assumptions:
		backup file does not exist. Does nothing otherwise.
*/


void write_file_and_backupfile(`ProblemS' pr, `SS' simplefn, `SS' caller) 
{
	`RetcodeS'	rc
	`FildesS'	fh
	`SS'		backupfn, transfn
	`SR'		origchksum, newchksum
	`booleanS'	caller_is_dta
	`RS'		intr

	caller_is_dta = (caller=="dta") 

	backupfn = backup_filename(pr, simplefn) 
	transfn  = trans_filename( pr, simplefn) 


	/* ------------------------------------------------------------ */
				/* file existence			*/

	if (!fileexists(simplefn)) { 
		errprintf("file %s does not exist\n") 
		exit(601)
		/*NOTREACHED*/
	}

	if (fileexists(backupfn)) { 
		errprintf("backup file %s already exists\n", backupfn) 
		exit(602) 
		/*NOTREACHED*/
	}

	intr = setbreakintr(0) 		/* -------------- Break off --- */
	if (fileexists(transfn)) { 
		erasefile(transfn) 
	}

	/* ------------------------------------------------------------ */
				/* simplefn -> backupfn 		*/

	origchksum = chksum_of_file(simplefn) 

	cpfile(simplefn, backupfn) 
	if (chksum_of_file(backupfn) != origchksum) { 
		erasefile(backupfn) 
		errprintf("checksums do not match\n") 
		errprintf("{p 4 4 2}\n") 
		errprintf("{bf:unicode} copied %s to %s\n", simplefn, backupfn) 
		errprintf("and checksums failed to match.\n")
		errprintf("%s erased.  System healthy, but\n", backupfn)
		errprintf("failure is unexplained.\n") 
		(void) setbreakintr(intr)	/* - Break restored --- */
		exit(9) 
		/*NOTREACHED*/
	}

	/* ------------------------------------------------------------ */
				/* data in memory -> simplefn		*/

	if (caller_is_dta) {
		rc = resave_currentfile(simplefn) 
	}
	else {
		erasefile(simplefn) 
		cpfile(pr.tmpfn, simplefn) 
		rc = 0 
	}
	if (rc) {
		erasefile(simplefn) 
		cpfile(backupfn, simplefn) 
		erasefile(backupfn) 

		errprintf("could not save translated file\n") 
		errprintf("{p 4 4 2}\n") 
		errprintf("Copied %s to %s successfully.\n", simplefn, backupfn)
		if (caller_is_dta) {
			errprintf("Attempted to save data in memory\n") 
			errprintf("as %s.\n", simplefn)
			errprintf("Got back return code %g.\n", rc) 
		}
		else {
			errprintf("Attempted to save translated text file\n")
			errprintf("as %s,\n", simplefn)
			errprintf("but that failed.\n") 
		}
		errprintf("Restored %s from backup\n", backupfn) 
		errprintf("and erased backup.\n") 
		errprintf("System is healthy but failure\n")  
		errprintf("is unexplained.\n") 
		errprintf("{p_end}\n") 
		(void) setbreakintr(intr)	/* - Break restored --- */
		exit(rc) 
		/*NOTREACHED*/
	}

	newchksum = chksum_of_file(simplefn) 

	/* ------------------------------------------------------------ */
				/* write checksums			*/

	fh = fopen(transfn, "w") 
	fput(fh, datetime())
	fput(fh, str_of_checksum(origchksum))
	fput(fh, str_of_checksum( newchksum))
	fclose(fh) 
	(void) setbreakintr(intr)	/* --------- Break restored --- */
}



/*	__
	rc  = verify_backup(pr, simplefn, replace) 

	   file <simple_fn> is known to have a backup file. 

	   Verify backup file is correct and that simplefn has 
	   not changed since it was created. 

	   Returns:

		rc=0		simplefn has not changed or 
				backup disappeared, etc., since
				translation.
		rc>0		problem; error message presented

*/
			
`RetcodeS' verify_backup(`ProblemS' pr, `SS' simplefn, `boolean' replace)
{
	`FildesS'	fh
	`SS'		backupfn, transfn
	`SS'		datetime, content1, content2
	`RR'		origchksum, newchksum
	`booleanS'	simplefn_exists, transfn_exists
	`RS'		intr

	/* ------------------------------------------------------------ */
					/* check files			*/
	
	backupfn = backup_filename(pr, simplefn) 
	transfn  = trans_filename( pr, simplefn) 

	simplefn_exists  = fileexists(simplefn) 
	transfn_exists   = fileexists(transfn) 

	if (!(replace | simplefn_exists)) {
		errprintf("translated file %s not found\n", simplefn) 
		errprintf("{p 4 4 2}\n") 
		errprintf("Specify option {bf:replace}\n") 
		errprintf("to ignore this error.\n")
		errprintf("{p_end}\n") 
		return(601) 
		/*NOTREACHED*/
	}

	if (!fileexists(backupfn)) {
		errprintf("backup file %s not found\n", backupfn) 
		errprintf("{p 4 4 2}\n") 
		errprintf("Someone erased the file.  No backup\n") 
		errprintf("exists to be restored.\n") 
		return(601) 
		/*NOTREACHED*/
	}

	if (!(replace | transfn_exists)) { 
		errprintf("tracking file %s not found\n", transfn) 
		errprintf("{p 4 4 2}\n") 
		errprintf("Specify option {bf:replace}\n") 
		errprintf("to ignore this error.\n")
		errprintf("{p_end}\n") 
		return(601) 
		/*NOTREACHED*/
	}
			
	/* ------------------------------------------------------------ */
					/* read trans file		*/

	if (transfn_exists) {
		intr = setbreakintr(0) 		/* ------ Break off --- */
		fh = fopen(transfn, "r") 
		datetime  = fget(fh) 
		content1  = fget(fh) 
		content2  = fget(fh) 
		fclose(fh) 
		(void) setbreakintr(intr)	/* - Break restored --- */
	
		if (length(datetime)!=1 | 
		    length(content1)!=1 | 
		    length(content2)!=1) {
			errprintf("tracking file %s is corrupt (1)\n", transfn) 
			errprintf("{p 4 4 2}\n") 
			errprintf("Specify option {bf:replace}\n") 
			errprintf("to ignore this error.\n")
			errprintf("{p_end}\n") 
			return(610) 
			/*NOTREACHED*/
		}

		origchksum = checksum_of_str(content1, `False') 
		newchksum  = checksum_of_str(content2, `False') 

		if (origchksum==. | newchksum==.) { 
			errprintf("file %s is corrupt (2)\n", transfn) 
			errprintf("{p 4 4 2}\n") 
			errprintf("Specify option {bf:replace}\n") 
			errprintf("to ignore this error.\n")
			errprintf("{p_end}\n") 
			return(610) 
			/*NOTREACHED*/
		}
	}
	

	/* ------------------------------------------------------------ */
					/* check contents of files	*/

	if (transfn_exists) {
		if (chksum_of_file(backupfn) != origchksum) {
			errprintf("backup file has changed\n", backupfn)
			errprintf("{p 4 4 2}") 
			errprintf("The contents of the backup file\n") 
			errprintf("%s have\n", backupfn) 
			errprintf("changed since they were written on\n")  
			errprintf("%s\n.", datetime)
			errprintf("Original file cannot be restored.\n") 
			errprintf("Specify option {bf:replace}\n") 
			errprintf("to ignore this error.\n")
			errprintf("{p_end}\n") 
			return(459) 
			/*NOTREACHED*/
		}
	}

	if (replace) return(0) 

	if (chksum_of_file(simplefn) != newchksum) { 
		errprintf("translated file has changed\n") 
		errprintf("{p 4 4 2}") 
		errprintf("The contents of\n") 
		errprintf("%s\n", simplefn) 
		errprintf("have changed since the file was\n") ;

		if (transfn_exists) {
			errprintf("translated on\n") 
			errprintf("%s.\n", datetime) 
		}
		else {
			errprintf("translated.\n") 
		}
		errprintf("If you wish to restore the file from the\n") 
		errprintf("the backup, specify option {bf:replace}.\n") 
		errprintf("{p_end}\n") 
		return(459) 
		/*NOTREACHED*/
	}
	return(0)
}


/*
Mon Mar  9 15:03:00 CDT 2015  Not used

`SS' get_translate_date(`ProblemS' pr, `SS' simplefn) 
{
	`FildesS'	fh
	`SS'		transfn, datetime
	`RS'		intr

	transfn  = trans_filename( pr, simplefn) 
	if (fileexists(transfn)) {
		intr = setbreakintr(0) 		/* ------ Break off --- */
		fh = fopen(transfn, "r") 
		datetime  = fget(fh) 
		fclose(fh) 
		(void) setbreakintr(intr)	/* - Break restored --- */
		return(datetime)
	}
	return("") 
}
*/


/*
	restore_and_erase_backupfile(pr, simplefn)

	You must call verify_backup() before calling this 
	routine.  Regardless of file contents, the routine 
	restores the backup, and erases the backup. 
*/
		
void restore_and_erase_backupfile(`ProblemS' pr, `SS' simplefn)
{
	`SS'		backupfn, transfn
	`RS'		intr

	backupfn = backup_filename(pr, simplefn)
	transfn  =  trans_filename(pr, simplefn) 

	if (!fileexists(backupfn)) {
		errprintf("assertion is false 5\n") 
		exit(9)
		/*NOTREACHED*/
	}


	intr = setbreakintr(0) 		/* -------------- Break off --- */
	erasefile(simplefn) 
	cpfile(backupfn, simplefn) 
	erasefile(backupfn) 
	erasefile(transfn) 
	(void) setbreakintr(intr)	/* --------- Break restored --- */
}

void cpfile(`SS' fn_from, `SS' fn_to)
{
	`FildesS'	fhr, fhw
	`RS'		bufsiz
	`SS'		buf
	`SM'		eof

	if (!fileexists(fn_from) | fileexists(fn_to)) {
		errprintf("assertion is false 6\n") 
		exit(9)
		/*NOTREACHED*/
	}
	
	bufsiz = 512*1024
	fhr    = fopen(fn_from, "r")
	fhw    = fopen(fn_to,   "w") 

	eof = J(0, 0, "") 
	while ( (buf=fread(fhr, bufsiz)) != eof) {
		fwrite(fhw, buf)
	}
	fclose(fhw)
	fclose(fhr)
}







/*	________
	filename = backup_filename(pr, simplefn) 

	________
	filename = trans_filename(pr, simplefn)

	________
	filename = okay_filename(pr, simplefn, tc)
				 --  --------  --

		returns desired filename. 
		Note, okay_filename() requires tc to be OK_* or T_suc.
*/
	
		
`SS' backup_filename(`ProblemS' pr, `SS' simplefn)
{
	return(pathjoin(pr.backdir, simplefn))
}

`SS' trans_filename(`ProblemS' pr, `SS' simplefn) 
{
	return(pathjoin(
		pathjoin(pr.backdir, "`OkaySubDirname'"), 
		simplefn + "`Suffix_T_suc'")
	      )
}
	

`SS' okay_filename(`ProblemS' pr, `SS' filename, `TranscodeS' tc)
{
	`SS'		suffix

	if (tc==`OK_Ascii') 	suffix = "`Suffix_OK_Ascii'"
	else if (tc==`OK_Utf8')	suffix = "`Suffix_OK_Utf8'"
	else if (tc==`T_suc')	suffix = "`Suffix_T_suc'"
	else {
		errprintf("assertion is false 7\n") 
		exit(9) 
		/*NOTREACHED*/
	}

	return(pathjoin(
		pathjoin(pr.backdir, "`OkaySubDirname'"), 
		filename + suffix))
}


/*
	booleanS = check_okayfile(pr, fname, {`OK_Ascii' | `OK_Utf8'})

		returns `True' if okayfile exists and matches 
		files in base directory. 

		if okayfile exists and does not match, 
		okayfile is erased.
*/
	

`booleanS' check_okayfile(`ProblemS' pr, `SS' fname, `TranscodeS' tc)
{
	`SS'		okayfn
	`RR'		chksums


	okayfn = okay_filename(pr, fname, tc) 

	chksums = okayfile_chksum(okayfn) 
	if (okayfile_chksum(okayfn) == .) return(`False') 


	if (chksums == chksum_of_file(fname)) return(`True') 

	erasefile(okayfn) 
	return(`False') 
}



/*
	rowvec = chksum_of_file(filename)

	Returns checksum (2 element row vector) of file, 
	which must exist.
*/


`RR' chksum_of_file(`SS' fn) 
{
	`RetcodeS'	rc

	rc = _stata("checksum " + `OpenQuote' + fn + `CloseQuote', 1, 1)
	if (rc) exit(rc) 
	return(( st_numscalar("r(checksum)"), st_numscalar("r(filelen)") )) 
}


/*
	rowvec = okayfile_chksum(fname) 

		returns (.) if file does not exist. 
		returns (.) if file invalid (file erased) 
		returns (chksum, len) if file exists and valid. 
*/
	

`RR' okayfile_chksum(`SS' fname)
{
	`FildesS'	fh
	`SS'		contents
	`RR'		toret
	`RS'		intr

	if (!fileexists(fname)) return(.) 

	intr = setbreakintr(0) 		/* -------------- Break off --- */
	fh = fopen(fname, "r") 
	contents = fget(fh) 
	fclose(fh) 
	(void) setbreakintr(intr)	/* --------- Break restored --- */

	toret = checksum_of_str(contents, `True')
	if (toret==.) erasefile(fname) 
	return(toret) 
}



					/* okayfiles			*/
/* -------------------------------------------------------------------- */


/* -------------------------------------------------------------------- */
					/* utilities			*/


void failmsg(`SS' id)
{
	printf("{p 4 8 2}\n") 
	printf("%s\n", id) 
	printf("contains unconvertable characters\n") 
	printf("{p_end}\n") 
}



void failmsgplural(`SS' id)
{
	printf("{p 4 8 2}\n") 
	printf("%s\n", id) 
	printf("contain unconvertable characters\n") 
	printf("{p_end}\n") 
}


void stdsubmsg(`SS' id)
{
	printf("{p 4 8 2}\n") 
	printf("unconvertable characters found and translated in\n") 
	printf("%s\n", id) 
	printf("{p_end}\n") 
}


/*	_______				____________
	boolean = file_is_dta(filename, origvarnames)
			      --------


	If file is .dta files,
		-use- it
		return `True'
	else
		return `False'
*/
	

`booleanS' file_is_dta(`SS' fn, `SR' origvarnames)
{
	`RetcodeS'	rc

	rc = _stata("use " + `OpenQuote' + fn + `CloseQuote' + ", clear"', 
					1, 1)
	if (rc==0) {
			/* 
			   get orig var names & 
			   move e(sample) to end 
			*/
		origvarnames = st_varname((1..st_nvar()))
		return(`True') 
	}

	if (rc==1) exit(1) 		/* --Break--		*/

	return(`False')
}


/*	_______
	boolean = filespec_is_explicit(filespec)
				       --------


	return `True' if filespec is explicit. 

	An explicit filespec is one that identifies has no 
	wild cards in the suffix or, if there is no suffix, 
	no wild cards at all. 
*/


`booleanS' filespec_is_explicit(`SS' filespec) 
{
	`RS'	l ; 
	`SS'	s 

	if (strpos(filespec, "*")==0 &
	    strpos(filespec, "?")==0) return(`True') 

	s = strreverse(filespec) 
	l = strpos(s, ".") 
	if (l==0) return(`False') ; 
	s = substr(s, 1, l) 
	return(
	   (strpos(s, "*")==0 &
	    strpos(s, "?")==0) ? `True' : `False') 
}



/*		     --
	get_filelist(pr)
		     --

	set pr.filelist to be files identified by pr.filespec. 
	Abort with error if no files identified
*/


void get_filelist(`ProblemS' pr) 
{
	pr.filelist = dir(".", "files", pr.filespec)
	if (rows(pr.filelist)==0) {
		errprintf(`"file(s) "%s" not found\n"', pr.filespec)
		exit(601)
		/*NOTREACHED*/
	}
	pr.filelist = sort(pr.filelist, 1)
}






/*	_______
	boolean = file_is_stata(filename)
				--------

	return `True' if file is Stata based on its extension.
*/


`booleanS' file_is_stata(`SS' fname)
{
	`SS'	suffix

	suffix = pathsuffix(fname) 

	if (suffix == ".dta") return(`True') 
	if (suffix == ".ado") return(`True') 
	if (suffix == ".do")  return(`True') 
	if (suffix == ".sthlp") return(`True') 
	if (suffix == ".class") return(`True') 
	if (suffix == ".dlg") return(`True') 
	if (suffix == ".idlg") return(`True') 
	if (suffix == ".ihlp") return(`True') 
	if (suffix == ".mata") return(`True') 
	if (suffix == ".stbcal") return(`True') 
	if (suffix == ".txt") return(`True') 
	if (suffix == ".smcl") return(`True') 

	if (suffix == ".csv") return(`True') 
	if (suffix == ".txt") return(`True') 

	return(`False') 
}

/*	_______
	boolean = file_is_stata_binary_suffix(filename)
				------

	return `True' if file is Stata binary (dataset) based on its extension.
*/
`booleanS' file_is_stata_binary_suffix(`SS' fname)
{
	`SS'	suffix

	suffix = pathsuffix(fname) 

	if (suffix == ".dta") return(`True') 

	return(`False') 
}


/*
	erasefile(filename)
		  --------

	Erases filename if it exists.  
	It is okay to erasefile a nonexisting file. 
	Aborts with error if file exists and cannot be erased.
*/

void erasefile(`SS' fn)
{
	`RetcodeS'	rc 

	if ((rc = _unlink(fn))) {
		errprintf("file " + fn + " cannot be erased\n")
		exit(-rc) 
		/*NOTREACHED*/
	}
}

/*	___
	str =  get_variable_label(i)
				  -

	    Return variable label of variable i

	(void) set_variable_label(i, s)
	    Set variable label of variable i
*/


`SS' get_variable_label(`RS' i) 
{
	`RetcodeS'	rc

	rc = _stata("local X : variable label " + st_varname(i), 1, 1)
	if (rc) exit(rc) 
	return(st_local("X"))
}

void set_variable_label(`RS' i, `SS' s) 
{
	`RetcodeS'	rc

	rc = _stata("label var " + st_varname(i) + 
			`OpenQuote' + s + `CloseQuote', 1, 1)
	if (rc) exit(rc) 
}


/*	_________
	strvector = get_vallab_names()

	    returns all value-label names
*/

`SR' get_vallab_names()
{
	`RetcodeS' 	rc

	if ((rc = _stata("label dir", 1, 1))) exit(rc) 
	return(tokens(st_global("r(names)")))
}


/*	______________
	real rowvector = get_strN_vars()
	______________
	real rowvector = get_strL_vars()

		returns str# and strL variable names
*/

`RR' get_strN_vars()
{
	`RS'	i, K
	`RS'	j
	`RR'	toret
	`SS'	vt

	K     = st_nvar()
	toret = J(1, K, .)
	j     = 0 
	for (i=1; i<=K; i++) {
		vt = st_vartype(i)
		if (substr(vt,1,3)=="str" && vt!="strL") toret[++j] = i
	}
	return( j ? toret[| (1,1) \ (1,j) |] : J(1, 0, .) )
}

`RR' get_strL_vars()
{
	`RS'	i, K
	`RS'	j
	`RR'	toret

	K     = st_nvar()
	toret = J(1, K, .)
	j     = 0 
	for (i=1; i<=K; i++) {
		if (st_vartype(i)=="strL") toret[++j] = i
	}
	return( j ? toret[| (1,1) \ (1,j) |] : J(1, 0, .) )
}
			
		





/*	______________
	real rowvector get_varidx_with_varlabs()

	    Returns variable indices of all variables 
	    that have a value label attached.
*/


`RR' get_varidx_with_vallabs()
{
	`RS'	i, K
	`RS'	j
	`RR'	toret

	K     = st_nvar() 
	toret = J(1, K, .) 
	j     = 0 
	for (i=1; i<=K; i++) {
		if (get_vallab_name_of_var(i)!="") toret[++j] = i 
	}

	return( j ? toret[| (1,1) \ (1,j) |] : J(1, 0, .) )
}



/*	______
	string = get_vallab_name_of_var(i)
					-

	    Returns value-label name associated with variable i.
	    Returns "" if no association. 
*/


`SS' get_vallab_name_of_var(`RS' i)
{
	`RetcodeS'	rc

	rc = _stata("local X : value label " + st_varname(i), 1, 1)
	if (rc) exit(rc) 

	return(st_local("X"))
}

/*	______
	string = get_dta_label()

	(void)   set_dta_label(string)
			       ------

	    Get/Set data label. 
*/


`SS' get_dta_label()
{
	`RetcodeS'	rc

	rc = _stata("local X : data label", 1, 1)
	if (rc) exit(rc) 
	return(st_local("X"))
}

void set_dta_label(`SS' s)
{
	`RetcodeS'	rc

	rc = _stata("label data " + `OpenQuote' + s + `CloseQuote', 1, 1)
	if (rc) exit(rc) 
}


/*
	stringvector = get_char_level1()
	
	    returns all entities (_dta, varnames) that have 
	    characteristics defined
*/

`SR' get_char_level1()
{
	`RS'	K, i, j
	`SR'	toret 

	K = st_nvar() 
	toret = J(1, K+1, "") 

	j = 0 
	if (length(st_dir("char", "_dta", "*"))) {
		toret[++j] = "_dta"
	}

	for (i=1; i<=K; i++) { 
		if (length(st_dir("char", st_varname(i), "*"))) {
			toret[++j] = st_varname(i) 
		}
	}

	return( j ? toret[| (1,1) \ (1,j) |] : J(1, 0, "") )
}


/*		
	char_rename(topname, oldname, newname)
		    -------  -------  -------

	Rename <topname>[<oldname>] to <topname>[<newname>]
	It is assumed <topname>[<newname>] does not exist
*/


void char_rename(`SS' topname, `SS' oldname, `SS' newname)
{
	`SS'	old, neu 

	old = sprintf("%s[%s]", topname, oldname) 
	neu = sprintf("%s[%s]", topname, newname) 

	st_global(neu, st_global(old))
	st_global(old, "") 
}


`RetcodeS' resave_currentfile(`SS' simplefn)
{
	`RetcodeS' 	rc

	rc = _stata("save " + `OpenQuote' + simplefn + `CloseQuote' + 
			", orphans replace", 1, 1)
	return(rc)
}

void drop_currentfile()
{
	`RetcodeS'	rc

	rc = _stata("drop _all")
	if (rc) exit(rc) 
}


void set_invflags(`ProblemS' pr)
{
	pr.inv_fail = pr.inv_ignore = pr.inv_mark = pr.inv_esc = `False'
	
	pr.inv_fail   = (pr.invalid=="") 
	pr.inv_ignore = (pr.invalid=="ignore") 
	pr.inv_mark   = (pr.invalid=="mark") 
	pr.inv_esc    = (pr.invalid=="esc") 
}


`SS' datetime()
{
	return(strtrim(c("current_date")) + " " + c("current_time"))
}


`booleanS' filespec_has_wildcards(`SS' filespec)
{
	if (strpos(filespec, "*")) return(`True') 
	if (strpos(filespec, "?")) return(`True') 
	return(`False') 
}


void set_translate_dta_char(`ProblemS' pr) 
{
	`SS' 	s
	`SS'	date

	s = "`UVersion' " + pr.encoding + " "
	s = s + (pr.data      ? "data "     : "nodata ")
	s = s + (pr.transutf8 ? "transutf8 " : "notransutf8 ")
	if (pr.inv_fail') 	s = s + "invalid(fail)" 
	else if (pr.inv_ignore) s = s + "invalid(ignore)"
	else if (pr.inv_mark)   s = s + "invalid(mark)"
	else if (pr.inv_esc)    s = s + "invalid(esc)"
	else {
		errprintf("assertion is false\n") 
		error(9) 
	}

	date = subinstr(c("current_date"), " ", "", .)
	s = s + " " + date + " " + c("current_time")
	st_global("_dta[unicode_translate]", s) 
}



/* -------------------------------------------------------------------- */




/* -------------------------------------------------------------------- */
					/* textfile input		*/


/* 	_
	t = textfile_open(filename)
			  -------- 

	    opens file for read.

		       _
	textfile_close(t)
		       -

	    closes file

	_______
	boolean = textfile_read(t, len)
 			        -  ---

	    For use by textfile_get() only. 
	    Reads len (or less) bytes and add them to internal buffer.
	    Returns `True' if successful and `False' if no bytes added
	    (meaning at EOF)

	____
	line = textfileget(t)
			   -

	     Reads line from file and returns in line. 
	     Line is returned with \r, \n,  \r\n, \n\r included unless
	     line exceeds (approximately) `MAXLINELEN'.
*/
	    

`TextfileS' textfile_open(`SS' filename) 
{
	`TextfileS'	t

	t.fh     = fopen(filename, "r")
	t.isopen = `True'
	t.buf    = ""
	t.len    = 0 
	t.lino   = 0
	return(t)
}

void textfile_close(`TextfileS' t)
{
	if (t.isopen) {
		fclose(t.fh) 
		t.isopen = `False' 
		/* leave buf, len, lino AS-IS */
	}
}

`booleanS' textfile_read(`TextfileS' t, `RS' len)
{
	`SS'	s

	if (t.isopen) {
		if ((s = fread(t.fh, len)) == J(0, 0, "")) {
			textfile_close(t) 
			return(`False') 
		}
		t.buf = t.buf + s 
		t.len = strlen(t.buf) 
		return(`True')
	}
	return(`False')
} 
		

`SM' textfile_get(`TextfileS' t) 
{
	`SS'	line
	`RS'	cont
	`RS'	len, p_lf, p_cr, p_eol, eol_len
	`RS'	max_line_len

	/* ------------------------------------------------------------ */
				/* Buffer empty  -->  EOF		*/

	if (t.len==0) {
		if (!textfile_read(t, `BUFLEN')) return(J(0, 0, ""))
	}


	/* ------------------------------------------------------------ */
				/* Add to line until buffer 		*/
				/* contains LF or CR, or until MAXLINELEN */
	line = ""
	len  = 0

	p_lf = strpos(t.buf, `LF')
	p_cr = strpos(t.buf, `CR') 
	if ((!p_lf) & (!p_cr)) {
		max_line_len = `MAXLINELEN'
		line  = t.buf ;   len = t.len 
		t.buf = ""    ; t.len = 0 
		cont = 1
		while (cont) {
			if (!textfile_read(t, `BUFLEN')) cont = 0
			else {
				p_lf = strpos(t.buf, `LF') 
				p_cr = strpos(t.buf, `CR')
				if (p_lf | p_cr) cont = 0
				else {
					line = line + t.buf 
					len  = len  + t.len 
					t.buf = "" ; t.len = 0 
					if (len > max_line_len) {
						cont = 0
					}
				}
			}
		}
		p_lf = strpos(t.buf, `LF')
		p_cr = strpos(t.buf, `CR')
	}

	/* ------------------------------------------------------------ */
				/* if one of (LF, CR) exists, and it 	*/
				/* is at end of buffer, get one more 	*/
				/* buffer				*/

	if ((p_lf | p_cr) & (!(p_lf & p_cr))) {
		if (p_lf==t.len | p_cr==t.len) {
			if (textfile_read(t, `BUFLEN')) {
				p_lf = strpos(t.buf, `LF')
				p_cr = strpos(t.buf, `CR') 
			}
		}
	}

	/* ------------------------------------------------------------ */
				/* p_eol = pos of end of line		*/
				/* eol_len = 0, 1, 2 			*/
				/* (no eol, 1 eol chrs, 2 eol chars)	*/

	/* EOL chars are 
		\n		linefeed
		\r\n
		\r
	    That implies \n\r is two end of lines
	*/

	if  ( p_lf & !p_cr) {
		p_eol   = p_lf 
		eol_len = 1
	}
	else if (!p_lf &  p_cr) {
		p_eol   = p_cr
		eol_len = 1
	}
	else if (p_lf & p_cr) {
		if (p_lf < p_cr) {		/* \n\r	*/
			p_eol   = p_lf
			eol_len = 1
		}
		else {				/* \r\n */
			p_eol   = p_cr
			eol_len = (p_cr + 1 == p_lf ? 2 : 1)
		}
	}
	else {
		p_eol   = t.len+1
		eol_len = 0
	}

	/* ------------------------------------------------------------ */
	line  = line + substr(t.buf, 1,               p_eol-1+eol_len) 
	t.buf =        substr(t.buf, p_eol+eol_len,   .) 
	t.len = strlen(t.buf) 

	/* ------------------------------------------------------------ */
	if (eol_len) t.lino = t.lino + 1
	return(line)
}
					/* textfile input		*/
/* -------------------------------------------------------------------- */


end
