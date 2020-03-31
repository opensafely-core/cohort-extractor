{smcl}
{* *! version 1.1.7  19oct2017}{...}
{vieweralsosee "[D] input" "mansection D input"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] edit" "help edit"}{...}
{vieweralsosee "[D] import" "help import"}{...}
{vieweralsosee "[D] save" "help save"}{...}
{viewerjumpto "Syntax" "input##syntax"}{...}
{viewerjumpto "Description" "input##description"}{...}
{viewerjumpto "Links to PDF documentation" "input##linkspdf"}{...}
{viewerjumpto "Options" "input##options"}{...}
{viewerjumpto "Examples" "input##examples"}{...}
{p2colset 1 14 16 2}{...}
{p2col:{bf:[D] input} {hline 2}}Enter data from keyboard{p_end}
{p2col:}({mansection D input:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 14 2}
{opt inp:ut}
[{varlist}]
[{cmd:,} {opt a:utomatic} {opt l:abel}]


{marker description}{...}
{title:Description}

{pstd}
{opt input} allows you to type data directly into the dataset in memory.

{pstd}
For most users, {helpb edit} is a better way to add observations to the
dataset because it automatically adjusts the storage type of variables, if
required, to accommodate new values.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D inputQuickstart:Quick start}

        {mansection D inputRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}{opt automatic} causes Stata to create value labels from the nonnumeric
data it encounters.  It also automatically widens the display format to fit
the longest label.  Specifying {opt automatic} implies {opt label},
even if you do not explicitly type the {opt label} option.

{phang}{opt label} allows you to type the labels (strings) instead of the
numeric values for
variables associated with value labels.  New value labels are not
automatically created unless {opt automatic} is specified.


{marker examples}{...}
{title:Examples}

    {hline}
    Setup
        {cmd:. clear all}

{pstd}Enter data on accident rates and speed limits directly into Stata{p_end}
        {cmd:. input acc_rate spdlimit}

                   acc_rate   spdlimit
          1.  {cmd:4.58 55}
          2.  {cmd:1.86 60}
          3.  {cmd:1.61 .}
          4.  {cmd:end}

{pstd}List the data{p_end}
        {cmd:. list}

{pstd}Add another observation{p_end}
        {cmd:. input}

                   acc_rate   spdlimit
          4.  {cmd:3.02 60}
          5.  {cmd:end}

{pstd}List the data{p_end}
        {cmd:. list}

{pstd}Add another variable{p_end}
        {cmd:. input acc_pts}

                   acc_pts
          1.  {cmd:4.6}
          2.  {cmd:4.4}
          3.  {cmd:2.2}
          4.  {cmd:4.7}

{pstd}List the data{p_end}
        {cmd:. list}

    {hline}
    Setup
        {cmd:. clear all}

{pstd}Enter data directly into Stata, where {cmd:name} and {cmd:sex} are
string variables{p_end}
        {cmd:. input str20 name age str6 sex}

                             name       age      sex
          1.  {cmd:"A. Doyle" 22  male}
          2.  {cmd:"Mary Hope" 37 "female"}
          3.  {cmd:"Guy Fawkes" 48 male}
          4.  {cmd:end}

{pstd}Note that {cmd:str20} means 20 bytes, not 20 Unicode characters (each
Unicode character requires up to 4 bytes) 

{pstd}List the data{p_end}
        {cmd:. list}

    {hline}
    Setup
        {cmd:. clear all}

{pstd}Same as previous example, but store {cmd:age} as a {cmd:byte}{p_end}
        {cmd:. input str20 name byte age str6 sex}

    {hline}
    Setup
        {cmd:. clear all}

{pstd}Enter data directly into Stata and store {cmd:make} as a {cmd:str20},
{cmd:foreign} and {cmd:rep78} as {cmd:byte}s, and {cmd:price} as the default
{cmd:float} storage type{p_end}
        {cmd:. input str20 make byte(foreign rep78) price}
    {hline}
