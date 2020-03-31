{smcl}
{* *! version 1.1.4  15may2018}{...}
{vieweralsosee "[M-5] logit()" "mansection M-5 logit()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Statistical" "help m4_statistical"}{...}
{viewerjumpto "Syntax" "mf_logit##syntax"}{...}
{viewerjumpto "Description" "mf_logit##description"}{...}
{viewerjumpto "Conformability" "mf_logit##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_logit##diagnostics"}{...}
{viewerjumpto "Source code" "mf_logit##source"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[M-5] logit()} {hline 2}}Log odds and complementary log-log
{p_end}
{p2col:}({mansection M-5 logit():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:real matrix}{bind:     }
{cmd:logit(}{it:real matrix X}{cmd:)}

{p 8 12 2}
{it:real matrix}{bind:  }
{cmd:invlogit(}{it:real matrix X}{cmd:)}

{p 8 12 2}
{it:real matrix}{bind:   }
{cmd:cloglog(}{it:real matrix X}{cmd:)}

{p 8 12 2}
{it:real matrix} 
{cmd:invcloglog(}{it:real matrix X}{cmd:)}


{marker description}{...}
{title:Description}

{p 4 4 2}
    {cmd:logit(}{it:X}{cmd:)} 
    returns the log of the odds ratio of the elements of {it:X}, 
    ln{c -(}{it:x}/(1-{it:x}){c )-}.

{p 4 4 2}
    {cmd:invlogit(}{it:X}{cmd:)} 
    returns the inverse of the {cmd:logit()} of the elements of {it:X}, 
    exp({it:x})/{c -(}1+exp({it:x}){c )-}.

{p 4 4 2}
    {cmd:cloglog(}{it:X}{cmd:)} 
    returns the complementary log-log of the elements of {it:X}, 
    ln{c -(}-ln(1-{it:x}){c )-}.

{p 4 4 2}
    {cmd:invcloglog(}{it:X}{cmd:)} 
    returns the elementwise inverse of {cmd:cloglog()} of the elements of
    {it:X},
    1-exp{c -(}-exp({it:x}){c )-}.


{marker conformability}{...}
{title:Conformability}

{p 4 4 2}
All functions return a matrix of the same dimension as input
containing element-by-element calculated results.

    
{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
    {cmd:logit(}{it:X}{cmd:)} and 
    {cmd:cloglog(}{it:X}{cmd:)}
    return missing when {it:x} <= 0 or {it:x} >= 1.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view logit.mata, adopath asis:logit.mata},
{view invlogit.mata, adopath asis:invlogit.mata},
{view cloglog.mata, adopath asis:cloglog.mata},
{view invcloglog.mata, adopath asis:invcloglog.mata}
{p_end}
