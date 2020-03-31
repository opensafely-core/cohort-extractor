{smcl}
{* *! version 2.1.4  14may2018}{...}
{viewerdialog "SEM Builder" "stata sembuilder"}{...}
{vieweralsosee "[SEM] sem path notation extensions" "mansection SEM sempathnotationextensions"}{...}
{vieweralsosee "[SEM] Intro 2" "mansection SEM Intro2"}{...}
{vieweralsosee "[SEM] Intro 6" "mansection SEM Intro6"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SEM] sem" "help sem_command"}{...}
{vieweralsosee "[SEM] sem and gsem path notation" "help sem and gsem path notation"}{...}
{viewerjumpto "Syntax" "sem_path_notation_extensions##syntax"}{...}
{viewerjumpto "Description" "sem_path_notation_extensions##description"}{...}
{viewerjumpto "Links to PDF documentation" "sem_path_notation_extensions##linkspdf"}{...}
{viewerjumpto "Options" "sem_path_notation_extensions##options"}{...}
{viewerjumpto "Examples" "sem_path_notation_extensions##examples"}{...}
{p2colset 1 39 41 2}{...}
{p2col:{bf:[SEM] sem path notation extensions} {hline 2}}Command syntax for
path diagrams{p_end}
{p2col:}({mansection SEM sempathnotationextensions:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{cmd:sem} {it:paths} ... [{cmd:,} {opt covariance()} {opt variance()} 
            {opt means()} {opth group(varname)}]

{p 8 12 2}
{cmd:sem} {it:paths} ... [{cmd:,} {opt covstructure()}
            {opt means()} {opth group(varname)}]

{pstd}
{it:paths} specifies the direct paths between the variables of your model.

{pstd}
The model to be fit is fully described by {it:paths}, 
{opt covariance()}, {opt variance()},
{opt covstructure()}, and {opt means()}.

{pstd}
The syntax of these elements is modified (generalized) when the
{cmd:group()} option is specified.


{marker description}{...}
{title:Description}

{pstd}
This entry concerns {cmd:sem} only.

{pstd}
The command syntax for describing your SEMs is fully
specified by {it:paths}, {opt covariance()}, {opt variance()},
{opt covstructure()}, and {opt means()}.  How that works is described in
{helpb sem and gsem path notation:[SEM] sem and gsem path notation} and
{helpb sem and gsem option covstructure:[SEM] sem and gsem option covstructure()}.
See those section before reading this section.

{pstd}
This entry concerns the path features unique to {cmd:sem}, and
that has to do with the {cmd:group()} option for comparing different
groups.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection SEM sempathnotationextensionsRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opt covariance()},
{opt variance()}, and
{opt means()} are described in
{helpb sem and gsem path notation:[SEM] sem and gsem path notation}.

{phang}
{opt covstructure()} is described in
{helpb sem and gsem option covstructure:[SEM] sem and gsem option covstructure()}.

{phang}
{opth group(varname)}
allows models specified with {it:paths}, {cmd:covariance()}, {cmd:variance()},
{cmd:covstructure()}, and {cmd:means()} to be automatically generalized
(interacted) with the groups defined by {it:varname}; see
{manlink SEM Intro 6}.  The syntax of {it:paths} and the arguments of
{cmd:covariance()}, {cmd:variance()}, {cmd:covstructure()}, and {cmd:means()}
gain an extra syntactical piece when {cmd:group()} is specified.


{marker examples}{...}
{title:Examples}

{title:Examples: Specifying a multiple group model}

{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}

{pstd}A simple regression model{p_end}
{phang2}{cmd:. sem (mpg <- turn trunk length)}{p_end}

{pstd}Specify groups{p_end}
{phang2}{cmd:. sem (mpg <- turn trunk length), group(foreign)}{p_end}

{pstd}Alternative notation to above{p_end}
{phang2}{cmd:. sem (0: mpg <- turn trunk length)}{break}
	{cmd: (1: mpg <- turn trunk length), group(foreign)}{p_end}


{title:Examples: Specifying means(), covariance(), and variance() options with groups}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse sem_2fmmby}{p_end}

{pstd}Measurement model with groups{p_end}
{phang2}{cmd:. sem (Peer -> peerrel1 peerrel2 peerrel3 peerrel4)}{break}
        {cmd:(Par -> parrel1 parrel2 parrel3 parrel4), group(grade)}{p_end}

{pstd}Constrain the mean of {cmd:Peer} to 0 in both groups{p_end}
{phang2}{cmd:. sem (Peer -> peerrel1 peerrel2 peerrel3 peerrel4)}{break}
        {cmd:(Par -> parrel1 parrel2 parrel3 parrel4),}{break}
 	{cmd:group(grade) mean(Peer@0)}{p_end}

{pstd}Same as above{p_end}
{phang2}{cmd:. sem (Peer -> peerrel1 peerrel2 peerrel3 peerrel4)}{break}
        {cmd:(Par -> parrel1 parrel2 parrel3 parrel4),}{break}
        {cmd:group(grade) mean(1:Peer@0) mean(2:Peer@0)}{p_end}

{pstd}Estimate the covariance between errors of {cmd:parrel1} and 
{cmd:parrel2} in group 1{p_end}
{phang2}{cmd:. sem (Peer -> peerrel1 peerrel2 peerrel3 peerrel4)}{break}
        {cmd:(Par -> parrel1 parrel2 parrel3 parrel4),}{break}
        {cmd:group(grade) covariance(1:e.parrel1*e.parrel2)}{p_end}

{pstd}Constrain the variance of {cmd:Par} to be equal in the two groups{p_end}
{phang2}{cmd:. sem (Peer -> peerrel1 peerrel2 peerrel3 peerrel4)}{break}
        {cmd:(Par -> parrel1 parrel2 parrel3 parrel4),}{break}
        {cmd:group(grade) variance(1:Par@v) variance(2:Par@v)}{p_end}
