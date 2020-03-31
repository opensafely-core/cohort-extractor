{smcl}
{* *! version 1.2.0  30may2019}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-5] st_matrix()" "help mf_st_matrix"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] matrix rownames" "help matrix_rownames"}{...}
{vieweralsosee "[P] _ms_element_info" "help _ms_element_info"}{...}
{vieweralsosee "[P] _ms_eq_info" "help _ms_eq_info"}{...}
{viewerjumpto "Syntax" "mf_st_ms_utils##syntax"}{...}
{viewerjumpto "Description" "mf_st_ms_utils##description"}{...}
{viewerjumpto "Conformability" "mf_st_ms_utils##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_st_ms_utils##diagnostics"}{...}
{viewerjumpto "Source code" "mf_st_ms_utils##source"}{...}
{title:Title}

{phang}
{cmd:[M-5] st_ms_utils()} {hline 2} Matrix stripe utilities


{marker syntax}{...}
{title:Syntax}

{phang2}
{it:real colvector}
{cmd:st_matrixrowstripe_order(}{it:name}{cmd:)}

{phang2}
{it:real colvector}
{cmd:st_matrixcolstripe_order(}{it:name}{cmd:)}

{phang2}
{it:string matrix}{space 1}
{cmd:st_matrixrowstripe_split(}{it:name}{cmd:,}
	{it:width}{cmd:,} {it:colon}{cmd:)}

{phang2}
{it:string matrix}{space 1}
{cmd:st_matrixcolstripe_split(}{it:name}{cmd:,}
	{it:width}{cmd:,} {it:colon}{cmd:)}

{phang2}
{it:real matrix}{space 3}
{cmd:st_matrixrowstripe_fvinfo(}{it:name}{cmd:)}

{phang2}
{it:real matrix}{space 3}
{cmd:st_matrixcolstripe_fvinfo(}{it:name}{cmd:)}

{phang2}
{it:void}{space 10}
{cmd:st_matrixrowstripe_fvinfo(}{it:name}{cmd:,} {it:info}{cmd:)}

{phang2}
{it:void}{space 10}
{cmd:st_matrixcolstripe_fvinfo(}{it:name}{cmd:,} {it:info}{cmd:)}

{phang2}
{it:real colvector}
{cmd:st_matrixrownumb(}{it:name}{cmd:,} {it:S}{cmd:)}

{phang2}
{it:real colvector}
{cmd:st_matrixcolnumb(}{it:name}{cmd:,} {it:S}{cmd:)}

{phang2}
{it:real colvector}
{cmd:st_matrixroweqnumb(}{it:name}{cmd:,} {it:S}{cmd:)}

{phang2}
{it:real colvector}
{cmd:st_matrixcoleqnumb(}{it:name}{cmd:,} {it:S}{cmd:)}

{phang2}
{it:real scalar}{space 3}
{cmd:st_matrixrownfreeparms(}{it:name}{cmd:)}

{phang2}
{it:real scalar}{space 3}
{cmd:st_matrixcolnfreeparms(}{it:name}{cmd:)}

{phang2}
{it:real scalar}{space 3}
{cmd:st_matrixrownlfs(}{it:name}{cmd:)}

{phang2}
{it:real scalar}{space 3}
{cmd:st_matrixcolnlfs(}{it:name}{cmd:)}

{phang2}
{it:real colvector}
{cmd:st_matrixrowfreeparm(}{it:name}{cmd:)}

{phang2}
{it:real colvector}
{cmd:st_matrixcolfreeparm(}{it:name}{cmd:)}

{pstd}
where

	  {it:name}:  {it:string scalar}
	 {it:width}:  {it:real   scalar}
	 {it:colon}:  {it:real   scalar}  (optional)
	  {it:info}:  {it:real   matrix}
	     {it:S}:  {it:string matrix}


{marker description}{...}
{title:Description}

