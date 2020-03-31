{smcl}
{* *! version 1.1.5  30nov2018}{...}
{viewerdialog estat "dialog regress_estat, message(-moran-)"}{...}
{vieweralsosee "[SP] estat moran" "mansection SP estatmoran"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SP] Intro" "mansection SP Intro"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SP] spmatrix create" "help spmatrix create"}{...}
{vieweralsosee "[SP] spregress" "help spregress"}{...}
{vieweralsosee "[R] regress" "help regress"}{...}
{viewerjumpto "Syntax" "estat moran##syntax"}{...}
{viewerjumpto "Menu for estat" "estat moran##menu_estat"}{...}
{viewerjumpto "Description" "estat moran##description"}{...}
{viewerjumpto "Links to PDF documentation" "estat_moran##linkspdf"}{...}
{viewerjumpto "Option" "estat moran##option"}{...}
{viewerjumpto "Examples" "estat moran##examples"}{...}
{viewerjumpto "Stored results" "estat moran##results"}{...}
{p2colset 1 21 23 2}{...}
{p2col:{bf:[SP] estat moran} {hline 2}}Moran's test of residual correlation
with nearby residuals{p_end}
{p2col:}({mansection SP estatmoran:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmd:estat} {cmd:moran}{cmd:,} 
{opt err:orlag(spmatname)}
[{opt err:orlag(spmataname)} ...]


INCLUDE help menu_estat


{marker description}{...}
{title:Description}

{pstd}
{cmd:estat moran} is a postestimation test that can be run after fitting a
model using {helpb regress} with spatial data.  It performs the Moran test
for spatial correlation among the residuals.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection SP estatmoranQuickstart:Quick start}

        {mansection SP estatmoranRemarksandexamples:Remarks and examples}

        {mansection SP estatmoranMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker option}{...}
{title:Option}

{phang}
{opt errorlag(spmatname)} specifies a spatial weighting matrix that defines
the error spatial lag that will be tested.  {cmd:errorlag()} is required.
This option is repeatable to allow testing of higher-order error lags.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. copy https://www.stata-press.com/data/r16/homicide1990.dta .}
{p_end}
{phang2}{cmd:. copy https://www.stata-press.com/data/r16/homicide1990_shp.dta .}
{p_end}
{phang2}{cmd:. use homicide1990}
{p_end}
{phang2}{cmd:. spset}
{p_end}

{pstd}Create a contiguity weighting matrix with the default spectral normalization{p_end}
{phang2}{cmd:. spmatrix create contiguity W}

{pstd}Fit a linear regression{p_end}
{phang2}{cmd:. regress hrate}

{pstd}Conduct the Moran test{p_end}
{phang2}{cmd:. estat moran, errorlag(W)}

{pstd}Create an inverse-distance weighting matrix{p_end}
{phang2}{cmd:. spmatrix create idistance M}

{pstd}Conduct a joint test of whether one of the weighting matrices
specify a spatial dependence{p_end}
{phang2}{cmd:. estat moran, errorlag(W) errorlag(M)}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:estat moran} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(chi2)}}chi-squared{p_end}
{synopt:{cmd:r(df)}}degrees of freedom of chi-squared{p_end}
{synopt:{cmd:r(p)}}p-value for model test{p_end}

{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:r(elmat)}}weighting matrices used to specify error lag{p_end}
{p2colreset}{...}
