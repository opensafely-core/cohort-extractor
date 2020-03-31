{smcl}
{* *! version 1.0.8  15may2018}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph" "help graph"}{...}
{vieweralsosee "[P] macro" "help macro"}{...}
{vieweralsosee "[P] syntax" "help syntax"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] _check4gropts" "help _check4gropts"}{...}
{viewerjumpto "Syntax" "_get_gropts##syntax"}{...}
{viewerjumpto "Description" "_get_gropts##description"}{...}
{viewerjumpto "Options" "_get_gropts##options"}{...}
{viewerjumpto "Some official Stata commands that use _get_gropts" "_get_gropts##use"}{...}
{viewerjumpto "Examples" "_get_gropts##examples"}{...}
{viewerjumpto "Stored results" "_get_gropts##results"}{...}
{title:Title}

{p 4 21 2}
{hi:[G-2] _get_gropts} {hline 2} Parsing tool for graph commands


{marker syntax}{...}
{title:Syntax}

{p 8 22 2}
{cmd:_get_gropts}{cmd:,}
	{cmd:graphopts(}{it:options}{cmd:)}
	[{cmd:grbyable}
	{cmd:nobycheck}
	{cmdab:total:allowed}
	{cmdab:missing:allowed}
	{cmd:getbyallowed(}{it:namelist}{cmd:)}
	{cmd:getcombine}
	{cmd:gettwoway}
	{cmd:getallowed(}{it:namelist}{cmd:)}]


{marker description}{...}
{title:Description}

{pstd}
{cmd:_get_gropts} is a parsing tool that was written to assist in syntax
checking and parsing of commands that generate graphs.


{marker options}{...}
{title:Options}

{phang}
{cmd:graphopts(}{it:options}{cmd:)} contains the options to be parsed.

{phang}
{cmd:grbyable} indicates that the {cmd:by()} option is allowed; see
{manhelpi by_option G-3}.  By default, {cmd:by()} is not allowed.

{phang2}
{cmd:totalallowed} indicates that the {cmd:total} option is allowed as an option
within the {cmd:by()} option.  By default, {cmd:by(,total)} is not allowed.

{phang2}
{cmd:missingallowed} indicates that the {cmd:missing} option is allowed as an option
within the {cmd:by()} option.  By default, {cmd:by(,missing)} is not allowed.

{phang}
{cmd:getbyallowed(}{it:namelist}{cmd:)} allows for the extraction of specific
options that take arguments from the {cmd:by()} option.  For each {it:name} in
{it:namelist}, the option {it:name}{cmd:()} is placed in
{cmd:s(by_}{it:name}{cmd:)} like a {cmd:passthru}.  By default, all
unrecognized options are returned in {cmd:s(byopts)}.
Option abbreviations are  allowed in {it:namelist}. All letters in
{it:name} are converted to lowercase for {cmd:s(by_}{it:name}{cmd:)}.

{pmore}
This option requires the {cmd:grbyable} option.
{* this restriction allows for easy grepping of graph producing commands}

{phang}
{cmd:nobycheck} prevents {cmd:_get_gropts} from checking if options are
provided to the {cmd:by()} option, but not a {it:varlist}.  By default, the
{cmd:by()} option requires a {it:varlist}.

{phang}
{cmd:getcombine} checks for the unique options allowed by {cmd:graph combine}.
For a complete list of these options, see
{manhelp graph_combine G-2:graph combine}; also see
{manhelp repeated_options G-4:Concept: repeated options}.  All options that
take arguments are returned as {cmd:passthru}s according to the {cmd:syntax}
documentation.  This option may not be combined with {cmd:gettwoway}.

{phang}
{cmd:gettwoway} checks for the unique options allowed by {cmd:graph twoway}.
For a complete list of these options, see {manhelpi twoway_options G-3}; also
see {manhelp repeated_options G-4:Concept: repeated options}.  All options that take arguments are
returned as {cmd:passthru}s according to the {cmd:syntax} documentation.  This
option may not be combined with {cmd:getcombine}.

