{smcl}
{* *! version 1.0.6  23oct2017}{...}
{viewerdialog mgarch "dialog mgarch"}{...}
{vieweralsosee "[TS] mgarch" "mansection TS mgarch"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[TS] arch" "help arch"}{...}
{vieweralsosee "[TS] var" "help var"}{...}
{viewerjumpto "Syntax" "mgarch##syntax"}{...}
{viewerjumpto "Description" "mgarch##description"}{...}
{viewerjumpto "Links to PDF documentation" "mgarch##linkspdf"}{...}
{viewerjumpto "Examples" "mgarch##examples"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[TS] mgarch} {hline 2}}Multivariate GARCH models{p_end}
{p2col:}({mansection TS mgarch:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmd:mgarch} {it:model}
{it:eq} [{it:eq} ... {it:eq}] 
{ifin} 
[{cmd:,} ...]

{synoptset 38 tabbed}{...}
{p2coldent :Family}{it:model}{p_end}
{synoptline}
{syntab:Vech}
{synopt :diagonal vech}{helpb mgarch_dvech:dvech}{p_end}

{syntab:Conditional correlation}
{synopt :constant conditional correlation}{helpb mgarch_ccc:ccc}{p_end}
{synopt :dynamic conditional correlation}{helpb mgarch_dcc:dcc}{p_end}
{synopt :varying conditional correlation}{helpb mgarch_vcc:vcc}{p_end}
{synoptline}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
{cmd:mgarch} estimates the parameters of multivariate generalized
autoregressive conditional-heteroskedasticity (MGARCH) models.
MGARCH models allow both the conditional mean and the
conditional covariance to be dynamic.

{pstd}
The general MGARCH model is so flexible that not all the parameters
can be estimated.  For this reason, there are many MGARCH models
that parameterize the problem more parsimoniously.

{pstd}
{cmd:mgarch} implements four commonly used parameterizations: the
diagonal vech model, the constant conditional correlation model, the dynamic
conditional correlation model, and the time-varying conditional correlation
model.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection TS mgarchRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker examples}{...}
{title:Example of mgarch dvech}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse stocks}{p_end}

{pstd}Fit a VAR(1) model of changes in toyota and honda, allowing for ARCH(1)
errors{p_end}
{phang2}{cmd:. mgarch dvech (toyota honda = L.toyota L.honda), arch(1)}{p_end}

{title:Example of mgarch dcc}

{pstd}Fit a VAR(1) model of changes in honda and nissan, allowing for ARCH(1)
	and GARCH(1) errors{p_end}
{phang2}{cmd:. mgarch dcc (honda nissan = L.honda L.nissan), arch(1) garch(1)}
{p_end}
