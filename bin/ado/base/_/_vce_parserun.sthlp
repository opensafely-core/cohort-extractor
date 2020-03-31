{smcl}
{* *! version 1.1.14  19apr2019}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] _vce_parse" "help _vce_parse"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] syntax" "help syntax"}{...}
{vieweralsosee "[R] vce_option" "help vce_option"}{...}
{viewerjumpto "Syntax" "_vce_parserun##syntax"}{...}
{viewerjumpto "Description" "_vce_parserun##description"}{...}
{viewerjumpto "Options" "_vce_parserun##options"}{...}
{viewerjumpto "Some official Stata commands that use _vce_parserun" "_vce_parserun##use"}{...}
{viewerjumpto "Stored results" "_vce_parserun##results"}{...}
{title:Title}

{p2colset 5 26 28 2}{...}
{p2col:{hi:[P] _vce_parserun} {hline 2}}Parsing tool for options
{cmd:vce(bootstrap)} and {cmd:vce(jackknife)}{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang2}
{cmd:_vce_parserun}
	{it:command_name} 
	[{cmd:,}
		{it:options}
	] {cmd::} {it:command}

{pstd}
where {it:command} is an estimation command that is assumed to follow
{help language:standard Stata syntax}.


{synoptset 27}{...}
{synopthdr}
{synoptline}
{synopt :{opt wtypes(weight_types)}}allowed weight types;
	default is {opt fw} {opt aw} {opt pw} {opt iw}{p_end}
{synopt :{opt noboot:strap}}{cmd:vce(bootstrap)} is not allowed{p_end}
{synopt :{opt nojack:knife}}{cmd:vce(jackknife)} is not allowed{p_end}
{synopt :{opt noother:vce}}only
	{cmd:vce(bootstrap)} and {cmd:vce(jackknife)} are allowed{p_end}
{synopt :{opt notest}}pass {opt notest}
	option to calls of {cmd:bootstrap} and {cmd:jackknife}{p_end}
{synopt :{opt panel:data}}parse {opt xt} settings and related options{p_end}
{synopt :{opt st:data}}parse {opt st} settings and related options{p_end}
{synopt :{opt bootopts(bootstrap_options)}}passthru
	options for calls to {helpb bootstrap}{p_end}
{synopt :{opt jkopts(jackknife_options)}}passthru
	options for calls to {helpb jackknife}{p_end}
{synopt :{opt robustok}}allow the {opt robust} option{p_end}
{synopt :{opt multivce}}allow multiple {opt vce()} options{p_end}

