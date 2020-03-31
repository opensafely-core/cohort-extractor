{* *! version 1.0.3  06mar2015}{...}
    {cmd:collatorversion(}{it:loc}{cmd:)} 
{p2colset 8 22 22 2}{...}
{p2col: Description:}the version string of a collator based on locale
	{it:loc}{p_end}

{p2col:}The Unicode standard is constantly adding more characters and the sort
	key format may change as well.  This can cause
	{helpb f_ustrsortkey:ustrsortkey()} and
	{helpb f_ustrsortkeyex:ustrsortkeyex()} to produce incompatible sort
	keys between different versions of International Components for
	Unicode.  The version string can be used for versioning the sort keys
	to indicate when saved sort keys must be regenerated.{p_end}
{p2col: Range:}strings{p_end}
{p2colreset}{...}
