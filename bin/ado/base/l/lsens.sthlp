{smcl}
{* *! version 1.0.5  19oct2017}{...}
{viewerdialog lsens "dialog lsens"}{...}
{vieweralsosee "[R] lsens" "mansection R lsens"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] ivprobit" "help ivprobit"}{...}
{vieweralsosee "[R] logistic" "help logistic"}{...}
{vieweralsosee "[R] logit" "help logit"}{...}
{vieweralsosee "[R] probit" "help probit"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] estat classification" "help estat classification"}{...}
{vieweralsosee "[R] estat gof" "help logistic estat gof"}{...}
{vieweralsosee "[R] lroc" "help lroc"}{...}
{vieweralsosee "[R] roc" "help roc"}{...}
{viewerjumpto "Syntax" "lsens##syntax"}{...}
{viewerjumpto "Menu" "lsens##menu"}{...}
{viewerjumpto "Description" "lsens##description"}{...}
{viewerjumpto "Links to PDF documentation" "lsens##linkspdf"}{...}
{viewerjumpto "Options" "lsens##options"}{...}
{viewerjumpto "Example" "lsens##example"}{...}
{viewerjumpto "Stored results" "lsens##results"}{...}
{p2colset 1 14 16 2}{...}
{p2col:{bf:[R] lsens} {hline 2}}Graph sensitivity and specificity versus
probability cutoff{p_end}
{p2col:}({mansection R lsens:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmd:lsens} [{depvar}] {ifin}
[{it:{help lsens##weight:weight}}]
[{cmd:,} {it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab :Main}
{synopt :{opt all}}graph all observations in the data{p_end}
{synopt :{opth genp:rob(varname)}}create variable containing probability
cutoffs{p_end}
{synopt :{opth gense:ns(varname)}}create variable containing sensitivity{p_end}
{synopt :{opth gensp:ec(varname)}}create variable containing specificity{p_end}
{synopt :{opt replace}}overwrite existing variables{p_end}
{synopt :{opt nog:raph}}suppress the graph{p_end}

{syntab :Advanced}
{synopt :{opt beta(matname)}}row vector containing model coefficients{p_end}

{syntab :Plot}
{synopt :{it:{help scatter##connect_options:connect_options}}}affect 
        rendition of the plotted points connected by lines{p_end}

{syntab :Add plots}
{synopt :{opth "addplot(addplot_option:plot)"}}add other plots to the generated graph{p_end}

{syntab :Y axis, X axis, Titles, Legend, Overall}
{synopt :{it:twoway_options}}any options other than {opt by()} documented in
   {manhelpi twoway_options G-3}{p_end}
{synoptline}
{p2colreset}{...}
{marker weight}{...}
{p 4 6 2}{opt fweight}s are allowed; see {help weight}.{p_end}
{p 4 6 2}{cmd:lsens} is not appropriate after the {cmd:svy} prefix.


{marker menu}{...}
{title:Menu}

{phang}
{bf:Statistics > Binary outcomes > Postestimation > Sensitivity/specificity plot}


{marker description}{...}
{title:Description}

{pstd}
{cmd:lsens} graphs sensitivity and specificity versus probability cutoff and
optionally creates new variables containing these data.

{pstd}
{cmd:lsens} requires that the current estimation results be from
{helpb logistic}, {helpb logit}, {helpb probit}, or {helpb ivprobit}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R lsensQuickstart:Quick start}

        {mansection R lsensRemarksandexamples:Remarks and examples}

        {mansection R lsensMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt all} requests that the statistic be computed for all observations in the
data, ignoring any {opt if} or {opt in} restrictions specified by the
estimation command.

{phang}
{opth genprob(varname)}, {opt gensens(varname)}, and {opt genspec(varname)}
specify the names of new variables created to contain, respectively, the
probability cutoffs and the corresponding sensitivity and specificity.

{phang}
{opt replace} requests that existing variables specified for {opt genprob()},
{opt gensens()}, or {opt genspec()} be overwritten.

{phang}
{opt nograph} suppresses graphical output.

{dlgtab:Advanced}

{phang}
{opt beta(matname)} specifies a row vector containing model coefficients. 
The columns of the row vector must be labeled with the
corresponding names of the independent variables in the data.  The dependent
variable {depvar} must be specified immediately after the command name.  See
{mansection R lsensRemarksandexamplesModelsotherthanthelastfittedmodel:{it:Models other than the last fitted model}}
in {bf:[R] lsens}.

{dlgtab:Plot}

{phang}
{it:connect_options} affect the rendition of the plotted points connected by
lines; see {it:{help scatter##connect_options:connect_options}} in 
{helpb twoway scatter:[G-2] graph twoway scatter}.

{dlgtab:Add plots}

{phang}
{opt addplot(plot)} provides a way to add other plots to the generated graph.
See {manhelpi addplot_option G-3}.

{marker twoway_options}{...}
{dlgtab:Y axis, X axis, Titles, Legend, Overall}

{phang}
{it:twoway_options} are any of the options documented in 
{manhelpi twoway_options G-3}, excluding {opt by()}.  These include options for
titling the graph (see {manhelpi title_options G-3}) and for saving the
graph to disk (see {manhelpi saving_option G-3}).


{marker example}{...}
{title:Example}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse lbw}

{pstd}Fit logistic regression to predict low birth weight{p_end}
{phang2}{cmd:. logistic low age lwt i.race smoke ptl ht ui}

{pstd}Graph sensitivity and specificity against probability cutoff{p_end}
{phang2}{cmd:. lsens}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:lsens} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(N)}}number of observations{p_end}
{p2colreset}{...}
