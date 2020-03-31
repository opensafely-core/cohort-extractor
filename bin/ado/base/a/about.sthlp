{smcl}
{* *! version 1.6.3  10may2018}{...}
{viewerdialog about "dialog about_dlg"}{...}
{vieweralsosee "[R] about" "mansection R about"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[U] 3 Resources for learning and using Stata" "help stata"}{...}
{vieweralsosee "stata/ic" "help stataic"}{...}
{vieweralsosee "stata/se" "help statase"}{...}
{vieweralsosee "stata/mp" "help statamp"}{...}
{vieweralsosee "[R] which" "help which"}{...}
{viewerjumpto "Syntax" "about##syntax"}{...}
{viewerjumpto "Menu" "about##menu"}{...}
{viewerjumpto "Description" "about##description"}{...}
{viewerjumpto "Links to PDF documentation" "about##linkspdf"}{...}
{viewerjumpto "Remarks" "about##remarks"}{...}
{p2colset 1 14 16 2}{...}
{p2col:{bf:[R] about} {hline 2}}Display information about your Stata
{p_end}
{p2col:}({mansection R about:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

    {cmd:about}


{marker menu}{...}
{title:Menu}

{phang}
{bf:Help > About Stata}


{marker description}{...}
{title:Description}

{pstd}
{cmd:about} displays information about your version of Stata.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection R aboutRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
If you are running Stata for Windows, information about memory is also
displayed:

         {cmd:. about}

         Stata/MP {ccl stata_version} for Windows (64-bit x86-64)
	 Revision 17 Sep 2019
	 Copyright 1985-2019 StataCorp LLC

	 Total physical memory:     {cmd:8388608 KB}
	 Available physical memory:  {cmd:937932 KB}

	 {cmd}10-user 32-core Stata network perpetual license:
	        Serial number:  {ccl stata_version}
	          Licensed to:  Alan R. Riley
	                        StataCorp{txt}
