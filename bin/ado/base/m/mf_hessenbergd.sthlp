{smcl}
{* *! version 1.0.9  15may2018}{...}
{vieweralsosee "[M-5] hessenbergd()" "mansection M-5 hessenbergd()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-1] LAPACK" "help m1_lapack"}{...}
{vieweralsosee "[M-5] schurd()" "help mf_schurd"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Matrix" "help m4_matrix"}{...}
{viewerjumpto "Syntax" "mf_hessenbergd##syntax"}{...}
{viewerjumpto "Description" "mf_hessenbergd##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_hessenbergd##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_hessenbergd##remarks"}{...}
{viewerjumpto "Conformability" "mf_hessenbergd##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_hessenbergd##diagnostics"}{...}
{viewerjumpto "Source code" "mf_hessenbergd##source"}{...}
{p2colset 1 24 26 2}{...}
{p2col:{bf:[M-5] hessenbergd()} {hline 2}}Hessenberg decomposition
{p_end}
{p2col:}({mansection M-5 hessenbergd():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 40 2}
{it:void}{bind:    }
{cmd:hessenbergd(}{it:numeric matrix A}{cmd:,} 
{it:H}{cmd:,} 
{it:Q}{cmd:)}

{p 8 40 2}
{it:void}{bind:   }
{cmd:_hessenbergd(}{it:numeric matrix A}{cmd:,} {bind:  }
{it:Q}{cmd:)}


{marker description}{...}
{title:Description}
	
{p 4 4 2}
{cmd:hessenbergd(}{it:A}{cmd:,} {it:H}{cmd:,} 
{it:Q}{cmd:)} calculates the Hessenberg decomposition of a square, numeric
matrix, {it:A}, returning the 
{help m6_glossary##hessform:upper Hessenberg form}
matrix in {it:H} and the orthogonal (unitary) matrix in {it:Q}.
{it:Q} is orthogonal if {it:A} is real and unitary if {it:A} is complex.

{p 4 4 2}
{cmd:_hessenbergd(}{it:A}{cmd:,} {it:Q}{cmd:)} 
does the same as {cmd:hessenbergd()} except that it returns {it:H} 
in {it:A}.

{p 4 4 2}
{cmd:_hessenbergd_la()}
is the interface into the LAPACK routines used to implement the above function;
see {bf:{help m1_lapack:[M-1] LAPACK}}. Its direct use is not recommended.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 hessenbergd()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
The Hessenberg decomposition of a matrix, {cmd:A}, can be written as

	{cmd:Q}' * {cmd:A} * {cmd:Q} = {cmd:H}
	
{p 4 4 2}
where {cmd:H} is upper Hessenberg; {cmd:Q} is orthogonal if {cmd:A} is 
real or unitary if {cmd:A} is complex. 

{p 4 4 2}
A matrix {cmd:H} is in upper Hessenberg form if all entries below its first
subdiagonal are zero.  For example, a 5 x 5 upper Hessenberg matrix looks like

	      {txt} 1   2   3   4   5
	    {c TLC}{hline 21}{c TRC}
	  1 {c |}  x   x   x   x   x  {c |}
	  2 {c |}  x   x   x   x   x  {c |}
	  3 {c |}  0   x   x   x   x  {c |}
	  4 {c |}  0   0   x   x   x  {c |}
	  5 {c |}  0   0   0   x   x  {c |}
	    {c BLC}{hline 21}{c BRC}

{p 4 4 2}
For instance, 

	{cmd:: A}
	       {txt} 1    2    3    4    5
	    {c TLC}{hline 26}{c TRC}
	  1 {c |}   3    2    1   -2   -5  {c |}
	  2 {c |}   4    2    1    0    3  {c |}
	  3 {c |}   4    4    0    1   -1  {c |}
	  4 {c |}   5    6    7   -2    4  {c |}
	  5 {c |}   6    7    1    2   -1  {c |}
	    {c BLC}{hline 26}{c BRC}

	{cmd:: hessenbergd(A, H=., Q=.)}
	
	{cmd:: H}
	       {txt}           1              2              3              4
	    {c TLC}{hline 60}
	  1 {c |}             3    2.903464745    -.552977683    -4.78764119 
	  2 {c |}  -9.643650761    7.806451613    2.878001755      5.1085876 
	  3 {c |}             0   -3.454023879   -6.119229633   -.2347200215
	  4 {c |}             0              0    1.404136249   -1.715823624
	  5 {c |}             0              0              0   -2.668128952
	    {c BLC}{hline 60}

	                  5
	     {hline 16}{c TRC}
	  1    -1.530555451  {c |}
	  2     5.580422694  {c |}
	  3     1.467932097  {c |}
	  4    -.9870601994  {c |}
	  5     -.971398356  {c |}
	     {hline 16}{c BRC}

	{cmd:: Q}
	       {txt}           1              2              3              4
	    {c TLC}{hline 60}
	  1 {c |}             1              0              0              0 
	  2 {c |}             0   -.4147806779   -.0368006164   -.4047768558
	  3 {c |}             0   -.4147806779   -.4871239484   -.5692309155
	  4 {c |}             0   -.5184758474    .8096135604   -.0748449196
	  5 {c |}             0   -.6221710168   -.3253949238    .7117092805
	    {c BLC}{hline 60}

	                  5
	     {hline 16}{c TRC}
	  1               0  {c |}
	  2    -.8140997488  {c |}
	  3     .5163752637  {c |}
	  4     .2647771074  {c |}
	  5    -.0221645995  {c |}
	     {hline 16}{c BRC}

{p 4 4 2}
Many algorithms use a Hessenberg decomposition in the process of finding
another decomposition with more structure.


{marker conformability}{...}
{title:Conformability}

{p 4 8 2}
{cmd:hessenbergd(}{it:A}{cmd:,} 
{it:H}{cmd:,} 
{it:Q}{cmd:)}:
{p_end}
	{it:input:}
		{it:A}:  {it:n x n}
	{it:output:}
		{it:H}:  {it:n x n}
		{it:Q}:  {it:n x n}
		

{p 4 8 2}
{cmd:_hessenbergd(}{it:A}{cmd:,} 
{it:Q}{cmd:)}:
{p_end}
	{it:input:}
		{it:A}:  {it:n x n}
	{it:output:}
		{it:A}:  {it:n x n}
		{it:Q}:  {it:n x n}

				
{marker diagnostics}{...}
{title:Diagnostics}

{p 4 8 2}
{cmd:_hessenbergd()} aborts with error if {it:A} is a view.

{p 4 8 2}
{cmd:hessenbergd()} and {cmd:_hessenbergd()} return missing results
if {it:A} contains missing values.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view hessenbergd.mata, adopath asis:hessenbergd.mata},
{view _hessenbergd.mata, adopath asis:_hessenbergd.mata}
{p_end}
