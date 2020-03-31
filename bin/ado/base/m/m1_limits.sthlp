{smcl}
{* *! version 1.1.9  19jun2018}{...}
{vieweralsosee "[M-1] Limits" "mansection M-1 Limits"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-3] mata memory" "help mata_memory"}{...}
{vieweralsosee "[M-5] mindouble()" "help mf_mindouble"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-1] Intro" "help m1_intro"}{...}
{viewerjumpto "Summary" "m1_limits##summary"}{...}
{viewerjumpto "Description" "m1_limits##description"}{...}
{viewerjumpto "Links to PDF documentation" "m1_limits##linkspdf"}{...}
{viewerjumpto "Remarks" "m1_limits##remarks"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[M-1] Limits} {hline 2}}Limits and memory utilization
{p_end}
{p2col:}({mansection M-1 Limits:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker summary}{...}
{title:Summary}

    Limits:
	                              Minimum       Maximum
	{hline 55}
	Scalars, vectors, matrices
	    rows                         0          2^48 - 1 
	    columns                      0          2^48 - 1

        String elements, length          0        2,147,483,647
	{hline 55}

    Size approximations:
				      Memory requirements
	{hline 66}
	real matrices                 {it:oh} + {it:r}*{it:c}*8 
        complex matrices              {it:oh} + {it:r}*{it:c}*16 
        pointer matrices              {it:oh} + {it:r}*{it:c}*8
	string matrices               {it:oh} + {it:r}*{it:c}*8 + {it:total_length_of_strings}
	{hline 66}
	where {it:r} and {it:c} represent the number of rows and columns and where
	{it:oh} is overhead and is approximately 64 bytes
       

{marker description}{...}
{title:Description}

{pstd}
Mata imposes limits, but those limits are of little importance 
compared with the memory requirements.  Mata stores matrices in memory and 
requests the memory for them from the operating system.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-1 LimitsRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
Mata requests (and returns) memory from the operating system as it needs it,
and if the operating system cannot provide it, Mata issues the following error:

	: {cmd:x = foo(A, B)}
	             {err}foo():  3900  unable to allocate{txt} ...
		   {err}<istmt>:     -  function returned error{txt}
	r(3900);

{pstd}
Stata's {cmd:set min_memory} and {cmd:set max_memory} values 
(see {bf:{help memory:[D] memory}}) 
play no role in Mata or, at least, they play no direct role.  
{p_end}
