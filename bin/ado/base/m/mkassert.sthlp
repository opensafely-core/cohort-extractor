{smcl}
{* *! version 1.2.0  22jun2018}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] assert" "help assert"}{...}
{vieweralsosee "[P] cscript" "help cscript"}{...}
{vieweralsosee "[P] return" "help return"}{...}
{vieweralsosee "[R] Stored results" "help stored_results"}{...}
{viewerjumpto "Syntax" "mkassert##syntax"}{...}
{viewerjumpto "Description" "mkassert##description"}{...}
{viewerjumpto "Options" "mkassert##options"}{...}
{viewerjumpto "Example" "mkassert##example"}{...}
{viewerjumpto "Acknowledgment" "mkassert##ack"}{...}
{title:Title}

{p 4 22 2}
{hi:[P] mkassert} {hline 2} Generate asserts for Stata objects


{marker syntax}{...}
{title:Syntax}

{p 8 24 2}
{cmd:mkassert} {cmdab:r:class}
    [{cmd:,}
     {cmdab:mf:mt:(}{it:fmt}{cmd:)}
     {cmdab:mt:ol:(}{it:{help mkassert##mtol:tol}}{cmd:)}
     {cmdab:sf:mt:(}{it:fmt}{cmd:)}
     {cmdab:st:ol:(}{it:{help mkassert##stol:tol}}{cmd:)}
     {cmdab:mw:rap:(}{it:#}{cmd:)}
     {cmdab:n:ame:(}{it:str}{cmd:)}
     {cmdab:nostripe:s}
     {cmdab:tmp:names}
     {bind:{cmdab:sav:ing:(}{it:filename} [{cmd:,} {cmd:append} | {cmd:replace}]{cmd:)}}]

{p 8 24 2}
{cmd:mkassert} {cmdab:e:class}
     [{cmd:,}
      {cmdab:mf:mt:(}{it:fmt}{cmd:)}
      {cmdab:mt:ol:(}{it:{help mkassert##mtol:tol}}{cmd:)}
      {cmdab:sf:mt:(}{it:fmt}{cmd:)}
      {cmdab:st:ol:(}{it:{help mkassert##stol:tol}}{cmd:)}
      {cmdab:mw:rap:(}{it:#}{cmd:)}
      {cmdab:n:ame:(}{it:str}{cmd:)}
      {cmdab:nostripe:s}
      {cmdab:tmp:names}
     {bind:{cmdab:sav:ing:(}{it:filename} [{cmd:,} {cmd:append} | {cmd:replace}]{cmd:)}}]

{p 8 24 2}
{cmd:mkassert} {cmdab:scl:ass}
     [{cmdab:n:ame:(}{it:str}{cmd:)}
     {bind:{cmdab:sav:ing:(}{it:filename} [{cmd:,} {cmd:append} | {cmd:replace}]{cmd:)}}]

{p 8 24 2}
{cmd:mkassert} {cmdab:m:atrix} {it:name-list}
     [{cmd:,}
      {cmdab:mf:mt:(}{it:fmt}{cmd:)}
      {cmdab:mt:ol:(}{it:{help mkassert##mtol:tol}}{cmd:)}
      {cmdab:mw:rap:(}{it:#}{cmd:)}
      {cmdab:n:ame:(}{it:str}{cmd:)}
      {cmdab:nostripe:s}
      {cmdab:tmp:names}
      {bind:{cmdab:sav:ing:(}{it:filename} [{cmd:,} {cmd:append} | {cmd:replace}]{cmd:)}}]

{p 8 24 2}
{cmd:mkassert} {cmdab:sca:lar} {it:name-list}
     [{cmd:,}
      {cmdab:sf:mt:(}{it:fmt}{cmd:)}
      {cmdab:st:ol:(}{it:{help mkassert##stol:tol}}{cmd:)}
      {cmdab:n:ame:(}{it:str}{cmd:)}
      {bind:{cmdab:sav:ing:(}{it:filename} [{cmd:,} {cmd:append} | {cmd:replace}]{cmd:)}}]

{p 8 24 2}
{cmd:mkassert} {cmdab:c:har}{space 3}[{varlist}]
     [{cmd:,}
      {cmd:dta}
      {cmdab:n:ame:(}{it:str}{cmd:)}
      {bind:{cmdab:sav:ing:(}{it:filename} [{cmd:,} {cmd:append} | {cmd:replace}]{cmd:)}}]

{p 8 24 2}
{cmd:mkassert} {cmdab:f:ormat} [{varlist}]
     [{cmd:,}
      {cmdab:n:ame:(}{it:str}{cmd:)}
      {bind:{cmdab:sav:ing:(}{it:filename} [{cmd:,} {cmd:append} | {cmd:replace}]{cmd:)}}]

{p 8 24 2}
{cmd:mkassert} {cmdab:o:bs}{space 4}[{varlist}] {ifin}
{cmd:,} {cmd:id(}{it:varlist}{cmd:)}
     [{cmdab:c:omputed:(}{it:spec}{cmd:)}
      {cmdab:n:ame:(}{it:str}{cmd:)}
      {bind:{cmdab:sav:ing:(}{it:filename} [{cmd:,} {cmd:append} | {cmd:replace}]{cmd:)}}]


{marker description}{...}
{title:Description}

{pstd}{cmd:mkassert} generates a set of {helpb assert} statements for the
current contents of one of the following Stata "objects":

{p 8 16 2}{cmd:eclass}{space 2}macros, scalars, and matrices in {cmd:e()}

{p 8 16 2}{cmd:rclass}{space 2}macros, scalars, and matrices in {cmd:r()}

{p 8 16 2}{cmd:sclass}{space 2}macros in {cmd:s()}

{p 8 16 2}{cmd:matrix}{space 2}one or more matrices

{p 8 16 2}{cmd:scalar}{space 2}one or more scalars

{p 8 16 2}{cmd:char}{space 4}the characteristics associated with the variables
in {it:varlist} or those associated with the dataset (or both)

{p 8 16 2}{cmd:format}{space 2}the formats associated with the variables
in {it:varlist}

{p 8 16 2}{cmd:obs}{space 5}the values of variables in (a selection of)
observations

{pstd}
To enhance readability, the output uses formatting such as alignment and
colors.  The assert statements can be copied from the Results window into a
certification script (see {manhelp cscript P}).  Alternatively, you can have
{cmd:mkassert} write a log file (see {manhelp log R}).

{pstd}
If macro texts can be interpreted as integers and reals, asserts are
generated that test numerical equality (for reals, after conversion
to float). Integer scalar values are tested with strict equality rather
than some tolerance.


{marker options}{...}
{title:Options}

{phang}
{cmd:mfmt(}{it:fmt}{cmd:)}
    is the format used to convert matrix elements to ASCII.  It defaults
    to %18.0g.

{phang}{marker mtol}
{cmd:mtol(}{{it:#}|{it:name}|{it:name} {it:#}}{cmd:)}
    specifies the tolerance for {hi:mreldif} testing of matrices.
    If {it:#} is not specified, it defaults to 1e-8.  If {it:name} is
    specified, a local macro {it:name} is defined equal to {it:#}, and all
    tests in the block refer to {it:name}.

{phang}
{cmd:sfmt(}{it:fmt}{cmd:)}
    is the format used to convert scalars to ASCII.  The default is
      {cmd:sfmt(%18.0g)}.

{phang}{marker stol}
{cmd:stol(}{{it:#}|{it:name}|{it:name} {it:#}}{cmd:)}
    specifies the tolerance for {hi:reldif} testing of scalars.  The syntax
    is described with the {cmd:mtol()} option.

{phang}
{cmd:mwrap(}{it:#}{cmd:)}
    specifies that {cmd:mkassert} performs element wrapping in generating input
    commands for a matrix with {it:#} or more columns.  The default is 4.

{phang}
{cmd:name(}{it:str}{cmd:)}
    specifies that each {cmd:assert} statement generated is
    accompanied by a reference {it:str#} within a comment and is numbered
    sequentially.

{phang}
{cmd:nostripes} specifies that matrix stripes not be included in the set of
{cmd:assert} statements.

{phang}
{cmd:tmpnames} specifies that {cmd:assert} statements include temporary
matrices.  By default, permanent matrices are created and discarded 
when no longer needed.

{phang}
{cmd:saving(}{it:filename} [{cmd:,} {cmd:append} | {cmd:replace}]{cmd:)}
    opens a text-only file with {cmd:mkassert} output to be included in a
    certification script.

{phang}
{cmd:dta}
    specifies that certification statements should be written for the
    characteristics associated with the dataset {cmd:_dta}.

{phang}
{cmd:id(}{it:varlist}{cmd:)}
    specifies one or more variables that identify the observations (form a
    key).  These variables are used to match the current observations with
    those during certification.  The {cmd:if} and {cmd:in} clauses
    are evaluated after the data are sorted on the {cmd:id()} variables.

{phang}
{cmd:computed(}{it:spec}{cmd:)}
    specifies the real-valued variables that are "computed" and have to be
    {hi:reldif} tested rather than equality tested.  The specification
    {it:spec} is a varlist with optionally embedded numbers that are the
    tolerances used in {hi:reldif} testing for all following variables
    until overruled by another number.  The tolerance defaults to 1e-10.

{pmore}For example, {cmd:computed(1e-8 price weight 1e-7 trunk mpg)}
    specifies that {cmd:price} and {cmd:weight} are {hi:reldif} tested with
    tolerance 1e-8, and {cmd:trunk} and {cmd:mpg} are tested with tolerance
    1e-7.


{marker example}{...}
{title:Example}

    {cmd:. sysuse auto}
    {txt}(1978 Automobile Data)

    {cmd:. summarize price}

    {txt}    Variable |     Obs        Mean   Std. Dev.       Min        Max
    {txt}-------------+-----------------------------------------------------
    {txt}       price |{res}      74    6165.257   2949.496       3291      15906{txt}

    {cmd:. return list}

    {txt:scalars:}
                     {txt:r(N) =}{res:  74}
                 {txt:r(sum_w) =}{res:  74}
                  {txt:r(mean) =}{res:  6165.256756756757}
                   {txt:r(Var) =}{res:  8699525.974268789}
                    {txt:r(sd) =}{res:  2949.495884768919}
                   {txt:r(min) =}{res:  3291}
                   {txt:r(max) =}{res:  15906}
                   {txt:r(sum) =}{res:  456229}

    {cmd:. mkassert rclass}

    {txt}assert{space 9}r({res:N})     {col 25}== {res}74
    {txt}assert{space 9}r({res:sum_w}) {col 25}== {res}74
    {txt}assert reldif( r({res:mean})  {col 25} , {res}6165.256756756757{txt}{col 46}) < {res} 1e-8
    {txt}assert reldif( r({res:Var})   {col 25} , {res}8699525.974268789{txt}{col 46}) < {res} 1e-8
    {txt}assert reldif( r({res:sd})    {col 25} , {res}2949.495884768919{txt}{col 46}) < {res} 1e-8
    {txt}assert{space 9}r({res:min})   {col 25}== {res}3291
    {txt}assert{space 9}r({res:max})   {col 25}== {res}15906
    {txt}assert{space 9}r({res:sum})   {col 25}== {res}456229

{pstd}
{txt}If you were writing a certification script for {cmd:summarize},
you would copy the command line and the associated output from
{cmd:mkassert rclass} into the script, and possibly delete unimportant
{cmd:assert}s.  You can, of course, modify the tolerances, but notice
the tolerance options to modify the tolerance for all tests, or
"parameterize" the tests, via a named constant in the {cmd:mtol()} and
{cmd:stol()} options.


{marker ack}{...}
{title:Acknowledgment}

{pstd}
{cmd:mkassert} was written by Jeroen Weesie, Department of Sociology,
Utrecht University, The Netherlands.
{p_end}
