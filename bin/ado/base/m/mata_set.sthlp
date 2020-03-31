{smcl}
{* *! version 1.1.7  25sep2018}{...}
{vieweralsosee "[M-3] mata set" "mansection M-3 mataset"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] query" "help query"}{...}
{vieweralsosee "[R] set" "help set"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] creturn" "help creturn"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-3] Intro" "help m3_intro"}{...}
{viewerjumpto "Syntax" "mata_set##syntax"}{...}
{viewerjumpto "Description" "mata_set##description"}{...}
{viewerjumpto "Links to PDF documentation" "mata_set##linkspdf"}{...}
{viewerjumpto "Option" "mata_set##option"}{...}
{viewerjumpto "Remarks" "mata_set##remarks"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[M-3] mata set} {hline 2}}Set and display Mata system parameters
{p_end}
{p2col:}({mansection M-3 mataset:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
: {cmd:mata} {cmd:query}


{p 8 16 2}
: {cmd:mata} {cmd:set} 
{cmd:matacache}{bind:   }
{it:#} [{cmd:,} {cmdab:perm:anently} ]

{p 8 16 2}
: {cmd:mata} {cmd:set} 
{cmd:matalnum}{bind:    }
{c -(}{cmd:off} | {cmd:on}{c )-}

{p 8 16 2}
: {cmd:mata} {cmd:set} 
{cmd:mataoptimize} {c -(}{cmd:on} | {cmd:off}{c )-}

{p 8 16 2}
: {cmd:mata} {cmd:set} 
{cmd:matafavor}{bind:   }
{c -(}{cmd:space} | {cmd:speed}{c )-}
[{cmd:,} {cmdab:perm:anently} ]

{p 8 16 2}
: {cmd:mata} {cmd:set} 
{cmd:matastrict}{bind:  }
{c -(}{cmd:off} | {cmd:on}{c )-}
[{cmd:,} {cmdab:perm:anently} ]

{p 8 16 2}
: {cmd:mata} {cmd:set} 
{cmd:matalibs}{bind:    }
{cmd:"}{it:libname}{cmd:;}{it:libname}{cmd:;}...{cmd:"}

{p 8 16 2}
: {cmd:mata} {cmd:set} 
{cmd:matamofirst}{bind: }
{c -(}{cmd:off} | {cmd:on}{c )-}
[{cmd:,} {cmdab:perm:anently} ]


{p 4 4 2}
These commands are for use in Mata mode following Mata's colon prompt.
To use these commands from Stata's dot prompt, type

		. {cmd:mata: mata query}

		. {cmd:mata: mata set} ...


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:mata} {cmd:query} shows the values of Mata's system parameters.

{p 4 4 2}
{cmd:mata} {cmd:set} sets the value of the system parameters:

{* index matacache tt}{...}
{p 8 12 2}
{cmd:mata} {cmd:set} {cmd:matacache} specifies the maximum amount of memory, 
    in kilobytes, that may be consumed before Mata starts looking to drop
    autoloaded functions that are not currently being used.  The default value
    is {cmd:2000}, meaning 2000 kilobytes.  This parameter affects the
    efficiency with which Stata runs.  Larger values cannot hurt, but once
    {cmd:matacache} is large enough, larger values will not improve
    performance.

{* index matalnum tt}{...}
{p 8 12 2}
{cmd:mata} {cmd:set} {cmd:matalnum} turns program line-number tracing {cmd:on}
    or {cmd:off}.  The default setting is {cmd:off}.  This setting modifies how
    programs are compiled.  Programs compiled when {cmd:matalnum} is turned on
    include code so that, if an error occurs during execution of the program,
    the line number is also reported.  Turning {cmd:matalnum} on prevents Mata
    from being able to optimize programs, so they will run more slowly.
    Except when debugging, the recommended setting for this is off.

{* index mataoptimize tt}{...}
{* index optimization}{...}
{p 8 12 2}
{cmd:mata} {cmd:set} {cmd:mataoptimize} turns compile-time code optimization 
    {cmd:on} or {cmd:off}.  The default setting is {cmd:on}.  Programs
    compiled when {cmd:mataoptimize} is switched off will run more slowly and,
    sometimes, much more slowly.  The only reason to set {cmd:mataoptimize}
    off is if a bug in the optimizer is suspected.

{* index matafavor tt}{...}
{p 8 12 2}
{cmd:mata} {cmd:set} {cmd:matafavor} specifies whether, when executing code,
    Mata should favor conserving memory ({cmd:space}) or running quickly
    ({cmd:speed}).  The default setting is {cmd:space}.  Switching to
    {cmd:speed} will make Mata, in a few instances, run a little quicker
    but consume more memory.  Also see 
    {bf:{help mf_favorspeed:[M-5] favorspeed()}}.

{* index matastrict tt}{...}
{p 8 12 2}
{cmd:mata} {cmd:set} {cmd:matastrict} sets whether declarations can be 
    omitted inside the body of a program.  The default is {cmd:off}.  If 
    {cmd:matastrict} is switched on, compiling programs that omit the 
    declarations will result in a compile-time error;
    see {bf:{help m2_declarations:[M-2] Declarations}}.
    {cmd:matastrict} acts unexpectedly but pleasingly when set/reset inside
    ado-files; see {bf:{help m1_ado:[M-1] Ado}}.
    
{* index matalibs tt}{...}
{* index .mlib library files}{...}
{p 8 12 2}
{cmd:mata} {cmd:set} {cmd:matalibs} sets the names and order of the {cmd:.mlib}
    libraries to be searched; see {bf:{help m1_how:[M-1] How}}.
    {cmd:matalibs} usually is set to {cmd:"lmatabase;lmataado"}.
    However it is set, it is probably set correctly, because 
    Mata automatically searches for libraries the
    first time it is invoked in a Stata session.
    If, during a session, you erase or copy new
    libraries along the {help adopath:ado-path}, the best way to reset
    {cmd:matalibs} is with the {cmd:mata mlib index} command; see
    {bf:{help mata_mlib:[M-3] mata mlib}}.  The only reason to set
    {cmd:matalibs} by hand is to modify the order in which libraries are
    searched.

{* index matamofirst tt}{...}
{p 8 12 2}
{cmd:mata} {cmd:set} {cmd:matamofirst}
    states whether {cmd:.mo} files or {cmd:.mlib} libraries are searched
    first.  The default is {cmd:off}, meaning libraries are searched first.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-3 matasetRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker option}{...}
{title:Option}

{p 4 8 2}
{cmd:permanently}
    specifies that, in addition to making the change right now, the
    setting be remembered and become the default setting when you
    invoke Stata in the future.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Remarks are presented under the following headings:

	{help mata_set##remarks1:Relationship between Mata's mata set and Stata's set commands}
	{help mata_set##remarks2:c() values}


{marker remarks1}{...}
{title:Relationship between Mata's mata set and Stata's set commands}

{p 4 4 2}
The command 

	: {cmd:mata set} ...

{p 4 4 2}
issued from Mata's colon prompt and the command 

	. {cmd:set} ...

{p 4 4 2}
issued from Stata's dot prompt are the same command, so you may 
set Mata's (or even Stata's) system parameters either way.

{p 4 4 2}
The command 

	: {cmd:mata query} 

{p 4 4 2}
issued from Mata's colon prompt and the command 

	. {cmd:query mata}

{p 4 4 2}
issued from Stata's dot prompt are also the same command.


{marker remarks2}{...}
{title:c() values}

{p 4 4 2}
The following concerns Stata more than Mata.

{p 4 4 2}
Stata's c-class, {cmd:c()}, contains the values of system parameters and 
settings along with certain other constants.  {cmd:c()} values may be
referred to in Stata, either via macro substitution ({cmd:`c(current_date)'},
for example) or in expressions (in which case the macro quoting characters
may be omitted).  Stata's {cmd:c()} is also available in Mata via Mata's
{bf:{help mf_c_lc:[M-5] c()}} function.

{p 4 4 2}
Most everything set by {cmd:set} is available via {cmd:c()}, including 
Mata's set parameters:

{p 8 12 2}
{cmd:c(matacache)} returns a numeric scalar equal to the cache size.

{p 8 12 2}
{cmd:c(matalnum)} returns a string equal to "{cmd:on}" or "{cmd:off}".

{p 8 12 2}
{cmd:c(mataoptimize)} returns a string equal to "{cmd:on}" or "{cmd:off}".

{p 8 12 2}
{cmd:c(matafavor)} returns a string equal to "{cmd:space}" or "{cmd:speed}".

{p 8 12 2}
{cmd:c(matastrict)} returns a string equal to "{cmd:on}" or "{cmd:off}".

{p 8 12 2}
{cmd:c(matalibs)} returns a string of library names separated by semicolons.

{p 8 12 2}
{cmd:c(matamofirst)} returns a string equal to "{cmd:on}" or "{cmd:off}".

{p 4 4 2}
The above is in Stataspeak.  Rather than referring to {cmd:c(matacache)}, 
we would refer to {cmd:c("matacache")} if we were using Mata's 
function.  The real use of these values, however, is in Stata.
{p_end}
