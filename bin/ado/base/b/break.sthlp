{smcl}
{* *! version 1.1.5  19oct2017}{...}
{vieweralsosee "[P] break" "mansection P break"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] capture" "help capture"}{...}
{vieweralsosee "[P] continue" "help continue"}{...}
{vieweralsosee "[P] quietly" "help noisily"}{...}
{vieweralsosee "[P] varabbrev" "help novarabbrev"}{...}
{viewerjumpto "Syntax" "break##syntax"}{...}
{viewerjumpto "Description" "break##description"}{...}
{viewerjumpto "Links to PDF documentation" "break##linkspdf"}{...}
{viewerjumpto "Example" "break##example"}{...}
{p2colset 1 14 16 2}{...}
{p2col:{bf:[P] break} {hline 2}}Suppress Break key{p_end}
{p2col:}({mansection P break:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 25 2}{cmd:nobreak} {it:stata_command}

{p 8 25 2}{cmd:break}{bind:   }{it:stata_command}


    Typical usage is

	{cmd:nobreak {c -(}}
		{it:...}
		{helpb capture} {helpb noisily} {cmd:break} {it:...}
		{it:...}
	{cmd:{c )-}}


{marker description}{...}
{title:Description}

{pstd}
{cmd:nobreak} temporarily turns off recognition of the {hi:Break} key.  It is
seldom used.  {cmd:break} temporarily reestablishes recognition of the 
{hi:Break} key within a {cmd:nobreak} block.  It is even more seldom used.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection P breakRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker example}{...}
{title:Example}

    {cmd:program} {it:...}
            {it:...}
	    {cmd:nobreak {c -(}}
		    {cmd:rename `myv' Result}
		    {cmd:list Result in 1/5}
		    {cmd:rename Result `myv'}
	    {cmd:{c )-}}
            {it:...}
    {cmd:end}
