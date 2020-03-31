{smcl}
{* *! version 1.2.2  19oct2017}{...}
{vieweralsosee "[FN] String functions" "mansection FN Stringfunctions"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "help functions" "help functions"}{...}
{vieweralsosee "help string functions" "help string_functions"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "FAQ: What are regular expressions and how can I use them in Stata?" "browse http://www.stata.com/support/faqs/data/regex.html"}{...}
{viewerjumpto "Functions" "f_regexm##functions"}{...}
{viewerjumpto "Examples" "f_regexm##examples"}{...}
{p2colset 1 26 28 2}{...}
{p2col:{bf:[FN] String functions}}
{p_end}
{p2col:({mansection FN Stringfunctions:View complete PDF manual entry})}{p_end}
{p2colreset}{...}


{marker functions}{...}
{title:Functions}

INCLUDE help f_regexm


{marker examples}{...}
{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}

{pstd}List makes and models of cars whose make begin with the capital letter
"B"{p_end}
{phang2}{cmd:. generate bbegin = regexm(make, "^B")}{p_end}
{phang2}{cmd:. list make if bbegin == 1}
   
{pstd}Or, all on one line{p_end}
{phang2}{cmd:. list make if regexm(make, "^B") == 1}
   
{pstd}List makes and models of cars where the letters "ck" appear anywhere in
the make or model{p_end}
{phang2}{cmd:. list make if regexm(make, "ck") == 1}
   
{pstd}List makes and models of cars whose model ends with a digit{p_end}
{phang2}{cmd:. list make if regexm(make, "[0-9]$") == 1}

{pstd}Generate a new variable {cmd:make2} equal to {cmd:make}, then replace
{cmd:make2} with {cmd:"found"} if {cmd:make2} begins with the capital letter
"B" and ends with a three-digit number followed by a single lowercase
letter{p_end}
{phang2}{cmd:. generate make2 = make}{p_end}
{phang2}{cmd:. replace make2 = regexr(make2, "^B.*[0-9][0-9][0-9][a-z]$",}
            {cmd:"found")}{p_end}
{phang2}{cmd:. list make make2 if make != make2}{p_end}

{pstd}Convert a phone number of the form (123) 456-7890 to the form
123-456-7890:{p_end}
{phang2}{cmd:. clear}{p_end}
{phang2}{cmd:. input str15 number}

                         number
             1. "(123) 456-7890"
             2. "(800) STATAPC"
             3. end

{phang2}{cmd:. gen str newnum = regexs(1) + "-" + regexs(2)}
               {cmd:if regexm(number, "^\(([0-9]+)\) (.*)")}{p_end}
{phang2}{cmd:. list number newnum}{p_end}
