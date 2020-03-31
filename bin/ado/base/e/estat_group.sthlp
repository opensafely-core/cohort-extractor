{smcl}
{* *! version 1.0.4  23may2018}{...}
{viewerdialog estat "dialog estat"}{...}
{vieweralsosee "[ME] estat group" "mansection ME estatgroup"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[ME] mecloglog" "help mecloglog"}{...}
{vieweralsosee "[ME] meglm" "help meglm"}{...}
{vieweralsosee "[ME] meintreg" "help meintreg"}{...}
{vieweralsosee "[ME] melogit" "help melogit"}{...}
{vieweralsosee "[ME] menbreg" "help menbreg"}{...}
{vieweralsosee "[ME] menl" "help menl"}{...}
{vieweralsosee "[ME] meologit" "help meologit"}{...}
{vieweralsosee "[ME] meoprobit" "help meoprobit"}{...}
{vieweralsosee "[ME] mepoisson" "help mepoisson"}{...}
{vieweralsosee "[ME] meprobit" "help meprobit"}{...}
{vieweralsosee "[ME] mestreg" "help mestreg"}{...}
{vieweralsosee "[ME] metobit" "help metobit"}{...}
{vieweralsosee "[ME] mixed" "help mixed"}{...}
{viewerjumpto "Syntax" "estat group##syntax"}{...}
{viewerjumpto "Menu for estat" "estat group##menu_estat"}{...}
{viewerjumpto "Description" "estat group##description"}{...}
{viewerjumpto "Links to PDF documentation" "estat_group##linkspdf"}{...}
{viewerjumpto "Example" "estat group##example"}{...}
{p2colset 1 21 23 2}{...}
{p2col:{bf:[ME] estat group} {hline 2}}Summarize the composition of the
nested groups{p_end}
{p2col:}({mansection ME estatgroup:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{cmd:estat} {opt gr:oup}


INCLUDE help menu_estat


{marker description}{...}
{title:Description}

{pstd}
{cmd:estat group} reports the number of groups and minimum, average, and
maximum group sizes for each level of the model.  Model levels are identified
by the corresponding group variable in the data.  Because groups are treated
as nested, the information in this summary may differ from what you would get
if you used the {cmd:tabulate} command on each group variable individually.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection ME estatgroupRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker example}{...}
{title:Example}

{pstd}Setup{p_end}
{phang2}{cmd:. webuse productivity}{p_end}
{phang2}{cmd:. mixed gsp private emp hwy water other unemp || region: ||}
             {cmd:state:}{p_end}

{pstd}Summarize composition of nested groups{p_end}
{phang2}{cmd:. estat group}{p_end}
