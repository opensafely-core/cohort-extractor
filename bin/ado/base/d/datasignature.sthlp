{smcl}
{* *! version 2.1.15  19oct2017}{...}
{viewerdialog datasignature "dialog datasignature"}{...}
{vieweralsosee "[D] datasignature" "mansection D datasignature"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] _datasignature" "help _datasignature"}{...}
{vieweralsosee "[P] signestimationsample" "help signestimationsample"}{...}
{viewerjumpto "Syntax" "datasignature##syntax"}{...}
{viewerjumpto "Menu" "datasignature##menu"}{...}
{viewerjumpto "Description" "datasignature##description"}{...}
{viewerjumpto "Links to PDF documentation" "datasignature##linkspdf"}{...}
{viewerjumpto "Options" "datasignature##options"}{...}
{viewerjumpto "Examples" "datasignature##examples"}{...}
{viewerjumpto "Stored results" "datasignature##results"}{...}
{p2colset 1 22 24 2}{...}
{p2col:{bf:[D] datasignature} {hline 2}}Determine whether data have changed
{p_end}
{p2col:}({mansection D datasignature:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{cmdab:datasig:nature}


{p 8 12 2}
{cmdab:datasig:nature}
{cmd:set}{bind:    }
[{cmd:,}
{cmd:reset}
]

{p 8 12 2}
{cmdab:datasig:nature}
{cmdab:conf:irm}
[{cmd:,}
{cmd:strict}
]

{p 8 12 2}
{cmdab:datasig:nature}
{cmdab:rep:ort}



{p 8 12 2}
{cmdab:datasig:nature}
{cmd:set}{cmd:,}{bind:   }
{cmd:saving(}{it:{help filename}}[{cmd:, replace}]{cmd:)}
[ {cmd:reset} ]

{p 8 12 2}
{cmdab:datasig:nature}
{cmdab:conf:irm}
{cmd:using} {it:{help filename}}
[{cmd:,}
{cmd:strict}
]

{p 8 12 2}
{cmdab:datasig:nature}
{cmdab:rep:ort}{bind: }
{cmd:using} {it:{help filename}}


{p 8 12 2}
{cmdab:datasig:nature}
{cmd:clear}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Data > Other utilities > Manage data signature}


{marker description}{...}
{title:Description}

{pstd}
These commands calculate, display, save, and verify checksums of the data,
which taken together form what is called a signature.  An example signature is
162:11(12321):2725060400:4007406597.  That signature is a function of the
values of the variables and their names, and thus the signature
can be used later to determine whether a dataset has changed.

{pstd}
{cmd:datasignature} without arguments calculates and displays the signature
of the data in memory.

{pstd}
{cmd:datasignature} {cmd:set} does the same, and it stores the signature as a
characteristic in the dataset.  You should {cmd:save} the dataset afterward
so that the signature becomes a permanent part of the dataset.

{pstd}
{cmd:datasignature} {cmd:confirm} verifies that, were the signature 
recalculated this instant, it would match the one previously set.
{cmd:datasignature} {cmd:confirm} displays an error message and 
returns a nonzero return code if the signatures do not match.

{pstd}
{cmd:datasignature} {cmd:report} displays a full report comparing the
previously set signature to the current one.

{pstd}
In the above, the signature is stored in the dataset and accessed from 
it.  The signature can also be stored in a separate, small file.

{pstd}
{cmd:datasignature} {cmd:set,} {cmd:saving(}{it:{help filename}}{cmd:)}
calculates and displays the signature and, in addition to storing it as a
characteristic in the dataset, also saves the signature in {it:filename}.

{pstd}
{cmd:datasignature} {cmd:confirm} {cmd:using} {it:filename} verifies that
the current signature matches the one stored in {it:filename}.

{pstd}
{cmd:datasignature} {cmd:report} {cmd:using} {it:filename} displays 
a full report comparing the current signature with the one stored 
in {it:filename}.

{pstd}
In all the above, if {it:filename} is specified without an extension,
{cmd:.dtasig} is assumed.

{pstd}
{cmd:datasignature} {cmd:clear} clears the signature, if any, stored 
in the characteristics of the dataset in memory.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D datasignatureQuickstart:Quick start}

        {mansection D datasignatureRemarksandexamples:Remarks and examples}

        {mansection D datasignatureMethodsandformulas:Methods and formulas}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{cmd:reset} is used with {cmd:datasignature} {cmd:set}. 
   It specifies that even though you have previously set a signature, 
   you want to erase the old signature and replace it with 
   the current one.