{phang}
{cmd:getallowed(}{it:namelist}{cmd:)} allows for the extraction of specific
options that take arguments.  For each {it:name} in {it:namelist}, the
arguments in {it:name}{cmd:()} are placed in {cmd:s(}{it:name}{cmd:)}.  By
default, all unrecognized options are returned in {cmd:s(graphopts)}.
Option abbreviations are  allowed in {it:namelist}. All letters in
{it:name} are converted to lowercase for {cmd:s(}{it:name}{cmd:)}.


{marker use}{...}
{title:Some official Stata commands that use {cmd:_get_gropts}}

{pstd}
The following commands use {cmd:_get_gropts}.  See help for

{pin}
	{helpb ac},
	{helpb avplot},
	{helpb fracplot},
	{helpb greigen},
	{helpb grmeanby},
	{helpb kdensity},
	{helpb lowess},
	{helpb lroc},
	{helpb lsens},
	{helpb pac},
	{helpb pnorm},
	{helpb qnorm},
	{helpb qqplot},
	{helpb quantile},
	{helpb xchart},
	{helpb xcorr}


{marker examples}{...}
{title:Examples}

{phang}
{cmd}. _get_gropts , graphopts(by(for, total) name(gr1) saving(gr1, replace)
replace ciopts(m(o)) plot(function y = sin(3*c(pi)*x))) grbyable total
getallowed(ciopts plot){text}

{phang}
{cmd}. sreturn list{text}

    macros:
	 s(graphopts) : "{res}name(gr1) saving(gr1, replace) replace{txt}"
	   s(varlist) : "{res}foreign{txt}"
	     s(total) : "{res}total{txt}"
	      s(plot) : "{res}function y = sin(3*c(pi)*x){txt}"
	    s(ciopts) : "{res}m(o){txt}"

{phang}
{cmd}. _get_gropts , graphopts(by(for, total ti("Title") legend(draw)) name(gr1) saving(gr1, replace) ciopts(m(o)) plot(function y = sin(3*c(pi)*X))) grbyable total getbyallowed(TItle) getcombine getallowed(ciopts plot)

{phang}
{cmd}. sreturn list{text}

    {txt}macros:
	   s(varlist) : "{res}foreign{txt}"
	     s(total) : "{res}total{txt}"
	  s(by_title) : "{res}title("Title"){txt}"
	    s(byopts) : "{res}legend(draw){txt}"
       s(combineopts) : "{res}name(gr1) saving(gr1, replace){txt}"
	      s(plot) : "{res}function y = sin(3*c(pi)*x){txt}"
	    s(ciopts) : "{res}m(o){txt}"


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:_get_gropts} stores the following in {cmd:s()}:

{synoptset 18 tabbed}{...}
{p2col 5 18 22 2:Macros}{p_end}
{synopt:{cmd:s(varlist)}}varlist from {cmd:by()}{p_end}
{synopt:{cmd:s(total)}}{cmd:total} option from {cmd:by()}{p_end}
{synopt:{cmd:s(missing)}}{cmd:missing} option from {cmd:by()}{p_end}
{synopt:{cmd:s(by_}{it:name}{cmd:)}}the {it:name}{cmd:()} option from {cmd:by()}{p_end}
{synopt:{cmd:s(byopts)}}rest of the options from {cmd:by()}{p_end}
{synopt:{cmd:s(combineopts)}}the {cmd:getcombine} options{p_end}
{synopt:{cmd:s(twowayopts)}}the {cmd:gettwoway} options{p_end}
{synopt:{cmd:s(}{it:name}{cmd:)}}arguments in {it:name}{cmd:()} from {cmd:graphopts()}{p_end}
{synopt:{cmd:s(graphopts)}}rest of the options from {cmd:graphopts()}{p_end}
