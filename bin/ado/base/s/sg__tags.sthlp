{smcl}
{* *! version 2.0.7  14may2018}{...}
{* this sthlp file is called by sg__connections_prop.dlg and sg__variables_prop.dlg}{...}
{vieweralsosee "[G-4] text" "help graph_text"}{...}
{viewerjumpto "Control tags" "sg__tags##control"}{...}
{viewerjumpto "Variable tags" "sg__tags##variable"}{...}
{viewerjumpto "Connection tags" "sg__tags##connection"}{...}
{viewerjumpto "Label tags" "sg__tags##label"}{...}
{viewerjumpto "Index tags" "sg__tags##index"}{...}
{viewerjumpto "Examples" "sg__tags##examples"}{...}
{title:Tags}

{pstd}
Tags provide a way within the SEM Builder to control what results and labels
are presented for the variables and connections in an SEM diagram.  Some of the
dialog fields that allow tags show the current tag text in the dialog
field.  Changing the tag text changes what will be displayed in the SEM
diagram.

{pstd}
Many of the most common combinations have already been created and can be
obtained through the drop-down lists available in the dialogs. 

{pstd}
{help sg__tags##control:Control tags} control when the text will be shown.

{pstd}
{help sg__tags##variable:Variable result tags} control what will be shown
for a variable's results.

{pstd}
{help sg__tags##connection:Connection tags} control what will be shown on
connections.

{pstd}
{help sg__tags##label:Label tags} control what will be shown for a
variable's label.

{pstd}
{help sg__tags##index:Index tags} provide index numbers (sequential counts)
for variables and connections.

{pstd}
Standard Stata graph tags may also be used in SEM Builder tag fields.  These
include tags for subscripts, superscripts, Greek letters, and other symbols;
see {helpb graph_text:[G-4] {it:text}}.

{pstd}
Multiple tags may be combined in one text field, and they may be combined with
normal text.  In fact, the field may contain just normal text.  You might use
"e" to label every error variable with the letter e.  
{help sg__tags##examples:Examples} at the bottom of this file illustrate some
combinations.


{marker control}{...}
{title:Control tags}

{synoptset 17}{...}
{p2col:Control tag}Description{p_end}
{p2line}
{p2col:{cmd:{c -(}\est{c )-}}}Show only when estimates are being
	displayed{p_end}
{p2col:{cmd:{c -(}\build{c )-}}}Show only when building model (not displaying
	estimates){p_end}
{p2col:{cmd:{c -(}\auto{c )-}}}Automatically swap between raw and standardized
	estimates{p_end}
{p2line}


{marker variable}{...}
{title:Variable result tags}

{p2col:Variable tag}Description{p_end}
{p2line}
{p2col:{cmd:{c -(}\mean{c )-}}}Mean{p_end}
{p2col:{cmd:{c -(}\mean_se{c )-}}}SE of mean{p_end}
{p2col:{cmd:{c -(}\mean_lb{c )-}}}Lower bound of CI of mean{p_end}
{p2col:{cmd:{c -(}\mean_ub{c )-}}}Upper bound of CI of mean{p_end}
{p2col:{cmd:{c -(}\mean_z{c )-}}}z statistic of mean{p_end}
{p2col:{cmd:{c -(}\mean_p{c )-}}}p-value of mean{p_end}
{p2col:{cmd:{c -(}\cons{c )-}}}Intercept/constant{p_end}
{p2col:{cmd:{c -(}\cons_se{c )-}}}SE of intercept{p_end}
{p2col:{cmd:{c -(}\cons_lb{c )-}}}Lower bound of CI of intercept{p_end}
{p2col:{cmd:{c -(}\cons_ub{c )-}}}Upper bound of CI of intercept{p_end}
{p2col:{cmd:{c -(}\cons_z{c )-}}}z statistic of intercept{p_end}
{p2col:{cmd:{c -(}\cons_p{c )-}}}p-value of intercept{p_end}
{p2col:{cmd:{c -(}\var{c )-}}}Variance{p_end}
{p2col:{cmd:{c -(}\var_se{c )-}}}SE of variance{p_end}
{p2col:{cmd:{c -(}\var_lb{c )-}}}Lower bound of CI of variance{p_end}
{p2col:{cmd:{c -(}\var_ub{c )-}}}Upper bound of CI of variance{p_end}
{p2col:{cmd:{c -(}\errvar{c )-}}}Variance of error{p_end}
{p2col:{cmd:{c -(}\errvar_se{c )-}}}SE of error variance{p_end}
{p2col:{cmd:{c -(}\errvar_lb{c )-}}}Lower bound of CI of error variance{p_end}
{p2col:{cmd:{c -(}\errvar_ub{c )-}}}Upper bound of CI of error variance{p_end}
{p2col:{cmd:{c -(}\errvar_z{c )-}}}z statistic of error variance{p_end}
{p2col:{cmd:{c -(}\errvar_p{c )-}}}p-value of error variance{p_end}

{p2col:{cmd:{c -(}\stdmean{c )-}}}Standardized mean{p_end}
{p2col:{cmd:{c -(}\stdmean_se{c )-}}}SE of standardized mean{p_end}
{p2col:{cmd:{c -(}\stdmean_lb{c )-}}}Lower bound of CI of standardized
	mean{p_end}
{p2col:{cmd:{c -(}\stdmean_ub{c )-}}}Upper bound of CI of standardized
	mean{p_end}
{p2col:{cmd:{c -(}\stdmean_z{c )-}}}z statistic of standardized mean{p_end}
{p2col:{cmd:{c -(}\stdmean_p{c )-}}}p-value of standardized mean{p_end}
{p2col:{cmd:{c -(}\stdcons{c )-}}}Standardized intercept/constant{p_end}
{p2col:{cmd:{c -(}\stdcons_se{c )-}}}SE of standardized intercept{p_end}
{p2col:{cmd:{c -(}\stdcons_lb{c )-}}}Lower bound of CI of standardized
	intercept{p_end}
{p2col:{cmd:{c -(}\stdcons_ub{c )-}}}Upper bound of CI of standardized
	intercept{p_end}
{p2col:{cmd:{c -(}\stdcons_z{c )-}}}z statistic of standardized
	intercept{p_end}
{p2col:{cmd:{c -(}\stdcons_p{c )-}}}p-value of standardized intercept{p_end}
{p2col:{cmd:{c -(}\stdvar{c )-}}}Standardized variance{p_end}
{p2col:{cmd:{c -(}\stdvar_se{c )-}}}SE of standardized variance{p_end}
{p2col:{cmd:{c -(}\stdvar_lb{c )-}}}Lower bound of CI of standardized
	variance{p_end}
{p2col:{cmd:{c -(}\stdvar_ub{c )-}}}Upper bound of CI of standardized
	variance{p_end}
{p2col:{cmd:{c -(}\stderrvar{c )-}}}Standardized variance of error{p_end}
{p2col:{cmd:{c -(}\stderrvar_se{c )-}}}SE of standardized error variance{p_end}
{p2col:{cmd:{c -(}\stderrvar_lb{c )-}}}Lower bound of CI of standardized error
	variance{p_end}
{p2col:{cmd:{c -(}\stderrvar_ub{c )-}}}Upper bound of CI of standardized error
	variance{p_end}
{p2col:{cmd:{c -(}\stderrvar_z{c )-}}}z statistic of standardized
	error variance{p_end}
{p2col:{cmd:{c -(}\stderrvar_p{c )-}}}p-value of standardized error
	variance{p_end}

{p2col:{cmd:{c -(}\expvar{c )-}}}exposure variable (for count outcomes){p_end}
{p2col:{cmd:{c -(}\denomvar{c )-}}}denominator variable 
	(for binomial outcomes){p_end}
{p2col:{cmd:{c -(}\lcensor{c )-}}}left boundary for left censoring or
	interval measurement{p_end}
{p2col:{cmd:{c -(}\rcensor{c )-}}}right boundary for right censoring or
	interval measurement{p_end}
{p2col:{cmd:{c -(}\ltrunc{c )-}}}left boundary for left truncation{p_end}
{p2col:{cmd:{c -(}\failvar{c )-}}}failure indicator variable{p_end}
{p2col:{cmd:{c -(}\aft{c )-}}}Indicator for accelerated failure-time 
	metric{p_end}
{p2line}

{pstd}
Variable result tags may only be used in a variable's label or in results text.


{marker connection}{...}
{title:Connection tags}

{p2col:Connection tag}Description{p_end}
{p2line}
{p2col:{cmd:{c -(}\parm{c )-}}}Parameter estimate (path coefficient or
	covariance){p_end}
{p2col:{cmd:{c -(}\parm_se{c )-}}}SE of parameter estimate{p_end}
{p2col:{cmd:{c -(}\parm_lb{c )-}}}Lower bound of CI of parameter
	estimate{p_end}
{p2col:{cmd:{c -(}\parm_ub{c )-}}}Upper bound of CI of parameter
	estimate{p_end}
{p2col:{cmd:{c -(}\parm_z{c )-}}}z statistic of parameter estimate{p_end}
{p2col:{cmd:{c -(}\parm_p{c )-}}}p-value of parameter estimate{p_end}
{p2col:{cmd:{c -(}\stdparm{c )-}}}Standardized parameter estimate{p_end}
{p2col:{cmd:{c -(}\stdparm_se{c )-}}}SE of standardized parameter
	estimate{p_end}
{p2col:{cmd:{c -(}\stdparm_lb{c )-}}}Lower bound of CI of standardized
	parameter estimate{p_end}
{p2col:{cmd:{c -(}\stdparm_ub{c )-}}}Upper bound of CI of standardized
	parameter estimate{p_end}
{p2col:{cmd:{c -(}\stdparm_z{c )-}}}z statistic of standardized parameter
	estimate{p_end}
{p2col:{cmd:{c -(}\stdparm_p{c )-}}}p-value of standardized parameter
	estimate{p_end}
{p2line}

{pstd}
Connection tags may only be used on results text for connections.


{marker label}{...}
{title:Label tags}

{p2col:Label tag}Description{p_end}
{p2line}
{p2col:{cmd:{c -(}\varname{c )-}}}Observed variable name{p_end}
{p2col:{cmd:{c -(}\name{c )-}}}Latent variable name{p_end}
{p2col:{cmd:{c -(}\label{c )-}}}Variable label{p_end}
{p2col:{cmd:{c -(}\basename{c )-}}}Multilevel latent variable base name{p_end}
{p2col:{cmd:{c -(}\basename{c )-}}}Factor or time-series operated 
				   base name{p_end}
{p2col:{cmd:{c -(}\fvtsop{c )-}}}Factor or time-series operator{p_end}
{p2col:{cmd:{c -(}\mllevels{c )-}}}Full level specification for a multilevel
				   latent variable{p_end}
{p2col:{cmd:{c -(}\mllevelsbr{c )-}}}{cmd:{\mllevels}} with surrounding 
				     brackets{p_end}
{p2col:{cmd:{c -(}\mlfinlevel{c )-}}}Final level variable for a multilevel
				     latent variable{p_end}
{p2col:{cmd:{c -(}\mlfinlevelbr{c )-}}}{cmd:{\mlfinlevel}} with surrounding 
				       brackets{p_end}
{p2line}

{pstd}
Label tags may only be used in label text fields.


{marker index}{...}
{title:Index tags}

{p2col:Index tag}Description{p_end}
{p2line}
{p2col:{cmd:{c -(}\i_vars{c )-}}}Variable sequence index{p_end}
{p2col:{cmd:{c -(}\i_latent{c )-}}}Latent variable sequence index{p_end}
{p2col:{cmd:{c -(}\i_mllatent{c )-}}}Multilevel latent variable 
				     sequence index{p_end}
{p2col:{cmd:{c -(}\i_glm{c )-}}}Generalized response
				     sequence index{p_end}
{p2col:{cmd:{c -(}\i_observed{c )-}}}Observed variable sequence index{p_end}
{p2col:{cmd:{c -(}\i_lexog{c )-}}}Exogenous latent variable sequence
	index{p_end}
{p2col:{cmd:{c -(}\i_lendog{c )-}}}Endogenous latent variable sequence
	index{p_end}
{p2col:{cmd:{c -(}\i_oexog{c )-}}}Exogenous observed variable sequence
	index{p_end}
{p2col:{cmd:{c -(}\i_oendog{c )-}}}Endogenous observed variable sequence
	index{p_end}
{p2col:{cmd:{c -(}\i_error{c )-}}}Error variable sequence index{p_end}
{p2col:{cmd:{c -(}\i_lerror{c )-}}}Error variable on latent variable sequence
	index{p_end}
{p2col:{cmd:{c -(}\i_oerror{c )-}}}Error variable on observed variable
	sequence index{p_end}

{p2col:{cmd:{c -(}\i_edge{c )-}}}Connection sequence index{p_end}
{p2col:{cmd:{c -(}\i_path{c )-}}}Path sequence index{p_end}
{p2col:{cmd:{c -(}\i_cov{c )-}}}Covariance sequence index{p_end}
{p2col:{cmd:{c -(}\i_errpath{c )-}}}Path to error sequence index{p_end}
{p2line}


{marker examples}{...}
{title:Examples}

{title:Customize results}

{pstd}To change the output of all observed exogenous variables to show{p_end}

{phang2}mu_{it:i} = #{p_end}
{phang2}sigma_{it:i}^2 = #{p_end}

{pstd}where mu and sigma are the Greek symbols, i is the exogenous variable's
index, and # is the estimated result, first open the variable settings dialog for
observed exogenous variables:{p_end}

{phang2}{cmd:Settings > Variables > Observed Exogenous}{p_end}

{pstd}On the Results tab, change Result 1: to {p_end}

{phang2}{cmd:Custom}{space 5}{cmd:{\auto}{&mu}{sub:{\i_oexog}} = {\mean}}{p_end}

{pstd}and change Result 2: to {p_end}

{phang2}{cmd:Custom}{space 5}{cmd:{\auto}{&sigma}{sub:{\i_oexog}}{sup:2} = {\var}}{p_end}

{pstd}If you do not wish to see the indices, simply change the above as
follows:{p_end}

{phang2}{cmd:Custom}{space 5}{cmd:{\auto}{&mu} = {\mean}}{p_end}
{phang2}{cmd:Custom}{space 5}{cmd:{\auto}{&sigma}{sup:2} = {\var}}{p_end}

{pstd}The tag {cmd:{\auto}} is included so that displayed results are
switched between standardized and unstandardized values when changed.  If this
option was not specified, only the unstandardized values would be
shown.

{pstd}The above will display the text portion ("mu=" and "sigma^2=") without
estimation results when building the diagram.  If you want to see these
results only after estimation, simply include {cmd:{\est}}, as
follows:{p_end}

{phang2}{cmd:Custom}{space 5}{cmd:{\est}{\auto}{&mu}{sub:{\i_oexog}} = {\mean}}{p_end}
{phang2}{cmd:Custom}{space 5}{cmd:{\est}{\auto}{&sigma}{sub:{\i_oexog}}{sup:2} = {\var}}{p_end}

{pstd}
Be aware, however, that adding {cmd:{\est}} means that all output will be
suppressed during model building and you will not see any constraints that you
apply during building.  Constraints are shown in place of parameters during
model building, but {cmd:{\est}} suppresses all output for the result unless
estimates are being shown.


{title:Customize labels}

{pstd}Let's assume that we wish to label all elements of the diagram to match
the notation used in {manlink SEM Methods and formulas for sem}.  To do this,
we must change the label tags as follows: {p_end}

{pstd}To label observed endogenous variables as y_{it:i}, open the variable
settings dialog for observed endogenous variables:{p_end}

{phang2}{cmd:Settings > Variables > Observed Endogenous}{p_end}

{pstd}On the Label tab, change Observed: to {p_end}

{phang2}{cmd:Custom}{space 5} {cmd:y{sub:{\i_oendog}}}{p_end}

{pstd}To label observed exogenous variables as x_{it:i}, open the variable
settings dialog for observed exogenous variables:{p_end}

{phang2}{cmd:Settings > Variables > Observed Exogenous}{p_end}

{pstd}On the Label tab, change Observed: to {p_end}

{phang2}{cmd:Custom}{space 5} {cmd:x{sub:{\i_oexog}}}{p_end}

{pstd}To label latent endogenous variables as eta_{it:i}, open the variable
settings dialog for latent endogenous variables:{p_end}

{phang2}{cmd:Settings > Variables > Latent Endogenous}{p_end}

{pstd}On the Label tab, change Latent: to {p_end}

{phang2}{cmd:Custom}{space 5} {cmd:{&eta}{sub:{\i_lendog}}}{p_end}

{pstd}To label latent exogenous variables as xi_{it:i}, open the variable
settings dialog for latent exogenous variables:{p_end}

{phang2}{cmd:Settings > Variables > Latent Exogenous}{p_end}

{pstd}On the Label tab, change Latent: to {p_end}

{phang2}{cmd:Custom}{space 5} {cmd:{&xi}{sub:{\i_lexog}}}{p_end}

{pstd}To label latent errors as e.eta_{it:i} and observed errors
as e.y_{it:i}, open the variable settings dialog for all error
variables:{p_end}

{phang2}{cmd:Settings > Variables > Errors}{p_end}

{pstd}On the Label tab, change Latent: to {p_end}

{phang2}{cmd:Custom}{space 5} {cmd:e.{&eta}{sub:{\i_lendog}}}{p_end}

{pstd}and change Observed: to {p_end}

{phang2}{cmd:Custom}{space 5} {cmd:e.y{sub:{\i_oendog}}}{p_end}


{title:Customize path results}

{pstd}To change the output of results for paths to display beta when building
the diagram and then to display beta = # after estimation, open the connection 
settings dialog for paths:{p_end}

{phang2}{cmd:Settings > Connections > Paths}{p_end}

{pstd}On the Results tab, change Result 1: to {p_end}

{phang2}{cmd:Custom}{space 5}{cmd:{\build}{&beta}}{p_end}

{pstd}and change Result 2: to {p_end}

{phang2}{cmd:Custom}{space 5}{cmd:{\est}{\auto}{&beta} = {\parm}}{p_end}
