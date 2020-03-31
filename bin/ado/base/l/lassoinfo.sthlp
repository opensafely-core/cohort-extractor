{smcl}
{* *! version 1.0.0  21jun2019}{...}
{viewerdialog lassoinfo "dialog lassoinfo"}{...}
{vieweralsosee "[LASSO] lassoinfo" "mansection lasso lassoinfo"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[LASSO] lassoselect" "help lassoselect"}{...}
{vieweralsosee "[LASSO] lasso postestimation" "help lasso postestimation"}{...}
{vieweralsosee "[LASSO] lasso inference postestimation" "help lasso inference postestimation"}{...}
{viewerjumpto "Syntax" "lassoinfo##syntax"}{...}
{viewerjumpto "Menu" "lassoinfo##menu"}{...}
{viewerjumpto "Description" "lassoinfo##description"}{...}
{viewerjumpto "Links to PDF documentation" "lassoinfo##linkspdf"}{...}
{viewerjumpto "Option" "lassoinfo##option"}{...}
{viewerjumpto "Examples" "lassoinfo##examples"}{...}
{viewerjumpto "Stored results" "lassoinfo##results"}{...}
{p2colset 1 22 24 2}{...}
{p2col:{bf:[LASSO] lassoinfo} {hline 2}}Display information about lasso
estimation results{p_end}
{p2col:}({mansection LASSO lassoinfo:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
For all lasso estimation results

{p 8 17 2}
{cmd:lassoinfo} [{it:namelist}]


{pstd}
For {cmd:xpo} estimation results

{p 8 17 2}
{cmd:lassoinfo} [{it:namelist}] [{cmd:, each}]


{phang}
{it:namelist} is a name of a stored estimation result, a list of names,
{cmd:_all}, or {cmd:*}.  {cmd:_all} and {cmd:*} mean the same thing.  See
{manhelp estimates_store R:estimates store}.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Postestimation}


{marker description}{...}
{title:Description}

{pstd}
{cmd:lassoinfo} displays basic information about the lasso or lassos fit by
all commands that fit lassos.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection LASSO lassoinfoQuickstart:Quick start}

        {mansection LASSO lassoinfoRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker option}{...}
{title:Option}

{phang}
{cmd:each} applies to {cmd:xpo} models only.  It specifies that information be
shown for each lasso for each cross-fit fold to be displayed.  If
{cmd:resample} was specified, then information is shown for each lasso for each
cross-fit fold in each resample.  By default, summary statistics are shown for
the lassos.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse breathe}{p_end}
{phang2}{cmd:. dsregress react no2_class no2_home,}
	{cmd:controls(i.(meducation overweight msmoke sex) noise sev* age)}

{pstd}Display the number of variables selected in each lasso{p_end}
{phang2}{cmd:. lassoinfo}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse nlsy80, clear}{p_end}
{phang2}{cmd:. xpoivregress wage exper}
    {cmd:(educ = i.pcollege##c.(meduc feduc) i.urban sibs iq),}
    {cmd:controls(c.age##c.age tenure kww i.(married black south urban))}

{pstd}Display the number of variables selected in each lasso{p_end}
{phang2}{cmd:. lassoinfo}{p_end}

    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:lassoinfo} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(names)}}names of estimation results displayed{p_end}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:r(table)}}matrix containing the numerical values displayed{p_end}
