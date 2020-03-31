{smcl}
{* *! version 1.1.13  19oct2017}{...}
{viewerdialog encode "dialog encode"}{...}
{viewerdialog decode "dialog decode"}{...}
{vieweralsosee "[D] encode" "mansection D encode"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] compress" "help compress"}{...}
{vieweralsosee "[D] destring" "help destring"}{...}
{vieweralsosee "[D] generate" "help generate"}{...}
{viewerjumpto "Syntax" "encode##syntax"}{...}
{viewerjumpto "Menu" "encode##menu"}{...}
{viewerjumpto "Description" "encode##description"}{...}
{viewerjumpto "Links to PDF documentation" "encode##linkspdf"}{...}
{viewerjumpto "Options for encode" "encode##options_encode"}{...}
{viewerjumpto "Options for decode" "encode##options_decode"}{...}
{viewerjumpto "Examples" "encode##examples"}{...}
{viewerjumpto "Video example" "encode##video"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[D] encode} {hline 2}}Encode string into numeric and vice versa{p_end}
{p2col:}({mansection D encode:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
String variable to numeric variable

{p 8 16 2}
{opt en:code} {varname} {ifin} {cmd:,} {opth g:enerate(newvar)}
[{opt l:abel}{cmd:(}{it:name}{cmd:)} {opt noe:xtend}]


{phang}
Numeric variable to string variable

{p 8 16 2}
{opt dec:ode} {varname} {ifin} {cmd:,} {opth g:enerate(newvar)}
[{opt maxl:ength}{cmd:(}{it:#}{cmd:)}]


{marker menu}{...}
{title:Menu}

    {title:encode}

{phang2}
{bf:Data > Create or change data > Other variable-transformation commands}
    {bf:> Encode value labels from string variable}

    {title:decode}

{phang2}
{bf:Data > Create or change data > Other variable-transformation commands}
     {bf:> Decode strings from labeled numeric variable}


{marker description}{...}
{title:Description}

{pstd}
{cmd:encode} creates a new variable named {newvar} based on the string
variable {varname}, creating, adding to, or just using (as necessary) the
value label {it:newvar} or, if specified, {it:name}.  Do not
use {cmd:encode} if {it:varname} contains numbers that merely happen to be
stored as strings; instead, use
{cmd:generate} {it:newvar} {cmd:=} {opt real(varname)} or {cmd:destring};
see {helpb real()} or {manhelp destring D}.

{pstd}
{cmd:decode} creates a new string variable named {it:newvar} based on the
"encoded" numeric variable {it:varname} and its value label.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D encodeQuickstart:Quick start}

        {mansection D encodeRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options_encode}{...}
{title:Options for encode}

{phang}
{opth generate(newvar)} is required and specifies the name of the variable to
be created.

{phang}
{opt label(name)} specifies the name of the value label to be created or used
and added to if the named value label already exists.  If {opt label()} is not
specified, {cmd:encode} uses the same name for the label as it does
for the new variable.

{phang}
{opt noextend} specifies that {varname} not be encoded if there are values
contained in {it:varname} that are not present in {opt label(name)}.  By
default, any values not present in {opt label(name)} will be added to that
label.


{marker options_decode}{...}
{title:Options for decode}

{phang}
{opth generate(newvar)} is required and specifies the name of the variable to
be created.

{phang}
{opt maxlength(#)} specifies how many bytes of the value label to retain;
{it:#} must be between 1 and 32,000.  The default is {cmd:maxlength(32000)}.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse hbp2}{p_end}
{phang2}{cmd:. describe sex}

{pstd}Create numeric variable {cmd:gender} based on the string variable
{cmd:sex} and create value label {cmd:gender}{p_end}
{phang2}{cmd:. encode sex, generate(gender)}

{pstd}List values of {cmd:sex} and {cmd:gender}{p_end}
{phang2}{cmd:. list sex gender in 1/4}

{pstd}List values of {cmd:sex} and {cmd:gender}, but show numeric values of
{cmd:gender} rather than the labels{p_end}
{phang2}{cmd:. list sex gender in 1/4, nolabel}

{pstd}List the names and contents of the {cmd:gender} value label{p_end}
{phang2}{cmd:. label list gender}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse hbp2, clear}{p_end}
{phang2}{cmd:. describe sex}

{pstd}Create numeric variable {cmd:gender} based on the string variable
{cmd:sex} and create value label {cmd:sexlbl}{p_end}
{phang2}{cmd:. encode sex, generate(gender) label(sexlbl)}

{pstd}Describe the {cmd:gender} variable{p_end}
{phang2}{cmd:. describe gender}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse hbp2, clear}{p_end}
{phang2}{cmd:. describe sex}

{pstd}Create value label {cmd:gender}{p_end}
{phang2}{cmd:. label define gender 1 "female" 2 "male"}

{pstd}Change the value of {cmd:sex} in the second observation to {cmd:other}
{p_end}
{phang2}{cmd:. replace sex = "other" in 2}

{pstd}Create numeric variable {cmd:gender} based on the string variable
{cmd:sex}, adding to value label {cmd:gender} as necessary{p_end}
{phang2}{cmd:. encode sex, generate(gender)}

{pstd}List the names and contents of the {cmd:gender} value label{p_end}
{phang2}{cmd:. label list gender}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse hbp3, clear}{p_end}
{phang2}{cmd:. describe female}{p_end}
{phang2}{cmd:. label list sexlbl}

{pstd}Create string variable {cmd:sex} based on the numeric variable
{cmd:female}{p_end}
{phang2}{cmd:. decode female, generate(sex)}

{pstd}Describe variable {cmd:sex}{p_end}
{phang2}{cmd:. describe sex}

{pstd}List values of {cmd:female} and {cmd:sex}{p_end}
{phang2}{cmd:. list female sex in 1/4}

{pstd}List values of {cmd:female} and {cmd:sex}, but show numeric values of
{cmd:female} rather than the labels{p_end}
{phang2}{cmd:. list female sex in 1/4, nolabel}{p_end}
    {hline}


{marker video}{...}
{title:Video example}

{phang2}{browse "https://www.youtube.com/watch?v=ZRWHjdIZyxo":How to convert categorical string variables to labeled numeric variables}
{p_end}
