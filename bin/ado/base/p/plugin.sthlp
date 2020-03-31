{smcl}
{* *! version 1.1.9  15mar2019}{...}
{vieweralsosee "[P] plugin" "mansection P plugin"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-0] mata" "help mata"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] Automation" "help automation"}{...}
{vieweralsosee "[P] program" "help program"}{...}
{viewerjumpto "Syntax" "plugin##syntax"}{...}
{viewerjumpto "Description" "plugin##description"}{...}
{viewerjumpto "Links to PDF documentation" "plugin##linkspdf"}{...}
{viewerjumpto "Options" "plugin##options"}{...}
{viewerjumpto "Remarks" "plugin##remarks"}{...}
{p2colset 1 15 17 2}{...}
{p2col:{bf:[P] plugin} {hline 2}}Load a plugin{p_end}
{p2col:}({mansection P plugin:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmdab:pr:ogram} {it:handle} , {cmdab:plug:in}
           [{cmd:using(}{it:filespec}{cmd:)}]


{marker description}{...}
{title:Description}

{pstd}
In addition to using ado-files and Mata, you can add new commands to Stata
by using the C language by following a set of programming conventions and
dynamically linking your compiled library into Stata.  The {cmd:program}
command with the {cmd:plugin} option finds plugins and loads (dynamically
links) them into Stata.

{pstd}
If you are interested in writing plugins for Stata in Java, see
{helpb java_intro:[P] Java intro}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection P pluginRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{opt plugin} specifies that plugins be found and loaded into Stata.

{phang}
{opt using(filespec)} specifies a file, {it:filespec}, containing the plugin.
If you do not specify {cmd:using()}, {cmd:program} assumes that the file is
named {it:handle}{cmd:.plugin} and can be found along the
{help adopath:ado-path}.


{marker remarks}{...}
{title:Remarks}

{pstd}
Plugins are most useful for methods that require the greatest possible speed
and involve heavy looping, recursion, or other computationally demanding
approaches.  They may also be useful if you have a solution that is already
programmed in C.

{pstd}
For complete documentation on plugin programming and loading compiled programs
into Stata, see

{pin}
      {browse "https://www.stata.com/plugins/"}
{p_end}

{pstd}
For tutorials on C and C++ plugins, see the following Stata blog entries:
{p_end}

        {browse "https://blog.stata.com/2018/02/15/programming-an-estimation-command-in-stata-preparing-to-write-a-plugin/":Programming an estimation command in Stata: Preparing to write a plugin}
        {browse "https://blog.stata.com/2018/02/20/programming-an-estimation-command-in-stata-writing-a-c-plugin/":Programming an estimation command in Stata: Writing a C plugin}
        {browse "https://blog.stata.com/2018/02/22/programming-an-estimation-command-in-stata-writing-a-c-plugin-2/":Programming an estimation command in Stata: Writing a C++ plugin}
