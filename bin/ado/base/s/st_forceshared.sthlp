{smcl}
{* *! version 1.0.3  29jan2013}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ST] stcox" "help stcox"}{...}
{vieweralsosee "[ST] streg" "help streg"}{...}
{viewerjumpto "Syntax" "st_forceshared##syntax"}{...}
{viewerjumpto "Description" "st_forceshared##description"}{...}
{viewerjumpto "Remarks" "st_forceshared##remarks"}{...}
{viewerjumpto "Reference" "st_forceshared##reference"}{...}
{title:Title}

{p2colset 4 28 32 2}{...}
{p2col:{hi:[ST] stcox, forceshared}}{hline 2} Force estimation of a
shared-frailty survival model{p_end}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:stcox} ... {cmd:, forceshared} ...

{p 8 16 2}
{cmd:streg} ... {cmd:, forceshared} ...


{marker description}{...}
{title:Description}

{pstd}
{cmd:stcox, forceshared} and {cmd:streg, forceshared} force estimation of
shared-frailty survival models in the presence of delayed entries or gaps.


{marker remarks}{...}
{title:Remarks}

{pstd}
You can use the {cmd:shared()} option to fit a shared-frailty survival model
with {helpb stcox} or {helpb streg}.  This option is not allowed in the
presence of delayed entries or gaps.  You may override this by specifying the
{cmd:forceshared} option, but we do not recommend this.  If you use
{cmd:forceshared}, you will obtain consistent results only under the
assumption that the frailty distribution in the sample is independent of the
covariates and the truncation points.  This is a restrictive assumption, and
you should evaluate whether it is reasonable for your data before you proceed
with estimation.  For more information, see
{help st_forceshared##hdl11:van den Berg and Drepper (2011)},
which prompted the change in the behavior of the {cmd:shared()} option.


{marker reference}{...}
{title:Reference}

{marker hdl11}{...}
{phang}
van den Berg, G. J., and B. Drepper.  2011.  Inference for shared-frailty
survival models with left-truncated data.  Discussion Paper series.
Forschungsinstitut zur Zukunft der Arbeit, No. 6031,
urn:nbn:de:101:1-201110263752. {browse "http://hdl.handle.net/10419/58973"}.
