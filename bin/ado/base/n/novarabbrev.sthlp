{smcl}
{* *! version 1.0.5  19oct2017}{...}
{vieweralsosee "[P] varabbrev" "mansection P varabbrev"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "set varabbrev" "help set_varabbrev"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] break" "help break"}{...}
{vieweralsosee "[P] unab" "help unab"}{...}
{viewerjumpto "Syntax" "novarabbrev##syntax"}{...}
{viewerjumpto "Description" "novarabbrev##description"}{...}
{viewerjumpto "Links to PDF documentation" "novarabbrev##linkspdf"}{...}
{viewerjumpto "Example" "novarabbrev##example"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[P] varabbrev} {hline 2}}Control variable abbreviation{p_end}
{p2col:}({mansection P varabbrev:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 25 2}{cmd:novarabbrev} {it:stata_command}

{p 8 25 2}{cmd:varabbrev}{bind:   }{it:stata_command}


    Typical usage is

	{cmd:novarabbrev {c -(}}
		{it:...}
	{cmd:{c )-}}


{marker description}{...}
{title:Description}

{pstd}
{cmd:novarabbrev} temporarily turns off variable abbreviation if it is on.
{cmd:varabbrev} temporarily turns on variable abbreviation if it is off.
Also see {helpb set varabbrev}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection P varabbrevRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker example}{...}
{title:Example}

    {cmd:program} {it:...}
            ... /* parse input */ ...
	    {cmd:novarabbrev {c -(}}
                    ... /* perform task */ ... 
	    {cmd:{c )-}}
            ...
    {cmd:end}
