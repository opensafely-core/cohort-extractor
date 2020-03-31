{smcl}
{* *! version 2.0.3  19oct2017}{...}
{vieweralsosee "[R] estat" "mansection R estat"}{...}
{viewerjumpto "Syntax" "estat##syntax"}{...}
{viewerjumpto "Description" "estat##description"}{...}
{p2colset 1 14 16 2}{...}
{p2col:{bf:[R] estat} {hline 2}}Postestimation statistics{p_end}
{p2col:}({mansection R estat:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{synoptset 52 tabbed}
{synopt :Command}Reference{p_end}
{synoptline}
{syntab:{it:Display information criteria}}

{p2col 7 57 59 2:{cmd:estat ic} [{cmd:,} {opt n(#)}]}{helpb estat_ic:[R] estat ic}

{syntab:{it:Summarize estimation sample}}

{p2col 7 57 59 2:{cmd:estat} {cmdab:su:mmarize} [{it:eqlist}] [{cmd:,} {it:estat_summ_options}]}{helpb estat_summarize:[R] estat summarize}{p_end}


{syntab:{it:Display covariance matrix estimates}}

{p2col 7 57 59 2:{cmd:estat} {cmd:vce} [{cmd:,} {it:estat_vce_options}]}{helpb estat_vce:[R] estat vce}


{syntab:{it:Command-specific}}

{p2col 7 57 59 2:{cmd:estat} {it:subcommand1} [{cmd:,} {it:options1}]}

{synoptline}


{marker description}{...}
{title:Description}

{pstd}
{opt estat} displays scalar- and matrix-valued statistics after estimation; it
complements {cmd:predict}, which calculates variables after estimation.
Exactly what statistics {opt estat} can calculate depends on
the previous estimation command.

{pstd}
Three sets of statistics are so commonly used that they are available after
all estimation commands that store the model log likelihood.  {opt estat ic}
displays the Akaike's and Schwarz's Bayesian information criteria. 
{opt estat summarize} summarizes the variables used by the command and
automatically restricts the sample to {cmd:e(sample)}; it also summarizes the
weight variable and cluster structure, if specified.  {opt estat vce} displays
the covariance or correlation matrix of the parameter estimates of the
previous model.
{p_end}
