{smcl}
{* *! version 1.0.2  10jan2017}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] creturn" "help creturn"}{...}
{viewerjumpto "Syntax" "set_prefix##syntax"}{...}
{viewerjumpto "Description" "set_prefix##description"}{...}
{title:Title}

{p2colset 4 22 24 2}{...}
{p2col:{hi:[P] set prefix} {hline 2}}Add a prefix name to c(prefix)
{p_end}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:set}
{cmd:prefix}
{it:prefix_name}


{marker description}{...}
{title:Description}

{pstd}
{cmd:set} {cmd:prefix} adds {it:prefix_name} to {cmd:c(prefix)}, allowing
other programs to know which prefix commands are currently running.
{p_end}

{pstd}
The following prefix commands use {cmd:set} {cmd:prefix} to add their name to
{cmd:c(prefix)}:
{p_end}

{* do not add fmm to the list.}{...}
{pmore}
{helpb bayes},
{helpb bootstrap},
{helpb fp},
{helpb jackknife},
{helpb mfp},
{helpb mi},
{helpb nestreg},
{helpb permute},
{helpb rolling},
{helpb simulate},
{helpb statsby},
{helpb stepwise},
{helpb svy},
{helpb xi}
{p_end}

{pstd}
{cmd:c(prefix)} is reset to its original value when a program or do-file exits.
{p_end}
