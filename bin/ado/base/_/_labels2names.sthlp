{smcl}
{* *! version 1.0.8  10aug2012}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] syntax" "help syntax"}{...}
{viewerjumpto "Syntax" "_labels2names##syntax"}{...}
{viewerjumpto "Description" "_labels2names##description"}{...}
{viewerjumpto "Options" "_labels2names##options"}{...}
{viewerjumpto "Examples" "_labels2names##examples"}{...}
{viewerjumpto "Stored results" "_labels2names##results"}{...}
{title:Title}

{p 4 27 2}
{hi:[P] _labels2names} {hline 2} Using value labels as Stata names


{marker syntax}{...}
{title:Syntax}

{phang2}
{cmd:_labels2names}
	[{varname}]
	{ifin}
	[{cmd:,}
		{opt m:issing} 
		{opt nolab:el}
		{opt stub(name)}
		{opt i:ndexfrom(#)}
		{opt noint:egers}
		{opt renum:ber}
		{opt n:amelist(names)}]


{marker description}{...}
{title:Description}

{pstd}
{cmd:_labels2names} is a programmer's tool that constructs Stata names for each
unique value of the categorical variable {it:varname}.  {cmd:_labels2names}
tries to use the value labels attached to {it:varname} to generate names
(identifiers), resorting to the value (if it is a nonnegative integer) or a
default name when the labels are not valid Stata names;
see {manhelp syntax P}.

{pstd}
{cmd:_labels2names} will ignore value labels that happen to be nonnegative
integers unless the {opt renumber} option is specified.


{marker options}{...}
{title:Options}

{phang}
{cmd:missing} requests that missing values be treated as valid
categories.

{phang}
{cmd:nolabel} causes {cmd:_labels2names} to ignore value labels attached to
{it:varname}.

{phang}
{opt stub(name)} specifies a stub for default name generation in cases where a
label is not a valid Stata name.  The default names are of the form
{it:name#}, where {it:#} is the index for the default name.

{phang}
{opt indexfrom(#)} specifies that the default names are to be indexed starting
from {it:#} instead of 1.

{phang}
{cmd:nointegers} prevents {cmd:_labels2names} from accepting nonnegative
integer values as valid names.

{phang}
{cmd:renumber} allows nonnegative integer value labels to remap the values
they represent.

{phang}
{opt namelist(names)} specifies an exclusion list; names that are not allowed.


{marker examples}{...}
{title:Examples}

    {cmd}. sysuse auto, clear
    {txt}(1978 Automobile Data)
    
    {cmd}. _labels2names foreign
    {txt}
    {cmd}. sreturn list
    
    {txt}macros:
             s(indexfrom) : "{res}3{txt}"
                s(labels) : "{res}Domestic Foreign{txt}"
              s(namelist) : "{res}Domestic Foreign{txt}"
                 s(names) : "{res}Domestic Foreign{txt}"
                 s(n_cat) : "{res}2{txt}"
    
    {cmd}. label define badlabs 1 "first cat" 2 "not.a.name" 3 "4" 4 "four"
    {txt}
    {cmd}. label val rep badlabs
    {txt}
    {cmd}. _labels2names rep, stub(mystub) index(3)
    {txt}
    {cmd}. sreturn list
    
    {txt}macros:
             s(indexfrom) : "{res}8{txt}"
                s(labels) : "{res}`"first cat"' not.a.name 4 four 5{txt}"
              s(namelist) : "{res}mystub3 mystub4 mystub5 four 5{txt}"
                 s(names) : "{res}mystub3 mystub4 mystub5 four 5{txt}"
                 s(n_cat) : "{res}5{txt}"


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:_labels2names} stores the following in {cmd:s()}:

{p2colset 9 25 32 2}{...}
{pstd}Macros:{p_end}
{p2col :{cmd:s(n_cat)}}number of categories in {it:varname}{p_end}
{p2col :{cmd:s(names)}}names generated from {it:varname}{p_end}
{p2col :{cmd:s(namelist)}}{it:names}
	from {opt namelist()} option with {cmd:s(names)} appended, for
	subsequent calls{p_end}
{p2col :{cmd:s(labels)}}label
	associated with each name in {cmd:s(names)}{p_end}
{p2col :{cmd:s(indexfrom)}}new
	value for {opt indexfrom()} option on subsequent calls{p_end}
{p2colreset}{...}
