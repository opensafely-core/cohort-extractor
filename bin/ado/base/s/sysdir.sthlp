{smcl}
{* *! version 1.1.7  19oct2017}{...}
{vieweralsosee "[P] sysdir" "mansection P sysdir"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] net" "help net"}{...}
{vieweralsosee "[R] query" "help query"}{...}
{vieweralsosee "[R] update" "help update"}{...}
{viewerjumpto "Syntax" "sysdir##syntax"}{...}
{viewerjumpto "Description" "sysdir##description"}{...}
{viewerjumpto "Links to PDF documentation" "sysdir##linkspdf"}{...}
{viewerjumpto "Option" "sysdir##option"}{...}
{viewerjumpto "Examples" "sysdir##examples"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[P] sysdir} {hline 2}}Query and set system directories{p_end}
{p2col:}({mansection P sysdir:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

    List Stata's system directories

	{cmd:sysdir} [{cmdab:l:ist}]


    Reset Stata's system directories

{p 8 15 2}{cmd:sysdir set} {it:codeword} [{cmd:"}]{it:path}[{cmd:"}]


    Display path of PERSONAL directory and list files in it

	{cmd:personal} [{cmd:dir}]


    Display ado-file path

	{cmd:adopath}


    Add directory to end of ado-path

{p 8 16 2}{cmd:adopath +}  {it:path_or_codeword}


    Add directory to beginning of ado-path

{p 8 16 2}{cmd:adopath ++} {it:path_or_codeword}


    Remove directory from ado-path

{p 8 16 2}{cmd:adopath -}  {c -(} {it:path_or_codeword} | {it:#} {c )-}


    Set maximum memory ado-files may consume

{phang2}{cmd:set} {cmdab:a:dosize} {it:#} [{cmd:,} {cmdab:perm:anently} ] {space 6} {bind:{cmd:10} {ul:<} {it:#} {ul:<} {cmd:10000}}


{pstd}
where {it:path} must be enclosed in double quotes if it contains blanks
or other special characters and {it:codeword} is

{pin}{c -(} {cmd:STATA} | {cmd:BASE} | {cmd:SITE} |
	{cmd:PLUS} | {cmd:PERSONAL} | {cmd:OLDPLACE} {c )-}


{marker description}{...}
{title:Description}

{pstd}
{cmd:sysdir} lists Stata's system directories.

{pstd}
{cmd:sysdir set} changes the path to Stata's system directories.

{pstd}
{cmd:personal} displays the path of the {cmd:PERSONAL} directory.
{cmd:personal dir} gives a directory listing of the files contained in the
{cmd:PERSONAL} directory.

{pstd}
{cmd:adopath} displays the ado-file path stored 
in the global macro {hi:S_ADO}.

{pstd}
{cmd:adopath +} adds a new directory or moves an existing directory to the end
of the search path stored in the global macro {hi:S_ADO}.

{pstd}
{cmd:adopath ++} adds a new directory or moves an existing directory to the
beginning of the search path stored in the global macro {hi:S_ADO}.

{pstd}
{cmd:adopath -} removes a directory from the search path stored in the 
global macro {hi:S_ADO}.

{pstd}
{cmd:set adosize} sets the maximum amount of memory in kilobytes that
automatically loaded do-files may consume.  The default is 
{cmd:set adosize 1000}.  To view the current setting, type {cmd:display}
{cmd:c(adosize)}.

{pstd}
These commands have to do with technical aspects of Stata's implementation.
Except for {cmd:sysdir list}, you should never have to use them.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection P sysdirRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker option}{...}
{title:Option}

{phang}
{cmd:permanently} specifies that, in addition to making the change right now,
    the {cmd:adosize} setting be remembered and become the default setting
    when you invoke Stata.


{marker examples}{...}
{title:Examples}

{pstd}List Stata's system directories{p_end}
{phang2}{cmd:. sysdir list}

{pstd}Display identity of {cmd:PERSONAL} directory{p_end}
{phang2}{cmd:. personal}

{pstd}List files in {cmd:PERSONAL} directory{p_end}
{phang2}{cmd:. personal dir}

{pstd}Display ado-file path{p_end}
{phang2}{cmd:. adopath}

{pstd}Add {cmd:C:\myprogs} to the end of the ado-path{p_end}
{phang2}{cmd:. adopath + C:\myprogs}

{pstd}Remove {cmd:C:\myprogs} from the ado-path{p_end}
{phang2}{cmd:. adopath - C:\myprogs}{p_end}