{phang}
{cmd:strict} is for use with {cmd:datasignature} {cmd:confirm}.
    It specifies that, in addition to requiring that the signatures match, you
    also wish to require that the variables be in the same order and that 
    no new variables have been added to the dataset.  (If any variables were
    dropped, the signatures would not match.)

{phang}
{cmd:saving(}{it:{help filename}}[{cmd:,} {cmd:replace}]{cmd:)}
    is used with {cmd:datasignature} {cmd:set}.  It specifies that, in
    addition to storing the signature in the dataset, you want a copy of the
    signature saved in a separate file.  If {it:filename} is specified without
    a suffix, {cmd:.dtasig} is assumed.
    The {cmd:replace} suboption allows {it:filename} to be replaced if it 
    already exists.


{marker examples}{...}
{title:Examples}

{marker ex1}{...}
{title:Example 1:  Verification at a distance}

{p 4 4 2}
You load the data and type 

	. {cmd:datasignature}
           74:12(71728):3831085005:1395876116

{p 4 4 2}
Your coworker does the same with his or her copy.  You compare the two 
signatures.


{marker ex2}{...}
{title:Example 2:  Protecting yourself from yourself}

{p 4 4 2}
You load the data and type 

	. {cmd:datasignature set}
           74:12(71728):3831085005:1395876116    (data signature set)

	. {cmd:save, replace}

{p 4 4 2}
From then on, you periodically type 

	. {cmd:datasignature confirm}
          (data unchanged since 19feb2017 14:24)

{p 4 4 2}
One day, however, you check and see the message:

	. {cmd:datasignature confirm}
          (data unchanged since 19feb2017 14:24, except 2 variables 
           have been added)

{p 4 4 2}
You can find out more by typing 

	. {cmd:datasignature report}
          (data signature set on Monday 19feb2017 14:24)

        {title:Data signature summary}

         1. Previous data signature{col 39}74:12(71728):3831085005:1395876116
         2. Same data signature today{col 39}(same as 1)
         3. Full data signature today{col 39}74:14(113906):1142538197:2410350265

        {title:Comparison of current data with previously set data signature}

		Variables{col 42}No.{col 50}Notes
		{hline 60}
		Original # of variables{col 42}    12{col 50}(values unchanged)
		Added variables{col 42}     2  (note 1)
		Dropped variables{col 42}     0
		{hline 60}
		Resulting # of variables{col 42}    14

		(1) Added variables are agesquared logincome.

{p 4 4 2}
You could now either drop the added variables or decide to incorporate 
them:

	. {cmd:datasignature set}
	  {err:data signature already set -- specify option -reset-}
	r(110)

	. {cmd:datasignature set, reset}
	  74:14(113906):1142538197:2410350265       (data signature reset)

{p 4 4 2}
Concerning the detailed report, three data signatures are reported:
1) the stored signature, 2) the signature that would be calculated 
today on the basis of the same variables in their original order, and (3) the 
signature that would be calculated today on the basis of all the variables 
and in their current order.

{p 4 4 2}
{cmd:datasignature} {cmd:confirm} knew that new variables had been added 
because 1) was equal to 2).  If some variables had been dropped, 
however, {cmd:datasignature} {cmd:confirm} would not be able to determine 
whether the remaining variables had changed.


{marker ex3}{...}
{title:Example 3:  Working with assistants}

{p 4 4 2}
You give your dataset to an assistant to have variable labels and 
the like added.  You wish to verify that the returned data are 
the same data.

{p 4 4 2}
Saving the signature with the dataset is inadequate here.  Your
assistant, having your dataset, could change both your data and the signature
and might even do that in a desire to be helpful.  The solution is
to save the signature in a separate file that you do not give to your 
assistant:

	. {cmd:datasignature set, saving(mycopy)}
	  74:12(71728):3831085005:1395876116       (data signature set)
          (file mycopy.dtasig saved)

