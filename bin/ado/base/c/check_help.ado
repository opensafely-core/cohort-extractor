*! version 2.1.9  09sep2019

program check_help
	version 11
	capture mata: close_open_files()

	capture noi mata:  helpcheck()
	local rc = _rc 
	capture mata: close_open_files()
	exit `rc'
end


version 11

local Fildes	real scalar
local Asarray	transmorphic
local RS	real scalar
local RM	real matrix

local SS	string scalar
local SV	string vector
local SR	string rowvector
local SC	string colvector
local SM	string matrix


local FildesR	real vector
local ExFildes	struct ExFildesdf scalar


mata:

// uncomment when developing
// mata set matastrict on

/* -------------------------------------------------------------------- */
/*
	(`ExFildes') exfh = ex_fopen_sysfile(`SS' fname)
		open system file fname, fname of the form "<name>.<suffix>".
		System file assumed to be in BASE or UPDATES.
		File assumed to be .sthlp-like in the lines of the form
			INCLUDE help <iname>
		are substituted with contents of system file "<iname>.ihlp".

	(`SM') ex_fget(exfh)
		fget() for exfh files.  
		Tabs changed to blanks.
		Returns J(0,0,"") on EOF.

	(void) ex_fclose(exfh)
		close exfh file.
*/


struct ExFildesdf {
	`FildesR'	fh
	`SR'		fname
}


`ExFildes' ex_fopen_sysfile(`SS' fname)
{
	`ExFildes'	ex

	ex.fname = fname
	ex.fh    = fopen_sysfile(fname)
	return(ex)
}

void ex_fclose(`ExFildes' ex, |`RS' sysmode)
{
	`RS'	i, n

	if ( (n=length(ex.fh)) ) {
		if (sysmode==1 & n>1) {
			fclose(ex.fh[n])
			(void) --n
			ex.fh    = ex.fh[| 1\n |]
			ex.fname = ex.fname[| 1\n |]
		}
		else {
			for (i=n; i>=1; --i) fclose(ex.fh[i])
			ex.fh    = J(1, 0, .)
			ex.fname = J(1, 0, "")
		}
	}
}


`SM' ex_fget(`ExFildes' ex)
{
	`RS'	n
	`SM'	s, EOF, fname
	`SR'	tok

	EOF = J(0, 0, "")

	if (!(n = length(ex.fh))) return(EOF)

	if ( (s = fget(ex.fh[n])) == EOF) {
		if (n>1) {
			ex_fclose(ex, 1)
			return(ex_fget(ex))
		}
		return(EOF)
	}

	s = subinstr(s, char(9), " ")
	if (bsubstr(strtrim(s), 1, 8) != "INCLUDE ") return(s)
	tok = tokens(s)
	if (tok[2] != "help") return(s)
	if (length(tok) != 3) { 
		content_error(1, ex.fname[n], s, "malformed")
		return(ex_fget(ex))
	}

	if (bsubstr(tok[3],-5) != ".ihlp") {
		fname = tok[3] + ".ihlp"
	}
	else {
		fname = tok[3]
	}
	if ((find_sysfile(fname)) == "") {
		content_error(1, ex.fname[n], s, "file not found")
		return(ex_fget(ex))
	}

	ex_faddopen(ex, fname)
	return(ex_fget(ex))
}

void ex_faddopen(`ExFildes' ex, `SS' fname)
{
	`ExFildes'	myex

	myex = ex_fopen_sysfile(fname)

	ex.fh    = ex.fh, myex.fh
	ex.fname = ex.fname, myex.fname
}

/* -------------------------------------------------------------------- */


void helpcheck()
{
	`SC'		helpfiles, dlgfiles
	`Asarray'	A, B, C, D, E

	printf("{txt}\n")
	printf("  1.  Build *.sthlp filelist\n")
	helpfiles = sysfilelist("*.sthlp")
	printf("{txt}      %g *.sthlp files found\n", length(helpfiles))

	printf("{txt}\n")
	printf("  2.  Build help index of *.sthlp\n")
	A = help_index_build(helpfiles)
	printf("      %g help index entries\n", asarray_elements(A))

	printf("{txt}\n")
	printf("  3.  Add {c -(}marker ...{c )-}s from *.sthlp to help index\n")
	help_index_add_markers(A, helpfiles)
	printf("      %g help index entries\n", asarray_elements(A))

	printf("{txt}\n")
	printf("  4.  Add abbreviations from *help_alias.maint to help index\n")
	help_index_add_abbrevs(A)
	printf("      %g help index entries\n", asarray_elements(A))

	printf("{txt}\n")
	printf("  5.  Build smcl index from *smcl_alias.maint\n")
	B = smcl_index_build()
	printf("      %g smcl index entries\n", asarray_elements(B))

	printf("{txt}\n")
	printf("  6.  Build ihlp index from *.ihlp\n")
	C = help_index_build(sysfilelist("*.ihlp"))
	printf("      %g ihlp index entries\n", asarray_elements(C))

	printf("{txt}\n")
	printf("  7.  Build pdf index from validpdflinks.maint\n")
	D =  pdf_index_build()
	printf("      %g ihlp index entries\n", asarray_elements(D))

	printf("{txt}\n")
	printf("  8.  Build dialog index from *.dlg\n")
	dlgfiles = sysfilelist("*.dlg")
	E = help_index_build(dlgfiles)
	/* Special cases: 						*/
	/*   Unfortunately, if one of these dialogs is removed we will	*/
	/*   not detect it						*/
	if (1) {
		asarray(E, "about_dlg", "about_dlg")
		asarray(E, "ciwidth_dlg", "ciwidth_dlg")
		asarray(E, "do_dlg", "do_dlg")
		asarray(E, "import_delimited_dlg", "import_delimited_dlg")
		asarray(E, "import_fred_dlg", "import_fred_dlg")
		asarray(E, "import_haver_dlg", "import_haver_dlg")
		asarray(E, "import_sas_dlg", "import_sas_dlg")
		asarray(E, "import_spss_dlg", "import_spss_dlg")
		asarray(E, "log_dlg", "log_dlg")
		asarray(E, "power_dlg", "power_dlg")
		asarray(E, "use_dlg", "use_dlg")
	}
	printf("      %g dialog index entries\n", asarray_elements(E))

	printf("{txt}\n")
	printf("  9.  Process *.sthlp files\n")
	process_help(helpfiles, A, B, C, D, E)

	printf("{txt}\n")
	printf(" 10.  Process *smcl_alias.maint files\n")
	process_help(sysfilelist("*smcl_alias.maint"), A, B, C, D)

}

/* -------------------------------------------------------------------- */
					/* help_index_*()		*/

`Asarray' help_index_build(`SC' helpfilenames)
{
	`RS'		i
	`SS'		basename
	`Asarray'	A

	A = asarray_create()
	for (i=1; i<=length(helpfilenames); i++) {
		basename = pathrmsuffix(helpfilenames[i])
		asarray(A, basename, basename)
	}
	return(A)
}


void help_index_add_markers(`Asarray' A, `SC' helpfilenames)
{
	`RS'		i, j
	`SC'		toadd
	`SS'		marker, line
	`RM'		EOF
	`ExFildes'	exfh

	EOF = J(0, 0, "")
	for (i=1; i<=length(helpfilenames); i++) {
		exfh  = ex_fopen_sysfile(helpfilenames[i])
		while ((line = ex_fget(exfh)) != EOF) {
			toadd = process_smcl_marker(find_smcl(line, "{marker "))
			for (j=1; j<=length(toadd); j++) {
				marker = pathrmsuffix(helpfilenames[i]) + 
								"##" + toadd[j]
				asarray(A, marker, marker)
			}
		}
		ex_fclose(exfh)
	}
}


`SC' process_smcl_marker(`SC' lines)
{
	`RS'	i
	`SC'	res
	`SS'	li

	res = J(rows(lines), cols(lines), "")
	for (i=1; i<=length(lines); i++) {
		li = strtrim(bsubstr(lines[i], 8, .))
		res[i] = strtrim(bsubstr(li, 1, strlen(li)-1))
	}
	return(uniqrows(res))
}

void help_index_add_abbrevs(`Asarray' A)
{
	`RS'		i
	`SC'		filelist
	`Fildes'	fh

			/*
				process <ltr>help_alias.maint, 
				one for each letter
				two cols, alias first, then help file.
			*/

	filelist = sysfilelist("*help_alias.maint")

	for (i=1; i<=length(filelist); i++) {
		fh = fopen_sysfile(filelist[i])
		help_index_add_abbrevs_u(A, filelist[i], fh)
		fclose(fh)
	}
}
	
void help_index_add_abbrevs_u(`Asarray' A, `SS' filename, `Fildes' fh)
{
	`RS'		haserr
	`SS'		line
	`RM'		EOF
	`SR'		tok

	haserr = 0
	EOF = J(0, 0, "")

	while ((line = fget(fh)) != EOF) {

		line = subinstr(line, char(9), " ")
		tok = tokens(line)
		if (length(tok)) {
			if (length(tok)==2) {
				asarray(A, tok[1], tok[2])
				if (!asarray_contains(A, tok[2])) {
					content_error(haserr, filename, line,
							"RHS not found")
					"|"+tok[2]+"|"
				}
			}
			else {
				content_error(haserr, filename, line, 
							"invalid")
			}
		}
	}
}

					/* help_index_*()		*/
/* -------------------------------------------------------------------- */
					/* smcl_index_build()		*/


`Asarray' smcl_index_build()
{
	`RS'		i
	`SS'		line
	`SC'		filelist
	`Fildes'	fh
	`Asarray'	B
	`RM'		EOF

	B   = asarray_create()
	EOF = J(0, 0, "")

	filelist = sysfilelist("*smcl_alias.maint")

	for (i=1; i<=length(filelist); i++) {
		fh = fopen_sysfile(filelist[i])
		while ((line = fget(fh)) != EOF) {
			smcl_index_build_u(B, line)
		}
		fclose(fh)
	}
	return(B)
}


void smcl_index_build_u(`Asarray' B, `SS' userline)
{
	`SS'	line

	line = strtrim(subinstr(userline, char(9), " "))
	if (line=="" | bsubstr(line,1,1)=="*") return
	asarray(B, tokens(line)[1], 1)
}
	
					/* smcl_index_build()		*/
/* -------------------------------------------------------------------- */
					/* pdf_index_build()		*/


`Asarray' pdf_index_build()
{
	`Asarray'	D
	`Fildes'	fh
	`SS'		ffname, line
	`RM'		EOF

	if ((ffname = find_sysfile("validpdflinks.maint"))=="") {
		errprintf("file validpdflinks.maint not found\n")
		exit(601)
	}

	D   = asarray_create()
	EOF = J(0, 0, "")
	fh  = fopen(ffname, "r")
	while ((line = fget(fh)) != EOF) {
		pdf_index_build_u(D, line)
	}
	fclose(fh)
	return(D)
}

void pdf_index_build_u(`Asarray' D, `SS' userline)
{
	`SS'	line
	`SR'	tok
	`RS'	i

	line = strtrim(subinstr(userline, char(9), " "))
	if (line=="" | bsubstr(line,1,1)=="*") return

	tok = tokens(line)
	if (length(tok)!=2) {
		errprintf("line invalid:  |%s|\n", line)
		return
	}
	if ((i = strpos(tok[1], ".") - 1)<=0) {
		errprintf("line invalid:  |%s|\n", line)
		return 
	}

	if (bsubstr(tok[1], 1, i) != bsubstr(tok[2], 1, i)) {
		errprintf("line invalid:  |%s|\n", line)
		return 
	}
	asarray(D, tok[2], tok[1])
}

					/* pdf_index_build()		*/
/* -------------------------------------------------------------------- */
					/* process_help()		*/


void process_help(`SC' filelist, `Asarray' A, `ASarray' B, `ASarray' C, 
				`Asarray' D, |`Asarray' E)
{
	`ExFildes'	exfh
	`SC'		omit
	`RS'		i, haserr, db
	`SS'		line, filename
	`SM'		EOF

	EOF = J(0, 0, "")
	db = 0
	if (args()>5) db = (asarray_elements(E)>0)

	// omit has out-of-date help files (we will not check for broken
	// links in those files); we only omit the checking of links inside
	// these files, but still allow other files to point to them
	omit = (
		"_qreg.sthlp",
		"anova_10.sthlp",
		"anova_postestimation_10.sthlp",
		"asclogit.sthlp",
		"asclogit_postestimation.sthlp",
		"asmixlogit.sthlp",
		"asmixlogit_postestimation.sthlp",
		"asmprobit.sthlp",
		"asmprobit_postestimation.sthlp",
		"asroprobit.sthlp",
		"asroprobit_postestimation.sthlp",
		"charset.sthlp",
		"chelp.sthlp",
		"ci_14_0.sthlp",
		"clist.sthlp",
		"cnreg.sthlp",
		"cnreg_postestimation.sthlp",
		"dprobit.sthlp",
		"dprobit_postestimation.sthlp",
		"dvech.sthlp",
		"dvech_postestimation.sthlp",
		"fdasave.sthlp",
		"glogit.sthlp",
		"hadimvo.sthlp",
		"hsearch.sthlp",
		"icd9_13.sthlp",
		"impute.sthlp",
		"manova_10.sthlp",
		"manova_postestimation_10.sthlp",
		"meqrlogit.sthlp",
		"meqrlogit_postestimation.sthlp",
		"meqrpoisson.sthlp",
		"meqrpoisson_postestimation.sthlp",
		"merge_10.sthlp",
		"ml_10.sthlp",
		"ml_11.sthlp",
		"mleval_10.sthlp",
		"mleval_11.sthlp",
		"mlmethod_10.sthlp",
		"mlmethod_11.sthlp",
		"moptimize_11.sthlp",
		"news.sthlp",
		"optimize_11.sthlp",
		"parse.sthlp",
		"plot.sthlp",
		"sampsi.sthlp",
		"stpower.sthlp",
		"stpower_cox.sthlp",
		"stpower_exponential.sthlp",
		"stpower_logrank.sthlp",
		"vce.sthlp",
		"xmlsave.sthlp",
		"xtmelogit.sthlp",
		"xtmelogit_postestimation.sthlp",
		"xtmepoisson.sthlp",
		"xtmepoisson_postestimation.sthlp",
		"xtmixed.sthlp",
		"xtmixed_postestimation.sthlp",
		"ztnb.sthlp",
		"ztnb_postestimation.sthlp",
		"ztp.sthlp",
		"ztp_postestimation.sthlp"
	)

	for (i=1; i<=length(filelist); i++) {
		filename = filelist[i]
		if (!anyof(omit,filename)) {	// skip out-of-date files
			exfh = ex_fopen_sysfile(filename)
			haserr = 0 
			while ((line = ex_fget(exfh)) != EOF) {
				process_help_line(line, A, B, C, D, filename,
					haserr)

				if (db) process_help_line_db(line, E, filename,
					haserr)
			}
		ex_fclose(exfh)
		}
	}
}

void process_help_line(`SS' line, `Asarray' A, `Asarray' B, `Asarray' C,
				  `Asarray' D, `SS' filename, `RS' haserr)
{
	`SS' 	li

	pragma unused C  /* the .ihlp not used directly in this subroutine */

	li = line

	process_help_line_help(li, A, filename, haserr)
	process_help_line_helpb(li, A, filename, haserr)
	process_help_line_jumpto(li, A, filename, haserr)
	process_help_line_alsosee(li, A, D, filename, haserr)
	process_help_line_manhelp(li, A, filename, haserr)
	process_help_line_manhelpi(li, A, filename, haserr)
	process_help_line_opth(li, A, filename, haserr)

	process_help_line_findalias(li, B, filename, haserr)

	process_help_line_mansection(li, D, filename, haserr)

	process_help_line_manlink(li, D, filename, haserr)
}


void process_help_line_help(`SS' line, `Asarray' A, `SS' filename, `RS' haserr)
{
	`RS'	i
	`SC'	tochk

			/* {help <destination>[:...]}			*/

	tochk = find_smcl(line, "{help ")
	for (i=1; i<=length(tochk); i++) {
		check_help_link(extract_std_link(tochk[i]), A, 
					filename, line, haserr)
	}
}


void process_help_line_helpb(`SS' line, `Asarray' A, `SS' filename, `RS' haserr)
{
	`RS'	i
	`SC'	tochk

			/* {helpb <destination>[:...]}			*/

	tochk = find_smcl(line, "{helpb ")
	for (i=1; i<=length(tochk); i++) {
		check_help_link(extract_std_link(tochk[i]), A, 
					filename, line, haserr)
	}
}


void process_help_line_jumpto(`SS' line, `Asarray' A, `SS' filename, 
		`RS' haserr)
{
	`RS'	j
	`SS'    jumpto
	`SC'	tochk

			/* {viewerjumpto <destination>[:...]}		*/

	tochk = find_smcl(line,"{viewerjumpto ")
	if (!length(tochk)) return

	tochk = strtrim(bsubstr(tochk,15,.))
	if (all(strlen(tochk):==0)) return

	tochk = strtrim(bsubstr(tochk,1,strlen(tochk)-1))

	jumpto = tokens(tochk[1])[2]
	j = strpos(jumpto,"##")
	if (!j) {
		if (strmatch(jumpto,"--")) return

		/* unexpected, adjust code to skip	*/
		errprintf("unexpected jump token \`%s\` in file ", jumpto)
		errprintf("%s\n", filename)
		exit(3498)
	}
	else {
		/* check for "help file##marker"			*/
		tochk = tokens(jumpto)
		if (length(tochk)==2 & strtrim(tochk[1])=="help") {
			jumpto = strtrim(tochk[2])
		}
	}
	check_help_link(jumpto, A, filename, line, haserr)
}


void process_help_line_alsosee(`SS' line, `Asarray' A, `Asarray' D, 
		`SS' filename, `RS' haserr)
{
	`RS'	j, n, bad
	`SS'    asee, wh, reason
	`SC'	tochk, toks

			/* {vieweralsosee <destination>[:...]}		*/

	tochk = find_smcl(line,"{vieweralsosee ")
	if (!length(tochk)) return

	tochk = strtrim(bsubstr(tochk,16,.))
	if (all(strlen(tochk):==0)) return

	tochk = strtrim(bsubstr(tochk,1,strlen(tochk)-1))

	tochk = tokens(tochk)
	if (length(tochk)<2) return
	
	asee = tochk[2]
	if (asee=="--") return

	toks = tokens(asee)
	n = length(toks)
	wh = toks[1]
	if (wh == "mansection") {
		bad = 0
		if (n >= 3) {
			asee = strlower(strtrim(toks[2]))
			for (j=3; j<=n; j++) asee = asee+strtrim(toks[j])

			if (!asarray_contains(D, asee)) {
				bad = 1
				reason = sprintf("%s not found", asee)
			}
		}
		else if (n == 2) {
			// this handles cases like the following with no
			// subsection listed (top level manual entry):
			// {vieweralsosee "[ERM]" "mansection ERM"}
			asee = strlower(strtrim(toks[2]))
		}
		else {
			bad = 1
			reason = "malformed"
		}
		if (bad) content_error(haserr, filename, line, reason)
	}
	else if (wh == "help") {
		asee = strtrim(toks[2])
		for (j=3; j<=n; j++) asee = asee + "_" + strtrim(toks[j])

		check_help_link(asee, A, filename, line, haserr)
	}
	else if ( wh=="net_mnu" | wh=="searchadvice") {
		check_help_link(strtrim(toks[1]), A, filename, line, haserr)
	}
	else if (wh == "browse") {
		printf("\nvieweralsosee in file %s: check URL\n\t%s\n", 
			filename, toks[2])
	}
	else if (wh == "net") {
		printf("\nvieweralsosee in file %s: check the net link\n\t%s\n",
			filename, asee)
	}
	else {
		errprintf("unexpected alsosee token \`%s\` in file %s\n", wh,
			filename)
		exit(3498)
	}
}


void process_help_line_db(`SS' line, `Asarray' E, `SS' filename, `RS' haserr)
{
	`RS'	i, bad
	`SS'	db, wh, reason
	`SC'	tochk, tools
	

			/* {viewerdialog <destination>[:...]}		*/

	/* Special cases: 						*/
	if ((strpos(line, `"{viewerdialog help "help_d"}"')>0) | 
(strpos(line, `"{viewerdialog "import excel" "dialog import_excel_dlg"}"')>0) |
(strpos(line, `"{viewerdialog net "net from https://www.stata.com/"}"')>0) |
(strpos(line, `"{viewerdialog "net search" "net_d"}"')>0) |
(strpos(line, `"{viewerdialog dir "ado dir"}"')>0) |
(strpos(line, `"{viewerdialog "ado find()" "ado_d"}"')>0) |
(strpos(line, `"{viewerdialog predict "dialog predict"}"')>0) |
(strpos(line, `"{viewerdialog save "dialog save_dlg"}"')>0) |
(strpos(line, `"{viewerdialog view "view_d"}"')>0) |
(strpos(line, `"{viewerdialog "SEM Builder" "stata sembuilder"}"')>0) |
(strpos(line, `"{viewerdialog search "search_d"}"')>0)) {
		return ;	
	}

	tools = ("edit","varmanage","browse","doedit")
	tochk = find_smcl(line, "{viewerdialog ")
	if (!length(tochk)) return

	tochk = strtrim(bsubstr(tochk,15,.))
	if (all(strlen(tochk):==0)) return

	tochk = strtrim(bsubstr(tochk,1,strlen(tochk)-1))
	tochk = strtrim(tokens(tochk[1]))
	if (!(bad=(length(tochk)<2))) {
		tochk = strtrim(tokens(tochk[2]))
		if (!(bad=(length(tochk)<2))) {
			wh = strtrim(tochk[1])
			db = strtrim(tochk[2])
			i = strpos(db,",")
			if (i) db = strtrim(bsubstr(db,1,i-1))

			bad = !(strlen(db))
		}
		else if (tochk[1]=="--") return
	}
	if (bad) reason = "malformed"
	else if (wh == "dialog") {
		if (!asarray_contains(E, db)) {
			bad = 1
			reason = sprintf("%s not found", db)
		}
	}
	else if (wh == "stata") {
		i = 0
		while (++i<=length(tools)) {
			if (db==tools[i]) break
		}
		if (i>length(tools)) {
			printf("unexpected dialog tokens \`stata %s\` ",
				db)
			printf("in file %s\n", filename)
/* Just show error message, but do not exit!
			exit(3498)
*/
		}
	}
	else {
		bad = 1
		reason = "malformed"
	}
	if (bad) {
		content_error(haserr, filename, line, reason)
	}
}


void process_help_line_manhelp(`SS' line, `Asarray' A, 
						`SS' filename, `RS' haserr)
{
	`RS'	i
	`SC'	tochk

			/* {help <destination>[:...]}			*/

	tochk = find_smcl(line, "{manhelp ")
	for (i=1; i<=length(tochk); i++) {
		check_help_link(tokens(tochk[i])[2], A, 
					filename, line, haserr)
	}
}


void process_help_line_manhelpi(`SS' line, `Asarray' A, 
						`SS' filename, `RS' haserr)
{
	`RS'	i
	`SC'	tochk

			/* {help <destination>[:...]}			*/

	tochk = find_smcl(line, "{manhelpi ")
	for (i=1; i<=length(tochk); i++) {
		check_help_link(tokens(tochk[i])[2], A, 
					filename, line, haserr)
	}
}


void process_help_line_opth(`SS' line, `Asarray' A, `SS' filename, `RS' haserr)
{
	`RS'	i, col1, col2
	`SS'	li, chk
	`SC'	tochk

		/*
			{opth intm:ethod(asmprobit##seqtype:seqtype)}
		*/

	tochk = find_smcl(line, "{opth ")
	for (i=1; i<=length(tochk); i++) {
		li = strtrim(bsubstr(tochk[i], 6, .))
		col1 = strpos(li, "(")
		col2 = find_matching_paren(li, col1)
		if (col1 & col2>col1+1) {
			chk = bsubstr(li, col1+1, col2-col1-1)
			if ((col1 = strpos(chk, ":"))) {
				chk = bsubstr(chk, 1, col1-1)
			}
		}
		else 	chk = strtrim(li)

		check_help_link(chk, A, filename, line, haserr)
	}
}

`RS' find_matching_paren(`SS' s, `RS' col)
{
	`SS'	c
	`RS'	np
	`RS'	i, len


	if (col==0) return(0)
	assert(bsubstr(s, col, 1)=="(")

	
	len = strlen(s)
	np   = 0
	for (i=col; i<=len; i++) {
		c = bsubstr(s, i, 1)
		if (c=="(") np++
		else if (c==")") {
			if ((--np)==0) return(i)
		}
	}
	return(0)
}


void process_help_line_findalias(`SS' line, `Asarray' B, `SS' filename, `RS' haserr)
{
	`RS'	i
	`SC'	tochk
	`SS'	chk

	tochk = find_smcl(line, "{findalias ")
	for (i=1; i<=length(tochk); i++) {
		chk = bsubstr(tochk[i], 11, .)
		chk = strtrim(bsubstr(chk, 1, strlen(chk)-1))
		if (!asarray_contains(B, chk)) {
			content_error(haserr, filename, line, 
					sprintf("%s not found", chk))
		}
	}

}



void process_help_line_mansection(`SS' line, `Asarray' D, 
					`SS' filename, `RS' haserr)
{
	`RS'	i, j, bad
	`SC'	tochk
	`SR'	toks
	`SS'	li, reason

	/*
           ----+----1----+----2----+----3----+
	   {mansection XT xtregMethodsandformulasxtreg,re:{it:xtreg, re}}
	*/

	tochk = find_smcl(line, "{mansection ")
	for (i=1; i<=length(tochk); i++) {
		bad = 0
		toks = tokens(strtrim(bsubstr(tochk[i], 12, .)))
		li = toks[2]

		if ((j=strpos(li, ":"))==0) j = strpos(li, "}")
		if (j>1) {
			li = manrefline(toks[1], bsubstr(li, 1, j-1))
			if (!asarray_contains(D, li)) {
				bad = 1
				reason = sprintf("%s not found", li)
			}
		}
		else {
			bad = 1
			reason = "malformed"
		}
		if (bad) content_error(haserr, filename, line, reason)
	}
}


void process_help_line_manlink(`SS' line, `Asarray' D, 
					`SS' filename, `RS' haserr)
{
	`RS'	i, j, bad
	`SC'	tochk
	`SR'	toks
	`SS'	li, prefix, rest, reason

	/*
           ----+----1----+----2----+----3----+
	   {manlink R anova postestimation}
	   {manlinki G addplot_option}
           ----+----1----+----2----+----3----+
	*/

	tochk = find_smcl(line, "{manlink ") \ find_smcl(line, "{manlinki ")
	for (i=1; i<=length(tochk); i++) {
		bad = 0
		if ((j=strpos(tochk[i], ":"))==0) j = strpos(tochk[i], "}")
		if (j<1) {
			bad = 1 
			reason = "malformed"
		}
		else {
			li     = bsubstr(tochk[i], 1, j-1)
			toks   = tokens(li)
			prefix = strlower(toks[2])
			if (length(toks)>2) {
				rest   = toks[3]
			}
			else {	// we have something like {manlink SP}
				rest   = ""
			}
			for (j=4; j<=length(toks); j++) rest = rest + toks[j]
			li = manrefline(prefix, rest)
			if (!asarray_contains(D, li)) {
				bad = 1
				reason = sprintf("%s not found", li)
			}
		}
		if (bad) content_error(haserr, filename, line, reason)
	}
}


`SS' manrefline(`SS' prefix, `SS' rest)
{
	`SS'	result

	/*
		right quotes get stripped
		~ get stripped
		$ get stripped
		[] stripped
		{} stripped
		# stripped
		left quotes stripped
	*/

	result = subinstr(rest, "#", "")
	result = subinstr(result, "[", "")
	result = subinstr(result, "]", "")
	result = subinstr(result, "{", "")
	result = subinstr(result, "}", "")
	result = subinstr(result, "~", "")
	result = subinstr(result, "$", "")

	return(strlower(prefix) + result)
}



`SS' extract_std_link(`SS' users)
{
	`RS'	i
	`SS'	s, t, c
	

	/* 
		{<tag> <link>}
		{<tag> <link>:<text>}
		{<tag> "<link>"}
		{<tag> "<link>":<text>}
	*/

	if (!(i = strpos(users, " "))) return("BADTAG")
	s = strtrim(bsubstr(users, i, .))
	if (bsubstr(s, 1, 1)!=`"""') {
		if (!(i = strpos(s, ":"))) i = strlen(s)
		return(bsubstr(s, 1, i-1))
	}

	if ( (i = strpos(t = bsubstr(s, 2, .), `"""')) ) {
		c = bsubstr(t, i+1, 1)
		if (c==":" | c=="}") return(bsubstr(t, 1, i-1))
	}
	return(bsubstr(s,1,strlen(s)-1))
}




void check_help_link(`SS' link, `Asarray' A, 
				`SS' filename, `SS' line, `RS' haserr)
{
	`RS'	i
	`SS'	chk, lhs, sub

	chk = fix_help_ref(link)    
	if (asarray_contains(A, chk)) return

	if ((i=strpos(chk, "##"))) {
		lhs = bsubstr(chk, 1, i-1)
		if (asarray_contains(A, lhs)) {
			if ((sub = asarray(A, lhs)) != lhs) {
				sub = sub + bsubstr(chk, i, .)
				if (asarray_contains(A, sub)) return
			}
		}
	}

	content_error(haserr, filename, line, sprintf("%s not found", chk))
}



					/* process_help()		*/
/* -------------------------------------------------------------------- */


/* -------------------------------------------------------------------- */
					/* utilities			*/

/*
		      ______
	content_error(haserr, filename, line, txt)
		      ------  --------  ----  ---

		standard error message handler.

*/


void content_error(`boolean' haserr, `SS' filename, `SS' line, `SS' txt)
{
	`SS'	li
	if (!haserr) {
		printf("\n")
		printf("%s:\n", filename)
		haserr = 1
	}
	li = subinstr(strtrim(line), "{", "{c -(}")
	printf("{p 4 4 2}\n")
	printf("%s\n", li)
	printf("{p_end}\n")
	printf("        -- %s\n", txt)
}


/*
	(string colvector) syusfilelist("<filter>")

	return string colvector containing all files found matching 
	"<filter>".
*/


`SC' sysfilelist(`SS' filter)
{
	return(uniqrows(
			sysfilelist_u(c("sysdir_base"), filter) \ 
			sysfilelist_u(c("sysdir_updates"), filter)
		       ) )
}

`SC' sysfilelist_u(`SS' dir, `SS' filter)
{
	`RS'	i 
	`SC'	files, subdirs

	files = dir(dir, "files", filter)
	subdirs = sort(dir(dir, "dirs", "*"), 1)
	for (i=1; i<=length(subdirs); i++) {
		files = files \ dir(pathjoin(dir,subdirs[i]), "files", filter)
	}
	return(files)
}


/*
	(string scalar) find_sysfile("<filename>")

	returns "<path>/<filename>" if found, "" if not.
*/
		

`SS' find_sysfile(`SS' filename)
{
	return(findfile(filename, "UPDATES;BASE"))
}

/*
	(`Fildes') fopen_sysfile("<filename>")

	Find in system directories and open <filename>
*/


`Fildes' fopen_sysfile(`SS' filename)
{
	return(fopen(find_sysfile(filename), "r"))
}


/*
	(string colvector) find_smcl(userline, smcl)

	return all occurrences of smcl in userline.
	smcl might be "{help ".  
*/


`SC' find_smcl(`SS' userline, `SS' smcl)
{
	`RS'	l
	`SS'	line, res


	line = userline 
	res  = J(0, 1, "")
	while (l=strpos(line, smcl)) {
		res = res \ extractsmcl(line, l)
	}
	return(res)
}


`SS' extractsmcl(`SS' line, `RS' l)
{
	`RS'	i, len, nbr
	`SS'	c, res


	line = bsubstr(line, l, .)
	len  = strlen(line)

	nbr = 0 
	for (i=1; i<=len; i++) {
		c = bsubstr(line, i, 1)
		if (c == "{") nbr++ 
		else if (c == "}") { 
			if (--nbr == 0) {
				res  = bsubstr(line, 1, i)
				line = bsubstr(line, i+1, .)
				return(res)
			}
		}
	}
	line = ""
	return("")
}


/*
	(string scalar) fix_help_ref(userref)

	Map user reference to help file such as 
        {help <userref>:...}, to processed reference.
*/


`SS' fix_help_ref(`SS' userref)
{
	`RS'	i, hasrhs
	`SS'	ref, c, rhs

			/*
				remove % and #
				substitute _ for -

        			1.  if mata @()   -> mf_@
				2.  change blanks to _
				3.  if @()        -> f_@

				4. r(#) 	  -> #
			*/

	ref       = strtrim(userref)

	c = bsubstr(ref, 1, 1)
	if (c=="%" | c=="#") ref = bsubstr(ref, 2, .)


	if ((i=strpos(ref, "##"))) {
		rhs = bsubstr(ref, i+2, .)
		ref = bsubstr(ref, 1, i-1)
		hasrhs = 1
	}
	else	hasrhs = 0

	ref = strlower(ref)

	ref = subinstr(ref, "-", "_")
	ref = subinstr(ref, ":", "")

	ref = maybe_map_to_number(ref)


	if (bsubstr(ref, -2, .)=="()") {
		if (bsubstr(ref, 1, 5)=="mata ") {
			ref = "mf_" + strtrim(bsubstr(ref, 5, .))
		}
		else	ref = "f_" + ref
		ref = bsubstr(ref, 1, strlen(ref)-2)
	}
	ref = subinstr(ref, " ", "_")

	if (hasrhs) ref = ref + "##" + rhs

	return(ref)
}

`SS' maybe_map_to_number(`SS' ref)
{
	`RS'	i
	`SS'	c, s

	if (bsubstr(ref, 1, 2) != "r(") return(ref)
	if (bsubstr(ref, 3, 1) == ")") return(ref)

	s = bsubstr(ref, 3, .)
	for (i=1; i<=7; i++) {
		c = bsubstr(s, i, 1)
		if (!(c>="0" & c<="9" | c==")")) return(ref)
		if (c==")") return(bsubstr(s, 1, i-1))
	}
	return(ref)
}



/*
	(void) close_open_files()

	This may (will) produce an error.  Right way to run is 

		capture mata: close_open_files()
*/
		

void close_open_files()
{
	`RS'	i
	for (i=1; i<=200; i++) _fclose(i)
}

end
