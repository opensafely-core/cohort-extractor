{smcl}
{* *! version 1.3.3  15may2018}{...}
{vieweralsosee "[M-1] Ado" "mansection M-1 Ado"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-2] version" "help m2_version"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-1] Intro" "help m1_intro"}{...}
{viewerjumpto "Description" "m1_ado##description"}{...}
{viewerjumpto "Links to PDF documentation" "m1_ado##linkspdf"}{...}
{viewerjumpto "Remarks" "m1_ado##remarks"}{...}
{p2colset 1 14 16 2}{...}
{p2col:{bf:[M-1] Ado} {hline 2}}Using Mata with ado-files
{p_end}
{p2col:}({mansection M-1 Ado:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
This section provides advice to ado-file programmers on how to use Mata
effectively and efficiently.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-1 AdoRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
For those interested in extending Stata by adding new commands, Mata is not a
replacement for ado-files.  Rather, the appropriate way to use Mata is to
create subroutines used by your ado-files.  Below we discuss how to do that
under the following headings:

	{help m1_ado##remarks1:A first example}
	{help m1_ado##remarks2:Where to store the Mata functions}
	{help m1_ado##remarks3:Passing arguments to Mata functions}
	{help m1_ado##remarks4:Returning results to ado-code}
	{help m1_ado##remarks5:Advice:  Use of matastrict}
	{help m1_ado##remarks6:Advice:  Some useful Mata functions}


{marker remarks1}{...}
{title:A first example}

{pstd}
We will pretend that Stata cannot produce sums and that we want to write a new
command for Stata that will report the sum of one variable.
Here is our first take on how we might do this:

	{hline 43} begin varsum.ado {hline 6}
	{cmd}program varsum
		version {ccl stata_version}
		syntax varname [if] [in]
		marksample touse
		mata: calcsum("`varlist'", "`touse'")
		display as txt "  sum = " as res r(sum)
	end

	version {ccl stata_version}
	mata:
	void calcsum(string scalar varname, string scalar touse)
	{
		real colvector  x

		st_view(x, ., varname, touse)
		st_numscalar("r(sum)", colsum(x))
	}
	end{txt}
	{hline 43} end varsum.ado {hline 8}

{pstd}
Running this program from Stata results in the following output:

	. {cmd:varsum mpg}
	  sum = 1576

{pstd}
Note the following:

{phang2}
    1.  The ado-file has both ado-code and Mata code in it.

{phang2}
    2.  The ado-code handled all issues of parsing and identifying the 
        subsample of the data to be used.

{phang2}
    3.  The ado-code called a Mata function to perform the calculation.

{phang2}
    4.  The Mata function received as arguments the names of two 
        variables in the Stata dataset:  the variable on which the 
        calculation was to be made and the variable that identified 
        the subsample of the data to be used.

{phang2}
    5.  The Mata function returned the result in {cmd:r()}, from where 
        the ado-code could access it.

{pstd}
The outline that we showed above is a good one, although we will show you 
alternatives that, for some problems, are better.


{marker remarks2}{...}
{title:Where to store the Mata functions}

{pstd}
Our ado-file included a Mata function.  You have three choices of 
where to put the Mata function:

{phang2}
    1.  You can put the code for the Mata function in the 
        ado-file, as we did.  To work, your {cmd:.ado} file 
        must be placed where Stata can find it.

{phang2}
    2.  You can omit code for the Mata function from the 
        ado-file, compile the Mata function separately, and store 
        the compiled code (the object code) in a separate file
        called a {cmd:.mo} file.  You place both your {cmd:.ado} and {cmd:.mo} 
	files where Stata can find them.
        
{phang2}
    3.  You can omit the code for the Mata function from the 
        ado-file, compile the Mata function separately, and store the 
        compiled code in a {cmd:.mlib} library.  Here both your 
        {cmd:.ado} file and your {cmd:.mlib} library will need to be placed
        where Stata can find them.

{pstd}
We will show you how to do each of these alternatives, but before we do, 
let's consider the advantages and disadvantages of each:

{phang2}
    1.  Putting your Mata source code right in the ado-file is 
        easiest, and it sure is convenient.  The disadvantage is that
        Mata must compile the source code into object code, and that will 
        slow execution.  The cost is small because it occurs infrequently;
        Mata compiles the code when the ado-file is loaded and, as 
        long as the ado-file is not dropped from memory, Stata and Mata 
        will use the same compiled code over and over again.

{phang2}
    2.  Saving your Mata code as {cmd:.mo} files saves Mata from having 
        to compile them at all.  The source code is compiled only 
        once -- at the time you create the {cmd:.mo} file -- and thereafter,
        it is the already-compiled copy that Stata and Mata will use.

{pmore2}
        There is a second advantage:  rather than the Mata functions 
        ({cmd:calcsum()} here) being private to the ado-file, 
        you will be able to use {cmd:calcsum()} in your other ado-files.  
        {cmd:calcsum()} will become a utility always available to you.
        Perhaps {cmd:calcsum()} is not deserving of this honor.

{phang2}
    3.  Saving your Mata code in a {cmd:.mlib} library has the same 
        advantages and disadvantages as (2); the only difference is 
        that we save the precompiled code in a different way.
        The {cmd:.mo}/{cmd:.mlib} choice is of more concern to those who 
        intend to distribute their ado-file to others.  
        {cmd:.mlib} libraries allow you to place many Mata functions 
        (subroutines for your ado-files) into one file, and so it is 
        easier to distribute.

{pstd}
Let's restructure our ado-file to save {cmd:calcsum()} in a {cmd:.mo} file.
First, we simply remove {cmd:calcsum()} from our ado-file, so it now 
reads

	{hline 43} begin varsum.ado {hline 6}
	{cmd}program varsum
		version {ccl stata_version}
		syntax varname [if] [in]
		marksample touse
		mata: calcsum("`varlist'", "`touse'")
		display as txt "  sum = " as res r(sum)
	end{txt}
	{hline 43} end varsum.ado {hline 8}

{pstd}
Next, we enter Mata, enter our {cmd:calcsum()} program, and save the 
object code:

	: {cmd:void calcsum(string scalar varname, string scalar touse)}
	> {cmd:{c -(}}
	>        {cmd:real colvector  x}
	>
	>        {cmd:st_view(x, ., varname, touse)}
	>        {cmd:st_numscalar("r(sum)", colsum(x))}
	> {cmd:{c )-}}

	: {cmd:mata mosave calcsum(), dir(PERSONAL)}

{pstd}
This step we do only once.  The {cmd:mata} {cmd:mosave} command 
created file {cmd:calcsum.mo} stored in our {cmd:PERSONAL} sysdir
directory; see 
{bf:{help mata_mosave:[M-3] mata mosave}}
and 
{bf:{help sysdir:[P] sysdir}}
for more details.
We put the {cmd:calcsum.mo} file in our {cmd:PERSONAL} directory so that 
Stata and Mata would be able to find it, just as you probably did with 
the {cmd:varsum.ado} ado-file.

{pstd}
Typing in the {cmd:calcsum()} program interactively is too prone to
error, so instead what we can do is create a do-file to perform the 
step and then run the do-file once:


	{hline 44} begin varsum.do {hline 6}
	{cmd:version {ccl stata_version}}
	{cmd:mata:}
	{cmd:void calcsum(string scalar varname, string scalar touse)}
	{cmd:{c -(}}
	       {cmd:real colvector  x}

	       {cmd:st_view(x, ., varname, touse)}
	       {cmd:st_numscalar("r(sum)", colsum(x))}
	{cmd:{c )-}}

	{cmd:mata mosave calcsum(), dir(PERSONAL) replace}
	{cmd:end}
	{hline 44} end varsum.do {hline 8}

{pstd}
We save the do-file someplace safe in case we should need to modify our 
code later, either to fix bugs or to add features.  For the same reason, we
added a {cmd:replace} option on the command that creates the {cmd:.mo} file,
so we can run the do-file over and over.

{pstd}
To follow the third organization -- putting our {cmd:calcsum()} subroutine
in a library -- is just a matter of modifying {cmd:varsum.do} to 
do {cmd:mata} {cmd:mlib} {cmd:add} rather than {cmd:mata} {cmd:mosave}.
See {bf:{help mata_mlib:[M-3] mata mlib}}; there are important details having
to do with how you will manage all the different functions you will put in the
library, but that has nothing to do with our problem here.

{pstd}
Where and how you store your Mata subroutines has nothing to do
with what your Mata subroutines do or how you use them.


{marker remarks3}{...}
{title:Passing arguments to Mata functions}

{pstd}
In designing a subroutine, you have two paramount interests:  how you get
data into your subroutine and how you get results back.  You get data in
by the values you pass as the arguments.  For {cmd:calcsum()}, we
called the subroutine by coding

	{cmd:mata: calcsum("`varlist'", "`touse'")}

{pstd}
After macro expansion, that line turned into something like

	{cmd:mata: calcsum("mpg", "__0001dc")}

{pstd}
The {cmd:__0001dc} variable is a temporary variable created by 
the {helpb marksample} command earlier in our ado-file.
{cmd:mpg} was the variable specified by the user.
After expansion, 
the arguments were nothing more than strings, and those strings were 
passed to {cmd:calcsum()}. 

{pstd}
Macro substitution is the most common way values are passed to 
Mata subroutines.  If we had a Mata function {cmd:add(}{it:a}{cmd:,} 
{it:b}{cmd:)}, which could add numbers, we might code in our ado-file 

	{cmd:mata: add(`x', `y')}

{pstd}
and, if macro {cmd:`x'} contained 2 and macro {cmd:`y'} contained 3, 
Mata would see 

	{cmd:mata: add(2, 3)}
 
{pstd} 
and values 2 and 3 would be passed to the subroutine.

{pstd}
When you think about writing your Mata subroutine, the arguments your 
ado-file will find convenient to pass and Mata will make convenient to use 
are

{phang2}
    1.  numbers, which Mata calls real scalars, such as 2 and 3
       ({cmd:`x'} and {cmd:`y'}), and

{phang2}
    2.  names of variables, macros, scalars, matrices, etc., 
	which Mata calls string scalars, 
	such as {cmd:"mpg"} and {cmd:"__0001dc"} ({cmd:"`varlist'"} and 
        {cmd:"`touse'"}), 

{pstd}
To receive arguments of type (1), you code {cmd:real scalar} as 
the type of the argument in the function declaration and then use the 
real scalar variable in your Mata code.

{pstd}
To receive arguments of type (2), you code {cmd:string scalar} as the 
type of the argument in the function declaration, and then you use 
one of the Stata interface functions
(in {bf:{help m4_stata:[M-4] Stata}})
to go from the name to the contents.
If you receive a variable name, you will especially want to read about 
the functions {cmd:st_data()} and {cmd:st_view()}
(see {bf:{help mf_st_data:[M-5] st_data()}}
and
{bf:{help mf_st_view:[M-5] st_view()}}), although there are many other
utilities for dealing with variable names. 
If you are dealing with local or global macros, scalars, or matrices, 
you will want to see
{bf:{help mf_st_local:[M-5] st_local()}}, 
{bf:{help mf_st_global:[M-5] st_global()}}, 
{bf:{help mf_st_numscalar:[M-5] st_numscalar()}},
and
{bf:{help mf_st_matrix:[M-5] st_matrix()}}.


{marker remarks4}{...}
{title:Returning results to ado-code}

{pstd}
You have many more choices on how to return results from your Mata function
to the calling ado-code.

{phang2}
    1.  You can return results in {cmd:r()} -- as we did in our example --
        or in {cmd:e()} or in {cmd:s()}.

{phang2}
    2.  You can return results in macros, scalars, matrices, etc., 
        whose names are passed to your Mata subroutine as arguments.

{phang2}
    3.  You can highhandedly reach back into the calling ado-file and 
        return results in macros, scalars, matrices, etc., whose names are
        of your devising. 

{pstd}
In all cases, see {bf:{help mf_st_global:[M-5] st_global()}}.  
{cmd:st_global()} is probably not the function you will use, but there 
is a wonderfully useful table in the
{it:{help mf_st_global##remarks:Remarks}} section that will 
tell you exactly which function to use.

{pstd} 
Also see all other Stata interface functions in
{bf:{help m4_stata:[M-4] Stata}}. 

{pstd} 
If you want to modify the Stata dataset in memory, see 
{bf:{help mf_st_store:[M-5] st_store()}} and
{bf:{help mf_st_view:[M-5] st_view()}}.


{marker remarks5}{...}
{title:Advice:  Use of matastrict}

{* index matastrict tt}{...}
{pstd}
The setting {cmd:matastrict} 
determines whether declarations can be omitted 
(see {bf:{help m2_declarations:[M-2] Declarations}}); by default, 
you may.  That is, {cmd:matastrict} is set {cmd:off}, but you can 
turn it on by typing {cmd:mata} {cmd:set} {cmd:matastrict} {cmd:on}; 
see {bf:{help mata_set:[M-3] mata set}}.
Some users do, and some users do not.

{pstd}
So now, consider what happens when you include Mata source code directly in
the ado-file.  When the ado-file is loaded, is {cmd:matastrict} set {cmd:on},
or is it set {cmd:off}?  The answer is that it is {cmd:off}, because when you
include the Mata source code inside an ado-file, {cmd:matastrict} is
temporarily switched off when the ado-file is loaded even if the user running
the ado-file has previously set it on.

{pstd}
For example, {cmd:varsum.ado} could read

	{hline 43} begin varsum.ado {hline 6}
	{cmd}program varsum
		version {ccl stata_version}
		syntax varname [if] [in]
		marksample touse
		mata: calcsum("`varlist'", "`touse'")
		display as txt "  sum = " as res r(sum)
	end

	version {ccl stata_version}
	mata:
	void calcsum(varname, touse)
	{c -(}{col 50}{txt:(note absence of declarations)}
		st_view(x, ., varname, touse)
		st_numscalar("r(sum)", colsum(x))
	}
	end{txt}
	{hline 43} end varsum.ado {hline 8}

{pstd}
and it will work even when run by users who have {cmd:set} {cmd:matastrict} 
{cmd:on}.

{pstd}
Similarly, in an ado-file, you can {cmd:set} {cmd:matastrict} {cmd:on}
and that will not affect the setting after the ado-file is loaded, so 
{cmd:varsum.ado} could read

	{hline 43} begin varsum.ado {hline 6}
	{cmd}program varsum
		version {ccl stata_version}
		syntax varname [if] [in]
		marksample touse
		mata: calcsum("`varlist'", "`touse'")
		display as txt "  sum = " as res r(sum)
	end

	version {ccl stata_version}
	mata:
	mata set matastrict on

	void calcsum(string scalar varname, string scalar touse)
	{
		real colvector  x

		st_view(x, ., varname, touse)
		st_numscalar("r(sum)", colsum(x))
	}
	end{txt}
	{hline 43} end varsum.ado {hline 8}

{pstd}
and not only will it work, but running {cmd:varsum} will not change the 
user's {cmd:matastrict} setting.

{pstd}
This preserving and restoring of {cmd:matastrict} is something that is 
done only for ado-files when they are loaded.


{marker remarks6}{...}
{title:Advice:  Some useful Mata functions}

{pstd}
In the {cmd:calcsum()} subroutine, we used the {cmd:colsum()} function --
see {bf:{help mf_sum:[M-5] sum()}} -- to obtain the sum:

	{cmd}void calcsum(string scalar varname, string scalar touse)
	{
		real colvector  x

		st_view(x, ., varname, touse)
		st_numscalar("r(sum)", colsum(x))
	}{txt}

{pstd} 
We could instead have coded 

	{cmd}void calcsum(string scalar varname, string scalar touse)
	{
		real colvector  x
		real scalar     i, sum

		st_view(x, ., varname, touse)
		sum = 0 
		for (i=1; i<=rows(x); i++) sum = sum + x[i]

		st_numscalar("r(sum)", sum)
	}{txt}

{pstd}
The first way is preferred.  Rather than construct explicit loops, it is
better to call functions that calculate the desired result when such functions
exist.  Unlike ado-code, however, when such functions do not exist, you can
code explicit loops and still obtain good performance.

{pstd}
Another set of functions we recommend are 
documented in 
{bf:{help mf_cross:[M-5] cross()}}, 
{bf:{help mf_crossdev:[M-5] crossdev()}}, 
and 
{bf:{help mf_quadcross:[M-5] quadcross()}}.

{pstd}
{cmd:cross()} makes calculations of the form

		{it:X}'{it:X} 
		{it:X}'{it:Z} 
		{it:X}{cmd:'diag(}{it:w}{cmd:)}{it:X}
		{it:X}{cmd:'diag(}{it:w}{cmd:)}{it:Z}


{pstd}
{cmd:crossdev()} makes calculations of the form

		({it:X}:-{it:x})'({it:X}:-{it:x})
		({it:X}:-{it:x})'({it:Z}:-{it:z})
		({it:X}:-{it:x})'{cmd:diag(}{it:w})({it:X}:-{it:x})
		({it:X}:-{it:x})'{cmd:diag(}{it:w})({it:Z}:-{it:z})

{pstd}
Both these functions could easily escape your attention because the 
matrix expressions themselves are so easily written in Mata.
The functions, however, are quicker, use less
memory, and sometimes are more accurate.
Also, quad-precision versions of the functions exist; 
{bf:{help mf_quadcross:[M-5] quadcross()}}.
{p_end}
