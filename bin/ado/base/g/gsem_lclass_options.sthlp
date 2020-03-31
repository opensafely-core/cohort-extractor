{smcl}
{* *! version 1.0.7  14may2018}{...}
{viewerdialog "LCA (latent class analysis)" "dialog lca"}{...}
{vieweralsosee "[SEM] gsem lclass options" "mansection SEM gsemlclassoptions"}{...}
{vieweralsosee "[SEM] Intro 2" "mansection SEM Intro2"}{...}
{findalias asgsemlca}{...}
{findalias asgsemlcagof}{...}
{findalias asgsemlpa}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SEM] gsem" "help gsem_command"}{...}
{viewerjumpto "Syntax" "gsem_lclass_options##syntax"}{...}
{viewerjumpto "Description" "gsem_lclass_options##description"}{...}
{viewerjumpto "Links to PDF documentation" "gsem_lclass_options##linkspdf"}{...}
{viewerjumpto "Options" "gsem_lclass_options##options"}{...}
{viewerjumpto "Remarks" "gsem_lclass_options##remarks"}{...}
{viewerjumpto "Example" "gsem_lclass_options##example"}{...}
{p2colset 1 30 32 2}{...}
{p2col:{bf:[SEM] gsem lclass options} {hline 2}}Fitting models with latent
classes{p_end}
{p2col:}({mansection SEM gsemlclassoptions:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{cmd:gsem} {it:paths} ...{cmd:,}
... {opt lclass}{cmd:(}{it:lcname} {it:#} [{cmd:,} {opt base(#)}]{cmd:)}
{opt lcin:variant(pclassname)}

{synoptset 24}{...}
{synopthdr:lclass_options}
{synoptline}
{synopt :{opt lclass()}}fit model with latent classes{p_end}
{synopt :{opt lcin:variant(pclassname)}}specify parameters that are equal across latent classes{p_end}
{synoptline}

{marker pclassname}{...}
{synoptset 24}{...}
{p2col:{it:pclassname}}Description{p_end}
{p2line}
{p2col:{opt cons}}intercepts and cutpoints{p_end}

{p2col:{opt coef}}fixed coefficients{p_end}

{p2col:{opt errv:ar}}covariances of errors{p_end}
{p2col:{opt scale}}scaling parameters{p_end}
{p2line}
{p2col:{opt all}}all the above{p_end}
{p2col:{opt none}}none of the above{p_end}
{p2line}
{p2colreset}{...}
{p 4 6 2}
{cmd:lcinvariant(errvar scale)} is the default if
{opt lcinvariant()} is not specified.  {p_end}


{marker description}{...}
{title:Description}

{pstd}
{cmd:gsem} can fit models with categorical latent variables having specified
numbers of latent classes.  Some parameters can vary across classes while
others are constrained to be
equal across classes.

{pstd}
{cmd:gsem} performs such estimation when the {opt lclass()} option is
specified.  The {opt lcinvariant(pclassname)} option specifies which parameters
are to be constrained to be equal across the latent classes.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection SEM gsemlclassoptionsRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opt lclass}{cmd:(}{it:lcname} {it:#} [{cmd:,} {opt base(#)}]{cmd:)}
specifies that the model be fit as described above.

{pmore}
{it:lcname}
specifies the name of a categorical latent variable, and {it:#} specifies the
number of latent classes.  The latent classes are the contiguous integers
starting with {cmd:1} and ending with {it:#}.

{pmore}
{opt base(#)} specifies the class of {it:lcname} to be treated as the base
class.  The default is {cmd:base(1)}.

{phang}
{opth lcinvariant:(gsem_lclass_options##pclassname:pclassname)}
specifies which classes of parameters of the model are to be constrained to be
equal across the latent classes.  The classes are defined above.  The default
is {cmd:lcinvariant(errvar scale)}.


{marker remarks}{...}
{title:Remarks}

{pstd}
See {manlink SEM Intro 2}, and
see {findalias gsemlca}, {findalias gsemlcagof}, and
{findalias gsemlpa}.


{marker example}{...}
{title:Example}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse gsem_lca1}{p_end}

{pstd}Latent class model{p_end}
{phang2}{cmd:. gsem (accident play insurance stock <- ), logit lclass(C 2)}
