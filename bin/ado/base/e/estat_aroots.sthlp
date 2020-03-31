{smcl}
{* *! version 1.0.4  19oct2017}{...}
{viewerdialog estat "dialog estat"}{...}
{vieweralsosee "[TS] estat aroots" "mansection TS estataroots"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] arima" "help arima"}{...}
{viewerjumpto "Syntax" "estat aroots##syntax"}{...}
{viewerjumpto "Menu for estat" "estat aroots##menu_estat"}{...}
{viewerjumpto "Description" "estat aroots##description"}{...}
{viewerjumpto "Links to PDF documentation" "estat_aroots##linkspdf"}{...}
{viewerjumpto "Options" "estat aroots##options"}{...}
{viewerjumpto "Examples" "estat aroots##examples"}{...}
{viewerjumpto "Stored results" "estat aroots##results"}{...}
{p2colset 1 22 24 2}{...}
{p2col:{bf:[TS] estat aroots} {hline 2}}Check the stability condition of ARIMA estimates{p_end}
{p2col:}({mansection TS estataroots:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:estat aroots}
[{cmd:,} {it:options}]

{synoptset 25 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opt nogra:ph}}suppress graph of the eigenvalues for the companion matrices{p_end}
{synopt:{opt d:label}}label eigenvalues with the distance from the unit circle{p_end}
{synopt:{opt mod:label}}label eigenvalues with the modulus{p_end}

{syntab:Grid}
{synopt:{opt nogrid}}suppress polar grid circles{p_end}
{synopt:{opt pgrid}{cmd:(}[...]{cmd:)}}specify radii and appearance of polar grid circles; see {it:{help estat aroots##pgrid():Options}} for details{p_end}

{syntab:Plot}
{synopt :{it:{help marker_options}}}change look of markers (color, size, etc.){p_end}

{syntab:Reference unit circle}
{synopt:{opth rlop:ts(cline_options)}}affect rendition of reference unit circle{p_end}

{syntab:Y axis, X axis, Titles, Legend, Overall}
{synopt:{it:twoway_options}}any options other than {opt by()} documented in {manhelpi twoway_options G-3}{p_end}
{synoptline}
{p2colreset}{...}


INCLUDE help menu_estat


{marker description}{...}
{title:Description}

{pstd}
{opt estat aroots} checks the eigenvalue stability condition after estimating
the parameters of an ARIMA model using {cmd:arima}.
A graph of the eigenvalues of the companion matrices for the AR and MA
polynomials is also produced.

{pstd}
{cmd:estat aroots} is available only after {helpb arima}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TS estatarootsQuickstart:Quick start}

        {mansection TS estatarootsRemarksandexamples:Remarks and examples}

        {mansection TS estatarootsMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opt nograph} specifies that no graph of the eigenvalues of the companion
matrices be drawn.

{phang}
{opt dlabel} labels each eigenvalue with its distance from the unit
   circle.  {opt dlabel} cannot be specified with {opt modlabel}.

{phang}
{opt modlabel} labels the eigenvalues with their moduli.  {opt modlabel}
   cannot be specified with {opt dlabel}.

{dlgtab:Grid}

{phang}
{opt nogrid} suppresses the polar grid circles.

{phang}
{marker pgrid()}{...}
{cmd:pgrid(}[{it:{help numlist}}][{cmd:,} {it:line_options}]{cmd:)}
   determines the radii and appearance of the polar grid circles.  By default,
   the graph includes nine polar grid circles with radii 0.1, 0.2, ..., 0.9
   that have the {opt grid} line style.  The {it:numlist} specifies the radii
   for the polar grid circles.  The {it:line_options} determine the appearance
   of the polar grid circles; see {manhelpi line_options G-3}.  Because the
   {opt pgrid()} option can be repeated, circles with different radii can have
   distinct appearances.

{dlgtab:Plot}

{phang}
{it:marker_options}
    specify the look of markers.  This look includes the marker symbol, the
    marker size, and its color and outline; see {manhelpi marker_options G-3}.

{dlgtab:Reference unit circle}

{phang}
{opt rlopts(cline_options)} affect the rendition of the reference
   unit circle; see {manhelpi cline_options G-3}.

{dlgtab:Y axis, X axis, Titles, Legend, Overall}

{phang}
{it:twoway_options} are any of the options documented in
   {manhelpi twoway_options G-3}, except {cmd:by()}.  These include options for
   titling the graph (see {manhelpi title_options G-3}) and for saving
   the graph to disk (see {manhelpi saving_option G-3}). 


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse air2}{p_end}
{phang2}{cmd:. generate lnair = ln(air)}{p_end}

{pstd}Fit an ARIMA model with additive seasonal effects{p_end}
{phang2}{cmd:. arima lnair, arima(0,1,1) sarima(0,1,1,12) noconstant}{p_end}

{pstd}Check stability of the {cmd:arima} results and graph eigenvalues of companion matrix{p_end}
{phang2}{cmd:. estat aroots}{p_end}

{pstd}Same as above, but suppress polar grid circles in the graph{p_end}
{phang2}{cmd:. estat aroots, nogrid}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:estat aroots} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:r(Re_ar)}}real part of the eigenvalues of AR companion matrix{p_end}
{synopt:{cmd:r(Im_ar)}}imaginary part of the eigenvalues of AR companion matrix{p_end}
{synopt:{cmd:r(Modulus_ar)}}modulus of the eigenvalues of AR companion matrix{p_end}
{synopt:{cmd:r(ar)}}AR companion matrix{p_end}
{synopt:{cmd:r(Re_ma)}}real part of the eigenvalues of MA companion matrix{p_end}
{synopt:{cmd:r(Im_ma)}}imaginary part of the eigenvalues of MA companion matrix{p_end}
{synopt:{cmd:r(Modulus_ma)}}modulus of the eigenvalues of MA companion matrix{p_end}
{synopt:{cmd:r(ma)}}MA companion matrix{p_end}
{p2colreset}{...}