{pstd}
{cmd:st_matrixrowstripe_order(}{it:name}{cmd:)}
returns a permutation vector for putting the rows of Stata matrix
{it:name} in alphabetical order by the row names.  In the case of
factor variables, main effects and nonfactor variables are put first in
alphabetical order, then all two-way interactions are put in
alphabetical order, then all three-way interactions, and so on.
The intercept, {bf:_cons}, is put last.
If the row stripes of {it:name} contain equations, permutations are
within-equation and equation order remains unchanged.

{pstd}
{cmd:st_matrixcolstripe_order(}{it:name}{cmd:)}
returns a permutation vector for putting the columns of Stata matrix
{it:name} in alphabetical order by the column names.  In the case of
factor variables, main effects and nonfactor variables are put first in
alphabetical order, then all two-way interactions are put in
alphabetical order, then all three-way interactions, and so on.
The intercept, {bf:_cons}, is put last.
If the column stripes of {it:name} contain equations, permutations are
within-equation and equation order remains unchanged.

{pstd}
{cmd:st_matrixrowstripe_split(}{it:name}{cmd:,} {it:width}{cmd:)}
returns a string matrix, {it:S}, whose elements are made up of the row
stripes of the Stata matrix {it:name}.  The first column of {it:S} contains
the equation names; the remaining columns are split according to standard
splitting rules for factor variables, interactions, and time-series operators.
{it:width} specifies the maximum number of characters that each element of
{it:S} is allowed to contain.
{cmd:st_matrixrowstripe_split(}{it:name}{cmd:,} {it:width}{cmd:,} {cmd:0}{cmd:)}
will suppress the colon from the equation names in the first column of {it:S};
the default is to append a colon to the nonempty equation names in the first
column of {it:S}.

{pstd}
{cmd:st_matrixcolstripe_split(}{it:name}{cmd:,} {it:width}{cmd:)}
returns a string matrix, {it:S}, whose elements are made up of the column
names of the Stata matrix {it:name}.  The columns are split according to
standard splitting rules for factor variables, interactions, and time-series
operators.  {it:width} specifies the maximum number of characters that each
element of {it:S} is allowed to contain.
{cmd:st_matrixcolstripe_split(}{it:name}{cmd:,} {it:width}{cmd:,} {cmd:0}{cmd:)}
will suppress the colon from the equation names in the first column of {it:S};
the default is to append a colon to the nonempty equation names in the first
column of {it:S}.

{pstd}
{cmd:st_matrixrowstripe_fvinfo(}{it:name}{cmd:)} returns factor-variables
information hidden in the row stripe of Stata matrix {it:name}.

{pstd}
{cmd:st_matrixcolstripe_fvinfo(}{it:name}{cmd:)} returns factor-variables
information hidden in the column stripe of Stata matrix {it:name}.

{pstd}
{cmd:st_matrixrowstripe_fvinfo(}{it:name}{cmd:,} {it:info}{cmd:)} sets the
hidden factor-variables information for the row stripe of Stata matrix
{it:name}.

{pstd}
{cmd:st_matrixcolstripe_fvinfo(}{it:name}{cmd:,} {it:info}{cmd:)} sets the
hidden factor-variables information for the column stripe of Stata matrix
{it:name}.

{pstd}
{cmd:st_matrixrownumb(}{it:name}{cmd:,} {it:S}{cmd:)}
returns the row numbers of Stata matrix {it:name} associated with the
stripe specifications in matrix {it:S}.

{pstd}
{cmd:st_matrixcolnumb(}{it:name}{cmd:,} {it:S}{cmd:)}
returns the column numbers of Stata matrix {it:name} associated with the
stripe specifications in matrix {it:S}.

{pstd}
{cmd:st_matrixroweqnumb(}{it:name}{cmd:,} {it:S}{cmd:)}
returns the row equation indices of Stata matrix {it:name} associated
with the equation specifications in row vector {it:S}.

