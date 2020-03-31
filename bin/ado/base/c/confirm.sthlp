{smcl}
{* *! version 1.2.6  25jan2019}{...}
{vieweralsosee "[P] confirm" "mansection P confirm"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] capture" "help capture"}{...}
{viewerjumpto "Syntax" "confirm##syntax"}{...}
{viewerjumpto "Description" "confirm##description"}{...}
{viewerjumpto "Links to PDF documentation" "confirm##linkspdf"}{...}
{viewerjumpto "Option" "confirm##option"}{...}
{viewerjumpto "Examples" "confirm##examples"}{...}
{p2colset 1 16 18 2}{...}
{p2col:{bf:[P] confirm} {hline 2}}Argument verification{p_end}
{p2col:}({mansection P confirm:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 25 2}{cmdab:conf:irm} {cmdab:e:xistence} {it:string}

{p 8 25 2}{cmdab:conf:irm} [{cmd:new}] {cmdab:f:ile} {it:{help filename}}

{p 8 25 2}{cmdab:conf:irm} [ {cmd:numeric} | {cmdab:str:ing} | {cmd:date} ]
{cmdab:fo:rmat} {it:string}

{p 8 25 2}{cmdab:conf:irm} [{cmd:new}] {cmd:frame} {it:name}

{p 8 25 2}{cmdab:conf:irm} {cmdab:name:s} {it:names}

{p 8 25 2}{cmdab:conf:irm} [{cmd:integer}] {cmdab:n:umber} {it:string}

{p 8 25 2}{cmdab:conf:irm} {cmdab:mat:rix} {it:string}

{p 8 25 2}{cmdab:conf:irm} {cmdab:sca:lar} {it:string}

{p 8 25 2}{cmdab:conf:irm} [ {cmd:new} | {cmd:numeric} | {cmdab:str:ing} |
{cmd:str#} |
{it:{help data_type:type}} ] {cmdab:v:ariable} {varlist} [{cmd:,} {opt ex:act}]

{p 4 25 2}where {it:type} is {c -(} {cmd:byte} | {cmd:int} | {cmd:long} |
{cmd:float} | {cmd:double} | {cmd:str}{it:#} | {cmd:strL} {c )-}


{marker description}{...}
{title:Description}

{pstd}
{cmd:confirm} verifies that the arguments following {cmd:confirm ...} are of
the claimed type and issues the appropriate error message and nonzero return
code if they are not.

{pstd}
{cmd:confirm} is useful in do-files and programs when you do not want to bother issuing your own error message.  {cmd:confirm} can also be combined with 
{cmd:capture} to detect and handle error conditions before they arise; see 
{helpb capture:[P] capture}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection P confirmRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker option}{...}
{title:Option}

{phang}
{opt exact} specifies that a match be declared only if the names specified in
{varlist} match. By default, names that are abbreviations of variables
are considered to be a match.


{marker examples}{...}
{title:Examples}

{pstd}{cmd:. confirm file `"c:\data\mydata.dta"'}

{pstd}{cmd:. confirm numeric variable price trunk rep78}

{pstd}You are writing a command that performs some action on each of the
variables in the local macro {it:varlist}.  The action should be different
for string (both {cmd:str}{it:#} and {cmd:strL}) and numeric variables.
The {cmd:confirm} command can be used
here in combination with the {helpb capture} command to switch between the
different actions:

	{cmd:foreach v of local {it:varlist} {c -(}}
		{cmd:capture confirm numeric variable `v'}
		{cmd:if !_rc {c -(}}
			{it:action for numeric variables}
		{cmd:{c )-}}
		{cmd:else {c -(}}
			{it:action for str# or strL variables}
		{cmd:{c )-}}
	{cmd:{c )-}}

{pstd}An alternative solution using inline expansion of the macro
function {cmd::type} (see {help local}) reads

	{cmd:foreach v of local varlist {c -(}}
		{cmd:if substr("`:type `v''",1,3) == "str" {c -(}}
			{it:action for string variables}
		{cmd:{c )-}}
		{cmd:else {c -(}}
			{it:action for numeric variables}
		{cmd:{c )-}}
	{cmd:{c )-}}

{pstd}If you need to differentiate between {cmd:str}{it:#} and {cmd:strL}
variables as well as numeric variables, you could instead code

	{cmd:foreach v of local {it:varlist} {c -(}}
		{cmd:capture confirm str# variable `v'}
		{cmd:if !_rc {c -(}}
			{it:action for str# variables}
		{cmd:{c )-}}
		{cmd:capture confirm strL variable `v'}
		{cmd:if !_rc {c -(}}
			{it:action for strL variables}
		{cmd:{c )-}}
		{cmd:capture confirm numeric variable `v'}
		{cmd:if !_rc {c -(}}
			{it:action for numeric variables}
		{cmd:{c )-}}
	{cmd:{c )-}}
