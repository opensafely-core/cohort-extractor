{smcl}
{* *! version 1.0.3  19oct2017}{...}
{viewerdialog forecast "dialog forecast"}{...}
{vieweralsosee "[TS] forecast create" "mansection TS forecastcreate"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] forecast" "help forecast"}{...}
{vieweralsosee "[TS] forecast clear" "help forecast clear"}{...}
{viewerjumpto "Syntax" "forecast_create##syntax"}{...}
{viewerjumpto "Description" "forecast_create##description"}{...}
{viewerjumpto "Links to PDF documentation" "forecast_create##linkspdf"}{...}
{viewerjumpto "Option" "forecast_create##option"}{...}
{viewerjumpto "Example" "forecast_create##example"}{...}
{viewerjumpto "Technical note" "forecast_create##technote"}{...}
{p2colset 1 25 27 2}{...}
{p2col:{bf:[TS] forecast create} {hline 2}}Create a new forecast
model{p_end}
{p2col:}({mansection TS forecastcreate:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}
{cmdab:fore:cast} {cmdab:cr:eate} [{it:name}]
[{cmd:,} {cmd:replace}]

{phang}
{it:name} is an optional name that can be given to the model.  
{it:name} must follow the naming conventions described in
{findalias frnames}.


{marker description}{...}
{title:Description}

{pstd}
{cmd:forecast create} creates a new forecast model in Stata.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TS forecastcreateQuickstart:Quick start}

        {mansection TS forecastcreateRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker option}{...}
{title:Option}

{phang}
{cmd:replace} causes Stata to clear the existing model from memory before
creating {it:name}.  You may have only one model in memory at a time.  By
default, {cmd:forecast create} issues an error message if another model is
already in memory.


{marker example}{...}
{title:Example}

{pstd}Create a model named {cmd:salesfcast}{p_end}
{phang2}{cmd:. forecast create salesfcast}{p_end}


{marker technote}{...}
{title:Technical note}

{pstd}
Warning: Do not type {cmd:clear all}, {cmd:clear mata}, or {cmd:clear results}
after creating a forecast model with {cmd:forecast create} unless you intend
to remove your forecast model.  Typing {cmd:clear all} or {cmd:clear mata}
eliminates the internal structures used to store your forecast model.  Typing
{cmd:clear results} clears all estimation results from memory.  If your
forecast model includes estimation results that rely on the ability to call
{cmd:predict}, you will not be able to solve your model.
{p_end}
