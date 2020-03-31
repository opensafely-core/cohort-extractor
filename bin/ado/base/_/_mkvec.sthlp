{smcl}
{* *! version 1.0.8  19feb2019}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] Maximize" "help maximize"}{...}
{vieweralsosee "[R] ml" "help ml"}{...}
{viewerjumpto "Syntax" "_mkvec##syntax"}{...}
{viewerjumpto "Description" "_mkvec##description"}{...}
{viewerjumpto "Options" "_mkvec##options"}{...}
{viewerjumpto "Examples" "_mkvec##examples"}{...}
{viewerjumpto "Stored results" "_mkvec##results"}{...}
{title:Title}

{p 4 20 2}
{hi:[P] _mkvec} {hline 2} Programmer's utility for creating a vector using
{opt from(init_specs)}


{marker syntax}{...}
{title:Syntax}

{p 8 15 2}{cmd:_mkvec} {it:matname} [{cmd:,} {cmd:from(}{it:init_specs} [{cmd:,}
			{cmd:copy} {cmd:skip}]{cmd:)} {opt up:date}
		{opt col:names(list_of_colfullnames)} {opt first}
		{opt err:or(string)} ]

{pstd}
where init_specs is one of the following forms:

	{it:vectorname}

{pmore}
{c -(} [{it:eqname}{cmd::}]{it:name}{cmd:=}{it:#} | {cmd:/}{it:eqname}{cmd:=}{it:#} {c )-} [{it:...}]

	{it:#} [{it:#}] [{it:...}]

{pstd}
If the last form above is used, then the {cmd:copy} option must be specified.

{pstd}
{it:list_of_colfullnames} is a full matrix stripe, such as that returned by
the {cmd:colfullnames} macro function.


{marker description}{...}
{title:Description}

{pstd}
Programmers may need to process the elements of a {cmd:from()}
specification (see {helpb maximize:[R] Maximize}) before passing it to
{cmd:ml model} or otherwise using it.  This command turns a {cmd:from()}
specification into a row vector called {it:matname}.

{pstd}
If {cmd:update} is specified, {it:matname} is an existing row vector, and
it is updated with the values in {cmd:from()}.

{pstd}
If {cmd:update} or {cmd:colnames()} is specified, the equation and colnames
implied by {cmd:from()} are checked against the original {it:matname} or
{cmd:colnames()}.  The returned row vector {it:matname} is labeled with the
original {it:matname} or {cmd:colnames()} equation/colnames in the original
order.

{pstd}
If {cmd:update} or {cmd:colnames()} is specified, any elements not
specified by {cmd:from()} are filled in with zeros.  Hence, when {cmd:update}
or {cmd:colnames()} is specified, programmers can be assured of the dimension,
equation/colnames, and order of the resulting row vector {it:matname}.

{pstd}
Using {cmd:update} with an initial row vector of all zeros is equivalent to
using {cmd:colnames()}.  With {cmd:colnames()}, however, you do not have to
create an initial vector.


{marker options}{...}
{title:Options}

{phang}
{cmd:from(}...{cmd:, copy)} specifies that the initialization is to be
copied into the vector without checking for valid column names.  {cmd:copy}
must be specified when {it:init_specs} is simply a list of numbers.

{phang}
{cmd:from(}...{cmd:, skip)} indicates that if extra vector elements are
specified, they are ignored.  Note that too few elements are always allowed.

{phang}
{cmd:update} specifies that {it:matname} is an existing row vector that
is to be updated with the values in {cmd:from()}.  If the {cmd:copy} option is
NOT specified, then {cmd:from()} must be a properly labeled vector or have
equation and colnames fully specified via the
[{it:eqname}{cmd::}]{it:name}{cmd:=}{it:#} syntax.  The equation and colnames
implied by {cmd:from()} are checked against those in the initial row vector.

{phang}
{cmd:colnames()} specifies the full matrix stripe that the programmer
expects to be present in the {cmd:from()} specification.  If the {cmd:copy}
option is NOT specified, then {cmd:from()} must be a properly labeled vector
or have equation and colnames fully specified via the
[{it:eqname}{cmd::}]{it:name}{cmd:=}{it:#} syntax.  The equation and colnames
implied by {cmd:from()} are checked against those in {cmd:colnames()}.  The
resulting vector returned by {cmd:_mkvec} is always labeled by
{cmd:colnames()}.

{phang}
{cmd:first} allows any blank equation names in {cmd:from()} to be
interpreted as the first equation name in {cmd:colnames()}.  This option is
typically specified when there is one main equation and, possibly, auxiliary
parameters.

{phang}
{cmd:error()} specifies an optional label for error messages.  For
example, if the programmer is processing a {cmd:from()} option on the main
command, {cmd:error("from()")} can be specified.


{marker examples}{...}
{title:Examples}

{pstd}
Although not intended for interactive use, these examples illustrate how
the command works:

{phang2}{cmd:. _mkvec x, from(mpg=1.2 wei=0.003)}

{phang2}{cmd:. matrix list x}

	{txt}x[1,2]
	       mpg  weight
	r1     {res}1.2    .003{txt}

	{cmd:. _mkvec x, from(mpg=5) update}

	{cmd:. matrix list x}

	{txt}x[1,2]
	       mpg  weight
	r1       {res}5    .003{txt}

{phang2}{cmd:. _mkvec x, from(_cons=2 mp=1 /sigma=4) colnames(price:mpg price:weight price:_cons sigma:_cons) first}

{phang2}{cmd:. matrix list x}

	{txt}x[1,4]
	     price:  price:  price:  sigma:
	       mpg  weight   _cons   _cons
	r1       {res}1       0       2       4{txt}

	{cmd:. sreturn list}

	{txt}macros:
	       s(k_fill)   : {res:"3"}
	       s(k)        : {res:"4"}

{phang2}{cmd:. _mkvec x, from(junk=5 _cons=2 mp=1 /sigma=4, skip) colnames(price:mpg price:weight price:_cons sigma:_cons) first}

{phang2}{cmd:. matrix list x}

	{txt}x[1,4]
	     price:  price:  price:  sigma:
	       mpg  weight   _cons   _cons
	r1       {res}1       0       2       4{txt}

{phang2}{cmd:. _mkvec x, from(head=5 _cons=2 mp=1 /sigma=4) error("from()") colnames(price:mpg price:weight price:_cons sigma:_cons) first}{p_end}
{p 8 8 2}{err:from(): extra parameter headroom found; specify skip option if necessary}{p_end}
	{search r(111):r(111);}

{phang2}{cmd:. _mkvec x, from(1 2 3 4, copy)}

{phang2}{cmd:. matrix list x}

	{txt}x[1,4]
	    c1  c1  c1  c1
	r1   {res}1   2   3   4{txt}

{phang2}{cmd:. _mkvec x, from(1 2 3 4, copy) colnames(price:mpg price:weight price:_cons sigma:_cons)}

{phang2}{cmd:. matrix list x}

	{txt}x[1,4]
	     price:  price:  price:  sigma:
	       mpg  weight   _cons   _cons
	r1       {res}1       2       3       4{txt}


{pstd}
Here is an example of the use of {cmd:_mkvec} in a program:

	{cmd:program define mycmd}
		{cmd:syntax varlist [if] [in] [, from(string)} {it:...} {cmd:]}
		{it:...}
		{cmd:if "`from'"!="" {c -(}}
			{cmd:tempname b0}
			{cmd:_mkvec `b0', from(`from') error("from()")}
			{it:[process `b0']}
			{cmd:local initopt "init(`b0',`s(copy)' `s(skip)')"}
		{cmd:{c )-}}
		{it:...}
		{cmd:ml model} {it:...} {cmd:, `initopt'} {it:...}
		{it:...}
	{cmd:end}

{pstd}
In the above example, the programmer did not specify {cmd:colnames()} because
the programmer did not need to check for proper equation/colnames
({cmd:ml model} will check it).
{p_end}


{marker results}{...}
{title:Stored results}

{pstd}{cmd:_mkvec} stores the following in {hi:s()}:

{p 8 20 2}{hi:s(copy)}{space 3}= "copy" if {cmd:copy} specified in
			{cmd:from()}{p_end}
{p 8 20 2}{hi:s(skip)}{space 3}= "skip" if {cmd:skip} specified in
			{cmd:from()}{p_end}
{p 8 20 2}{hi:s(k)}{space 6}= the dimension of the vector{p_end}
{p 8 20 2}{hi:s(k_fill)} = the number of elements explicitly filled in by
			{cmd:from()}{p_end}
