{smcl}
{* *! version 1.0.10  15may2018}{...}
{vieweralsosee "[M-5] gschurd()" "mansection M-5 gschurd()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-1] LAPACK" "help m1_lapack"}{...}
{vieweralsosee "[M-5] geigensystem()" "help mf_geigensystem"}{...}
{vieweralsosee "[M-5] ghessenbergd()" "help mf_ghessenbergd"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Matrix" "help m4_matrix"}{...}
{viewerjumpto "Syntax" "mf_gschurd##syntax"}{...}
{viewerjumpto "Description" "mf_gschurd##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_gschurd##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_gschurd##remarks"}{...}
{viewerjumpto "Conformability" "mf_gschurd##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_gschurd##diagnostics"}{...}
{viewerjumpto "Source code" "mf_gschurd##source"}{...}
{p2colset 1 20 22 2}{...}
{p2col:{bf:[M-5] gschurd()} {hline 2}}Generalized Schur decomposition
{p_end}
{p2col:}({mansection M-5 gschurd():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 8 2}
{it:void}{bind:        }
{cmd:gschurd(}{it:A}{cmd:,} 
{it:B}{cmd:,} 
{it:T}{cmd:,} 
{it:R}{cmd:,} 
{it:U}{cmd:,} 
{it:V}{cmd:,} 
{it:w}{cmd:,} 
{it:b}{cmd:)}

{p 8 8 2}
{it:void}{bind:       }
{cmd:_gschurd(}{it:A}{cmd:,} 
{it:B}{cmd:,} 
{it:U}{cmd:,} 
{it:V}{cmd:,} 
{it:w}{cmd:,} 
{it:b}{cmd:)}

{p 8 8 2}
{it:void}{bind: }
{cmd:gschurdgroupby(}{it:A}{cmd:,} 
{it:B}{cmd:,}
{it:f}{cmd:,}
{it:T}{cmd:,} 
{it:R}{cmd:,} 
{it:U}{cmd:,} 
{it:V}{cmd:,} 
{it:w}{cmd:,} 
{it:b}{cmd:,}
{it:m}{cmd:)}

{p 8 8 2}
{it:void}
{cmd:_gschurdgroupby(}{it:A}{cmd:,} 
{it:B}{cmd:,} 
{it:f}{cmd:,}
{it:U}{cmd:,} 
{it:V}{cmd:,} 
{it:w}{cmd:,} 
{it:b}{cmd:,}
{it:m}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:gschurd(}{it:A}{cmd:,} {it:B}{cmd:,} {it:T}{cmd:,} 
{it:R}{cmd:,} {it:U}{cmd:,} {it:V}{cmd:,} {it:w}{cmd:,} {it:b}{cmd:)} 
computes the generalized Schur decomposition of two square, numeric matrices,
{it:A} and {it:B}, and the  
{help m6_glossary##geigenvalues:generalized eigenvalues}.
The decomposition is returned in the 
{help m6_glossary##schurform:Schur-form} matrix, {it:T}; the
upper-triangular matrix, {it:R}; and the orthogonal (unitary) matrices, {it:U}
and {it:V}.  The generalized eigenvalues are returned
in the complex vectors {it:w} and {it:b}.

{p 4 4 2}
{cmd: gschurdgroupby(}{it:A}{cmd:,} {it:B}{cmd:,} {it:f}{cmd:,} 
{it:T}{cmd:,} {it:R}{cmd:,} {it:U}{cmd:,} {it:V}{cmd:,} 
{it:w}{cmd:,} {it:b}{cmd:,} {it:m}{cmd:)} 
computes the generalized Schur decomposition of two square, numeric matrices,
{it:A} and {it:B}, and the  
{help m6_glossary##geigenvalues:generalized eigenvalues},
and groups the results according to whether 
a condition on each generalized eigenvalue is satisfied.  
{it:f} is a pointer to the function that implements the condition on each
generalized eigenvalue, as discussed {help mf_gschurd##grouping:below}.
The number of generalized eigenvalues for which the condition is true is
returned in {it:m}.

{p 4 4 2}
{cmd:_gschurd()} mirrors {cmd:gschurd()}, the difference being that it
returns {it:T} in {it:A} and {it:R} in {it:B}.

{p 4 4 2}
{cmd:_gschurdgroupby()} mirrors {cmd:gschurdgroupby()}, the difference 
being that it returns {it:T} in {it:A} and {it:R} in {it:B}.

{p 4 4 2}
{cmd:_gschurd_la()} and {cmd: _gschurdgroupby_la()}
are the interfaces into the LAPACK routines used to implement the above
functions; see {bf:{help m1_lapack:[M-1] LAPACK}}.  Their direct use is not
recommended.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 gschurd()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Remarks are presented under the following headings:

	{help mf_gschurd##schurd:Generalized Schur decomposition}
	{help mf_gschurd##grouping:Grouping the results}


{marker schurd}{...}
{title:Generalized Schur decomposition}

{p 4 4 2}
The generalized Schur decomposition of a pair of square, numeric matrices,
{bf:A} and {bf:B}, can be written as

		{bf:U}' * {bf:A} * {bf:V} = {bf:T} 
		{bf:U}' * {bf:B} * {bf:V} = {bf:R}
		
{p 4 4 2}
where {bf:T} is in Schur form, {bf:R} is
upper triangular, and {bf:U} and {bf:V} are orthogonal if {bf:A} and {bf:B}
are real and are unitary if {bf:A} or {bf:B} is complex.  The complex vectors 
{bf:w} and {bf:b} contain the generalized eigenvalues.

{p 4 4 2}
If {bf:A} and {bf:B} are real, {bf:T} is in real Schur form and {bf:R} is a
real upper-triangular matrix.  If {bf:A} or {bf:B} is complex, {bf:T} is in
complex Schur form and {bf:R} is a complex upper-triangular matrix.

{p 4 4 2}
In the example below, we define {cmd:A} and {cmd:B}, obtain the 
generalized Schur decomposition, and list {cmd:T} and {cmd:R}. 

	{cmd:: A = (6, 2, 8, -1\-3, -4, -6, 4\0, 8, 4, 1\-8, -7, -3, 5)}

	{cmd:: B = (8, 0, -8, -1\-6, -2, -6, -1\-7, -6, 2, -6\1, -7, 9, 2)}

	{cmd:: gschurd(A, B, T=., R=., U=., V=., w=., b=.)}
	
	{cmd:: T}
	       {txt}         1              2              3              4
	    {c TLC}{hline 60}{c TRC}
	  1 {c |}  12.99313938    1.746927947    3.931212285   -10.91622337  {c |}
	  2 {c |}            0     .014016016    6.153566902    1.908835695  {c |}
	  3 {c |}            0   -4.362999645    1.849905717   -2.998194791  {c |}
	  4 {c |}            0              0              0   -5.527285433  {c |}
	    {c BLC}{hline 60}{c BRC}

	{cmd:: R}
	       {txt}         1              2              3              4
	    {c TLC}{hline 60}{c TRC}
	  1 {c |}  4.406836593    6.869534063   -1.840892081    1.740906311  {c |}
	  2 {c |}            0    13.88730687              0   -.6995556735  {c |}
	  3 {c |}            0              0    9.409495218   -4.659386723  {c |}
	  4 {c |}            0              0              0    9.453808732  {c |}
	    {c BLC}{hline 60}{c BRC}

	{cmd:: w}
               {txt}                       1                          2
            {c TLC}{hline 55}
          1 {c |}                12.9931394   .409611804 + 1.83488354i
            {c BLC}{hline 55}
                                      3                          4
             {hline 55}{c TRC}
          1    .024799819 - .111092453i                -5.52728543  {c |}
             {hline 55}{c BRC}

	{cmd:: b}
	       {txt}         1             2             3             4
	    {c TLC}{hline 57}{c TRC}
	  1 {c |}  4.406836593   4.145676341   .2509986829   9.453808732  {c |}
	    {c BLC}{hline 57}{c BRC}

{p 4 4 2}
Generalized eigenvalues can be obtained by typing

        {com}: w:/b
               {txt}                       1                          2
            {c TLC}{hline 55}
          1 {c |}                2.94840508   .098804579 + .442601735i
            {c BLC}{hline 55}
                                      3                          4
             {hline 55}{c TRC}
          1    .098804579 - .442601735i                -.584662287  {c |}
             {hline 55}{c BRC}


{marker grouping}{...}
{title:Grouping the results}

{p 4 4 2}
{cmd:gschurdgroupby()} reorders the generalized Schur decomposition 
so that a selected group of generalized eigenvalues appears in the 
leading block of the pair {cmd:w} and {cmd:b}.  It also reorders the 
generalized Schur form {cmd:T}, {cmd:R}, and orthogonal (unitary) 
matrices, {cmd:U} and {cmd:V}, correspondingly. 

{p 4 4 2}
We must pass {cmd:gschurdgroupby()} a {help m2_ftof:pointer} to a
function that implements our criterion.  The function must accept two
arguments, a complex scalar and a real scalar, so that it can receive a
generalized eigenvalue, and it must return the real value 0 to indicate
rejection and a nonzero real value to indicate selection.

{p 4 4 2}
In the following example, we use {cmd:gschurdgroupby()} to put the finite,
real, generalized eigenvalues first.  One of the arguments to
{cmd:schurdgroupby()} is a pointer to the function {cmd:onlyreal()} which
accepts two arguments, a complex scalar and a real scalar that define a
generalized eigenvalue.  {cmd:onlyreal()} returns 1 if the generalized
eigenvalue is finite and real; it returns zero otherwise.

	{cmd:: real scalar onlyreal(complex scalar w, real scalar b)}
	{cmd:> {c -(}}
	{cmd:>         if(b==0) return(0)}
	{cmd:>         if(Im(w/b)==0) return(1)}
	{cmd:>         return(0)}
	{cmd:> {c )-}}

	{cmd:: gschurdgroupby(A, B, &onlyreal(), T=., R=., U=., V=., w=., b=., m=.)}
	
{p 4 4 2}
We obtain

	{cmd:: T}
	       {txt}          1              2              3              4
	    {c TLC}{hline 61}{c TRC}
	  1 {c |}   12.99313938     8.19798168    6.285710813    5.563547054  {c |}
	  2 {c |}             0   -5.952366071   -1.473533834    2.750066482  {c |}
	  3 {c |}             0              0   -.2015830885    3.882051743  {c |}
	  4 {c |}             0              0    6.337230739    1.752690714  {c |}
	    {c BLC}{hline 61}{c BRC}

	{cmd:: R}
	       {txt}          1              2              3              4
	    {c TLC}{hline 61}{c TRC}
	  1 {c |}   4.406836593    2.267479575   -6.745927817    1.720793701  {c |}
	  2 {c |}             0    10.18086202   -2.253089622     5.74882307  {c |}
	  3 {c |}             0              0    -12.5704981              0  {c |}
	  4 {c |}             0              0              0    9.652818299  {c |}
	    {c BLC}{hline 61}{c BRC}

        {cmd:: w}
                                      1                          2
            {c TLC}{hline 55}
          1 {c |}                12.9931394   .409611804 + 1.83488354i
            {c BLC}{hline 55}
                                      3                          4
             {hline 55}{c TRC}
          1    .024799819 - .111092453i                -5.52728543  {c |}
             {hline 55}{c BRC}

	{cmd:: b}
	       {txt}         1             2             3             4
	    {c TLC}{hline 57}{c TRC}
	  1 {c |}  4.406836593   10.18086202   3.694083258   3.694083258  {c |}
	    {c BLC}{hline 57}{c BRC}

	{cmd:: w:/b}
                                     1                          2
            {c TLC}{hline 55}
          1 {c |}               2.94840508   .098804579 + .442601735i
            {c BLC}{hline 55}
                                     3                          4
            {hline 55}{c TRC}
          1   .098804579 - .442601735i                -.584662287  {c |}
            {hline 55}{c BRC}


{p 4 4 2}
{cmd:m} contains the number of real, generalized eigenvalues

	{cmd:: m}
 	  2


{marker conformability}{...}
{title:Conformability}

{p 4 8 2}
{cmd:gschurd(}{it:A}{cmd:,} 
{it:B}{cmd:,} 
{it:T}{cmd:,} 
{it:R}{cmd:,} 
{it:U}{cmd:,} 
{it:V}{cmd:,} 
{it:w}{cmd:,} 
{it:b}{cmd:)}:
{p_end}
	{it:input:}
		{it:A}:  {it:n x n}
		{it:B}:  {it:n x n}
	{it:output:}
		{it:T}:  {it:n x n}
		{it:R}:  {it:n x n}
		{it:U}:  {it:n x n}
		{it:V}:  {it:n x n}
		{it:w}:  1 {it:x n}
                {it:b}:  1 {it:x n}

{p 4 8 2}
{cmd:_gschurd(}{it:A}{cmd:,} 
{it:B}{cmd:,} 
{it:U}{cmd:,} 
{it:V}{cmd:,} 
{it:w}{cmd:,} 
{it:b}{cmd:)}:
{p_end}
	{it:input:}
		{it:A}:  {it:n x n}
		{it:B}:  {it:n x n}
	{it:output:}
		{it:A}:  {it:n x n}
		{it:B}:  {it:n x n}
		{it:U}:  {it:n x n}
		{it:V}:  {it:n x n}
		{it:w}:  1 {it:x n}
                {it:b}:  1 {it:x n}

{p 4 8 2}
{cmd:gschurdgroupby(}{it:A}{cmd:,} 
{it:B}{cmd:,} 
{it:f}{cmd:,} 
{it:T}{cmd:,} 
{it:R}{cmd:,} 
{it:U}{cmd:,} 
{it:V}{cmd:,} 
{it:w}{cmd:,} 
{it:b}{cmd:,} 
{it:m}{cmd:)}:
{p_end}
	{it:input:}
		{it:A}:  {it:n x n}
		{it:B}:  {it:n x n}
                {it:f}:  1 {it:x} 1 
	{it:output:}
		{it:T}:  {it:n x n}
		{it:R}:  {it:n x n}
		{it:U}:  {it:n x n}
		{it:V}:  {it:n x n}
		{it:w}:  1 {it:x n}
                {it:b}:  1 {it:x n}
		{it:m}:  1 {it:x} 1

{p 4 8 2}
{cmd:_gschurdgroupby(}{it:A}{cmd:,} 
{it:B}{cmd:,} 
{it:f}{cmd:,} 
{it:U}{cmd:,} 
{it:V}{cmd:,} 
{it:w}{cmd:,} 
{it:b}{cmd:,} 
{it:m}{cmd:)}:
{p_end}
	{it:input:}
		{it:A}:  {it:n x n}
		{it:B}:  {it:n x n}
	        {it:f}:  1 {it:x} 1 
	{it:output:}
		{it:A}:  {it:n x n}
		{it:B}:  {it:n x n}
		{it:U}:  {it:n x n}
		{it:V}:  {it:n x n}
		{it:w}:  1 {it:x n}
                {it:b}:  1 {it:x n}
		{it:m}:  1 {it:x} 1


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 8 2}
{cmd:_gschurd()} and {cmd:_gschurdgroupby()} abort with error if 
{it:A} or {it:B} is a view.

{p 4 8 2}
{cmd:gschurd()}, {cmd:_gschurd()}, {cmd:gschurdgroupby()}, 
and {cmd:_gschurdgroupby()} return missing results
if {it:A} or {it:B} contains missing values.

	
{marker source}{...}
{title:Source code}

{p 4 4 2}
{view gschurd.mata, adopath asis:gschurd.mata},
{view _gschurd.mata, adopath asis:_gschurd.mata},
{view gschurdgroupby.mata, adopath asis:gschurdgroupby.mata},
{view _gschurdgroupby.mata, adopath asis:_gschurdgroupby.mata}
{p_end}
