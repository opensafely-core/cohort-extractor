{smcl}
{* *! version 1.0.3  16apr2009}{...}
{cmd:help matrix makeCns}, {cmd:help matrix dispCns}{...}
{right:{help prdocumented:previously documented}}
{hline}

{title:Title}

{pstd}
{hi:[P] matrix makeCns} {hline 2} Constrained estimation


{title:Syntax}

	{cmdab:mat:rix} {cmd:makeCns} [{it:clist} | {it:matname}]

	{cmdab:mat:rix} {cmd:dispCns} [{cmd:,} {cmd:r} ]

{pstd}
where {it:clist} is a list of constraint numbers, separated by commas or
dashes.

{pstd}
{it:matname} is an existing matrix representing the constraints and must have
one more column than the {hi:e(b)} and {hi:e(V)} matrices.


{title:Description}

{pstd}
{cmd:matrix makeCns} makes a constraint matrix; the matrix can be obtained by
the {cmd:matrix get(Cns)} function (see {hi:[P] matrix get} or {helpb get()}).
{cmd:matrix dispCns} displays the system-stored constraint matrix in readable
form.

{pstd}
See {helpb makecns} for a newer alternative to {cmd:matrix makeCns} and
{cmd:matrix dispCns} and for information on the {cmd:matcproc} command.

{pstd}
If your interest is simply in using constraints in a command that supports
constrained estimation, then see {hi:[R] constraint} and {helpb constraint}.


{title:Option}

{phang}
{cmd:r} suppresses the output of {cmd:matrix dispCns} and instead fills in
macros {cmd:r(cns}{it:#}{cmd:)} along with scalar {cmd:r(k)}.


{title:Also see}

{psee}
Manual:  {help prdocumented:previously documented}

{psee}
{space 2}Help:  {manhelp makecns P};
{manhelp constraint R};
{manhelp get() P:matrix get}
{p_end}
