{smcl}
{* *! version 1.1.5  04apr2018}{...}
{findalias asfrnumlist}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[U] 11 Language syntax" "help language"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] numlist" "help nlist"}{...}
{vieweralsosee "[P] syntax" "help syntax"}{...}
{viewerjumpto "Remarks" "numlist##remarks"}{...}
{viewerjumpto "Examples" "numlist##examples"}{...}
{title:Title}

{pstd}
{findalias frnumlist} {hline 2} Number lists


{marker remarks}{...}
{title:Remarks}

{pstd}
See {help nlist} for the {cmd:numlist} programming command.

{pstd}
A {it:numlist} is a list of numbers with blanks or commas in between.  There
are a number of shorthand conventions to reduce the amount of typing
necessary.  For instance:

{p 8 32 2}{cmd:2} {space 19} just one number{p_end}
{p 8 32 2}{cmd:1 2 3} {space 15} three numbers{p_end}
{p 8 32 2}{cmd:3 2 1} {space 15} three numbers in reversed order{p_end}
{p 8 32 2}{cmd:.5 1 1.5} {space 12} three different numbers{p_end}
{p 8 32 2}{cmd:1 3 -2.17 5.12} {space 6} four numbers in jumbled order

{p 8 32 2}{cmd:1/3} {space 17} three numbers: 1, 2, 3{p_end}
{p 8 32 2}{cmd:3/1} {space 17} the same three numbers in reverse order{p_end}
{p 8 32 2}{cmd:5/8} {space 17} four numbers: 5, 6, 7, 8{p_end}
{p 8 32 2}{cmd:-8/-5} {space 15} four numbers: -8, -7, -6, -5{p_end}
{p 8 32 2}{cmd:-5/-8} {space 15} four numbers: -5, -6, -7, -8{p_end}
{p 8 32 2}{cmd:-1/2} {space 16} four numbers: -1, 0, 1, 2

{p 8 32 2}{cmd:1 2 to 4} {space 12} four numbers: 1, 2, 3, 4{p_end}
{p 8 32 2}{cmd:4 3 to 1} {space 12} four numbers: 4, 3, 2, 1{p_end}
{p 8 32 2}{cmd:10 15 to 30} {space 9} five numbers: 10, 15, 20, 25, 30

{p 8 32 2}{cmd:1 2:4} {space 15} same as {cmd:1 2 to 4}{p_end}
{p 8 32 2}{cmd:4 3:1} {space 15} same as {cmd:4 3 to 1}{p_end}
{p 8 32 2}{cmd:10 15:30} {space 12} same as {cmd:10 15 to 30}

{p 8 32 2}{cmd:1(1)3} {space 15} three numbers: 1, 2, 3{p_end}
{p 8 32 2}{cmd:1(2)9} {space 15} five numbers: 1, 3, 5, 7, 9{p_end}
{p 8 32 2}{cmd:1(2)10} {space 14} the same five numbers: 1, 3, 5, 7, 9{p_end}
{p 8 32 2}{cmd:9(-2)1} {space 14} five numbers: 9, 7, 5, 3, and 1{p_end}
{p 8 32 2}{cmd:-1(.5)2.5} {space 11} the numbers: -1, -.5, 0, .5, 1, 1.5, 2, 2.5

{p 8 32 2}{cmd:1[1]3} {space 15} same as {cmd:1(1)3}{p_end}
{p 8 32 2}{cmd:1[2]9} {space 15} same as {cmd:1(2)9}{p_end}
{p 8 32 2}{cmd:1[2]10} {space 14} same as {cmd:1(2)10}{p_end}
{p 8 32 2}{cmd:9[-2]1} {space 14} same as {cmd:9(-2)1}{p_end}
{p 8 32 2}{cmd:-1[.5]2.5} {space 11} same as {cmd:-1(.5)2.5}

{p 8 32 2}{cmd:1 2 3/5 8(2)12} {space 6} eight numbers: 1, 2, 3, 4, 5, 8, 10, 12{p_end}
{p 8 32 2}{cmd:1,2,3/5,8(2)12} {space 6} the same eight numbers{p_end}
{p 8 32 2}{cmd:1 2 3/5 8 10 to 12} {space 2} the same eight numbers{p_end}
{p 8 32 2}{cmd:1,2,3/5,8,10 to 12} {space 2} the same eight numbers{p_end}
{p 8 32 2}{cmd:1 2 3/5 8 10:12} {space 5} the same eight numbers

{pstd}
Advice:  Do not use commas to separate the entries -- use spaces
instead -- because commas are not always allowed.  You may use commas
when a {it:numlist} appears inside the parentheses of an option, but you may
not use commas in other cases.


{marker examples}{...}
{title:Examples}

{phang}{cmd:. sysuse uslifeexp}{p_end}
{phang}{cmd:. line le_wm year, ylabel(0 20(10)80)}

{phang}{cmd:. sysuse auto}{p_end}
{phang}{cmd:. centile price, centile(5 50 95)}{p_end}
{phang}{cmd:. forvalues i = 10(-2)1 {c -(}}{p_end}
{phang}{cmd:{space 2}2. display `i'}{p_end}
{phang}{cmd:{space 2}3. {c )-}}{p_end}
