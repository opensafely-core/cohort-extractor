{smcl}
{* *! version 1.1.11  30sep2019}{...}
{vieweralsosee "[P] preserve" "mansection P preserve"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] nopreserve option" "help nopreserve"}{...}
{vieweralsosee "[D] snapshot" "help snapshot"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] macro" "help tempfile"}{...}
{viewerjumpto "Syntax" "preserve##syntax"}{...}
{viewerjumpto "Description" "preserve##description"}{...}
{viewerjumpto "Links to PDF documentation" "preserve##linkspdf"}{...}
{viewerjumpto "Options" "preserve##options"}{...}
{viewerjumpto "Remarks" "preserve##remarks"}{...}
{viewerjumpto "Technical notes" "preserve##technote"}{...}
{p2colset 1 17 19 2}{...}
{p2col:{bf:[P] preserve} {hline 2}}Preserve and restore data{p_end}
{p2col:}({mansection P preserve:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

    Preserve data

{p 8 17 2}{cmd:preserve} [{cmd:,} {cmdab:ch:anged}]


    Restore data

{p 8 16 2}{cmd:restore} [{cmd:,} {cmd:not} {cmdab:pres:erve}]


    Set maximum memory for fast storage by {cmd:preserve}

{p 8 12 2}
{cmd:set max_preservemem} {it:amt}
[{cmd:,} {opt perm:anently}]

{phang}
where {it:amt} is {it:#}[{cmd:b}|{cmd:k}|{cmd:m}|{cmd:g}], and the
default unit is {cmd:b}.


{marker description}{...}
{title:Description}

{pstd}
{cmd:preserve} preserves the data, guaranteeing that data will be restored
after program termination.

{pstd}
{cmd:restore} forces a restore of the data now.

{pstd}
{cmd:set} {cmd:max_preservemem}, available only in Stata/MP,
controls the maximum amount of memory {cmd:preserve} will use to store
preserved datasets in memory.  Once this limit is exceeded, {cmd:preserve}
will store datasets on disk.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection P preserveRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}{cmd:changed} instructs {cmd:preserve} to preserve only the
flag indicating that the data have changed since the last save.  Use of this
option is strongly discouraged; see the 
{it:{help preserve##technote:technical note}}.

{phang}{cmd:not} instructs {cmd:restore} to cancel the previous
{cmd:preserve}.

{phang}{cmd:preserve} instructs {cmd:restore} to restore the data now, but not
to cancel the restoration of the data again at program conclusion.  If
{cmd:preserve} is not specified, the scheduled restoration at program
conclusion is canceled.

{phang}
{opt permanently} instructs {cmd:set} {cmd:max_preservemem}
    that, in addition to making the change right now, the new limit
    be remembered and become the default setting when you invoke Stata.

{phang}
{opt once}
    is not shown in the syntax diagram but is allowed with 
    {cmd:set max_preservemem}.  It is for use by system administrators
    and allows them to set {cmd:max_preservemem} such that users cannot modify
    it; see {it:{help memory##sysadmin:Notes for system administrators}}
    in {manhelp memory D:memory}.


{marker remarks}{...}
{title:Remarks}

{pstd}
{cmd:preserve} and {cmd:restore} deal with the programming problem where the
user's data must be changed to achieve the desired result but, when the
program concludes, the programmer wishes to undo the damage done to the data.
When {cmd:preserve} is issued, the user's data are preserved.  The data
in memory remain unchanged.  When the program or do-file concludes, the user's
data are automatically restored.

{pstd}
After a {cmd:preserve}, the programmer can also instruct Stata to
restore the data now with the {cmd:restore} command.  This is useful when the
programmer needs the original data back and knows that no more damage will be
done to the data.  {cmd:restore,} {cmd:preserve} can be used when the
programmer needs the data back but plans further damage.  {cmd:restore,}
{cmd:not} can be used when the programmer wishes to cancel the previous
{cmd:preserve} and to have the data currently in memory returned to the user.

{pstd}
For speed, Stata/MP uses {helpb frames} to preserve datasets to memory rather
than writing them to disk.  It does so unless the {cmd:max_preservemem} limit
has been reached in terms of memory consumed by preserved datasets.  Once the
limit has been reached, Stata/MP falls back to writing preserved datasets to
disk.  Stata/SE and Stata/IC are typically used on computers with less memory
and as such always preserve datasets on disk.

{pstd}
The default setting for {cmd:set} {cmd:max_preservemem} is {cmd:1g}, meaning 1
gigabyte.  If {it:amt} is set to {cmd:0b} (0 bytes), {cmd:preserve} will
always use disk storage.  If {it:amt} is set to {cmd:.}, {cmd:preserve} will
use as much memory as the operating system is willing to supply.  The memory
used by {cmd:preserve} is in addition to the memory used by other datasets you
may have in memory and is not included in your {cmd:max_memory} setting (see
{manhelp memory D:memory}).  Keep this in mind when changing this setting.


{marker technote}{...}
{title:Technical notes}

{pstd}
We said above that with {cmd:set} {cmd:max_preservemem}, if you set {it:amt}
to {cmd:0b} (0 bytes), {cmd:preserve} will use disk storage.  In fact, if you
set {it:amt} to anything less than the size of one of Stata's data segments
(see {cmd:set} {cmd:segmentsize} in {manhelp memory D:memory}), {cmd:preserve}
will always use disk storage.  You can type {cmd:query} {cmd:memory} to see
the current {cmd:segmentsize} and {cmd:max_preservemem} settings.

{pstd}
{cmd:preserve,} {cmd:changed} is best avoided, although it is very
fast.  {cmd:preserve,} {cmd:changed} does not preserve the data; it merely
records whether the data have changed since the data were last saved (as
mentioned by {cmd:describe} and as checked by {cmd:exit} and {cmd:use} when
the user does not also say {cmd:clear}) and restores the flag at the
conclusion of the program.  The programmer must ensure that the data really
have not changed.

{pstd}
As long as your programs use temporary variables, as created by {cmd:tempvar}
(see {helpb macro:[P] macro}), the changed-since-last-saved flag would not be
changed anyway -- Stata can track such temporary changes to the data that it
will, itself, be able to undo.  In fact, we cannot think of one use for
{cmd:preserve,} {cmd:changed}, and included it only to preserve the happiness
of our more imaginative users.
{p_end}
