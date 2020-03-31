{smcl}
{* *! version 1.2.14  17may2019}{...}
{viewerdialog reshape "dialog reshape"}{...}
{vieweralsosee "[D] reshape" "mansection D reshape"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] char" "help char"}{...}
{vieweralsosee "[D] save" "help save"}{...}
{vieweralsosee "[D] stack" "help stack"}{...}
{vieweralsosee "[D] xpose" "help xpose"}{...}
{viewerjumpto "Syntax" "reshape##syntax"}{...}
{viewerjumpto "Menu" "reshape##menu"}{...}
{viewerjumpto "Description" "reshape##description"}{...}
{viewerjumpto "Links to PDF documentation" "reshape##linkspdf"}{...}
{viewerjumpto "Options" "reshape##options"}{...}
{viewerjumpto "Remarks" "reshape##remarks"}{...}
{viewerjumpto "Examples" "reshape##examples"}{...}
{viewerjumpto "Video examples" "reshape##video"}{...}
{viewerjumpto "Stored results" "reshape##results"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[D] reshape} {hline 2}}Convert data from wide to long form and vice versa{p_end}
{p2col:}({mansection D reshape:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{marker overview}{...}
{p 4 8 2}
Overview

           {it:long}
        {c TLC}{hline 12}{c TRC}                  {it:wide}
        {c |} {it:i  j}  {it:stub} {c |}                 {c TLC}{hline 16}{c TRC}
        {c |}{hline 12}{c |}                 {c |} {it:i}  {it:stub}{bf:1} {it:stub}{bf:2} {c |}
        {c |} 1  {bf:1}   4.1 {c |}     reshape     {c |}{hline 16}{c |}
        {c |} 1  {bf:2}   4.5 {c |}   <{hline 9}>   {c |} 1    4.1   4.5 {c |}
        {c |} 2  {bf:1}   3.3 {c |}                 {c |} 2    3.3   3.0 {c |}
        {c |} 2  {bf:2}   3.0 {c |}                 {c BLC}{hline 16}{c BRC}
        {c BLC}{hline 12}{c BRC}

        To go from long to wide:

     {col 45}{it:j} existing variable
     {col 44}/
     	        {cmd:reshape wide} {it:stub}{cmd:, i(}{it:i}{cmd:) j(}{it:j}{cmd:)}

        To go from wide to long:

     	        {cmd:reshape long} {it:stub}{cmd:, i(}{it:i}{cmd:) j(}{it:j}{cmd:)}
     {col 44}\
     {col 45}{it:j} new variable

        To go back to long after using {cmd:reshape wide}:

    	        {cmd:reshape long}

        To go back to wide after using {cmd:reshape long}:

                {cmd:reshape wide}


{p 4 8 2}
Basic syntax

{phang2}
Convert data from wide form to long form

{p 12 16 2}
{cmd:reshape} {helpb reshape##overview:long}
{it:stubnames}{cmd:,}
{cmd:i(}{varlist}{cmd:)}
[{it:{help reshape##options_table:options}}]

{phang2}
Convert data from long form to wide form

{p 12 16 2}
{cmd:reshape} {helpb reshape##overview:wide}
{it:stubnames}{cmd:,}
{cmd:i(}{varlist}{cmd:)}
[{it:{help reshape##options_table:options}}]

{phang2}
Convert data back to long form after using reshape wide

{p 12 16 2}
{cmd:reshape} {helpb reshape##overview:long}

{phang2}
Convert data back to wide form after using reshape long

{p 12 16 2}
{cmd:reshape} {helpb reshape##overview:wide}

{phang2}
List problem observations when reshape fails

{p 12 16 2}
{cmd:reshape error}

{marker options_table}{...}
{p2colset 10 37 39 2}{...}
{p2col :{it:options}}Description{p_end}
{col 8}{hline}
{p2col 8 37 37 2 :* {opth i(varlist)}}use {it:varlist} as the ID variables{p_end}
{p2col :{cmd:j(}{varname} [{it:values}]{cmd:)}}long->wide: {it:varname}, existing variable{p_end}
{p2col :}wide->long: {it:varname}, new variable{p_end}
{p2col :}optionally specify values to subset {it:varname}{p_end}
{p2col :{cmdab:s:tring}}{it:varname} is a string variable (default is numeric){p_end}
{col 8}{hline}
{p2colreset}{...}
{p 8 8 2}* {opt i(varlist)} is required.{p_end}

{p 8 8 2}where {it:values} is{space 2}{it:#}[{cmd:-}{it:#}] [...]
{space 13}if {it:varname} is numeric{p_end}
{col 53}(default)
{col 26}{cmd:"}{it:string}{cmd:"} [{cmd:"}{it:string}{cmd:"} ...]{...}
{col 51}if {it:varname} is string

{p 8 8 2}
and where {it:stubnames} are variable names (long->wide), or stubs of 
variable names (wide->long), and either way, may contain {cmd:@}, denoting
where {it:j} appears or is to appear in the name.

{p 8 8 2}
In the example above, when we wrote "{cmd:reshape} {cmd:wide}
    {it:stub}", we could have written "{cmd:reshape} {cmd:wide}
    {it:stub}{cmd:@}" because {it:j} by default ends up as a suffix.
    Had we written {it:stu}{cmd:@}{it:b}, then the wide variables would 
    have been named {it:stu}{cmd:1}{it:b} and {it:stu}{cmd:2}{it:b}.


{p 4 8 2}
Advanced syntax

{p 8 17 2}
{cmd:reshape i} {varlist}

{p 8 17 2}
{cmd:reshape j} {varname} [{it:values}] [{it:,} {opt s:tring}]

{p 8 17 2}
{cmd:reshape xij} {it:fvarnames} [{cmd:,} {opt at:wl(chars)}]

{p 8 17 2}
{cmd:reshape xi} [{varlist}]

{p 8 17 2}
{cmd:reshape} [{opt q:uery}]

{p 8 17 2}
{cmd:reshape clear}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Data > Create or change data > Other variable-transformation commands}
    {bf:> Convert data between wide and long}


{marker description}{...}
{title:Description}

{pstd}
{cmd:reshape} converts data from wide to long form and vice versa.  


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D reshapeQuickstart:Quick start}

        {mansection D reshapeRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opth i(varlist)} specifies the variables whose unique values denote a
logical observation. {opt i()} is required.

{phang}
{cmd:j(}{varname} [{it:values}]{cmd:)} specifies the variable whose
unique values denote a subobservation.  {it:values} lists the unique values to
be used from {it:varname}, which typically are not explicitly stated because
{cmd:reshape} will determine them automatically from the data.

{phang}
{opt string} specifies that {cmd:j()} may contain string values.

{phang}
{cmd:atwl(}{it:chars}{cmd:)}, available only with the advanced syntax 
and not shown in the dialog box, specifies that
{help u_glossary##plainascii:plain ASCII} {it:chars} be substituted for
the {cmd:@} character when converting the data from wide to long form.


{marker remarks}{...}
{title:Remarks}

{pstd}
Before using {cmd:reshape}, you need to determine whether the data are in long
or wide form.  You also must determine the logical observation ({it:i}) and the
subobservation ({it:j}) by which to organize the data.  Suppose that you had the
following data, which could be organized in wide or long form as follows:


{center:         (wide form)           }

{center:{it:i}{space 9}....... x_{it:ij} ........}
{center:{cmd:id  sex   inc80   inc81   inc82}}
{center:{hline 31}}
{center: 1    0    5000    5500    6000}
{center: 2    1    2000    2200    3300}
{center: 3    0    3000    2000    1000}


{center:      (long form)      }

{center:{it:i}{space 5}{it:j}{space 11}x_{it:ij}}
{center:{cmd:id   year   sex    inc }}
{center:{hline 23}}
{center: 1     80     0   5000 }
{center: 1     81     0   5500 }
{center: 1     82     0   6000 }
{center: 2     80     1   2000 }
{center: 2     81     1   2200 }
{center: 2     82     1   3300 }
{center: 3     80     0   3000 }
{center: 3     81     0   2000 }
{center: 3     82     0   1000 }


{pstd}
Given these data, you could use {cmd:reshape} to convert from one form to the
other:

{p 8 43 2}{cmd:. reshape long inc, i(id) j(year)}{space 2}(goes from top form to
bottom){p_end}
{p 8 43 2}{cmd:. reshape wide inc, i(id) j(year)}{space 2}(goes from bottom form
to top)

{pstd}
See {manlink D reshape} for a detailed discussion and examples for both the
basic and advanced syntax.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse reshape1}

{pstd}List the data{p_end}
{phang2}{cmd:. list}

{pstd}Convert data from wide form to long form{p_end}
{phang2}{cmd:. reshape long inc ue, i(id) j(year)}

{pstd}List the result{p_end}
{phang2}{cmd:. list, sepby(id)}

{pstd}Convert data back from long form to wide form (quick way){p_end}
{phang2}{cmd:. reshape wide}

{pstd}Convert data back from long form to wide form (explicit way){p_end}
{phang2}{cmd:. reshape wide inc ue, i(id) j(year)}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse reshape2, clear}

{pstd}List the data{p_end}
{phang2}{cmd:. list}

{pstd}Try to convert the data from wide form to long form{p_end}
{phang2}{cmd:. reshape long inc, i(id) j(year)}

{pstd}List the problem observations{p_end}
{phang2}{cmd:. reshape error}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse reshape3, clear}

{pstd}List the data{p_end}
{phang2}{cmd:. list}

{pstd}Convert the data from wide form to long form{p_end}
{phang2}{cmd:. reshape long inc@r ue, i(id) j(year)}

{pstd}List the result{p_end}
{phang2}{cmd:. list, sepby(id)}

{pstd}Convert the data back from long form to wide form (quick way){p_end}
{phang2}{cmd:. reshape wide}

{pstd}Convert the data back from long form to wide form (explicit way){p_end}
{phang2}{cmd:. reshape wide inc@r ue, i(id) j(year)}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse reshape4, clear}

{pstd}List the data{p_end}
{phang2}{cmd:. list}

{pstd}Convert the data from wide form to long form, allowing {cmd:sex} to 
take on string values{p_end}
{phang2}{cmd:. reshape long inc, i(id) j(sex) string}

{pstd}List the result{p_end}
{phang2}{cmd:. list, sepby(id)}

{pstd}Convert the data back from long form to wide form (quick way){p_end}
{phang2}{cmd:. reshape wide}

{pstd}Convert the data back from long form to wide form (explicit way){p_end}
{phang2}{cmd:. reshape wide inc, i(id) j(sex) string}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse reshape5, clear}

{pstd}List the data{p_end}
{phang2}{cmd:. list}

{pstd}Convert the data from long-long form to wide-wide form (two {it:j}
variables){p_end}
{phang2}{cmd:. reshape wide @inc, i(hid year) j(sex) string}{p_end}
{phang2}{cmd:. reshape wide minc finc, i(hid) j(year)}

{pstd}List the result{p_end}
{phang2}{cmd:. list}

{pstd}Convert the data back from wide-wide form to long-long form{p_end}
{phang2}{cmd:. reshape long minc finc, i(hid) j(year)}{p_end}
{phang2}{cmd:. reshape long @inc, i(hid year) j(sex) string}

{pstd}List the result{p_end}
{phang2}{cmd:. list}{p_end}
    {hline}


{marker video}{...}
{title:Video examples}

{phang}
{browse "https://www.youtube.com/watch?v=gkcYpw8CtCw":How to reshape data from long format to wide format}

{phang}
{browse "https://www.youtube.com/watch?v=Bx9kVdkr9oY":How to reshape data from wide format to long format}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:reshape} stores the following characteristics with the data (see
{manhelp char P}):

{synoptset 20 tabbed}{...}
{synopt:{cmd:_dta[ReS_i]}}{cmd:i} variable names{p_end}
{synopt:{cmd:_dta[ReS_j]}}{cmd:j} variable name{p_end}
{synopt:{cmd:_dta[ReS_jv]}}{cmd:j} values, if specified{p_end}
{synopt:{cmd:_dta[ReS_Xij]}}{cmd:X_ij} variable names{p_end}
{synopt:{cmd:_dta[ReS_Xij_n]}}number of {cmd:X_ij} variables{p_end}
{synopt:{cmd:_dta[ReS_Xij_long}{it:#}{cmd:]}}name of {it:#}th {cmd:X_ij} variable in long form{p_end}
{synopt:{cmd:_dta[ReS_Xij_wide}{it:#}{cmd:]}}name of {it:#}th {cmd:X_ij} variable in wide form{p_end}
{synopt:{cmd:_dta[ReS_Xi]}}{cmd:X_i} variable names, if specified{p_end}
{synopt:{cmd:_dta[ReS_atwl]}}{cmd:atwl()} value, if specified{p_end}
{synopt:{cmd:_dta[ReS_str]}}{cmd:1} if option {cmd:string} specified, {cmd:0}
    otherwise{p_end}
{p2colreset}{...}
