{smcl}
{* *! version 1.1.8  15oct2018}{...}
{vieweralsosee "[P] Automation" "mansection P Automation"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] plugin" "help plugin"}{...}
{viewerjumpto "Description" "automation##description"}{...}
{viewerjumpto "Links to PDF documentation" "automation##linkspdf"}{...}
{viewerjumpto "Remarks" "automation##remarks"}{...}
{p2colset 1 19 21 2}{...}
{p2col:{bf:[P] Automation} {hline 2}}Automation
{p_end}
{p2col:}({mansection P Automation:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
Automation (formerly known as OLE Automation) is a communication
mechanism between Microsoft Windows applications.  It provides an
infrastructure whereby Windows applications (automation clients) can access
and manipulate functions and properties implemented in another application
(automation server).  A Stata Automation object exposes internal Stata methods
and properties so that Windows programmers can write automation clients to
directly use the services provided by Stata.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection P AutomationRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd} 
A Stata Automation object is most useful for situations that require the
greatest flexibility to interact with Stata from community-contributed
applications.
A Stata Automation object enables users to directly access Stata macros,
scalars, stored results, and dataset information in ways besides the
usual log files.

{pstd}
For documentation on using a Stata Automation object, see

{pin}
	{browse "https://www.stata.com/automation/"}

{pstd}
Note that the standard Stata end-user license agreement (EULA)
does not permit Stata to be used as an embedded engine in a production
setting.  If you wish to use Stata in such a manner, please contact
StataCorp at {browse "mailto:service@stata.com":service@stata.com}.
{p_end}
