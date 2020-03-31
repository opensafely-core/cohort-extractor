{smcl}
{* *! version 2.3.3  10may2018}{...}
{vieweralsosee "[P] gettoken" "mansection P gettoken"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] syntax" "help syntax"}{...}
{vieweralsosee "[P] tokenize" "help tokenize"}{...}
{vieweralsosee "[P] while" "help while"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] invtokens()" "help mf_invtokens"}{...}
{vieweralsosee "[M-5] tokenget()" "help mf_tokenget"}{...}
{vieweralsosee "[M-5] tokens()" "help mf_tokens"}{...}
{viewerjumpto "Syntax" "gettoken##syntax"}{...}
{viewerjumpto "Description" "gettoken##description"}{...}
{viewerjumpto "Links to PDF documentation" "gettoken##linkspdf"}{...}
{viewerjumpto "Options" "gettoken##options"}{...}
{viewerjumpto "Remarks" "gettoken##remarks"}{...}
{viewerjumpto "Examples" "gettoken##examples"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[P] gettoken} {hline 2}}Low-level parsing{p_end}
{p2col:}({mansection P gettoken:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmd:gettoken}
{it:emname1} [{it:emname2}] {cmd::} {it:emname3}
[{cmd:,}
{cmdab:p:arse:("}{it:pchars}{cmd:")}
{cmdab:q:uotes}
{cmd:qed(}{it:lmacname}{cmd:)}
{cmdab:m:atch:(}{it:lmacname}{cmd:)}
{cmd:bind}]

{pstd}
where {it:pchars} are the parsing characters, {it:lmacname} is a local
macro name, and {it:emname} is described in the following table:

             {it:emname} is...{space 8}Refers to a ...
             {hline 35}
             {it:macroname}{space 11}local macro
             {cmd:(local)} {it:macroname}{space 3}local macro
             {cmd:(global)} {it:macroname}{space 2}global macro


{marker description}{...}
{title:Description}

{pstd}
{cmd:gettoken} is a low-level parsing command designed for programmers who
wish to parse input for themselves.  The {helpb syntax} command is an
easier-to-use, high-level parsing command.

{pstd}
{cmd:gettoken} obtains the next token from the macro {it:emname3} and stores
it in the macro {it:emname1}.  If macro {it:emname2} is specified, the rest of
the string from {it:emname3} is stored in {it:emname2} macro.  {it:emname1}
and {it:emname3}, or {it:emname2} and {it:emname3}, may be the same name.  The
first token is determined based on parsing characters {it:pchars}, which
default to a space if not specified.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection P gettokenRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}{cmd:parse("}{it:pchars}{cmd:")} specifies the parsing characters.  If
{cmd:parse()} is not specified, {cmd:parse(" ")} is assumed, meaning tokens
are identified by blanks.

{phang}{cmd:quotes} specifies that the outside quotes are not to be stripped
in what is stored in {it:emname1}.  This option has no effect on what is
stored in {it:emname2} because it always retains outside quotes.
{cmd:quotes} is a rarely specified option; usually you want the quotes
stripped.  You would not want the quotes stripped if you wanted to make a
perfect copy of the contents of the original macro for parsing at a later
time.

{phang}
{cmd:qed(}{it:lmacname}{cmd:)}
    specifies a local macroname that is to be filled in with 1 or 0
    according to whether the returned token was enclosed in quotes in
    the original string.  {cmd:qed()} does not change how parsing is
    done; it merely returns more information.

{phang}{cmd:match(}{it:lmacname}{cmd:)} specifies that parentheses be
matched in determining the token.  The outer level of parentheses, if any, are
removed before the token is stored in {it:emname1}.  The local macro
{it:lmacname} is set to "(" if parentheses were found; otherwise, it is set
to an empty string.

{phang}
{cmd:bind} specifies that expressions within parentheses and those within
brackets are to be bound together, even when not parsing on {cmd:()} and
{cmd:[]}.


{marker remarks}{...}
{title:Remarks}

{pstd}
Often we apply {cmd:gettoken} to the macro {hi:`0'}, as in

{phang2}{cmd:gettoken first : 0}

{pstd}
which obtains the first token (with spaces as token delimiters) from {hi:`0'}
and leaves {hi:`0'} unchanged.  Or, alternatively,

{phang2}{cmd:gettoken first 0 : 0}

{pstd}
which obtains the first token from {hi:`0'} and saves the rest back in
{hi:`0'}.


{marker examples}{...}
{title:Examples}

{pstd}
Assume that {hi:`0'} contains {hi:`"by x: cmd if sex=="male""'}

	{cmd:. gettoken left 0: 0, parse(": ")}

    results in
	{hi:`left'} containing  {hi:`"by"'}
	   {hi:`0'} containing  {hi:`" x: cmd if sex=="male""'}

    Continuing,

	{cmd:. gettoken next 0: 0, parse(": ")}

    results in
	{hi:`next'} containing  {hi:`"x"'}
	   {hi:`0'} containing  {hi:`": cmd if sex=="male""'}

    Continuing,

	{cmd:. gettoken next 0: 0, parse(": ")}

    results in
	{hi:`next'} containing  {hi:`":"'}
	   {hi:`0'} containing  {hi:`" cmd if sex=="male""'}


{pstd}
You wish to create a two-word command.  For example, {cmd:mycmd list} does
one thing and {cmd:mycmd generate} does another.

	{cmd:program mycmd}
	        {cmd:version {ccl stata_version}}
		{cmd:gettoken subcmd 0: 0}
		{cmd:if "`subcmd'"=="list" {c -(}}
			{cmd:mycmd_l `0'}
		{cmd:{c )-}}
		{cmd:else if "`subcmd'"=="generate" {c -(}}
			{cmd:mycmd_g `0'}
		{cmd:{c )-}}
		{cmd:else    error 199}
	{cmd:end}

	{cmd:program mycmd_l}
		{it:...}
	{cmd:end}

	{cmd:program mycmd_g}
		{it:...}
	{cmd:end}
