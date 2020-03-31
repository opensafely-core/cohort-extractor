{smcl}
{* *! version 1.0.9  19sep2018}{...}
{vieweralsosee "[D] unicode translate" "mansection D unicodetranslate"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[D] unicode" "help unicode"}{...}
{vieweralsosee "" "--"}{...}
{findalias asfrunicode}
{findalias asfrunicodeadvice}
{viewerjumpto "Syntax" "unicode_translate##syntax"}{...}
{viewerjumpto "Description" "unicode_translate##description"}{...}
{viewerjumpto "Links to PDF documentation" "unicode_translate##linkspdf"}{...}
{viewerjumpto "Options" "unicode_translate##options"}{...}
{viewerjumpto "Remarks" "unicode_translate##remarks"}{...}
{p2colset 1 26 28 2}{...}
{p2col:{bf:[D] unicode translate} {hline 2}}Translate files to Unicode{p_end}
{p2col:}({mansection D unicodetranslate:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}
Analyze files to be translated

{p 8 16 2}
{cmd:unicode analyze} {it:{help unicode_translate##filespec:filespec}} 
[, 
{cmdab:re:do} 
{cmd:nodata}]


{pstd}
Set encoding to be used during translation

{p 8 16 2}
{cmd:unicode} {cmdab:en:coding} {cmd:set} 
[{cmd:"}]{it:encoding}[{cmd:"}]


{pstd}
Translate or retranslate files

{p 8 40 2}
{cmd:unicode} {cmdab:tr:anslate}{bind:   }{it:{help unicode_translate##filespec:filespec}} 
[{cmd:,}
{cmd:invalid}[{cmd:(}{cmd:escape}|{cmd:mark}|{cmd:ignore}{cmd:)}]
{cmd:transutf8} 
{cmd:nodata}
]

{p 8 40 2}
{cmd:unicode} {cmdab:retr:anslate} {it:{help unicode_translate##filespec:filespec}} 
[{cmd:,}
{cmd:invalid}[{cmd:(}{cmd:escape}|{cmd:mark}|{cmd:ignore}{cmd:)}]
{cmd:transutf8} 
{cmd:replace}
{cmd:nodata}
]


{pstd}
Restore backups of translated files

{p 8 16 2}
{cmd:unicode} {cmd:restore} {it:{help unicode_translate##filespec:filespec}}  
[{cmd:,}
{cmd:replace} ]


{pstd}
Delete backups of translated files

{p 8 16 2}
{cmd:unicode} {cmd:erasebackups, badidea}


{marker filespec}{...}
{phang}
{it:filespec} is a single filename or a file specification 
containing {cmd:*} and {cmd:?} specifying one or more files, such as

{col 30}{cmd:*.dta}
{col 30}{cmd:*.do}
{col 30}{cmd:*.*}
{col 30}{cmd:*}
{col 30}{cmd:myfile.*} 
{col 30}{cmd:year??data.dta} 

{pstd}
{cmd:unicode} analyzes and translates {cmd:.dta} files and text files.  It
assumes that filenames with suffix {cmd:.dta} contain Stata datasets and that
all
other suffixes contain text. 
Those other suffixes are 
{cmd:.ado}, 
{cmd:.do}, 
{cmd:.mata}, 
{cmd:.txt}, 
{cmd:.csv}, 
{cmd:.sthlp},
{cmd:.class},
{cmd:.dlg}, 
{cmd:.idlg}, 
{cmd:.ihlp}, 
{cmd:.smcl}, 
and {cmd:.stbcal}.

{pstd}
Files with suffixes other than those listed are ignored. 
Thus "*.*" would ignore any .docx files or files with other suffixes. 
If such files contain text, they can be analyzed and translated by 
specifying the suffix explicitly, such as info.README and *.README.


{marker description}{...}
{title:Description}

{pstd}
{cmd:unicode} {cmd:translate} translates files containing extended ASCII
to Unicode (UTF-8).

{pstd}
Extended ASCII is how people got accented Latin characters 
such as "{c a'}" and "{c a'g}" and got characters from other languages
such as "Я", "θ", and "わたし"
before the advent of Unicode or, 
in this context, before Stata became Unicode aware. 

        {c TLC}{hline 54}{c TRC}
        {c |} If you have do-files, ado-files, {cmd:.dta} files, etc.,   {c |}
        {c |} from Stata 13 or earlier -- and those files          {c |}
        {c |} contain extended ASCII -- you need to use            {c |}
        {c |} the {cmd:unicode} {cmd:translate} command to translate the files {c |}
        {c |} from extended ASCII to Unicode.                      {c |}
        {c BLC}{hline 54}{c BRC}

{pstd} 
The {cmd:unicode} {cmd:translate} command is also useful if you have
text files containing extended ASCII that you wish to read into Stata.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection D unicodetranslateRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker options}{...}
{title:Options}

{phang}
{cmd:redo}
     is allowed with {cmd:unicode analyze}.  {cmd:unicode analyze}
     remembers results from one run to the next so that it does not repeat
     results for files that have been previously analyzed and determined not
     to need translation.  Thus {cmd:unicode} {cmd:analyze}'s output focuses on
     the files that remain to be translated.  {cmd:redo} specifies that
     {cmd:unicode} {cmd:analyze} show the analysis for all files specified.

{phang} 
{cmd:nodata} 
     is used with {cmd:unicode} {cmd:analyze}, {cmd:translate}, and 
     {cmd:retranslate}.  It specifies that the contents of 
     the {cmd:str}{it:#} and {cmd:strL} variables in {cmd:.dta} files 
     are not to be translated.  The contents of the variables are
     to be left as is. 
     The default behavior is to translate if necessary.

{pmore}
     If option {cmd:nodata} is specified, only the metadata --
     variable names, dataset label, variable labels, value labels, and
     characteristics -- are analyzed and perhaps translated.

{pmore}
      This option is provided for two reasons.

{pmore}
     {cmd:nodata} is included for those who do not
     trust automated software to modify the most vital part
     of their datasets, the data themselves.  We emphasize to those
     users that {cmd:unicode} backs up files, and so translated files
     are easily restored to their original status.  

{pmore}
     The other reason {cmd:nodata} is included is for those datasets
     that include string variables in which some variables
     (observations) use one encoding and
     other variables (observations) use another. Such datasets
     are rare and called mixed-encoding datasets.  One could arise
     if dataset {cmd:result.dta} was the result of merging
     {cmd:input1.dta} and {cmd:input2.dta}, and {cmd:input1.dta} encoded its
     string variables using ISO-8859-1, whereas {cmd:input2.dta} used
     JIS-X-0208.  Such datasets are rare because if this had occurred, you
     would have noticed when you produced {cmd:result.dta}.  The two extended
     ASCII encodings are simply not compatible, and one group or another of
     characters would have displayed incorrectly.

{marker invalid}{...}
{phang}
{cmd:invalid} and {cmd:invalid()} 
    are allowed with {cmd:unicode} {cmd:translate} and 
    {cmd:retranslate}.  They specify how invalid characters are to be
    handled.  Invalid characters are not supposed to arise, and when
    they do, it is a sign that you have set the wrong extended ASCII
    encoding.  So let's assume that you have indeed set the right 
    encoding and that still one or a few invalid characters do arise.  
    The stories on how this might happen are long and technical, and 
    all of them involve you playing sophisticated font games, or 
    they involve you using a proprietary extended ASCII encoding 
    that is no longer available, and so you are using an encoding that 
    is close to the actual encoding used. 

{pmore}
    By default, {cmd:unicode} will not translate files containing
    invalid characters.  {cmd:unicode} instead warns you so 
    that you can specify the correct extended ASCII encoding. 

{pmore}
    {cmd:invalid} specifies the invalid characters are to be shown with
    an escape sequence.  If a string contained "A@B", where @ indicates
    an invalid character, after translation, the string might contain
    "A%XCDB", which is say, %XCD was substituted for @.  In general,
    invalid characters are replaced with {cmd:%X}{it:##}, where {it:##}
    is the invalid character's hex value.  The substitution is
    admittedly ugly, but it ensures that distinct strings remain
    distinct, which is important if the string is used as an 
    identifier when you use the data.

{pmore}
    {cmd:invalid(escape)} is a synonym for {cmd:invalid}. 

{pmore} 
    {cmd:invalid(mark)} specifies that the official Unicode replacement
    character be substituted for invalid characters. That official character
    is {bf:\ufffd} in Unicode speak and how it looks varies across
    operating systems.  On Windows, the Unicode replacement character looks
    like a square; on Mac and Unix, it looks like a question mark in a
    hexagon.

{pmore}
    {cmd:invalid(ignore)} indicates that the invalid character 
    simply be removed.  "A@B" becomes "AB". 

{phang}
{cmd:transutf8} 
    is allowed with {cmd:unicode} {cmd:translate} and
    {cmd:retranslate}.  {cmd:transutf8} specifies that characters that
    look as if they are UTF-8 already should nonetheless be translated
    according to the extended ASCII encoding.  Do not specify this option
    unless {cmd:unicode} suggests it when you translate the file
    without the option, and even then, specify the option only
    after you have examined the translated file and determined that you
    agree.

{pmore}
    For most of us, this issue arises when two extended ASCII 
    characters appear next to each other, such as a German word 
    containing "{c u:}{c ss}", or a French word containing "{c a'g}{c o:}".
    Even when extended ASCII characters are adjacent, that is not 
    necessarily sufficient to mimic valid UTF-8 characters, but some
    combinations do mimic UTF-8.

{pmore}
    Adjacent UTF-8 characters that mimic UTF-8 characters
    are actually likely when you are using a CJK extended ASCII 
    encoding.  CJK stands for Chinese, Japanese, and Korean. 
   
{pmore}
     In any case, if {cmd:unicode} {cmd:analyze} reports 
     when valid UTF-8 strings appear and if the file needs translating 
     because it is not all ASCII plus UTF-8, you may need to specify 
     {cmd:transutf8} when you translate the file. 
     If you are unsure, proceed by translating the file without 
     specifying {cmd:transutf8}, inspect the result, and retranslate 
     if necessary. 

{phang}
{cmd:replace} 
    has nothing to do with translation and is allowed
    with {cmd:unicode} {cmd:retranslate} and 
    {cmd:restore}.  It has to do with the restoration of original, 
    untranslated files from the backups that {cmd:unicode} {cmd:translate} 
    and {cmd:retranslate} make.  Option {cmd:replace} should not be
    specified unless {cmd:unicode} suggests it.  

{pmore}
    {cmd:unicode} keeps backups of your originals.  When you restore
    the originals or retranslate files (which involves restoring the
    originals), {cmd:unicode} checks that the previously  translated file
    is unchanged from when {cmd:unicode} last translated it.  It does
    this because if you modified the translated file since
    translation, those changes might be important to you and because if
    {cmd:unicode} restored the original from the backup, you would lose
    those changes.  {cmd:replace} specifies that it is okay to change
    the previously translated file even though it has changed.

{phang}
{cmd:badidea} 
    is used with {cmd:unicode erasebackups} and is not optional.
    Erasing the backups of original files is usually a bad idea.  We
    recommend you keep them for six months or so.  Eventually, however,
    you will want to delete the backups.  You are required to specify
    option {cmd:badidea} to show that you realize that erasing the
    backups is a bad idea if done too soon.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

{phang2}{help unicode_translate##about:What is this about?}{p_end}
{phang2}{help unicode_translate##need:Do I need to translate my files?}{p_end}
{phang2}{help unicode_translate##process:Overview of the process}{p_end}
{phang2}{help unicode_translate##encoding:How to determine the extended ASCII encoding}{p_end}
{phang2}{help unicode_translate##analyze:Use of unicode analyze}{p_end}
{phang2}{help unicode_translate##overview:Use of unicode translate: Overview}{p_end}
{phang2}{help unicode_translate##backups:Use of unicode translate: A word on backups}{p_end}
{phang2}{help unicode_translate##output:Use of unicode translate: Output}{p_end}
{phang2}{help unicode_translate##binary:Translating binary strLs}{p_end}


{marker about}{...}
{title:What is this about?}

{pstd}
Stata 14 and later use UTF-8, a form of Unicode, to encode strings.
Stata 13 and earlier used ASCII.  Datasets, do-files, ado-files, help
files, and the like may need translation to display properly in Stata
{ccl stata_version}.

{pstd}
Files containing strings using only plain ASCII do not need translation.
Plain ASCII provides the following characters:

	          Latin letters:  A - Z, a - z
	                 Digits:  0 - 9
                        Symbols:  ! " # $ % & ' ( ) * + , - . /
				  : ; < = > ? @ [ \ ] ^ _ ` 
                                  {c -(} | {c )-} ~

{pstd}
If the variable names, variable labels, value labels, and string
variables in your {cmd:.dta} files and the lines in your do-files,
ado-files, and other Stata text files contain only the characters
above, there is nothing you need to do.

{pstd}
On the other hand, if your {cmd:.dta} files, do-files, ado-files, etc.,
contain accented characters such as

{p 35 35 2}
{c a'} {c e'g} {c o^} {c u:}  {c y'}  ...

{pstd}
or symbols such as 

{p 35 35 2}
{c L-} {c Y=} ...

{pstd}
or characters from other alphabets, 

{p 35 35 2} 
знать{break}
こんにちは

{pstd}
then the files do need translating so that the characters display
correctly.

{pstd} 
{cmd:unicode} {cmd:analyze} will tell you whether you have such files,
and {cmd:unicode} {cmd:translate} will translate them. 

{pstd}
You first use {cmd:unicode} {cmd:analyze}.  It may turn out that
no files need translating, and in that case, you are done.

{pstd} 
If you do have files that need translating, you will use {cmd:unicode}
{cmd:translate}.  {cmd:unicode} {cmd:translate} makes a backup of your
file before translating it.

{pstd}
If you do have files that need translating, {cmd:unicode} {cmd:translate} will
translate them.  Before you can use {cmd:unicode} {cmd:translate}, you must
set the extended ASCII encoding that your files used.  You do this with
{cmd:unicode} {cmd:encoding} {cmd:set}.  Encodings go by names such as
ISO-8859-1, Windows-1252, Big5, ISO-2022-KR, and about a thousand other names.
However, there are only 231 encodings.  Most of the names are aliases
(synonyms).  ISO-8859-1, for instance, is also known as ISO-Latin1, Latin1,
and other names.

{pstd}
See {help encodings:help encodings} for more information on encodings.
Some of you will find the appropriate encoding name
immediately.  Others will be able only to narrow down the alternatives.
Even so, all is not lost.  {cmd:unicode} {cmd:translate} makes it easy
to translate and retranslate a file over and over again until you find the
encoding that works best.  Once you find that encoding, it is likely
that all of your files are using the same encoding.


{marker need}{...}
{title:Do I need to translate my files?}

{pstd}
{it:Can I ignore the issue?} 

{p 8 8 2}
If you are asking whether you can close your eyes and ignore the issue,
the answer is maybe and maybe not.  

{p 8 8 2}
If you have files using extended
ASCII, they will not display correctly in Stata {ccl stata_version}.  We view
that as a significant problem, but let's assume that does not concern you.  If
you used extended ASCII for variable names, you may find it difficult or
impossible to type the untranslated name.  That would be a problem.  Other
than that, you are probably okay, or more accurately, we cannot think of a
problem even though we have tried.  We have tried because if we could think of
a problem, we would have fixed it.  Stata's data management routines have been
modified and certified to work with UTF-8.  If they receive extended ASCII,
they can mightily mess up what is displayed, but beyond that, they should
produce results equivalent to what previous Statas produced.

{p 8 8 2}
Our advice is, for safety's sake, do not ignore the problem.

{p 8 8 2}
However, you do not need to analyze and translate all of your files today.
One day, you will {cmd:use} a dataset and results will look odd when
you {cmd:describe} or {cmd:list} the data.  You will see unprintable
characters and probably mutter a few unprintable words yourself, but having
discovered the problem, you can then turn to solving it using {cmd:unicode}
{cmd:analyze} and {cmd:unicode} {cmd:translate}.

{p 8 8 2}
However, we recommend that you learn to use {cmd:unicode} {cmd:translate}
today.  Take some files you are working with, determine whether you have
a problem, and fix them if you do.

{pstd}
{it:Do my files need translation?} 

{p 8 8 2}
If you are asking whether you have files that contain extended ASCII in
hopes that you do not, here is our answer:

{p 8 8 2}
If you live and work in an English-speaking country, you probably 
do not have files containing extended ASCII. 

{p 8 8 2}
If you live and work outside an English-speaking country but you have 
limited yourself to the unadorned Latin alphabet, you probably do 
not have files containing extended ASCII. 

{p 8 8 2}
Otherwise, you probably do have files containing extended ASCII. 

{pstd}
{it:How will I know what to do?} 

{p 8 8 2}
{cmd:unicode analyze} will tell you whether you have files 
containing extended ASCII. 
{cmd:unicode} {cmd:analyze} can look at single files, or it can look at
all the files in a directory.  And if you do have files containing 
extended ASCII, {cmd:unicode} {cmd:translate} will fix the files. 


{marker process}{...}
{title:Overview of the process}

{pstd}
You will analyze your files and, if necessary, translate
them.  You can do this one file at a time by typing

	. {cmd:unicode analyze myfile.dta}

	. {cmd:unicode encoding set} {it:encoding}

	. {cmd:unicode translate myfile.dta}

{pstd} 
or you can do this with all of your files at once by typing

	. {cmd:unicode analyze *}

	. {cmd:unicode encoding set} {it:encoding}

	. {cmd:unicode translate *}

{pstd} 
Shockingly, we are going to advise you that analyzing and even translating
all of your files at once is perfectly safe!  That is because

{p 8 12 2}
1.  {cmd:unicode} {cmd:analyze} by default ignores files that are not
     Stata related. 

{p 8 12 2}
2.  {cmd:unicode} {cmd:analyze} reads your files and reports 
    on them; it does not change them. 

{p 8 12 2}
3.  {cmd:unicode} {cmd:analyze} might report that 
    no files need translating.  In that case, you are done. 

{p 8 12 2} 
4.  if you do have files that need translating, before you can use
    {cmd:unicode} {cmd:translate}, you must set the extended ASCII
    encoding.  How you determine the encoding is the topic of the next
    section.

{p 8 12 2} 
5.  {cmd:unicode} {cmd:translate}, just like {cmd:unicode} {cmd:analyze}, 
    ignores by default files that are not Stata related.  
    Typing {cmd:unicode} {cmd:translate} {cmd:*} is safe.

{p 8 12 2} 
6.  {cmd:unicode} {cmd:translate} does not modify files that do not 
    need translation.  This does not hinge on your having run 
    {cmd:unicode} {cmd:analyze}.
    Typing {cmd:unicode} {cmd:translate} {cmd:*} is safe.

{p 8 12 2} 
7.   {cmd:unicode} {cmd:translate} does not modify files in which 
     the translation goes poorly; it discards the translation. 
     Typing {cmd:unicode} {cmd:translate} {cmd:*} is safe.

{p 8 12 2}
8.  {cmd:unicode} {cmd:translate} makes backups of the original 
    of any file it does translate successfully.  At any time, you can
    type

{p 16 16 2}
. {cmd:unicode restore *} 

{p 12 12 2}
    and the files in your directory are back to being just as they were
    when you started.
    Typing {cmd:unicode} {cmd:translate} {cmd:*} is safe.

{pstd}
In the rest of this manual entry, we could discuss what might happen when you
run {cmd:unicode} {cmd:analyze} and {cmd:unicode} {cmd:translate} and offer
advice on what you might do about it.

{pstd}
{cmd:unicode} {cmd:analyze} and {cmd:unicode} {cmd:translate}, however,
produce a ream of output, especially if you run them on a group of
files.  That output is tailored to your files and your situation.  That
output states what did happen and offers advice.  Read it.


{marker encoding}{...}
{title:How to determine the extended ASCII encoding}

{pstd} 
We are getting ahead of ourselves because we have not yet determined
that any of your files do need translating.  Whether translation is 
necessary can be determined without knowing the extended ASCII encoding. 

{pstd}
Determining the encoding can be more difficult than you would wish.
Back in the day when the experts were still trying to make the extended
ASCII solution work, the cleverest among them went to a lot of effort
to hide the encoding from you, and they did a good job.

{pstd}
When the time comes to type

	. {cmd:unicode encoding set} {it:encoding}

{pstd} 
see {help encodings:help encodings}.  We have advice. 
In the meantime, allow us to predict how this process will transpire:

{pstd} 
Some of you will not be able to determine the encoding your files are using,
but you will be able to make guesses and narrow the choices down to a few of
them.  Then you will experiment to see which works best.  We say "see" because
that is literally how you are going to do it.  You will guess, you will
translate, and you will look at the result.  And then you will repeat the
process with a different encoding.  The {cmd:unicode} command will make
the translation and retranslation part easy.

{pstd}
Many of you will discover the single encoding that works for all of your
files.  Some of you will discover that one encoding works for most of your
files but that there are one or two other encodings that you have to use
with other files.

{pstd}
And then there is the issue of mixed UTF-8 and extended ASCII.  This
will affect only a few of you.

{p 8 12 2} 
1.  {cmd:unicode translate} will warn you when a file is a mix of UTF-8
    and extended ASCII.  It warns you because (1) the file could be 
    exactly what it appears to be, a mix of encodings, 
    or (2) the file is all extended ASCII and a few extended ASCII 
    strings are merely masquerading as UTF-8. 

{p 8 12 2} 
2.  By default, {cmd:unicode} {cmd:translate} assumes that the file 
    really is a mix.  It does not translate 
    the UTF-8 strings; it translates just the strings that are 
    extended ASCII.  

{p 12 12 2}
    {it:Technical note:} Here is how this works.  A variable label
    appearing to be UTF-8 already is not translated, whereas another
    variable label containing extended ASCII is translated even if a
    part of it appears to be UTF-8. {cmd:unicode} {cmd:translate}
    assumes that each variable label follows a single encoding. This
    same logic applies to {cmd:str}{it:#} and {cmd:strL} variables in
    the data.  The variable is assumed to use the same encoding in all
    observations.

{p 8 12 2} 
3.  The default assumption may be incorrect; the file could be entirely 
    extended ASCII.  The default assumption is more likely to be
    incorrect in the CJK case.  You can
    determine whether the default assumption is correct by looking at
    the file after translation.  If some parts of it look like memory
    junk, then use {cmd:unicode} {cmd:retranslate,} {cmd:transutf8} to
    retranslate the file, and if you do not like that result, 
    use {cmd:unicode} {cmd:retranslate} without {cmd:transutf8} 
    to return to the previous result.  Or you could use {cmd:unicode} 
    {cmd:restore} to return to the original file and start all over 
    again, perhaps with a different encoding. 

{p 12 12 2}
    {it:Technical note:} There is no difference between using 
    {cmd:unicode} {cmd:restore} followed by {cmd:unicode} {cmd:translate}
    and using {cmd:unicode} {cmd:retranslate}.  So if you want to 
    try a different encoding, you can restore, set the new encoding, 
    and translate, or you can set the new encoding and retranslate. 


{marker analyze}{...}
{title:Use of unicode analyze} 

{pstd}
If the files you want to examine are not in the current 
directory, change to the appropriate directory:

	    . {cmd:cd} {it:wherever}

{pstd}
{cmd:unicode analyze} and all the rest of the {cmd:unicode} commands
described in this entry look at files in the current directory and only
files in the current directory.  {cmd:unicode} does not even look in
subdirectories of the current directory.

{pstd} 
Analyze the file.  

	    . {cmd:unicode analyze myfile.dta}

{pstd} 
{cmd:unicode analyze} will report whether the file needs translation
and provide other information, too.  The output looks something like
this:

	    . {cmd:unicode analyze myfile.dta}

	    File summary (before starting):
	          1   file(s) specified 
                  1   file(s) to be examined ...

	    File {cmd:myfile.dta} (Stata dataset)
                   {hline 40}
		   File does not need translation

            File summary:
                all files okay

{pstd}
Or it might look like this: 

	    . {cmd:unicode analyze myfile.dta}

	    File summary (before starting):
	          1   file(s) specified 
                  1   file(s) to be examined ...

	    File {cmd:myfile.dta} (Stata dataset)
                  3 variable names need translation
                  2 variable labels need translation 
                  1 str# variable needs translation 
                   {hline 40}
		   {err:File needs translation.} 
                   Use {cmd:unicode translate on this file}

            File summary:
                1 file needs translation 

{pstd}
If you were to now rerun the analysis in the case where the file 
does not need translation, you would see something like this:

	    . {cmd:unicode analyze myfile.dta}

	    File summary (before starting):
	          1   file(s) specified 
                  1   file(s) already known to be ASCII in previous runs
                  0   file(s) to be examined ...
            (nothing to do) 

{pstd} 
If you want to see the detailed output, type 
{cmd:unicode} {cmd:analyze} {cmd:myfile.dta,} {cmd:redo}. 

{pstd}
The primary purpose of {cmd:unicode} {cmd:analyze} is to get the 
files that do not need translating out of the way.
{cmd:unicode} {cmd:analyze} does not change your files; it just 
dismisses the ones that need no further work.

{pstd}
You can run {cmd:unicode} {cmd:analyze} on multiple files, and we
recommend that you do that.

	    . {cmd:unicode analyze *}
	         30   file(s) specified 
	          6   file(s) not Stata 
                  1   file(s) already known to be ASCII in previous runs
                  1   file(s) already known to be UTF-8 in previous runs
                 22   files(s) to be examined

{pstd} 
There is more to the output, but before we look at that, note 
that {cmd:unicode} {cmd:analyze} reported that 6 files were not 
Stata.  {cmd:unicode} {cmd:analyze} and {cmd:unicode} {cmd:translate}
ignore non-Stata files unless you explicitly specify them, say, by typing 
{cmd:unicode} {cmd:analyze} {cmd:README} or 
{cmd:unicode} {cmd:analyze} {cmd:*.README}.

{pstd} 
Let's now return to the remaining output from 
{cmd:unicode} {cmd:analyze} {cmd:*}:

	    File {it:filename} ({it:filetype})
                  {it:notes about elements that need translating}
                  {hline 40}
                  {it:recommendations} 
 
	    File {it:filename} ({it:filetype})
                  {it:notes about elements that need translating}
                  {hline 40}
                  {it:recommendations} 

            .
            .

	    File {it:filename} ({it:filetype})
                  {it:notes about elements that need translating}
                  {hline 40}
                  {it:recommendations} 

            Files matching * that need translation:
                  {it:list of files} 

            File summary: 
                  2   file(s) skipped (known okay from previous runs) 
                  8   file(s) need translation
              

{pstd}
{cmd:unicode} {cmd:analyze} produced a lot of output.  If you are
like us, you will want a log of the output and perhaps want to look at it in
the Viewer.  It is not too late, just remember to specify the {cmd:redo}
option:

	. {cmd:log using output} 

	. {cmd:unicode analyze *, redo} 
	  {it:(output omitted)}

	. {cmd:log close}

	. {cmd:view output.smcl} 

{pstd} 
If you are really like us, you will instead want a file you can 
edit in Stata's Do-file Editor:

	. {cmd:log using output.log} 

	. {cmd:unicode analyze *, redo} 
	  {it:(output omitted)}

	. {cmd:log close}

	. {cmd:doedit output.log}

{pstd}
Now, you can edit the output to make a to-do list for yourself. 
We go through the output and delete the parts with which we agree, such as 
the following:

	File myfile.do (text file) 
                40 line(s) in file
          {hline 60} 
          File does not need translation. 

{pstd} 
Buried in the output, however, may be something like this: 

	File {cmd:german.dta} (Stata dataset)
          {hline 50} 
          File does not need translation, except ...
          The file appears to be UTF-8 already.  Sometimes, files that need
          translating can look like UTF-8.  Look at these examples:
              variable name "länge"
              variable label "Kofferraumvolumen (Kubikfuß)"
              value-label contents "Ausländisch"
              contents of str# variable marke
          Do they look okay to you?
          If not, the file needs translating or retranslating with the
          {cmd:transutf8} option.  Type
              . {cmd:unicode   translate "bill_utf8.dta", transutf8}
              . {cmd:unicode retranslate "bill_utf8.dta", transutf8}

{pstd} 
This file, too, is marked as not needing translation, and we agree based on
the evidence presented, but we might not have agreed.  Assume that the file
was named {cmd:japan.dta} and that the examples did not look like Japanese but
looked like memory junk.  We would want to add this file to our list to
translate and remind ourselves to specify option {cmd:transutf8} when
translating.

{pstd}
It is unlikely that any file that {cmd:unicode} {cmd:analyze} 
reports as purely UTF-8 needs translating unless the file is short, and 
then you must look at it to determine whether the file really is UTF-8. 

{pstd} 
Here is a different example. The file, according to {cmd:unicode} 
{cmd:analyze}, needs translation, but it also includes UTF-8:

	File filter.do (text file)
                40 line(s) in file
                33 line(s) ASCII
                 1 line(s) UTF-8
                 6 line(s) need translation
          {hline 60} 
          File needs translation.  Use {cmd:unicode translate} on this file.  
            There are three possibilities. 
            (1) The file is exactly what it appears to be, a mix of extended
            ASCII and UTF-8.  Use {cmd:unicode translate}.
	    (2) The UTF-8 lines are extended ASCII masquerading as UTF-8.
	    Use {cmd:unicode translate, transutf8}.
	    (3) The file is UTF-8 with some invalid characters.  Set the
	    encoding to {cmd:utf8} and then use {cmd:unicode translate, invalid()}.

{pstd}
{cmd:unicode} {cmd:analyze} thinks this file needs translation and 
speculates about how it should be translated.  Read the output.
Possibility (3) did not even occur to us.  Even so, and even without
looking at the file, we would favor possibility (2) because there is only
one UTF-8 line and there are 6 lines known to need translation.

{pstd} 
You will learn that running {cmd:unicode} {cmd:analyze} is optional. 
The advantage of running {cmd:unicode} {cmd:analyze} is that it 
offers advice. 

{pstd}
You can analyze files repeatedly.  If you type {cmd:unicode} {cmd:analyze}
without the {cmd:redo} option, the output reappears, but files are skipped that
{cmd:unicode} {cmd:analyze} previously determined as not needing translation.
Specify {cmd:redo} and you will see all the files.

{pstd}
{cmd:unicode} {cmd:analyze} remembers results from previous runs.
Five years from now, {cmd:unicode analyze} will remember the files it
has examined and determined do not need translation, and it will even
know whether the file has changed in the intervening five years and so needs
reexamination.

{pstd}
{cmd:unicode} {cmd:analyze} remembers from one run to the next by
creating a directory named bak.stunicode, where it can put its notes.
Ignore the directory and its subdirectories.  When we tell you about
{cmd:unicode} {cmd:translate}, you will learn that bak.stunicode is also
where backups of unmodified original files are stored.  Now that you
know that, you might be tempted to restore originals from the
backups by copying the files.  Do not do that because you will confuse
{cmd:unicode}.  Use {cmd:unicode} {cmd:restore} to restore originals.
We will get to that.

{pstd} 
The purpose of {cmd:unicode} {cmd:analyze} is to dismiss all the files
that do not have problems so you can focus on those that do.  When you
later use {cmd:unicode} {cmd:translate}, it will also skip over files
that do not need translating.  Using {cmd:unicode} {cmd:analyze} is
optional, and even if you do not use it, {cmd:unicode} {cmd:translate} will
never translate a file that does not need it; {cmd:unicode}
{cmd:translate} runs {cmd:unicode} {cmd:analyze} in secret if it needs
to.


{marker overview}{...}
{title:Use of unicode translate: Overview}

{pstd} 
Let's assume that we have used {cmd:unicode} {cmd:analyze} and learned that
the following files need translating:

	    {cmd:myfile.dta}
	    {cmd:anotherfile.do}

{pstd}
Before we can translate the files, we must set the extended ASCII
encoding.  See {help encodings:help encodings} when you are translating
your files.

{pstd}
Let's just assume right now that we know the encoding for the files is
ISO-8859-1, and then we will assume that we were wrong and show you how
we get out of that situation.

{pstd}
Step 1.  Inform {cmd:unicode} of the encoding by typing

	    . {cmd:unicode encoding set ISO-8859-1}


{pstd}
Step 2.  Translate the files, one at a time by typing

	    . {cmd:unicode translate myfile.dta} 

	    . {cmd:unicode translate anotherfile.do} 

{pstd} 
or both in one command by typing

	    . {cmd:unicode translate *} 

{pstd} 
Specifying {cmd:*} or {cmd:*.*} or {cmd:*.dta} or {cmd:m*.*} or any
other file specification is perfectly safe.  {cmd:unicode}
{cmd:translate} ignores irrelevant files just as {cmd:unicode}
{cmd:analyze} does.  {cmd:unicode} {cmd:translate} also ignores files
that do not need translating, and it ignores files that have
already been translated.  {cmd:unicode} {cmd:translate} does not depend
on your having run {cmd:unicode} {cmd:analyze} previously. 

{pstd}
{cmd:unicode} {cmd:translate} has another great feature:  it makes
backups of the files it modifies.  If, after translation, you decide
you do not like the translation, you can restore the original by typing 

	    . {cmd:unicode restore myfile.dta}

{pstd} 
You can even type 

            . {cmd:unicode restore *}
 
{pstd} 
if you want all of your files restored. 

{pstd} 
You do not have to restore the original just to retranslate it. 
Use {cmd:unicode} {cmd:retranslate} instead:

	    . {cmd:unicode retranslate myfile.dta} 

            . {cmd:unicode retranslate *}

{pstd} 
The only reason to run {cmd:unicode} {cmd:retranslate}, however, is if
you want to specify different options or try a different encoding:

	    . {cmd:unicode encoding set} {it:some_other_encoding}

	    . {cmd:unicode retranslate *} 

{pstd} 
And if you do not like that result, you can still {cmd:unicode}
{cmd:restore}.


{marker backups}{...}
{title:Use of unicode translate:  A word on backups} 

{pstd}
{cmd:unicode} {cmd:translate} and {cmd:retranslate} automatically make
backups when they modify a file and a backup does not already exist.
{cmd:unicode} calculates and keeps track of checksums calculated on
the original and translated files, so it knows whether the files are
subsequently changed.  {cmd:unicode} is thoroughly tested.  What could
possibly go wrong?

{pstd} 
If you are like us, you trust nobody with regard to your files.
We do not even trust ourselves.  Trust us on this.  Make your own back up
in whatever way you know before using {cmd:unicode} {cmd:translate}.
Backup the entire directory.  We would make a zip file of it, but if
nothing else, just copy all the files to a new, out-of-the-way
directory.  We predict you will not need the copies, but one never knows
for sure.

{pstd}
Even if {cmd:unicode} is perfect, the subsequent validity of the
backups depends on the bak.stunicode subdirectory not being corrupted
by another process or even by you.  More than once, we have ourselves 
damaged files in haste. 

{pstd}
After you have translated your files, keep the backups for a while. 
Eventually, however, there will come a day when the backups are 
no longer needed.  The command to delete the backups 
of your originals is 

	    . {cmd:unicode erasebackups, badidea}

{pstd} 
You must specify option {cmd:badidea}.  Think of {cmd:badidea} 
as an abbreviation for {cmd:badideaifdonetoosoon}: what you 
are doing in specifying the option is stating that it is not too 
soon. 


{marker output}{...}
{title:Use of unicode translate: Output}

{pstd}
{cmd:unicode translate}'s output looks just like {cmd:unicode} 
{cmd:analyze}'s output except that the content varies:

	    . {cmd:unicode translate *}
	         30   file(s) specified 
	          6   file(s) not Stata 
                  6   file(s) already known to be ASCII in previous runs
                  4   file(s) already known to be UTF-8 in previous runs
                 14   files(s) to be examined

	    File {it:filename} ({it:filetype})
                  {it:notes about the translation}
                  {hline 40}
                  {it:result message} 
 
	    File badfile.ado (textfile) 
                  40 lines in file
                  16 lines ASCII 
		   2 lines translated 
                  22 lines w/ invalid chars not translated
                  {hline 40}
		  {err:File not translated because it contains untranslatable}
		  {err:characters;}
                         you need to specify a different encoding or, if you
                         are sure that you have the correct encoding, use
                         {cmd:unicode translate} with the {cmd:invalid()} option
            .
            .

	    File {it:filename} ({it:filetype})
                  {it:notes about the translation}
                  {it:notes about elements that need translating}
                  {hline 40}
                  {it:result message} 

            Files matching * that still need translation:
                  badfile.ado

            File summary: 
                 10   file(s) skipped (known okay from previous runs) 
                 13   file(s) successfully translated
                 {err: 1   files(s) not translated because they contain}
                      {err:untranslatable characters}
                         you need to specify a different encoding or, if you
                         are sure that you have the correct encoding, use
                         {cmd:unicode translate} with the {cmd:invalid()} option

{pstd}
One file still needs translation according to the output.  How can files still
need translation?  The output explains.  We had untranslatable characters.
The output even says what to do about it.  We should specify a different
encoding -- the fact that we had untranslatable characters is evidence that we
are using the wrong encoding -- or we should accept that there are invalid
characters in our file and tell {cmd:unicode} {cmd:translate} how to handle
them.  It will help us make the decision if we scan up from the
file-summary message to find the detailed output for badfile.ado:

	    File badfile.ado (textfile) 
                  40 lines in file
                  16 lines ASCII 
		   2 lines translated 
                  22 lines w/ invalid chars not translated
                  {hline 40}
		  {err:File not translated because it contains untranslatable}
		  {err:characters;}
                      you need to specify a different encoding or, if you
                      are sure that you have the correct encoding, use
                      {cmd:unicode translate} with the {cmd:invalid()} option

{pstd}
You can read about the {helpb unicode_translate##invalid:invalid()} option
under {it:Options}, but this looks like a case where the file needs a
different encoding; 2 lines translated with the current encoding, and 22 did
not.  If we had instead seen that 22 lines translated and that 2 lines had
invalid characters, we would be less sure about needing a different encoding.
Assume the output had been 

	    File badfile.ado (textfile) 
                  40 lines in file
                  38 lines ASCII 
                   2 lines w/ invalid chars not translated
                  {hline 40}
		  {err:File not translated because it contains untranslatable}
		  {err:characters;}
                      you need to specify a different encoding or, if you
                      are sure that you have the correct encoding, use
                      {cmd:unicode translate} with the {cmd:invalid()} option

{pstd} 
That an ado-file is mostly ASCII does not surprise us. The fact 
that no lines could be translated (given the encoding) speaks volumes. 
We need a different encoding. 

{pstd}
Most of our files were translated.  For successful translations, 
the detailed output for {cmd:.dta} files will be something like the following:

            File {cmd:trees.dta} (Stata dataset)
                   9 variable names okay, ASCII
                   3 variable names translated
                 all data labels okay, ASCII
                   8 variable labels okay, ASCII
                   4 variable labels translated
                 all value-label names okay, ASCII
                 all value-label contents translated
                 all characteristic names okay, ASCII
                 all characteristic contents okay, ASCII
                 all str# variables okay, ASCII
                 {hline 50}
                 File successfully translated

{pstd}
The detailed output for text files might look like the following:

	    File runjob.do (textfile) 
                120 lines in file
                101 lines ASCII 
                 19 lines translated
                 {hline 50}
                 File successfully translated

{pstd}
Here is an example of a file that translated successfully
but produced a lot of output: 

            File {cmd:northwest.dta} (Stata dataset)
                all variable names okay, ASCII
                all data labels okay, ASCII
                all variable labels okay, ASCII
                all value-label names okay, ASCII
                all value-label contents okay, ASCII
                all characteristic names okay, ASCII
                all characteristic contents okay, ASCII
                  1 strL variable okay, ASCII
                  1 strL variable(s) have binary values
                       This concerns strL variable diagnotes.
                       StrL variables that contain binary values in even one
                       observation are not translated by {cmd:unicode}.  Translating
                       binary values is inappropriate.  Rarely, however,
                       "binary" values are just text or the variable contains
                       binary values in some observations and nonbinary values
                       in others.  You translate such variables using {cmd:generate}
                       or {cmd:replace}; see {help unicode_translate##binary:translating binary strLs}.  
                  1 strL variable translated 
                  2 str# variables okay, ASCII 
                  1 str# variable translated 
                 {hline 50}
                 File successfully translated

{pstd}
The extra output concerns a strL variable that was not translated. 
The output states that the variable is binary and that translating 
binary strLs is inappropriate, but maybe not. 
This is the topic of the next section.


{marker binary}{...}
{title:Translating binary strLs}

{pstd}
{cmd:unicode} {cmd:translate} does not translate binary strLs.  
That is probably the right decision. 
StrLs are sometimes used in Stata to record documents, images, and other
binary files, and modifying binary files is never a good idea. 

{pstd}
Stata marks strL variables as binary on an observation-by-observation
basis.  As far as {cmd:unicode} {cmd:translate} is concerned, however,
if there is just one observation in which the strL is marked as binary,
it treats all observations as binary and does not translate them.  The
thinking is that variables hold different realizations of the same
underlying type of thing, and if the strL is binary in one observation,
it is probably truly binary in all observations.

{pstd}
Perhaps you know differently in your specific application
and wish to translate the variable's nonbinary observations or 
all of its observations.  Here is how you do that. 

{pstd}
You use string function {cmd:ustrfrom()} to obtain a translated string.
Assuming the existing strL variable is named {cmd:myvar}, you type 

	. {cmd:generate strL} {it:newvar} {cmd:= ustrfrom(myvar, "}{it:encoding}{cmd:", }{it:#}{cmd:)}

{pstd}
Specify  encoding just as you would with 
	{cmd:unicode} {cmd:encoding} {cmd:set} {it:encoding}.
{it:encoding} might be ISO-8859-1, Windows-1252, Big5, ISO-2022-KR, or
any other extended ASCII encoding.  Whatever string you specify 
for {it:encoding}, make sure it is valid and spelled correctly. 
Testing the string with
{cmd:unicode encoding set} is one way to do that. 

{pstd}
{it:#} is specified as 1, 2, 3, or 4 and determines how invalid
characters are to be handled.  Three of the four values
correspond to {cmd:unicode}'s {cmd:invalid()} option:

		1  is equivalent to  {cmd:invalid(mark)}
        	2  is equivalent to  {cmd:invalid(ignore)}
		4  is equivalent to  {cmd:invalid(escape)}

{pstd} 
The remaining code, 3, specifies that the function return "" if invalid 
characters are encountered. 

{pstd}
So one way of translating all the values of {cmd:myvar} would be 

	. {cmd:generate strL try = ustrfrom(myvar, "ISO-8859-1", 1)}

	. {cmd:browse newvar}         // review result 

	. {cmd:replace newvar = try}

	. {cmd:drop try}

{pstd}
If you want to translate only the nonbinary values of {cmd:myvar},
you could type 

{p 8 16 2}
. {cmd:gen strL try = ustrfrom(myvar, "ISO-8859-1", 1) if !_strisbinary(myvar)}
{p_end}
{p 8 16 2}
. {cmd:replace try = myvar if _strisbinary(myvar)}
{p_end}

{pstd}
That would use Stata's definition of binary, which is difficult to explain. 
Another good definition of binary is that the string not contain 
binary 0:

{p 8 16 2}
. {cmd:gen strL try = ustrfrom(myvar, "ISO-8859-1", 1) if !strpos(myvar, char(0))}
{p_end}
{p 8 16 2}
. {cmd:replace try = myvar if strpos(myvar, char(0))}
{p_end}
