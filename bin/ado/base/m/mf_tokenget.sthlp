{smcl}
{* *! version 1.1.9  15may2018}{...}
{vieweralsosee "[M-5] tokenget()" "mansection M-5 tokenget()"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] gettoken" "help gettoken"}{...}
{vieweralsosee "[M-5] invtokens()" "help mf_invtokens"}{...}
{vieweralsosee "[P] tokenize" "help tokenize"}{...}
{vieweralsosee "[M-5] tokens()" "help mf_tokens"}{...}
{vieweralsosee "[M-5] ustrword()" "help mf_ustrword"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[M-4] Programming" "help m4_programming"}{...}
{vieweralsosee "[M-4] String" "help m4_string"}{...}
{viewerjumpto "Syntax" "mf_tokenget##syntax"}{...}
{viewerjumpto "Description" "mf_tokenget##description"}{...}
{viewerjumpto "Links to PDF documentation" "mf_tokenget##linkspdf"}{...}
{viewerjumpto "Remarks" "mf_tokenget##remarks"}{...}
{viewerjumpto "Conformability" "mf_tokenget##conformability"}{...}
{viewerjumpto "Diagnostics" "mf_tokenget##diagnostics"}{...}
{viewerjumpto "Source code" "mf_tokenget##source"}{...}
{p2colset 1 21 23 2}{...}
{p2col:{bf:[M-5] tokenget()} {hline 2}}Advanced parsing
{p_end}
{p2col:}({mansection M-5 tokenget():View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 12 2}
{it:t} = 
{cmd:tokeninit(}[{it:wchars}
[{cmd:,} {it:pchars}
[{cmd:,} {it:qchars}
[{cmd:,} {it:allownum}
[{cmd:,} {it:allowhex}]]]]]{cmd:)}

{p 8 12 2}
{it:t} = 
{cmd:tokeninitstata()}


{p 8 12 2}
{it:void}{bind:            }
{cmd:tokenset(}{it:t}{cmd:,}
{it:string scalar s}{cmd:)}


{p 8 12 2}
{it:string rowvector}
{cmd:tokengetall(}{it:t}{cmd:)}

{p 8 12 2}
{it:string scalar}{bind:   }
{cmd:tokenget(}{it:t}{cmd:)}

{p 8 12 2}
{it:string scalar}{bind:   }
{cmd:tokenpeek(}{it:t}{cmd:)}

{p 8 12 2}
{it:string scalar}{bind:   }
{cmd:tokenrest(}{it:t}{cmd:)}


{p 8 12 2}
{it:real scalar}{bind:     }
{cmd:tokenoffset(}{it:t}{cmd:)}

{p 8 12 2}
{it:void}{bind:            }
{cmd:tokenoffset(}{it:t}{cmd:,}
{it:real scalar offset}{cmd:)}


{p 8 12 2}
{it:string scalar}{bind:   }
{cmd:tokenwchars(}{it:t}{cmd:)}

{p 8 12 2}
{it:void}{bind:            }
{cmd:tokenwchars(}{it:t}{cmd:,}
{it:string scalar} {it:wchars}{cmd:)}


{p 8 12 2}
{it:string rowvector}
{cmd:tokenpchars(}{it:t}{cmd:)}

{p 8 12 2}
{it:void}{bind:            }
{cmd:tokenpchars(}{it:t}{cmd:,}
{it:string rowvector} {it:pchars}{cmd:)}


{p 8 12 2}
{it:string rowvector}
{cmd:tokenqchars(}{it:t}{cmd:)}

{p 8 12 2}
{it:void}{bind:            }
{cmd:tokenqchars(}{it:t}{cmd:,}
{it:string rowvector} {it:qchars}{cmd:)}


{p 8 12 2}
{it:real scalar}{bind:     }
{cmd:tokenallownum(}{it:t}{cmd:)}

{p 8 12 2}
{it:void}{bind:            }
{cmd:tokenallownum(}{it:t}{cmd:,}
{it:real scalar} {it:allownum}{cmd:)}


{p 8 12 2}
{it:real scalar}{bind:     }
{cmd:tokenallowhex(}{it:t}{cmd:)}

{p 8 12 2}
{it:void}{bind:            }
{cmd:tokenallowhex(}{it:t}{cmd:,}
{it:real scalar} {it:allowhex}{cmd:)}


{p 4 4 2}
where

{p 12 16 2}
{it:t} is {it:transmorphic} and contains the parsing environment
    information.  You obtain a {it:t} from {cmd:tokeninit()} or
    {cmd:tokeninitstata()} and then pass {it:t} to the other functions.

{p 12 16 2}
{it:wchars} is a {it:string scalar} containing the characters to be 
    treated as whitespace, such as 
    {cmd:" "}, {cmd:(" "+char(9))}, or {cmd:""}.

{p 12 16 2}
{it:pchars} is a {it:string rowvector} containing the strings 
    to be treated as parsing characters, 
    such as {cmd:""} and {cmd:(">", "<", ">=", "<=")}.  {cmd:""}
    and {helpb mf_j##void_matrices:J(1,0,"")} are given the same
    interpretation:  there are no parsing characters.

{p 12 16 2}
    {it:qchars} is a {it:string rowvector} containing the 
    character pairs to be treated as quote characters.
    {cmd:""} (that is, empty string) is given the same interpretation as 
    {helpb mf_j##void_matrices:J(1,0,"")}; there are no quote characters.
    {it:qchars}={cmd:(`""""')} (that is, the two-character string 
    quote indicates that {cmd:"} is to be treated as open quote 
    and {cmd:"} is to be treated as close quote.
    {it:qchars}={cmd:(`""""', `"`""'"')} indicates that, in addition,
    {cmd:`"} is to be treated as open quote and {cmd:"'} as close quote.
    In a syntax that did not use {cmd:<} and {cmd:>} as parsing characters, 
    {it:qchars}={cmd:("<>")} would indicate that {cmd:<} is to be treated as 
    open quote and {cmd:>} as close quote.
   
{p  12 16 2}
{it:allownum} is a {it:string scalar} containing 0 or 1.  {it:allownum}=1
    indicates that numbers such as 12.23 and 1.52e+02 are to be returned 
    as single tokens even in violation of other parsing rules.

{p  12 16 2}
{it:allowhex} is a {it:string scalar} containing 0 or 1.  {it:allowhex}=1
    indicates that numbers such as 1.921fb54442d18X+001 and 1.0x+a are
    to be returned as single tokens even in violation of other parsing rules.


{marker description}{...}
{title:Description}

{p 4 4 2}
These functions provide advanced parsing.  If you simply wish to convert
strings into row vectors by separating on blanks, converting 
{cmd:"mpg weight displ"} into {cmd:("mpg", "weight", "displ")}, see 
{bf:{help mf_tokens:[M-5] tokens()}}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection M-5 tokenget()Remarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{p 4 4 2}
Remarks are presented under the following headings:

	{help mf_tokenget##remarks1:Concepts}
	    {help mf_tokenget##remarks1a:White-space characters}
	    {help mf_tokenget##remarks1b:Parsing characters}
	    {help mf_tokenget##remarks1c:Quote characters}
	    {help mf_tokenget##remarks1d:Overrides}
	    {help mf_tokenget##remarks1e:Setting the environment to parse on blanks with quote binding}
	    {help mf_tokenget##remarks1f:Setting the environment to parse full Stata syntax}
	    {help mf_tokenget##remarks1g:Setting the environment to parse tab-delimited files}
	{help mf_tokenget##remarks2:Function overview}
	    {help mf_tokenget##remarks2a:tokeninit() and tokeninitstata()}
            {help mf_tokenget##remarks2b:tokenset()}
	    {help mf_tokenget##remarks2c:tokengetall()}
	    {help mf_tokenget##remarks2d:tokenget(), tokenpeek(), and tokenrest()}
            {help mf_tokenget##remarks2e:tokenoffset()}
	    {help mf_tokenget##remarks2f:tokenwchars(), tokenpchars(), and tokenqchars()}
	    {help mf_tokenget##remarks2g:tokenallownum and tokenallowhex()}


{marker remarks1}{...}
{title:Concepts}
 
{p 4 4 2}
Parsing refers to splitting a string into pieces, which we will call tokens.
Parsing as implemented by the {cmd:token*()} functions is defined by (1) the
whitespace characters {it:wchars}, (2) the parsing characters {it:pchars},
and (3) the quote characters {it:qchars}.


{marker remarks1a}{...}
    {title:White-space characters}

{p 4 4 2}
Consider the string {cmd:"this that what"}.  If there are no 
whitespace characters, no parsing characters, and no quote characters, 
that is, if {it:wchars}={it:pchars}={it:qchars}={cmd:""}, then the result of
parsing {cmd:"this that what"} would be one token that would be the
string just as it is:  {cmd:"this that what"}.

{p 4 4 2}
If {it:wchars} were instead {cmd:" "}, then parsing {cmd:"this that what"}
results in
{cmd:("this", "that", "what")}.  
Parsing {cmd:"this that{bind:   }what"} (note the multiple
blanks) would result in the same thing.  White-space characters separate one
token from the next but are not otherwise significant.


{marker remarks1b}{...}
    {title:Parsing characters}

{p 4 4 2}
If we instead left {it:wchars}={cmd:""} and set {it:pchars}={cmd:" "}, 
{cmd:"this that what"} parses into 
{cmd:("this", " ", "that", " ", "what")}
and parsing {cmd:"this that{bind:   }what"} results in 
{cmd:("this", " ", "that", " ", " ", " ", "what")}.

{p 4 4 2}
{it:pchars} are like {it:wchars} except that they are themselves significant.

{p 4 4 2}
{it:pchars} do not usually contain space.  A more reasonable definition of
{it:pchars} is {cmd:("+", "-")}. 
Then parsing {cmd:"x+y"} results in 
{cmd:("x", "+", "y")}.  
Also, the parsing characters can be character combinations.  If
{it:pchars} = {cmd:("+", "-", "++", "--")}, then parsing 
{cmd:"x+y++"} results in {cmd:("x", "+", "y", "++")} and parsing 
{cmd:"x+++y"} results in {cmd:("x", "++", "+", "y")}.
Longer {it:pchars} are matched before shorter ones regardless of the 
order in which they appear in the {it:pchars} vector.


{marker remarks1c}{...}
    {title:Quote characters}

{p 4 4 2}
{it:qchars} specifies the quote characters.  Pieces of the string being 
parsed that are surrounded by quotes are returned as one token, 
ignoring the separation that would usually occur because of the {it:wchars}
and {it:pchars} definitions.  Consider the string

	{cmd:mystr= "x = y"}

{p 4 4 2}
Let {it:wchars} = {cmd:" "} and {it:pchars} include {cmd:"="}.
That by itself would result in the above string parsing into the five tokens 

	{c TLC}{hline 7}{c TT}{hline 3}{c TT}{hline 5}{c TT}{hline 5}{c TT}{hline 6}{c TRC}
	{c |} {cmd:mystr} {c |} {cmd:=} {c |} {cmd:"x}  {c |}  {cmd:=}  {c |}  {cmd:y"}  {c |}
	{c BLC}{hline 7}{c BT}{hline 3}{c BT}{hline 5}{c BT}{hline 5}{c BT}{hline 6}{c BRC}

{p 4 4 2}
Now let {it:qchars} = {cmd:(`""""')}; that is, {it:qchars} is the
two-character string {cmd:""}.  Parsing then results in the three tokens

	{c TLC}{hline 7}{c TT}{hline 3}{c TT}{hline 9}{c TRC}
	{c |} {cmd:mystr} {c |} {cmd:=} {c |} {cmd:"x = y"} {c |}
	{c BLC}{hline 7}{c BT}{hline 3}{c BT}{hline 9}{c BRC}

{p 4 4 2}
Each element of {it:qchars} contains a character pair:  the open
character followed by the close character.  
We defined those two 
characters as {cmd:"} and {cmd:"} above, that is, as being the same.
The two characters can differ.  We might define the first
as {cmd:`} and the second as {cmd:'}.  When the characters are
different, quotations can nest.  The quotation {cmd:"he said "hello""}
makes no sense because that parses into {cmd:("he said ", hello, "")}.  The
quotation {cmd:`he said `hello''}, however, makes perfect sense and results
in the single token {cmd:`he said `hello''}.

{p 4 4 2}
The quote characters can themselves be multiple characters.
You can define open quote as {cmd:`"} and close as {cmd:"'}:
{it:qchars}={cmd:(`"`""'"')}.  Or you can define multiple sets of quotation
characters, such as {it:qchars}={cmd:(`""""', `"`""'"')}.

{p 4 4 2}
The quote characters do not even have to be quotes at all.
In some context you might find it convenient to specify 
them as {cmd:("()")}.  With that definition, 
"(2*(3+2))" would parse into one token.
Specifying them like this can be useful, but in general we recommend against
it.  It is usually better to write your code so that quote characters really
are quote characters and to push the work of handling other kinds of nested
expressions back onto the caller.


{marker remarks1d}{...}
    {title:Overrides}

{p 4 4 2}
The {cmd:token*()} functions provide two overrides:  {it:allownum} and
{it:allowhex}.  These have to do with parsing numbers.  First, consider life
without overrides.  You have set {it:wchars}={cmd:" "} and 
{it:pchars}={cmd:("=", "+", "-", "*", "/")}.  You
attempt to parse

	{cmd:y = x + 1e+13}

{p 4 4 2}
The result is 

        {c TLC}{hline 3}{c TT}{hline 3}{c TT}{hline 3}{c TT}{hline 3}{c TT}{hline 4}{c TT}{hline 3}{c TT}{hline 4}{c TRC}
	{c |} {cmd:y} {c |} {cmd:=} {c |} {cmd:x} {c |} {cmd:+} {c |} {cmd:1e} {c |} {cmd:+} {c |} {cmd:13} {c |}
        {c BLC}{hline 3}{c BT}{hline 3}{c BT}{hline 3}{c BT}{hline 3}{c BT}{hline 4}{c BT}{hline 3}{c BT}{hline 4}{c BRC}

{p 4 4 2}
when what you wanted was 

        {c TLC}{hline 3}{c TT}{hline 3}{c TT}{hline 3}{c TT}{hline 3}{c TT}{hline 7}{c TRC}
	{c |} {cmd:y} {c |} {cmd:=} {c |} {cmd:x} {c |} {cmd:+} {c |} {cmd:1e+13} {c |}
        {c BLC}{hline 3}{c BT}{hline 3}{c BT}{hline 3}{c BT}{hline 3}{c BT}{hline 7}{c BRC}

{p 4 4 2}
Setting {it:allownum}=1 will achieve the desired result.
{it:allownum} specifies that, when a token could be interpreted as a number, 
the number interpretation is to be taken even in violation of the other 
parsing rules.

{p 4 4 2}
Setting {it:allownum}=1 will not find numbers buried in the middle of strings,
such as the {cmd:1e+3} in {cmd:"xis1e+3"}, but if the number occurs at the
beginning of the token according to the parsing rules set by {it:wchars}
and {it:pchars}, {it:allownum}=1 will continue the token in violation of those
rules if that results in a valid number.

{p 4 4 2}
The override {it:allowhex} is similar and Stata specific.  Stata (and Mata)
provide a unique and useful way of writing hexadecimal floating-point numbers
in a printable, short, and precise way:  pi can be written
1.921fb54442d18X+001.  Setting {it:allowhex}=1 allows such numbers.


{marker remarks1e}{...}
    {title:Setting the environment to parse on blanks with quote binding}

{p 4 4 2}
Stata's default rule for parsing do-file arguments
is "parse on blanks and bind on quotes".  The settings for duplicating 
that behavior are

	    {it:wchars} =  {cmd:" "}

	    {it:pchars} =  {cmd:( "" )}

	    {it:qchars} =  {cmd:( `""""', `"`""'"')}

          {it:allownum} =  0

          {it:allowhex} =  0

{p 4 4 2}
This behavior can be obtained by coding 

	{it:t} {cmd:= tokeninit(" ", "", (`""""', `"`""'"'), 0, 0)}

{p 4 4 2}
or by coding 

	{it:t} {cmd:= tokeninit()}

{p 4 4 2}
because in {cmd:tokeninit()} the arguments are optional and 
"parse on blank with quote binding" is the default.

{p 4 4 2}
With those settings, parsing 
{cmd:`"first second "third fourth" fifth"'}
results in 
{cmd:("first", "second", `""third fourth""', "fifth")}.

{p 4 4 2}
This result is a little different from that of Stata
because the third token includes the quote binding characters.
Assume that the parsed string was obtained by coding 

	{cmd:res = tokengetall(}{it:t}{cmd:)}

{p 4 4 2}
The following code will remove the open and close quotes, should that 
be desirable.

	{cmd}for (i=1; i<=cols(res); i++) {
		if (substr(res[i], 1, 1)==`"""') {
			res[i] = substr(res[i], 2, strlen(res[i])-2)
		}
		else if (substr(res[i], 1, 2)=="`" + `"""') {
			res[i] = substr(res[i], 3, strlen(res[i])-4)
		}
	}{txt}


{marker remarks1f}{...}
    {title:Setting the environment to parse full Stata syntax}

{p 4 4 2}
To parse full Stata syntax, the settings are

	    {it:wchars} =  {cmd:" "}

	    {it:pchars} =  {cmd:( "\",  "~",  "!",  "=",  ":",  ";",  ",",}
                       {cmd: "?",  "!",  "@",  "#", "==", "!=", ">=",}
		       {cmd:"<=",  "<",  ">",  "&",  "|", "&&", "||",}
                       {cmd: "+",  "-", "++", "--",  "*",  "/",  "^",}
                       {cmd: "(",  ")",  "[",  "]",  "{c -(}",  "{c )-}" )}

	    {it:qchars} =  {cmd:( `""""', `"`""'"', char(96)+char(39) )}

          {it:allownum} =  1

          {it:allowhex} =  1

{p 4 4 2}
The above is a slight oversimplification.  Stata is an interpretive 
language and Stata does not require users to type filenames in quotes, 
although Stata does allow it.  Thus {cmd:"\"} is sometimes a 
parsing character and sometimes not, and the same is true of
{cmd:"/"}.  As Stata parses a line from left to right, it will 
change {it:pchars} between two {cmd:tokenget()} calls
when the next token could be or is
known to be a filename.  Sometimes Stata peeks ahead to decide which way to
parse.  You can do the same by using the {cmd:tokenpchars()} and
{cmd:tokenpeek()} functions.

{p 4 4 2}
To obtain the above environment, code 

	{it:t}{cmd: = tokeninitstata()}


{marker remarks1g}{...}
    {title:Setting the environment to parse tab-delimited files}

{p 4 4 2}
The {cmd:token*()} functions can be used to parse lines from tab-delimited 
files.  A tab-delimited file contains lines of the form

		<{it:field1}><{it:tab}><{it:field2}><{it:tab}><{it:field3}>

{p 4 4 2}
The parsing environment variables are

	    {it:wchars} =  {cmd:""}

	    {it:pchars} =  {cmd:( char(9) )}{col 40}(i.e., {it:tab})

	    {it:qchars} =  {cmd:( "" )}

          {it:allownum} =  0

          {it:allowhex} =  0

{p 4 4 2}
To set this environment, code

	{it:t}{cmd: = tokeninit("", char(9), "", 0, 0)}

{p 4 4 2}
Say that you then parse the line 

		Farber, William<{it:tab}>  2201.00<{it:tab}>12

{p 4 4 2}
The results will be 

		{cmd:("Farber, William", char(9), {bind:"  2201.00"}, char(9), "12")}

{p 4 4 2}
If the line were

		Farber, William<{it:tab}><{it:tab}>12

{p 4 4 2}
the result would be 

                {cmd:("Farber, William", char(9), char(9), "12")}

{p 4 4 2}
The tab-delimited format is not well defined when the missing fields occur at
the end of the line.  A line with the last field missing might be recorded

		Farber, William<{it:tab}>  2201.00<{it:tab}>

{p 4 4 2}
or

		Farber, William<{it:tab}>  2201.00

{p 4 4 2}
A line with the last two fields missing might be recorded

		Farber, William<{it:tab}><{it:tab}>

{p 4 4 2}
or

		Farber, William<{it:tab}>

{p 4 4 2}
or

		Farber, William

{p 4 4 2}
The following program would correctly parse lines with missing fields 
regardless of how they are recorded:

	{cmd}real rowvector readtabbed(transmorphic t, real scalar n)
	{
		real scalar       i
		string rowvector  res
		string scalar     token

		res = J(1, n, "")
		i = 1
		while ((token = tokenget(t))!="") {
			if (token==char(9)) i++ 
			else res[i] = token
		}
		return(res)
	}{txt}


{marker remarks2}{...}
{title:Function overview}

{p 4 4 2}
The basic way to proceed is to initialize the parsing environment and 
store it in a variable, 

	{cmd:t = tokeninit(}...{cmd:)}

{p 4 4 2}
and then set the string {cmd:s} to be parsed,

	{cmd:tokenset(t, s)}

{p 4 4 2}
and finally use {cmd:tokenget()} to obtain the tokens one at a time
({cmd:tokenget()} returns {cmd:""} when the end of the line is reached), 
or obtain all the tokens at once using {cmd:tokengetall(t)}.
That is, either 

	{cmd}while((token = tokenget(t)) != "") {
		... {it:process }{cmd}token ...
	}{txt}

{p 4 4 2}
or

	{cmd}tokens = tokengetall(t)
	for (i=1; i<=cols(tokens); i++) {
		... {it:process }{cmd}tokens[i] ...
	}{txt}

{p 4 4 2}
After that, set the next string to be parsed,

	{cmd:tokenset(t,} {it:nextstring}{cmd:)}

{p 4 4 2}
and repeat.


{marker remarks2a}{...}
    {title:tokeninit() and tokeninitstata()}

{p 4 4 2}
{cmd:tokeninit()} and {cmd:tokeninitstata()} are alternatives.
{cmd:tokeninitstata()} is generally unnecessary unless you are 
writing a fairly complicated function.

{p 4 4 2}
Whichever function you use, code 

	{it:t}{cmd: = tokeninit(}...{cmd:)}

{p 4 4 2}
or

	{it:t}{cmd: = tokeninitstata()}

{p 4 4 2}
If you declare {it:t}, declare it {cmd:transmorphic}.  {it:t} is in fact a
structure containing all the details of your parsing environment, but that is
purposely hidden from you so that you cannot accidentally modify the
environment.

{p 4 4 2}
{cmd:tokeninit()} allows up to five arguments:

	{it:t}{cmd: = tokeninit(}{it:wchars}{cmd:,} {it:pchars} {cmd:,} {it:qchars}{cmd:,} {it:allownum}{cmd:,} {it:allowhex}{cmd:)}

{p 4 4 2}
You may omit arguments from the end.  If omitted, the default values of 
the arguments are

          {it:allowhex} =  0

          {it:allownum} =  0

	    {it:qchars} =  {cmd:( `""""', `"`""'"')}

	    {it:pchars} =  {cmd:( "" )}

	    {it:wchars} =  {cmd:" "}


{p 4 4 2}
Notes

{p 8 12 2}
1.  Concerning {it:wchars}:

{p 12 16 2}
a.  {it:wchars} is a {it:string scalar}.  The whitespace characters 
    appear one after the other in the string.  The order in which the 
    characters appear is irrelevant.

{p 12 16 2}
b.  Specify {it:wchars} as {cmd:" "} to treat blank as whitespace.

{p 12 16 2}
c.  Specify {it:wchars} as {cmd:" "+char(9)} to treat blank and {it:tab}
    as whitespace.  Including {it:tab} is necessary only when strings
    to be parsed are obtained from a file; strings obtained from Stata 
    already have the {it:tab} characters removed.

{p 12 16 2}
d.  Any character can be treated as a whitespace character, 
    including letters.

{p 12 16 2}
e.  Specify {it:wchars} as {cmd:""} to specify that there are no whitespace
    characters.

{p 8 12 2}
2.  Concerning {it:pchars}:

{p 12 16 2}
a.  {it:pchars} is a {it:string rowvector}.  Each element of the vector 
    is a separate parse character.  The order in which the parse characters
    are specified is irrelevant.

{p 12 16 2}
b.  Specify {it:pchars} as {cmd:("+", "-")} to make {cmd:+} and {cmd:-}
    parse characters.

{p 12 16 2}
c.  Parse characters may be character combinations such as {cmd:++} or 
    {cmd:>=}.  Character combinations may be up to four characters long.

{p 12 16 2}
d.  Specify {it:pchars} as {cmd:""} or {helpb mf_j##void_matrices:J(1,0,"")} to
    specify that there are no parse characters.  It makes no difference which
    you specify, but you will realize that {cmd:J(1,0,"")} is more logically
    consistent if you think about it.

{p 8 12 2}
3.  Concerning {it:qchars}:

{p 12 16 2}
a.  {it:qchars} is a {cmd:string rowvector}.  Each element of the vector
    contains the open followed by the close characters.  The order in which
    sets of quote characters are specified is irrelevant.

{p 12 16 2}
b.  Specify {it:qchars} as {cmd:(`""""')} to make {cmd:"} an open and close 
    character.

{p 12 16 2}
c.  Specify {it:qchars} as {cmd:(`""""', `"`""'"')} to make {cmd:""} 
    and {cmd:`""'} quote characters.

{p 12 16 2}
d.  Individual quote characters can be up to two characters long.

{p 12 16 2}
e.  Specify {it:qchars} as {cmd:""} or {helpb mf_j##void_matrices:J(1,0,"")} to
    specify that there are no quote characters.


{marker remarks2b}{...}
    {title:tokenset()}

{p 4 4 2}
After {cmd:tokeninit()} or {cmd:tokeninitstata()}, you are not 
yet through with initialization.
You must {cmd:tokenset(}{it:s}{cmd:)} to specify the 
string scalar you wish to parse.
You {cmd:tokenset()} one line, parse it, and if you have more 
lines, you {cmd:tokenset()} again and repeat the process.  
Often you will need to parse 
only one line.  Perhaps you wish to write a program 
to parse the argument of a complicated option in a Stata ado-file.
The structure is 

	{cmd:program} ...
		...
		{cmd:syntax} ... {cmd:[,} ... {cmd:MYoption(string)} ...{cmd:]}
		{cmd:mata: parseoption(`"`myoption'"')}
		...
	{cmd:end}

	{cmd:mata:}
	{cmd:void parseoption(string scalar option)}
	{cmd:{c -(}}
		{cmd:transmorphic     t}

		{cmd:t = tokeninit(}...{cmd:)}
		{cmd:tokenset(t, option)}
		...
	{cmd:{c )-}}
	{cmd:end}

{p 4 4 2}
Notes

{p 8 12 2}
1.  When you {cmd:tokenset(}{it:s}{cmd:)}, the contents of {it:s} 
    are not stored.  Instead, a pointer to {it:s} is stored.  This approach
    saves memory and time, but it means that if you change {it:s} after
    setting it, you will change the subsequent behavior of the {cmd:token*()}
    functions.

{p 8 12 2}
2.  Simply changing {it:s} is not sufficient to restart parsing.  
    If you change {it:s}, you must {cmd:tokenset(}{it:s}{cmd:)} again.


{marker remarks2c}{...}
    {title:tokengetall()}

{p 4 4 2}
You have two alternatives in how to process the tokens.  You can 
parse the entire line into a row vector containing all the individual 
tokens by using {cmd:tokengetall()}, 

	{cmd:tokens = tokengetall(}{it:t}{cmd:)}

{p 4 4 2}
or you can use {cmd:tokenget()} to process the tokens one at a time, 
which is discussed in the next section.

{p 4 4 2}
Using {cmd:tokengetall()}, {cmd:tokens[1]} will be the first token, 
{cmd:tokens[2]} the second, and so on.  There are, in total, 
{cmd:cols(tokens)} tokens.
If the line was empty or contained only whitespace characters, 
{cmd:cols(tokens)} will be 0.


{marker remarks2d}{...}
    {title:tokenget(), tokenpeek(), and tokenrest()}

{p 4 4 2}
{cmd:tokenget()} returns the tokens one at a time and returns 
{cmd:""} when the end of the line is reached.  The basic loop for 
processing all the tokens in a line is

	{cmd:while ( (token = tokenget(}{it:t}{cmd:)) != "") {c -(}}
		...
	{cmd:{c )-}}

{p 4 4 2}
{cmd:tokenpeek()} allows you to peek ahead at the next token without actually
getting it, so whatever is returned will be returned again by the next call to
{cmd:tokenget()}.  {cmd:tokenpeek()} is suitable only for obtaining the next
token after {cmd:tokenget()}.  Calling {cmd:tokenpeek()} twice in a row 
will not return the next two tokens; it will return the next token twice.
To obtain the next two tokens, code

	...
	{cmd:current = tokenget(}{it:t}{cmd:)}         // get the current token
	...
	{it:t2} {cmd:=} {it:t}                        // copy parse environment
	{cmd:next_1 = tokenget(}{it:t2}{cmd:)}         // peek at next token
	{cmd:next_1 = tokenget(}{it:t2}{cmd:)}         // peek at token after that
	...
	{cmd:current = tokenget(}{it:t}{cmd:)}         // get next token

{p 4 4 2}
If you declare {it:t2}, declare it {cmd:transmorphic}.

{p 4 4 2}
{cmd:tokenrest()} returns the unparsed portion of the {cmd:tokenset()}
string.  Assume that you have just gotten the first token by
using {cmd:tokenget()}.  {cmd:tokenrest()} would return the rest of the
original string, following the first token, unparsed.
{cmd:tokenrest(}{it:t}{cmd:)} returns {cmd:substr(}{it:original_string}{cmd:,}
{cmd:tokenoffset(}{it:t}{cmd:),} {cmd:.)}.


{marker remarks2e}{...}
    {title:tokenoffset()}

{p 4 4 2}
{cmd:tokenoffset()} is useful only when you are using the {cmd:tokenget()}
rather than {cmd:tokengetall()} style of programming.  Let the original string
you {cmd:tokenset()} be "this is an example".  Right after you have 
{cmd:tokenset()} this string, {cmd:tokenoffset()} is 1:

		{cmd:this is an example}
        	|
          {cmd:tokenoffset()} = 1

{p 4 4 2}
After getting the first token (say it is {cmd:"this"}), 
{cmd:tokenoffset()} is 5:

		{cmd:this is an example}
        	    |
              {cmd:tokenoffset()} = 5

{p 4 4 2}
{cmd:tokenoffset()} is always located on the first character following 
the last character parsed.

{p 4 4 2}
The syntax of {cmd:tokenoffset()} is

	{cmd:tokenoffset(}{it:t}{cmd:)}

{p 4 4 2}
and

	{cmd:tokenoffset(}{it:t}{cmd:,} {it:newoffset}{cmd:)}

{p 4 4 2}
The first returns the current offset value.  The second resets the 
parser's location within the string.


{marker remarks2f}{...}
    {title:tokenwchars(), tokenpchars(), and tokenqchars()}

{p 4 4 2}
{cmd:tokenwchars()}, 
{cmd:tokenpchars()}, 
and 
{cmd:tokenqchars()}
allow resetting the current {it:wchars}, {it:pchars}, and {it:qchars}.
As with {cmd:tokenoffset()}, they come in two syntaxes.

{p 4 4 2}
With one argument, {it:t}, they return the current value of the 
setting.  With two arguments, {it:t} and {it:newvalue}, they 
reset the value.

{p 4 4 2}
Resetting in the midst of parsing is an advanced issue.  The most 
useful of these functions is {cmd:tokenpchars()}, since 
for interactive grammars, it is sometimes necessary to switch on and 
off a certain parsing character such as {cmd:/}, which in one context 
means division and in another is a file separator.


{marker remarks2g}{...}
    {title:tokenallownum and tokenallowhex()}

{p 4 4 2}
These two functions allow obtaining the current values of {it:allownum} and
{it:allowhex} and resetting them.


{marker conformability}{...}
{title:Conformability}

{p 4 8 2}
    {cmd:tokeninit(}{it:wchars}{cmd:,}
    {it:pchars}{cmd:,}
    {it:qchars}{cmd:,}
    {it:allownum}{cmd:,}
    {it:allowhex}{cmd:)}:
{p_end}
	    {it:wchars}:  1 {it:x} 1    (optional)
	    {it:pchars}:  1 {it:x} {it:c_p}  (optional)
	    {it:qchars}:  1 {it:x} {it:c_q}  (optional)
	  {it:allownum}:  1 {it:x} 1    (optional)
	  {it:allowhex}:  1 {it:x} 1    (optional)
	    {it:result}:  {it:transmorphic}

    {cmd:tokeninitstata()}:
	    {it:result}:  {it:transmorphic}

    {cmd:tokenset(}{it:t}{cmd:,} {it:s}{cmd:)}:
		 {it:t}:  {it:transmorphic}
	         {it:s}:  1 {it:x} 1 
	    {it:result}:  {it:void}

    {cmd:tokengetall(}{it:t}{cmd:)}:
		 {it:t}:  {it:transmorphic}
	    {it:result}:  1 {it:x} {it:k}

{p 4 8 2}
    {cmd:tokenget(}{it:t}{cmd:)},
    {cmd:tokenpeek(}{it:t}{cmd:)},
    {cmd:tokenrest(}{it:t}{cmd:)}:
{p_end}
		 {it:t}:  {it:transmorphic}
	    {it:result}:  1 {it:x} 1
	
{p 4 4 2}
    {cmd:tokenoffset(}{it:t}{cmd:)}, 
    {cmd:tokenwchars(}{it:t}{cmd:)}, 
    {cmd:tokenallownum(}{it:t}{cmd:)}, 
    {cmd:tokenallowhex(}{it:t}{cmd:)}:
{p_end}
		 {it:t}:  {it:transmorphic}
	    {it:result}:  1 {it:x} 1

{p 4 4 2}
    {cmd:tokenoffset(}{it:t}{cmd:,} {it:newvalue}{cmd:)},
    {cmd:tokenwchars(}{it:t}{cmd:,} {it:newvalue}{cmd:)},{break}
    {cmd:tokenallownum(}{it:t}{cmd:,} {it:newvalue}{cmd:)},
    {cmd:tokenallowhex(}{it:t}{cmd:,} {it:newvalue}{cmd:)}:
{p_end}
		 {it:t}:  {it:transmorphic}
	  {it:newvalue}:  1 {it:x} 1
	    {it:result}:  {it:void}
	
{p 4 8 2}
    {cmd:tokenpchars(}{it:t}{cmd:)}, 
    {cmd:tokenqchars(}{it:t}{cmd:)}:
{p_end}
		 {it:t}:  {it:transmorphic}
	    {it:result}:  1 {it:x} {it:c}

{p 4 8 2}
    {cmd:tokenpchars(}{it:t}{cmd:,} {it:newvalue}{cmd:)},
    {cmd:tokenqchars(}{it:t}{cmd:,} {it:newvalue}{cmd:)}:
{p_end}
		 {it:t}:  {it:transmorphic}
	  {it:newvalue}:  1 {it:x} {it:c}
	    {it:result}:  {it:void}


{marker diagnostics}{...}
{title:Diagnostics}

{p 4 4 2}
None.


{marker source}{...}
{title:Source code}

{p 4 4 2}
{view tokenget.mata, adopath asis:tokenget.mata} 
for all functions.
{p_end}
