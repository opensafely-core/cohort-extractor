{smcl}
{* *! version 1.0.7  11feb2011}{...}
{viewerdialog sysdescribe "dialog sysdescribe"}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] describe" "help describe"}{...}
{vieweralsosee "[R] net" "help net"}{...}
{vieweralsosee "[R] ssc" "help ssc"}{...}
{vieweralsosee "[P] adopath" "help adopath"}{...}
{vieweralsosee "[P] findfile" "help findfile"}{...}
{viewerjumpto "Syntax" "sysdescribe##syntax"}{...}
{viewerjumpto "Description" "sysdescribe##description"}{...}
{viewerjumpto "Option" "sysdescribe##option"}{...}
{viewerjumpto "Examples" "sysdescribe##examples"}{...}
{viewerjumpto "Shipped datasets" "sysdescribe##shipped_dta"}{...}
{viewerjumpto "User-installed datasets" "sysdescribe##user_dta"}{...}
{title:Title}

{p 4 25 2}
{hi:[D] sysdescribe} {hline 2} Describe shipped dataset


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:sysdescribe}
[{cmd:"}]{it:filename}[{cmd:"}]

{p 8 16 2}
{opt sysdescribe dir}
[{cmd:,}
{opt all}]


{marker description}{...}
{title:Description}

{pstd}
{opt sysdescribe} {it:filename} displays a summary of the contents
of the specified Stata-format dataset that was either shipped
with Stata or is stored along the {help adopath}.  If {it:filename}
is specified without a suffix, {opt .dta} is assumed.

{pstd}
{opt sysdescribe dir} lists the names of the datasets shipped with
Stata and any other datasets stored along the {help adopath}.


{marker option}{...}
{title:Option}

{phang}
{opt all} specifies that all datasets be listed, even those that include
    an underscore ({opt _}) in their name.  Such datasets are not otherwise
    listed.


{marker examples}{...}
{title:Examples}

    {cmd:. sysdescribe auto}
    {cmd:. sysdescribe dir}
    {cmd:. describe dir, all}


{marker shipped_dta}{...}
{title:Shipped datasets}

{pstd}
A few datasets are included with Stata and are stored in the system
directories.  These datasets are often used in the help files to demonstrate a
certain feature.

{pstd}
Typing

	{cmd:. sysdescribe dir, all}

{pstd}
will list the names of those datasets.

{pstd}
The datasets shipped with Stata are stored in different folders
(directories) so that they do not become confused with your datasets.
Not all the datasets used in the manuals are shipped with Stata; shipped
datasets include only those used in the help files.  To obtain the other
datasets, see the manual datasets help page {help dta_manuals} for links
to the datasets in each manual.

{pstd}
Be aware that the datasets used to demonstrate Stata are often fictional.


{marker user_dta}{...}
{title:User-installed datasets}

{pstd}
Any datasets you have installed using {cmd:net} or {cmd:ssc} -- see
{helpb net} and {helpb ssc} -- are also listed by {cmd:sysdescribe}
{cmd:dir}, and {cmd:sysdescribe} {it:filename} will display the summary of
its contents.

{pstd}
Any datasets you store in your personal ado folder -- see
{helpb sysdir} -- are also listed by {cmd:sysdescribe} {cmd:dir}, and
{cmd:sysdescribe} {it:filename} will display the summary of its contents.
{p_end}
