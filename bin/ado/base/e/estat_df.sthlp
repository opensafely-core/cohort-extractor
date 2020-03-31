{smcl}
{* *! version 1.0.2  19oct2017}{...}
{viewerdialog estat "dialog estat"}{...}
{vieweralsosee "[ME] estat df" "mansection ME estatdf"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ME] mixed" "help mixed"}{...}
{viewerjumpto "Syntax" "estat df##syntax"}{...}
{viewerjumpto "Menu for estat" "estat df##menu_estat"}{...}
{viewerjumpto "Description" "estat df##description"}{...}
{viewerjumpto "Links to PDF documentation" "estat_df##linkspdf"}{...}
{viewerjumpto "Options" "estat df##option_estat_df"}{...}
{viewerjumpto "Examples" "estat df##examples"}{...}
{viewerjumpto "Stored results" "estat df##results"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[ME] estat df} {hline 2}}Calculate degrees of freedom for fixed
effects{p_end}
{p2col:}({mansection ME estatdf:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmd:estat} {opt df} [{cmd:,} 
	{opt meth:od}{cmd:(}{help mixed##df_method:{it:df_methods}}{cmd:)}
	{opt post}[{cmd:(}{help mixed##df_method:{it:df_method}}{cmd:)}]
	{opt eim} {opt oim}]


INCLUDE help menu_estat


{marker description}{...}
{title:Description}

{pstd}
{cmd:estat df} is for use after estimation with {cmd:mixed}.

{pstd}
{cmd:estat df} calculates and displays the degrees of freedom (DF) for each
fixed effect using the specified methods. This allows for a comparison of
different DF methods.  {cmd:estat df} can also be used to continue with
postestimation using a different DF method without rerunning the model.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection ME estatdfRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker option_estat_df}{...}
{title:Options}

{phang}
{opth method:(mixed##df_method:df_methods)} specifies a list of methods to
compute DF.  The supported methods are {cmd:residual}, {cmd:repeated},
{cmd:anova}, {cmd:satterthwaite}, and {cmd:kroger}; more than one method may
be specified. Methods {cmd:satterthwaite} and {cmd:kroger} are only available
with REML estimation.  If option {cmd:dfmethod()} was not specified in the
most recently fit {cmd:mixed} model, then option {cmd:method()} is required.
See
{mansection ME mixedRemarksandexamplesSmall-sampleinferenceforfixedeffects:{it:Small-sample inference for fixed effects}} under {it:Remarks and examples}
in {bf:[ME] mixed} for more details.  

{phang}
{cmd:post} causes {cmd:estat df} to behave like a Stata estimation
command.  When {cmd:post} is specified, {cmd:estat df} will post the DF for
each fixed effect as well as everything related to the DF computation to
{cmd:e()} for the method specified in {cmd:method()}.  Thus, after posting,
you could continue to use this DF for other postestimation commands.  For
example, you could use {cmd:test, small} to perform Wald F tests on linear
combination of the fixed effects.

{pmore} 
{cmd:post} may also be specified using the syntax 
{opth post:(mixed##df_method:df_method)}. You must use this syntax if you
specify multiple {it:df_methods} in option {cmd:method()}.  With this syntax,
{cmd:estat df} computes the DF using the method specified in {cmd:post()}
and stores the results in {cmd:e()}. Only one computation method may be
specified using the syntax {cmd:post()}.

{pmore} 
The {it:df_method} specified in {cmd:post()} must be one of the DF methods
specified in option {cmd:method()}. If only one method is specified in option
{cmd:method()}, then one can simply use {cmd:post} to make this DF method
active for postestimation and for {cmd:mixed} replay.

{phang}
{cmd:eim} specifies that the expected information matrix be used in the DF
computation. It can be used only when {cmd:method()} contains {cmd:kroger} or
{cmd:satterthwaite}.  {cmd:eim} is the default.

{phang}
{cmd:oim} specifies that the observed information matrix be used in the DF
computation. It can be used only when {cmd:method()} contains {cmd:kroger} or
{cmd:satterthwaite}.


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse pig}{p_end}
{phang2}{cmd:. mixed weight i.week || id:, reml}{p_end}

{pstd}Calculate and compare the DFs using three different methods{p_end}
{phang2}{cmd:. estat df, method(kroger anova repeated)}{p_end}

{pstd}Post the {cmd:kroger} method to {cmd:e()}{p_end}
{phang2}{cmd:. estat df, method(kroger) post}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:estat df} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:r(dfmethods)}}DF methods{p_end}
{p2colreset}{...}

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:r(df)}}parameter-specific DF for each method specified in {cmd:method()}{p_end}
{synopt:{cmd:r(V_df)}}variance-covariance matrix of the estimators when {cmd:kroger} method is specified{p_end}

{pstd}
If {cmd:post()} is specified, {cmd:estat df} also stores the following in {cmd:e()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:e(F)}}overall F test statistic for the method specified in {cmd:post()}{p_end}
{synopt:{cmd:e(ddf_m)}}model DDF for the method specified in {cmd:post()}{p_end}
{synopt:{cmd:e(df_max)}}maximum DF for the method specified in {cmd:post()}{p_end}
{synopt:{cmd:e(df_avg)}}average DF for the method specified in {cmd:post()}{p_end}
{synopt:{cmd:e(df_min)}}minimum DF for the method specified in {cmd:post()}{p_end}
{p2colreset}{...}

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:e(dfmethod)}}DF method specified in {cmd:post()}{p_end}
{synopt:{cmd:e(dftitle)}}title for DF method{p_end}
{p2colreset}{...}

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:e(df)}}parameter-specific DFs for the method specified in {cmd:post()}{p_end}
{synopt:{cmd:e(V_df)}}variance-covariance matrix of the estimators when {cmd:kroger} method is posted{p_end}
{p2colreset}{...}