{pstd}
{cmd:st_matrixcoleqnumb(}{it:name}{cmd:,} {it:S}{cmd:)}
returns the column equation indices of Stata matrix {it:name} associated
with the equation specifications in column vector {it:S}.

{pstd}
{cmd:st_matrixrownfreeparms(}{it:name}{cmd:)}
returns the number of free parameter rows of Stata matrix {it:name}.

{pstd}
{cmd:st_matrixcolnfreeparms(}{it:name}{cmd:)}
returns the number of free parameter columns of Stata matrix {it:name}.

{pstd}
{cmd:st_matrixrownlfs(}{it:name}{cmd:)}
returns the number of linear forms among the rows of
Stata matrix {it:name}.

{pstd}
{cmd:st_matrixcolnlfs(}{it:name}{cmd:)}
returns the number of linear forms among the columns of
Stata matrix {it:name}.

{pstd}
{cmd:st_matrixrowfreeparm(}{it:name}{cmd:)}
returns a vector indicating where the free parameters are among the rows
of Stata matrix {it:name}.

{pstd}
{cmd:st_matrixcolfreeparm(}{it:name}{cmd:)}
returns a vector indicating where the free parameters are among the
columns of Stata matrix {it:name}.


{marker conformability}{...}
{title:Conformability}

    {cmd:st_matrixrowstripe_order(}{it:name}{cmd:)}:
	     {it:name}:  1 {it:x} 1
	   {it:result}:  {it:n x} 1

    {cmd:st_matrixcolstripe_order(}{it:name}{cmd:)}:
	     {it:name}:  1 {it:x} 1
	   {it:result}:  {it:n x} 1

    {cmd:st_matrixrowstripe_split(}{it:name}{cmd:,} {it:width}{cmd:,} {it:colon}{cmd:)}:
	     {it:name}:  1 {it:x} 1
	    {it:width}:  1 {it:x} 1
	    {it:colon}:  1 {it:x} 1  (optional)
	   {it:result}:  {it:n x m}  (0 {it:x} 2 if not found)

    {cmd:st_matrixcolstripe_split(}{it:name}{cmd:,} {it:width}{cmd:,} {it:colon}{cmd:)}:
	     {it:name}:  1 {it:x} 1
	    {it:width}:  1 {it:x} 1
	    {it:colon}:  1 {it:x} 1  (optional)
	   {it:result}:  {it:n x m}  (0 {it:x} 2 if not found)

    {cmd:st_matrixrowstripe_fvinfo(}{it:name}{cmd:)}:
	     {it:name}:  1 {it:x} 1
	   {it:result}:  {it:n x} 2  (0 {it:x} 2 if not found)

    {cmd:st_matrixcolstripe_fvinfo(}{it:name}{cmd:)}:
	     {it:name}:  1 {it:x} 1
	   {it:result}:  {it:n x} 2  (0 {it:x} 2 if not found)

    {cmd:st_matrixrowstripe_fvinfo(}{it:name}{cmd:,} {it:info}{cmd:)}:
	     {it:name}:  1 {it:x} 1
	     {it:info}:  {it:n x} 2
	   {it:result}:  {it:void}

    {cmd:st_matrixcolstripe_fvinfo(}{it:name}{cmd:,} {it:info}{cmd:)}:
	     {it:name}:  1 {it:x} 1
	     {it:info}:  {it:n x} 2
	   {it:result}:  {it:void}

    {cmd:st_matrixrownumb(}{it:name}{cmd:,} {it:S}{cmd:)}:
	     {it:name}:  1 {it:x} 1
	        {it:S}:  {it:n x} 2
	   {it:result}:  {it:n x} 1

    {cmd:st_matrixcolnumb(}{it:name}{cmd:,} {it:S}{cmd:)}:
	     {it:name}:  1 {it:x} 1
	        {it:S}:  {it:n x} 2
	   {it:result}:  {it:n x} 1

    {cmd:st_matrixroweqnumb(}{it:name}{cmd:,} {it:S}{cmd:)}:
	     {it:name}:  1 {it:x} 1
	        {it:S}:  {it:n x} 1
	   {it:result}:  {it:n x} 1

    {cmd:st_matrixcoleqnumb(}{it:name}{cmd:,} {it:S}{cmd:)}:
	     {it:name}:  1 {it:x} 1
	        {it:S}:  {it:n x} 1
	   {it:result}:  {it:n x} 1

    {cmd:st_matrixrownfreeparms(}{it:name}{cmd:)}:
	     {it:name}:  1 {it:x} 1
	   {it:result}:  1 {it:x} 1

    {cmd:st_matrixcolnfreeparms(}{it:name}{cmd:)}:
	     {it:name}:  1 {it:x} 1
	   {it:result}:  1 {it:x} 1

    {cmd:st_matrixrownlfs(}{it:name}{cmd:)}:
	     {it:name}:  1 {it:x} 1
	   {it:result}:  1 {it:x} 1

    {cmd:st_matrixcolnlfs(}{it:name}{cmd:)}:
	     {it:name}:  1 {it:x} 1
	   {it:result}:  1 {it:x} 1

    {cmd:st_matrixrowfreeparm(}{it:name}{cmd:)}:
	     {it:name}:  1 {it:x} 1
	   {it:result}:  {it:n x} 1

    {cmd:st_matrixcolfreeparm(}{it:name}{cmd:)}:
	     {it:name}:  1 {it:x} 1
	   {it:result}:  {it:n x} 1


