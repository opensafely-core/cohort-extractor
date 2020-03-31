{smcl}
{* *! version 1.0.8  15may2018}{...}
{vieweralsosee "[M-5] ghessenbergd()" "mansection M-5 ghessenbergd()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-1] LAPACK" "help m1_lapack"}{...}
{vieweralsosee "[M-5] gschurd()" "help mf_gschurd"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Matrix" "help m4_matrix"}{...}
{viewerjumpto "Syntax" "mf_ghessenbergd##syntax"}{...}
{viewerjumpto "Description" "mf_ghessenbergd##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_ghessenbergd##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_ghessenbergd##remarks"}{...}
{viewerjumpto "Conformability" "mf_ghessenbergd##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_ghessenbergd##diagnostics"}{...}
{viewerjumpto "Source code" "mf_ghessenbergd##source"}{...}
{p2colset 1 25 27 2}{...}
{p2col:{bf:[M-5] ghessenbergd()} {hline 2}}Generalized Hessenberg decomposition
{p_end}
{p2col:}({mansection M-5 ghessenbergd():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 40 2}
{it:void}{bind:  }
{cmd:ghessenbergd(}{it:numeric matrix A}{cmd:,} 
{it:B}{cmd:,} 
{it:H}{cmd:,} 
{it:R}{cmd:,} 
{it:U}{cmd:,} 
{it:V}{cmd:)}

{p 8 40 2}
{it:void}{bind: }
{cmd:_ghessenbergd(}{it:numeric matrix A}{cmd:,} 
{it:B}{cmd:,} {bind:     }
{it:U}{cmd:,} 
{it:V}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:ghessenbergd(}{it:A}{cmd:,} {it:B}{cmd:,} {it:H}{cmd:,} {it:R}{cmd:,}
{it:U}{cmd:,} {it:V}{cmd:)} computes the generalized Hessenberg
decomposition of two general, real or complex, square matrices, {it:A} 
and {it:B}, returning the 
{help m6_glossary##hessform:upper Hessenberg form} matrix in 
{it:H}, the upper triangular matrix in {it:R}, and the orthogonal 
(unitary) matrices in {it:U} and {it:V}.

{p 4 4 2}
{cmd:_ghessenbergd(}{it:A}{cmd:,} {it:B}{cmd:,} {it:U}{cmd:,} {it:V}{cmd:)}
mirrors {cmd:ghessenbergd()}, the difference being that it returns {it:H} 
in {it:A} and {it:R} in {it:B}.

{p 4 4 2}	
{cmd:_ghessenbergd_la()}
is the interface into the LAPACK routines used to implement the above function;
see {bf:{help m1_lapack:[M-1] LAPACK}}.  Its direct use is not recommended.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 ghessenbergd()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
The generalized Hessenberg decomposition of two square, numeric matrices
({it:A} and {it:B}) can be written as

		{cmd:U}' * {cmd:A} * {cmd:V} = {cmd:H}
		{cmd:U}' * {cmd:B} * {cmd:V} = {cmd:R}
		
{p 4 4 2}
where {cmd:H} is in upper Hessenberg form, 
{cmd:R} is upper triangular, and {cmd:U} and {cmd:V} are orthogonal matrices 
if {cmd:A} and {cmd:B} are real or are unitary matrices otherwise.

{p 4 4 2}
In the example below, we define {cmd:A} and {cmd:B}, obtain the 
generalized Hessenberg decomposition, and list {cmd:H} and {cmd:Q}. 

	{cmd:: A = (6, 2, 8, -1\-3, -4, -6, 4\0, 8, 4, 1\-8, -7, -3, 5)}

	{cmd:: B = (8, 0, -8, -1\-6, -2, -6, -1\-7, -6, 2, -6\1, -7, 9, 2)}

	{cmd:: ghessenbergd(A, B, H=., R=., U=., V=.)}

	{cmd:: H}
	       {txt}          1              2              3              4
	    {c TLC}{hline 61}{c TRC}
	  1 {c |}  -4.735680169    1.363736029    5.097381347    3.889763589  {c |}
	  2 {c |}   9.304479208   -8.594240253   -7.993282943    4.803411217  {c |}
	  3 {c |}             0    4.553169015    3.236266637   -2.147709419  {c |}
	  4 {c |}             0              0    6.997043028   -3.524816722  {c |}
	    {c BLC}{hline 61}{c BRC}

	{cmd:: R}
	       {txt}          1              2              3              4
	    {c TLC}{hline 61}{c TRC}
	  1 {c |}  -12.24744871   -1.089095534   -1.848528639   -5.398470103  {c |}
	  2 {c |}             0   -5.872766311    8.891361089     3.86967647  {c |}
	  3 {c |}             0              0    9.056748937    1.366322731  {c |}
	  4 {c |}             0              0              0    8.357135399  {c |}
	    {c BLC}{hline 61}{c BRC}


{marker conformability}{...}
{title:Conformability}

{p 4 8 2}
{cmd:ghessenbergd(}{it:A}{cmd:,} 
{it:B}{cmd:,} 
{it:H}{cmd:,} 
{it:R}{cmd:,} 
{it:U}{cmd:,} 
{it:V}{cmd:)}:
{p_end}
	{it:input:}
		{it:A}:  {it:n x n}
		{it:B}:  {it:n x n}
	{it:output:}
		{it:H}:  {it:n x n}
		{it:R}:  {it:n x n}
		{it:U}:  {it:n x n}
		{it:V}:  {it:n x n}

{p 4 8 2}
{cmd:_ghessenbergd(}{it:A}{cmd:,} 
{it:B}{cmd:,} 
{it:U}{cmd:,} 
{it:V}{cmd:)}:
{p_end}
	{it:input:}
		{it:A}:  {it:n x n}
		{it:B}:  {it:n x n}
	{it:output:}
		{it:A}:  {it:n x n}
		{it:B}:  {it:n x n}
		{it:U}:  {it:n x n}
		{it:V}:  {it:n x n}


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 8 2}
{cmd:_ghessenbergd()} aborts with error if {it:A} or {it:B} is a view.

{p 4 8 2}
{cmd:ghessenbergd()} and {cmd:_ghessenbergd()} return missing results
if {it:A} or {it:B} contains missing values.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view ghessenbergd.mata, adopath asis:ghessenbergd.mata},
{view _ghessenbergd.mata, adopath asis:_ghessenbergd.mata}
{p_end}
