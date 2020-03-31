{smcl}
{* *! version 1.0.6  14may2018}{...}
{viewerdialog "SEM Builder" "stata sembuilder"}{...}
{vieweralsosee "[SEM] gsem path notation extensions" "mansection SEM gsempathnotationextensions"}{...}
{vieweralsosee "[SEM] Intro 2" "mansection SEM Intro2"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SEM] gsem" "help gsem_command"}{...}
{vieweralsosee "[SEM] gsem group options" "help gsem group options"}{...}
{vieweralsosee "[SEM] gsem lclass options" "help gsem lclass options"}{...}
{vieweralsosee "[SEM] sem and gsem path notation" "help sem and gsem path notation"}{...}
{viewerjumpto "Syntax" "gsem_path_notation_extensions##syntax"}{...}
{viewerjumpto "Description" "gsem_path_notation_extensions##description"}{...}
{viewerjumpto "Links to PDF documentation" "gsem_path_notation_extensions##linkspdf"}{...}
{viewerjumpto "Options" "gsem_path_notation_extensions##options"}{...}
{viewerjumpto "Examples" "gsem_path_notation_extensions##examples"}{...}
{p2colset 1 40 42 2}{...}
{p2col:{bf:[SEM] gsem path notation extensions} {hline 2}}Command syntax for
path diagrams{p_end}
{p2col:}({mansection SEM gsempathnotationextensions:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{cmd:gsem} {it:paths} ... [{cmd:,} {opt covariance()} {opt variance()} 
            {opt means()} {opt group()} {opt lclass()}]

{p 8 12 2}
{cmd:gsem} {it:paths} ... [{cmd:,} {opt covstructure()}
            {opt means()} {opt group()} {opt lclass()}]

{pstd}
{it:paths} specifies the direct paths between the variables of your model.

{pstd}
The model to be fit is fully described by {it:paths}, 
{opt covariance()}, {opt variance()},
{opt covstructure()}, and {opt means()}.

{pstd}
The syntax of these elements is modified when the {cmd:group()} or
{cmd:lclass()} option is specified.


{marker description}{...}
{title:Description}

{pstd}
This entry concerns {cmd:gsem} only.

{pstd}
The command syntax for describing generalized SEMs is fully
specified by {it:paths}, {opt covariance()}, {opt variance()},
{opt covstructure()}, and {opt means()}; see
{helpb sem and gsem path notation:[SEM] sem and gsem path notation} and
{helpb sem and gsem option covstructure:[SEM] sem and gsem option covstructure()}.

{pstd}
With {cmd:gsem}, the notation is extended to allow for generalized linear
response variables, multilevel latent variables, categorical latent variables,
and comparisons of groups.  That is the subject of this entry.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection SEM gsempathnotationextensionsRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opt covariance()},
{opt variance()}, and
{opt means()} are described in
{helpb sem and gsem path notation:[SEM] sem and gsem path notation}.

{phang}
{opt covstructure()}
is described in
{helpb sem and gsem option covstructure:[SEM] sem and gsem option covstructure()}.

{phang}
{opth group(varname)} allows models specified with
{it:paths}, {cmd:covariance()}, {cmd:variance()},
{cmd:covstructure()}, and {cmd:means()}
to be automatically interacted with the groups defined by {it:varname};
see {manlink SEM Intro 6}.
The syntax of {it:paths} and the arguments of
{opt covariance()}, {opt variance()},
{opt covstructure()}, and {opt means()}
gain an extra syntactical piece when {opt group()} is specified.

{phang}
{opt lclass()} allows models specified with
{it:paths}, {opt covariance()}, {opt variance()}, and {opt covstructure()}
to be automatically interacted with categorical latent variables;
see {manlink SEM Intro 2}.
The syntax of {it:paths} and the arguments of
{opt covariance()}, {opt variance()}, and {opt covstructure()}
gain an extra syntactical piece when {opt lclass()} is specified.


{marker examples}{...}
{title:Examples}

{title:Examples: Specifying family and link options}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse gsem_melanoma}{p_end}

{pstd}Fit a model with the negative binomial family and log link{p_end}
{phang2}{cmd:. gsem (deaths <- uv), family(nbinomial) link(log)}{p_end}

{pstd}Same model as above{p_end}
{phang2}{cmd:. gsem (deaths <- uv), nbreg}{p_end}


{title:Examples: Specifying multilevel models with nested effects}

{pstd}Fit a two-level negative binomial model with a random intercept 
for region{p_end}
{phang2}{cmd:. gsem (deaths <- uv M1[region]), nbreg}{p_end}

{pstd}Fit a three-level negative binomial model with random intercepts for
nation and region nested in nation{p_end}
{phang2}{cmd:. gsem (deaths <- uv M1[nation] M2[nation>region]), nbreg}{p_end}


{title:Examples: Specifying multilevel models with crossed effects}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse gsem_fifeschool}

{pstd}Fit a model with crossed random effects for primary and secondary schools{p_end}
{phang2}{cmd:. gsem (attain <- i.sex M1[pid] M2[sid])}{p_end}
