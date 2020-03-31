{smcl}
{* *! version 1.1.13  20sep2018}{...}
{viewerdialog varstable "dialog varstable"}{...}
{vieweralsosee "[TS] varstable" "mansection TS varstable"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] var" "help var"}{...}
{vieweralsosee "[TS] var intro" "help var_intro"}{...}
{vieweralsosee "[TS] var svar" "help svar"}{...}
{vieweralsosee "[TS] varbasic" "help varbasic"}{...}
{viewerjumpto "Syntax" "varstable##syntax"}{...}
{viewerjumpto "Menu" "varstable##menu"}{...}
{viewerjumpto "Description" "varstable##description"}{...}
{viewerjumpto "Links to PDF documentation" "varstable##linkspdf"}{...}
{viewerjumpto "Options" "varstable##options"}{...}
{viewerjumpto "Examples" "varstable##examples"}{...}
{viewerjumpto "Stored results" "varstable##results"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[TS] varstable} {hline 2}}Check the stability condition of VAR
or SVAR estimates{p_end}
{p2col:}({mansection TS varstable:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:varstable}
[{cmd:,} {it:options}]

{synoptset 25 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opt est:imates(estname)}}use previously stored results {it:estname};
default is to use active results{p_end}
{synopt:{opt a:mat(matrix_name)}}save the companion matrix as {it:matrix_name}{p_end}
{synopt:{opt gra:ph}}graph eigenvalues of the companion matrix{p_end}
{synopt:{opt d:label}}label eigenvalues with the distance from the unit circle{p_end}
{synopt:{opt mod:label}}label eigenvalues with the modulus{p_end}
{synopt :{it:{help marker_options}}}change look of markers (color, size, etc.){p_end}
{synopt:{opth rlop:ts(cline_options)}}affect rendition of reference unit circle{p_end}
{synopt:{opt nogri:d}}suppress polar grid circles{p_end}
{synopt:{opt pgrid}{cmd:(}[...]{cmd:)}}specify radii and appearance of polar grid circles; see {it:{help varstable##pgrid():Options}} for details{p_end}

{syntab:Add plots}
{synopt:{opth "addplot(addplot_option:plot)"}}add other plots to the generated graph{p_end}

{syntab:Y axis, X axis, Titles, Legend, Overall}
{synopt:{it:twoway_options}}any options other than {opt by()} documented in
     {manhelpi twoway_options G-3}{p_end}
{synoptline}
{p 4 6 2}
{opt varstable} can be used only after {cmd:var} or {cmd:svar}; see
{helpb var:[TS] var} and {helpb svar:[TS] var svar}.
{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Multivariate time series > VAR diagnostics and tests >}
      {bf:Check stability condition of VAR estimates}


{marker description}{...}
{title:Description}

{pstd}
{opt varstable} checks the eigenvalue stability condition after estimating
the parameters of a vector autoregression using {cmd:var} or {cmd:svar}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TS varstableQuickstart:Quick start}

        {mansection TS varstableRemarksandexamples:Remarks and examples}

        {mansection TS varstableMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt estimates(estname)} requests that {opt varstable} use the
   previously obtained set of {cmd:var} estimates stored as {it:estname}.  By
   default, {opt varstable} uses the active estimation results.
   See {manhelp estimates R} for information on manipulating estimation
   results.

{phang}
{opt amat(matrix_name)} specifies a valid Stata matrix name by which
   the companion matrix {bf:A} can be saved (see
   {it:{mansection TS varstableMethodsandformulas:Methods and formulas}} in
   {bf:[TS] varstable} for the definition of the matrix {bf:A}).  The default is
   not to save the {bf:A} matrix.

{phang}
{opt graph} causes {opt varstable} to draw a graph of the eigenvalues of the
   companion matrix.

{phang}
{opt dlabel} labels each eigenvalue with its distance from the unit
   circle.  {opt dlabel} cannot be specified with {opt modlabel}.

{phang}
{opt modlabel} labels the eigenvalues with their moduli.  {opt modlabel}
   cannot be specified with {opt dlabel}.

{phang}
{it:marker_options}
    specify the look of markers.  This
    look includes the marker symbol, the marker size, and its color and outline;
    see {manhelpi marker_options G-3}.

{phang}
{opt rlopts(cline_options)} affect the rendition of the reference
   unit circle; see {manhelpi cline_options G-3}.

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

{dlgtab:Add plots}

{phang}
{opt addplot(plot)} adds specified plots to the generated graph.  See
{manhelpi addplot_option G-3}.

{dlgtab:Y axis, X axis, Titles, Legend, Overall}

{phang}
{it:twoway_options} are any of the options documented in
   {manhelpi twoway_options G-3}, except {cmd:by()}.  These include options for
   titling the graph (see {manhelpi title_options G-3}) and for saving
   the graph to disk (see {manhelpi saving_option G-3}). 


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse lutkepohl2}{p_end}

{pstd}Fit vector autoregressive model{p_end}
{phang2}{cmd:. var dln_inv dln_inc dln_consump if qtr>=tq(1961q2) &}
                 {cmd:qtr<=tq(1978q4)}{p_end}

{pstd}Check stability of the {cmd:var} results{p_end}
{phang2}{cmd:. varstable}{p_end}

{pstd}Same as above, but graph eigenvalues of the companion matrix{p_end}
{phang2}{cmd:. varstable, graph}{p_end}

{pstd}Same as above, but suppress polar grid circles{p_end}
{phang2}{cmd:. varstable, graph nogrid}

{pstd}Store estimation results in {cmd:var1}{p_end}
{phang2}{cmd:. estimates store var1}{p_end}

{pstd}Setup{p_end}
{phang2}{cmd:. matrix A = (.,0\.,.)}{p_end}
{phang2}{cmd:. matrix B = I(2)}{p_end}

{pstd}Fit structural vector autoregressive model{p_end}
{phang2}{cmd:. svar d.ln_inc d.ln_consump, aeq(A) beq(B)}

{pstd}Check stability of the {cmd:svar} results{p_end}
{phang2}{cmd:. varstable}

{pstd}Check stability of the {cmd:var} results stored in {cmd:var1}{p_end}
{phang2}{cmd:. varstable, estimates(var1)}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:varstable} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:r(Re)}}real part of the eigenvalues of A{p_end}
{synopt:{cmd:r(Im)}}imaginary part of the eigenvalues of A{p_end}
{synopt:{cmd:r(Modulus)}}modulus of the eigenvalues of A{p_end}
{p2colreset}{...}