{p 4 4 2}
You keep file {cmd:mycopy.dtasig}.  When your assistant returns the dataset to
you, you {cmd:use} it and compare the current signature to what you have 
stored in {cmd:mycopy.dtasig}:

	. {cmd:datasignature confirm using mycopy}
	  (data unchanged since 19feb2017 15:05)

{p 4 4 2}
By the way, the signature is a function of the following:

{p 8 12 2}
o  The number of observations and number of variables in the data

{p 8 12 2}
o  The values of the variables

{p 8 12 2}
o  The names of the variables

{p 8 12 2}
o  The order in which the variables occur in the dataset

{p 8 12 2}
o  The storage types of the individual variables

{p 4 4 2}
The signature is not a function of variable labels, value labels, notes, 
and the like.


{marker ex4}{...}
{title:Example 4:  Working with shared data}

{p 4 4 2}
You work on a dataset served on a network drive, which means that others
could change the data.  You wish to know whether this occurs.

{p 4 4 2}
The solution here is the same as working with an assistant:  you save 
the signature in a separate, private file on your computer,

	. {cmd:datasignature set, saving(private)}
	  74:12(71728):3831085005:1395876116       (data signature set)
          (file private.dtasig saved)

{p 4 4 2}
and then you periodically check the signature by typing 

	. {cmd:datasignature confirm using private}
	  (data unchanged since 15mar2017 11:22)


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:datasignature} without arguments and {cmd:datasignature set} store the
following in {cmd:r()}:

	Macros
	    {cmd:r(datasignature)}        the signature

{pstd}
{cmd:datasignature confirm} stores the following in {cmd:r()}:

	Scalars
	    {cmd:r(k_added)}              number of variables added

	Macros
	    {cmd:r(datasignature)}        the signature

{pstd}
{cmd:datasignature} {cmd:confirm} aborts execution if 
the signatures do not match and so then returns nothing 
except a return code of 9. 

{pstd}
{cmd:datasignature report} stores the following in {cmd:r()}:

{p2colset 13 37 42 2}{...}
{p2col 9 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(datetime)}}{cmd:%tc} date-time when set{p_end}
{synopt:{cmd:r(changed)}}{cmd:.} if {cmd:r(k_dropped)}!=0, otherwise
		{cmd:0} if data have not changed,
		{cmd:1} if data have changed{p_end}
{synopt:{cmd:r(reordered)}}{cmd:1} if variables reordered, 
		{cmd:0} if not reordered, 
		{cmd:.} if {cmd:r(k_added)}!=0 | {cmd:r(k_dropped)}!=0{p_end}
{synopt:{cmd:r(k_original)}}number of original variables{p_end}
{synopt:{cmd:r(k_added)}}number of added variables{p_end}
{synopt:{cmd:r(k_dropped)}}number of dropped variables{p_end}
          
{p2col 9 20 24 2: Macros}{p_end}
{synopt:{cmd:r(origdatasignature)}}original signature{p_end}
{synopt:{cmd:r(curdatasignature)}}current signature on same variables,
					if it can be calculated{p_end}
{synopt:{cmd:r(fulldatasignature)}}current full-data signature{p_end}
{synopt:{cmd:r(varsadded)}}variable names added{p_end}
{synopt:{cmd:r(varsdropped)}}variable names dropped{p_end}

{pstd}
{cmd:datasignature} {cmd:clear} stores nothing in {cmd:r()} but
does clear it.

{pstd}
{cmd:datasignature} {cmd:set} stores the signature in the following 
characteristics:

	Characteristic
	    {cmd:_dta[datasignature_si]}  signature
	    {cmd:_dta[datasignature_dt]}  {cmd:%tc} date-time when set in {cmd:%21x} format
	    {cmd:_dta[datasignature_vl1]} part 1, original variables
	    {cmd:_dta[datasignature_vl2]} part 2, original variables, if necessary
	    etc.

{pstd}
To access the original variables stored in {cmd:_dta[datasignature_vl1]},
etc., from an ado-file, code

	{cmd:mata: ado_fromlchar("vars", "_dta", "datasignature_vl")}

{pstd}
Thereafter, the original variable list would be found in {cmd:`vars'}.
{p_end}
