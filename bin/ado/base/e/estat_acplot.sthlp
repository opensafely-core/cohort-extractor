{smcl}
{* *! version 1.0.4  19oct2017}{...}
{viewerdialog estat "dialog estat"}{...}
{vieweralsosee "[TS] estat acplot" "mansection TS estatacplot"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] arfima" "help arfima"}{...}
{vieweralsosee "[TS] arima" "help arima"}{...}
{viewerjumpto "Syntax" "estat acplot##syntax"}{...}
{viewerjumpto "Menu for estat" "estat acplot##menu_estat"}{...}
{viewerjumpto "Description" "estat acplot##description"}{...}
{viewerjumpto "Links to PDF documentation" "estat_acplot##linkspdf"}{...}
{viewerjumpto "Options" "estat acplot##options"}{...}
{viewerjumpto "Example" "estat acplot##example"}{...}
{p2colset 1 22 24 2}{...}
{p2col:{bf:[TS] estat acplot} {hline 2}}Plot parametric autocorrelation and autocovariance functions{p_end}
{p2col:}({mansection TS estatacplot:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 25 2}
{cmd:estat acplot}
[{cmd:,} {it:options}]

{synoptset 24 tabbed}{...}
{synopthdr :options}
{synoptline}
{synopt :{help estat_acplot##saving():{bf:{ul:sa}ving(}{it:filename}{bf:[, ...])}}}save
	results to {it:filename}; save variables in double precision; save
	variables with prefix {it:stubname}{p_end}
{synopt :{opt l:evel(#)}}set confidence level; default is {cmd:level(95)}{p_end}
{synopt:{opt lag:s(#)}}use {it:#} autocorrelations{p_end}
{synopt:{opt cov:ariance}}calculate autocovariances; the default is to calculate
	autocorrelations{p_end}
{synopt:{opt smem:ory}}report short-memory ACF;
	only allowed after {cmd:arfima}{p_end}

{syntab:CI plot}
{synopt :{opth ciop:ts(rcap_options)}}affect rendition of the confidence bands{p_end}

{syntab:Plot}
{synopt :{it:{help marker_options}}}change look of markers (color, size, etc.){p_end}
{synopt :{it:{help marker_label_options}}}add marker labels; change look or position{p_end}
{synopt :{it:{help cline_options}}}affect rendition of the plotted points{p_end}

{syntab:Y axis, X axis, Titles, Legend, Overall}
{synopt :{it:twoway_options}}any options other than {opt by()} documented in
      {manhelpi twoway_options G-3}{p_end}
{synoptline}
{p2colreset}{...}


INCLUDE help menu_estat


{marker description}{...}
{title:Description}

{pstd}
{cmd:estat acplot} plots the estimated autocorrelation and autocovariance
functions of a stationary process using the parameters of a previously
fit parametric model.

{pstd}
{cmd:estat acplot} is available after {helpb arima} and {helpb arfima}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TS estatacplotQuickstart:Quick start}

        {mansection TS estatacplotRemarksandexamples:Remarks and examples}

        {mansection TS estatacplotMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{marker saving()}{...}
{phang}
{opt saving}{cmd:(}{it:{help filename}} [{cmd:,} {it:suboptions}]{cmd:)} creates
a Stata data file ({cmd:.dta} file) consisting of the autocorrelation
estimates, standard errors, and confidence bounds.

{pmore}
Five variables are saved: {cmd:lag} (lag number), {cmd:ac} (autocorrelation
estimate), {cmd:se} (standard error), {cmd:ci_l} (lower confidence bound),
and {cmd:ci_u} (upper confidence bound). 

{pmore}
{cmd:double} specifies that the variables be saved as {cmd:double}s, meaning
8-byte reals.  By default, they are saved as {cmd:float}s, meaning 4-byte
reals.

{pmore}
{opt name(stubname)} specifies that variables be saved with prefix
{it:stubname}.

{pmore}
{opt replace} indicates that {it:filename} be overwritten if it exists.

{phang}
{opt level(#)} specifies the confidence level, as a percentage, for
confidence intervals.  The default is {cmd:level(95)} or as set by 
{helpb set level}.

{phang}
{opt lags(#)} specifies the number of autocorrelations to calculate.  The
default is to use min{floor(n/2) - 2, 40}, where floor(n/2) is the greatest
integer less than or equal to n/2 and n is the number of observations.

{phang}
{opt covariance} specifies the calculation of autocovariances instead of the
default autocorrelations.

{phang}
{opt smemory} specifies that the ARFIMA fractional integration parameter be
ignored.  The computed autocorrelations are for the short-memory ARMA
component of the model.  This option is allowed only after {cmd:arfima}.

{dlgtab:CI plot}

{marker ciopts()}{...}
{phang}
{opt ciopts(rcap_options)} affects the rendition of the confidence bands;
see {manhelpi rcap_options G-3}.

{dlgtab:Plot}

{phang}
{it:marker_options} affect the rendition of markers drawn at
the plotted points, including their shape, size, color, and outline; see 
{manhelpi marker_options G-3}.

{phang}
{it:marker_label_options} specify if and how the markers are
to be labeled; see {manhelpi marker_label_options G-3}.

{phang}
{it:cline_options} affect whether lines connect the
plotted points and the rendition of those lines; see
{manhelpi cline_options G-3}.

{dlgtab:Y axis, X axis, Titles, Legend, Overall}

{phang}
{it:twoway_options} are any of the options documented in 
{manhelpi twoway_options G-3}, except {opt by()}.  These include options
for titling the graph (see {manhelpi title_options G-3}) and for saving the
graph to disk (see {manhelpi saving_option G-3}).


{marker example}{...}
{title:Example}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse wpi1}{p_end}
{phang2}{cmd:. arima wpi, arima(1,1,1)}{p_end}

{pstd}Plot the autocorrelations and their 95% confidence intervals{p_end}
{phang2}{cmd:. estat acplot, lags(50)}{p_end}
