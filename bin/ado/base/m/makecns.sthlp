{smcl}
{* *! version 1.1.7  29aug2018}{...}
{vieweralsosee "[P] makecns" "mansection P makecns"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] constraint" "help constraint"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] cnsreg" "help cnsreg"}{...}
{vieweralsosee "[P] ereturn" "help ereturn"}{...}
{vieweralsosee "[P] macro (local)" "help local"}{...}
{vieweralsosee "[P] matrix" "help matrix"}{...}
{vieweralsosee "[P] matrix get" "help get()"}{...}
{vieweralsosee "[R] ml" "help ml"}{...}
{viewerjumpto "Syntax" "makecns##syntax"}{...}
{viewerjumpto "Description" "makecns##description"}{...}
{viewerjumpto "Links to PDF documentation" "makecns##linkspdf"}{...}
{viewerjumpto "Options" "makecns##options"}{...}
{viewerjumpto "Example" "makecns##example"}{...}
{viewerjumpto "Stored results" "makecns##results"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[P] makecns} {hline 2}}Constrained estimation{p_end}
{p2col:}({mansection P makecns:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

    Build constraints

{p 8 15 2}
{cmd:makecns}
	[{it:{help numlist}}|{it:matname}]
	[{cmd:,} {it:options}]


    Create constraint matrix 

{p 8 15 2}
{cmd:matcproc} {it:T a C}


{phang}
{it:numlist} is a list of constraint numbers, separated by blanks or
dashes; {it:matname} is an existing matrix representing the constraints and
must have one more column than the {hi:e(b)} and {hi:e(V)} matrices.

{phang}
{it:T}, {it:a}, and {it:C} are names of new or existing matrices.

{synoptset 12}{...}
{synopthdr}
{synoptline}
{synopt:{opt nocnsnote:s}}do not display notes when constraints are dropped{p_end}
{synopt:{opt di:splaycns}}display the system-stored constraint matrix{p_end}
{synopt:{opt r}}return the accepted constraints in {hi:r()}; this option overrides {opt displaycns}{p_end}
{synoptline}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
{cmd:makecns} is a programmer's command that facilitates adding constraints to
estimation commands.

{pstd}
{cmd:makecns} will create a constraint matrix and displays a note for each
constraint that is dropped because of an error.  When called without
arguments, {cmd:makecns} will add missing factor-variable constraints implied
by base levels, empty levels, and omitted coefficients.  The constraint matrix
is stored in {hi:e(Cns)}.

{pstd}
{cmd:matcproc} returns matrices helpful for performing constrained estimation,
including the constraint matrix.

{pstd}
If your interest is simply in using constraints in a command that supports
constrained estimation, see {manhelp constraint R}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection P makecnsRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{cmd:nocnsnotes} prevents notes from being displayed when constraints are
dropped.

{phang}
{cmd:displaycns} displays the system-stored constraint matrix in readable
form.

{phang}
{cmd:r} returns the accepted constraints in {cmd:r()}.  This option overrides
{cmd:displaycns}.


{marker example}{...}
{title:Example}

{pstd}
Here is an outline for programs to perform constrained estimation using
{cmd:makecns}:

{cmd}{...}
	program {it:myest}, eclass properties(...)
		version {ccl stata_version}
		if replay() {	// {it:replay the results}
			if ("`e(cmd)'" != "{it:myest}") error 301
			syntax [, Level(cilevel) ]
                        makecns , displaycns
		}
		else {		// {it:fit the model}
			syntax {it:whatever} [,			     ///
				{it:whatever}			     ///
				Constraints(string)	    	///
				Level(cilevel)			///
			]
			// {it:any other parsing of the user's estimate request}
			tempname b V C T a bc Vc
			local p={it:number of parameters}
			// {it:define the model} ({it:set the row and column}
			// {it:names}) {it:in `b'}
			if "`constraints'" != "" {
				matrix `V' = `b''*`b'
				ereturn post `b' `V'	// {it:a dummy solution}
				makecns `constraints', display
				matcproc `T' `a' `C'
				// {it:obtain solution in `bc' and `Vc'}
				matrix `b' = `bc'*`T'' + `a'    // {it:note prime}
				matrix `V' = `T'*`Vc'*`T''	// {it:note prime}
				ereturn post `b' `V' `C', {it:options}
			}
			else {
				// {it:obtain standard solution in `b' and `V'}
				ereturn post `b' `V', {it:options}
			}
			// {it:store whatever else you want in e}()
			ereturn local cmd "{it:myest}"
		}
		// {it:output any header above the coefficient table}
		ereturn display, level(`level')
	end
{reset}{txt}{...}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:makecns} stores the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:r(k_autoCns)}}number of base, empty, and omitted constraints{p_end}

{p2col 5 15 19 2: Macro}{p_end}
{synopt:{cmd:r(clist)}}constraints used (numlist or matrix name){p_end}
{p2colreset}{...}
