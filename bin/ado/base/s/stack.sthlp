{smcl}
{* *! version 1.1.14  19oct2017}{...}
{viewerdialog stack "dialog stack"}{...}
{vieweralsosee "[D] stack" "mansection D stack"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] contract" "help contract"}{...}
{vieweralsosee "[D] reshape" "help reshape"}{...}
{vieweralsosee "[D] xpose" "help xpose"}{...}
{viewerjumpto "Syntax" "stack##syntax"}{...}
{viewerjumpto "Menu" "stack##menu"}{...}
{viewerjumpto "Description" "stack##description"}{...}
{viewerjumpto "Links to PDF documentation" "stack##linkspdf"}{...}
{viewerjumpto "Options" "stack##options"}{...}
{viewerjumpto "Remarks" "stack##remarks"}{...}
{viewerjumpto "Examples" "stack##examples"}{...}
{p2colset 1 14 16 2}{...}
{p2col:{bf:[D] stack} {hline 2}}Stack data{p_end}
{p2col:}({mansection D stack:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmd:stack}
{varlist}
{ifin}
{cmd:,}
{c -(}{cmdab:i:nto(}{it:{help newvar:newvars}}{cmd:)}|{opt g:roup(#)}{c )-}
[{it:options}]

{synoptset 17 tabbed}{...}
{synopthdr}
{synoptline}
{syntab :Main}
{p2coldent :* {opth i:nto(newvar:newvars)}}identify names
of new variables to be created{p_end}
{p2coldent :* {opt g:roup(#)}}stack {it:#} groups of variables in
{varlist}{p_end}
{synopt :{opt clear}}clear dataset from memory{p_end}
{synopt :{opt wi:de}}keep variables in {varlist} that are not specified in
{it:{help newvar:newvars}}{p_end}
{synoptline}
{p 4 6 2}
* Either {opt into(newvars)} or {opt group(#)} is required.{p_end}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Data > Create or change data > Other variable-transformation commands}
      {bf:> Stack data}


{marker description}{...}
{title:Description}

{pstd}
{opt stack} stacks the variables in {varlist} vertically,
resulting in a dataset with variables {it:{help newvar:newvars}} and 
{helpb _N}*(Nv/Nn) observations, where Nv is the number of variables in
{it:varlist} and Nn is the number in {it:newvars}.
{opt stack} creates the new variable {cmd:_stack} identifying the groups.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D stackQuickstart:Quick start}

        {mansection D stackRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opth "into(newvar:newvars)"}
identifies the names of the new variables to be created.
{opt into()} may be specified using variable ranges
(for example, {cmd:into(v1-v3)}). Either {opt into()} or {opt group()},
but not both, must be specified.

{phang}
{opt group(#)} specifies the number of groups of variables in {varlist} to be
stacked.  The created variables will be named according to the first group in
{it:varlist}.  Either {opt group()} or {opt into()},
but not both, must be specified.

{phang}
{opt clear} indicates that it is okay to clear the dataset in memory.
If you do not specify this option, you will be asked to confirm your intentions.

{phang}
{opt wide} includes any of the original variables in {varlist} that
are not specified in {it:{help newvar:newvars}} in the resulting data.


{marker remarks}{...}
{title:Remarks}

{pstd}
This command is best understood by examples.  Consider 

{phang2}{cmd:. webuse stackxmpl}{p_end}
{phang2}{cmd:. stack a b c d, into(e f) clear}

{pstd}
This would create a new dataset containing

{phang2}{cmd:. list}{p_end}
             {c TLC}{hline 8}{c -}{hline 3}{c -}{hline 3}{c TRC}
             {c |} {res}_stack   e   f {txt}{c |}
             {c LT}{hline 8}{c -}{hline 3}{c -}{hline 3}{c RT}
          1. {c |} {res}     1   1   2 {txt}{c |}
          2. {c |} {res}     1   5   6 {txt}{c |}
          3. {c |} {res}     2   3   4 {txt}{c |}
          4. {c |} {res}     2   7   8 {txt}{c |}
             {c BLC}{hline 8}{c -}{hline 3}{c -}{hline 3}{c BRC}

{pstd}
We formed the new variable {cmd:e} by stacking {cmd:a} and {cmd:c}, and we
formed the new variable {cmd:f} by stacking {cmd:b} and {cmd:d}.  {cmd:_stack}
is automatically created and set equal to 1 for the first ({cmd:a}, {cmd:b})
group and equal to 2 for the second ({cmd:c}, {cmd:d}) group. 

{pstd}
The number of variables specified by {opt into()} determine the number of
groups formed.  {opt into()} may be specified with variable ranges, such as

{phang2}{cmd:. stack a b c d, into(v1-v2)}

{pstd}
as, of course, may the {varlist}

{phang2}{cmd:. stack a-d, into(v1-v2)}

{pstd}
The new variables formed may have the existing variables' names;

{phang2}{cmd:. stack a b c d, into(a b)}{p_end}

    makes perfect sense.

{pstd}
When you want the new variables to have the same names as the variables in
the first group, rather than specifying {opt into()}, you may specify
{opt group()}.  Equivalent to the above command is

{phang2}{cmd:. stack a b c d, group(2)}{p_end}

{pstd}
For instance, the latter command creates

{phang2}{cmd:. list}{p_end}
             {c TLC}{hline 8}{c -}{hline 3}{c -}{hline 3}{c TRC}
             {c |} {res}_stack   a   b {txt}{c |}
             {c LT}{hline 8}{c -}{hline 3}{c -}{hline 3}{c RT}
          1. {c |} {res}     1   1   2 {txt}{c |}
          2. {c |} {res}     1   5   6 {txt}{c |}
          3. {c |} {res}     2   3   4 {txt}{c |}
          4. {c |} {res}     2   7   8 {txt}{c |}
             {c BLC}{hline 8}{c -}{hline 3}{c -}{hline 3}{c BRC}


{marker examples}{...}
{title:Examples}

    {hline}
    Setup
        {cmd:. webuse stackxmpl}

    List the original data
	{cmd:. list}
		     a        b        c        d
	  1.         {res}1        2        3        4{txt}
	  2.         {res}5        6        7        8{txt}

{pstd}Form {cmd:e} by stacking {cmd:a} and {cmd:c} and form {cmd:f} by stacking
{cmd:b} and {cmd:d}{p_end}
	{cmd:. stack a b  c d, into(e f) clear}

    List the results
	{cmd:. list}
	        _stack   e   f    
	  1.         {res}1   1   2{txt}
	  2.         {res}1   5   6{txt}
	  3.         {res}2   3   4{txt}
	  4.         {res}2   7   8{txt}

{pstd}
{cmd:_stack} is automatically created and set equal to 1 for the first
({cmd:a},{cmd:b}) group and 2 for the second ({cmd:c},{cmd:d}) group.{p_end}

    {hline}
    Setup
{phang2}{cmd:. webuse stackxmpl, clear}

{pstd}Stack {cmd:a} on {cmd:a} and call it {cmd:a} and stack {cmd:b} on
{cmd:c} and call it {cmd:bc}{p_end}
       {cmd:. stack a b  a c, into(a bc) clear}

{pstd}List the results{p_end}
{phang2}{cmd:. list}

    {hline}
    Setup
{phang2}{cmd:. webuse stackxmpl, clear}

{pstd}Form {cmd:e} by stacking {cmd:a} and {cmd:c}, form {cmd:f} by
stacking {cmd:b} and {cmd:d}, and keep original variables {cmd:a}, {cmd:b},
{cmd:c}, and {cmd:d}{p_end}
        {cmd:. stack a b  c d, into(e f) clear wide}

{pstd}List the results{p_end}
{phang2}{cmd:. list}

    {hline}
    Setup
{phang2}{cmd:. webuse stackxmpl, clear}

{pstd}Stack {cmd:a} on {cmd:a} and call it {cmd:a}, stack {cmd:b} on
{cmd:c} and call it {cmd:bc}, and retain original variables ({cmd:a} will
contain stacked values because {cmd:a} is specified in {cmd:into()}){p_end}
        {cmd:. stack a b  a c, into(a bc) clear wide}

{pstd}List the results{p_end}
{phang2}{cmd:. list}{p_end}
    {hline}