{synopt :{opt required:opts(opt_name)}}named options
	with arguments that are required when {cmd:vce(bootstrap)} or
	{cmd:vce(jackknife)} is specified{p_end}
{synopt :{opt noeqlist}}do not use {helpb _eqlist} to parse {it:command}{p_end}
{synopt :{it:_eqlist options}}passthru
	options to {helpb _eqlist} routines{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
{it:opt_name} is the name of an option.
Use capital letters to specify minimum abbreviations as in {helpb syntax}.
{p_end}


{marker description}{...}
{title:Description}

{pstd}
{cmd:_vce_parserun} is a programmer's tool that helps estimation commands 
parse the {opt vce()} option.  {cmd:_vce_parserun} takes on one of three
actions (provided there are no syntax errors):

{phang}
1.  When supplied with {cmd:vce(bootstrap)} or {cmd:vce(jackknife)},
{cmd:_vce_parserun} calls the corresponding prefix command--{helpb bootstrap}
or {helpb jackknife}--as a prefix to {it:command} and exits with the
{cmd:s(exit)} macro set to "{cmd:exit}".

{phang}
2.  If {it:command} is specified using the replay syntax, only options are
specified. {cmd:_vce_parserun} uses {it:command} to report the estimation
results and exits with the {cmd:s(exit)} macro set to "{cmd:exit}".

{phang}
3.  Otherwise, {cmd:_vce_parserun} exits with the {cmd:s(exit)} macro set to the
empty string "".


{marker options}{...}
{title:Options}

{phang}
{opt wtypes(weight_types)} specifies which weight types are allowed to be
specified in {it:command} and determines the default weight type.
{it:weight_types} is a list of weight types accepted by {helpb syntax}.
If {opt wtypes()} is not specified, the default is {cmd:wtypes(fw aw pw iw)}.

{phang}
{opt nobootstrap} specifies that the {cmd:vce(bootstrap)} option is not
allowed, resulting in an error message if it is an option of {it:command}.

{phang}
{opt nojackknife} specifies that the {cmd:vce(jackknife)} option is not
allowed, resulting in an error message if it is an option of {it:command}.

{phang}
{opt noothervce} specifies that only {cmd:vce(bootstrap)} and
{cmd:vce(jackknife)} are allowed, resulting in an error message if any other
{opt vce()} option is present in {it:command}.

{phang}
{opt notest} specifies that a {opt notest} option be passed to {cmd:bootstrap}
or {cmd:jackknife} if either of these prefix commands are executed.

{phang}
{opt paneldata} specifies that {it:command} is an {cmd:xt} estimation command,
and may require special parsing of the {opt i()} option.

{phang}
{opt stdata} specifies that {it:command} is an {cmd:st} estimation command,
and may require special parsing of the {opt cluster()} and {opt shared()}
options.  {opt stdata} also prevents {cmd:_vce_parserun} from reporting the
current estimation (item 2. in the above Description section).

{phang}
{opt bootopts(bootstrap_options)} specifies prefix options to be passed to
{cmd:bootstrap} if {cmd:vce(bootstrap)} is an option of {it:command}.

{phang}
{opt jkopts(jackknife_options)} specifies prefix options to be passed to
{cmd:jackknife} if {cmd:vce(jackknife)} is an option of {it:command}.

{phang}
{opt robustok} specifies that the {it:robust} option is allowed when
{cmd:vce(bootstrap)} and {cmd:vce(jackknife)} are not specified.  By default,
{cmd:_vce_parserun} exits with an error message when both {opt robust} and
{opt vce()} options are specified.

{phang}
{opt multivce} specifies that more than one {opt vce()} option is allowed.
Some error checking is performed, but it is the programmer's responsibility to
validate the specified combination of {opt vce()} options.

{phang}
{opt requiredopts(opt_name)} identifies required options with arguments to
search for when {cmd:vce(bootstrap)} or {cmd:vce(jackknife)} is specified.

{phang}
{opt noeqlist} specifies that {it:command} should not be parsed by an
{helpb _eqlist} object.


{marker use}{...}
{title:Some official Stata commands that use _vce_parserun}

{pstd}
The following estimation commands use {cmd:_vce_parserun}:

{pmore}
{helpb areg},
{helpb asmprobit},
{helpb binreg},
{helpb biprobit},
{helpb blogit},
{helpb bprobit},
{helpb clogit},
{helpb cloglog},
{helpb cnreg},
{helpb cnsreg},
{helpb etpoisson},
{helpb etregress},
{helpb frontier},
{helpb glm},
{helpb glogit},
{helpb gnbreg},
{helpb gprobit},
{helpb heckman},
{helpb heckprobit},
{helpb hetoprobit},
{helpb hetprobit},
{helpb hetregress},
{helpb intreg},
{helpb ivprobit},
{helpb ivregress},
{helpb ivtobit},
{helpb logistic},
{helpb logit},
{helpb mlogit},
{helpb mprobit},
{helpb nbreg},
{helpb nl},
{helpb ologit},
{helpb oprobit},
{helpb poisson},
{helpb probit},
{helpb regress},
{helpb scobit},
{helpb slogit},
{helpb stcox},
{helpb streg},
{helpb tnbreg},
{helpb tobit},
{helpb tpoisson},
{helpb truncreg},
{helpb xtabond},
{helpb xtcloglog},
{helpb xtfrontier},
{helpb xtgee},
{helpb xthtaylor},
{helpb xtintreg},
{helpb xtivreg},
{helpb xtlogit},
{helpb xtnbreg},
{helpb xtpoisson},
{helpb xtprobit},
{helpb xtrc},
{helpb xtreg},
{helpb xttobit},
{helpb zinb},
{helpb zip}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:_vce_parserun} stores the following in {cmd:s()}:

{p2colset 9 24 32 2}{...}
{pstd}Macros:{p_end}
{p2col :{cmd:s(exit)}}"{bf:exit}" or ""{p_end}
{p2colreset}{...}
