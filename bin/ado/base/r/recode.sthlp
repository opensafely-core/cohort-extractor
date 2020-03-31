{smcl}
{* *! version 1.2.5  19oct2017}{...}
{viewerdialog recode "dialog recode"}{...}
{vieweralsosee "[D] recode" "mansection D recode"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] generate" "help generate"}{...}
{vieweralsosee "[D] mvencode" "help mvencode"}{...}
{viewerjumpto "Syntax" "recode##syntax"}{...}
{viewerjumpto "Menu" "recode##menu"}{...}
{viewerjumpto "Description" "recode##description"}{...}
{viewerjumpto "Links to PDF documentation" "recode##linkspdf"}{...}
{viewerjumpto "Options" "recode##options"}{...}
{viewerjumpto "Examples" "recode##examples"}{...}
{viewerjumpto "Video example" "recode##video"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[D] recode} {hline 2}}Recode categorical variables{p_end}
{p2col:}({mansection D recode:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}Basic syntax{p_end}
{p 8 16 2}
{cmd:recode} {varlist} {cmd:(}{it:rule}{cmd:)} 
[{cmd:(}{it:rule}{cmd:)} {it:...}]
[{cmd:,} {opth g:enerate(newvar)}]


{phang}Full syntax{p_end}
{p 8 16 2}
{cmd:recode} {varlist} {cmd:(}{it:erule}{cmd:)} 
[{cmd:(}{it:erule}{cmd:)} {it:...}] {ifin}
[{cmd:,} {it:options}]


{phang}
where the most common forms for {it:rule} are

{center:{c TLC}{hline 16}{c TT}{hline 13}{c TT}{hline 27}{c TRC}}
{center:{c |} {it:rule}           {c |} Example     {c |} Meaning                   {c |}}
{center:{c LT}{hline 16}{c +}{hline 13}{c +}{hline 27}{c RT}}
{center:{c |} {it:#} {cmd:=} {it:#}          {c |} 3 = 1       {c |} 3 recoded to 1            {c |}}
{center:{c |} {it:#} {it:#} {cmd:=} {it:#}        {c |} 2 . = 9     {c |} 2 and . recoded to 9      {c |}}
{center:{c |} {it:#}{cmd:/}{it:#} {cmd:=} {it:#}        {c |} 1/5 = 4     {c |} 1 through 5 recoded to 4  {c |}}
{center:{c |} {opt nonm:issing} {cmd:=} {it:#} {c |} nonmiss = 8 {c |} all other nonmissing to 8 {c |}}
{center:{c |} {opt mis:sing} {cmd:=} {it:#}    {c |} miss = 9    {c |} all other missings to 9   {c |}}
{center:{c BLC}{hline 16}{c BT}{hline 13}{c BT}{hline 27}{c BRC}}

{phang}
where {it:erule} has the form

{p 8 17 2}
{it:element} [{it:element ...}] {cmd:=} {it:el} [{cmd:"}{it:label}{cmd:"}]

{p 8 20 2} 
{opt nonm:issing =} {it:el} [{cmd:"}{it:label}{cmd:"}]

{p 8 17 2}
{opt mis:sing =} {it:el} [{cmd:"}{it:label}{cmd:"}]

{p 8 14 2}
{cmd:else} | {cmd:*} {cmd:=} {it:el} [{cmd:"}{it:label}{cmd:"}]

{phang}
{it:element} has the form

{p 8 12 2}
{it:el} | {it:el}{cmd:/}{it:el}

{phang}
and {it:el} is

{p 8 11 2}
{it:#} | {cmd:min} | {cmd:max}

{phang}
The keyword rules {cmd:missing}, {cmd:nonmissing}, and {cmd:else} must be the
last rules specified.  {cmd:else} may not be combined with {cmd:missing} or 
{cmd:nonmissing}.

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab :Options}
{synopt :{opth g:enerate(newvar)}}generate {it:newvar} containing transformed
variables; default is to replace existing variables{p_end}
{synopt :{opt pre:fix(str)}}generate new variables with {it:str} prefix{p_end}
{synopt :{opt l:abel(name)}}specify a name for the value label defined by the
transformation rules{p_end}
{synopt :{opt copy:rest}}copy out-of-sample values from original
variables{p_end}
{synopt :{opt t:est}}test that rules are invoked and do not overlap{p_end}
{synoptline}
{p2colreset}{...}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Data > Create or change data > Other variable-transformation commands}
       {bf:> Recode categorical variable}


{marker description}{...}
{title:Description}

{pstd}
{cmd:recode} changes the values of numeric variables according to
the rules specified.  Values that do not meet any of the conditions of the
rules are left unchanged, unless an {it:otherwise} rule is specified.

{pstd}
A range {it:#1}{cmd:/}{it:#2} refers to all (real and integer)
values between {it:#1} and {it:#2}, including the boundaries {it:#1} and
{it:#2}.  This interpretation of {it:#1}{cmd:/}{it:#2} differs from that in
{help numlist:numlists}. 

{pstd}
{cmd:min} and {cmd:max} provide a convenient way to refer to the minimum and
maximum for each variable in {varlist} and may be used in both the from-value
and the to-value parts of the specification.  Combined with {helpb if} and
{helpb in}, the minimum and maximum are determined over the restricted dataset.

{pstd}
The keyword rules specify transformations for values not changed by
the previous rules:

{p2colset 9 26 27 2}{...}
{p2col: {opt nonm:issing}}all nonmissing values not changed by the rules{p_end}
{p2col: {opt mis:sing}}all missing values ({cmd:.}, {cmd:.a}, {cmd:.b},..., {cmd:.z}) not changed by the rules{p_end}
{p2col: {cmd:else}}all nonmissing and missing values not changed by the rules{p_end}
{p2col: {cmd:*}}synonym for {cmd:else}
{p2colreset}{...}

{pstd}
{cmd:recode} provides a convenient way to define value labels for the
generated variables during the definition of the transformation, reducing the
risk of inconsistencies between the definition and value labeling of
variables.  Value labels may be defined for integer values and for the
extended {help missing:missing values} ({cmd:.a}, {cmd:.b},..., {cmd:.z}), but
not for noninteger values and or for sysmiss ({cmd:.}).

{pstd}
Although this is not shown in the syntax diagram, the parentheses around the
{it:rule}s and keyword clauses are optional if you transform only one 
variable and if you do not define value labels.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D recodeQuickstart:Quick start}

        {mansection D recodeRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{dlgtab:Options}

{phang}
{opth generate(newvar)} specifies the names of the variables that will contain
the transformed variables.  {opt into()} is a synonym for {opt generate()}.
Values outside the range implied by {helpb if} or {helpb in} are set to missing
({cmd:.}), unless the {opt copyrest} option is specified.

{pmore}
If {opt generate()} is not specified, the input variables are overwritten;
values outside the {opt if} or {opt in} range are not modified.  Overwriting
variables is dangerous (you cannot undo changes, value labels may be wrong,
etc.), so we strongly recommend specifying {opt generate()}.

{phang}
{opt prefix(str)} specifies that the recoded variables be returned in new
variables formed by prefixing the names of the original variables with
{it:str}.

{phang}
{opt label(name)} specifies a name for the value label defined from the
transformation rules.  {opt label()} may be defined only with {opt generate()}
(or its synonym, {opt into()}) and {opt prefix()}.  If a variable is
recoded, the label name defaults to {newvar} unless a label with that name
already exists.

{phang}
{opt copyrest} specifies that out-of-sample values be copied from the original
variables.  In line with other data management commands, {cmd:recode} defaults
to setting {newvar} to missing ({cmd:.}) outside the observations selected by
{help if:{bf:if} {it:exp}} and {help in:{bf:in} {it:range}}.

{phang}
{opt test} specifies that Stata test whether rules are ever invoked or that
rules overlap; for example, {cmd:(1/5=1) (3=2)}.


{marker examples}{...}
{title:Examples}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse recxmpl}

{pstd}List the data{p_end}
{phang2}{cmd:. list}

{pstd}For {cmd:x}, change 1 to 2, leave all other values unchanged, and store
the results in {cmd:nx}{p_end}
{phang2}{cmd:. recode x (1 = 2), gen(nx)}

{pstd}List the result{p_end}
{phang2}{cmd:. list x nx}

{pstd}For {cmd:x1}, swap 1 and 2, and store the results in {cmd:nx1}{p_end}
{phang2}{cmd:. recode x1 (1 = 2) (2 = 1), gen(nx1)}

{pstd}List the result{p_end}
{phang2}{cmd:. list x1 nx1}

{pstd}For {cmd:x2}, collapse 1 and 2 into 1, change 3 to 2, change 4 through 7
to 3, and store the results in {cmd:nx2}{p_end}
{phang2}{cmd:. recode x2 (1 2 = 1) (3 = 2) (4/7 = 3), gen(nx2)}

{pstd}List the result{p_end}
{phang2}{cmd:. list x2 nx2}

{pstd}For {cmd:x1}, {cmd:x2}, and {cmd:x3}, change the direction of 1, 2, ...,
8, moving 8 to 1, 7 to 2, etc., and store the transformed variables in
{cmd:newx1}, {cmd:newx2}, and {cmd:newx3}{p_end}
{phang2}{cmd:. recode x1-x3 (1=8) (2=7) (3=6) (4=5) (5=4) (6=3) (7=2) (8=1),}
           {cmd:pre(new) test}{p_end}

{pstd}List the result{p_end}
{phang2}{cmd:. list x1 newx1 x2 newx2 x3 newx3}

    {hline}
{pstd}Setup{p_end}
{phang2}{cmd:. webuse fullauto, clear}

{pstd}For {cmd:rep77} and {cmd:rep78}, collapse 1 and 2 into 1, change 3 to 2,
collapse 4 and 5 into 3, store results in {cmd:newrep77} and {cmd:newrep78},
and define a new value label {cmd:newrep}{p_end}
{phang2}{cmd:. recode rep77 rep78 (1 2 = 1 "Below average") (3 = 2 Average)}
              {cmd:(4 5 = 3 "Above average"), pre(new) label(newrep)}{p_end}

{pstd}List the old and new value label{p_end}
{phang2}{cmd:. label list repair newrep}

{pstd}List some of the data{p_end}
{phang2}{cmd:. list *rep77 *rep78 in 1/10, nolabel}{p_end}
    {hline}


{txt}{phang}Tip:  long {cmd:recode} commands may conveniently be written using
the line continuation {cmd:///}.  For example
{cmd}

    . recode x y (1 2 = 1 low)  ///
                 (3   = 2 medium)  ///
                 (4 5 = 3 high)  ///
                 (nonmissing = 9 "something else")  ///
                 (missing = .)  ///
               , gen(Rx Ry) label(Cat3){txt}


{marker video}{...}
{title:Video example}

{phang2}{browse "https://www.youtube.com/watch?v=XWVaXN2KwmA":How to create a categorical variable from a continuous variable}
{p_end}
