{smcl}
{* *! version 2.0.4  19oct2017}{...}
{viewerdialog "SEM Builder" "stata sembuilder"}{...}
{vieweralsosee "[SEM] sem and gsem option constraints()" "mansection SEM semandgsemoptionconstraints()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[SEM] sem" "help sem_command"}{...}
{vieweralsosee "[SEM] gsem" "help gsem_command"}{...}
{vieweralsosee "[SEM] sem and gsem path notation" "help sem and gsem path notation"}{...}
{vieweralsosee "[SEM] sem model description options" "help sem_model_options"}{...}
{vieweralsosee "[SEM] gsem model description options" "help gsem_model_options"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] constraint" "help constraint"}{...}
{viewerjumpto "Syntax" "sem_and_gsem_option_constraints##syntax"}{...}
{viewerjumpto "Description" "sem_and_gsem_option_constraints##description"}{...}
{viewerjumpto "Links to PDF documentation" "sem_and_gsem_option_constraints##linkspdf"}{...}
{viewerjumpto "Remarks" "sem_and_gsem_option_constraints##remarks"}{...}
{viewerjumpto "Examples" "sem_and_gsem_option_constraints##examples"}{...}
{p2colset 1 44 46 2}{...}
{p2col:{bf:[SEM] sem and gsem option constraints()} {hline 2}}Specifying constraints{p_end}
{p2col:}({mansection SEM semandgsemoptionconstraints():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{cmd:sem} ... [{cmd:,} ... {cmd:constraints(}{it:#} [{it:#} ...]{cmd:)} ...] 

{p 8 12 2}
{cmd:gsem} ... [{cmd:,} ... {cmd:constraints(}{it:#} [{it:#} ...]{cmd:)} ...] 

{pstd}
where {it:#} are constraint numbers.  Constraints are defined by the
{cmd:constraint} command; see {helpb constraint:[R] constraint}. 


{marker description}{...}
{title:Description}

{pstd}
Constraints refer to constraints to be imposed on the estimated parameters of
a model.  These constraints usually come in one of three forms:

{phang2}
1.  Constraints that a parameter such as a path coefficient or variance is
equal to a fixed value such as 1.

{phang2}
2.  Constraints that two or more parameters are equal.

{phang2}
3.  Constraints that two or more parameters are related by a linear equation. 

{pstd}
It is usually easier to specify constraints with {cmd:sem}'s and
{cmd:gsem}'s path notation;
see {helpb sem_and_gsem_path_notation##item11:[SEM] sem and gsem path notation}.

{pstd}
{cmd:sem}'s and {cmd:gsem}'s {cmd:constraints()} option provides an
alternative way of specifying constraints. 


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection SEM semandgsemoptionconstraints()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

        {help sem and gsem option constraints##sem_constraints:Use with sem}
        {help sem and gsem option constraints##gsem_constraints:Use with gsem}

{pstd}
Also see {helpb constraint:[R] constraint}.


{marker sem_constraints}{...}
{title:Use with sem}

{pstd}
There is only one case where {cmd:constraints()} might be easier to use
with {cmd:sem} instead of
specifying constraints in the path notation.  You wish to specify that two or
more parameters are related and then decide you would like to fix the value at
which they are related. 

{pstd}
For example, if you wanted to specify that parameters are equal, you could
type 

{phang2}{cmd:. sem ... (y1 <- x@}{it:c1}{cmd:) (y2 <- x@}{it:c1}{cmd:)     (y3 <- x@}{it:c1}{cmd:)      ...}{p_end}

{pstd}
Using the path notation, you can specify more general relationships, too, such
as 

{phang2}{cmd:. sem ... (y1 <- x@}{it:c1}{cmd:) (y2 <- x@(2*}{it:c1}{cmd:)) (y3 <- x@(3*}{it:c1}{cmd:+1)) ...}{p_end}

{pstd}
Say you now decide you want to fix {it:c1} at value 1.  Using the path
notation, you modify what you previously typed: 

{phang2}{cmd:. sem ... (y1 <- x@1) (y2 <- x@2)     (y3 <- x@4)      ...}{p_end}

{pstd}
Alternatively, you could do the following:

{phang2}{cmd:. constraint 1 _b[y2:x] = 2*_b[y1:x]}{p_end}

{phang2}{cmd:. constraint 2 _b[y3:x] = 3*_b[y1:x] + 1}{p_end}

{phang2}{cmd:. sem ..., ... constraints(1 2)}{p_end}

{phang2}{cmd:. constraint 3 _b[y1:x] = 1}{p_end}

{phang2}{cmd:. sem .., ... constraints(1 2 3)}{p_end}


{marker gsem_constraints}{...}
{title:Use with gsem}

{pstd}
Gamma regression can produce exponential regression estimates if you
constrain the log of the scale parameter to 0.  Parameters
associated with particular generalized linear families, such as scalar
parameters, cutpoints, and the like, cannot be constrained using the {cmd:@}
notation in paths.  You must use Stata's constraints.

{pstd}
Say we wish to fit the model {cmd:y <- x1} with exponential regression.
We admit that we do not remember the name under which {cmd:gsem} stores
the scalar parameter, so first we type

{phang2}{cmd:. gsem (y <- x1, gamma), noestimate}

{pstd}
From the output, we quickly discover that the log of the scale parameter is
stored as {cmd:_b[y_logs:_cons]}.  With that information, to obtain the
constrained results, we type

{phang2}{cmd:. constraint 1 _b[/y:logs] = 0}{p_end}
{phang2}{cmd:. gsem (y <- x1, gamma), constraints(1)}


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse sem_2fmm}{p_end}

{pstd}Two-factor measurement model{p_end}
{phang2}{cmd:. sem (Affective -> a1 a2 a3 a4 a5) (Cognitive -> c1 c2 c3 c4 c5)}{p_end}

{pstd}Constrain parameters with the {cmd:@} notation{p_end}
{phang2}{cmd:. sem (Affective -> a1 a2@c1 a3@c1 a4 a5)}{break}
	{cmd: (Cognitive -> c1 c2@c2 c3@c2 c4 c5)}{p_end}

{pstd}Specify same model with the {cmd:constraints()} option{p_end}
{phang2}{cmd:. constraint 1 _b[a2:Affective] = _b[a3:Affective]}{p_end}

{phang2}{cmd:. constraint 2 _b[c2:Cognitive] = _b[c3:Cognitive]}{p_end}

{phang2}{cmd:. sem (Affective -> a1 a2 a3 a4 a5)}{break}
	{cmd: (Cognitive -> c1 c2 c3 c4 c5), constraints(1 2)}{p_end}
