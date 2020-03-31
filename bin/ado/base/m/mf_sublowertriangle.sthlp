{smcl}
{* *! version 1.0.13  15may2018}{...}
{vieweralsosee "[M-5] sublowertriangle()" "mansection M-5 sublowertriangle()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Manipulation" "help m4_manipulation"}{...}
{viewerjumpto "Syntax" "mf_sublowertriangle##syntax"}{...}
{viewerjumpto "Description" "mf_sublowertriangle##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_sublowertriangle##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_sublowertriangle##remarks"}{...}
{viewerjumpto "Conformability" "mf_sublowertriangle##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_sublowertriangle##diagnostics"}{...}
{viewerjumpto "Source code" "mf_sublowertriangle##source"}{...}
{p2colset 1 29 31 2}{...}
{p2col:{bf:[M-5] sublowertriangle()} {hline 2}}Return a matrix with zeros above a diagonal{p_end}
{p2col:}({mansection M-5 sublowertriangle():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 25 2}
{it:numeric matrix}
{cmd:sublowertriangle(}{it:numeric matrix A}{break}
           [{cmd:,} {it:numeric scalar p}]{cmd:)}

{p 8 25 2}
{it:void}{bind:         }
{cmd:_sublowertriangle(}{it:numeric matrix A}{break}
          [{cmd:,} {it:numeric scalar p}]{cmd:)}

{p 4 4 2}
where argument {it:p} is optional.


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:sublowertriangle(}{it:A}{cmd:,} {it:p}{cmd:)} returns {it:A} with the
elements above a diagonal set to zero.  In the returned matrix,
{it:A[i,j]=0} for all {it:i}-{it:j}<{it:p}.  If it is not specified, {it:p} 
is set to zero.

{p 4 4 2}
{cmd:_sublowertriangle()} mirrors {cmd:sublowertriangle()} but modifies
{it:A}.  {cmd:_sublowertriangle(}{it:A}{cmd:,} {it:p}{cmd:)} sets 
{it:A[i,j]=0} for all {it:i}-{it:j}<{it:p}.  If it is not specified, {it:p} 
is set to zero.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 sublowertriangle()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Remarks are presented under the following headings:

	{help mf_sublowertriangle##remarks1:Get lower triangle of a matrix}
	{help mf_sublowertriangle##remarks2:Nonsquare matrices}


{marker remarks1}{...}
{title:Get lower triangle of a matrix}

{p 4 4 2}
If {it:A} is a square matrix, then 
	{cmd:sublowertriangle(}{it:A}{cmd:,} 0{cmd:)}=
	{cmd:lowertriangle(}{it:A}{cmd:)}. {cmd:sublowertriangle()} is 
a generalization of {bf:{help mf_lowertriangle:lowertriangle()}}.

{p 4 4 2}
We begin by defining {cmd:A}

	{cmd:: A = (1, 2, 3 \ 4, 5, 6 \ 7, 8, 9)}

{p 4 4 2}
{cmd:sublowertriangle(A, 0)} returns {cmd:A} with zeros above the main
diagonal as does {bf:{help mf_lowertriangle:lowertriangle()}}:

	{cmd:: sublowertriangle(A, 0)}
	
	       {txt}1   2   3
	    {c TLC}{hline 13}{c TRC}
	  1 {c |}  1   0   0  {c |}
	  2 {c |}  4   5   0  {c |}
	  3 {c |}  7   8   9  {c |}
	    {c BLC}{hline 13}{c BRC}

{p 4 4 2}
{cmd:sublowertriangle(A, 1)} returns {cmd:A} with zeros in the main diagonal
and above.

	{cmd:: sublowertriangle(A, 1)}
	
		{txt}1   2   3
	    {c TLC}{hline 13}{c TRC}
	  1 {c |}  0   0   0  {c |}
	  2 {c |}  4   0   0  {c |}
	  3 {c |}  7   8   0  {c |}
	    {c BLC}{hline 13}{c BRC}

{p 4 4 2}
{cmd:sublowertriangle(A, p)} can take negative {it:p}. For example,
setting {cmd:p}=-1 yields

	{cmd:: sublowertriangle(A, -1)}

	       {txt}1   2   3
	    {c TLC}{hline 13}{c TRC}
	  1 {c |}  1   2   0  {c |}
	  2 {c |}  4   5   6  {c |}
	  3 {c |}  7   8   9  {c |}
	    {c BLC}{hline 13}{c BRC}


{marker remarks2}{...}
{title:Nonsquare matrices}

{p 4 4 2}
{cmd:sublowertriangle()} and {cmd:_sublowertriangle()} may be used with 
nonsquare matrices.  

{p 4 4 2}
For instance, we define a nonsquare matrix {cmd:A}

	{cmd:: A = (1, 2, 3, 4 \ 5, 6, 7,  8 \ 9, 10, 11, 12)}

{p 4 4 2}
We use {cmd:sublowertriangle()} to obtain the lower triangle of {cmd:A}:

	{cmd:: sublowertriangle(A, 0)}
	
	       {txt} 1    2    3    4
	    {c TLC}{hline 21}{c TRC}
	  1 {c |}  1    0    0    0   {c |}
	  2 {c |}  5    6    0    0   {c |}
	  3 {c |}  9   10   11    0   {c |}
	    {c BLC}{hline 21}{c BRC}


{marker conformability}{...}
{title:Conformability}

    {cmd:sublowertriangle(}{it:A}{cmd:,} {it:p}{cmd:)}:
	{it:input:}
		{it:A}:  {it:r x c}
		{it:p}:  1 {it:x} 1 (optional)
	{it:output:}
	   {it:result}:  {it:r x c}

    {cmd:_sublowertriangle(}{it:A}{cmd:,} {it:p}{cmd:)}:
	{it:input:}
		{it:A}:  {it:r x c}
	      	{it:p}:  1 {it:x} 1 (optional)
	{it:output:}
	        {it:A}:  {it:r x c}


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
None.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view sublowertriangle.mata, adopath asis:sublowertriangle.mata},
{view _sublowertriangle.mata, adopath asis:_sublowertriangle.mata}
{p_end}
