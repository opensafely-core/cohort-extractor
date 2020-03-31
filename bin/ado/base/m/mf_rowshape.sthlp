{smcl}
{* *! version 1.1.4  15may2018}{...}
{vieweralsosee "[M-5] rowshape()" "mansection M-5 rowshape()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Manipulation" "help m4_manipulation"}{...}
{viewerjumpto "Syntax" "mf_rowshape##syntax"}{...}
{viewerjumpto "Description" "mf_rowshape##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_rowshape##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_rowshape##remarks"}{...}
{viewerjumpto "Conformability" "mf_rowshape##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_rowshape##diagnostics"}{...}
{viewerjumpto "Source code" "mf_rowshape##source"}{...}
{p2colset 1 21 23 2}{...}
{p2col:{bf:[M-5] rowshape()} {hline 2}}Reshape matrix
{p_end}
{p2col:}({mansection M-5 rowshape():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:transmorphic matrix}
{cmd:rowshape(}{it:transmorphic matrix T}{cmd:,}
{it:real scalar r}{cmd:)}

{p 8 12 2}
{it:transmorphic matrix}
{cmd:colshape(}{it:transmorphic matrix T}{cmd:,}
{it:real scalar c}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:rowshape(}{it:T}{cmd:,} {it:r}{cmd:)} returns {it:T} transformed into a
matrix with {cmd:trunc(}{it:r}{cmd:)} rows.

{p 4 4 2}
{cmd:colshape(}{it:T}{cmd:,} {it:c}{cmd:)} 
returns {it:T} having
{cmd:trunc(}{it:c}{cmd:)} columns.

{p 4 4 2}
In both cases, elements are assigned sequentially with the column index 
varying more rapidly.
See {bf:{help mf_vec:[M-5] vec()}} for a function that varies the row index
more rapidly.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 rowshape()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Remarks are presented under the following headings:

	{help mf_rowshape##remarks1:Example of rowshape()}
	{help mf_rowshape##remarks2:Example of colshape()}
	
	
{marker remarks1}{...}
{title:Example of rowshape()}

	{cmd}: A
	{res}       1    2    3    4
	    {c TLC}{hline 19}{c TRC}
	  1 {c |} {res}11   12   13   14{txt} {c |}
	  2 {c |} {res}21   22   23   24{txt} {c |}
	  3 {c |} {res}31   32   33   34{txt} {c |}
	  4 {c |} {res}41   42   43   44{txt} {c |}
	    {c BLC}{hline 19}{c BRC}

	{cmd}: rowshape(A, 2)
	{res}
        {res}       1    2    3    4    5    6    7    8
	    {c TLC}{hline 39}{c TRC}
	  1 {c |} {res}11   12   13   14   21   22   23   24{txt} {c |}
	  2 {c |} {res}31   32   33   34   41   42   43   44{txt} {c |}
	    {c BLC}{hline 39}{c BRC}


{marker remarks2}{...}
{title:Example of colshape()}

	{cmd}: colshape(A, 2)
        {res}
	{res}       1    2
	    {c TLC}{hline 9}{c TRC}
	  1 {c |} {res}11   12{txt} {c |}
	  2 {c |} {res}13   14{txt} {c |}
	  3 {c |} {res}21   22{txt} {c |}
	  4 {c |} {res}23   24{txt} {c |}
	  5 {c |} {res}31   32{txt} {c |}
	  6 {c |} {res}33   34{txt} {c |}
	  7 {c |} {res}41   42{txt} {c |}
	  8 {c |} {res}43   44{txt} {c |}
	    {c BLC}{hline 9}{c BRC}


{marker conformability}{...}
{title:Conformability}

{p 4 4 2}
{cmd:rowshape(}{it:T}{cmd:,} {it:r}{cmd:)}
{p_end}
		{it:T}:   {it:r_0 x c_0}
		{it:r}:   1 {it:x} 1
	   {it:result}:   {it:r x} ({it:r_0}*{it:c_0})/{it:r}

{p 4 4 2}
{cmd:colshape(}{it:T}{cmd:,} {it:c}{cmd:)}
{p_end}
		{it:T}:   {it:r_0 x c_0}
		{it:c}:   1 {it:x} 1
	   {it:result}:   ({it:r_0}*{it:c_0})/{it:c x c}


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
Let {it:r_0} and {it:c_0} be the number of rows and columns of {it:T}.

{p 4 4 2}
{cmd:rowshape()} aborts with error if {it:r_0}*{it:c_0} is not evenly 
divisible by trunc({it:r}).

{p 4 4 2}
{cmd:colshape()} aborts with error if {it:r_0}*{it:c_0} is not evenly 
divisible by trunc({it:c}).


{marker source}{...}
{title:Source code}

{p 4 4 2}
Functions are built in.
{p_end}
