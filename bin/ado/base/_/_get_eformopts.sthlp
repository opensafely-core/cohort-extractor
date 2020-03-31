{smcl}
{* *! version 1.1.4  17oct2016}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] ereturn" "help ereturn"}{...}
{vieweralsosee "[P] syntax" "help syntax"}{...}
{viewerjumpto "Syntax" "_get_eformopts##syntax"}{...}
{viewerjumpto "Description" "_get_eformopts##description"}{...}
{viewerjumpto "Options" "_get_eformopts##options"}{...}
{viewerjumpto "Examples" "_get_eformopts##examples"}{...}
{viewerjumpto "Stored results" "_get_eformopts##results"}{...}
{title:Title}

{pstd}
{hi:[P] _get_eformopts} {hline 2} Parsing utility


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{cmd:_get_eformopts}
	[{cmd:,}
	{cmd:eformopts(}{it:eform_options}{cmd:)}
	{cmdab:allow:ed:(}{it:allow_options}{cmd:)}]

{p 8 12 2}
{cmd:_get_eformopts}
	{cmd:,}
	{cmd:soptions}
	[{cmd:eformopts(}{it:options}{cmd:)}
	{cmdab:allow:ed:(}{it:allow_options}{cmd:)}]

{pstd}
where {it:eform_options} is at most one of

{p 8 12 2}
	{cmdab:ef:orm:(}{it:string}{cmd:)} 
	{cmdab:ef:orm} 
	{cmd:hr} 
	{cmdab:ir:r} 
	{cmd:or} 
	{cmdab:rr:r}

{pstd}
{it:allow_options} is either {cmd:__all__} or an option specification allowed
by the {cmd:syntax} command, such as

{p 8 12 2}
	{cmd:hr} 
	{cmd:IRr} 
	{cmd:or} 
	{cmd:RRr}

{pstd}
({cmd:EForm} is implied) and {it:options} is any collection of
options, including {it:eform_options}.


{marker description}{...}
{title:Description}

{pstd}
{cmd:_get_eformopts} is a parsing tool, written to help parse the multiple
forms of the {cmd:eform()} option.

{pstd}
If more than one of the {it:eform_options} are supplied, {cmd:_get_eformopts}
will produce an error.


{marker options}{...}
{title:Options}

{phang}
{cmd:eformopts(}{it:eform_options}{cmd:)} contain options to be parsed.  When
{cmd:soptions} is also specified, {cmd:_get_eformopts} allows other options
besides {it:eform_options} within {cmd:eformopts()}, and will place them in
{cmd:s(options)}.

{phang}
{cmd:allowed(}{it:allow_options}{cmd:)} accepts option specifications allowed
by {cmd:syntax} to identify which shortcuts to the {cmd:eform()} option are
allowed.  Usually only one of the following is specified:

{pin3}
{cmd:EForm} {cmd:hr} {cmd:IRr} {cmd:or} {cmd:RRr}

{phang}
{cmd:soptions} indicates that {cmd:_get_eformopts} allows other options
besides {it:eform_options} within {cmd:eformopts()}, and will place them in
{cmd:s(options)}.


{marker examples}{...}
{title:Examples}

    {cmd}. _get_eformopts, eformopts(eform(Some string))
    {txt}
    {cmd}. sreturn list

    {txt}macros:
             s(eform) : "{res}eform(`"Some string"'){txt}"
               s(str) : "{res}Some string{txt}"

    {cmd}. _get_eformopts, eformopts(or) allowed(__all__)
    {txt}
    {cmd}. sreturn list

    {txt}macros:
     s(eform_cons_ti) : "{res}Odds{txt}"
             s(eform) : "{res}eform(`"Odds Ratio"'){txt}"
               s(str) : "{res}Odds Ratio{txt}"
               s(opt) : "{res}or{txt}"

    {cmd}. _get_eformopts, eformopts(or junk) soptions allowed(__all__)
    {txt}
    {cmd}. sreturn list

    {txt}macros:
     s(eform_cons_ti) : "{res}Odds{txt}"
             s(eform) : "{res}eform(`"Odds Ratio"'){txt}"
               s(str) : "{res}Odds Ratio{txt}"
               s(opt) : "{res}or{txt}"
           s(options) : "{res}junk{txt}"

    {cmd}. _get_eformopts, eformopts(or junk) allowed(__all__)
    {err}option {bf:junk} not allowed
    {txt}{search r(198):r(198);}

    {cmd}. _get_eformopts, eformopts(eform or) allowed(__all__)
    {err}only one of {bf:eform} or {bf:or} is allowed
    {txt}{search r(198):r(198);}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:_get_eformopts} stores the following in {cmd:s()}:

    Macros:

        {cmd:s(opt)}               "", or one of {cmd:eform}, {cmd:hr}, {cmd:irr}, {cmd:or}, {cmd:rrr}
	{cmd:s(str)}               contents of the {cmd:eform()} option
	{cmd:s(eform)}             equivalent {cmd:eform()} option to the one supplied
	{cmd:s(eform_cons_ti)}     coefficient title for the constant-only model   
	{cmd:s(options)}           any other options
