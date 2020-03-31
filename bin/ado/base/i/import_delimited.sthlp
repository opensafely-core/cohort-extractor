{smcl}
{* *! version 1.1.7  17sep2019}{...}
{viewerdialog "import delimited" "dialog import_delimited_dlg"}{...}
{vieweralsosee "[D] import delimited" "mansection D importdelimited"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] export" "help export"}{...}
{vieweralsosee "[D] import" "help import"}{...}
{viewerjumpto "Syntax" "import_delimited##syntax"}{...}
{viewerjumpto "Menu" "import_delimited##menu"}{...}
{viewerjumpto "Description" "import_delimited##description"}{...}
{viewerjumpto "Links to PDF documentation" "import_delimited##linkspdf"}{...}
{viewerjumpto "Options for import delimited" "import_delimited##import_options"}{...}
{viewerjumpto "Options for export delimited" "import_delimited##export_options"}{...}
{viewerjumpto "Examples" "import_delimited##examples"}{...}
{viewerjumpto "Video example" "import_delimited##video"}{...}
{viewerjumpto "Stored results" "import_delimited##results"}{...}
{p2colset 1 25 26 2}{...}
{p2col:{bf:[D] import delimited} {hline 2}}Import and export delimited text data{p_end}
{p2col:}({mansection D importdelimited:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Load a delimited text file

{p 8 16 2}
{cmd:import} {cmdab:delim:ited} [{cmd:using}] {it:{help filename}}
[{cmd:,} {it:{help import_delimited##import_delimited_options:import_delimited_options}}]


{phang}
Rename specified variables from a delimited text file

{p 8 16 2}
{cmd:import} {cmdab:delim:ited} {it:{help import_delimited##extvarlist:extvarlist}} {cmd:using} {it:{help filename}}
[{cmd:,} {it:{help import_delimited##import_delimited_options:import_delimited_options}}]


{phang}
Save data in memory to a delimited text file

{p 8 32 2}
{cmd:export} {cmdab:delim:ited} [{cmd:using}] {it:{help filename}} {ifin}
   [{cmd:,} {it:{help import_delimited##export_delimited_options:export_delimited_options}}]


{phang}
Save subset of variables in memory to a delimited text file

{p 8 32 2}
{cmd:export} {cmdab:delim:ited} [{varlist}] {cmd:using} {it:{help filename}}
{ifin} [{cmd:,} {it:{help import_delimited##export_delimited_options:export_delimited_options}}]


{pstd}
If {it:{help filename}} is specified without an extension, {cmd:.csv} is
assumed for both {cmd:import delimited} and {cmd:export delimited}.  If
{it:filename} contains embedded spaces, enclose it in double quotes.

{marker extvarlist}{...}
{p 4 4 2}
{it:extvarlist} specifies variable names of imported columns.

{synoptset 40}{...}
{marker import_delimited_options}{...}
{synopthdr :import_delimited_options}
{synoptline}
{synopt :{opt rowr:ange([start][:end])}}row range of data to load{p_end}
{synopt :{opt colr:ange([start][:end])}}column range of data to load{p_end}
{synopt :{cmdab:varn:ames(}{it:#}|{cmd:nonames)}}treat row {it:#} of data as variable names or the data do not have variable names{p_end}
{synopt :{cmd:case(preserve}|{cmd:lower}|{cmd:upper)}}preserve the case or read variable names as lowercase (the default) or uppercase{p_end}
{synopt :{opt asflo:at}}import all floating-point data as {cmd:float}s{p_end}
{synopt :{opt asdoub:le}}import all floating-point data as {cmd:double}s{p_end}
{synopt :{cmdab:enc:oding(}{help import delimited##encoding:{it:encoding}}{cmd:)}}specify the encoding of the text file being imported{p_end}
{synopt :{cmdab:bindq:uotes(loose}|{cmd:strict}|{cmd:nobind)}}specify how to handle double quotes in data{p_end}
{synopt :{cmdab:stripq:uotes(yes}|{cmd:no}|{cmd:default)}}remove or keep double quotes in data{p_end}
{synopt :{cmdab:delim:iters("}{it:chars}{cmd:"}[{cmd:, }{cmd:collapse}|{cmd:asstring}]{cmd:)}}use {it:chars} as delimiters{p_end}
{synopt :{cmdab:parsel:ocale(}{help import delimited##locale:{it:locale}}{cmd:)}}specify the locale to use for interpreting numbers in the text file being imported{p_end}
{synopt :{cmdab:decimals:eparator(}{it:character}{cmd:)}}character to use for the decimal separator when parsing numbers{p_end}
{synopt :{cmdab:groups:eparator(}{it:character}{cmd:)}}character to use for the grouping separator when parsing numbers{p_end}
{synopt :{cmdab:maxquotedr:ows(}{it:#} | {cmd:unlimited)}}number of rows of data allowed inside a quoted string when {cmd:bindquote(strict)} is specified{p_end}
{synopt :{cmdab:numericc:ols(}{it:{help numlist}}|{cmd:_all)}}force specified columns to be numeric{p_end}
{synopt :{cmdab:stringc:ols(}{it:{help numlist}}|{cmd:_all)}}force specified columns to be string{p_end}
{synopt :{opt clear}}replace data in memory{p_end}
{synoptline}
{p2colreset}{...}

{synoptset 40 tabbed}{...}
{marker export_delimited_options}{...}
{synopthdr :export_delimited_options}
{synoptline}
{syntab :Main}
{synopt :{cmdab:delim:iter("}{it:char}{cmd:"}|{cmd:tab})}use {it:char} as delimiter{p_end}
{synopt :{opt novar:names}}do not write variable names on the first line{p_end}
{synopt :{opt nolab:el}}output numeric values (not labels) of labeled
variables{p_end}
{synopt :{opt dataf:mt}}use the variables' display format upon export{p_end}
{synopt :{opt q:uote}}always enclose strings in double quotes{p_end}
{synopt:{opt replace}}overwrite existing {it:{help filename}}{p_end}
{synoptline}
{p2colreset}{...}


{marker menu}{...}
{title:Menu}

    {title:import delimited}

{phang2}
{bf:File > Import > Text data (delimited, *.csv, ...)}

    {title:export delimited}

{phang2}
{bf:File > Export > Text data (delimited, *.csv, ...)}


{marker description}{...}
{title:Description}

{pstd}
{cmd:import delimited} reads into memory a text file in which there is one
observation per line and the values are separated by commas, tabs, or some
other delimiter.  The two most common types of text data to import are
comma-separated values ({cmd:.csv}) text files and tab-separated text files,
often {cmd:.txt} files.  Similarly, {cmd:export delimited} writes Stata's data
to a text file.

{pstd}
Stata has other commands for importing data.  If you are not sure that
{cmd:import delimited} will do what you are looking for, see
{manhelp import D} and {findalias frdatain}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D importdelimitedQuickstart:Quick start}

        {mansection D importdelimitedRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker import_options}{...}
{title:Options for import delimited}

{phang}
{opt "rowrange([start][:end])"} specifies a range of rows within
the data to load.  {it:start} and {it:end} are integer row numbers.

{phang}
{opt "colrange([start][:end])"} specifies a range of variables within
the data to load.  {it:start} and {it:end} are integer column numbers.

{phang}
{cmd:varnames(}{it:#}|{cmd:nonames)} specifies where or whether variable names
are in the data.  By default, {cmd:import delimited} tries to determine
whether the file includes variable names.  {cmd:import delimited} translates
the names in the file to valid Stata variable names.  The original names from
the file are stored unmodified as variable labels.

{phang2}
{opt varnames(#)} specifies that the variable names are in row {it:#} of the
data; any data before {it:#} should not be imported.

{phang2}
{cmd:varnames(nonames)} specifies that the variable names are not in the data.

{phang}
{cmd:case(}{cmd:preserve}|{cmd:lower}|{cmd:upper)} specifies the case of the
    variable names after import.  The default is {cmd:case(lowercase)}.

{phang}
{cmd:asfloat} imports floating-point data as type {cmd:float}.  The default
storage type of the imported variables is determined by
{helpb generate:set type}.

{phang}
{cmd:asdouble} imports floating-point data as type {cmd:double}.  The default
    storage type of the imported variables is determined by
    {helpb generate:set type}.

{marker encoding}{...}
{phang}
{cmd:encoding(}{it:encoding}{cmd:)} specifies the encoding of the text file
to be read.  The default is {cmd:encoding("latin1")}.  Specify
{cmd:encoding("utf-8")} for files to be encoded in UTF-8.
{cmd:import delimited} uses Java encoding.  A list of available encodings
can be found at
{browse "https://docs.oracle.com/javase/8/docs/technotes/guides/intl/encoding.doc.html"}.

{pmore}
Option {cmd:charset()} is a synonym for {cmd:encoding()}.

{phang}
{cmd:bindquotes(}{cmd:loose}|{cmd:strict}|{cmd:nobind)}  specifies how
    {cmd:import delimited} handles double quotes in data.  Specifying
    {opt loose} (the default) tells {cmd:import delimited} that it must have a
    matching open and closed double quote on the same line of data.
    {opt strict} tells {cmd:import delimited} that once it finds one double
    quote on a line of data, it should keep searching through the data for the
    matching double quote even if that double quote is on another line.
    Specifying {opt nobind} tells  {cmd:import delimited} to ignore double
    quotes for binding.

{phang}
{cmd:stripquotes(}{cmd:yes}|{cmd:no}|{cmd:default)} tells
    {cmd:import delimited} how to handle double quotes.  {opt yes} causes all
    double quotes to be stripped.  {opt no} leaves double quotes in the data
    unchanged.  {opt default} automatically strips quotes that can be
    identified as binding quotes.  {opt default} also will identify two
    adjacent double quotes as a single double quote because some software
    encodes double quotes that way.

{phang}
{cmd:delimiters("}{it:chars}{cmd:"}[{cmd:, collapse}|{cmd:asstring}]{cmd:)}
allows you to specify other separation characters.  For instance, if values in
the file are separated by a semicolon, specify {cmd:delimiters(";")}.  By
default, {cmd:import delimited} will check if the file is delimited by tabs or
commas based on the first line of data.  Specify {cmd:delimiters("\t")} to use
a tab character, or specify {cmd:delimiters("whitespace")} to use whitespace
as a delimiter.

{phang2}
{opt collapse} forces {cmd:import delimited} to treat multiple consecutive
delimiters as just one delimiter.

{phang2}
{opt asstring} forces {cmd:import delimited} to treat {it:chars} as one
delimiter.  By default, each character in {it:chars} is treated as an
individual delimiter.

{marker locale}{...}
{phang}
{cmd:parselocale(}{it:locale}{cmd:)} specifies the locale to use for
interpreting numbers in the text file being imported.  This option invokes an
alternative parsing method and can result in slightly different behavior than
not specifying this option.  The default is to not use a locale when parsing
numbers where the behavior is to treat {cmd:.} as the decimal separator.  A
list of available locales can be found at
{browse "https://www.oracle.com/technetwork/java/javase/java8locales-2095355.html"}.

{phang}
{cmd:decimalseparator(}{it:character}{cmd:)} specifies the character to use
for interpreting the decimal separator when parsing numbers.  This option
implicitly invokes option {cmd:parselocale()} with your system's default
locale.  {cmd:parselocale(}{it:locale}{cmd:)} can be specified to override the
default system locale.

{phang}
{cmd:groupseparator(}{it:character}{cmd:)} specifies the character to use for
interpreting the grouping separator when parsing numbers.  This option
implicitly invokes option {cmd:parselocale()} with your system's default
locale.  {cmd:parselocale(}{it:locale}{cmd:)} can be specified to override the
default system locale.

{phang}
{cmd:maxquotedrows(}{it:#} | {cmd:unlimited)} specifies the number of rows
allowed inside a quoted string when parsing the file to import.  The default
is {cmd:maxquotedrows(20)}.  If this option is specified without
{cmd:bindquote(strict)}, then {cmd:maxquotedrows()} will be ignored. 

{pmore}
Option {cmd:maxquotedrows(0)} is a synonym for {cmd:maxquotedrows(unlimited)}.

{phang}
{cmd:numericcols(}{it:{help numlist}}|{cmd:_all)} forces the data type of the
    column numbers in {it:numlist} to be numeric.  Specifying {opt _all}
    will import all data as numeric.

{phang}
{cmd:stringcols(}{it:{help numlist}}|{cmd:_all)} forces the data type of the
    column numbers in {it:numlist} to be string.  Specifying {opt _all} will
    import all data as strings.

{phang}
{opt clear} specifies that it is okay to replace the data in memory,
even though the current data have not been saved to disk.


{marker export_options}{...}
{title:Options for export delimited}

{phang}
{cmd:delimiter("}{it:char}{cmd:"}|{cmd:tab}{cmd:)} allows you to
    specify other separation characters.  For instance, if you want the values
    in the file to be separated by a semicolon, specify {cmd:delimiter(";")}.
    The default delimiter is a comma.

{pmore}
{cmd:delimiter(tab)} specifies that a tab character be used as the
delimiter.

{phang}{opt novarnames} specifies that variable names not be written in
the first line of the file; the file is to contain data values only.

{phang}
{opt nolabel} specifies that the numeric values of labeled variables
be written into the file rather than the label associated with each
value.

{phang}
{opt datafmt} specifies that all variables be exported using their display
format.  For example, the number 1000 with a display format of {cmd:%4.2f}
would export as {cmd:1000.00}, not {cmd:1000}. The default is to use the raw,
unformatted value when exporting.

{phang}
{opt quote} specifies that string variables always be enclosed in double
quotes.  The default is to only double quote strings that contain spaces or
the delimiter.

{phang}
{opt replace} specifies that {it:{help filename}} be replaced if it
already exists.


{marker examples}{...}
{title:Examples}

{pstd}
Setup{p_end}
{phang2}
{cmd:. copy https://www.stata.com/examples/auto.csv auto.csv}

{pstd}
Read this file into Stata{p_end}
{phang2}{cmd:. import delimited auto}

{pstd}
Look at what we just loaded{p_end}
{phang2}{cmd:. list}

{pstd}
Read rows 2 through 5 of {cmd:auto.csv} into Stata and then list the
data{p_end}
{phang2}{cmd:. clear}{p_end}
{phang2}{cmd:. import delimited auto, rowrange(3:6)}{p_end}
{phang2}{cmd:. list}

{pstd}
Read the first three columns and last four rows of {cmd:auto.csv} into Stata
and list the data{p_end}
{phang2}{cmd:. clear}{p_end}
{phang2}{cmd:. import delimited auto, colrange(:3) rowrange(8)}{p_end}
{phang2}{cmd:. list}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse auto, clear}

{pstd}Save the data currently in memory to {cmd:myauto.csv}{p_end}
{phang2}{cmd:. export delimited myauto}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse auto}

{pstd}Same as above but only saves a subset of the data; note the
use of the {cmd:replace} option because {cmd:myauto.csv} already exists{p_end}
{phang2}{cmd:. export delimited make mpg rep78 foreign in 1/10 using myauto,}
      {cmd:replace}{p_end}

    {hline}


{marker video}{...}
{title:Video example}

{phang}
{browse "https://www.youtube.com/watch?v=60RBNsqzL6I&feature=youtu.be":Importing delimited data}
{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:import delimited} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt :{cmd:r(N)}}number of observations imported{p_end}
{synopt :{cmd:r(k)}}number of variables imported{p_end}
{p2colreset}{...}
