{smcl}
{* *! version 2.0.4  23oct2017}{...}
{viewerdialog "SEM Builder" "stata sembuilder"}{...}
{vieweralsosee "[SEM] sem and gsem syntax options" "mansection SEM semandgsemsyntaxoptions"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SEM] gsem" "help gsem_command"}{...}
{vieweralsosee "[SEM] sem" "help sem_command"}{...}
{vieweralsosee "[SEM] sem and gsem path notation" "help sem and gsem path notation"}{...}
{viewerjumpto "Syntax" "sem_and_gsem_syntax_options##syntax"}{...}
{viewerjumpto "Description" "sem_and_gsem_syntax_options##description"}{...}
{viewerjumpto "Links to PDF documentation" "sem_and_gsem_syntax_options##linkspdf"}{...}
{viewerjumpto "Options" "sem_and_gsem_syntax_options##options"}{...}
{viewerjumpto "Remarks" "sem_and_gsem_syntax_options##remarks"}{...}
{viewerjumpto "Examples" "sem_and_gsem_syntax_options##examples"}{...}
{p2colset 1 38 40 2}{...}
{p2col:{bf:[SEM] sem and gsem syntax options} {hline 2}}Options affecting
interpretation of syntax{p_end}
{p2col:}({mansection SEM semandgsemsyntaxoptions:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{cmd:sem} {it:{help sem and gsem path notation:paths}} ... {cmd:,} ... {it:syntax_options}

{p 8 12 2}
{cmd:gsem} {it:{help sem and gsem path notation:paths}} ... {cmd:,} ... {it:syntax_options}

{synoptset 24}{...}
{synopthdr:syntax_options}
{synoptline}
{synopt :{opt lat:ent}{cmd:(}{it:names}{cmd:)}}explicitly specify latent variable names{p_end}
{synopt :{opt nocaps:latent}}do not treat capitalized {it:Names} as latent{p_end}
{synoptline}

{pstd}
where {it:names} is a space-separated list of the names of the latent
variables.


{marker description}{...}
{title:Description}

{pstd}
These options affect some minor issues of how {cmd:sem} and {cmd:gsem}
interpret what you type.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection SEM semandgsemsyntaxoptionsRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opt latent(names)} specifies that {it:names} is the full
set of names of the latent variables.
{cmd:sem} and {cmd:gsem} ordinarily assume that latent variables
have the first letter capitalized and observed variables have the first letter
lowercased; see
{helpb sem_and gsem path_notation:[SEM] sem and sem path notation}.  When you
specify {opt latent(names)}, {cmd:sem} and {cmd:gsem} treat the listed
variables as the latent variables and all other variables, regardless of
capitalization, as observed.  {opt latent()} implies {opt nocapslatent}.

{phang}
{opt nocapslatent} specifies that having the first letter capitalized does not
designate a latent variable.  This option can be used when fitting models with
observed variables only where some observed variables in the dataset have the
first letter capitalized.


{marker remarks}{...}
{title:Remarks}

{pstd}
We recommend using the default naming convention.  If your dataset
contains variables with the first letter capitalized, it is easy to convert
the variables to have lowercase names by typing

{phang2}{cmd:. rename *, lower}{p_end}

{pstd}
See {helpb rename_group:[D] rename groups}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse sem_2fmm}{p_end}

{pstd}Two-factor measurement model{p_end}
{phang2}{cmd:. sem (Affective -> a1 a2 a3 a4 a5) (Cognitive -> c1 c2 c3 c4 c5)}{p_end}

{pstd}Directly specify latent variables{p_end}
{phang2}{cmd:. sem (Affective -> a1 a2 a3 a4 a5) (Cognitive -> c1 c2 c3 c4 c5),}{break}
	{cmd: latent(Affective Cognitive)}{p_end}

{pstd}Rename {cmd:a1} and {cmd:a2}{p_end}
{phang2}{cmd:. rename (a1 a2) (A1 A2)}{p_end}

{pstd}Do not treat capitalized names as latent variables{p_end}
{phang2}{cmd:. sem (affective -> A1 A2 a3 a4 a5) (cognitive -> c1 c2 c3 c4 c5),}{break}
	{cmd:  nocapslatent latent(affective cognitive)}{p_end}
