{smcl}
{* *! version 1.2.9  19oct2017}{...}
{vieweralsosee "[P] unab" "mansection P unab"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] syntax" "help syntax"}{...}
{vieweralsosee "[P] varabbrev" "help novarabbrev"}{...}
{viewerjumpto "Syntax" "unab##syntax"}{...}
{viewerjumpto "Description" "unab##description"}{...}
{viewerjumpto "Links to PDF documentation" "unab##linkspdf"}{...}
{viewerjumpto "Options" "unab##options"}{...}
{viewerjumpto "Examples" "unab##examples"}{...}
{p2colset 1 13 15 2}{...}
{p2col:{bf:[P] unab} {hline 2}}Unabbreviate variable list{p_end}
{p2col:}({mansection P unab:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Expand and unabbreviate standard variable lists

{p 8 13 2}{cmd:unab} {it:lmacname} {cmd::} [{varlist}] [{cmd:,}
	{cmd:min(}{it:#}{cmd:)} {cmd:max(}{it:#}{cmd:)}
	{cmd:name(}{it:{help strings:string}}{cmd:)}]


{pstd}
Expand and unabbreviate variable lists that may contain time-series operators

{p 8 15 2}{cmd:tsunab} {it:lmacname} {cmd::} [{varlist}] [{cmd:,}
	{cmd:min(}{it:#}{cmd:)} {cmd:max(}{it:#}{cmd:)}
	{cmd:name(}{it:{help strings:string}}{cmd:)}]


{pstd}
Expand and unabbreviate variable lists that may contain time-series operators
or factor variables

{p 8 15 2}{cmd:fvunab} {it:lmacname} {cmd::} [{varlist}] [{cmd:,}
	{cmd:min(}{it:#}{cmd:)} {cmd:max(}{it:#}{cmd:)}
	{cmd:name(}{it:{help strings:string}}{cmd:)}]


{marker description}{...}
{title:Description}

{pstd}
{cmd:unab} expands and unabbreviates a varlist of existing variables,
placing the results in the local macro {it:lmacname}.  {cmd:unab} is a
low-level parsing command.  The {cmd:syntax} command is a high-level parsing
command that, among other things, also unabbreviates variable lists; see
{manhelp syntax P}.

{pstd}
The difference between {cmd:unab} and {cmd:tsunab} is that {cmd:tsunab}
allows time-series operators in {varlist}; see {help tsvarlist}.

{pstd}
The difference between {cmd:tsunab} and {cmd:fvunab} is that {cmd:fvunab}
allows factor variables in {it:varlist}; see {help fvvarlist}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection P unabRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}{cmd:min(}{it:#}{cmd:)} specifies the minimum number of variables
allowed.  The default is {hi:min(1)}.

{phang}{cmd:max(}{it:#}{cmd:)} specifies the maximum number of variables
allowed.  The default is {hi:max(120000)}.

{phang}{cmd:name(}{it:{help strings:string}}{cmd:)} provides a label that is used when
printing error messages.


{marker examples}{...}
{title:Examples: within a program}

{pstd}
Within a program that did the high-level command parsing using
{helpb syntax}, as in

{phang2}{cmd:syntax varname [if] [in], BY(string)} {it:...}

{pstd}
further low-level parsing might be needed.  For instance,

	{cmd:capture confirm var `by'}
	{cmd:if _rc == 0 {c -(}}
		{cmd:unab by : `by', max(1) name(by())}
	{cmd:{c )-}}
	{cmd:else {c -(}}
		{it:...} {txt}something else is done with {cmd:`by'} {it:...}
	{cmd:{c )-}}

{pstd}
Within a program that allows time-series variable lists, you might have

	{cmd:tsunab myvar : `myvar'}

{pstd}
The local macro {hi:myvar} would then contain the unabbreviated variable
list with time-series operators (if any) in standard form.


{title:Examples: interactive}

        {cmd:. sysuse auto}
	{cmd:. unab x : mpg wei for, name(myopt())}
	{cmd:. display "`x'"}
	{cmd:. unab x : junk}                                  (gives error message)
	{cmd:. unab x : mpg wei, max(1) name(myopt())}         (gives error message)
	{cmd:. unab x : mpg wei, max(1) name(myopt()) min(0)}  (gives error message)
	{cmd:. unab x : mpg wei, min(3) name(myopt())}         (gives error message)
	{cmd:. unab x : mpg wei, min(3) name(myopt()) max(10)} (gives error message)
	{cmd:. unab x : mpg wei, min(3) max(10)}               (gives error message)

        {cmd:. gen time = _n}
	{cmd:. tsset time}
	{cmd:. tsunab mylist : l(1/3).mpg}
	{cmd:. display "`mylist'"}
	{cmd:. tsunab mylist : l(1/3).(price turn displ)}
	{cmd:. di "`mylist'"}

	{cmd:. unab varn : mp}
	{cmd:. display "`varn'"}
	{cmd:. set varabbrev off}
	{cmd:. unab varn : mp}                                 (gives error message)
	{cmd:. set varabbrev on}
	{cmd:. unab varn : mp}
	{cmd:. display "`varn'"}
