{smcl}
{* *! version 1.2.7  19sep2018}{...}
{vieweralsosee "[D] putmata" "mansection D putmata"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Stata" "help m4_stata"}{...}
{vieweralsosee "[M-5] st_data()" "help mf_st_data"}{...}
{vieweralsosee "[M-5] st_store()" "help mf_st_store"}{...}
{vieweralsosee "[M-5] st_view()" "help mf_st_view"}{...}
{viewerjumpto "Syntax" "putmata##syntax"}{...}
{viewerjumpto "Description" "putmata##description"}{...}
{viewerjumpto "Links to PDF documentation" "putmata##linkspdf"}{...}
{viewerjumpto "Options for putmata" "putmata##options_putmata"}{...}
{viewerjumpto "Options for getmata" "putmata##options_getmata"}{...}
{viewerjumpto "Remarks" "putmata##remarks"}{...}
{viewerjumpto "Stored results" "putmata##results"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[D] putmata} {hline 2}}Put Stata variables into Mata and vice versa
{p_end}
{p2col:}({mansection D putmata:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{cmd:putmata}
{it:putlist}
{ifin}
[{cmd:,}
{it:{help putmata##putmata_options:putmata_options}}]


{p 8 12 2}
{cmd:getmata}
{it:getlist}
[{cmd:,}
{it:{help putmata##getmata_options:getmata_options}}]


{marker putmata_options}{...}
{synoptset 16}{...}
{synopthdr:putmata_options}
{synoptline}
{synopt:{opt omit:missing}}omit observations with missing values{p_end}
{synopt:{opt view}}create vectors and matrices as views, not as copies{p_end}
{synopt:{opt replace}}replace existing Mata vectors and matrices{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
A {it:putlist} can be as simple as a list of Stata variable names.  See 
{help putmata##putlist:below} for details.


{marker getmata_options}{...}
{synoptset 16}{...}
{synopthdr:getmata_options}
{synoptline}
{synopt:{opt double}}create Stata variables as {cmd:double}s{p_end}
{synopt:{opt up:date}}update existing Stata variables{p_end}
{synopt:{opt replace}}replace existing Stata variables{p_end}
{synopt:{opt id(name)}}match observations with rows based on equal values
        of variable {it:name} and matrix {it:name};
	{cmd:id(}{varname}{cmd:=}{it:vecname}{cmd:)} is also allowed{p_end}
{synopt:{opt force}}allow nonconformable matrices; usually,
            {cmd:id()} is preferable{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}
A {it:getlist} can be as simple as a list of Mata vector names.
See {help putmata##getlist:below} for details.


{marker putlist}{...}
{p 4 4 2}
Definition of {it:putlist} for use with {cmd:putmata}:

{p 8 8 2}
A {it:putlist} is one or more of any of the following:

	    {cmd:*}
	    {it:varname}
	    {it:varlist}
	    {it:vecname}{cmd:=}{it:varname}
	    {it:matname}{cmd:=(}{it:varlist}{cmd:)}
	    {it:matname}{cmd:=(}[{it:varlist}] {it:#} [{it:varlist}] [...]{cmd:)}

{marker putmata_examples}{...}
{p 8 8 2}
Example:  {cmd:putmata *}
{p_end}
{p 12 12 2}
    Creates a vector in Mata for each of the Stata variables in memory.
    Vectors contain the same data as Stata variables.
    Vectors have the same names as the corresponding variables.  
    
{p 8 8 2}
Example:  {cmd:putmata mpg weight displ}
{p_end}
{p 12 12 2}
    Creates a vector in Mata for each variable specified.
    Vectors have the same names as the corresponding variables.  
    In this example, {cmd:displ} is an abbreviation for the variable 
    {cmd:displacement}; thus the vector will also be named 
    {cmd:displacement}.
     
{p 8 8 2}
Example:  {cmd:putmata mileage=mpg pounds=weight}
{p_end}
{p 12 12 2}
    Creates a vector for each variable specified.  Vector names differ
    from the corresponding variable names.  In this example, 
    vectors will be named {cmd:mileage} and {cmd:pounds}.

{p 8 8 2}
Example:  {cmd:putmata y=mpg X=(weight displ)}
{p_end}
{p 12 12 2}
Creates {it:N} x 1 Mata vector {cmd:y} equal to Stata variable
{cmd:mpg}, and creates {it:N} x 2 Mata matrix {cmd:X} containing the
values of Stata variables {cmd:weight} and {cmd:displacement}.

{p 8 8 2}
Example:  {cmd:putmata y=mpg X=(weight displ 1)}
{p_end}
{p 12 12 2}
Creates {it:N} x 1 Mata vector {cmd:y} containing {cmd:mpg}, and 
creates {it:N} x 3 Mata matrix {cmd:X} containing {cmd:weight},
{cmd:displacement}, and a column of 1s.  
After typing this example, you could enter Mata and type 
{cmd:invsym(X'X)*X'y} to obtain the regression coefficients.

{p 4 4 2}
Syntactical elements may be combined.  It is valid to type 

{p 12 12 2}
. {cmd:putmata mpg foreign X=(weight displ) Z=(foreign 1)}

{p 4 4 2}
    No matter how you specify the {it:putlist}, you will need to specify
    the {cmd:replace} option if some or all vectors already exist in Mata:

{p 12 12 2}
. {cmd:putmata mpg foreign X=(weight displ) Z=(foreign 1), replace}


{marker getlist}{...}
{p 4 4 2}
Definition of {it:getlist} for use with {cmd:getmata}:

{p 8 8 2}
A {it:getlist} is one or more of any of the following:

	    {it:vecname}
	    {it:varname}{cmd:=}{it:vecname}
	    {cmd:(}{it:varname varname ... varname}{cmd:)=}{it:matname}
            {cmd:(}{it:varname}{cmd:*)=}{it:matname}

{marker getmata_examples}{...}
{p 8 8 2}
Example:  {cmd:getmata x1 x2}
{p_end}
{p 12 12 2}
    Creates a Stata variable for each Mata vector specified.  Variables will
    have the same names as the corresponding vectors.  Names may not be
    abbreviated.

{p 8 8 2}
Example:  {cmd:getmata myvar1=x1 myvar2=x2}
{p_end}
{p 12 12 2}
    Creates a Stata variable for each Mata vector specified.  Variable names
    will differ from the corresponding vector names.

{p 8 8 2}
Example:  {cmd:getmata (firstvar secondvar)=X}
{p_end}
{p 12 12 2}
    Creates one Stata variable corresponding to each column 
    of the Mata matrix specified.  In this case, the matrix has two columns, and
    corresponding variables will be named {cmd:firstvar} and {cmd:secondvar}.
    If the matrix had three columns, then three variable names would need to
    be specified.

{p 8 8 2}
Example:  {cmd:getmata (myvar*)=X}
{p_end}
{p 12 12 2}
    Creates one Stata variable corresponding to each column 
    of the Mata matrix specified. Variables will be named
    {cmd:myvar1}, {cmd:myvar2}, etc.  
    The matrix may have any number of columns, even zero!

{p 4 4 2}
    Syntactical elements may be combined.  It is valid to type

{p 12 12 2}
. {cmd:getmata r1 r2 final=r3 (rplus*)=X}
     
{p 4 4 2}
    No matter how you specify the {it:getlist}, you will need to specify
    the {cmd:replace} or {cmd:update} option if some or all variables already 
    exist in Stata:

{p 12 12 2}
. {cmd:getmata r1 r2 final=r3 (rplus*=)X, replace}


{marker description}{...}
{title:Description}

{p 4 4 2}
{cmd:putmata} exports the contents of Stata variables to Mata 
vectors and matrices. 

{p 4 4 2}
{cmd:getmata} imports the contents of Mata vectors and matrices 
to Stata variables.

{p 4 4 2}
{cmd:putmata} and {cmd:getmata} are useful for creating solutions to problems
more easily solved in Mata.  The commands are also useful in teaching.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D putmataQuickstart:Quick start}

        {mansection D putmataRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options_putmata}{...}
{title:Options for putmata}

{p 4 8 2}
{cmd:omitmissing}
    specifies that observations containing a missing value in any of the 
    numeric variables specified be omitted from the vectors and matrices
    created in Mata.  In

{col 12}. {cmd:putmata y=mpg X=(weight displ 1), omitmissing}

{p 8 8 2}
    rows would be omitted from {cmd:y} and {cmd:X} in which the corresponding
    observation contained missing in any of {cmd:mpg}, {cmd:weight}, or
    {cmd:displ}.  In this case, specifying {cmd:omitmissing} would be
    equivalent to typing

{phang3}. {cmd:putmata y=mpg X=(weight displ 1) if !missing(mpg) & !missing(weight) & !missing(displ)}

{p 8 8 2}
    All vectors and matrices created by a single {cmd:putmata}
    command will have the same number of rows (observations).
    That is true whether you specify {cmd:if}, {cmd:in}, or the 
    {cmd:omitmissing} option.  

{p 4 8 2}
{cmd:view} 
    specifies that {cmd:putmata} create views rather than copies of the
    Stata data in the Mata vectors and matrices.  Views require less memory
    than copies and offer the advantage (and disadvantage) that changes in the
    Stata data are immediately reflected in the Mata vectors and matrices, and
    vice versa.

{p 8 8 2}
    If you specify numeric constants using the {it:matname}{cmd:=(}...{cmd:)}
    syntax, {it:matname} is created as a copy even if the {cmd:view} 
    option is specified.  Other vectors and matrices created by the  
    command, however, would be views.

{p 8 8 2}
    Use of the {cmd:view} option with {cmd:putmata} often obviates the 
    need to use {cmd:getmata} to import results back into Stata.

{p 8 8 2}
    Warning 1:  Mata records views as "this vector is a
    view onto variable 3, observations 2 through 5 and 7".  If you change the
    order of the variables, the order of the observations, or drop variables
    once the views are created, then the contents of the views will change.

{p 8 8 2}
    Warning 2:  When assigning values in Mata to view vectors, code

		{cmd:v[]} = ...

{p 8 8 2}
    not {cmd:v} = ....

{p 8 8 2}
    To have changes reflected in the underlying Stata data, you 
    must update the elements of the view {cmd:v}, not redefine it.
    To update all the elements of {cmd:v}, you literally code 
    {cmd:v[.]}.  In the matrix 
    case, you code {cmd:X[.,.]}.

{p 4 8 2}
{cmd:replace}
    specifies that existing Mata vectors or
    matrices be replaced should that be necessary.


{marker options_getmata}{...}
{title:Options for getmata}

{p 4 8 2}
{cmd:double} 
    specifies that Stata numeric variables be created as 
    {bf:{help data_types:double}}s.  The default is that they be created as
    {bf:{help data_types:float}}s.  Actually, variables start out as 
    {bf:float}s or {cmd:double}s, but then they are 
    {help compress:compressed}.

{p 4 8 2}
{cmd:update} and {cmd:replace} are alternatives.
    They have the same meaning unless the {cmd:id()} or {cmd:force}
    option is specified.

{p 8 8 2}
    When {cmd:id()} or {cmd:force} is not specified, 
    both {cmd:replace} and {cmd:update} specify that it is okay to replace 
    the values in existing Stata variables.  By default, 
    vectors can be posted to new Stata variables only.

{p 8 8 2}
    When {cmd:id()} or {cmd:force} is specified, 
    {cmd:replace} and {cmd:update} 
    allow posting of values of existing variables, just 
    as usual.  The options differ in how the posting is 
    performed when the {cmd:id()} or {cmd:force} option causes
    only a subset of the observations of the variables to be updated.  
    {cmd:update} specifies that the remaining values be 
    left as they are.  {cmd:replace} specifies that the remaining 
    values be set to missing, just as if the existing variable(s) were
    being created for the first time.
    
{p 4 8 2}
{cmd:id(}{it:name}{cmd:)} and {cmd:id(}{varname}{cmd:=}{it:vecname}{cmd:)}
    specify how the rows in the Mata vectors and matrices match the
    observations in the Stata data.  Observation {it:i} matches row {it:j} if
    variable {it:name}[{it:i}] equals vector {it:name}[{it:j}], or 
    in the second syntax, if 
    {it:varname}[{it:i}]={it:vecname}[{it:j}].  The
    ID variable (vector) must contain values that uniquely
    identify the observations (rows).  Only in observations that contain
    matching values will the variable be modified.  Values in observations 
    that have no match will not be modified or will be set to missing, as
    appropriate; values in the ID vector that have no match will be ignored.

{p 8 8 2}
    Example:  You wish to run a regression of {cmd:y} on {cmd:x1} and {cmd:x2}
    on the males in the data and use that result to obtain the fitted
    values for the males.  Stata already has commands that will do this,
    namely,
    {cmd:regress y x1 x2 if male} followed by 
    {cmd:predict yhat if male}.
    For instructional purposes, let's say you wish to do this in Mata.  You type

	    . {cmd:putmata  myid  y  X=(x1 x2 1)  if male}

	    . {cmd:mata}
	    : {cmd:b = invsym(X'X)*X'y}
	    : {cmd:yhat = X*b}
	    : {cmd:end}

	    . {cmd:getmata yhat, id(myid)}

{p 8 8 2}
    The new Stata variable {cmd:yhat} will contain the predicted values for males
    and missing values for the females.  If the {cmd:yhat} variable already
    existed, you would type

	    . {cmd:getmata yhat, id(myid) replace}

{p 8 8 2}
    or 

	    . {cmd:getmata yhat, id(myid) update}

{p 8 8 2}
    The {cmd:replace} option would set the female observations to missing.
    The
    {cmd:update} option would leave the female observations unchanged.

{p 8 8 2}
    If you do not have an identification variable, create one first by typing
    {cmd:generate} {cmd:myid} {cmd:=} {cmd:_n}.

{p 4 8 2}
{cmd:force}
    specifies that it is okay to post vectors and matrices with fewer 
    or with more rows than the number of observations in the data.
    The {cmd:force} option is an alternative to {cmd:id()}, and usually, 
    {cmd:id()} is the appropriate choice.

{p 8 8 2}
    If you specify {cmd:force} and if there are fewer rows in the 
    vectors and matrices than observations in the data, new variables will be
    padded with missing values. 
    If there are more rows than
    observations, observations will be added to the data and previously
    existing variables will be padded with missing values.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Remarks are presented under the following headings:

	{help putmata##basic1:Use of putmata}
	{help putmata##basic2:Use of putmata and getmata}
	{help putmata##subset:Using putmata and getmata on subsets of observations}
	{help putmata##views:Using views}
	{help putmata##dofiles:Constructing do-files}


{marker basic1}{...}
{title:Use of putmata}

{p 4 4 2}
In this example, we will use Mata to make a calculation and report the result,
but we will not post results back to Stata.  We will use {cmd:putmata} but not
{cmd:getmata}.

{p 4 4 2}
Consider solving for {bf:b} the set of linear equations 

		{bf:y} = {bf:X}{bf:b}{right:(1)    }

{p 4 4 2}
where {bf:y}: {it:N} x 1, {bf:X}: {it:N} x {it:k}, and {bf:b}: {it:k}
x 1.  If {it:N} = {it:k}, then {bf:y} = {bf:X}{bf:b} amounts to solving
{it:k} equations for {it:k} unknowns, and the solution is

                     -1
		{bf:b} = {bf:X}  {bf:y}{right:(2)    }

{p 4 4 2}
That solution is obtained by premultiplying both sides of equation (1) by
{bf:X}^(-1).

{p 4 4 2}
When {it:N} > {it:k}, equation (2) can be used to obtain least-square results if
matrix inversion is appropriately defined.  Assume that you wish to demonstrate
this when matrix inversion is defined as the Moore-Penrose generalized inverse
for nonsquare matrices.  The demonstration can be obtained by typing

	. {cmd:sysuse auto, clear}

	. {cmd:regress mpg weight displacement}

	. {cmd:putmata y=mpg X=(weight displacement 1)}

	. {cmd:mata}
	: {cmd:pinv(X)*y}
	: {cmd:end}

	. _

{p 4 4 2}
The Mata expression {cmd:pinv(X)*y} will display a 3 x 1 column vector.
The elements of the vector will equal the coefficients reported by
{cmd:regress} {cmd:mpg} {cmd:weight} {cmd:displacement}.

{p 4 4 2}
For your information, the Moore-Penrose inverse of rectangular matrix {bf:X}:
{it: N} x {it:k} is a {it:k} x {it:N} rectangular matrix.  Among
other properties, {cmd:pinv(}{bf:X}{cmd:)}{cmd:*}{bf:X} = {bf:I}, where {bf:I}
is the {it:k} x {it:k} identity matrix.  You can demonstrate that using Mata,
too:

	. {cmd:mata: pinv(X)*X}


{marker basic2}{...}
{title:Use of putmata and getmata}

{p 4 4 2}
In this example, we will use Mata to calculate a result that we 
wish to post back to Stata.  We will use both {cmd:putmata} and {cmd:getmata}.

{p 4 4 2}
Some problems are more easily solved in Mata than in Stata.  For
instance, say that you need to create new Stata variable {cmd:D} from existing variable
{cmd:C}, defined as

		{cmd:D}[{it:i}] = sum({cmd:C}[{it:j}] - {cmd:C}[{it:i}]) for all {cmd:C}[{it:j}]>{cmd:C}[{it:i}]

{p 4 4 2}
where {it:i} and {it:j} index observations.

{p 4 4 2}
This problem can be solved in Stata, but the solution is elusive to most
people.  The solution is more natural in Mata because the Mata solution
corresponds almost letter for letter with the mathematical statement of the
problem.  If {cmd:C} and {cmd:D} were Mata vectors rather than Stata
variables, the solution would be

	{cmd}D = J(rows(C), 1, 0)
	for (i=1; i<=rows(C); i++) {c -(}
		for (j=1; j<=rows(C); j++) {c -(}
			if (C[j]>C[i]) D[i] = D[i] + (C[j] - C[i])
		{c )-}
	{c )-}{txt}

{p 4 4 2}
The most difficult part of this solution to understand is the first line,
{cmd:D} {cmd:=} {cmd:J(rows(C), 1, 0)}, and that is because you may not
be familiar with Mata's {cmd:J()} function.  {cmd:D} {cmd:=} 
{cmd:J(rows(C), 1, 0)} creates a {cmd:rows(C)} x 1 column vector of
0s.  The arguments of {cmd:J()} are in just that order.

{p 4 4 2}
{cmd:C} and {cmd:D} are not vectors in Mata, or at least they are not yet.
Using {cmd:getmata}, we can create vector {cmd:C} from variable {cmd:C} and run
our Mata solution.  Then using {cmd:putmata}, we can post Mata vector
{cmd:D} back to new Stata variable {cmd:D}.  The solution includes these
three steps, also shown in the do-file below:

{p 8 12 2}
    (1)  In Stata, use {cmd:putmata} to create vector {cmd:C} in Mata equal
        to variable {cmd:C} in Stata:  {cmd:putmata C}.

{p 8 12 2}
    (2)  Use Mata to solve the problem, creating new Mata vector {cmd:D}.

{p 8 12 2}
    (3)  In Stata again, use {cmd:getmata} to create new variable {cmd:D} equal
        to Mata vector {cmd:D}.

{p 4 4 2}
Because of the typing involved in the solution, we would package the code 
in a do-file:

	{hline 50} {cmd:myfile.do} {hline 3}{cmd}
	use mydata, clear 
	putmata C{col 69}{txt:(1)}

	mata:{col 69}{txt:(2)}
	D = J(rows(C), 1, 0)
	for (i=1; i<=rows(C); i++) {c -(}
	        for (j=1; j<=rows(C); j++) {c -(}
	                if (C[j]>C[i]) D[i] = D[i] + (C[j] - C[i])
	        {c )-}
	{c )-}
	end

	getmata D{col 69}{txt:(3)}
	save mydata, replace{txt}
	{hline 50} {cmd:myfile.do} {hline 3}

{p 4 4 2}
With {cmd:myfile.do} now in place, in Stata we would type

	. {cmd:do myfile}

{pstd}
Notes:

{p 4 8 2}
(1)
    Our program might be better if we changed {cmd:putmata} {cmd:C} to read
    {cmd:putmata} {cmd:C,} {cmd:replace} and if we changed {cmd:getmata}
    {cmd:D} to read {cmd:getmata} {cmd:D,} {cmd:replace}.  As things are
    right now, typing {cmd:do} {cmd:myfile} works, but if we were then to run
    it a second time, it would not work.  Stata would encounter the
    {cmd:putmata} command and issue an error that matrix {cmd:C}
    already exists.  Even if Stata got through that, it would encounter the
    {cmd:getmata} command and issue an error that variable
    {cmd:D} already exists.  Perhaps that is an advantage.  You cannot run
    {cmd:myfile.do} again without dropping matrix {cmd:C} and variable {cmd:D}.  If
    you consider that a disadvantage, however, include the {cmd:replace}
    option.

{p 4 8 2}
(2) 
    In our solution, we entered Mata by typing {cmd:mata:}, which is to say,
    {cmd:mata} with a colon.  Interactively, we usually enter Mata by just
    typing {cmd:mata}.  The colon affects how Mata treats errors.  When working
    interactively, we want Mata to note errors but then to continue running so
    we can correct ourselves.  In do-files, we want Mata to note the error and
    stop.  That is the difference between {cmd:mata} without the colon and
    {cmd:mata} with the colon.  Remember to use {cmd:mata:} when writing
    do-files.

{p 4 8 2}
(3)
    Rather than specify the {cmd:replace} option, you could modify the 
    do-file to drop any preexisting 
    Mata vector {cmd:C} and any preexisting variable {cmd:D}. 
    To drop vector {cmd:C}, in Mata you can type  
    {cmd:mata drop C}, or in Stata, you can type 
    {cmd:mata: mata drop C}.
    To drop variable {cmd:D}, in Stata you can type {cmd:drop} {cmd:D}.
    You must worry that the variables do not exist, so in your do-file, 
    you would code 

		{cmd:capture mata: mata drop C}
		{cmd:capture drop D}

{p 8 8 2}
    Rather than dropping vector {cmd:C}, you might prefer just to clear Mata:

		{cmd:clear mata}


{marker subset}{...}
{title:Using putmata and getmata on subsets of observations}

{p 4 4 2}
{cmd:putmata} can be used to create Mata vectors
that contain a subset of the observations in the Stata data, and 
{cmd:getmata} can be used to fetch such vectors back into Stata. 
Thus you can work with only the males or only outcomes in which 
failures are observed, and so on.  Below we work with only the 
observations in which {cmd:C} does not contain missing 
values.

{p 4 4 2}
In the create-variable-{cmd:D}-from-{cmd:C} example above, we assumed that
there were no missing values in {cmd:C}, or at least we did not consider the
issue.  It turns out that our code produces several missing values in the
presence of just one missing value in {cmd:C}.  Perhaps, if there are missing
values, we want to exclude them from our calculation.  We could complicate our
Mata code to handle that.  We could modify our Mata code to read 

	{cmd}use mydata, clear 
	putmata C

	D = J(rows(C), 1, 0)
	for (i=1; i<=rows(C); i++) {c -(}
		if (C[i]>=.) D[i] = .               {txt}{it:// new}{cmd}
		else for (j=1; j<=rows(C); j++) {c -(}
			if (C[j]<.) {c -(}               {txt}{it:// new}{cmd}
	               		if (C[j]>C[i]) D[i] = D[i] + (C[j] - C[i])
			{c )-}
	       	{c )-}
	{c )-}
	end

	getmata D
	save mydata, replace{txt}

{p 4 4 2}
Easier, however, is simply to restrict Mata vector {cmd:C} to the nonmissing
elements of Stata variable {cmd:C}, which we could do by replacing
{cmd:putmata} {cmd:C} with

	{cmd:putmata C if !missing(C)}

{p 4 4 2}
or, equivalently,

	{cmd:putmata C, omitmissing}

{p 4 4 2}
Whichever way we coded it, if the data contained 100 observations and variable
{cmd:C} contained 82 nonmissing values, new Mata vector {cmd:C} would contain
82 rows rather than 100.  The observations corresponding to {cmd:missing(C)}
would be omitted from the vector, and that means we could run our original Mata
solution without modification.

{p 4 4 2}
There is, however, an issue.  At the end of our code when we post the Mata
solution vector {cmd:D} to Stata variable {cmd:D} -- {cmd:getmata D} -- we
will need to specify which of the 100 observations are to receive the 82
results stored in the vector.  
{cmd:getmata} has an option to handle this situation -- 
{cmd:id(}{it:varname}{cmd:)}, where {it:varname} is the name of 
an identification variable.  

{p 4 4 2}
An identification variable is a variable that takes on different values for
each observation in the data.  The values could be 1, 2, ..., 100; or they
could be 1.25, -2, ..., 16.5; or they could be Nick, Bill, ..., Mary.
The values can be numeric or string, and they need not be in order.
All that is important is that the variable contain a unique (different) 
value in each observation.  Possibly, the data already contain such a
variable.  If not, you can create one by typing 

        {cmd:generate fid = _n}

{p 4 4 2}
When we use {cmd:putmata} to create vector {cmd:C}, we will need
simultaneously to create vector {cmd:fid} containing the selected values of
variable {cmd:fid}, which we can do by adding {cmd:fid} to the {it:putlist}:

	{cmd:putmata fid C if !missing(C)}

{p 4 4 2}
The above command creates two vectors in Mata:  {cmd:fid} and {cmd:C}.
When we post the resulting vector {cmd:D} back to Stata, we will specify 
the {cmd:id(fid)} option to indicate into which observations {cmd:getmata} 
is to post the results:

	{cmd:getmata D, id(fid)}

{p 4 4 2}
The {cmd:id(fid)} option is taken to mean that there exists a variable named
{cmd:fid} and a vector named {cmd:fid}.  It is by comparing the values in each
that {cmd:getmata} determines how the rows of the vectors correspond 
to the observations of the data. 

{p 4 4 2}
The entire solution is 

	{hline 50} {cmd:myfile.do} {hline 3}{cmd}
	use mydata, clear 
	putmata fid C if !missing(C) {txt}// {it:new: we add fid & if !missing(C)}

	{cmd}mata:
	D = J(rows(C), 1, 0)
	for (i=1; i<=rows(C); i++) {c -(}
	        for (j=1; j<=rows(C); j++) {c -(}
	                if (C[j]>C[i]) D[i] = D[i] + (C[j] - C[i])
	        {c )-}
	{c )-}
	end

	getmata D, id(fid)          {txt}// {it:new: we add option id(fid)}
	{cmd}save mydata, replace{txt}
	{hline 50} {cmd:myfile.do} {hline 3}

{p 4 4 2}
The above code will run on data with or without missing values.  New variable
{cmd:D} will be missing in observations where {cmd:C} is missing, but 
{cmd:D} will otherwise contain nonmissing values.


{marker views}{...}
{title:Using views}

{p 4 4 2}
When you type or code {cmd:putmata} {cmd:C}, vector {cmd:C} is created as a
copy of the Stata data.  The variable and the vector are separate things.  An
alternative is to make the Mata vector a view onto the Stata variable.  By
that, we mean that both the variable and the vector share the same recording
of the values.  Views save memory but are slightly less efficient in terms of
execution time.  Views have other advantages and disadvantages, too.

{p 4 4 2}
For instance, 
if you type {cmd:putmata} {cmd:mpg} and then, in Mata, type {cmd:mpg[1]=20},
you will change not only the Mata vector but also the Stata data!  Or if,
after typing {cmd:putmata} {cmd:mpg}, you typed {cmd:replace} {cmd:mpg}
{cmd:=} {cmd:20} {cmd:in} {cmd:1}, that would modify both the data and the
Mata vector!  This is an advantage if you are fixing real errors and a
disadvantage if intend to do something else.

{p 4 4 2}
If in the middle of your Mata session where you are working with views you take
a break and return to Stata, it is important that you do not modify the Stata
data in certain ways.  Rather than recording copies of the data, views record
notes about the mapping.  A view might record that this Mata vector corresponds
to variable 3, observations 2 through 20 and 39.  If you change the sort order
of the data, the view will still be working with observations 2 through 20 and
39 even though those physical observations now contain different data.  If you
drop the first or second variable, the view will still be working with the
third variable even though that will now be a different variable!  

{p 4 4 2}
The memory savings offered by views are considerable, at least when working 
with large datasets.  Say that you have a dataset containing 200 variables and
1,000,000 observations.  Your data might be 1 GB in size.  Even so,
typing {cmd:putmata *, view}, and thus creating 200 vectors each with 1,000,000
rows, would consume only a few dozen kilobytes of memory.

{p 4 4 2}
All the examples shown above work equally well with copies or views. 
We have been working with copies, but 
in the previous example, where we coded

	{cmd:putmata fid C if !missing(C)}

{p 4 4 2}
we could switch to working with views by coding

	{cmd:putmata fid C if !missing(C), view}

{p 4 4 2}
With that one change, our code would still work and it would use less 
memory.

{p 4 4 2}
With that one change, we would still not be working with views everywhere we
could, however.  Vector {cmd:D} -- the vector we create in Mata and then post
back to Stata -- would still be a regular vector.  We can save additional
memory by making {cmd:D} a view, too.  Before we do that, let us warn you that
we do not recommend doing this unless the memory savings is vitally
important.  The result, when complete, will be elegant and memory efficient, 
but the extra memory savings is seldom worth the debugging effort.

{p 4 4 2}
No extra changes are required to your code when the vectors 
you make into views contain values that are not modified in the
code.  Vector {cmd:C} is such a vector.  We use the values stored in {cmd:C},
but we do not change them.  Vector {cmd:D}, on the other hand, is a vector in
which we change values.  It is usually easier if you do not convert such 
vectors into views.

{p 4 4 2}
With that proviso, we are going to make {cmd:D} into a view, too, and in the
process, we will drop the use of {cmd:fid} altogether:

	{hline 50} {cmd:myfile.do} {hline 3}{cmd}
	use mydata, clear 
	generate D = .               {txt}     // {it:new}
	{cmd}putmata C D if !missing(C), view  {txt}// {it:changed}

	{cmd}mata:
	D[.] = J(rows(C), 1, 0)      {txt}     // {it:changed}
	{cmd}for (i=1; i<=rows(C); i++) {c -(}
	        for (j=1; j<=rows(C); j++) {c -(}
	                if (C[j]>C[i]) D[i] = D[i] + (C[j] - C[i])
	        {c )-}
	{c )-}
	end

	                            {txt}     // {it:we drop the getmata}
	{cmd}save mydata, replace{txt}
	{hline 50} {cmd:myfile.do} {hline 3}

{p 4 4 2}
In this solution, we create new Stata variable {cmd:D} at the outset, and then
we modify the {cmd:putmata} command to create view vectors for both {cmd:C}
and {cmd:D}.  Our code, which stores results in vector {cmd:D}, now
simultaneously posts to variable {cmd:D} when we store results in vector
{cmd:D}, so we can omit the {cmd:getmata} {cmd:D} at the end because results
are already posted!  Moreover, we no longer have to concern ourselves with
matching observations to rows via {cmd:fid}.  Rows of {cmd:D} now
automatically align themselves with the selected observations in variable
{cmd:D} by the mere fact of {cmd:D} being a view.

{p 4 4 2}
The beginning of our Mata code has an important change, however. 
We change

	{cmd:D = J(rows(C), 1, 0)}

{p 4 4 2}
to

	{cmd:D[.] = J(rows(C), 1, 0)}

{p 4 4 2}
That change is very important.  What we coded previously created vector
{cmd:D}.  What we now code changes the values stored in existing vector
{cmd:D}.  If we left what we coded previously, Mata would discard the view
currently stored in {cmd:D} and create a new {cmd:D} -- a regular Mata vector
unconnected to Stata -- containing 0s.


{marker dofiles}{...}
{title:Constructing do-files}

{p 4 4 2}
{cmd:putmata} and {cmd:getmata} can be used interactively, but if you have
much Mata code between the put and the get, you will be better off using a
do-file because do-files can be easily edited when they
have a mistake in them.  We recommend the following outline for such do-files:

	{hline 49} {cmd:outline.do} {hline 3}{cmd}
	version 13{col 57}{txt:(1)}

	mata clear{col 57}{txt:(2)}

	// {txt:{it:Stata code for setup goes here}{col 57}{txt:(3)}}

	putmata {it:...{col 57}}{txt:(4)}

	mata:
	// {txt:{it:Mata code goes here}{col 57}{txt:(5)}}
	end

	getmata {it:...}{col 57}{txt:(6)}

	mata clear{col 57}{txt:(7)}{txt}
	{hline 49} {cmd:outline.do} {hline 3}

{p 4 4 2}
Notes on do-file steps:

{p 8 12 2}
    (1)  A do-file should always start with a {cmd:version} statement; 
        it ensures that the do-file continues to work in the 
        years to come as new versions of Stata are released.  See 
        {bf:{help version:[P] version}}.

{p 8 12 2}
    (2)  The do-file should not depend on Mata having certain 
        vectors, matrices, or programs already loaded and set up because if
        you attempt to run the do-file again later, what you assumed may not
        be true.  A do-file should be self-contained.  To ensure that is true
        the first time we write and run the do-file and to ensure on
        subsequent runs that nothing lying around in Mata gets in our way, we
        clear Mata.

{p 8 12 2}
    (3)  You may need to sort your data, create extra variables that your
        do-file will use, or drop variables that you are assuming do not
        already exist.  In the last iteration of {cmd:myfile.do}, we needed to
        {cmd:generate} {cmd:D} {cmd:=} {cmd:.}, and it would not have been a
        bad idea to {cmd:capture} {cmd:drop} {cmd:D} before we did that.
        Our example did not depend on the sort order of the data, but if 
        it had, we would have included the sort even if we were certain 
        that the data would already be in the right order.

{p 8 12 2}
    (4)  Put the {cmd:putmata} command here.  If {cmd:putmata} includes 
        the {cmd:omitmissing} option, then put everything you need to put 
        in a single {cmd:putmata} command.  Otherwise, you can use 
        multiple {cmd:putmata} commands if you find that more convenient.
        If you use multiple {cmd:putmata} commands, be sure to include 
        the same {cmd:if} {it:expression} and {cmd:in} {it:range} 
        qualifiers on each one.

{p 8 12 2}
    (5)  The Mata code goes here.  Note that we type {cmd:mata:} ({cmd:mata}
	with a colon) to enter Mata.  {cmd:mata:} ensures that errors stop
        Mata and thus our do-file.

{p 8 12 2}
    (6)  The {cmd:getmata} command goes here if you need it. 
        Be sure to include {cmd:getmata}'s 
        {cmd:id(}{it:name}{cmd:)} or
        {cmd:id(}{it:vecname}{cmd:=}{it:varname}{cmd:)} option if, on the
        {cmd:putmata} command in step 4, you included the {cmd:if}
        {it:expression} qualifier or the {cmd:in} {it:range}
        qualifier or the {cmd:omitmissing} option.
        If you include {cmd:id()}, be sure you included the ID variable 
        in the {cmd:putmata} command in step 4.

{p 8 12 2}
    (7)  We conclude by clearing Mata again to avoid leaving
        memory allocated needlessly and to avoid causing problems
        for poorly written do-files that we might subsequently run.

{p 4 4 2}
{cmd:putmata} and {cmd:getmata} 
are designed to work interactively and in do-files.  The commands are
not designed to work with ado-files.  An ado-file is something like a do-file,
but it defines a program that implements a new command of Stata, and well-written
ado-files do not use globals such as the global vectors and matrices that
{cmd:putmata} creates.  Ado-files use local variables.  Ado-file programmers
should use the Mata functions
{cmd:st_data()} and {cmd:st_view()} (see 
{bf:{help mf_st_data:[M-5] st_data()}}
and 
{bf:{help mf_st_view:[M-5] st_view()}})
to create vectors and matrices, and if necessary, use {cmd:st_store()} (see 
{bf:{help mf_st_store:[M-5] st_store()}}) to post the contents of those 
vectors and matrices back to Stata.


{marker results}{...}
{title:Stored results}

{p 4 4 2}
{cmd:putmata} stores the following in {cmd:r()}:

{col 8}Scalars
{col 12}{cmd:r(N)}{...}
{col 28}number of rows in created vectors and matrices
{col 12}{cmd:r(K_views)}{...}
{col 28}number of vectors and matrices created as views
{col 12}{cmd:r(K_copies)}{...}
{col 28}number of vectors and matrices created as copies

{p 8 8 2}
The total number of vectors and matrices created is 
{cmd:r(K_views)} + {cmd:r(K_copies)}.

{p 8 8 2}
{cmd:r(N)}=. if {cmd:r(K_views)} + {cmd:r(K_copies)} = 0.
{cmd:r(N)}=0 means that zero-observation 
vectors and matrices were created, which is to say, 
vectors and matrices dimensioned 
0 x 1 and 0 x {it:k}.

{p 4 4 2}
{cmd:getmata} stores the following in {cmd:r()}:

{col 8}Scalars
{col 12}{cmd:r(K_new)}{...}
{col 28}number of new variables created
{col 12}{cmd:r(K_existing)}{...}
{col 28}number of existing variables modified

{p 8 8 2}
The total number of variables modified is 
{cmd:r(K_new)} + {cmd:r(K_existing)}.{p_end}
{* {title:Source code}}{...}
{...}
{* {p 4 4 2}}{...}
{* {view putmata.ado, adopath asis:putmata.ado},}{...}
{* {view getmata.ado, adopath asis:getmata.ado}}{...}
{...}
{...}
