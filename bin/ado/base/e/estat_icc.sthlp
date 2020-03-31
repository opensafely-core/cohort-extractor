{smcl}
{* *! version 1.1.6  01nov2019}{...}
{viewerdialog estat "dialog estat"}{...}
{vieweralsosee "[ME] estat icc" "mansection ME estaticc"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ME] mecloglog" "help mecloglog"}{...}
{vieweralsosee "[ME] meglm" "help meglm"}{...}
{vieweralsosee "[ME] meintreg" "help meintreg"}{...}
{vieweralsosee "[ME] melogit" "help melogit"}{...}
{vieweralsosee "[ME] meologit" "help meologit"}{...}
{vieweralsosee "[ME] meoprobit" "help meoprobit"}{...}
{vieweralsosee "[ME] meprobit" "help meprobit"}{...}
{vieweralsosee "[ME] metobit" "help metobit"}{...}
{vieweralsosee "[ME] mixed" "help mixed"}{...}
{viewerjumpto "Syntax" "estat icc##syntax"}{...}
{viewerjumpto "Menu for estat" "estat icc##menu_estat"}{...}
{viewerjumpto "Description" "estat icc##description"}{...}
{viewerjumpto "Links to PDF documentation" "estat_icc##linkspdf"}{...}
{viewerjumpto "Option" "estat icc##option_estat_icc"}{...}
{viewerjumpto "Examples" "estat icc##examples"}{...}
{viewerjumpto "Stored results" "estat icc##results"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[ME] estat icc} {hline 2}}Estimate intraclass correlations{p_end}
{p2col:}({mansection ME estaticc:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmd:estat} {opt icc} [{cmd:,} {opt l:evel(#)}]


INCLUDE help menu_estat


{marker description}{...}
{title:Description}

{pstd}
{cmd:estat icc} is for use after estimation with {cmd:mixed}, {cmd:meintreg},
{cmd:metobit}, {cmd:melogit}, {cmd:meprobit}, {cmd:meologit}, {cmd:meoprobit},
and {cmd:mecloglog}.
{cmd:estat icc}  is also for use after estimation with {cmd:meglm} in cases
when the fitted model is a linear, logit, probit, ordered logit, ordered
probit, or complementary log-log mixed-effects model.

{pstd}
{cmd:estat icc} displays the intraclass correlation for pairs of responses at
each nested level of the model.  Intraclass correlations are available for
random-intercept models or for random-coefficient models conditional on
random-effects covariates being equal to 0.  They are not available for
crossed-effects models or with residual error structures other than
independent structures.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection ME estaticcRemarksandexamples:Remarks and examples}

        {mansection ME estaticcMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker option_estat_icc}{...}
{title:Option}

{phang}
{opt level(#)}
specifies the confidence level, as a percentage, for confidence intervals.
The default is {cmd:level(95)} or as set by {helpb set level}.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse productivity}{p_end}
{phang2}{cmd:. mixed gsp private emp hwy water other unemp || region: ||}
             {cmd:state:}{p_end}

{pstd}Compute residual intraclass correlations{p_end}
{phang2}{cmd:. estat icc}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse tvsfpors}{p_end}
{phang2}{cmd:. meglm thk prethk cc##tv || school:, family(ordinal)}{p_end}

{* correlation is correct below; here only one returned*}{...}
{pstd}Compute residual intraclass correlation{p_end}
{phang2}{cmd:. estat icc}{p_end}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse towerlondon}{p_end}
{phang2}{cmd:. melogit dtlm difficulty i.group || family: || subject:}{p_end}

{pstd}Compute residual intraclass correlations{p_end}
{phang2}{cmd:. estat icc}{p_end}

    {hline}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:estat icc} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(icc}{it:#}{cmd:)}}level-{it:#} intraclass correlation{p_end}
{synopt:{cmd:r(se}{it:#}{cmd:)}}standard errors of level-{it:#} intraclass
         correlation{p_end}
{synopt:{cmd:r(level)}}confidence level of confidence intervals{p_end}
{p2colreset}{...}

{synoptset 15 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(label}{it:#}{cmd:)}}label for level {it:#}{p_end}
{p2colreset}{...}

{synoptset 15 tabbed}{...}
{p2col 5 20 24 2: Matrices}{p_end}
{synopt:{cmd:r(ci}{it:#}{cmd:)}}vector of confidence intervals (lower and upper)
        for level-{it:#} intraclass correlation{p_end}
{p2colreset}{...}

{pstd}
For a G-level nested model, {it:#} can be any integer between 2 and G.
{p_end}
