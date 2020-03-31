{smcl}
{* *! version 1.0.3  19oct2017}{...}
{viewerdialog estat "dialog estat"}{...}
{vieweralsosee "[R] estat ic" "mansection R estatic"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] estat" "help estat"}{...}
{vieweralsosee "[R] estat summarize" "help estat summarize"}{...}
{vieweralsosee "[R] estat vce" "help estat vce"}{...}
{viewerjumpto "Syntax" "estat ic##syntax"}{...}
{viewerjumpto "Menu for estat" "estat ic##menu_estat"}{...}
{viewerjumpto "Description" "estat ic##description"}{...}
{viewerjumpto "Links to PDF documentation" "estat_ic##linkspdf"}{...}
{viewerjumpto "Option" "estat ic##option_estat_ic"}{...}
{viewerjumpto "Example" "estat ic##example"}{...}
{viewerjumpto "Stored results" "estat ic##results"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[R] estat ic} {hline 2}}Display information criteria{p_end}
{p2col:}({mansection R estatic:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

        {cmd:estat ic} [{cmd:,} {opt n(#)}]


INCLUDE help menu_estat


{marker description}{...}
{title:Description}

{pstd}
{opt estat ic} displays Akaike's and Schwarz's Bayesian information
criteria. 


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R estaticQuickstart:Quick start}

        {mansection R estaticRemarksandexamples:Remarks and examples}

        {mansection R estaticMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker option_estat_ic}{...}
{title:Option}

{phang}
{opt n(#)} specifies the {it:N} to be used in calculating BIC; see
{manhelp bic_note R:BIC note}.


{marker example}{...}
{title:Example}

{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}
{phang2}{cmd:. regress price headroom trunk length mpg}{p_end}

{pstd}Obtain AIC and BIC{p_end}
{phang2}{cmd:. estat ic}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:estat ic} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:r(S)}}1 x 6 matrix of results:{p_end}
{synopt:}{space 2}1. sample size{space 19}4. degrees of freedom{p_end}
{synopt:}{space 2}2. log likelihood of null model{space 2}5. AIC{p_end}
{synopt:}{space 2}3. log likelihood of full model{space 2}6. BIC{p_end}
