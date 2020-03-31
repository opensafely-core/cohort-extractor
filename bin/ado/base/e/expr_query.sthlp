{smcl}
{* *! version 1.2.1  10may2018}{...}
{vieweralsosee "undocumented" "help undocumented"}{...}
{viewerjumpto "Syntax" "expr_query##syntax"}{...}
{viewerjumpto "Description" "expr_query##description"}{...}
{viewerjumpto "Remarks" "expr_query##remarks"}{...}
{viewerjumpto "Examples" "expr_query##examples"}{...}
{viewerjumpto "Stored results" "expr_query##stored"}{...}
{viewerjumpto "Diagnostics" "expr_query##diag"}{...}
{title:Title}

{p2colset 5 23 25 2}{...}
{p2col :{bf:[P] expr_query} {hline 2}}Obtain variables used in expression{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 25 2}
{cmd:expr_query} [{cmd:=}] {it:exp}


{marker description}{...}
{title:Description}

{pstd}
{cmd:expr_query} returns in {cmd:r()} 
the variable names used in {it:exp}, where 
{it:exp} is an expression that might be used with 
{helpb generate} or {helpb replace}. 

{pstd}
The variable names are names of variables in the dataset.  They do not 
include scalar or matrix variables.


{marker remarks}{...}
{title:Remarks}

{pstd}
In some programming situations, there are expressions specified by the user
that will be evaluated later, after the dataset in memory has been modified.
The list returned by {cmd:expr_query} can be added to the list of variables to
be kept.


{marker examples}{...}
{title:Examples}

{pstd}
We begin with out-of-context examples just to demonstrate the {cmd:r()} values
{cmd:expr_query} makes available to you.

	. {cmd:sysuse auto}

	. {cmd:expr_query 1/mpg}

	. {cmd:return list}
          macros:
                       r(type) : "{res}numeric{txt}"
                   r(varnames) : "{res}mpg{txt}"


	. {cmd:expr_query weight/(1/mpg)}

	. {cmd:return list}
          macros:
                       r(type) : "{res}numeric{txt}"
                   r(varnames) : "{res}mpg weight{txt}"


	. {cmd:expr_query "car " + lower(make)}

	. {cmd:return list}
          macros:
                       r(type) : "{res}string{txt}"
                   r(varnames) : "{res}make{txt}"


	. {cmd:expr_query 1/sqrt(2)}

	. {cmd:return list}
          macros:
                       r(type) : "{res}numeric{txt}"
                   r(varnames) : "{res} {txt}"

{pstd}
{cmd:expr_query} is a programming command. 
Typical use would be something like this: 

	{cmd}program myprog
		version {ccl stata_version}
		syntax varlist =exp [if] [in], ... 
		marksample touse
		{it:...}
		expr_query `exp'
		local uservars `r(varnames)'
		...
		local vars_to_keep : list varlist | uservars
		preserve
		keep if `touse'
		keep `vars_to_keep'
		...
		tempvar weight
		gen double `weight' `exp'     /* <--- */
		...
		...
	end{txt}

{pstd}
In the above example, the user specifies, among other things, an expression on
the {cmd:myprog} command line.  Command {cmd:syntax} parses what the user types.
{cmd:expr_query} provides the list of variables that the user-specified
expression uses; {cmd:myprog} then makes a list of variables to
be kept -- variables the program will need -- ignoring the expression and
presumably based on other parts of the syntax that the user provided.
Finally, the variables-to-keep list and the variables used in the
expression are combined with the logical operator {cmd:|} (or), 
producing the union of the two lists.  {cmd:myprog} preserves
the user's data, keeps the variables it would need, and does whatever other
work it needs to do.  Eventually (we marked the line with an arrow),
{cmd:myprog} generates a temporary new variable based on
the user-specified expression.  The {cmd:generate} command will be successful
because in {cmd:vars_to_keep} we included any variables the user-specified
{cmd:`exp'} required. 


{marker stored}{...}
{title:Stored results}

{pstd}
{cmd:expr_query} produces no output but stores the following in {cmd:r()}:

{synoptset 16 tabbed}{...}
{p2col 5 16 20 2: Macros}{p_end}
{synopt:{cmd:r(type)}}{cmd:numeric} or {cmd:string}{p_end}
{synopt:{cmd:r(varnames)}}space-delimited variable-name list;
	  contains a single blank ({cmd:" "}) if no variables are used in
          {it:exp}{p_end}
{synopt:{cmd:r(tsvarlist)}}time-series variables list{p_end}
{synopt:{cmd:r(fvvarlist)}}factor variables list{p_end}
{p2colreset}{...}


{marker diag}{...}
{title:Diagnostics}

{pstd}
{cmd:expr_query} produces the same error messages and nonzero return codes
that {cmd:generate} or {cmd:replace} would produce when {it:exp} contains an
error.
{p_end}
