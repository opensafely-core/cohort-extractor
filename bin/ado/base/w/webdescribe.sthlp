{smcl}
{* *! version 1.1.3  15oct2018}{...}
{viewerdialog webdescribe "dialog webdescribe"}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] describe" "help describe"}{...}
{vieweralsosee "[D] webuse" "help webuse"}{...}
{viewerjumpto "Syntax" "webdescribe##syntax"}{...}
{viewerjumpto "Description" "webdescribe##description"}{...}
{viewerjumpto "Options" "webdescribe##options"}{...}
{viewerjumpto "Examples" "webdescribe##examples"}{...}
{title:Title}

{p2colset 5 24 26 2}{...}
{p2col :{hi:[D] webdescribe} {hline 2}}Describe data over the web{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang}
Describe data over the web

{p 8 17 2}
{cmd:webdescribe} {it:filename} [{cmd:,}
 {it:{help webdescribe##webdescribe_options:describe_options}}]


{phang}
Report URL from which data will be described

{p 8 17 2}
{cmd:webdescribe query}

{phang}
Specify URL from which data will be described

{p 8 17 2}
{cmd:webdescribe set} {it:URL}


{phang}
Reset URL to default

{p 8 17 2}
{cmd:webdescribe set}


{synoptset 20 tabbed}{...}
{marker webdescribe_options}{...}
{synopthdr :webdescribe_options}
{synoptline}
{syntab :Main}
{synopt :{opt s:hort}}display only general information{p_end}
{synopt :{opt var:list}}store {cmd:r(varlist)} and {cmd:r(sortlist)} in addition to usual stored results; programmer's option{p_end}
{synoptline}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
{cmd:webdescribe} produces a summary of the Stata-format dataset located by
appending {it:filename} to the URL.

{pstd}
When setting {it:URL}, you can specify just the name of the website,
but it will not produce an error if you prepend {cmd:http://} or
{cmd:https://} or append the trailing slash.

{pstd}
Using {cmd:webdescribe set} {it:URL} enables you to describe multiple
datasets from the same URL without having to specify the URL each time.
This is a convenience command that simply calls {helpb describe} with
the appropriate option to describe a file located at URL.  The two
examples below are equivalent.

{pstd}
The name, storage type, display format, value label, and variable label
for each variable along with summary information about the dataset are
displayed by default.


{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt short} displays only the summary information about the dataset:
number of observations, number of variables, size, sort order, dataset
label, and the time the file was last saved.

{phang} 
{opt varlist}, an option for programmers, specifies that, in addition to the
usual stored results, {cmd:r(varlist)} and {cmd:r(sortlist)} also be stored.
{cmd:r(varlist)} contains the names of the variables in the dataset.
{cmd:r(sortlist)} contains the names of the variables by which the data
are sorted.


{marker examples}{...}
{title:Examples}

    {cmd}. webdescribe census
    . webdescribe cancer, short
    . webdescribe set http://www.mydata.org/
    . webdescribe set www.mydata.org
    . webdescribe query
    . webdescribe set{txt}
