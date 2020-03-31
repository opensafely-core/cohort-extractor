{smcl}
{* *! version 2.0.6  14may2018}{...}
{viewerdialog "SEM Builder" "stata sembuilder"}{...}
{vieweralsosee "[SEM] sem and gsem option from()" "mansection SEM semandgsemoptionfrom()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SEM] sem" "help sem_command"}{...}
{vieweralsosee "[SEM] gsem" "help gsem_command"}{...}
{vieweralsosee "[SEM] sem and gsem path notation" "help sem_and_gsem_path_notation"}{...}
{vieweralsosee "[SEM] sem model description options" "help sem_model_options"}{...}
{vieweralsosee "[SEM] gsem model description options" "help gsem_model_options"}{...}
{vieweralsosee "[SEM] gsem estimation options" "help gsem_estimation_options"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] maximize" "help maximize"}{...}
{viewerjumpto "Syntax" "sem_and_gsem_option_from##syntax"}{...}
{viewerjumpto "Description" "sem_and_gsem_option_from##description"}{...}
{viewerjumpto "Links to PDF documentation" "sem_and_gsem_option_from##linkspdf"}{...}
{viewerjumpto "Option" "sem_and_gsem_option_from##option"}{...}
{viewerjumpto "Remarks" "sem_and_gsem_option_from##remarks"}{...}
{viewerjumpto "Examples" "sem_and_gsem_option_from##examples"}{...}
{p2colset 1 37 39 2}{...}
{p2col:{bf:[SEM] sem and gsem option from()} {hline 2}}Specifying starting values{p_end}
{p2col:}({mansection SEM semandgsemoptionfrom():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{c -(}{cmd:sem}|{cmd:gsem}{c )-} ... [{cmd:,} ... {cmd:from(}{it:matname}
                     [{cmd:,} {opt skip}]{cmd:)} ...]

{p 8 12 2}
{c -(}{cmd:sem}|{cmd:gsem}{c )-} ... [{cmd:,} ... {cmd:from(}{it:svlist}{cmd:)} ...]

{pstd}
where {it:matname} is the name of a Stata matrix and 

{pstd}
where {it:svlist} is a space-separated list of the form

{phang2}{it:eqname}{cmd::}{it:name} {cmd:=} {it:#}{p_end}


{marker description}{...}
{title:Description}

{pstd}
See {manlink SEM Intro 12} for a description of starting values.

{pstd}
Starting values are usually not specified.  When there are convergence
problems, it is often necessary to specify starting values.  You can specify
starting values by using

{phang2}
1.  suboption {opt init()} as described in
{helpb sem_and gsem path_notation##item16:[SEM] sem and gsem path notation}, or by using

{phang2}
2.  option {opt from()} as described here. 

{pstd}
Option {opt from()} is especially convenient for using the solution
of one model as starting values for another. 


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection SEM semandgsemoptionfrom()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker option}{...}
{title:Option}

{phang}
{cmd:skip} is an option of {opt from(matname)}.  It specifies to ignore
any parameters in {it:matname} that do not appear in the model being fit.
If this option is not specified, the existence of such parameters causes 
{cmd:sem} ({cmd:gsem}) to issue an error message.


{marker remarks}{...}
{title:Remarks}

{pstd}
See
{it:{mansection SEM semandgsemoptionfrom()Remarksandexamples:Remarks and examples}}
of {manlink SEM sem and gsem option from()} for further information. 


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse sem_2fmm}{p_end}

{pstd}Fit a reduced two-factor measurement model{p_end}
{phang2}{cmd:. sem (Affective -> a1 a2 a3 a4)}{break}
	{cmd:(Cognitive -> c1 c2 c3 c4)}{p_end}

{pstd}Copy results in {cmd:e(b)}{p_end}
{phang2}{cmd:. matrix b = e(b)}{p_end}

{pstd}Add parameters to the above model and specify starting values{p_end}
{phang2}{cmd:. sem (Affective -> a1 a2 a3 a4 a5)}{break}
	{cmd:(Cognitive -> c1 c2 c3 c4 c5), from(b)}{p_end}

{pstd}Use the alternative notation to specify a list of starting values{p_end}
{phang2}{cmd:. sem (Affective -> a1 a2 a3 a4 a5)}{break}
	{cmd:(Cognitive -> c1 c2 c3 c4 c5),}{break}
	{cmd: from(a2:Affective = 1 a3:Affective = 1)}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse gsem_cfa}{p_end}

{pstd}Fit a one-factor measurement model{p_end}
{phang2}{cmd:. gsem (MathAtt -> att1-att5, ologit)}{p_end}

{pstd}Copy results in {cmd:e(b)}{p_end}
{phang2}{cmd:. matrix b = e(b)}{p_end}

{pstd}Fit a two-factor measurement model using results from the one-factor 
model as starting values{p_end}

{phang2}{cmd:. gsem (MathAtt -> att1-att5, ologit)}{break} 
        {cmd:(MathAb -> q1-q8, logit), from(b)}{p_end}

    {hline}
