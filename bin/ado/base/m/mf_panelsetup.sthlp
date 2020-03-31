{smcl}
{* *! version 1.1.5  15may2018}{...}
{vieweralsosee "[M-5] panelsetup()" "mansection M-5 panelsetup()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Utility" "help m4_utility"}{...}
{viewerjumpto "Syntax" "mf_panelsetup##syntax"}{...}
{viewerjumpto "Description" "mf_panelsetup##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_panelsetup##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_panelsetup##remarks"}{...}
{viewerjumpto "Conformability" "mf_panelsetup##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_panelsetup##diagnostics"}{...}
{viewerjumpto "Source code" "mf_panelsetup##source"}{...}
{p2colset 1 23 25 2}{...}
{p2col:{bf:[M-5] panelsetup()} {hline 2}}Panel-data processing
{p_end}
{p2col:}({mansection M-5 panelsetup():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 16 16 2}
{it:info} = 
{cmd:panelsetup(}{it:V}{cmd:,}
{it:idcol}{cmd:)}

{p 16 16 2}
{it:info} = 
{cmd:panelsetup(}{it:V}{cmd:,}
{it:idcol}{cmd:,}
{it:minobs}{cmd:)}

{p 16 16 2}
{it:info} = 
{cmd:panelsetup(}{it:V}{cmd:,}
{it:idcol}{cmd:,}
{it:minobs}{cmd:,}
{it:maxobs}{cmd:)}


{p 8 8 2}
{it:real rowvector}
{cmd:panelstats(}{it:info}{cmd:)}

{p 8 8 2}
{it:real matrix}{bind:   }
{cmd:panelsubmatrix(}{it:V}{cmd:,}
{it:i}{cmd:,}
{it:info}{cmd:)}

{p 8 8 2}
{it:void}{bind:          }
{cmd:panelsubview(}{it:SV}{cmd:,} 
{it:V}{cmd:,}
{it:i}{cmd:,}
{it:info}{cmd:)}

{p 4 4 2}
where, 

		    {it:V}:  {it:real} or {it:string} {it:matrix}, possibly a view
		{it:idcol}:  {it:real scalar}
	       {it:minobs}:  {it:real scalar}
	       {it:maxobs}:  {it:real scalar}
		 {it:info}:  {it:real matrix}
		    {it:i}:  {it:real scalar}
		   {it:SV}:  {it:matrix} to be created, possibly as view


{marker description}{...}
{title:Description}

{p 4 4 2}
These functions assist with the processing of panel data.  The idea is to 
make it easy and fast to write loops like

		{cmd:for (}{it:i}{cmd:=1;} {it:i}{cmd:<=}{it:number_of_panels}{cmd:;} {it:i}{cmd:++) {c -(}}
			{it:X} {cmd:=} {it:matrix corresponding to panel i}
			...
			...{it:(calculations using X)}...
			...
		{cmd:{c )-}}

{p 4 4 2}
Using these functions, this loop could become

		{cmd}st_view(Vid, ., "idvar",      "touse")
		st_view(V,   ., ("x1", "x2"), "touse")

		info = panelsetup(Vid, 1)

		for (i=1; i<=rows(info); i++) {
			X = panelsubmatrix(V, i, info)
			{txt}...{cmd}
			{txt}...{it:(calculations using} {cmd:X}{it:)}{txt}...{cmd}
			{txt}...{cmd}
		}{txt}

{p 4 4 2}
{cmd:panelsetup(}{it:V}{cmd:,} {it:idcol}{cmd:,} ...{cmd:)} sets up panel
processing.  It returns a matrix ({it:info}) that is passed to other
panel-processing functions.

{p 4 4 2}
{cmd:panelstats(}{it:info}{cmd:)} returns a row vector 
containing the number of panels, number of observations, minimum number of
observations per panel, and maximum number of observations per panel.

{p 4 4 2}
{cmd:panelsubmatrix(}{it:V}{cmd:,} {it:i}{cmd:,} {it:info}{cmd:)}
returns a matrix containing the contents of {it:V} for panel {it:i}.

{p 4 4 2}
{cmd:panelsubview(}{it:SV}{cmd:,} {it:V}{cmd:,} {it:i}{cmd:,}
{it:info}{cmd:)}
does nearly the same thing.  Rather than returning a matrix, however, it 
places the matrix in {it:SV}.  If {it:V} is a view, then the matrix placed
in {it:SV} will be a view.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 panelsetup()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Remarks are presented under the following headings:

	{help mf_panelsetup##remarks1:Definition of panel data}
	{help mf_panelsetup##remarks2:Definition of problem}
	{help mf_panelsetup##remarks3:Preparation}
	{help mf_panelsetup##remarks4:Use of panelsetup()}
	{help mf_panelsetup##remarks5:Use of panelstats()}
	{help mf_panelsetup##remarks6:Using panelsubmatrix()}
	{help mf_panelsetup##remarks7:Using panelsubview()}


{marker remarks1}{...}
{title:Definition of panel data}

{p 4 4 2}
Panel data include multiple observations on subjects, countries, etc.:

		Subject ID    "Time" ID       x1        x2
		{hline 43}
		      1           1          4.2       3.7
		      1           2          3.2       3.7
		      1           3          9.2       4.2

                      2           1          1.7       4.0
                      2           2          1.9       5.0

		      3           1          9.5       1.3
		      .           .           .         . 
		      .           .           .         . 
		{hline 43}

{p 4 4 2}
In the above dataset, there are three observations for subject 1, two for
subject 2, etc.  We labeled the identifier within subject to be time, but that
is only suggestive, and in any case, the secondary identifier will play no
role in what follows.

{p 4 4 2}
If we speak about the first panel, we are discussing the first 3 observations
of this dataset.  If we speak about the second, that corresponds to
observations 4 and 5.

{p 4 4 2}
It is common to refer to panel numbers with the letter {it:i}.  
It is common to refer to the number of observations in the {it:i}th panel
as {it:T}_{it:i} even when the data within panel have nothing to do with 
repeated observations over time.


{marker remarks2}{...}
{title:Definition of problem}

{p 4 4 2}
We want to calculate some statistic on panel data.
The calculation amounts to

                K
		Sum    {it:f}({it:X}_{it:i})
		i=1

{p 4 4 2}
where the sum is performed across panels, and {it:X}_{it:i} is the 
data matrix for panel {it:i}.  For instance, given the example in 
the previous section

			  {c TLC}{c -}        {c -}{c TRC}
			  {c |} 4.2  3.7 {c |}
		{it:X}_1  =    {c |} 3.2  3.7 {c |}
			  {c |} 9.2  4.2 {c |}
			  {c BLC}{c -}        {c -}{c BRC}

{p 4 4 2}
and {it:X}_{it:2} is a similarly constructed 2 {it:x} 2 matrix.

{p 4 4 2}
Depending on the nature of the calculation, there will be problems for
which 

{p 8 12 2}
    1.  we want to use all the panels,

{p 8 12 2}
    2.  we want to use only panels for which there are two or more 
        observations, and

{p 8 12 2}
    3.  we want to use the same number of observations in all the panels
        (balanced panels).

{p 4 4 2}
In addition to simple problems of the sort,

                K
		Sum    {it:f}({it:X}_{it:i})
		i=1

{p 4 4 2}
you may also need to deal with problems of the form,

                K
		Sum    {it:f}({it:X}_{it:i}, {it:Y}_{it:i}, ...)
		i=1

{p 4 4 2}
That is, you may need to deal with problems where there are multiple matrices
per subject.

{p 4 4 2}
We use the sum operator purely for illustration, although it is the most 
common.  Your problem might be 

		{it:F}({it:X}_1, {it:Y}_1, ..., {it:X}_2, {it:Y}_2, ..., ...)


{marker remarks3}{...}
{title:Preparation}

{p 4 4 2}
Before using the functions documented here, create a matrix or
matrices containing the data.  For illustration, it will be sufficient to 
create {it:V} containing all the data in our example problem: 


			 {c TLC}{c -}               {c -}{c TRC}
			 {c |}  1  2  4.2  3.7 {c |}
			 {c |}  1  2  3.2  3.7 {c |}
			 {c |}  1  3  9.2  4.2 {c |}
			 {c |}  2  1  1.7  4.0 {c |}
		{it:V}  =     {c |}  2  2  1.9  5.0 {c |}
			 {c |}  3  1  9.5  1.3 {c |}
			 {c |}  .  .   .    .  {c |}
			 {c |}  .  .   .    .  {c |}
			 {c BLC}{c -}               {c -}{c BRC}

{p 4 4 2}
But you will probably find it more convenient (and we recommend) if you 
create at least two matrices, one containing the subject identifier
and the other containing the {it:x} variables (and omit the within-subject
"time" identifier altogether):

                        {c TLC}{c -}   {c -}{c TRC}                 {c TLC}{c -}         {c -}{c TRC}
                        {c |}  1  {c |}                 {c |}  4.2  3.7 {c |}
                        {c |}  1  {c |}                 {c |}  3.2  3.7 {c |}
                        {c |}  1  {c |}                 {c |}  9.2  4.2 {c |}
                        {c |}  2  {c |}                 {c |}  1.7  4.0 {c |}
                 {it:V1}  =  {c |}  2  {c |}        {it:V2}  =    {c |}  1.9  5.0 {c |}
                        {c |}  3  {c |}                 {c |}  9.5  1.3 {c |}
                        {c |}  .  {c |}                 {c |}   .    .  {c |}
                        {c |}  .  {c |}                 {c |}   .    .  {c |}
                        {c BLC}{c -}   {c -}{c BRC}                 {c BLC}{c -}         {c -}{c BRC}

{p 4 4 2}
In the above, matrix {it:V1} contains the subject identifier, and 
matrix {it:V2} contains the data for all the {it:X}_{it:i} matrices in

                K
		Sum    {it:f}({it:X}_{it:i})
		i=1

{p 4 4 2}
If your calculation is 

                K
		Sum    {it:f}({it:X}_{it:i}, {it:Y}_{it:i}, ...)
		i=1

{p 4 4 2}
create additional {it:V} matrices, {it:V3} corresponding to {it:Y}_{it:i}, 
and so on.

{p 4 4 2}
To create these matrices, use {bf:{help mf_st_view:[M-5] st_view()}}


	{cmd:st_view(}{it:V1}{cmd:,  ., "idvar",      "}{it:touse}{cmd:")}

	{cmd:st_view(}{it:V2}{cmd:,  ., ("x1", "x2"), "}{it:touse}{cmd:")}

{p 4 4 2}
although you could use {bf:{help mf_st_data:[M-5] st_data()}} if 
you preferred.  Using {cmd:st_view()} will save memory.  
You can also construct {it:V1}, {it:V2}, ..., however you wish; they are just
matrices.  Be sure that the matrices align, for example, that row 4 of one
matrix corresponds to row 4 of another.  We did that above by assuming a
{it:touse} variable had been included (or constructed) in the dataset.


{marker remarks4}{...}
{title:Use of panelsetup()}

{p 4 4 2}
{cmd:panelsetup(}{it:V}{cmd:,} {it:idcol}{cmd:,} ...{cmd:)} sets up panel
processing, returning a {it:K} {it:x} 2 matrix that contains a row for each
panel.  The row records the first and last observation numbers (row numbers
in {it:V}) that correspond to the panel.  

{p 4 4 2}
For instance, with our example, {cmd:panelsetup()} will return 

                {c TLC}{c -}     {c -}{c TRC}
		{c |}  1  3 {c |}
		{c |}  4  5 {c |}
		{c |}  6  9 {c |}   
		{c |}  .  . {c |}
		{c |}  .  . {c |}
		{c |}  .  . {c |}
                {c BLC}{c -}     {c -}{c BRC}

{p 4 4 2}
The first panel is recorded in observations 1 to 3; it contains 3-1+1=3
observations.  The second panel is recorded in observations 4 to 5 and 
it contains 5-4+1=2 observations, and so on.  
We recorded the third panel as being observations 6 to 9, although we 
did not show you enough of the original data for you to know 
that 9 was the last observation with ID 3.

{p 4 4 2}
{cmd:panelsetup()} has many more capabilities in constructing this
result, but it is important to appreciate that returning this
observation-number matrix is all that {cmd:panelsetup()} does.  This matrix
is all that other panel functions need to know.  They work with the
information produced by {cmd:panelsetup()}, but they will equally well work
with any two-column matrix that contains observation numbers.
Correspondingly, {cmd:panelsetup()} engages in no secret behavior that ties up
memory, puts you in a mode, or anything else.  {cmd:panelsetup()} merely
produces this matrix.

{p 4 4 2}
The number of rows of the matrix {cmd:panelsetup()} returns equals {it:K}, the
number of panels.

{p 4 4 2}
The syntax of {cmd:panelsetup()} is 

{p 8 12 2}
{it:info} = 
{cmd:panelsetup(}{it:V}{cmd:,}
{it:idcol}{cmd:,}
{it:minobs}{cmd:,}
{it:maxobs}{cmd:)}

{p 4 4 2}
The last two arguments are optional.

{p 4 4 2}
The required argument {it:V} specifies a matrix containing 
at least the panel identification numbers and required argument {it:idcol}
specifies the column of {it:V} that contains that ID. Here 
we will use the matrix {it:V1}, which contains only the identification number:

	{it:info} = {cmd:panelsetup(}{it:V1}{cmd:,} {cmd:1)}

{p 4 4 2}
The two optional arguments are {it:minobs} and {it:maxobs}.  {it:minobs}
specifies the minimum number of observations within panel that we are willing 
to tolerate; if a panel has fewer observations, we want to omit it
entirely.  For instance, were we to specify 

	{it:info} = {cmd:panelsetup(}{it:V1}{cmd:,} {cmd:1, 3)}

{p 4 4 2}
then the matrix {cmd:panelsetup()} would contain 
fewer rows.  In our example, the returned {it:info} matrix 
would contain

                {c TLC}{c -}     {c -}{c TRC}
		{c |}  1  3 {c |}
		{c |}  6  9 {c |}
		{c |}  .  . {c |}
		{c |}  .  . {c |}
		{c |}  .  . {c |}
                {c BLC}{c -}     {c -}{c BRC}

{p 4 4 2}
Observations 4 and 5 are now omitted because they
correspond to a two-observation panel, and we said only panels with three or
more observations should be included.

{p 4 4 2}
We chose three as a demonstration.  In fact, it is most common to code 

	{it:info} = {cmd:panelsetup(}{it:V1}{cmd:,} {cmd:1, 2)}

{p 4 4 2}
because that eliminates the singletons (panels with one observation).

{p 4 4 2}
The final optional argument is {it:maxobs}.  For example, 

	{it:info} = {cmd:panelsetup(}{it:V1}{cmd:,} {cmd:1, 2, 5)}

{p 4 4 2}
means to include only up to five observations per panel.  Any observations
beyond five are to be trimmed.  If we code

	{it:info} = {cmd:panelsetup(}{it:V1}{cmd:,} {cmd:1, 3, 3)}

{p 4 4 2}
then all the panels contained in {it:info} would have three observations.
If a panel had fewer than three observations, it would be omitted entirely.
If a panel had more than three observations, only the first three would be 
included.

{p 4 4 2}
Panel datasets with the same number of observations per panel are said to be
balanced.  {it:panelsetup()} also provides panel-balancing capabilities.  If 
you specify {it:maxobs} as 0, then 

{p 8 12 2}
1.  {cmd:panelsetup()} first calculates the min(T_i) among the panels with 
    {it:minobs} observations or more.  Call that number {it:m}.

{p 8 12 2}
2.   {cmd:panelsetup()} then returns
     {cmd:panelsetup(}{it:V1}{cmd:,} {it:idcol}{cmd:,} {it:m}{cmd:,} {it:m}{cmd:)}, 
     thus creating balanced panels of size {it:m} and producing a 
     dataset that has the maximum number of within-panel observations 
     given it has the maximum number of panels.

{p 4 4 2}
If we coded

	{it:info} = {cmd:panelsetup(}{it:V1}{cmd:,} {cmd:1, 2, 0)}

{p 4 4 2}
then {cmd:panelsetup()} would 
create the maximum number of panels with the maximum number of within-panel
observations subject to the constraint of no singletons and the panels being
balanced.


{marker remarks5}{...}
{title:Using panelstats()}

{p 4 4 2}
{cmd:panelstats(}{it:info}{cmd:)} can be used on any two-column matrix that
contains observation numbers.  {cmd:panelstats()} returns a row vector
containing

		{cmd:panelstats()[1]} = number of panels (same as {cmd:rows(}{it:info}{cmd:)})
		{cmd:panelstats()[2]} = number of observations
		{cmd:panelstats()[3]} = min({it:T}_{it:i})
		{cmd:panelstats()[4]} = max({it:T}_{it:i})


{marker remarks6}{...}
{title:Using panelsubmatrix()}

{p 4 4 2}
Having created an {it:info} matrix using {cmd:panelsetup()}, you can 
obtain the matrix corresponding to the {it:i}th panel using 

		{it:X} = {cmd:panelsubmatrix(}{it:V}{cmd:,} {it:i}{cmd:,} {it:info}{cmd:)}

{p 4 4 2}
It is not necessary that {cmd:panelsubmatrix()} be used with the same 
matrix that was used to produce {it:info}.
We created matrix {it:V1} containing the ID numbers, and 
we created matrix {it:V2} containing the {it:x} variables

	{cmd:st_view(}{it:V1}{cmd:,  ., "idvar",      "}{it:touse}{cmd:")}

	{cmd:st_view(}{it:V2}{cmd:,  ., ("x1", "x2"), "}{it:touse}{cmd:")}

{p 4 4 2}
and we create {it:info} using {it:V1}:

	{it:info} = {cmd:panelsetup(}{it:V1}{cmd:,} {cmd:1)}

{p 4 4 2}
We can now create the corresponding {it:X} matrix by coding 

	{it:X} = {cmd:panelsubmatrix(}{it:V2}{cmd:,} {it:i}{cmd:,} {it:info}{cmd:)}

{p 4 4 2}
and, had we created a {it:V3} matrix corresponding to {it:Y}_{it:i}, we could
also code

	{it:Y} = {cmd:panelsubmatrix(}{it:V3}{cmd:,} {it:i}{cmd:,} {it:info}{cmd:)}

{p 4 4 2}
and so on.


{marker remarks7}{...}
{title:Using panelsubview()}

{p 4 4 2}
{cmd:panelsubview()} works much like {cmd:panelsubmatrix()}.  The 
difference is that rather than coding 

	{it:X} = {cmd:panelsubmatrix(}{it:V}{cmd:,} {it:i}{cmd:,} {it:info}{cmd:)}

{p 4 4 2}
you code

	{cmd:panelsubview(}{it:X}{cmd:,} {it:V}{cmd:,} {it:i}{cmd:,} {it:info}{cmd:)}

{p 4 4 2}
The matrix to be defined becomes the first argument of {cmd:panelsubview()}.
That is because {cmd:panelsubview()} is designed especially to work with
views.  {cmd:panelsubmatrix()} will work with views, but {cmd:panelsubview()}
does something special.  Rather than returning an ordinary matrix (an array,
in the jargon), if {it:V} is a view, {cmd:panelsubview()} returns a view
in its first argument.
Views save memory.

{p 4 4 2}
Views can save much memory, so it would seem that you would always 
want to use {cmd:panelsubview()} in place of {cmd:panelsubmatrix()}. 
What is not always appreciated, however, is that it takes Mata longer 
to access the data recorded in views, and so there is a tradeoff.

{p 4 4 2}
If the panels are likely to be large, you want to use {cmd:panelsubview()}.
Conserving memory trumps all other considerations.

{p 4 4 2}
In fact, the panels that occur in most datasets are not that large, even 
when the dataset itself is.  If you are going to make many 
calculations on {it:X}, you may wish to use {cmd:panelsubmatrix()}.

{p 4 4 2}
Both {cmd:panelsubmatrix()} and {cmd:panelsubview()} 
work with view and nonview matrices.  {cmd:panelsubview()} produces a 
regular matrix when the base matrix {it:V} is not a view, just as does 
{cmd:panelsubmatrix()}.  The difference is that {cmd:panelsubview()}
will produce a view when {it:V} is a view, whereas {cmd:panelsubmatrix()} 
always produces a nonview matrix.


{marker conformability}{...}
{title:Conformability}

{p 4 4 2}
{cmd:panelsetup(}{it:V}{cmd:,} 
{it:idcol}{cmd:,} 
{it:minobs}{cmd:,} 
{it:maxobs}{cmd:)}:
{p_end}
		{it:V}:  {it:r x c}
	    {it:idcol}:  1 {it:x} 1
	   {it:minobs}:  1 {it:x} 1    (optional)
	   {it:maxobs}:  1 {it:x} 1    (optional)
	   {it:result}:  {it:K x} 2, {it:K} = number of panels

    {cmd:panelstats(}{it:info}{cmd:)}:
	     {it:info}:  {it:K x} 2
	   {it:result}:  1 {it:x} 4

    {cmd:panelsubmatrix(}{it:V}{cmd:,} {it:i}{cmd:,} {it:info}{cmd:)}:
		{it:V}:  {it:r x c}
		{it:i}:  1 {it:x} 1, 1 <= {it:i} <= {cmd:rows(}{it:info}{cmd:)}
	     {it:info}:  {it:K x} 2
	   {it:result}:  {it:t x c}, {it:t} = number of obs. in panel

    {cmd:panelsubview(}{it:SV}{cmd:,} {it:V}{cmd:,} {it:i}{cmd:,} {it:info}{cmd:)}:
	{it:input:}
	       {it:SV}:  irrelevant
		{it:V}:  {it:r x c}
		{it:i}:  1 {it:x} 1, 1 <= {it:i} <= {cmd:rows(}{it:info}{cmd:)}
	     {it:info}:  {it:K x} 2
	   {it:result}:  {it:t x c}, {it:t} = number of obs. in panel
	{it:output:}
	       {it:SV}:  {it:t x c}, {it:t} = number of obs. in panel


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
{cmd:panelsubmatrix(}{it:V}{cmd:,} {it:i}{cmd:,} {it:info}{cmd:)}
and
{cmd:panelsubview(}{it:SV}{cmd:,} {it:V}{cmd:,} {it:i}{cmd:,} {it:info}{cmd:)}
abort with error if {it:i}<1 or {it:i}>{cmd:rows(}{it:info}{cmd:)}.

{p 4 4 2}
{cmd:panelsetup()} can return a 0 {it:x} 2 result.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view panelsetup.mata, adopath asis:panelsetup.mata},
{view panelstats.mata, adopath asis:panelstats.mata},
{view panelsubmatrix.mata, adopath asis:panelsubmatrix.mata},
{view panelsubview.mata, adopath asis:panelsubview.mata}
{p_end}
