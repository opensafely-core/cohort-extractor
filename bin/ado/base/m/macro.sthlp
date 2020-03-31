{smcl}
{* *! version 1.1.11  07mar2019}{...}
{vieweralsosee "[P] macro" "mansection P macro"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] char" "help char"}{...}
{vieweralsosee "[P] creturn" "help creturn"}{...}
{vieweralsosee "[P] display" "help display"}{...}
{vieweralsosee "[FN] Functions by category" "help functions"}{...}
{vieweralsosee "[P] gettoken" "help gettoken"}{...}
{vieweralsosee "[P] macro lists" "help macrolists"}{...}
{vieweralsosee "[P] matrix" "help matrix"}{...}
{vieweralsosee "[P] numlist" "help nlist"}{...}
{vieweralsosee "[P] preserve" "help preserve"}{...}
{vieweralsosee "[P] program" "help program"}{...}
{vieweralsosee "[P] return" "help return"}{...}
{vieweralsosee "[P] scalar" "help scalar"}{...}
{vieweralsosee "[M-5] st_global()" "help mf_st_global"}{...}
{vieweralsosee "[M-5] st_local()" "help mf_st_local"}{...}
{vieweralsosee "[P] syntax" "help syntax"}{...}
{vieweralsosee "[P] tokenize" "help tokenize"}{...}
{viewerjumpto "Syntax" "macro##syntax"}{...}
{viewerjumpto "Description" "macro##description"}{...}
{viewerjumpto "Links to PDF documentation" "macro##linkspdf"}{...}
{viewerjumpto "Remarks" "macro##remarks"}{...}
{p2colset 1 14 16 2}{...}
{p2col:{bf:[P] macro} {hline 2}}Macro definition and manipulation{p_end}
{p2col:}({mansection P macro:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 17 2}{cmdab:gl:obal}{space 3}{it:mname} {space 1} [{cmd:=}{it:{help exp}} |
		{cmd::}{it:{help macro##macro_fcn:macro_fcn}} |
		{cmd:"}[{it:string}]{cmd:"} |
		{cmd:`}{cmd:"}[{it:string}]{cmd:"}{cmd:'}]

{p 8 17 2}{cmdab:loc:al}{space 4}{it:lclname} [{cmd:=}{it:{help exp}} |
		{cmd::}{it:{help macro##macro_fcn:macro_fcn}} |
		{cmd:"}[{it:string}]{cmd:"} |
		{cmd:`}{cmd:"}[{it:string}]{cmd:"}{cmd:'}]

{p 8 17 2}{cmd:tempvar}{space 2}{it:lclname} [{it:lclname} [{it:...}]]

{p 8 17 2}{cmd:tempname} {it:lclname} [{it:lclname} [{it:...}]]

{p 8 17 2}{cmd:tempfile} {it:lclname} [{it:lclname} [{it:...}]]

{p 8 17 2}{cmdab:loc:al} {c -(} {cmd:++}{it:lclname} | {cmd:--}{it:lclname} {c )-}

{p 8 14 2}{cmdab:ma:cro} {cmdab:di:r}

{p 8 14 2}{cmdab:ma:cro} {cmd:drop} {c -(} {it:mname} [{it:mname} [{it:...}]] |
		{it:mname}{cmd:*} | {cmd:_all} {c )-}

{p 8 14 2}{cmdab:ma:cro} {cmdab:l:ist} [ {it:mname} [{it:mname} [{it:...}]] |
		{cmd:_all} ]

{p 8 14 2}{cmdab:ma:cro} {cmdab:s:hift} [{it:#}]

{p 8 14 2} [{it:...}] {cmd:`}{it:expansion_optr}{cmd:'} [{it:...}]


{pstd}
where {it:expansion_optr} is

{phang2}
{it:lclname} {c |}
{cmd:++}{it:lclname} {c |}
{it:lclname}{cmd:++} {c |}
{cmd:--}{it:lclname} {c |}
{it:lclname}{cmd:--} {c |}
{cmd:=}{it:exp} {c |}
{cmd::}{it:macro_fcn} {c |}
{cmd:.}{it:class_directive} {c |}
{cmd:macval(}{it:lclname}{cmd:)}


{marker macro_fcn}{...}
{phang}
and where {it:macro_fcn} is any of the following:


{pstd}Macro function for extracting program properties

{p 8 12 2}
{cmd:properties} {it:command}


{pstd}Macro function for extracting program results class

{p 8 12 2}
{cmd:results} {it:command}


{pstd}Macro functions for extracting data attributes

{p 8 12 2}
{cmdab:t:ype} {varname}

{p 8 12 2}
{cmdab:f:ormat} {varname}

{p 8 12 2}
{cmdab:val:ue} {cmdab:l:abel} {varname}

{p 8 12 2}
{cmdab:var:iable} {cmdab:l:abel} {varname}

{p 8 12 2}
{cmd:data} {cmdab:l:abel}

{p 8 12 2}
{cmdab:sort:edby}

{p 8 14 2}
{cmdab:lab:el} {c -(} {it:valuelabelname} |
		{cmd:(}{varname}{cmd:)} {c )-}
		{c -(} {cmd:maxlength} | {it:#} [{it:#_2}] {c )-}
		[{cmd:,} {cmd:strict} ]
		
{p 8 12 2}
{cmd:constraint} {c -(} {cmd:dir} | {it:#} {c )-}

{p 8 12 2}
{cmd:char} {c -(} {varname}{cmd:[]} |
		{varname}{cmd:[}{it:charname}{cmd:]} {c )-}

{p 8 12 2}
{cmd:char} {c -(} {cmd:_dta[]} | {cmd:_dta[}{it:charname}{cmd:]} {c )-}


{pstd}Macro function for naming variables

{p 8 12 2}
{cmd:permname} {it:suggestedname}
		[{cmd:,} {cmdab:l:ength:(}{it:#}{cmd:)} ]
		

{pstd}Macro functions for filenames and file paths

{p 8 12 2}
{cmd:adosubdir} [{cmd:"}]{it:{help filename}}[{cmd:"}]

{p 8 13 2}
{cmd:dir} [{cmd:"}]{it:dirname}[{cmd:"}]
	{c -(}{cmdab:file:s}|{cmdab:dir:s}|{cmd:other}{c )-}
	[{cmd:"}]{it:pattern}[{cmd:"}]
	[{cmd:,} {cmd:nofail} {cmdab:respect:case}]

{p 8 15 2}
{cmd:sysdir} [ {cmd:STATA} | {cmd:BASE} | {cmd:SITE} |
		{cmd:PLUS} | {cmd:PERSONAL} | {it:dirname} ]
		

{pstd}Macro function for accessing operating-system parameters

{p 8 12 2}
{cmdab:env:ironment} {it:name}


{pstd}Macro functions for names of stored results

{p 8 12 2}
{cmd:e(scalars} | {cmd:macros} | {cmd:matrices} | {cmd:functions)}{p_end}

{p 8 12 2}
{cmd:r(scalars} | {cmd:macros} | {cmd:matrices} | {cmd:functions)}

{p 8 12 2}
{cmd:s(macros)}

{p 8 12 2}
{cmd:all} {c -(}{cmd:globals}|{cmd:scalars}|{cmd:matrices}{c )-}
	[{cmd:"}{it:pattern}{cmd:"}]

{p 8 12 2}
{cmd:all} {c -(}{cmd:numeric}|{cmd:string}{c )-} {cmd:scalars}
	[{cmd:"}{it:pattern}{cmd:"}]


{pstd}Macro function for formatting results

{p 8 12 2}
{cmdab:di:splay} {it:{help display:display_directive}}


{pstd}Macro functions for manipulating lists

{p 8 12 2}
{cmd:list} {it:{help macrolists:macrolist_directive}}


{pstd}Macro functions related to matrices

{p 8 12 2}
{cmdab:rown:ames} {space 3} {it:matrixname}

{p 8 12 2}
{cmdab:coln:ames} {space 3} {it:matrixname}

{p 8 12 2}
{cmdab:rowf:ullnames} {it:matrixname}

{p 8 12 2}
{cmdab:colf:ullnames} {it:matrixname}

{p 8 12 2}
{cmdab:rowe:q} {space 6} {it:matrixname} [{cmd:,} {cmdab:q:uoted} ]

{p 8 12 2}
{cmdab:cole:q} {space 6} {it:matrixname} [{cmd:,} {cmdab:q:uoted} ]

{p 8 12 2}
{cmd:rownumb} {space 4} {it:matrixname} {it:string}

{p 8 12 2}
{cmd:colnumb} {space 4} {it:matrixname} {it:string}

{p 8 12 2}
{cmd:roweqnumb} {space 2} {it:matrixname} {it:string}

{p 8 12 2}
{cmd:coleqnumb} {space 2} {it:matrixname} {it:string}

{p 8 12 2}
{cmd:rownfreeparms} {space 2} {it:matrixname}

{p 8 12 2}
{cmd:colnfreeparms} {space 2} {it:matrixname}

{p 8 12 2}
{cmd:rownlfs} {space 2} {it:matrixname}

{p 8 12 2}
{cmd:colnlfs} {space 2} {it:matrixname}

{p 8 12 2}
{cmd:rowsof} {space 2} {it:matrixname}

{p 8 12 2}
{cmd:colsof} {space 2} {it:matrixname}

{p 8 12 2}
{cmd:rowvarlist} {space 2} {it:matrixname}

{p 8 12 2}
{cmd:colvarlist} {space 2} {it:matrixname}

{p 8 12 2}
{cmd:rowlfnames} {space 2} {it:matrixname} [{cmd:,} {cmdab:q:uoted} ]

{p 8 12 2}
{cmd:collfnames} {space 2} {it:matrixname} [{cmd:,} {cmdab:q:uoted} ]


{pstd}Macro function related to time-series operators

{p 8 12 2}
{cmd:tsnorm} {it:string} [{cmd:,} {cmdab:v:arname} ]


{pstd}Macro function for copying a macro

{p 8 12 2}
{cmd:copy} {c -(} {cmdab:loc:al} | {cmdab:gl:obal} {c )-}
{it:mname}


{marker parsing}{...}
{pstd}Macro functions for parsing

{p 8 12 2}
{cmd:word count} {it:string}{p_end}

{p 8 12 2}
{cmd:word} {it:#} {cmd:of} {it:string}

{p 8 12 2}
{cmd:piece} {it:#_1} {it:#_2} {cmd:of}
		[{cmd:`}]{cmd:"}{it:string}{cmd:"}[{cmd:'}]
		[{cmd:,} {cmdab:nob:reak} ]

{p 8 12 2}
{cmd:strlen} {c -(} {cmdab:loc:al} | {cmdab:gl:obal} {c )-} {it:mname}

{p 8 12 2}
{cmd:ustrlen} {c -(} {cmdab:loc:al} | {cmdab:gl:obal} {c )-} {it:mname}

{p 8 12 2}
{cmd:udstrlen} {c -(} {cmdab:loc:al} | {cmdab:gl:obal} {c )-} {it:mname}

{p 8 17 2}
{cmd:subinstr} {c -(} {cmdab:loc:al} | {cmdab:gl:obal} {c )-}
		{it:mname} [{cmd:`}]{cmd:"}{it:from}{cmd:"}[{cmd:'}]
		[{cmd:`}]{cmd:"}{it:to}{cmd:"}[{cmd:'}]
		[{cmd:,} {cmd:all} {cmdab:w:ord}
		{cmdab:c:ount:(}{c -(} {cmdab:loc:al} | {cmdab:gl:obal} {c )-}
		{it:mname}{cmd:)} ]


{marker description}{...}
{title:Description}

{pstd}
{cmd:global} assigns strings to specified global macro names ({it:mnames}).
{cmd:local} assigns strings to local macro names ({it:lclnames}).  Both
double quotes ({cmd:"} and {cmd:"}) and compound double quotes 
({cmd:`"} and {cmd:"'}) are allowed; see {help quotes}.  If the {it:string}
has embedded quotes, compound double quotes are needed.

{pstd}
{cmd:tempvar} assigns names to the specified local macro names that may be
used as temporary variable names in a dataset.  When the program or do-file
concludes, any variables with these assigned names are dropped.

{pstd}
{cmd:tempname} assigns names to the specified local macro names that may be
used as temporary scalar or matrix names.  When the program or do-file
concludes, any scalars or matrices with these assigned names are dropped.

{pstd}
{cmd:tempfile} assigns names to the specified local macro names that may be
used as names for temporary files.  When the program or do-file concludes, any
datasets created with these assigned names are erased.

{pstd}
{cmd:macro} manipulates global and local macros.

{pstd}
See {findalias frmacros} for information on macro substitution.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection P macroRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

        {help macro##remarks1:Macro function for extracting program properties}
        {help macro##remarks1b:Macro function for extracting program results class}
	{help macro##remarks2:Macro functions for extracting data attributes}
	{help macro##remarks3:Macro function for naming variables}
	{help macro##remarks4:Macro functions for filenames and file paths}
	{help macro##remarks5:Macro function for accessing operating-system parameters}
	{help macro##remarks6:Macro functions for names of stored results}
	{help macro##remarks7:Macro function for formatting results}
	{help macro##remarks8:Macro function for manipulating lists}
	{help macro##remarks9:Macro functions related to matrices}
	{help macro##remarks10:Macro function related to time-series operators}
	{help macro##remarks11:Macro function for copying a macro}
	{help macro##remarks12:Macro functions for parsing}


{marker remarks1}{...}
    {title:Macro function for extracting program properties}

{phang2}
{cmd:properties} {it:command}
{break}
returns the properties declared for {it:command}; see 
{manhelp program_properties P:program properties}.


{marker remarks1b}{...}
    {title:Macro function for extracting program results class}

{phang2}
{cmd:results} {it:command}
{break}
returns the results class -- {cmd:nclass}, {cmd:eclass}, {cmd:rclass}, or
{cmd:sclass} -- declared for {it:command}; see {manhelp program P:program}.


{marker remarks2}{...}
    {title:Macro functions for extracting data attributes}

{phang2}
{cmd:type} {varname}
{break}
returns the storage type of {it:varname}, which might be {cmd:int},
{cmd:long}, {cmd:float}, {cmd:double}, {cmd:str1}, {cmd:str2}, etc.

{phang2}
{cmd:format} {varname}
{break}
returns the display format associated with {it:varname}; for instance,
{cmd:%9.0g} or {cmd:%12s}.

{phang2}
{cmd:value label} {varname}
{break}
returns the name of the value label associated with {it:varname}, which 
might be "" (meaning no label), or, for example, {cmd:make}, meaning that the
value label's name is {cmd:make}.

{phang2}
{cmd:variable label} {varname}
{break}
returns the variable label associated with {it:varname}, which might be 
"" (meaning no label), or, for example, {cmd:Repair Record 1978}.

{phang2}
{cmd:data label}
{break}
returns the dataset label associated with the dataset currently in memory,
which might be "" (meaning no label), or, for example,
{cmd:1978 Automobile Data}. See {manhelp label D}.

{phang2}
{cmd:sortedby}
{break}
returns the names of the variables by which the data in memory are currently
sorted, which might be {bind:""} (meaning not sorted), or, for example, 
{cmd:foreign mpg}, meaning that the data are in the order of variable
{cmd:foreign}, and, within that, in the order of {cmd:mpg} (the order that
would be obtained from the Stata command {cmd:sort foreign mpg}).  See
{manhelp sort D}.

{phang2}
{cmd:label} {it:valuelabelname}
	{c -(} {cmd:maxlength} | {it:#} [{it:#_2}] {c )-}
	[{cmd:,} {cmd:strict} ]
{break}
returns the value label of {it:#} in {it:valuelabelname}.  For instance,
{cmd:label forlab 1} might return {cmd:Foreign cars} if {cmd:forlab} were the
name of a value label and 1 mapped to "Foreign cars".  If 1 did not correspond
to any mapping within the value label, or if the value label {cmd:forlab} were
not defined, {cmd:1} (the {it:#} itself) would be returned.

{pmore2}
{it:#}_2 optionally specifies the maximum length of the label to be returned.
If {cmd:label forlab 1} would return {cmd:Foreign cars}, then
{cmd:label forlab 1 6} would return {cmd:Foreig}.

{pmore2}
{cmd:maxlength} specifies that, rather than looking up a number in a value
label, {cmd:label} return the maximum length of the labelings.
For instance, if value label {cmd:yesno} mapped 0 to {cmd:no} and 1 to
{cmd:yes}, then its {cmd:maxlength} would be 3 because {cmd:yes} is the
longest label and it has three characters.

{pmore2}
{cmd:strict} specifies that nothing is to be returned if there is no value
label for {it:#}.

{phang2}
{cmd:label} {cmd:(}{varname}{cmd:)}
	{c -(} {cmd:maxlength} | {it:#} [{it:#_2}] {c )-}
	[{cmd:,} {cmd:strict} ]
{break}
works exactly as the above, except that rather than specifying the 
{it:valuelabelname} directly, you indirectly specify it.  The value label name
associated with {it:varname} is used, if there is one.  If not, it is treated
just as if {it:valuelabelname} were undefined, and the number itself is 
returned.

{phang2}
{cmd:constraint} {c -(} {it:#} | {cmd:dir} {c )-}
{break}
gives information on constraints.

{pmore2}
{cmd:constraint} {it:#} puts constraint {it:#} in {it:mname} or returns
{bind:""} if constraint {it:#} is not defined. {cmd:constraint} {it:#}
for {it:#} < 0 is an error.

{pmore2}
{cmd:constraint dir} returns an unsorted
numerical list of those constraints that are currently defined. For example,

                {cmd:. constraint 1 price = weight}
		
	        {cmd:. constraint 2 mpg > 20}
		
	        {cmd:. local myname : constraint 2}
		
	        {cmd:. macro list _myname}
	        {cmd:_myname         mpg > 20}

	        {cmd:. local aname : constraint dir}

	        {cmd:. macro list _aname}
    	        {cmd:_aname:  2 1}

{phang2}
{cmd:char} {c -(} {varname}{cmd:[]} |
{it:varname}{cmd:[}{it:charname}{cmd:]} {c )-} {space 2}or{space 2}{p_end}
{phang2}
{cmd:char} {c -(} {cmd:_dta[]} | {cmd:_dta[}{it:charname}{cmd:]} {c )-}
{break}
returns information on the characteristics of a dataset; see {manhelp char P}.
For instance,

	        {cmd:. sysuse auto}

	        {cmd:. char mpg[one] "this"}
		
		{cmd:. char mpg[two] "that"}

		{cmd:. local x : char mpg[one]}

		{cmd:. di "`x'"}
		{cmd:this}

		{cmd:. local x : char mpg[nosuch]}

		{cmd:. di "`x'"}

		{cmd:. local x : char mpg[]}

		{cmd:. di "`x'"}
		{cmd:two one}


{marker remarks3}{...}
    {title:Macro function for naming variables}

{phang2}
{cmd:permname} {it:suggested_name} [{cmd:,} {cmd:length(}{it:#}{cmd:)} ]
{break}
returns a valid new variable name based on {it:suggested_name} in
{it:matname}, where {it:suggested_name} must follow naming conventions but may
be too long or correspond to an already existing variable.

{pmore2}
{cmd:length(}{it:#}{cmd:)} specifies the maximum length of the returned
variable name, which must be between 8 and 32.  {cmd:length(32)} is the
default. For instance,

		{cmd:. local myname : permname foreign}

		{cmd:. macro list _myname}
		{cmd:_myname:      foreign1}

		{cmd:. local aname : permname displacement, length(8)}

		{cmd:. macro list _aname}
		{cmd:_aname        displace}


{marker remarks4}{...}
    {title:Macro functions for filenames and file paths}

{phang2}
{cmd:adosubdir} [{cmd:"}]{it:{help filename}}[{cmd:"}]
{break}
puts in {it:mname} the subdirectory in which Stata would search for
this file along the {help adopath:ado-path}.
Typically, the directory name would
be the first letter of {it:filename}.  However, certain files
may result in a different directory name depending on their extension.

{phang2}
{cmd:dir} [{cmd:"}]{it:dirname}[{cmd:"}]
	{c -(} {cmd:files} | {cmd:dirs} | {cmd:other} {c )-}
	[{cmd:"}]{it:pattern}[{cmd:"}] [{cmd:,} {cmd:nofail}
	{cmd:respectcase}]
{break}
puts in {it:mname} the specified files, directories, or entries that are
neither files nor directories, from directory {it:dirname} and matching pattern
{it:pattern}, where the pattern matching is defined by Stata's
{helpb f_strmatch:strmatch({it:s1},{it:s2})} function.  The quotes in the
command are optional but recommended, and they are nearly always required
surrounding {it:pattern}.  The returned string will contain each of the
names, separated one from the other by spaces and each enclosed in double
quotes.  If {it:mname} is subsequently used in a quoted context, it
must be enclosed in compound double quotes: {cmd:`"`}{it:mname}{cmd:'"'}.

{pmore2}
The {cmd:nofail} option specifies that if the directory contains too many
filenames to fit into a macro, rather than issuing an error message, the
filenames that fit into {it:mname} should be returned.  {cmd:nofail} should
rarely, if ever, be specified.

{pmore2}
In Windows only, the {cmd:respectcase} option specifies that {cmd:dir}
respect the case of filenames when performing matches.  Unlike other
operating systems, Windows has, by default, case-insensitive filenames.
{cmd:respectcase} is ignored in operating systems other than Windows.

{pmore2}
For example,

{pmore2}
{cmd:local list : dir . files "*"} makes a list of all regular files in the
current directory.  In {cmd:list} might be returned {cmd:"subjects.dta"}
{cmd:"step1.do"} {cmd:"step2.do"} {cmd:"reest.ado"}.

{pmore2}
{cmd:local list : dir . files "s*", respectcase} in Windows makes a list of
all regular files in the current directory that begin with a lowercase "s".
The case of characters in the filenames is preserved.  In Windows, without
the {cmd:respectcase} option, all filenames would be converted to lowercase
before being compared with {it:pattern} and possibly returned.
                                                                                
{pmore2}
{cmd:local list : dir . dirs "*"} makes a list of all subdirectories of the
current directory.  In {cmd:list} might be returned {cmd:"notes"}
{cmd:"subpanel"}.
                                                                                
{pmore2}
{cmd:local list : dir . other "*"} makes a list of all things that are neither
regular files nor directories.  These files rarely occur and might be, for
instance, Unix device drivers.
                                                                                
{pmore2}
{cmd:local list : dir "\mydir\data" files "*"} makes a list of all regular
files that are to be found in {cmd:\mydir\data}.  Returned might be
{cmd:"example.dta"} {cmd:"make.do"} {cmd:"analyze.do"}.

{pmore2}
It is the names of the files that are returned, not their full path names.

{pmore2}
{cmd:local list : dir "subdir" files "*"} makes a list of all regular files
that are to be found in {cmd:subdir} of the current directory.

{phang2}
{cmd:sysdir} [ {cmd:STATA} | {cmd:BASE} | {cmd:SITE} |
{cmd:PLUS} | {cmd:PERSONAL} ]
{break}
returns the various Stata system directory paths; see {manhelp sysdir P}.
The path is returned with a trailing separator; for example, {cmd:sysdir STATA}
might return {cmd:D:\PROGRAMS\STATA\}.

{phang2}
{cmd:sysdir} {it:dirname}
{break}
returns {it:dirname}.  This function is used to code 
{cmd:local x : sysdir `dir'}, where {cmd:`dir'} might contain the name of a
directory specified by a user or a keyword, such as {cmd:STATA} or
{cmd:BASE}.  The appropriate directory name will be returned.  The path is
returned with a trailing separator.


{marker remarks5}{...}
    {title:Macro function for accessing operating-system parameters}

{phang2}
{cmd:environment} {it:name}
{break}
returns the contents of the operating system's environment variable {it:name},
or {bind:""} if {it:name} is undefined.


{marker remarks6}{...}
    {title:Macro functions for names of stored results}

{phang2}
{cmd:e(scalars} | {cmd:macros} | {cmd:matrices} | {cmd:functions)}
{break}
returns the names of all the stored results in {cmd:e()} of the specified type,
with the names listed one after the other and separated by one space.  For
instance, {cmd:e(scalars)} might return {cmd:N ll_0 ll df_m chi2 r2_p},
meaning that scalar stored results {cmd:e(N)}, {cmd:e(ll_0)}, ... exist.

{phang2}
{cmd:r(scalars} | {cmd:macros} | {cmd:matrices} | {cmd:functions)}
{break}
returns the names of all the stored results in {cmd:r()} of specified type.

{phang2}
{cmd:s(macros)}
{break}
returns the names of all the stored results in {cmd:s()} of type macro, which
is the only type that exists within {cmd:s()}.

{phang2}
{cmd:all} {c -(} {cmd:globals} | {cmd:scalars} | {cmd:matrices} {c )-}
	[{cmd:"}{it:pattern}{cmd:"}]
{break}
puts in {it:mname} the specified globals, scalars, or matrices that match
the {it:pattern}, where the pattern matching is defined by Stata's
{helpb f_strmatch:strmatch({it:s1},{it:s2})} function.

{phang2}
{cmd:all} {c -(} {cmd:numeric} | {cmd:string} {c )-} {cmd:scalars}
	[{cmd:"}{it:pattern}{cmd:"}]
{break}
puts in {it:mname} the specified numeric or string scalars that match the
{it:pattern}, where the pattern matching is defined by Stata's
{helpb f_strmatch:strmatch({it:s1},{it:s2})} function.


{marker remarks7}{...}
    {title:Macro function for formatting results}

{phang2}
{cmd:display} {it:display_directive}
{break}
returns the results from the {helpb display} command.  The {cmd:display}
function is the {cmd:display} command, except that the output is
rerouted to a macro rather than the screen.

{pmore2}
You can use all the features of {cmd:display} that make sense.  That is, you
may not set styles with {cmd:as} {it:style} because macros do not have
colors, you may not use {cmd:_continue} to suppress going to a new line on the
real display (it is not being displayed), you may not use {cmd:_newline} (for
the same reason), and you may not use {cmd:_request} to obtain input from the
console (because input and output have nothing to do with macro definition).
Everything else works.  See {manhelp display P}.

{pmore2}
Example:
                {cmd:local x : display %9.4f sqrt(2)}


{marker remarks8}{...}
    {title:Macro function for manipulating lists}

{phang2}
{cmd:list} {it:macrolist_directive}
{break}
fills in {it:mname} with the {it:{help macrolists:macrolist_directive}},
which specifies one of many available commands or operators for working with
macros that contain lists; see {manhelp macrolists P:macro lists}.


{marker remarks9}{...}
    {title:Macro functions related to matrices}

{pstd}
In understanding the functions below, remember that the {it:fullname} of a
matrix row or column is defined as {it:eqname}{cmd::}{it:name}.  For
instance, {it:fullname} might be {cmd:outcome:weight}, and then the
{it:eqname} is {cmd:outcome} and the {it:name} is {cmd:weight}.  Or the
{it:fullname} might be {cmd:gnp:L.cpi}, and then the {it:eqname} is {cmd:gnp}
and the {it:name} is {cmd:L.cpi}.  Or the {it:fullname} might be {cmd:mpg},
in which case the {it:eqname} is {bind:""} and the {it:name} is {cmd:mpg}.
Or the {it:fullname} might be {cmd:gnp:1.south#1.smsa}, and then the
{it:eqname} is {cmd:gnp} and the {it:name} is {cmd:1.south#1.smsa}.
For more information, see {manhelp matrix_define P:matrix define}.

{phang2}
{cmd:rownames} {space 3} {it:matrixname}{p_end}
{phang2}
{cmd:rowfullnames} {it:matrixname}{p_end}
{phang2}
{cmd:roweq} {space 6} {it:matrixname} [{cmd:,} {cmd:quoted} ]
{break}
return the names of the rows of {it:matname}; see {help matmacfunc}.

{phang2}
{cmd:colnames} {space 3} {it:matrixname}{p_end}
{phang2}
{cmd:colfullnames} {it:matrixname}{p_end}
{phang2}
{cmd:coleq} {space 6} {it:matrixname} [{cmd:,} {cmd:quoted} ]
{break}
return the names of the columns of {it:matname}; see {help matmacfunc}.

{phang2}
{cmd:rownumb} {space 4} {it:matrixname} {it:string}
{break}
returns the row number of {it:matname} that matches {it:string}; see
{help matmacfunc}.

{phang2}
{cmd:colnumb} {space 4} {it:matrixname} {it:string}
{break}
returns the column number of {it:matname} that matches {it:string};
see {help matmacfunc}.

{phang2}
{cmd:roweqnumb} {space 2} {it:matrixname} {it:string}
{break}
returns the row equation number of {it:matname} that matches {it:string}; see
{help matmacfunc}.

{phang2}
{cmd:coleqnumb} {space 2} {it:matrixname} {it:string}
{break}
returns the column equation number of {it:matname} that matches {it:string};
see {help matmacfunc}.

{phang2}
{cmd:colnfreeparms} {space 2} {it:matrixname}{break}
returns the number of free parameter columns of {it:matname};
see {help matmacfunc}.

{phang2}
{cmd:rownfreeparms} {space 2} {it:matrixname}{break}
returns the number of free parameter rows of {it:matname};
see {help matmacfunc}.

{phang2}
{cmd:colnlfs} {space 2} {it:matrixname}{break}
returns the number of linear forms among the columns of {it:matname};
see {help matmacfunc}.

{phang2}
{cmd:rownlfs} {space 2} {it:matrixname}{break}
returns the number of linear forms among the rows of {it:matname};
see {help matmacfunc}.

{phang2}
{cmd:colsof} {space 2} {it:matrixname}{break}
returns the number of columns of {it:matname};
see {help matmacfunc}.

{phang2}
{cmd:rowsof} {space 2} {it:matrixname}{break}
returns the number of rows of {it:matname};
see {help matmacfunc}.

{phang2}
{cmd:colvarlist} {space 2} {it:matrixname}{break}
returns the variable list corresponding to the columns of {it:matname};
see {help matmacfunc}.

{phang2}
{cmd:rowvarlist} {space 2} {it:matrixname}{break}
returns the variable list corresponding to the rows of {it:matname};
see {help matmacfunc}.

{phang2}
{cmd:collfnames} {space 2} {it:matrixname} [{cmd:,} {cmd:quoted} ]
{break}
returns the list of names corresponding to the linear forms in the columns
of {it:matname};
see {help matmacfunc}.

{phang2}
{cmd:rowlfnames} {space 2} {it:matrixname} [{cmd:,} {cmd:quoted} ]
{break}
returns the list of names corresponding to the linear forms in the rows
of {it:matname};
see {help matmacfunc}.


{marker remarks10}{...}
    {title:Macro function related to time-series operators}

{phang2}
{cmd:tsnorm} {it:string}
{break}
returns the canonical form of {it:string} when {it:string} is interpreted as a
time-series operator.  For instance, if {it:string} is {cmd:ldl}, then
{cmd:L2D} is returned, or if {it:string} is {cmd:l.ldl}, then {cmd:L3D} is
returned.  If {it:string} is nothing, {bind:""} is returned.

{phang2}
{cmd:tsnorm} {it:string}{cmd:, varname}
{break}
returns the canonical form of {it:string} when {it:string} is interpreted as a
time-series-operated variable.  For instance, if {it:string} is {cmd:ldl.gnp},
then {cmd:L2D.gnp} is returned, and if {it:string} is {cmd:l.ldl.gnp}, then
{cmd:L3D.gnp} is returned.  If {it:string} is just a variable name, the
variable name is returned.


{marker remarks11}{...}
    {title:Macro function for copying a macro}

{phang2}
{cmd:copy} {c -(} {cmd:local} | {cmd:global} {c )-} {it:mname}
{break}
returns a copy of the contents of {it:mname}, or an empty string if
{it:mname} is undefined.


{marker remarks12}{...}
{marker parsing_desc}{...}
    {title:Macro functions for parsing}

{phang2}
{cmd:word count} {it:string}
{break}
returns the number of words in {it:string}.  A token is a word (characters
separated by spaces) or set of words enclosed in quotes.  Do not enclose
{it:string} in double quotes because {cmd:word count} will return {cmd:1}.

{phang2}
{cmd:word} {it:#} {cmd:of} {it:string}
{break}
returns the {it:#}th token of {it:string}.  Do not enclose {it:string}
in double quotes.

{phang2}
{cmd:piece} {it:#_1} {it:#_2} {cmd:of}
[{cmd:`}]{cmd:"}{it:string}{cmd:"}[{cmd:'}] [{cmd:,} {cmd:nobreak} ]
{break}
returns a piece of {it:string}.  This macro function provides a smart
method of breaking a string into pieces of roughly the specified
{mansection U 12.4.2.2DisplayingUnicodecharacters:display columns}.
{it:#_1} specifies which piece to obtain.  {it:#_2} specifies the maximum
number of display columns of each piece.  Each piece is built trying to fill
to the maximum number of display columns without breaking in the middle of a
word.  However, when a word takes more display columns than {it:#_2}, the word
will be split unless {cmd:nobreak} is specified.  {cmd:nobreak} specifies that
words not be broken, even if that would result in a string being displayed in
more than {it:#_2} columns.

{pmore2}
Compound double quotes may be used around {it:string} and must be used when
{it:string} itself might contain double quotes.

{phang2}
{cmd:strlen} {c -(} {cmd:local} | {cmd:global} {c )-} {it:mname}
{break}
returns the length of the contents of {it:mname} in bytes.  If 
{it:mname} is undefined, {cmd:0} is returned. For instance,

                {cmd:. constraint 1 price = weight}

		{cmd:. local myname : constraint 1}

		{cmd:. macro list _myname}
		{cmd:_myname          price = weight}

		{cmd:. local lmyname : strlen local myname}

		{cmd:. macro list _lmyname}
		{cmd:_lmyname:        14}

{phang2}
{cmd:ustrlen} {c -(} {cmd:local} | {cmd:global} {c )-} {it:mname}
{break}
returns the length of the contents of {it:mname} in Unicode characters.  If 
{it:mname} is undefined, {cmd:0} is returned. 

{phang2}
{cmd:udstrlen} {c -(} {cmd:local} | {cmd:global} {c )-} {it:mname}
{break}
returns the length of the contents of {it:mname} in
{mansection U 12.4.2.2DisplayingUnicodecharacters:display columns}.
If {it:mname} is undefined, {cmd:0} is returned. 

{phang2}
{cmd:subinstr} {cmd:local} {it:mname} {cmd:"}{it:from}{cmd:"}
{cmd:"}{it:to}{cmd:"}
{break}
    returns the contents of {it:mname}, with the first occurrence of
    "{it:from}" changed to "{it:to}".
                                                                                
{phang2}
{cmd:subinstr} {cmd:local} {it:mname} {cmd:"}{it:from}{cmd:"}
{cmd:"}{it:to}{cmd:", all}
{break}
    does the same thing but changes all occurrences of "{it:from}" to
    "{it:to}".

{phang2}
{cmd:subinstr} {cmd:local} {it:mname} {cmd:"}{it:from}{cmd:"}
{cmd:"}{it:to}{cmd:", word}
{break}
    returns the contents of {it:mname}, with the first occurrence of the word
    "{it:from}" changed to "{it:to}".  A word is defined as a space-separated
token or a token at the beginning or end of the string.

{phang2}
{cmd:subinstr} {cmd:local} {it:mname} {cmd:"}{it:from}{cmd:"}
{cmd:"}{it:to}{cmd:", all word}
{break}
    does the same thing but changes all occurrences of the word "{it:from}"
    to "{it:to}".
                                                                                
{phang2}
{cmd:subinstr} {cmd:global} {it:mname} ...
{break}
    is the same as the above but obtains the original string
    from the global macro {cmd:$mname} rather than from the local macro
    {it:mname}.

{phang2}
{cmd:subinstr} ... {cmd:global} {it:mname} ...{cmd:,} ... 
{cmd:count(} {c -(} {cmd:global} | {cmd:local} {c )-} {it:mname2}{cmd:)}
{break}
     in addition to the usual, places a count of the number of
     substitutions in the specified global or in local macro {it:mname2}.
{p_end}