{marker diagnostics}{...}
{title:Diagnostics}

{pstd}
{cmd:st_matrixrowstripe_order(}{it:name}{cmd:)} and
{cmd:st_matrixcolstripe_order(}{it:name}{cmd:)}
abort with error if the argument {it:name} is malformed.
These functions return {cmd:J(0,1,.)} if Stata matrix {it:name} does not
exist.

{pstd}
{cmd:st_matrixrowstripe_split(}{it:name}{cmd:,} {it:width}{cmd:,} {it:colon}{cmd:)} and
{cmd:st_matrixcolstripe_split(}{it:name}{cmd:,} {it:width}{cmd:,} {it:colon}{cmd:)}
abort with error if any of the arguments are malformed.  These functions
return {cmd:J(0,2,"")} if Stata matrix {it:name} does not exist.  {it:width}
is assumed to be 12 if {it:width}<5 or missing.  {it:colon} indicates whether
to include a colon in the equation name; the default is {it:colon}={cmd:1}.

{pstd}
{cmd:st_matrixrowstripe_fvinfo(}{it:name}{cmd:)} and
{cmd:st_matrixcolstripe_fvinfo(}{it:name}{cmd:)}
abort with error if {it:name} is malformed.  These functions
return {cmd:J(0,2,.)} if Stata matrix {it:name} does not exist.

{pstd}
{cmd:st_matrixrowstripe_fvinfo(}{it:name}{cmd:,} {it:info}{cmd:)} and
{cmd:st_matrixcolstripe_fvinfo(}{it:name}{cmd:,} {it:info}{cmd:)}
abort with error if any of the arguments are malformed.  These functions also
abort with error if {it:info} is not conformable with the corresponding
stripe's dimension.

{pstd}
{cmd:st_matrixrownumb(}{it:name}{cmd:,} {it:S}{cmd:)} and
{cmd:st_matrixcolnumb(}{it:name}{cmd:,} {it:S}{cmd:)}
abort with error if any of the arguments are malformed.

{pstd}
{cmd:st_matrixroweqnumb(}{it:name}{cmd:,} {it:S}{cmd:)} and
{cmd:st_matrixcoleqnumb(}{it:name}{cmd:,} {it:S}{cmd:)}
abort with error if any of the arguments are malformed.


{marker source}{...}
{title:Source code}

{pstd}
{view st_ms_order.mata, adopath asis:st_ms_order.mata}
{p_end}

{pstd}
All other functions are built in.
{p_end}
