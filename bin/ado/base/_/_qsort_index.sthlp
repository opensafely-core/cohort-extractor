{smcl}
{* *! version 1.0.7  18sep2018}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] macro lists" "help macrolists"}{...}
{vieweralsosee "[U] 11.1.8 numlist" "help numlist"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] sort" "help sort"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] gsort" "help gsort"}{...}
{viewerjumpto "Syntax" "_qsort_index##syntax"}{...}
{viewerjumpto "Description" "_qsort_index##description"}{...}
{viewerjumpto "Options" "_qsort_index##options"}{...}
{viewerjumpto "Remarks" "_qsort_index##remarks"}{...}
{viewerjumpto "Examples" "_qsort_index##examples"}{...}
{title:Title}

{p 4 26 2}
{hi:[P] _qsort_index} {hline 2} Sort a list of words


{marker syntax}{...}
{title:Syntax}

{p 8 24 2}
{cmd:_qsort_index} {it:list1} [{cmd:\ *}|{it:list2} [{cmd:\} ...]]
[{cmd:,} {it:options} ]

{col 5}{it:options}{col 18}Description
{col 5}{hline -2}
{col 5}{opt a:scending}{col 18}sorts in ascending order (default)
{col 5}{opt d:escending}{col 18}sorts in descending order
{col 5}{opt al:pha}{col 18}sorts alphabetically; default is numerically
{col 5}{opt di:splay}{col 18}displays the sorted list (for debugging)
{col 5}{hline -2}


{marker description}{...}
{title:Description}

{pstd}
{cmd:_qsort_index} is a programming utility that sorts the words in {it:list1}
in ascending or descending order, and applies the same permutation to the words
of {it:list2}, {it:list3} etc.  All specified lists should have the same number
of words, {it:n}.  {cmd:*} is expanded to the list 1..{it:n}.

{pstd}
The ordering may be in numeric or alphanumeric order.

{pstd}
The ordering is returned in {cmd:r(order)}.  The ordered version of list{it:j}
is returned as {cmd:r(slist{it:j})}.

{pstd}
If you are looking to sort a list of numbers, and are not interested in the
sorting order, use the macro function {cmd::list sort} (see
{help macrolists}), which is much faster.

{pstd}
Currently quoted string elements of lists are not fully supported.  For
instance, with {cmd:_qsort_index `"y "m n o" x "a b c" z"', alpha}, the
{cmd:r(order)} will be correct, while {cmd:r(slist1)} is in the correct 
order, but with internal quotes stripped.


{marker options}{...}
{title:Options}

{phang}{opt ascending} and {opt descending}
specify that the words in {it:list1} are sorted in ascending (increasing) or
descending (decreasing) order.  In accordance with sorting observations,
{cmd:_qsort_index} defaults to {opt ascending}.

{phang}
{opt alpha} specifies that the words are compared alphanumerically.  The
default is to compare the words numerically.

{phang}{opt display}
displays the sorted lists.  This option is mostly useful while debugging.


{marker remarks}{...}
{title:Remarks}

{pstd}
Beware about sorting numerical lists with {help missing:missing values}
({cmd:.}, {cmd:.a}, {cmd:.b}, ... {cmd:.z}).  Missing values are located 
last and ordered in increasing order even if option 
{cmd:descending} was specified.

{pstd}
{cmd:_qsort_index} is usually stable, that is, the order of tied values remains
the same as the input order.  The exception is lists with tied values, sorted
alphanumerically in descending order.


{marker examples}{...}
{title:Examples}

    the most common application of {cmd:_qsort_index}

	{cmd:. _qsort_index 3 1 5 4 2}

	then: {cmd:r(order)  : "2 5 1 4 3"}
	      {cmd:r(slist1) : "1 2 3 4 5"}

    sort multiple lists in the order of the first list

	{cmd:. _qsort_index 3 1 5 4 2 \ 1 4 9 16 25 \ *, descending}

	then: {cmd:r(order)  : "3 4 1 5 2"}
	      {cmd:r(slist1) : "5 4 3 2 1"}
	      {cmd:r(slist2) : "9 16 1 25 4"}
	      {cmd:r(slist3) : "3 4 1 5 2"}

	{cmd:. _qsort_index 3 1 5 4 2 \ a b c dd ev, ascending}

	then: {cmd:r(order)  : "2 5 1 4 3"}
	      {cmd:r(slist1) : "1 2 3 4 5"}
	      {cmd:r(slist2) : "b ev a dd c"}

    _qsort_index uses a "stable" sorting algorithm:

	{cmd:. _qsort_index 1 3 2 3 1 \ a b c d e}

	then: {cmd:r(order) : ""          }
	      {cmd:r(list1) : "1 1 2 3 3"}
	      {cmd:r(list2) : "a e c b d"}

    To obtain an alphabetically ordered list of variables

	{cmd:. unab vlist: _all}{...}
{right:unabbreviated varlist in {cmd:vlist}  }
	{cmd:. _qsort_index `vlist', alpha}{...}
{right:alpha-sorted varlist in {cmd:r(list1)}  }
