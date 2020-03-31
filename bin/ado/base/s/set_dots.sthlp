{smcl}
{* *! version 1.0.0  24apr2019}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] query" "help query"}{...}
{vieweralsosee "[R] set" "help set"}{...}
{viewerjumpto "Syntax" "set_dots##syntax"}{...}
{viewerjumpto "Description" "set_dots##description"}{...}
{viewerjumpto "Option" "set_dots##option"}{...}
{title:Title}

{phang}Format settings for coefficient tables{p_end}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:set}
{cmd:dots}
{c -(}{opt on}{c |}{opt off}{c )-}
[{cmd:,} {cmdab:perm:anently}]


{marker description}{...}
{title:Description}

{pstd}
{cmd:set} {cmd:dots} allows you to control the default behavior for
commands that support the {opt dots()} option.

{pstd}
{cmd:set dots on} reports a dot each time statistics are computed from a
sample or resample of the dataset.

{pstd}
{cmd:set dots off} suppresses reporting dots.

{pstd}
The current setting is {cmd:set} {cmd:dots} {cmd:{ccl dots}}.

{pstd}
The following commands check the value of {cmd:c(dots)} to determine the
default {opt dots()} behavior.

{pmore}
{helpb bootstrap},
{helpb jackknife},
{helpb permute},
{helpb rolling},
{helpb simulate},
{helpb statsby},
{helpb svy bootstrap},
{helpb svy brr},
{helpb svy jackknife},
{helpb svy sdr},
{helpb threshold}
{p_end}


{marker option}{...}
{title:Option}

{phang}
{cmd:permanently} specifies that, in addition to making the change right now,
the setting be remembered and become the default setting when you invoke Stata.
{p_end}
