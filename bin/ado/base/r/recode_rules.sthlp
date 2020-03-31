{smcl}
{* *! version 1.0.3  11feb2011}{...}
{* this hlp file is called by recode.dlg}{...}
{vieweralsosee "[D] recode" "help recode"}{...}
{viewerjumpto "Understanding recode rules" "recode_rules##understand"}{...}
{viewerjumpto "Examples of recode rules" "recode_rules##examples"}{...}
{marker understand}{...}
{title:Understanding recode rules}

{pstd}
There can be an arbitrary number of rules, each contained in parentheses.  The
most common forms for {it:rule} are

{center:{c TLC}{hline 16}{c TT}{hline 15}{c TT}{hline 27}{c TRC}}
{center:{c |} {it:rule}           {c |} Example       {c |} Meaning                   {c |}}
{center:{c LT}{hline 16}{c +}{hline 15}{c +}{hline 27}{c RT}}
{center:{c |}{cmd:(}{it:#} {cmd:=} {it:#}{cmd:)}         {c |} (3 = 1)       {c |} 3 recoded to 1            {c |}}
{center:{c |}{cmd:(}{it:#} {it:#} {cmd:=} {it:#}{cmd:)}       {c |} (2 . = 9)     {c |} 2 and . recoded to 9      {c |}}
{center:{c |}{cmd:(}{it:#}{cmd:/}{it:#} {cmd:=} {it:#}{cmd:)}       {c |} (1/5 = 4)     {c |} 1 through 5 recoded to 4  {c |}}
{center:{c |}{cmd:(}{cmdab:nonm:issing} {cmd:=} {it:#}{cmd:)}{c |} (nonmiss = 8) {c |} all other nonmissing to 8 {c |}}
{center:{c |}{cmd:(}{cmdab:mis:sing} {cmd:=} {it:#}{cmd:)}   {c |} (miss = 9)    {c |} all other missings to 9   {c |}}
{center:{c BLC}{hline 16}{c BT}{hline 15}{c BT}{hline 27}{c BRC}}


{marker examples}{...}
{title:Examples of recode rules}


{cmd:Single Rules:}

{phang} {cmd:(3 = 5)} or {cmd:(1/3 5.5 = min)}  or {cmd:(1/3 max = .)} or
{cmd:(else = 0)}

{phang} {cmd:(missing = 0 None)} or {cmd: (1 4 7 9 11/13 = 1 blue)} or
{cmd:(* = 20.5 "the rest")}

{cmd}
{cmd:Multiple rules:}

{phang} (1=2) (2=1)

{phang} (1 2.1 3/5=1) (6/10=2)

{phang} (1 2 3/5=1) (6/10.5=2)

{phang} (1=6) (2=5.5) (3=4) (4=3) (5=2) (6=1) (nonmiss=0) (miss=.)

{phang} (min/0 = 0) (1/max = 1)

{phang} (min/19=1) (20/29=2) (30/39=3) (40/49=4) (50/max=5)

{phang} (.=.) (missing =.a)

{phang} (.=.) (.a = .a) (missing =.a)

{phang} (1 2=1 low) (3=2 medium) (4 5=3 high) (nonmiss=9) (miss=.)


Multiple rules with labels:

{phang} (1 2 = 1 low) (3 = 2 medium) (4 5 = 3 high) (nonmissing = 9 "something else") (missing = .)

{phang} (missing = 0 None) (min/10.7 = 1 first) (10.8/30.3 = 2 second)
(30.4/max = 3 third)

{txt}
{title:Recode rules in general}

{pstd}
In general each {it:rule} is of the form

{p 12 12 2}
({it:element} [ {it:element ...}] {cmd:=} {it:el} [{cmd:"}{it:label}{cmd:"}])

{p 23 23 2}({cmdab:nonm:missing =} {it:el} [{cmd:"}{it:label}{cmd:"}])

{p 27 27 2}({cmdab:mis:sing =} {it:el} [{cmd:"}{it:label}{cmd:"}])

{p 26 26 2}({cmd:else} | {cmd:*} {cmd:=} {it:el} [{cmd:"}{it:label}{cmd:"}])

{p 8 8 2}
{it:element} is of the form

{p 12 12 2}
{it:el} | {it:el}{cmd:/}{it:el}

{p 8 8 2}
and {it:el} is

{p 12 12 2}
{it:#} | {cmd:min} | {cmd:max}

{pstd}
The keyword rules {cmd:missing}, {cmd:nonmissing} and {cmd:else} have to
be specified as the last rules.  {cmd:else} may not be combined with
{cmd:missing} and {cmd:nonmissing}.
{p_end}
