{smcl}
{* *! version 1.1.5  19oct2017}{...}
{viewerdialog discrim "dialog discrim"}{...}
{vieweralsosee "[MV] discrim" "mansection MV discrim"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] discrim estat" "help discrim estat"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[MV] candisc" "help candisc"}{...}
{vieweralsosee "[MV] cluster" "help cluster"}{...}
{viewerjumpto "Syntax" "discrim##syntax"}{...}
{viewerjumpto "Description" "discrim##description"}{...}
{viewerjumpto "Links to PDF documentation" "discrim##linkspdf"}{...}
{viewerjumpto "Examples" "discrim##examples"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[MV] discrim} {hline 2}}Discriminant analysis{p_end}
{p2col:}({mansection MV discrim:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:discrim} {it:subcommand} ... [{cmd:,} ...]

{synoptset 15}{...}
{synopthdr:subcommand}
{synoptline}
{synopt:{helpb discrim_knn:knn}}{it:k}th-nearest-neighbor discriminant
	analysis{p_end}
{synopt:{helpb discrim_lda:lda}}linear discriminant analysis{p_end}
{synopt:{helpb discrim_logistic:logistic}}logistic discriminant
	analysis{p_end}
{synopt:{helpb discrim_qda:qda}}quadratic discriminant analysis{p_end}
{synoptline}


{marker description}{...}
{title:Description}

{pstd}
{cmd:discrim} performs discriminant analysis, which is also known as
classification.  {it:k}th-nearest-neighbor (KNN) discriminant analysis, linear
discriminant analysis (LDA), quadratic discriminant analysis (QDA), and
logistic discriminant analysis are available.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection MV discrimRemarksandexamples:Remarks and examples}

        {mansection MV discrimMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse rootstock}{p_end}

{pstd}Fit a {it:k}th-nearest-neighbor discriminant analysis model{p_end}
{phang2}{cmd:. discrim knn y*, k(5) group(rootstock)}{p_end}

{pstd}Fit a linear discriminant analysis (LDA) model with equal prior
	probabilities for the six rootstock groups{p_end}
{phang2}{cmd:. discrim lda y1 y2 y3 y4, group(rootstock)}{p_end}

{pstd}Fit a quadratic discriminant analysis (QDA) model with prior probabilities
    of 0.2 for the first four rootstocks and 0.1 for the last two root
    stocks{p_end}
{phang2}
{cmd:. discrim qda y*, group(rootstock) priors(.2,.2,.2,.2,.1,.1)}
{p_end}

{pstd}Fit a logistic discriminant analysis model{p_end}
{phang2}{cmd:. discrim logistic y*, group(rootstock)}{p_end}
