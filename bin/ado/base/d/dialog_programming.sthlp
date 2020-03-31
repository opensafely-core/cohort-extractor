{smcl}
{* *! version 1.5.3  05oct2018}{...}
{vieweralsosee "[P] Dialog programming" "mansection P Dialogprogramming"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] window programming" "help window programming"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] db" "help db"}{...}
{viewerjumpto "Description" "dialog_programming##description"}{...}
{viewerjumpto "Links to PDF documentation" "dialog_programming##linkspdf"}{...}
{viewerjumpto "Remarks" "dialog_programming##remarks"}{...}
{p2colset 1 27 29 2}{...}
{p2col:{bf:[P] Dialog programming} {hline 2}}Dialog programming
{p_end}
{p2col:}({mansection P Dialogprogramming:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
Dialog-box programs -- also called dialog resource files -- allow
you to define the appearance of a dialog box, specify how its controls work
when the user fills it in (such as hiding or disabling specific controls), 
and specify the ultimate action to be taken (such as running a Stata command)
when the user clicks on {hi:OK} or {hi:Submit}.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection P DialogprogrammingRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

        {help dialogs##intro:1. Introduction}

        {help dialogs##remarks2:2. Concepts}
        {help dialogs##remarks2.1:2.1 Organization of the .dlg file}
        {help dialogs##remarks2.2:2.2 Positions, sizes, and the DEFINE command}
        {help dialogs##remarks2.3:2.3 Default values}
        {help dialogs##remarks2.4:2.4 Memory (recollection)}
        {help dialogs##remarks2.5:2.5 I-actions and member functions}
        {help dialogs##remarks2.6:2.6 U-actions and communication options}
        {help dialogs##remarks2.7:2.7 The distinction between i-actions and u-actions}
        {help dialogs##remarks2.8:2.8 Error and consistency checking}

        {help dialogs##remarks3:3. Commands}
        {help dialogs##remarks3.1:3.1 VERSION}
        {help dialogs##remarks3.2:3.2 INCLUDE}
        {help dialogs##remarks3.3:3.3 DEFINE}
        {help dialogs##remarks3.4:3.4 POSITION}
        {help dialogs##remarks3.5:3.5 LIST}
        {help dialogs##remarks3.6:3.6 DIALOG}
        {help dialogs##remarks3.6.1:3.6.1 CHECKBOX on/off input control}
        {help dialogs##remarks3.6.2:3.6.2 RADIO on/off input control}
        {help dialogs##remarks3.6.3:3.6.3 SPINNER numeric input control}
        {help dialogs##remarks3.6.4:3.6.4 EDIT string input control}
        {help dialogs##remarks3.6.5:3.6.5 VARLIST and VARNAME string input controls}
        {help dialogs##remarks3.6.6:3.6.6 FILE string input control}
        {help dialogs##remarks3.6.7:3.6.7 LISTBOX list input control}
        {help dialogs##remarks3.6.8:3.6.8 COMBOBOX list input control}
        {help dialogs##remarks3.6.9:3.6.9 BUTTON special input control}
        {help dialogs##remarks3.6.10:3.6.10 TEXT static control}
        {help dialogs##remarks3.6.11:3.6.11 TEXTBOX static control}
        {help dialogs##remarks3.6.12:3.6.12 GROUPBOX static control}
        {help dialogs##remarks3.6.13:3.6.13 FRAME static control}
        {help dialogs##remarks3.6.14:3.6.14 COLOR input control}
        {help dialogs##remarks3.6.15:3.6.15 EXP expression input control}
        {help dialogs##remarks3.6.16:3.6.16 HLINK hyperlink input control}
        {help dialogs##remarks3.6.17:3.6.17 TREEVIEW tree input control}
        {help dialogs##remarks3.7:3.7 OK, SUBMIT, CANCEL, and COPY u-action buttons}
        {help dialogs##remarks3.8:3.8 HELP and RESET helper buttons}
        {help dialogs##remarks3.9:3.9 Special dialog directives}

        {help dialogs##remarks4:4. SCRIPT}

        {help dialogs##remarks5:5. PROGRAM}
        {help dialogs##remarks5.1:5.1 Concepts}
        {help dialogs##remarks5.1.1:5.1.1 Vnames}
        {help dialogs##remarks5.1.2:5.1.2 Enames}
        {help dialogs##remarks5.1.3:5.1.3 rstrings: cmdstring and optstring}
        {help dialogs##remarks5.1.4:5.1.4 Adding to an rstring}
        {help dialogs##remarks5.2:5.2 Flow-control commands}
        {help dialogs##remarks5.2.1:5.2.1 if}
        {help dialogs##remarks5.2.2:5.2.2 while}
        {help dialogs##remarks5.2.3:5.2.3 call}
        {help dialogs##remarks5.2.4:5.2.4 exit}
        {help dialogs##remarks5.2.5:5.2.5 close}
        {help dialogs##remarks5.3:5.3 Error-checking and presentation commands}
        {help dialogs##remarks5.3.1:5.3.1 require}
        {help dialogs##remarks5.3.2:5.3.2 stopbox}
        {help dialogs##remarks5.4:5.4 Command-construction commands}
        {help dialogs##remarks5.4.1:5.4.1 by}
        {help dialogs##remarks5.4.2:5.4.2 bysort}
        {help dialogs##remarks5.4.3:5.4.3 put}
        {help dialogs##remarks5.4.4:5.4.4 varlist}
        {help dialogs##remarks5.4.5:5.4.5 ifexp}
        {help dialogs##remarks5.4.6:5.4.6 inrange}
        {help dialogs##remarks5.4.7:5.4.7 weight}
        {help dialogs##remarks5.4.8:5.4.8 beginoptions and endoptions}
        {help dialogs##remarks5.4.8.1:5.4.8.1 option}
        {help dialogs##remarks5.4.8.2:5.4.8.2 optionarg}
        {help dialogs##remarks5.5:5.5 Command-execution commands}
        {help dialogs##remarks5.5.1:5.5.1 stata}
        {help dialogs##remarks5.5.2:5.5.2 clear}
        {help dialogs##remarks5.6:5.6 Special scripts and programs}

        {help dialogs##remarks6.:6. Properties}
       
        {help dialogs##remarks7.:7. Child dialogs}
        {help dialogs##remarks7.1:7.1 Referencing the parent}
        
        {help dialogs##remarks8.:8. Example}

        {help dialogs##AppendixA:Appendix A:  Jargon}
        {help dialogs##AppendixB:Appendix B:  Class definition of dialog boxes}
        {help dialogs##AppendixC:Appendix C:  Interface guidelines for dialog boxes}

        {help dialogs##faqs:Frequently asked questions}


{marker intro}{...}
{title:1. Introduction}

{pstd}
At a programming level, the purpose of a dialog box is to produce a Stata
command to be executed.  Along the way, it hopefully provides the
user with an intuitive and consistent experience -- that is your job as a
dialog-box programmer -- but the ultimate output will be

       {cmd:list mpg weight} or
       {cmd:regress mpg weight if foreign} or
       {cmd:append using myfile}

{pstd}
or whatever other Stata command is appropriate.  Dialog boxes are limited to
executing one Stata command, but that does not limit what you can do with
them because that Stata command can be an ado-file.  (Actually,
there is another way around the one-command limit, which we will discuss in
{it:{help dialogs##remarks5.1.3:5.1.3 rstrings: cmdstring and optstring}}.)

{pstd}
This ultimate result is called the dialog box's u-action.

{pstd}
The u-action of the dialog box is determined by the code you write, called
dialog code, which you store in a {cmd:.dlg} file.  The name of the {cmd:.dlg}
file is important because it determines the name of the dialog box.  When a
user types

       {cmd:. db regress}

{pstd}
{cmd:regress.dlg} is executed.  Stata finds the file the same way it finds
ado-files -- by looking along the ado-path; see {manhelp sysdir P}.
{cmd:regress.dlg} runs regress commands because of the 
dialog code that appears inside the {cmd:regress.dlg} file.  {cmd:regress.dlg}
could just as well execute {cmd:probit} commands or even {cmd:merge} commands
if the code were written differently.

{pstd}
{cmd:.dlg} files describe

{p 8 11 2}
1. how the dialogs look;

{p 8 11 2}
2. how the input controls of the dialogs interact with each other; and

{p 8 11 2}
3. how the u-action is constructed from the user's input.

{pstd}
Items 1 and 2 determine how intuitive and consistent the user finds the
dialog.  Item 3 determines what the dialog box does.  Item 2 determines
whether some fields are disabled or hidden so that they cannot be mistakenly
filled in until the user clicks on something, checks something, or fills in a
certain result.


{marker remarks2}{...}
{title:2. Concepts}

{pstd}
A dialog box is composed of many elements called controls, including static
text, edit fields, and checkboxes.  Input controls are those that the user
fills in, such as checkboxes and text-entry fields.  Static controls are fixed
text and lines that appear on the dialog box but that the user cannot change.
See {it:{help dialogs##AppendixA:Appendix A}} below for definitions of the
various types of controls as well as other related jargon.

{pstd}
In the jargon we use, a dialog box is composed of dialogs, and dialogs are
composed of controls.  When a dialog box contains multiple dialogs, only one
dialog is shown at a time.  Here access to the dialogs is made
possible through small tabs.  Clicking on the tab associated with a dialog
makes that dialog active.

{pstd}
The dialog box may contain the helper buttons {hi:Help} (shown as a small button
with a question mark on it) and {hi:Reset} (shown as a small button with an
{hi:R} on it).  These buttons appear in the dialog box -- not the individual
dialogs -- so in a multiple-dialog dialog box, they appear regardless of the
dialog (tab) selected.

{pstd}
The {hi:Help} helper button displays a help file associated with the dialog box.

{pstd}
The {hi:Reset} helper button resets the dialog box to its initial state.  Each
time a user invokes a particular dialog box, it will remember the values last
set for its controls.  The reset button allows the user to restore the default
values for all controls in the dialog box.

{pstd}
The dialog box may also include the u-action buttons {hi:OK}, {hi:Submit}, 
{hi:Copy}, and {hi:Cancel}.  Like the helper buttons, u-action buttons appear 
in the dialog box -- not the individual dialogs -- so in a 
multiple-dialog dialog box, they appear regardless of the dialog (tab) selected.

{pstd}
The {hi:OK} u-action button constructs the u-action, sends it 
to Stata for execution, and closes the dialog box.

{pstd}
The {hi:Submit} u-action button constructs the u-action, sends it
to Stata for execution, and leaves the dialog box open.

{pstd}
The {hi:Copy} u-action button constructs the u-action, sends it
to the clipboard, and leaves the dialog box open.

{pstd}
The {hi:Cancel} u-action button closes the dialog box without
constructing the u-action.

{pstd}
A dialog box does not have to include all of these u-action buttons, but it 
needs at least one.

{pstd}
Thus the nesting is 

	Dialog box, which contains
	   Dialog 1, which contains
	      input controls and static controls
 	   Dialog 2, which is optional and which, if defined, contains
	      input controls and static controls
	   [.  .  .]
           Helper buttons, which are optional and which, if defined, contain
             [{hi:Help} button]
             [{hi:Reset} button]
           U-action buttons, which contain
             [{hi:OK} button]
             [{hi:Submit} button]
             [{hi:Copy} button]
             [{hi:Cancel} button]

{pstd}
Said differently, 

{p 8 11 2}
1. a dialog box must have at least one dialog, must have one set of u-action
buttons, and may have helper buttons;

{p 8 11 2}
2. a dialog must have at least one control and may have many controls; and

{p 8 11 2}
3. the u-action buttons may include any of {hi:OK}, {hi:Submit}, {hi:Copy}, and
{hi:Cancel} and must include at least one of them.


{pstd}
Here is a simple {cmd:.dlg} file that will execute the {helpb kappa} command, 
although it does not allow {cmd:if} {it:exp} and {cmd:in} {it:range}:

    {hline 10} BEGIN {hline 10} mykappa.dlg {hline 33}

    // ----------------- set version number and define size of box ---------
    VERSION {ccl stata_version}
    POSITION . . 290 200

    // ------------------------------------------- define a dialog ---------
    DIALOG main, label("kappa - Interrater agreement") 
    BEGIN
            TEXT    tx_var 10  10 270 ., label("frequency variables:")
            VARLIST vl_var  @ +20   @ ., label("frequencies")
    END

    // -------------------- define the u-action and helper buttons ---------
    OK     ok1, label("OK")
    CANCEL can1, label("Cancel")
    SUBMIT sub1, label("Submit")
    COPY   copy1,
    HELP   hlp1, view("help kappa")
    RESET  res1

    // --------------------------- define how to assemble u-action ---------
    PROGRAM command
    BEGIN
            put "kappa " 
            varlist main.vl_var
    END
    {hline 10} END {hline 10} mykappa.dlg {hline 35}


{marker remarks2.1}{...}
{title:2.1 Organization of the .dlg file}

{pstd}
A {cmd:.dlg} file consists of seven parts, some of which are optional:


    {hline 10} BEGIN {hline 10} {it:dialogboxname}.dlg{hline 28}
    VERSION {ccl stata_version}            {it:Part 1:  version number}
    POSITION . . .          {it:Part 2:  set size of dialog box}
    DEFINE . . .            {it:Part 3, optional:  common definitions}
    LIST . . . 
    DIALOG . . .            {it:Part 4: dialog definitions}
        BEGIN                   
            FILE . . .      {it:        . . . which contain input controls}
            BUTTON . . . 
            CHECKBOX . . .
            COMBOBOX . . .
            EDIT . . .
            LISTBOX . . .
            RADIO . . .
            SPINNER . . .
            VARLIST . . .
            VARNAME . . .
    
            FRAME . . .     {it:        . . . and static controls}
            GROUPBOX . . . 
            TEXT . . .
        END
            {it:repeat} {it:DIALOG}. . . {it:BEGIN}. . . {it:END} {it:as necessary}

    SCRIPT . . .            {it:Part 5, optional:  i-action definitions}
        BEGIN               {it:        . . . usually done as scripts}
            . . .
        END
    PROGRAM . . .           {it:        . . . but sometimes as programs}
        BEGIN
            . . .
        END
    
    OK . . .                {it:Part 6:  u-action and helper button definitions}
    CANCEL . . . 
    SUBMIT . . .
    HELP . . .
    RESET . . .
    
    PROGRAM command         {it:Part 7:  u-action definition}
        BEGIN
            . . .
        END
    {hline 10} END {hline 10} {it:dialogboxname}.dlg{hline 28}

{pstd}
The {hi:VERSION} statement must appear at the top; the other parts may appear
in any order.

{pstd}
{it:I-actions}, mentioned in {it:Part 5}, are intermediate actions, such
as hiding or showing, disabling or enabling a control, or opening the
Viewer to display something, etc., while leaving the dialog up and 
waiting for the user to fill in more or press a u-action button.


{marker remarks2.2}{...}
{title:2.2 Positions, sizes, and the DEFINE command}

{pstd}
Part of specifying how a dialog appears is defining where things go 
and how big they are.

{pstd}
Positions are indicated by a pair of numbers, {it:x} and {it:y}.  They are
measured in pixels and are interpreted as being measured from the top-left
corner:  {it:x} is how far to the right, and {it:y} is how far down.

{pstd}
Sizes are similarly indicated by a pair of numbers, {it:xsize} and 
{it:ysize}.  They, too, are measured in pixels and indicate the size starting
at the top-left corner of the object.

{pstd}
Any command that needs a position or a size always takes all four
numbers -- position and size -- and you must specify all four.  In
addition to each element being allowed to be a number, some extra codes are
allowed.  A position or size element is defined as
 
{p2colset 9 17 17 0}{...}
{p2col :{it:#}}any unsigned integer number, such as 0, 1, 10, 200, ....{p_end}

{p2col :{it:.}}(period) meaning the context-specific default value for
this position or size element.  {cmd:.} is allowed only with heights
of controls (heights are measured from the top down) and for the initial
position of a dialog box.{p_end}

{p2col :{cmd:@}}means the previous value for this position or size element.
If {cmd:@} is used for an {it:x} or a {it:y}, then the {it:x} or {it:y} from
the preceding command will be used.  If {cmd:@} is used for an {it:xsize} or
a {it:ysize}, then the previous {it:xsize} or {it:ysize} will be used.{p_end}

{p2col :{cmd:+}{it:#}}means a positive offset from the last value (meaning to
the right or down or bigger).  If {cmd:+10} is used for {it:x}, the result
will be 10 pixels to the right of the previous position.  If {cmd:+10} is used 
for a {it:ysize}, it means 10 pixels taller.{p_end}

{p2col :{cmd:-}{it:#}}means a negative offset from the last value (meaning to
the left or up or smaller).  If {cmd:-10} is used for {it:y}, the result will
be 10 pixels above the previous position.  If {cmd:-10} is used for an
{it:xsize}, it means 10 pixels narrower.{p_end}

{p2col :{it:name}}means the value last recorded for {it:name} by the 
{hi:DEFINE} command.{p_end}
{p2colreset}{...}

{pstd}
The {cmd:DEFINE} command has the syntax 

        {bind:DEFINE {it:name} { {cmd:.}|{it:#}|{cmd:+}{it:#}|{cmd:-}{it:#}|{cmd:@x}|{cmd:@y}|{opt @xs:ize}|{opt @ys:ize} }}

{pstd}
and may appear anywhere in your dialog code, even inside the 
{hi:BEGIN}/{hi:END} of {hi:DIALOG}.  Anywhere you need to specify a
position or size element, you can use a {it:name} defined by {hi:DEFINE}.

{pstd}
The first four possibilities for defining {it:name} have the obvious meaning:
{cmd:.} means the default, {it:#} means the number specified, {cmd:+}{it:#}
means a positive offset, and {cmd:-}{it:#} means a negative offset.  The other
four possibilities -- {cmd:@x}, {cmd:@y}, {cmd:@xsize}, and {cmd:@ysize} --
refer to the previous {it:x}, {it:y}, {it:xsize}, and {it:ysize} values, with
"previous" meaning previous to the time the {cmd:DEFINE} command was issued.


{marker remarks2.3}{...}
{title:2.3 Default values}

{pstd}
You can also load input controls with initial, or default, values.
For instance, perhaps, as a default, you want one
checkbox checked and another unchecked, and you want an edit field filled in
with "Default title".

{pstd}
The syntax of the {hi:CHECKBOX} command, which creates checkboxes, is 

        {bind:{hi:CHECKBOX} . . . [{cmd:,} . . .  {opt default(defnumval)} . . .]}

{pstd}
In checkboxes, the {opt default()} option specifies how the box is to be
filled in initially, and 1 corresponds to checked and 0 to unchecked.

{pstd}
The syntax of {hi:EDIT}, which creates edit fields, is 

        {bind:{cmd:EDIT} . . . [{cmd:,} . . . {opt default(defstrval)} . . .]}
 
{pstd}
In edit fields, {opt default()} specifies what the box will contain initially.

{pstd}
Wherever {it:defnumval} appears in a syntax diagram, you may type 

{p2colset 5 34 36 2}{...}
{p2col :{it:defnumval}}Definition{p_end}
{p2line}
{p2col :{it:#}}meaning the number specified{p_end}
{p2col :{opt literal} {it:#}}same as {it:#}{p_end}
{p2col :{opt c(name)}}value of {opt c(name)}; see {manhelp creturn P}{p_end}
{p2col :{opt r(name)}}value of {opt r(name)}; see {manhelp return P}{p_end}
{p2col :{opt e(name)}}value of {opt e(name)}; see {manhelp ereturn P}{p_end}
{p2col :{opt s(name)}}value of {opt s(name)}; see {manhelp return P}{p_end}
{p2col :{cmd:global} {it:name}}value of global macro {cmd:$}{it:name}{p_end}
{p2line}
{p2colreset}{...}

{pstd}
Wherever {it:defstrval} appears in a syntax diagram, you may type 

{p2colset 5 34 36 2}{...}
{p2col :{it:defstrval}}Definition{p_end}
{p2line}
{p2col :{it:string}}meaning the string specified{p_end}
{p2col :{cmd:literal} {it:string}}same as {it:string}{p_end}
{p2col :{opt c(name)}}contents of {opt c(name)}; see {manhelp creturn P}{p_end}
{p2col :{opt r(name)}}contents of {opt r(name)}; see {manhelp return P}{p_end}
{p2col :{opt e(name)}}contents of {opt e(name)}; see {manhelp ereturn P}{p_end}
{p2col :{opt s(name)}}contents of {opt s(name)}; see {manhelp return P}{p_end}
{p2col :{cmd:char} {it:varname}{cmd:[}{it:charname}{cmd:]}}value of characteristic; see
    {manhelp char P}{p_end}
{p2col :{cmd:global} {it:name}}contents of global macro {cmd:$}{it:name}{p_end}
{p2line}
{p 4 6 2}Note: If {it:string} is enclosed in double quotes (simple or compound),
the first set of quotes is stripped.{p_end}
{p2colreset}{...}

{pstd}
List and combo boxes present the user with a list of items from which 
to choose.  In dialog-box jargon, rather than having initial 
or default values, the boxes are said to be populated.  The syntax for 
creating a list-box input control is 

        {bind:{cmd:LISTBOX} . . . [{cmd:,} . . . {opt contents(conspec)} . . .]}

{pstd}
Wherever a {it:conspec} appears in a syntax diagram, you may type 

{phang}
{cmd:list} {it:listname}{break}
populates the box with the specified list, which you create separately by using
the {cmd:LIST} command.  {cmd:LIST} has the following syntax:

            {cmd:LIST}
                {cmd:BEGIN}
                    {it:item to appear}
                    {it:item to appear}
                    . . . 
                {cmd:END}

{phang}
{opt mat:rix}{break}
populates the box with the names of all matrices currently defined in Stata.

{phang}
{opt vec:tor}{break}
populates the box with the names of all 1 {it:x} {it:k} and {it:k} {it:x} 1
matrices currently defined in Stata.

{phang}
{cmd:row}{break}
populates the box with the names of all 1 {it:x} {it:k} matrices currently
defined in Stata.

{phang}
{opt col:umn}{break}
populates the box with the names of all {it:k} {it:x} 1 matrices currently
defined in Stata.

{phang}
{opt sq:uare}{break}
populates the box with the names of all {it:k} {it:x} {it:k} matrices currently
defined in Stata.

{phang}
{opt sca:lar}{break}
populates the box with the names of all scalars currently defined in Stata.

{phang}
{opt constr:aint}{break}
populates the box with the names of all constraints currently defined in
Stata.

{phang}
{opt est:imates}{break}
populates the box with the names of all saved estimates currently defined in
Stata.

{phang}
{cmd:char} {it:varname}{cmd:[}{it:charname}{cmd:]}{break}
populates the box with the elements of the characteristic 
{bind:{it:varname}{cmd:[}{it:charname}{cmd:]}}, parsed on spaces.

{phang}
{opt e(name)}{break}
populates the box with the elements of {opt e(name)}, parsed on spaces.

{phang}
{opt glo:bal}{break}
populates the box with the names of all global macros currently defined in
Stata.

{phang}
{opt valuelab:els}{break}
populates the box with the names of all values labels currently defined in
Stata.


{pstd}
Predefined lists for use with Stata graphics:

{p2colset 9 32 34 2}{...}
{p2col :Predefined lists}Definition{p_end}
{p2line}
{p2col :{opt symbols}}list of marker symbols{p_end}
{p2col :{opt symbolsizes}}list of marker symbol sizes{p_end}
{p2col :{opt colors}}list of colors{p_end}
{p2col :{opt intensity}}list of fill intensities{p_end}
{p2col :{opt clockpos}}list of clock positions{p_end}
{p2col :{opt linepatterns}}list of line patterns{p_end}
{p2col :{opt linewidths}}list of line widths{p_end}
{p2col :{opt connecttypes}}list of line connecting types{p_end}
{p2col :{opt textsizes}}list of text sizes{p_end}
{p2col :{opt justification}}list of horizontal text justifications{p_end}
{p2col :{opt alignment}}list of vertical text alignments{p_end}
{p2col :{opt margin}}list of margins{p_end}
{p2col :{opt tickpos}}list of axis-tick positions{p_end}
{p2col :{opt angles}}list of angles; usually used for axis labels{p_end}
{p2col :{opt compass}}list of compass directions{p_end}
{p2col :{opt yesno}}list containing Default, Yes, and No; usually accompanied 
		    by a user-defined {it:values} list{p_end}
{p2line}
{p2colreset}{...}


{marker remarks2.4}{...}
{title:2.4 Memory (recollection)}

{pstd}
All input control commands have a {opt default()} or {opt contents()}
option that specifies how the control is to be filled in, for example,

        {bind:{hi:CHECKBOX} . . . [{cmd:,} . . .  {opt default(defnumval)} . . .]}

{pstd}
In this command, if {it:defnumval} evaluates to 0, the checkbox is initially
unchecked; otherwise, it is checked.  If {opt default()} is not
specified, the box is initially unchecked.

{pstd}
Dialogs remember how they were last filled in
during a session, so the next time the user invokes the dialog box that
contains this {hi:CHECKBOX} command, the {opt default()} option will be
ignored and the checkbox will be as the user last left it.  That is, the 
setting will be remembered unless you specify the
input control's {opt nomemory} option.

        {bind:{hi:CHECKBOX} . . . [{cmd:,} . . . {opt default(defnumval)} {cmd:nomemory} . . .]}

{pstd}
{opt nomemory} specifies that the dialog-box manager not remember between
invocations how the control is filled in; it will always reset it 
to the default, whether that default is explicitly specified or implied.

{pstd}
Whether or not you specify {opt nomemory}, explicit or implicit defaults are
also restored when the user presses the {hi:Reset} helper button.

{pstd}
The contents of dialog boxes are only remembered during a session, not between
them.  Within a session, the {helpb discard} command causes Stata to forget
the contents of all dialog boxes.

{pstd}
The issues of initialization and memory are in fact more complicated than they
first appear.  Consider a list box.  A list box might be
populated with the currently saved estimates.  If the dialog box containing
this list box is closed and reopened, the available estimates may have
changed.  So list boxes are always repopulated according to the
instructions given.  Even so, list boxes remember the choice that was made.
If that choice is still among the possibilities, that choice will be the one
selected unless {opt nomemory} is specified; otherwise, the choice goes back to
being the default -- the first choice in the list of alternatives.

{pstd}
The same issues arise with combo boxes, and that is why some controls have the
{opt default()} option and others have {opt contents()}.  {opt default()} is
used once, and after that, memory is substituted (unless {cmd:nomemory} is
specified).  {opt contents()} is always used -- {cmd:nomemory} or not -- but
the choice made is remembered (unless {cmd:nomemory} is specified).


{marker remarks2.5}{...}
{title:2.5 I-actions and member functions}

{pstd}
I-actions -- intermediate actions -- refer to all actions taken
in producing the u-action.  An i-action might disable or hide
controls when another control is checked or unchecked, although there are
many other possibilities.  I-actions are always optional.

{pstd}
I-actions are invoked by {opt on}{it:*}{cmd:()} options -- those
that begin with the letters "{opt on}".  For instance, the syntax for the
{hi:CHECKBOX} command -- the command for defining a checkbox
control -- is

    {bind:{hi:CHECKBOX} {it:controlname} . . . [{cmd:,} . . . {opt onclickon(iaction)} {opt onclickoff(iaction)} . . .]}

{pstd}
{opt onclickon()} is the i-action to be taken when the checkbox is checked,
and {opt onclickoff()} is the i-action for when the checkbox is unchecked.
You do not have to fill in the {opt onclickon()} and {opt onclickoff()}
options  -- the checkbox will work fine taking no i-actions -- but
g_programming##remarks2.3
you may fill them in if you want, say, to disable or to enable other controls
when this control is checked.  For instance, you might code

    {bind:{cmd:CHECKBOX sw2} . . . {cmd:, onclickon(d2.sw3.show) onclickoff(d2.sw3.hide)} . . .}

{pstd}
{opt d2.sw3} refers to the control named {opt sw3} in the dialog
{opt d2} (for instance, the control we just defined is named {opt sw2}).
{opt hide} and {opt show} are called member functions.  {opt hide} is the
member function that hides a control, and {opt show} is its inverse.  Controls
have other member functions as well; what member functions are available is
documented with the command that creates the specific control.

{pstd}
Many commands have {opt on}{it:*}{cmd:()} options that allow you to specify
i-actions.  When {it:iaction} appears in a syntax diagram, you can specify

{phang}
{cmd:.} (period){break}
Do nothing; take no action.  This is the default if you do not specify the
{opt on}{it:*}{opt ()} option.

{phang}
{bind:{cmd:gaction} {it:dialogname}{cmd:.}{it:controlname}{cmd:.}{it:memberfunction}} {cmd:[}{it:arguments}{cmd:]}{break}
Execute the specified {it:memberfunction} on the specified control, where
{it:memberfunction} may be

{pmore}
{bind:{{cmd:hide}|{cmd:show}|{cmd:disable}|{cmd:enable}|{cmd:setposition}|{it:something_else} {cmd:[}{it:arguments}{cmd:]}}}

{pmore}
All controls provide the {it:memberfunctions} {opt hide}, {opt show}, 
{opt disable}, {opt enable}, and {opt setposition}, and some controls make 
other, special {it:memberfunctions} available.

{pmore}
{opt hide} specifies that the control disappear from view (if it has not
already done so).  {opt show} specifies that it reappear (if it is not already
visible).

{pmore}
{opt disable} specifies that the control be disabled (if it is not already).
{opt enable} specifies that it be enabled (if it is not already).

{pmore}
{opt setposition} specifies the new position and size of a control.
{opt setposition} requires {it:arguments} in the form of
{bind:{it:x} {it:y} {it:xsize} {it:ysize}}.  A dot can be used with any of the 
four {it:arguments} to mean the current value.

{pmore}
Sometimes {it:arguments} may require quotes.  For
instance, {hi:CHECKBOX} provides a special {it:memberfunction}

            {cmd:setlabel} {it:string}

{pmore}
which sets the text shown next to the checkbox, so you might specify
{bind:{cmd:onclickon}{cmd:(}{cmd:'"gaction main.robust.setlabel "Robust VCE""'}{cmd:)}}.
Anytime a {it:string} is required, you must place quotes around it if that
{it:string} contains a space.  When you specify an {it:iaction} inside the
parentheses of an option, it is easier to leave the quotes off unless they are
required.  If quotes are required, you must enclose the entire
contents of the option in compound double quotes as in the example above.

{phang}
{bind:{it:dialogname}{cmd:.}{it:controlname}{cmd:.}{it:memberfunction} {cmd:[}{it:arguments}{cmd:]}}{break}
Same as {opt gaction}; the {opt gaction} is optional.

{phang}
{bind:{cmd:action} {it:memberfunction} {cmd:[}{it:arguments}{cmd:]}}{break}
Same as {cmd:gaction}
{bind:{it:currentdialog}{cmd:.}{it:currentcontrol}{cmd:.}{it:memberfunction}};
executes the specified {it:memberfunction} on the current control.

{phang}
{cmd:view} {it:topic}{break}
Display {it:topic} in viewer; see {manhelp view R}.

{phang}
{cmd:script} {it:scriptname}{break}
Execute the specified script.  A script is a set of lines, each specifying an
{it:iaction}.  So if you wanted to disable three things, {opt gaction} would
be insufficient.  You would instead define a script containing the three 
{opt gaction} lines.

{phang}
{cmd:program} {it:programname}{break}
Execute the specified dialog-box program.  Programs can do more than scripts
because they provide if-statement flow of control (among other things), but
they are more difficult to write; typically, the extra capabilities are
not needed when specifying i-actions.

{marker remarks2.5.7}{...}
{phang}
{cmd:create} {opt STRING|DOUBLE|BOOLEAN} {it:propertyname}{break}
Creates a new instance of a dialog property.
See {it:{help dialogs##remarks6.:6. Properties}} for details.

{phang}
{cmd:create} {opt PSTRING|PDOUBLE|PBOOLEAN} {it:propertyname}{break}
Creates a new instance of a persistent dialog property.
See {it:{help dialogs##remarks6.:6. Properties}} for details.

{phang}
{cmd:create} {opt CHILD} {it:dialogname} [{cmd:AS} {it:referencename}][{cmd:, nomodal allowsubmit allowcopy}]{break}
Creates a new instance of a child dialog.
By default, the reference name will be the 
name of the dialog unless otherwise specified.
See {it:{help dialogs##remarks7.:7. Child dialogs}} for details.


{marker remarks2.6}{...}
{title:2.6 U-actions and communication options}

{pstd}
Remember that the ultimate goal of a dialog box is to construct a
u-action -- a Stata command to be executed.  What that command is
depends on how the user fills in the dialog box.

{pstd}
You construct the command by writing a dialog-box
program, also known as a {hi:PROGRAM}.  You arrange that the program be
invoked by specifying the {opt uaction()} option allowed with the {hi:OK},
{hi:SUBMIT}, {hi:CANCEL}, and {hi:COPY} u-action buttons.
For instance, the syntax of {hi:OK} is

        {bind:{cmd:OK} . . . [{cmd:,} . . . {opt uaction(pgmname)} {opt target(target)} . . .]}

{pstd}
{it:pgmname} is the name of the dialog program you write, and {opt target()}
specifies how the command constructed by {it:pgmname} is to be executed.
Usually, you will simply want Stata to execute the command, which 
could be coded {cmd:target(stata)}, but because that is the default, most 
programmers omit the {opt target()} option altogether.

{pstd}
The dialog-box program you write accesses the information the user has filled
in and outputs the Stata command to be executed.  Without going into details,
the program might say to construct the command by outputting the word
{hi:regress}, followed by the {varlist} the user specified in
the varlist field of the first dialog, and followed by {opt if} {it:exp},
getting the expression from what the user filled in an edit field of the
second dialog.

{pstd}
Dialogs and input controls are named, and in your dialog-box program, when you
want to refer to what a user has filled in, you refer to
{bind:{it:dialogname}{cmd:.}{it:inputcontrolname}}.  {it:dialogname} was
determined when you coded the {hi:DIALOG} command to create the dialog

            {cmd:DIALOG} {it:dialogname} . . .

{pstd}
and {it:inputcontrolname} was determined when you coded the input-control
command to create the input control, for instance,

            {hi:CHECKBOX} {it:inputcontrolname} . . .

{pstd}
The details are discussed in {it:{help dialogs##remarks5:5. PROGRAM}}, but do
not get lost in the details.  Think first about coding how the dialogs look
and second about how to translate what the user specifies into the u-action.

{pstd}
On the various commands that specify how dialogs look, you can specify
an option that will make writing the u-action program easier:
the communication option {opt option()}, which communicates
something about the control to the u-action program, is allowed with every
control.  For instance, on the {hi:CHECKBOX} command, you could code

            {bind:{hi:CHECKBOX} . . . {cmd:,} . . .  {cmd:option(robust)} . . . }

{pstd}
When you wrote your dialog-box {hi:PROGRAM}, you
would find it easier to associate the {opt robust} option in the command
you are constructing with this checkbox.  Communication options
never alter how a control looks or works: they just make extra information
available to the {hi:PROGRAM} and make writing the u-action routine
easier.

{pstd}
Do not worry much about communication options when writing your dialog.
Wait until you are writing the corresponding u-action program.  Then
it will be obvious what communication options you should have specified, 
and you can go back and specify them.


{marker remarks2.7}{...}
{title:2.7 The distinction between i-actions and u-actions}

{pstd}
In this documentation, we distinguish between i-actions and u-actions, but if
you read carefully, you will realize that the distinction is more syntactical
than real.  One way we have distinguished i-actions from u-actions is to note
that only u-actions can run Stata commands.  In fact, i-actions can also run
Stata commands; you just code them differently.  In
the vast majority of dialog boxes, you will not do this.

{pstd}
Nevertheless, if you were writing a dialog box to edit a Stata graph, you
might construct your dialog box so that it contained no u-actions
and only i-actions.  Some of those i-actions might invoke Stata commands.

{pstd}
As you already know, i-actions can invoke {hi:PROGRAM}s, and {hi:PROGRAM}s
serve two purposes:  coding of i-actions and coding of u-actions.
{hi:PROGRAM}s themselves, however, have the ability to submit commands to
Stata, and therein lies the key.  I-actions can invoke {hi:PROGRAM}s, and
{hi:PROGRAM}s can invoke Stata commands.  How this is done is 
discussed in
{it:{help dialogs##remarks5.1.3:5.1.3 rstrings: cmdstring and optstring}} and
{it:{help dialogs##remarks5.5:5.5 Command-execution commands}}.

{pstd}
We recommend that you not program i-actions and u-actions that are 
virtually indistinguishable except in
rare, special circumstances.  Users expect to fill in a dialog box and to be
given the opportunity to click on {hi:OK} or {hi:Submit} before anything too
severe happens.


{marker remarks2.8}{...}
{title:2.8 Error and consistency checking}

{pstd}
In filling in the dialogs you construct, the user might make errors.  One
alternative is simply to ignore that possibility and let Stata complain when
it executes the u-action command you construct.  Even in well-written dialog
boxes, most errors should be handled this way because discovering
all the problems would require rewriting the entire logic of the Stata
command.

{pstd}
Nevertheless, you will want to catch easy-to-detect errors while the dialog is
still open and the user can easily fix them.  Errors come in two forms:
An outright error would be typing a number in an edit field that is supposed
to contain a variable name.  A consistency error would be checking two checkboxes
that are, logically speaking, mutually exclusive.

{pstd}
You will want to handle most consistency errors at the dialog level, either by
design (if two checkboxes are mutually exclusive, perhaps the information
should be collected as radio buttons) or by i-actions (disabling
or even hiding some fields depending on what has been filled in).
The latter was discussed in
{it:{help dialogs##remarks2.5:2.5 I-actions and member functions}}.

{pstd}
Outright errors can be detected and handled in dialog-box programs and are
usually detected and handled in the u-action program.  For instance, in your
dialog-box program, you can assert that 
{bind:{it:dialogname}{cmd:.}{it:inputcontrolname}} must be filled in and pop
up a custom error message if it is not, or the program code can be written so
that an automatically generated error message is presented.  You will find
that all input-control commands have an {opt error()} option; for example,

            {bind:{cmd:VARLIST} . . . [{cmd:,} . . . {opt error(string)} . .  .]}

{pstd}
The {opt error()} string provides the text to describe the control when the 
dialog-box manager presents an error.  For instance, if we specified

            {bind:{cmd:VARLIST} . . . [{cmd:,} . . . {opt error(dependent variable)} . . .]}

{pstd}
the dialog-box manager might use that information later to construct the error
message "dependent variable must be specified".

{pstd}
If you do not specify the {opt error()} option, the dialog-box manager will
use what was specified in the {opt label()}; otherwise, {cmd:""} is used.
The {opt label()} option specifies the text that usually appears near the
control describing it to the user, but {opt label()} will do double duty so
that you only need to specify {opt error()} when the two strings need to
differ.


{marker remarks3}{...}
{title:3. Commands}


{marker remarks3.1}{...}
{title:3.1 VERSION}

{title:Syntax}

{p 8 15 2}
{bind:{cmd:VERSION} {it:#}[{cmd:.}{it:##}] [{it:valid_operating_systems}]}


{title:Description}

{pstd}
{hi:VERSION} specifies how the commands that follow are to be interpreted.


{title:Remarks}

{pstd}
{hi:VERSION} must appear first in the {cmd:.dlg} file (it may be preceded by
comments).  In the current version of Stata, it should read 
{hi:VERSION {ccl stata_version}}.

{pstd}
Optionally, {hi:VERSION} can specify one or more valid operating systems.
Accepted values are {cmd:WINDOWS}, {cmd:MACINTOSH}, and {cmd:UNIX}.  If none
of these are specified, all are assumed.

{pstd}
Including {hi:VERSION} at the top is of vital importance.  Stata is under
continual development, so syntax and features can change.  Including
{hi:VERSION} is how you ensure that your dialog box will continue to work
as you intended.


{marker remarks3.2}{...}
{title:3.2 INCLUDE}

{title:Syntax}

{p 8 15 2}
{bind:{cmd:INCLUDE} {it:includefilename}}

{pstd}
where {it:includefilename} refers to {it:includefilename}{cmd:.idlg} and
must be specified without the suffix and without a path.


{title:Description}

{pstd}
{hi:INCLUDE} reads and processes the lines from {it:includefilename}{cmd:.idlg}
just as if they were part of the current file being read.
{hi:INCLUDE} may appear in both {cmd:.dlg} and {cmd:.idlg} files.


{title:Remarks}

{pstd}
The name of the file is specified without a file suffix and without a path.
{cmd:.idlg} files are searched for along the ado-path, as are {cmd:.dlg}
files.

{pstd}
{hi:INCLUDE} may appear anywhere in the dialog code and may appear in both
{cmd:.dlg} and {cmd:.idlg} files; include files may {hi:INCLUDE} other
include files.  Files may contain multiple {hi:INCLUDE}s.  The maximum
nesting depth is 10.


{marker remarks3.3}{...}
{title:3.3 DEFINE}

{title:Syntax}

{p 8 14 2}
{cmd:DEFINE} {it:name}
{{cmd:.}|{it:#}|{cmd:+}{it:#}|{cmd:-}{it:#}|{cmd:@x}|{cmd:@y}|{opt @xs:ize}|{cmd:,}{opt @ys:ize}}


{title:Description}

{pstd}
{hi:DEFINE} creates {it:name}, which may be used in other commands wherever a
position or size element is required.


{title:Remarks}

{pstd}
The first four possibilities for defining {it:name} -- {cmd:.},
{it:#}, {cmd:+}{it:#}, and {cmd:-}{it:#} -- specify default, number
specified, positive offset, and negative offset.

{pstd}
The other four possibilities -- {opt @x}, {opt @y}, {opt @xsize}, and
{opt @ysize} -- refer to the previous {it:x}, {it:y}, {it:xsize}, and
{it:ysize} values, with "previous" meaning previous to the time the
{cmd:DEFINE} command is issued, not at the time {it:name} is used.


{marker remarks3.4}{...}
{title:3.4 POSITION}

{title:Syntax}

{p 8 16 2}
{bind:{cmd:POSITION} {it:x} {it:y} {it:xsize} {it:ysize}}


{title:Description}

{pstd}
{hi:POSITION} is used to set the location and size of the dialog box.
{it:x} and {it:y} refer to the upper-left-hand corner of
the dialog box.  {it:xsize} and {it:ysize} refer to the 
width and height of the dialog box.


{title:Remarks}
 
{pstd}
The positions {it:x} and {it:y} may each be specified as {cmd:.}, and Stata
will determine where the dialog box will be displayed; this is recommended.

{pstd}
{it:xsize} and {it:ysize} may not be specified as {cmd:.} because they specify
the overall size of the dialog box.  You can discover the size by
experimentation.  If you specify a size that is too small, some elements will
flow off the dialog box.  If you specify a size that is too large, there 
will be large amounts of white space on the right and bottom of the dialog
box.  Good initial values for {it:xsize} and {it:ysize} are 400 and 300.

{pstd}
{hi:POSITION} may be specified anywhere in the dialog code outside
{hi:BEGIN} . . . {hi:END} blocks.  It does not matter where it is specified
because the entire {cmd:.dlg} file is processed before the dialog box is
displayed.


{marker remarks3.5}
{title:3.5 LIST}

{title:Syntax}

       {cmd:LIST} {it:newlistname}
           {cmd:BEGIN}
               {it:item}
               {it:item}
               . . . 
           {cmd:END}


{title:Description}

{pstd}
{hi:LIST} creates a named list for populating list and combo boxes.


{title:Example}

       LIST choices
           BEGIN
               Statistics
               Graphics
               Data management
           END
       . . . 
       DIALOG . . . 
           BEGIN
              . . .
              LISTBOX . . . , . . . contents(choices) . . .  
              . . . 
           END


{marker remarks3.6}{...}
{title:3.6 DIALOG}

{title:Syntax}

       {bind:{cmd:DIALOG} {it:newdialogname} [{cmd:,} {opt ti:tle}("{it:string}") {opt tab:title}("{it:string}")]}
           BEGIN
               {{it:control definition statements}|{cmd:INCLUDE}|{cmd:DEFINE}}
               . . .
           END


{title:Description}

{pstd}
{hi:DIALOG} defines a dialog.  Every {cmd:.dlg} file should define at least one
dialog.  Only control definition statements, {hi:INCLUDE}, and {hi:DEFINE}
are allowed between {hi:BEGIN} and {hi:END}.


{title:Options}

{phang}
{opt title}{cmd:("}{it:string}{cmd:")} defines the text to be displayed in the
dialog's title bar.

{phang}
{opt tabtitle}{cmd:("}{it:string}{cmd:")} defines the text to be displayed on
the dialog's tab.  Dialogs are tabbed if more than one dialog is defined.
When a user clicks on the tab, the dialog becomes visible and active.  If only
one dialog is specified, the contents of {opt tabtitle()} are irrelevant.


{title:Member functions}

{p2colset 5 27 29 2}{...}
{p2col :{cmd:settabtitle} {it:string}}sets tab title to {it:string}{p_end}
{p2col :{cmd:settitle} {it:string}}sets overall dialog box title to {it:string}{p_end}
{p2colreset}{...}

{pstd}
{cmd:settitle} may be called as a member function of any 
dialog tab, but it is more appropriate to call it as a member 
function of the dialog box.  This is accomplished by calling it 
in the local scope of the dialog.

{pstd}
Example: 

{p 8 4 2}
{cmd: settitle "sort - Sort data"}


{marker remarks3.6.1}{...}
{title:3.6.1 CHECKBOX on/off input control}

{title:Syntax}

{p 8 12 2}
{hi:CHECKBOX} {it:newcontrolname} {it:x} {it:y} {it:xsize} {it:ysize} 
[{cmd:,} {opt l:abel}{cmd:("}{it:string}{cmd:")} 
         {opt e:rror}{cmd:("}{it:string}{cmd:")} 
         {opt default(defnumval)} {opt nomem:ory} 
         {cmd:groupbox} {opt onclickon(iaction)} 
         {opt onclickoff(iaction)} {opt op:tion(optionname)}
         {cmd:tooltip("}{it:string}{cmd:")}]
 

{title:Member functions}

{p2colset 5 27 29 2}{...}
{p2col :{cmd:setlabel} {it:string}}sets text to {it:string}{p_end}
{p2col :{cmd:setoff}}unchecks checkbox{p_end}
{p2col :{cmd:seton}}checks checkbox{p_end}
{p2col :{cmd:setoption} {it:optionname}}associates {it:optionname}
	with the value of the checkbox{p_end}
{p2col :{cmd:setdefault} {it:value}}sets the default value for the 
	checkbox; this does not change the selected state{p_end}
{p2col :{cmd:settooltip} {it:string}}sets the tooltip text to {it:string}{p_end}
{p2colreset}{...}

{pstd}	
The standard member functions {opt hide}, {opt show}, {opt disable}, 
{opt enable}, and {opt setposition} are also provided.


{title:Returned values for use in PROGRAM}

{pstd}	
Returns numeric, 0 or 1, depending on whether the box is checked.


{title:Description}

{pstd}
{hi:CHECKBOX} defines a checkbox control, which indicates
an option that is either on or off.


{title:Options}

{phang}
{opt label}{cmd:("}{it:string}{cmd:")} specifies the text to be displayed next
to the control.  You should specify text that clearly implies two opposite
states so that it is obvious what happens when the checkbox is checked or
unchecked.

{phang}
{opt error}{cmd:("}{it:string}{cmd:")} specifies the text to be displayed 
describing this field to the user in automatically generated error boxes.

{phang}
{opt default(defnumval)} specifies whether the box is checked or unchecked 
initially; it will be unchecked if {it:defnumval} evaluates to 0, and it will
be checked otherwise.  If {opt default()} is not specified, {cmd:default(0)}
is assumed.

{phang}
{opt nomemory} specifies that the checkbox not remember how it was filled in
between invocations.

{phang}
{opt groupbox} makes this checkbox control also a group box into which other
controls can be placed to emphasize that they are related.
The group box is just
an outline; it does not cause the controls "inside" to be disabled or hidden
or in any other way act differently than they would if they were outside the
group box.  On some platforms, radio buttons have precedence over checkbox
group boxes.  You may place radio buttons within a checkbox group box, but do
not place a checkbox group box within a group of radio buttons.  If you do,
you may not be able to click on the checkbox control on some platforms.

{phang}
{opt onclickon(iaction)} and {opt onclickoff(iaction)} specify the i-actions
to be invoked when the checkbox is clicked on or off.  This could be used, for
instance, to hide, show, disable, or enable other input controls.  The default
i-action is to do nothing.  The {opt onclickon()} or 
{opt onclickoff()} i-action will be invoked the first time the checkbox is
displayed.

{phang}
{opt option(optionname)} is a communication option that associates
{it:optionname} with the value of the checkbox.

{phang}
{opt tooltip}{cmd:("}{it:string}{cmd:")} specifies the text to be displayed
as a tip or hint when the user hovers over the control with the mouse.


{title:Example}

{psee}{cmd:CHECKBOX robust 10 10 100 ., label(Robust VCE)}{p_end}


{marker remarks3.6.2}{...}
{title:3.6.2 RADIO on/off input control}

{title:Syntax}

{p 8 15 2}
{cmd:RADIO} {it:newcontrolname} {it:x} {it:y} {it:xsize} {it:ysize} 
[{cmd:,} [{opt f:irst}|{opt m:iddle}|{opt la:st}] 
                {opt l:abel}{cmd:("}{it:string}{cmd:")} 
                {opt e:rror}{cmd:("}{it:string}{cmd:")}
                {opt default(defnumval)} {opt nomem:ory}
                {opt onclickon(iaction)} {opt onclickoff(iaction)}
                {opt op:tion(optionname)}
                {cmd:tooltip("}{it:string}{cmd:")}]


{title:Member functions}

{p2colset 5 27 29 2}{...}
{p2col :{cmd:setlabel} {it:string}}sets text to {it:string}{p_end}
{p2col :{cmd:seton}}checks the radio button and unchecks any other buttons
	in the group{p_end}
{p2col :{cmd:setoption} {it:optionname}}associates {it:optionname}
	with the value of the radio{p_end}
{p2col :{cmd:setdefault} {it:value}}sets the default value for the 
	radio; this does not change the selected state{p_end}
{p2col :{cmd:settooltip} {it:string}}sets the tooltip text to {it:string}{p_end}
{p2colreset}{...}

{phang}
The standard member functions {opt hide}, {opt show}, {opt disable}, 
{opt enable}, and {opt setposition} are also provided.


{title:Returned values for use in PROGRAM}

{pstd}
Returns numeric, 0 or 1, depending on whether the button is checked.


{title:Description}

{pstd}
{hi:RADIO} defines a radio button control in a radio-button group.  Radio
buttons are used in groups of two or more to select mutually exclusive, but
related, choices when the number of choices is small.  Selecting one radio
button automatically unselects the others in its group.


{title:Options}

{phang}
{opt first}, {opt middle}, and {opt last} specify whether this radio button is
the first, a middle, or the last member of a group.  There must be one 
{opt first} and one {opt last}.  There can be zero or more {opt middle}
members.  {opt middle} is the default if no option is specified.

{phang}
{opt label}{cmd:("}{it:string}{cmd:")} specifies the text to be displayed next
to the control.

{phang}
{opt error}{cmd:("}{it:string}{cmd:")} specifies the text to be displayed
describing this field to the user in automatically generated error boxes.

{phang}
{opt default(defnumval)} specifies whether the radio button is to start as
selected or unselected; it will be unselected if {it:defnumval} evaluates to 0
and will be selected otherwise.  If {opt default()} is not specified, 
{cmd:default(0)} is assumed unless {opt first} is also specified, in which
case {cmd:default(1)} is assumed.  It is considered bad style to use
anything other than the first button as the default, so this option is rarely
specified.

{phang}
{opt nomemory} specifies that the radio button not remember how it was filled
in between invocations.

{phang}
{opt onclickon(iaction)} and {opt onclickoff(iaction)} specify that i-action
be invoked when the radio button is clicked on or clicked off.  This could be
used, for instance, to hide, show, disable, or enable other input controls.
The default i-action is to do nothing.  The {opt onclickon()}
i-action will be invoked the first time the radio button is displayed if it is
selected.

{phang}
{opt option(optionname)} is a communication option that associates
{it:optionname} with the value of the radio button.

{phang}
{opt tooltip}{cmd:("}{it:string}{cmd:")} specifies the text to be displayed
as a tip or hint when the user hovers over the control with the mouse.


{title:Example}

    {hi:RADIO} {cmd: r1 10  10 100 ., first  label("First choice")}
    {hi:RADIO} {cmd: r2  @ +20   @ ., middle label("Second choice")}
    {hi:RADIO} {cmd: r3  @ +20   @ ., middle label("Third choice")}
    {hi:RADIO} {cmd: r4  @ +20   @ ., last   label("Last choice")}


{marker remarks3.6.3}{...}
{title:3.6.3 SPINNER numeric input control} 

{title:Syntax}

{p 8 17 2}
{cmd:SPINNER} {it:newcontrolname} {it:x} {it:y} {it:xsize} {it:ysize} 
[{cmd:,} {opt l:abel}{cmd:("}{it:string}{cmd:")}
        {opt e:rror}{cmd:("}{it:string}{cmd:")}
        {opt default(defnumval)} {opt nomem:ory} {opt min(defnumval)}
        {opt max(defnumval)} {opt onchange(iaction)}
        {opt op:tion(optionname)}
        {cmd:tooltip("}{it:string}{cmd:")}]


{title:Member functions}

{p2colset 5 26 28 2}{...}
{p2col :{cmd:setvalue} {it:{help dialogs##specialdefs.:value}}}sets the actual value of the spinner to {it:{help dialogs##specialdefs.:value}}{p_end}
{p2col :{cmd:setrange} {it:min# max#}}sets the range of the spinner to {it:min# max#}{p_end}
{p2col :{cmd:setoption} {it:optionname}}associates {it:optionname}
	with the value of the spinner{p_end}
{p2col :{cmd:setdefault} {it:#}}sets the default of the spinner to {it:#};
	this does not change the value shown in the spinner control{p_end}
{p2col :{cmd:settooltip} {it:string}}sets the tooltip text to {it:string}{p_end}
{p2colreset}{...}

{pstd}
The standard member functions {opt hide}, {opt show}, {opt disable}, 
{opt enable}, and {opt setposition} are also provided.


{title:Returned values for use in PROGRAM}

{pstd}
Returns numeric, the value of the spinner.


{title:Description}

{pstd}
{hi:SPINNER} defines a spinner, which displays an edit field that accepts
an integer number, which the user may either increase or decrease by
clicking on an up or down arrow.


{title:Options}

{phang} 
{opt label}{cmd:("}{it:string}{cmd:")} specifies a description for the
control, but it does not display the label next to the spinner.  If you want
to label the spinner, you must use a {hi:TEXT} static control.

{phang}
{opt error}{cmd:("}{it:string}{cmd:")} specifies the text to be displayed in
describing this field to the user in automatically generated error boxes.

{phang}
{opt default(defnumval)} specifies the initial integer value of the spinner.
If not specified, {opt min()} is assumed, and if that is not specified, 0 is
assumed.

{phang}
{opt nomemory} specifies that the spinner not remember how it was filled in
between invocations.

{phang}
{opt min(defnumval)} and {opt max(defnumval)} set the minimum and maximum
integer values of the spinner.  {cmd:min(0)} and {cmd:max(100)} are the
defaults.

{phang}
{opt onchange(iaction)} specifies the i-action to be invoked when the spinner
is changed.  The default i-action is to do nothing.  The 
{opt onchange()} i-action will be invoked the first time the spinner is
displayed.

{phang}
{opt option(optionname)} is a communication option that associates
{it:optionname} with the value of the spinner.

{phang}
{opt tooltip}{cmd:("}{it:string}{cmd:")} specifies the text to be displayed
as a tip or hint when the user hovers over the control with the mouse.


{title:Example}

{psee}{cmd:SPINNER level 10 10 60 ., label(Sig. level) min(5) max(100)} ///{break}
{cmd:default(c(level)) option(level)}{p_end}


{marker remarks3.6.4}{...}
{title:3.6.4 EDIT string input control}

{title:Syntax}

{p 8 14 2} 
EDIT {it:newcontrolname} {it:x} {it:y} {it:xsize} {it:ysize} 
     [{cmd:,} {opt l:abel}("{it:string}") {opt e:rror}("{it:string}")
     {opt default(defstrval)} {opt nomem:ory} {opt max(#)} 
     {cmd: numonly password} {opt onchange(iaction)}
     {opt op:tion(optionname)}
     {cmd:tooltip("}{it:string}{cmd:")}]


{title:Member functions}

{p2colset 5 30 32 2}{...}
{p2col :{cmd:setlabel} {it:string}}sets the label for the edit field{p_end}
{p2col :{cmd:setvalue} {it:{help dialogs##specialdefs.:strvalue}}}sets the value shown in the edit field{p_end}
{p2col :{cmd:append} {it:string}}appends {it:string} to the value in the edit field{p_end}
{p2col :{cmd:prepend} {it:string}}prepends {it:string} to the value of the edit field{p_end}
{p2col :{cmd:insert} {it:string}}inserts {it:string} at the current cursor position of the edit field{p_end}
{p2col :{cmd:smartinsert} {it:string}}inserts {it:string} at the
        current cursor position in the edit field with leading and 
        trailing spaces around it{p_end}
{p2col :{cmd:setfocus}}causes the control to obtain keyboard focus{p_end}
{p2col :{cmd:setoption} {it:optionname}}associates {it:optionname}
	with the contents of the edit field{p_end}
{p2col :{cmd:setdefault} {it:string}}sets the default value for the edit field;
	this does not change what is displayed{p_end}
{p2col :{cmd:settooltip} {it:string}}sets the tooltip text to {it:string}{p_end}
{p2colreset}{...}

{pstd}
The standard member functions {opt hide}, {opt show}, {opt disable},
{opt enable}, and {opt setposition} are also provided.


{title:Returned values for use in PROGRAM}

{pstd}
Returns {it:string}, the contents of the edit field.


{title:Description}

{pstd}
{hi:EDIT} defines an edit field.  An edit field is a box into which the 
user may enter text or in which the user may edit text; the width of the box
does not limit how much text can be entered.


{title:Options}

{phang}
{opt label}{cmd:("}{it:string}{cmd:")} specifies a description for the
control, but it does not display the label next to the edit field.  If you
want to label the edit field, you must use a {hi:TEXT} static control.

{phang}
{opt error}{cmd:("}{it:string}{cmd:")} specifies the text to be displayed
describing this field to the user in automatically generated error boxes.

{phang}
{opt default(defstrval)} specifies the default contents of the edit field.  If
not specified, {opt default("")} is assumed.

{phang}
{opt nomemory} specifies that the edit field is not to remember how it was
filled in between invocations.

{phang}
{opt max(#)} specifies the maximum number of characters that may be entered
into the edit field.

{phang}
{opt numonly} specifies that the edit field be able to contain only a period,
numeric characters 0 through 9, and {cmd:-} (minus).

{phang}
{opt password} specifies that the characters entered into the edit field be
shown on the screen as asterisks or bullets, depending on the operating
system.

{phang}
{opt onchange(iaction)} specifies the i-action to be invoked when the contents
of the edit field are changed.  The default i-action is to do nothing.  Note
that the {opt onchange()} i-action will be invoked the first time the edit field
is displayed.

{phang}
{opt option(optionname)} is a communication option that associates
{it:optionname} with the contents of the edit field.

{phang}
{opt tooltip}{cmd:("}{it:string}{cmd:")} specifies the text to be displayed
as a tip or hint when the user hovers over the control with the mouse.


{title:Example}

   {hi:TEXT} {cmd:tlab   10  10 200   ., label("Title")}
   {hi:EDIT} {cmd:title   @ +20   @   ., label("title")}


{marker remarks3.6.5}
{title:3.6.5 VARLIST and VARNAME string input controls}

{title:Syntax}

{p 8 19 2} 
{{hi:VARLIST}|{hi:VARNAME}} {it:newcontrolname} 
    {it:x} {it:y} {it:xsize} {it:ysize} [{cmd:,}
    {opt l:abel}("{it:string}") {opt e:rror}("{it:string}")
    {opt default(defstrval)} {opt nomem:ory} {cmd:fv ts}
    {opt op:tion(optionname)}
     {cmd:tooltip("}{it:string}{cmd:")}]


{title:Member functions}

{p2colset 5 30 32 2}{...}
{p2col :{opt setlabel} {it:string}}sets the label for the varlist edit
field{p_end}
{p2col :{opt setvalue} {it:{help dialogs##specialdefs.:strvalue}}}sets the value shown in the varlist edit field{p_end}
{p2col :{opt append} {it:string}}appends {it:string} to the value in the varlist edit field{p_end}
{p2col :{opt prepend} {it:string}}prepends {it:string} to the value of the varlist edit field{p_end}
{p2col :{opt insert} {it:string}}inserts {it:string} at the current cursor position of the varlist edit field{p_end}
{p2col :{opt smartinsert} {it:string}}inserts {it:string} at the
	current cursor position in the varlist edit field with leading and trailing 
	spaces around it{p_end}
{p2col :{cmd:setfocus}}causes the control to obtain keyboard focus{p_end}
{p2col :{cmd:setoption} {it:optionname}}associates {it:optionname}
	with the contents of the edit field{p_end}
{p2col :{cmd:setdefault} {it:string}}sets the default value for the edit field;
	this does not change what is displayed{p_end}
{p2col :{cmd:settooltip} {it:string}}sets the tooltip text to {it:string}{p_end}
{p2colreset}{...}

{pstd}
The standard member functions {opt hide}, {opt show}, {opt disable}, 
{opt enable}, and {opt setposition} are also provided.


{title:Returned values for use in PROGRAM}

{pstd}
Returns {it:string}, the contents of the varlist edit field.


{title:Description}

{pstd}
{hi:VARLIST} and {hi:VARNAME} are special cases of an edit field.
{hi:VARLIST} provides an edit field into which one or more Stata variable
names may be entered (along with standard Stata varlist abbreviations), and
{hi:VARNAME} provides an edit field into which one Stata variable name may be
entered (with standard Stata varname abbreviations allowed). 


{title:Options}

{phang}
{opt label}{cmd:("}{it:string}"{cmd:)} specifies a description for the
control, but does not display the label next to the varlist edit field.  If
you want to label the control, you must use a {hi:TEXT} static control.

{phang}
{opt error}{cmd:("}{it:string}"{cmd:)} specifies the text to be displayed
describing this field to the user in automatically generated error boxes.

{phang}
{opt default(defstrval)} specifies the default contents of the edit field.  If
not specified, {opt default("")} is assumed.

{phang}
{opt nomemory} specifies that the edit field not remember how it was filled in
between invocations.

{phang}
{opt fv} specifies that the control add a factor-variable dialog button.

{phang}
{opt ts} specifies that the control add a time-series-operated variable dialog
button.

{phang}
{opt option(optionname)} is a communication option that associates
{it:optionname} with the contents of the edit field.

{phang}
{opt tooltip}{cmd:("}{it:string}{cmd:")} specifies the text to be displayed
as a tip or hint when the user hovers over the control with the mouse.


{title:Example}

    {hi:TEXT}     {cmd:dvlab     10  10 200   ., label("Dependent variable")}
    {hi:VARNAME}  {cmd:depvar     @ +20   @   ., label("dep. var")}
    {hi:TEXT}     {cmd:ivlab      @ +30   @   ., label("Independent variables")}
    {hi:VARLIST}  {cmd:idepvars   @ +20   @   ., label("ind. vars.")}


{marker remarks3.6.6}{...}
{title:3.6.6 FILE string input control}

{title:Syntax}

{p 8 16 2}
{cmd:FILE} {it:newcontrolname} {it:x} {it:y} {it:xsize} {it:ysize}
    [{cmd:,} {opt l:abel}("{it:string}") {opt e:rror}("{it:string}")
    {opt default(defstrval)} {opt nomem:ory} {opt buttonw:idth(#)}
    {opt dialogti:tle(string)} {cmd:save} {opt multi:select} {opt dir:ectory}
    {opt filter(string)}
    {opt onchange(iaction)} {opt op:tion(optionname)}
    {cmd:tooltip("}{it:string}{cmd:")}]


{title:Member functions}

{p2colset 5 30 32 2}{...}
{p2col :{opt setlabel} {it:string}}sets the label shown on the edit button{p_end}
{p2col :{opt setvalue} {it:{help dialogs##specialdefs.:strvalue}}}sets the value shown in the edit field{p_end}
{p2col :{opt append} {it:string}}appends {it:string} to the value in the edit field{p_end}
{p2col :{opt prepend} {it:string}}prepends {it:string} to the value of the edit field{p_end}
{p2col :{opt insert} {it:string}}inserts {it:string} at the current cursor position of the edit field{p_end}
{p2col :{opt smartinsert} {it:string}}inserts {it:string} at the
	current cursor position in the edit field with leading and trailing spaces around it{p_end}
{p2col :{cmd:setoption} {it:optionname}}associates {it:optionname}
	with the contents of the edit field{p_end}
{p2col :{cmd:setdefault} {it:string}}sets the default value for the edit field;
	this does not change what is displayed{p_end}
{p2col :{cmd:settooltip} {it:string}}sets the tooltip text to {it:string}{p_end}
{p2colreset}{...}

{pstd}
The standard member functions {opt hide}, {opt show}, {opt disable}, 
{opt enable}, and {opt setposition} are also provided.


{title:Returned values for use in PROGRAM}

{pstd}
Returns {it:string}, the contents of the edit field (the file chosen).


{title:Description}

{pstd}
{hi:FILE} is a special edit field with a button on the right for selecting a
filename.  When the user clicks on the button, a file dialog is displayed.  If
the user selects a filename and clicks on {hi:OK}, that filename is put into the
edit field.  The user may alternatively type a filename into the edit field.


{title:Options}

{phang}
{opt label}{cmd:("}{it:string}{cmd:")} specifies the text to appear on the button.  The
default is {bind:{cmd:("Browse . . .")}}.

{phang}
{opt error}{cmd:("}{it:string}{cmd:")} specifies the text to be displayed
describing this field to the user in automatically generated error boxes.

{phang}
{opt default(defstrval)} specifies the default contents of the edit
field.  If not specified, {opt default("")} is assumed.

{phang}
{opt nomemory} specifies that the edit field not remember how it was filled in
between invocations.

{phang}
{opt buttonwidth(#)} specifies the width in pixels of the button.  The default
is {cmd:buttonwidth(80)}.  The overall size specified in {it:xsize} includes
the button.

{phang}
{opt dialogtitle(string)} is the title to show on the file dialog when you
click on the file button.

{phang}
{opt save} specifies that the file dialog allow the user to choose a filename
for saving rather than one for opening.

{phang}
{opt multiselect} specifies that the file dialog allow the user to select
multiple filenames rather than only one filename.

{phang}
{opt directory} specifies that the file dialog select a 
directory rather than a filename.  If specified, any nonrelevant options
will be ignored.

{phang}
{opt filter(string)} consists of pairs of descriptions and wildcard file
selection strings separated by "{opt |}", such as

{pmore}
{cmd:filter("Stata Graphs|*.gph|All Files|*.*")}

{phang}
{opt onchange(iaction)} specifies an i-action to be invoked when the user
changes the chosen file.  The default i-action is to do nothing.  
The {opt onchange()} i-action will be invoked the first time the file chooser
is displayed.

{phang}
{opt option(optionname)} is a communication option that associates
{it:optionname} with the contents of the edit field.

{phang}
{opt tooltip}{cmd:("}{it:string}{cmd:")} specifies the text to be displayed
as a tip or hint when the user hovers over the control with the mouse.


{title:Example}

{psee}{cmd:FILE fname 10 10 300 ., error("Filename to open") label("Browse . . .")}{p_end}


{marker remarks3.6.7}{...}
{title:3.6.7 LISTBOX list input control}

{title:Syntax}

{p 8 19 2}
{cmd:LISTBOX} {it:newcontrolname} {it:x} {it:y} {it:xsize} {it:ysize}
[{cmd:,}
    {opt l:abel}{cmd:("}{it:string}{cmd:")} {opt e:rror}{cmd:("}{it:string}{cmd:")}
    {opt nomem:ory} {opt cont:ents(conspec)} {opt val:ues(listname)}
    {opt default(defstrval)}
    {opt ondblclick(iaction)}
    [{opt onselchange(iaction)}|{opt onselchangelist(listname)}]
    {opt op:tion(optionname)}
    {cmd:tooltip("}{it:string}{cmd:")}]


{title:Member functions}

{p2colset 8 30 32 2}{...}
{p2col :{opt setlabel} {it:string}}sets the label for the list box{p_end}
{p2col :{opt setvalue} {it:{help dialogs##specialdefs.:strvalue}}}sets the currently selected item{p_end}
{p2col :{cmd:setfocus}}causes the control to obtain keyboard focus{p_end}
{p2col :{cmd:setoption} {it:optionname}}associates {it:optionname}
	with the element chosen from the list{p_end}
{p2col :{cmd:setdefault} {it:string}}sets the default value for the list box;
	this does not change what is displayed{p_end}
{p2col :{cmd:repopulate}}causes the associated contents list to rebuild itself
	and then updates the control with the new values from that list{p_end}
{p2col :{cmd:forceselchange}}forces an {cmd:onselchange} event to occur{p_end}
{p2col :{cmd:settooltip} {it:string}}sets the tooltip text to {it:string}{p_end}
{p2colreset}{...}

{pstd}
The standard member functions {opt hide}, {opt show}, {opt disable},
{opt enable}, and {opt setposition} are also provided.


{title:Returned values for use in PROGRAM}

{pstd}
Returns {it:string}, the text of the item chosen, or, if {opt values(listname)} is
specified, the text from the corresponding element of {it:listname}.


{title:Description}

{pstd}
{hi:LISTBOX} defines a list box control.  Like radio buttons, a list box
allows the user to make a selection from a number of mutually exclusive, but
related, choices.  A list box control is more appropriate when the number
of choices is large.


{title:Options}

{phang}
{opt label}{cmd:("}{it:string}{cmd:")} specifies a description for the
control but does not display the label next to the control.  If you want to
label the list box, you must use a {hi:TEXT} static control.

{phang}
{opt error}{cmd:("}{it:string}{cmd:")} specifies the text to be displayed
describing this field to the user in automatically generated error boxes.

{phang}
{opt nomemory} specifies that the list box not remember the item selected
between invocations.

{phang}
{opt contents(conspec)} specifies the items to be shown in the list box.
If {opt contents()} is not specified, the list box will be empty.

{phang}
{opt values(listname)} specifies the list (see
{it:{help dialogs##remarks3.5:3.5 LIST}}) for which the
values of {opt contents()} should match one to one.  When the user chooses the
{it:k}th element from {opt contents()}, the {it:k}th element of {it:listname}
will be returned.  If the lists do not match one to one, extra elements of
{it:listname} are ignored, and extra elements of {opt contents()} return
themselves.

{phang}
{opt default(defstrval)} specifies the default selection.  If not specified, 
or if {it:defstrval} does not exist, the first item is the default.

{phang}
{opt ondblclick(iaction)} specifies the i-action to be invoked when an item in
the list is double clicked.  The double-clicked item is selected
before the {it:iaction} is invoked.

{phang}
{opt onselchange(iaction)} and {opt onselchangelist(listname)} are
alternatives.  They specify the i-action to be invoked when a selection in the
list changes.

{pmore}
{opt onselchange(iaction)} performs the same i-action, regardless of which
element of the list was chosen.

{pmore}
{opt onselchangelist(listname)} specifies a vector of {it:iactions} that
should match one to one with {opt contents()}.  If the user selects the
{it:k}th element of {opt contents()}, the {it:k}th i-action from {it:listname}
is invoked.  See {it:{help dialogs##remarks3.5:3.5 LIST}} for information on
creating {it:listname}.  If the elements of {it:listname} do not match one to
one with the elements of {opt contents()}, extra elements are ignored, and if
there are too few elements, the last element will be invoked for the extra
elements of {opt contents()}.

{phang}
{opt option(optionname)} is a communication option that associates
{it:optionname} with the element chosen from the list.

{phang}
{opt tooltip}{cmd:("}{it:string}{cmd:")} specifies the text to be displayed
as a tip or hint when the user hovers over the control with the mouse.


{title:Example}

    LIST ourlist
        BEGIN
            Good
            Common or average
            Poor
        END
    . . .
    DIALOG . . . 
        BEGIN
            . . . 
            TEXT ourlab    10  10 200   ., label("Pick a rating")
            LISTBOX rating  @ +20 150 200, contents(ourlist)
            . . .
        END


{marker remarks3.6.8}{...}
{title:3.6.8 COMBOBOX list input control}

{title:Syntax}

{p 8 12 2} 
{hi:COMBOBOX} {it:newcontrolname} {it:x} {it:y} {it:xsize} {it:ysize}
    [{cmd:,}
    {opt l:abel}{cmd:("}{it:string}{cmd:")}
    {opt e:rror}{cmd:("}{it:string}{cmd:")}
    [{cmd:regular|dropdown|}{opt dropdownl:ist}]
    {opt default(defstrval)}
    {opt nomem:ory}
    {opt cont:ents(conspec)}
    {opt val:ues(listname)}
    {cmd:append}
    [{opt onselchange(iaction)}|{opt onselchangelist(listname)}] 
    {opt op:tion(optionname)}
    {cmd:tooltip("}{it:string}{cmd:")}]


{title:Member functions}

{p2colset 5 30 32 2}{...}
{p2col :{opt setlabel} {it:string}}sets the label for the combo box{p_end}
{p2col :{opt setvalue} {it:{help dialogs##specialdefs.:strvalue}}}in the case of regular and drop-down
	combo boxes, sets the value of the edit field; in the case of a
	{opt dropdownlist}, sets the currently selected item{p_end}
{p2col :{cmd:setfocus}}causes the control to obtain keyboard focus{p_end}
{p2col :{cmd:setoption} {it:optionname}}associates {it:optionname}
	with the element chosen from the list{p_end}
{p2col :{cmd:setdefault} {it:string}}sets the default value for the combo box;
	this does not change what is displayed or selected{p_end}
{p2col :{cmd:repopulate}}causes the associated contents list to rebuild itself
	and then updates the control with the new values from that list{p_end}
{p2col :{cmd:forceselchange}}forces an {cmd:onselchange} event to occur{p_end}
{p2col :{cmd:settooltip} {it:string}}sets the tooltip text to {it:string}{p_end}
{p2colreset}{...}

{phang}
Also, except for drop-down lists (option {hi:dropdownlist}
specified), the following member functions are also available:

{p2colset 5 30 32 2}{...}
{p2col :{opt append} {it:string}}appends {it:string} to the value in the edit field{p_end}
{p2col :{opt prepend} {it:string}}prepends {it:string} to the value of the edit field{p_end}
{p2col :{opt insert} {it:string}}inserts {it:string} at the current cursor position of the edit field{p_end}
{p2col :{opt smartinsert} {it:string}}inserts {it:string} at the
current cursor position in the edit field with leading and trailing spaces around it{p_end}
{p2colreset}{...}

{pstd}
The standard member functions {opt hide}, {opt show}, {opt disable}, 
{opt enable}, and {opt setposition} are also always provided.


{title:Returned values for use in PROGRAM}

{pstd}
Returns {it:string}, the contents of the edit field.


{title:Description}

{pstd}
{hi:COMBOBOX} defines regular combo boxes, drop-down combo boxes, and
drop-down-list combo boxes.  By default, {hi:COMBOBOX} creates a regular combo
box; it creates a drop-down combo box if the {hi:dropdown} option is specified,
and it creates a drop-down-list combo box if the {hi:dropdownlist} option is
specified.

{pstd}
A regular combo box contains an edit field and a visible list box.  The user
may make a selection from the list box, which is entered into the edit field,
or type in the edit field.  Multiple selections are allowed using the
{hi:append} option.  Regular combo boxes are useful for allowing multiple
selections from the list as well as for allowing the user to type in an item
not in the list.

{pstd}
A drop-down combo box contains an edit field and a list box that appears when
the control is clicked on.  The user may make a selection from the list box,
which is entered into the edit field, or type in the edit field.
The control has the same functionality and options as a regular combo box but
requires less space.  Multiple selections are allowed using the {hi:append}
option.  Drop-down combo boxes may
be cumbersome to use if the number of choices is large, so use them only
when the number of choices is small or when space is limited.

{pstd}
A drop-down-list combo box contains a list box that displays only the current
selection.  Clicking on the control displays the entire list box, allowing the
user to make a selection without typing in the edit field; the user 
chooses among the given alternatives.  Drop-down-list combo boxes should be used
only when the number of choices is small or when space is limited.


{title:Options}

{phang}
{opt label}{cmd:("}{it:string}{cmd:")} specifies a description for the
control but does not display the label next to the combo box.  If you want
to label a combo box, you must use a {hi:TEXT} static control.

{phang}
{opt error}{cmd:("}{it:string}{cmd:")} specifies the text to be displayed
    describing this field to the user in automatically generated error boxes.

{phang}
{hi:regular}, {hi:dropdown}, and {hi:dropdownlist} specify the type of
combo box to be created.

{pmore}
If {hi:regular} is specified, a regular combo box is created.  {hi:regular}
is the default.

{pmore}
If {hi:dropdown} is specified, a drop-down combo box is created.

{pmore}
If {hi:dropdownlist} is specified, a drop-down-list combo box is created.

{phang}
{opt default(defstrval)} specifies the default contents of the edit field.  If
not specified, {opt default("")} is assumed.  If {hi:dropdownlist} is specified,
the first item is the default.

{phang}
{opt nomemory} specifies that the combo box not remember the item selected
between invocations.  Even for drop-down 
lists -- where there is no {opt default()} -- combo boxes remember
previous selections by default.

{phang}
{opt contents(conspec)} specifies the items to be shown in the list box from
which the user may choose.  If {opt contents()} is not specified, the list box
will be empty.

{phang}
{opt values(listname)} specifies the list (see
{it:{help dialogs##remarks3.5:3.5 LIST}}) for which the
values of {opt contents()} should match one to one.  When the user chooses the
{it:k}th element from {opt contents()}, the {it:k}th element of {it:listname}
is copied into the edit field.  If the lists do not match one to one, extra
elements of {it:listname} are ignored, and extra elements of {opt contents()}
return themselves.

{phang}
{hi:append} specifies that selections made from the combo box's list box be
appended to the contents of the combo box's edit field.  By default,
selections replace the contents of the edit field.  {hi:append} is not allowed
if {hi:dropdownlist} is also specified.

{phang}
{opt onselchange(iaction)} and {opt onselchangelist(listname)} are
alternatives that specify the i-action to be invoked when a selection in the
list changes.

{pmore}
{opt onselchange(iaction)} performs the same i-action, regardless of the
element of the list that was chosen.

{pmore}
{opt onselchangelist(listname)} specifies a vector of {it:iactions}
that should match one to one with {opt contents()}.  If the user selects the
{it:k}th element of {opt contents()}, the {it:k}th i-action from {it:listname}
is invoked.  See {it:{help dialogs##remarks3.5:3.5 LIST}} for information on
creating {it:listname}.  If the elements of {it:listname} do not match one to
one with the elements of {opt contents()}, extra elements are ignored, and if
there are too few elements, the last element will be invoked for the extra
elements of {opt contents()}.  {opt onselchangelist()} should not be
specified with {opt dropdown}. 

{phang}
{opt option(optionname)} is a communication option that associates
{it:optionname} with the element chosen from the list.

{phang}
{opt tooltip}{cmd:("}{it:string}{cmd:")} specifies the text to be displayed
as a tip or hint when the user hovers over the control with the mouse.


{title:Example}

        LIST namelist
            BEGIN
                John
                Sue
                Frank
            END
        . . .
        DIALOG . . .
            BEGIN
                . . . 
                TEXT ourlab    10  10 200   ., label("Pick one or more names")
                COMBOBOX names  @ +20 150 200, contents(namelist) append
                . . .
            END


{marker remarks3.6.9}{...}
{title:3.6.9 BUTTON special input control}

{title:Syntax}

{p 8 18 2}
{hi:BUTTON} {it:newcontrolname} {it:x} {it:y} {it:xsize} {it:ysize}
    [{cmd:,} {opt l:abel}{cmd:("}{it:string}{cmd:")}
    {opt e:rror}{cmd:("}{it:string}{cmd:")}
    {opt onpush(iaction)}
    {cmd:tooltip("}{it:string}{cmd:")}]


{title:Member functions}

{p2colset 5 26 28 2}{...}
{p2col :{opt setlabel} {it:string}}sets the label for the button{p_end}
{p2col :{opt setfocus}}causes the control to obtain keyboard focus{p_end}
{p2col :{cmd:settooltip} {it:string}}sets the tooltip text to {it:string}{p_end}
{p2colreset}{...}

{pstd}
The standard member functions {opt hide}, {opt show}, {opt disable}, 
{opt enable}, and {opt setposition} are also provided.


{title:Returned values for use in PROGRAM}

{pstd}
None.


{title:Description}

{pstd}
{hi:BUTTON} creates a push button that performs instantaneous
actions.  Push buttons do not indicate a state, such as on or off, and do 
not return anything for use by the u-action {hi:PROGRAM}.  Buttons are used
to invoke i-actions.


{title:Options}

{phang}
{opt label}{cmd:("}{it:string}{cmd:")} specifies the text to display on the button.
You should specify text that contains verbs that describe the action to perform.

{phang}
{opt error}{cmd:("}{it:string}{cmd:")} specifies the text to be displayed
describing this field to the user in automatically generated error boxes.

{phang}
{opt onpush(iaction)} specifies the i-action to be invoked when the button is
clicked on.  If {opt onpush()} is not specified, the button does nothing.

{phang}
{opt tooltip}{cmd:("}{it:string}{cmd:")} specifies the text to be displayed
as a tip or hint when the user hovers over the control with the mouse.


{title:Example}

{psee}
{hi:BUTTON} {cmd:help 10 10 80 ., label("Help") onpush("view help example")}
{p_end}
 

{marker remarks3.6.10}{...}
{title:3.6.10 TEXT static control}

{title:Syntax}

{p 8 16 2}
{hi:TEXT} {it:newcontrolname} {it:x} {it:y} {it:xsize} {it:ysize}
   [{cmd:,} 
   {opt l:abel}{cmd:("}{it:string}{cmd:")} 
   [{cmd:left}|{cmd:center}|{cmd:right}]]


{title:Member functions}

{p2colset 5 28 32 2}{...}
{p2col :{opt setlabel} {it:string}}sets the text shown{p_end}
{p2colreset}{...}

{pstd}
The standard member functions {opt hide}, {opt show}, {opt disable}, 
{opt enable}, and {opt setposition} are also provided.


{title:Returned values for use in PROGRAM}

{pstd}
None.


{title:Description}

{pstd}
{hi:TEXT} displays text.


{title:Options}

{phang}
{opt label}{cmd:("}{it:string}{cmd:")} specifies the text to be shown.

{phang}
{opt left}, {opt center}, and {opt right} are alternatives that specify the
horizontal alignment of the text with respect to {it:x}.  {opt left} is the
default.


{title:Example}

{psee}{hi: TEXT} {cmd:dvlab 10 10 200 ., label("Dependent variable")}{p_end}


{marker remarks3.6.11}{...}
{title:3.6.11 TEXTBOX static control}

{title:Syntax}

{p 8 16 2}
{hi:TEXTBOX} {it:newcontrolname} {it:x} {it:y} {it:xsize} {it:ysize}
   [{cmd:,} 
   {opt l:abel}{cmd:("}{it:string}{cmd:")} 
   [{cmd:left}|{cmd:center}|{cmd:right}]]


{title:Member functions}

{p2colset 5 28 32 2}{...}
{p2col :{opt setlabel} {it:string}}sets the text shown{p_end}
{p2colreset}{...}

{pstd}
The standard member functions {opt hide}, {opt show}, {opt disable}, 
{opt enable}, and {opt setposition} are also provided.


{title:Returned values for use in PROGRAM}

{pstd}
None.


{title:Description}

{pstd}
{hi:TEXTBOX} displays multiline text.


{title:Options}

{phang}
{opt label}{cmd:("}{it:string}{cmd:")} specifies the text to be shown.

{phang}
{opt left}, {opt center}, and {opt right} are alternatives that specify the
horizontal alignment of the text with respect to {it:x}.  {opt left} is the
default.


{title:Example}

{psee}{hi: TEXTBOX} {cmd:tx_note 10 10 200 45, label("Note ...")}{p_end}


{marker remarks3.6.12}{...}
{title:3.6.12 GROUPBOX static control}

{title:Syntax}

{p 8 13 2}
{hi:GROUPBOX} {it:newcontrolname} {it:x} {it:y} {it:xsize} {it:ysize}
    [{cmd:,} {opt l:abel}{cmd:("}{it:string}{cmd:")}]


{title:Member functions}

{p2colset 5 27 29 2}{...}
{p2col :{opt setlabel} {it:string}}sets the text shown above the group box{p_end}
{p2colreset}{...}

{pstd}
The standard member functions {opt hide}, {opt show}, {opt disable}, 
{opt enable}, and {opt setposition} are also provided.


{title:Returned values for use in PROGRAM}

{pstd}
None.


{title:Description}

{pstd}
{hi:GROUPBOX} displays a frame (an outline) with text displayed above it.
Group boxes are used for grouping related controls together.  The grouped
controls are sometimes said to be inside the group box, but there is no
meaning to that other than the visual effect.


{title:Options}

{phang}
{opt label}{cmd:("}{it:string}{cmd:")} specifies the text to be shown at the
top of the group box.


{title:Example}

{psee}
{hi:GROUPBOX} {cmd:weights 10 10 300 200, label("Weight type")}{break}
    {hi:RADIO} {cmd:w1 . . . , . . . label(fweight) first . . . }{break}
    {hi:RADIO} {cmd:w2 . . . , . . . label(aweight) . . . }{break}
    {hi:RADIO} {cmd:w3 . . . , . . . label(pweight) . . . }{break}
    {hi:RADIO} {cmd:w4 . . . , . . . label(iweight) last . . .}{p_end}


{marker remarks3.6.13}{...}
{title:3.6.13 FRAME static control}

{title:Syntax}

{p 8 15 2}
FRAME {it:newcontrolname} {it:x} {it:y} {it:xsize} {it:ysize} 
[{cmd:,} {opt l:abel}{cmd:("}{it:string}{cmd:")}]


{title:Member functions}

{pstd}
There are no special member functions provided.

{pstd}
The standard member functions {opt hide}, {opt show}, {opt disable}, 
{opt enable}, and {opt setposition} are also provided.


{title:Returned values for use in PROGRAM}

{pstd}
None.


{title:Description}

{pstd}
{hi:FRAME} displays a frame (an outline).


{title:Options}

{phang}
{opt label}{cmd:("}{it:string}{cmd:")} specifies the label for the frame,
which is not used in any way, but some programmers use it to record comments
documenting the purpose of the frame.


{title:Remarks}

{pstd}
The distinction between a frame and a group box with no label is that a frame
draws its outline using the entire dimensions of the control.  A group box
draws its outline a few pixels offset from the top of the control,
whether there is a label or not.  A frame is useful for horizontal alignment
with other controls.


{title:Example}

{psee}
{hi:FRAME} {cmd:box 10 10 300 200}{break}
    {hi:RADIO} {cmd:w1 . . . , . . . label(fweight) first . . . }{break}
    {hi:RADIO} {cmd:w2 . . . , . . . label(aweight) . . . }{break}
    {hi:RADIO} {cmd:w3 . . . , . . . label(pweight) . . . }{break}
    {hi:RADIO} {cmd:w4 . . . , . . . label(iweight) last . . .}{p_end}


{marker remarks3.6.14}{...}
{title:3.6.14 COLOR input control}

{title:Syntax}

{p 8 14 2} 
COLOR {it:newcontrolname} {it:x} {it:y} {it:xsize} {it:ysize} 
     [{cmd:,} {opt l:abel}("{it:string}") {opt e:rror}("{it:string}")
     {opt default(rgbvalue)} {opt nomem:ory} 
     {opt onchange(iaction)} {opt op:tion(optionname)}
     {cmd:tooltip("}{it:string}{cmd:")}]


{title:Member functions}

{p2colset 5 30 32 2}{...}
{p2col :{cmd:setvalue} {it:rgbvalue}}sets the rgb value of the color selector{p_end}
{p2col :{cmd:setoption} {it:optionname}}associates {it:optionname}
	with the selected color{p_end}
{p2col :{cmd:setdefault} {it:rgbvalue}}sets the default rgb value of 
	the color selector; this does not change the selected color{p_end}
{p2col :{cmd:settooltip} {it:string}}sets the tooltip text to {it:string}{p_end}
{p2colreset}{...}

{pstd}
The standard member functions {opt hide}, {opt show}, {opt disable},
{opt enable}, and {opt setposition} are also provided.


{title:Returned values for use in PROGRAM}

{pstd}
Returns {it:rgbvalue} of the selected color as a string.


{title:Description}

{pstd}
{hi:COLOR} defines a button to access a color selector.  The button shows the
color that is currently selected.


{title:Options}

{phang}
{opt label}{cmd:("}{it:string}{cmd:")} specifies a description for the
control, but it does not display the label next to the button.  If you
want to label the color control, you must use a {hi:TEXT} static control.

{phang}
{opt error}{cmd:("}{it:string}{cmd:")} specifies the text to be displayed 
describing this field to the user in automatically generated error boxes.

{phang}
{opt default(rgbvalue)} specifies the default color of the color control.  If
not specified, {opt default(255 0 0)} is assumed.

{phang}
{opt nomemory} specifies that the color control not remember the 
set color between invocations.

{phang}
{opt onchange(iaction)} specifies the i-action to be invoked when the color
is changed.  The default i-action is to do nothing.  Note
that the {opt onchange()} i-action will be invoked the first time the color
control is displayed.

{phang}
{opt option(optionname)} is a communication option that associates
{it:optionname} with the selected color.

{phang}
{opt tooltip}{cmd:("}{it:string}{cmd:")} specifies the text to be displayed
as a tip or hint when the user hovers over the control with the mouse.


{title:Example}

   {hi:COLOR} {cmd:box_color   10 10 40  ., default(0 0 0)}


{marker remarks3.6.15}{...}
{title:3.6.15 EXP expression input control}

{title:Syntax}

{p 8 14 2} 
EXP  {it:newcontrolname} {it:x} {it:y} {it:xsize} {it:ysize} 
     [{cmd:,} {opt l:abel}("{it:string}") {opt e:rror}("{it:string}")
     {opt default(defstrval)} {opt nomem:ory}
     {opt onchange(iaction)} {opt op:tion(optionname)}
     {cmd:tooltip("}{it:string}{cmd:")}]


{title:Member functions}

{p2colset 5 30 32 2}{...}
{p2col :{cmd:setlabel} {it:string}}sets the label for the button{p_end}
{p2col :{cmd:setvalue} {it:{help dialogs##specialdefs.:strvalue}}}sets the value shown in the edit field{p_end}
{p2col :{cmd:append} {it:string}}appends {it:string} to the value in the edit field{p_end}
{p2col :{cmd:prepend} {it:string}}prepends {it:string} to the value of the edit field{p_end}
{p2col :{cmd:insert} {it:string}}inserts {it:string} at the current cursor position of the edit field{p_end}
{p2col :{cmd:smartinsert} {it:string}}inserts {it:string} at the
        current cursor position in the edit field with leading and trailing
        spaces around it{p_end}
{p2col :{cmd:setoption} {it:optionname}}associates {it:optionname}
	with the contents of the edit field{p_end}
{p2col :{cmd:setdefault} {it:string}}sets the default value for the edit field;
	this does not change what is displayed{p_end}
{p2col :{cmd:settooltip} {it:string}}sets the tooltip text to {it:string}{p_end}
{p2colreset}{...}

{pstd}
The standard member functions {opt hide}, {opt show}, {opt disable},
{opt enable}, and {opt setposition} are also provided.


{title:Returned values for use in PROGRAM}

{pstd}
Returns {it:string}, the contents of the edit field.


{title:Description}

{pstd}
{hi:EXP} defines an expression control that consists of an edit field and 
a button for launching the Expression Builder.

{title:Options}

{phang}
{opt label}{cmd:("}{it:string}{cmd:")} specifies the text for labeling the button.

{phang}
{opt error}{cmd:("}{it:string}{cmd:")} specifies the text to be displayed
describing this field to the user in automatically generated error boxes.

{phang}
{opt default(defstrval)} specifies the default contents of the edit field.  If
not specified, {opt default("")} is assumed.

{phang}
{opt nomemory} specifies that the edit field not remember how it was
filled in between invocations.

{phang}
{opt onchange(iaction)} specifies the i-action to be invoked when the contents
of the edit field are changed.  The default i-action is to do nothing.  Note
that the {opt onchange()} i-action will be invoked the first time the expression
control is displayed.

{phang}
{opt option(optionname)} is a communication option that associates
{it:optionname} with the contents of the edit field.

{phang}
{opt tooltip}{cmd:("}{it:string}{cmd:")} specifies the text to be displayed
as a tip or hint when the user hovers over the control with the mouse.


{title:Example}

   {hi:TEXT} {cmd:tlab   10  10 200   ., label("Expression:")}
   {hi:EXP} {cmd:exp     @  +20   @   ., label("Expression")}


{marker remarks3.6.16}{...}
{title:3.6.16 HLINK hyperlink input control}

{title:Syntax}

{p 8 16 2}
{hi:HLINK} {it:newcontrolname} {it:x} {it:y} {it:xsize} {it:ysize}
   [{cmd:,} 
   {opt l:abel}{cmd:("}{it:string}{cmd:")} 
   [{cmd:left}|{cmd:center}|{cmd:right}]
   {opt onpush(iaction)}]


{title:Member functions}

{p2colset 5 28 32 2}{...}
{p2col :{opt setlabel} {it:string}}sets the text shown{p_end}
{p2colreset}{...}

{pstd}
The standard member functions {opt hide}, {opt show}, {opt disable}, 
{opt enable}, and {opt setposition} are also provided.


{title:Returned values for use in PROGRAM}

{pstd}
None.


{title:Description}

{pstd}
{hi:HLINK} creates a hyperlink that performs instantaneous
actions.  Hyperlinks do not indicate a state, such as on or off, and do 
not return anything for use by the u-action {hi:PROGRAM}.  Hyperlinks are used
to invoke i-actions.


{title:Options}

{phang}
{opt label}{cmd:("}{it:string}{cmd:")} specifies the text to be shown.

{phang}
{opt left}, {opt center}, and {opt right} are alternatives that specify the
horizontal alignment of the text with respect to {it:x}.  {opt left} is the
default.

{phang}
{opt onpush(iaction)} specifies the i-action to be invoked when the hyperlink
is clicked on.  If {opt onpush()} is not specified, the hyperlink does nothing.


{title:Example}

{psee}
{hi:HLINK} {cmd:help 10 10 80 ., label("Help") onpush("view help example")}


{marker remarks3.6.17}{...}
{title:3.6.17 TREEVIEW tree input control}

{title:Syntax}

{p 8 19 2}
{cmd:TREEVIEW} {it:newcontrolname} {it:x} {it:y} {it:xsize} {it:ysize}
[{cmd:,}
    {opt l:abel}{cmd:("}{it:string}{cmd:")} {opt e:rror}{cmd:("}{it:string}{cmd:")}
    {opt nomem:ory} {opt cont:ents(conspec)} {opt val:ues(listname)}
    {opt default(defstrval)}
    {opt ondblclick(iaction)}
    [{opt onselchange(iaction)}|{opt onselchangelist(listname)}]
    {opt op:tion(optionname)}
    {cmd:tooltip("}{it:string}{cmd:")}]


{title:Member functions}

{p2colset 8 30 32 2}{...}
{p2col :{opt setlabel} {it:string}}sets the label for the tree{p_end}
{p2col :{opt setvalue} {it:{help dialogs##specialdefs.:strvalue}}}sets the currently selected item{p_end}
{p2col :{cmd:setfocus}}causes the control to obtain keyboard focus{p_end}
{p2col :{cmd:setoption} {it:optionname}}associates {it:optionname}
	with the element chosen from the tree{p_end}
{p2col :{cmd:setdefault} {it:string}}sets the default value for the tree;
	this does not change what is displayed{p_end}
{p2col :{cmd:forceselchange}}forces an {cmd:onselchange} event to occur{p_end}
{p2col :{cmd:settooltip} {it:string}}sets the tooltip text to {it:string}{p_end}
{p2colreset}{...}

{pstd}
The standard member functions {opt hide}, {opt show}, {opt disable},
{opt enable}, and {opt setposition} are also provided.


{title:Returned values for use in PROGRAM}

{pstd}
Returns {it:string}, the text of the item chosen, or, if {opt values(listname)} is
specified, the text from the corresponding element of {it:listname}.


{title:Description}

{pstd}
{hi:TREEVIEW} defines a tree control, which is used to display a hierarchical 
view of labeled items.  A tree view allows the user to select from
several mutually exclusive but related choices.  By clicking on an item, 
the user can expand or collapse the associated list of subitems.


{title:Options}

{phang}
{opt label}{cmd:("}{it:string}{cmd:")} specifies a description for the
control but does not display the label next to the control.  If you want to
label a tree view, you must use a {hi:TEXT} static control.

{phang}
{opt error}{cmd:("}{it:string}{cmd:")} specifies the text to be displayed
describing this field to the user in automatically generated error boxes.

{phang}
{opt nomemory} specifies that the control not remember the item selected 
between invocations.

{phang}
{opt contents(conspec)} specifies the items to be shown in the control. 
If {opt contents()} is not specified, the tree view control will be empty.

{phang}
{opt values(listname)} specifies the list (see
{it:{help dialogs##remarks3.5:3.5 LIST}}) for which the
values of {opt contents()} should match one to one.  When the user chooses the
{it:k}th element from {opt contents()}, the {it:k}th element of {it:listname}
will be returned.  If the lists do not match one to one, extra elements of
{it:listname} are ignored, and extra elements of {opt contents()} return
themselves.

{phang}
{opt default(defstrval)} specifies the default selection.  If not specified, 
or if {it:defstrval} does not exist, the first item is the default.

{phang}
{opt ondblclick(iaction)} specifies the i-action to be invoked when an item in
the control is double clicked.  The double-clicked item is selected before the 
{it:iaction} is invoked.

{phang}
{opt onselchange(iaction)} and {opt onselchangelist(listname)} are
alternatives.  They specify the i-action to be invoked when a selection in the
control changes.

{pmore}
{opt onselchange(iaction)} performs the same i-action, regardless of which
element of the control was chosen.

{pmore}
{opt onselchangelist(listname)} specifies a vector of {it:iactions} that
should match one to one with {opt contents()}.  If the user selects the
{it:k}th element of {opt contents()}, the {it:k}th i-action from {it:listname}
is invoked.  See {it:{help dialogs##remarks3.5:3.5 LIST}} for information on
creating {it:listname}.  If the elements of {it:listname} do not match one to
one with the elements of {opt contents()}, extra elements are ignored, and if
there are too few elements, the last element will be invoked for the extra
elements of {opt contents()}.

{phang}
{opt option(optionname)} is a communication option that associates
{it:optionname} with the element chosen from the tree view control.

{phang}
{opt tooltip}{cmd:("}{it:string}{cmd:")} specifies the text to be displayed
as a tip or hint when the user hovers over the control with the mouse.


{title:Organize data}

{pstd}
{hi:TREEVIEW} represents a hierarchical view of information where each item
may have a number of subitems.  Items (nodes) in the tree view can be expanded
or collapsed to show or hide subitems.  For example,

     Root 1
        SubItem A
           SubItem A1
           SubItem A2
        SubItem B
     Root 2
        SubItem C

{pstd}
The parent-child relationship data are stored in a content list.
Each item in the list represents a node of the tree.  The string labeling each
item contains two parts. The first part encloses a nonnegative integer in
square brackets to denote the level or depth of each node. The second part
following the square brackets is the content shown in the tree. 


{title:Example}

    LIST ourcontentlist
        BEGIN
            [0]Root 1
            [1]SubItem A
            [2]SubItem A1
	    [2]SubItem A2
	    [1]SubItem B
	    [0]Root 2
	    [1]SubItem C
        END
    . . .
    DIALOG . . . 
        BEGIN
            . . . 
            TEXT     ourlab    10  10  200   ., label("Pick an item")
            TREEVIEW ourtree   @   +20 150 200, contents(ourcontentlist)
            . . .
        END


{marker remarks3.7}{...}
{title:3.7 OK, SUBMIT, CANCEL, and COPY u-action buttons}

{title:Syntax}

{p 8 23 2}
{{hi:OK}|{hi:SUBMIT}|{hi:COPY}} {it:newbuttonname}
[{cmd:,}
    {opt l:abel}{cmd:("}{it:string}{cmd:")}
    {opt uact:ion(programname)}
    {opt tar:get(target)}]


{p 8 23 2}
{hi:CANCEL} {it:newbuttonname} 
[{cmd:,} {opt l:abel}{cmd:("}{it:string}{cmd:")}]


{title:Description}

{pstd}
{hi:OK}, {hi:CANCEL}, {hi:SUBMIT}, and {hi:COPY} define buttons that, when
clicked on,
invoke a u-action.  At least one of the buttons should be defined (or the
dialog will have no associated u-action); only one of each button may be
defined; and usually, good style dictates defining all four.

{pstd}
{hi:OK} executes {it:programname}, removes the dialog box from the screen,
and submits the resulting command produced by {it:programname} to 
{it:target}.  If no other buttons are defined, clicking on the close icon of
the dialog box does the same thing.

{pstd}
{hi:SUBMIT} executes {it:programname}, leaves the dialog box on the screen,
and submits the resulting command produced by {it:programname} to 
{it:target}.

{pstd}
{hi:CANCEL} removes the dialog from the screen and does nothing.  If this
button is defined, clicking on the close icon of the dialog box does the same
thing.

{pstd}
{hi:COPY} executes {it:programname}, leaves the dialog box on the screen,
and copies the resulting command produced by {it:programname} to 
{it:target}.  By default, the {it:target} is the {it:clipboard}.

{pstd}
You do not specify the location or size of these controls.
They will be placed in the dialog box where the user would expect to see
them.


{title:Options}

{phang}
{opt label}{cmd:("}{it:string}{cmd:")} defines the text to appear on the
button.  The default {opt label()} is {hi:OK}, {hi:Submit}, and
{hi:Cancel} for each individual button.

{phang}
{opt uaction(programname)} specifies the {hi:PROGRAM} to be executed.
{opt uaction(command)} is the default.

{phang}
{opt target(target)} defines what is to be done with the resulting string
(command) produced by {it:programname}.  The alternatives are

{pmore}
{opt target(stata)}:  The command is to be executed by Stata.  This is the
default.

{pmore}
{opt target(stata hidden)}:  The command is to be executed by Stata, but the
command itself is not to appear in the Results window.  The output from the
command will appear normally.
{cmd:This option may change in the future and should be avoided when possible.} 

{pmore}
{opt target(cmdwin)}:  The command is to be placed in the Command window so
that the user can edit it and then press {hi:Enter} to submit it.

{pmore}
{opt target(clipboard)}:  The command is to be placed on the clipboard so
that the user can paste it into the desired editor.


{title:Example}

{psee}{hi:OK} {cmd:ok1}{p_end}
{psee}{hi:CANCEL} {cmd:can1}{p_end}
{psee}{hi:SUBMIT} {cmd:sub1}{p_end}
{psee}{hi:COPY} {cmd:copy1}{p_end}


{marker remarks3.8}{...}
{title:3.8 HELP and RESET helper buttons}

{title:Syntax}

{p 8 15 2}
{hi:HELP} {it:newbuttonname} 
   [{cmd:,} {opt view}{cmd:("}{it:viewertopic}{cmd:")}]

{p 8 15 2}
{hi:RESET} {it:newbuttonname}


{title:Description}

{pstd}
{hi:HELP} defines a button that, when clicked on, presents {it:viewertopic} in
the Viewer.  {it:viewertopic} is typically specified as 
{bind:{cmd:"view {it:helpfile}"}}.

{pstd}
{hi:RESET} defines a button that, when clicked on, resets the values of the
controls in the dialog box to their initial state, just as if the dialog box
were invoked for the first time.  Each time a user invokes a dialog box, its
controls will be filled in with the values the user last entered.  {hi:RESET}
restores the control values to their defaults.

{pstd}
You do not specify the location, size, or appearance of these
controls.  They will be placed in the lower-left corner of the dialog box.  The
{hi:HELP} button will have a question mark on it, and the {hi:RESET} button will
have an {hi:R} on it.


{title:Option}

{phang}
{opt view}{cmd:("}{it:viewertopic}{cmd:")} specifies the topic to appear in
the Viewer when the user clicks on the button.  The default is 
{bind:{cmd:view("help contents")}}.


{title:Example}

{psee}{hi:HELP} {cmd:hlp1, view("help mycommand")}{p_end}
{psee}{hi:RESET} {cmd:res1}{p_end}


{marker remarks3.9}{...}
{title:3.9 Special dialog directives}

{title:Syntax}

{p 8 15 2}
{{hi:MODAL}|{hi:SYNCHRONOUS_ONLY}}


{title:Description}

{pstd}
{hi:MODAL} instructs the dialog to have modal behavior.

{pstd}
{hi:SYNCHRONOUS_ONLY} allows the dialog to invoke {cmd:stata hidden immediate}
at special times during the initialization process.
See {hi:{help dialogs##remarks5.5.1:5.5.1 stata}} for more information
on this topic.


{marker remarks4}{...}
{title:4. SCRIPT}

{title:Syntax}

    {hi:SCRIPT} {it:newscriptname}
        {hi:BEGIN}
            {it:iaction}
            . . . 
        {hi:END}

{pstd}
where {it:iaction} is

{p 8 10 2}
{cmd:.}{p_end}

{p 8 10 2}
{cmd:action} {it:memberfunction}{p_end}

{p 8 10 2}
{cmd:gaction} {it:dialogname}{cmd:.}{it:controlname}{cmd:.}{it:memberfunction}{p_end}

{p 8 10 2}
{it:dialogname}{cmd:.}{it:controlname}{cmd:.}{it:memberfunction}{p_end}

{p 8 10 2}
{cmd:script} {it:scriptname}{p_end}

{p 8 10 2}
{cmd:view} {it:topic}{p_end}

{p 8 10 2}
{cmd:program} {it:programname}{p_end}

{pstd}
See {it:{help dialogs##remarks2.5:2.5 I-actions and member functions}} for more
information on {it:iactions}.


{title:Description}

{pstd}
{hi:SCRIPT} defines the {it:newscriptname}, which in turn defines a compound
i-action.  I-actions are invoked by the {cmd:on} {it:*}{cmd:()} options of the
input controls.  When a script is invoked, the lines are executed
sequentially, and any errors are ignored.


{title:Remarks}

{pstd}
{hi:CHECKBOX} provides {opt onclickon(iaction)} and {opt onclickoff(iaction)}
options.  Let's focus on the {opt onclickon(iaction)} option.  If you wanted to
take just one action when the box was checked -- say, disabling 
{opt d1.s2} -- you could code

{p 8 16 2}
{hi:CHECKBOX} {cmd:. . . , . . . onclickon(d1.s2.disable) . . .}

{pstd}
If you wanted to take two actions, say, disabling {opt d1.s3} as well, 
you would have to use a {hi:SCRIPT}.  On the {hi:CHECKBOX} command, you 
would code

{p 8 16 2}
{hi:CHECKBOX} {cmd:. . . , . . . onclickon(script buttonsoff) . . .}

{pstd}
and then somewhere else in the {cmd:.dlg} file (it does not matter where), 
you would code

    SCRIPT buttonsoff
        BEGIN
            d1.s2.disable
            d1.s3.disable
        END


{marker remarks5}{...}
{title:5. PROGRAM}

{title:Syntax}

	{hi:PROGRAM} {it:programname}
	    {cmd:BEGIN}
		[{it:program_line}|{cmd:INCLUDE}]
		[. . .]
	    {cmd:END}


{title:Description}

{pstd}
{hi:PROGRAM} defines a dialog program.  Dialog programs are used to
describe complicated i-actions and to implement u-actions.


{title:Remarks}

{pstd}
Dialog programs are used to describe complicated i-actions when flow control
(if/then) is necessary or when you wish to create heavyweight i-actions that 
are like u-actions because they invoke Stata commands; otherwise, you should
use a {hi:SCRIPT}.  Used this way, programs are invoked when the specified
{it:iaction} is {cmd:program} {it:programname} in an {opt on}{it:*}{cmd:()}
option of an input control command; for instance, you could code

{p 8 16 2}
{hi:CHECKBOX} {cmd:. . . , . . . onclickon(program complicated) . . .} 

{pstd}
or use a {hi:SCRIPT}:

{p 8 16 2}
{hi:CHECKBOX} {cmd:. . . , . . . onclickon(script multi) . . .}{p_end}
        . . .
        SCRIPT multi
            BEGIN
                 . . .
                 program complicated
                 . . .
            END

{pstd}
The primary use of dialog programs, however, is to implement u-actions.  The
program constructs and returns a {it:string}, which the dialog-box manager will
then interpret as a Stata command.  The program is invoked by the
{opt uaction()} options of {hi:OK} and {hi:SUBMIT}; for instance,

{p 8 12 2}
{hi:OK} {cmd:. . . , . . .  uaction(program command) . . .}

{pstd}
The u-action program is nearly always named {cmd:command} because, if the 
{opt uaction()} option is not specified, {cmd:command} is assumed.  The 
u-action program may, however, be named as you please.

{pstd}
Here is an example of a dialog program being used to implement an i-action
with if/then flow control:

        PROGRAM testprog
            BEGIN
                if sample.cb1 & sample.cb2 {
                    call sample.txt1.disable
                }
                if !(sample.cb1 & sample.cb2) {
                    call sample.txt1.enable
                 }
            END

{pstd}
Here is an example of a dialog program being used to implement the u-action:

        {cmd:PROGRAM command}
            {cmd:BEGIN}
                {cmd:put "mycmd "}
                {cmd:varlist main.vars}    // {cmd:varlist [main.vars] {it:would make optional}}
                {cmd:ifexp main.if}
                {cmd:inrange main.obs1 main.obs2}
                {cmd:beginoptions}
                    {cmd:option options.detail}
                    {cmd:optionarg options.title}
                {cmd:endoptions}
            {cmd:END}

{pstd}
Using programs to implement heavyweight i-actions is much like implementing
u-actions, except the program might not be a function of the input
controls, and you must explicitly code the {hi:stata} command to execute
what is constructed.  Here is an example of a dialog program being used to
implement a heavyweight i-action:

        {cmd:PROGRAM heavyweight}
            {cmd:BEGIN}
                {cmd:put "myeditcmd, resume"}
                {hi:stata}
            {cmd:END}


{marker remarks5.1}{...}
{title:5.1 Concepts}


{marker remarks5.1.1}{...}
{title:5.1.1 Vnames}


{pstd}
{it:Vname} stands for value name and refers to the "value" of a control.
Vnames are of the form {it:dialogname}{cmd:.}{it:controlname}; for example,
{cmd:d2.s2} and {cmd:d2.list} would be vnames if input controls {cmd:s2} and
{cmd:list} were defined in {hi:DIALOG} {cmd:d2}:  

        {cmd:DIALOG d2 . . .}
            {cmd:BEGIN} 
                {cmd:. . .}
                {cmd:CHECKBOX s2 . . .}
                {cmd:EDIT list . . .}
                {cmd:. . .}
            {cmd:END}

{pstd}
A vname can be numeric or string depending on the control to which it
corresponds.  For {hi:CHECKBOX}, it was documented under "Returned
value for use in {hi:PROGRAM}" that {hi:CHECKBOX} "returns numeric, 0 or 1,
depending on whether box is checked", so {cmd:d2.s2} is a numeric.  For the
{hi:EDIT} input control, it was documented that {hi:EDIT} returns a string
representing the contents of the edit field, so {cmd:d2.list} is a string.

{pstd}
Different words are sometimes used to describe whether {it:vname} is 
numeric or string, including 

        {it:vname} is numeric

        {it:vname} is string

        {it:vname} is a numeric control

        {it:vname} is a string control

        {it:vname} returns a numeric result

        {it:vname} returns a string result

{pstd}
In a program, you may not assign values to vnames; you may only examine their
values and, for u-action (and heavyweight i-action) programs,
output them.  Thus dialog programs are pretty relaxed about types.  You can
ask whether {cmd:d2.s2} is true or {cmd:d2.list} is true, even though
{cmd:d2.list} is a string.  For a string, it is true if it is not
{cmd:""}.  Numeric vnames are true if the numeric result is not 0.


{marker remarks5.1.2}{...}
{title:5.1.2 Enames}

{pstd}
Enames are an extension of vnames.  An {it:ename} is defined as 

        {it:vname}
        {cmd:or(}{it:vname} {it:vname} . . . {it:vname}{cmd:)}
        {cmd:radio(}{it:dialogname} {it:controlname} . . . {it:controlname}{cmd:)}

{pstd}
{opt or()} returns the {it:vname} of the first in the list that is true
(filled in). For instance, the {cmd:varlist} u-action dialog-programming
command "outputs" a varlist (see
{it:{help dialogs##remarks5.1.3:5.1.3 rstrings: cmdstring and optstring}}).
If you knew that the varlist was in either control {cmd:d1.field1} or
{cmd:d1.field2} and knew that both could not be filled in, you might code

        {cmd:varlist or(d1.field1 d1.field2)}

{pstd}
which would have the same effect as

        if d1.field1 { 
            varlist d1.field1
        }
        if (!d1.field1) & d2.field2 {
            varlist d2.field2
        }

{pstd}
{opt radio()} is for dealing with radio buttons.  Remember that each radio
button is a separate control, and yet, in the set, we know that exactly one is
clicked on.  {opt radio} finds the clicked one.  Typing 

        {cmd:option radio(d1 b1 b2 b3 b4)}

{pstd}
would be equivalent to typing 

        {cmd:option or(d1.b1 d1.b2 d1.b3 d1.b4)}

{pstd}
which would be equivalent to typing 

        {cmd:option d1.b2}

{pstd}
assuming that the second radio button is selected.  (The {opt option} command
outputs the option corresponding to a control.)


{marker remarks5.1.3}{...}
{title:5.1.3 rstrings: cmdstring and optstring}

{pstd}
Rstrings, {opt cmdstring} and {opt optstring}, are relevant only in u-action
and heavyweight i-action programs.

{pstd}
The purpose of a u-action program is to build and return a string, which Stata
will ultimately execute.  To do that, dialog programs have an {it:rstring}
to which the dialog-programming commands implicitly contribute.  For example,

        {cmd:put "kappa"}

{pstd}
would add "kappa" (without the quotes) to the end of the rstring currently
under construction, known as the current rstring.  Usually, the current
rstring is {opt cmdstring}, but within a {cmd:beginoptions}/{cmd:endoptions}
block, the current rstring is switched to {opt optstring}:

        beginoptions
            put "kappa"
        endoptions

{pstd}
The above would add "kappa" (without the quotes) to {opt optstring}.

{pstd}
When the program concludes, the {opt cmdstring} and the {opt optstring} are
put together -- separated by a comma -- and that is the command
Stata will execute.  In any case, any command that can be used outside
{cmd:beginoptions}/{cmd:endoptions} can be used inside them, and the only
difference is the rstring to which the output is directed.  Thus if our entire
u-action program read

        PROGRAM command
            BEGIN 
                put "kappa"
                beginoptions
                    put "kappa"
                endoptions
            END

{pstd}
the result would be to execute the command "{cmd:kappa,} {cmd:kappa}".

{pstd}
The difference between a u-action program and a heavyweight i-action program
is that you must, in your program, specify that the constructed command be
executed.  You do this with the {hi:stata} command.  The {hi:stata} command
can also be used in u-action programs if you wish to execute more than one
Stata command:

        PROGRAM command
             BEGIN
                put{it:, etc.}             // {it:construct first command}
                stata                 // {it:execute first command}
                clear                 // {it:clear{opt cmdstring} and{opt optstring}}
                put{it:, etc.}             // {it:construct second command}
                                      // {it:execution will be automatic}
             END


{marker remarks5.1.4}{...}
{title:5.1.4 Adding to an rstring}

{pstd}
When adding to an {it:rstring}, be aware of some rules in using spaces.
Call {it:A} the rstring and {it:B} the string being added (say "kappa").
The following rules apply:

{phang}
1.  If {it:A} does not end in a space and {it:B} does not begin with a space,
the two strings are joined to form "{it:AB}".  If {it:A} is "{cmd:this}" and
{it:B} is "{cmd:that}", the result is "{cmd:thisthat}".

{phang}
2.  If {it:A} ends in one or more spaces and {it:B} does not begin with a
space, the spaces at the end of {it:A} are removed, one space is added, and
{it:B} is joined to form {bind:"rightstrip({it:A}) B"}.  If A is
{bind:"{cmd:this} "} and {it:B} is "{cmd:that}", the result is 
{bind:"{cmd:this that}"}.

{phang}
3.  If {it:A} does not end in a space and {it:B} begins with one or more
spaces, the spaces at the beginning of {it:B} are ignored and treated as if
there is one space, and the two strings are joined to form 
{bind:"{it:A} leftstrip({it:B})"}.  If {it:A} is "{cmd:this}" and {it:B} is 
{bind:" {cmd:that}"}, the result is {bind:"{cmd:this that}"}.

{phang}
4.  If {it:A} ends in one or more spaces and {it:B} begins with one or more
spaces, the spaces at the end of {it:A} are removed, the spaces at the
beginning of {it:B} are ignored, and the two strings are joined with one space
in between to form {bind:"rightstrip({it:A}) leftstrip({it:B})"}.  If A is
{bind:"{cmd:this} "} and {it:B} is {bind:"{cmd: that}"}, the result is
{bind:"{cmd:this that}"}.

{pstd}
These rules ensure that multiple spaces do not end up in
the resulting string so that the string will look better and more like
what a user might have typed.

{pstd}
When string literals are put, they are nearly always put with a trailing
space

        {cmd:put "kappa "}

{pstd}
to ensure that they do not join up with whatever is put next .
If what is put next has a leading space, that space will be ignored.


{marker remarks5.2}{...}
{title:5.2 Flow-control commands}


{marker remarks5.2.1}{...}
{title:5.2.1 if}

{title:Syntax}

        if {it:ifexp} { 
           . . . 
        }
        
    or

        if {it:ifexp} { 
           . . . 
        }
        else {
           . . .
        }

{pstd}
where {it:ifexp} may be 

{p2colset 5 36 38 2}{...}
{p2col :{it:ifexp}}Meaning{p_end}
{p2line}
{p2col :({it:ifexp})}order of evaluation{p_end}
{p2col :!{it:ifexp}}logical not{p_end}
{p2col :{it:ifexp} | {it:ifexp}}logical or{p_end}
{p2col :{it:ifexp} & {it:ifexp}}logical and{p_end}
{p2col :{it:vname}}true if {it:vname} is not 0 and not {cmd:""}{p_end}
{p2col :{it:vname.booleanfunction}}true if {it:vname.booleanfunction}
	evaluates to true{p_end}
{p2col :{opt _rc}}see {it:{help dialogs##remarks5.5:5.5 Command-execution commands}}.{p_end}
{p2col :{opt _stbusy}}true if Stata is busy{p_end}
{p2col :{opt H(vname)}}true if {it:vname} is hidden or disabled{p_end}
{p2col :{opt default(vname)}}true if {it:vname} is its default value{p_end}
{p2line}
{p2colreset}{...}

{pmore}
Note the recursive definition:  An {it:ifexp} may be substituted into itself
to produce more complicated expressions, such as 
{bind:{cmd:((!d1.s1) & d1.s2) | d1.s3.isdefault()}}.

{pmore}
Also note that the order of evaluation is left to right; use parentheses.


{p2colset 5 36 38 2}{...}
{p2col :{it:booleanfunction}}Meaning{p_end}
{p2line}
{p2col :{opt isdefault()}}true if the value of {it:vname} is its default value{p_end}
{p2col :{opt isenabled()}}true if {it:vname} is enabled{p_end}
{p2col :{opt isnumlist()}}true if the value of {it:vname} is a {it:numlist}{p_end}
{p2col :{opt isvisible()}}true if {it:vname} is visible{p_end}
{p2col :{opt isvalidname()}}true if the value of {it:vname} is a valid Stata name{p_end}
{p2col :{opt isvarname()}}true if the value of {it:vname} is the name of a variable in the 
	current dataset{p_end}
{p2col :{opt iseq(argument)}}true if the value of {it:vname}
	is equal to {it:argument}{p_end}
{p2col :{opt isneq(argument)}}true if the value of {it:vname}
	is not equal to {it:argument}{p_end}
{p2col :{opt isgt(argument)}}true if the value of {it:vname} is greater than
	{it:argument}{p_end}
{p2col :{opt isge(argument)}}true if the value of {it:vname} is greater than
	or equal to {it:argument}{p_end}
{p2col :{opt islt(argument)}}true if the value of {it:vname} is less than
	{it:argument}{p_end}
{p2col :{opt isle(argument)}}true if the value of {it:vname} is less than
	or equal to {it:argument}{p_end}
{p2col :{opt isNumlistEQ(argument)}}true if every value of {it:vname} is 
	equal to {it:argument}, where {it:vname} may be a {help numlist}{p_end}
{p2col :{opt isNumlistLT(argument)}}true if every value of {it:vname} is 
	less than {it:argument}, where {it:vname} may be a {help numlist}{p_end}
{p2col :{opt isNumlistLE(argument)}}true if every value of {it:vname} is 
	less than or equal to {it:argument}, where {it:vname} may be a 
	{help numlist}{p_end}
{p2col :{opt isNumlistGT(argument)}}true if every value of {it:vname} is 
	greater than {it:argument}, where {it:vname} may be a 
	{help numlist}{p_end}
{p2col :{opt isNumlistGE(argument)}}true if every value of {it:vname} is 
	greater than or equal to {it:argument}, where {it:vname} may be a
	{help numlist}{p_end}
{p2col :{opt isNumlistInRange(arg1,arg2)}}true if every value of
	{it:vname} is in between {it:arg1} and {it:arg2}
	inclusive, where {it:vname} may be a {help numlist}{p_end}
{p2col :{opt startswith(argument)}}true if the value of {it:vname}
	starts with {it:argument}{p_end}
{p2col :{opt endswith(argument)}}true if the value of {it:vname}
	ends with {it:argument}{p_end}
{p2col :{opt contains(argument)}}true if the value of {it:vname}
	contains {it:argument}{p_end}
{p2col :{opt iseqignorecase(argument)}}true if the value of {it:vname}
	is equal to {it:argument} ignoring case{p_end}
{p2line}
{p2colreset}{...}

{pmore}
An {it:argument} can be a dialog control, a dialog property,
or a literal.  If the {it:argument} is a literal it can be either 
string or numeric, depending on the type of control the {it:booleanfunction}
references.  String controls require that literals be quoted, and numeric 
controls require that literals not be quoted.


{title:Description}

{pstd}
{hi:if} executes the code inside the braces if {it:ifexp} evaluates to 
true and skips it otherwise.  When an {hi:else} has been specified, the
code within its braces will be executed if {it:ifexp} evaluates to false.
{cmd:if} commands may be nested.


{title:Example}

    if d1.v1.isvisible() {
        put "thing=" d1.v1
    }
    else {
    	put "thing=" d1.v2
    }


{marker remarks5.2.2}{...}
{title:5.2.2 while}

{title:Syntax}

        while {it:condition} { 
           . . . 
        }

{pstd}
where {it:condition} may be 

{p2colset 5 36 38 2}{...}
{p2col :{it:condition}}Meaning{p_end}
{p2line}
{p2col :({it:condition})}order of evaluation{p_end}
{p2col :!{it:condition}}logical not{p_end}
{p2col :{it:condition} | {it:condition}}logical or{p_end}
{p2col :{it:condition} & {it:condition}}logical and{p_end}
{p2line}
{p2colreset}{...}


{title:Description}

{pstd}
A {cmd:while} loop is for circumstances where you want to do the same thing
repeatedly.  It is controlled by a counter.  For a {cmd:while} loop to
execute correctly, you must do the following:

{phang}
    1. Initialize a start value for the counter before the loop.
    
{phang}
    2. Specify a condition that tests the value of the counter against its
       expected final value such that the logical condition evaluates to false
       and the loop is forced to end at some point.

{phang}
    3. Specify a command that modifies the value of the counter inside the
    loop.


{title:Example}

    PROGRAM testprog
    	call create DOUBLE i
    	call create ARRAY testlist
    	while(i.islt(10)) {
    		call i.withvalue testlist.Arrpush @
    		call i.increment
    	}
    END


{marker remarks5.2.3}{...}
{title:5.2.3 call}

{title:Syntax}

{p 8 16 2}
{hi:call} {it:iaction} 

{pstd}
where {it:iaction} is

        {cmd:.}

        {cmd:action}  {it:memberfunction}
    
        {cmd:gaction} {it:dialogname}{cmd:.}{it:controlname}{cmd:.}{it:memberfunction}

        {it:dialogname}{cmd:.}{it:controlname}{cmd:.}{it:memberfunction}

        {cmd:script} {it:scriptname}

        {cmd:view} {it:topic}

        {cmd:program} {it:programname}

{pmore}
{it:iaction} "{cmd:action} {it:memberfunctionname}" is invalid 
in u-action programs because there is no concept of a current control.


{title:Description}

{pstd}
{hi:call} executes the specified {it:iaction}.  If an {it:iaction} is not 
specified, {cmd:gaction} is assumed.


{title:Example}

    PROGRAM testprog
        BEGIN
            if sample.cb1 & sample.cb2 {
                    call gaction sample.txt1.disable
            }
            if !(sample.cb1 & sample.cb2) {
                      call gaction sample.txt1.enable
            }
        END


{marker remarks5.2.4}{...}
{title:5.2.4 exit}

{title:Syntax}

{p 8 16 2}
{cmd:exit} [{it:#}]

{pstd}
where {it:#}>=0.  The following exit codes have special meaning:

{p2colset 5 21 22 2}{...}
{p2col :{space 2}{it:#}}Definition{p_end}
{p2line}
{p2col :{space 2}0}exit without error{p_end}
{p2col :{space 1}>0}exit with error{p_end}
{p2col :101}program exited because of a missing required object{p_end}
{p2line}
{p2colreset}{...}


{title:Description}

{pstd}
{hi:exit} causes the program to exit and, optionally, to return
{it:#}.

{pstd}
{cmd:exit} without an argument is equivalent to "{cmd:exit} {cmd:0}".
In u-action programs, the {cmd:cmdstring, optstring} will be sent to 
Stata for execution.

{pstd}
{cmd:exit} {it:#}, {it:#}>0, indicates an error.  In u-action programs, the
{cmd:cmdstring, optstring} will not be executed.  {cmd:exit 101} has special
meaning.  When a u-action program exits, Stata checks the exit code for
that program and, if it is {cmd:101}, presents an error box stating that
the user forgot to fill in a required element of the dialog box.


{title:Example}

        if !sample.var1 {
            exit 101
        }


{marker remarks5.2.5}{...}
{title:5.2.5 close}

{title:Syntax}

{p 8 16 2}
{cmd:close}


{title:Description}

{pstd}
{hi:close} causes the dialog box to close.


{marker remarks5.3}{...}
{title:5.3 Error-checking and presentation commands}


{marker remarks5.3.1}{...}
{title:5.3.1 require}

{title:Syntax}

{p 8 19 2}
require {it:ename} [{it:ename} [ . . . ]]

{pstd}
where each {it:ename} must be {it:string}.


{title:Description}

{pstd}
{hi:require} does nothing on each {it:ename} that is disabled or hidden.

{pstd}
For other {it:enames}, {cmd:require} requires that the controls specified 
not be empty ({cmd:""}) and produces a stop-box error message such as 
"dependent variable must be defined" for any that are empty.
The "dependent variable" part of the message will be obtained from the
control's {cmd:error()} option or, if that was not specified, from 
the control's {cmd:label()} option; if that was not specified, a generic
error message will be displayed.


{title:Example}

{psee}{cmd:require main.grpvar}{p_end}


{marker remarks5.3.2}{...}
{title:5.3.2 stopbox}

{title:Syntax}

{p 8 19 2} 
{cmd:stopbox} {{cmd:stop|note|rusure}}
["{it:line1}" ["{it:line2}" ["{it:line3}" ["{it:line4}" ]]]]


{title:Description}

{pstd}
{hi:stopbox} displays a message box containing up to four lines of text.
Three types are available:

{p 8 12 2} 
{hi:stop}:  Displays a message box in which there is only one button,
{hi:OK}, which means that the user must accept that he or she made an error
and correct it.  The program will exit after {hi:stopbox} {hi:stop}.

{p 8 12 2}
{hi:note}:  Displays a message box in which there is only one button,
{hi:OK}, which confirms that the user has read the message.  The program will
continue after {hi:stopbox} {hi:note}.

{p 8 12 2}
{hi:rusure}:  Displays a message box in which there are two buttons, {hi:Yes}
and {hi:No}.  The program will continue if the user clicks on {hi:Yes} or exit
if the user clicks on {hi:No}.

{pstd}
Also see {helpb window stopbox} for more information.
 

{title:Example}

{psee}{cmd:stopbox stop "Nothing has been selected"}{p_end}


{marker remarks5.4}{...}
{title:5.4 Command-construction commands}

{pstd}
The command-construction commands are 

        {cmd:by}
        {cmd:bysort}
        {cmd:put}
        {cmd:varlist}
        {cmd:ifexp}
        {cmd:inrange}
        {cmd:weight}
        {cmd:beginoptions}/{cmd:option}/{cmd:optionarg}/{cmd:endoptions}
        {cmd:allowxi}/{cmd:xi}
        {cmd:clear}

{pstd}
Most correspond to the part of Stata syntax for which they are named:

{p 8 14 2}
by {varlist}: {it:cmd} {it:varlist} {ifin} {weight}, {it:options}

{pstd}
{cmd:put} corresponds to {it:cmd} (although it is useful for other things as
well), and {cmd:allowxi}/{cmd:xi} corresponds to putting {cmd:xi:} in
front of the entire command; see {manhelp xi R}.

{pstd}
The command-construction commands (with the exception of {cmd:xi}) build 
{opt cmdstring} and {opt optstring} in the order the commands are executed
(see {it:{help dialogs##remarks5.1.3:5.1.3 rstrings: cmdstring and optstring}}),
so you should issue them in the same order they are used in Stata syntax.

{pstd}
Added to the syntax diagrams that follow is a new header:

{p 8 4 2}
Use of {opt option()} communication.

{pstd}
This refers to the {opt option()} option on the input control definition, 
such as {hi:CHECKBOX} and {hi:EDIT}; see
{it:{help dialogs##remarks2.6:2.6 U-actions and communication options}}.


{marker remarks5.4.1}{...}
{title:5.4.1 by}

{title:Syntax}

{p 8 14 2}
by {it:ename} 

{pstd}
where {it:ename} must contain a string and should refer to a
{hi:VARNAME}, {hi:VARLIST}, or {hi:EDIT} control.

{pstd}
Use of {opt option()} communication:  None.


{title:Description}

{pstd}
{opt by} adds nothing to the current rstring if {it:ename} is
hidden, disabled, or empty.  Otherwise, {it:by} outputs "{cmd:by}
{it:varlist}{cmd::}", followed by a blank, obtaining a varlist from {it:ename}.


{title:Example}

{psee}{cmd:by d2.by}{p_end}


{marker remarks5.4.2}{...}
{title:5.4.2 bysort}

{title:Syntax}

{p 8 19 2}
{hi:bysort} {it:ename} 

{pstd}
where {it:ename} must contain a string and should probably refer to a
{hi:VARNAME}, {hi:VARLIST}, or {hi:EDIT} control.

{pstd}
Use of {opt option()} communication:  None.


{title:Description}

{pstd}
{hi:bysort} adds nothing to the current rstring if {it:ename} is
hidden, disabled, or empty.  Otherwise, {it:bysort} outputs "{cmd:by}
{it:varlist}{cmd:, sort :}", followed by a blank, obtaining a varlist 
from {it:ename}.


{title:Example}

{psee}{cmd:bysort d2.by}{p_end}


{marker remarks5.4.3}{...}
{title:5.4.3 put}

{title:Syntax}

{p 8 14 2}
{hi:put} [{help format:{bf:%}{it:fmt}}] {it:putel} [[%{it:fmt}] {it:putel} [ . . . ]]

{pstd}
where {it:putel} may be

       {cmd:""}

       {cmd:"{it:string}"}

       {it:vname}

       {cmd:/hidden {it:vname}}

       {cmd:/on {it:vname}}

       {cmd:/program {it:programname}}

{pstd}
The word "output" means "add to the current result" in
what follows.  The {cmd:put} directives are defined as

{phang}
{cmd:""} and {cmd:"}{it:string}{cmd:"}{break}
Outputs the fixed text specified.

{phang}
{it:vname}{break}
Outputs the value of the control.

{phang}
{cmd:/hidden} {it:vname}{break}
Outputs the value of the control, even if it is hidden or disabled.

{phang}
{cmd:/on} {it:vname}{break}
Outputs nothing if {cmd: {it:vname}==0}.
{it:vname} must be numeric and should be the result of a {hi:CHECKBOX} or
{hi:RADIO} control.  {cmd:/on} outputs the text from the control's
{cmd:option()} option.  Also see
{it:{help dialogs##remarks5.4.8.1:5.4.8.1 option}}
for an alternative using the {cmd:option} command.

{phang}
{cmd:/program} {it:programname}{break}
Outputs the {cmd:cmdstring, optstring} returned by {it:programname}.

{pstd}
If any {it:vname} is disabled or hidden and not preceded by 
{cmd:/hidden}, {cmd:put} outputs nothing.

{pstd}
If the directive is preceded by {cmd:%}{it:fmt}, the specified
{cmd:%}{it:fmt} is always used to format the result.  Otherwise, string results
are displayed as is, and numeric results are displayed in
{cmd:%10.0g} format and stripped of resulting leading and trailing
blanks.  See {manhelp format D}.

{pstd}
Use of {cmd:option()} communication:  See {cmd:/on} above.


{title:Description}

{pstd}
{cmd:put} adds to the current rstring (outputs) what is specified.


{title:Remarks}

{pstd}
{cmd:put} {cmd:"}{it:string}{cmd:"} is often used to add the Stata command to
the current rstring.  When used in that way, the right way to code is

        {cmd:put "{it:commandname} "}

{pstd}
Note the trailing blank on {it:commandname}; see
{it:{help dialogs##remarks5.1.4:5.1.4 Adding to an rstring}}.

{pstd}
{cmd:put} displays nothing if any element specified is hidden or disabled.
For instance, 

       {cmd:put "thing=" d1.v1}

{pstd}
will output nothing (not even {cmd:"thing="}) if {cmd:d1.v1} is hidden or
disabled.  This saves you from having to code

       if !H(d1.v1) {
           put "thing=" d1.v1
       }


{marker remarks5.4.4}{...}
{title:5.4.4 varlist}

{title:Syntax}

{p 8 19 2}
{hi:varlist} {it:el} [ {it:el} [ . . . ]]

{pstd}
where an {it:el} is {it:ename} or {cmd:[}{it:ename}{cmd:]} (brackets
significant).

{phang}
Each {it:ename} must be string and should be the result from a
{hi:VARLIST}, {hi:VARNAME}, or {hi:EDIT} control.

{phang}
If {it:ename} is not enclosed in brackets, it must not be hidden or disabled.

{phang}
Use of {opt option()} communication:  None.


{title:Description}

{pstd}
{hi:varlist} considers it an error if any of the specified {it:enames}
that are not enclosed in brackets are hidden or disabled or empty (contain
{cmd:""}).

{pstd}
In these cases, {it:varlist} displays a stop-message box indicating that the
varlist must be filled in and exits the program.

{pstd}
{hi:varlist} adds nothing to the current rstring if any of the
specified {it:enames} that are enclosed in brackets are hidden or disabled.

{pstd}
Otherwise, {hi:varlist} outputs with leading and trailing blanks the contents
of each {it:ename} that is not hidden, is not disabled, and does not contain
{cmd:""}.


{title:Remarks}

{pstd}
{hi:varlist} is most often used to output the varlist of a Stata command, 
such as 

       {cmd:varlist main.depvar [main.indepvars]}

{pstd}
{hi:varlist} can also be used for other purposes.  You might code

       if d1.vl {
            put " exog("
            varlist d2.vl
            put ") "
       }

{pstd}
although coding 

        {cmd:optionarg d2.vl}

{pstd}
would be an easier way to achieve the same effect.


{marker remarks5.4.5}{...}
{title:5.4.5 ifexp}

{title:Syntax}

{p 8 17 2}
{hi:ifexp} {it:ename}

{pstd}
where {it:ename} must be a string control.

{pstd}
Use of {opt option()} communication:  None.


{title:Description}

{pstd}
{hi:ifexp} adds nothing to the current rstring if {it:ename} is
hidden, disabled, or empty.  Otherwise, output is "{cmd:if} {it:exp}",
with spaces added before and after.


{title:Example}

{psee}{cmd:if d2.if}{p_end}


{marker remarks5.4.6}{...}
{title:5.4.6 inrange}

{title:Syntax}

{p 8 17 2}
{hi:inrange} {it:ename_1} {it:ename_2}

{pstd}
where {it:ename_1} and {it:ename_2} must be numeric controls.

{pstd}
Use of {opt option()} communication:  None.


{title:Description}

{pstd}
If {it:ename_1} is hidden or disabled, results are as if {it:ename_1}
were not hidden and contained 1.  If {it:ename_2} is hidden or disabled,
results are as if {it:ename_1} were not hidden and contained {cmd:_N},
the number of observations in the dataset.

{pstd}
If {cmd: {it:ename_1}==1} and {cmd: {it:ename_2}==_N}, nothing is output
(added to the current rstring).

{pstd}
Otherwise, "{cmd:in} {it:range}" is output with spaces added before and
after, with the range obtained from {it:ename_1} and {it:ename_2}.


{title:Example}

{psee}{cmd:inrange d2.in1 d2.in2}{p_end}


{marker remarks5.4.7}{...}
{title:5.4.7 weight}

{title:Syntax}

{p 8 18 2}
{hi:weight} {it:ename_t} {it:ename_e}

{pstd}
where {it:ename_t} may be a string or numeric control and must have had 
{opt option()} filled in with a weight type (one of {opt weight}, 
{opt fweight}, {opt aweight}, {opt pweight}, or {opt iweight}), and
{it:ename_e} must be a string evaluating to the weight expression or variable
name.

{pstd}
Use of {opt option()} communication:  {it:ename_t} must have {opt option()} 
filled in the weight type.


{title:Description}

{pstd}
{hi:weight} adds nothing to the current rstring if {it:ename_t}
or {it:ename_e} are hidden, disabled, or empty.  Otherwise,
output is {cmd:[}{it:weighttype}{cmd:=}{it:exp}{cmd:]} with leading
and trailing blanks.


{title:Remarks}

{pstd}
{hi:weight} is typically used as

        {hi:weight radio}{cmd:(d1 w1 w2 . . . wk) d1.wexp}

{pstd}
where {hi:d1.w1}, {hi:d1.w2}, . . . , {hi:d1.wk} are radio buttons, which 
could be defined as

        DIALOG d1 . . . 
            BEGIN
            . . . 
                RADIO w1 . . . , . . . label(fweight) first . . . 
                RADIO w2 . . . , . . . label(aweight) . . .
                RADIO w3 . . . , . . . label(pweight) . . .
                RADIO w4 . . . , . . . label(iweight) last . . .
                . . .
            END

{pstd}
Not all weight types need to be offered.  If a command offers only one kind of
weight, you do not need to use radio buttons.  You could code

        {hi:weight} {cmd:d1.wt d1.wexp}

{pstd}
where {cmd:d1.wt} was defined as

        {hi:CHECKBOX} {cmd:wt . . . , . . . label(fweight) . . .} 


{marker remarks5.4.8}{...}
{title:5.4.8 beginoptions and endoptions}

{title:Syntax}

       {hi:beginoptions}
           {it:any dialog-programming command except} {hi:beginoptions}
           {cmd:. . .}
       {hi:endoptions}

{pstd}
Use of {opt option()} communication:  None.


{title:Description}

{pstd}
{hi:beginoptions}/{hi:endoptions} indicates that you wish what is enclosed to
be treated as Stata options in constructing {opt cmdstring, optstring}.

{pstd}
The current rstring is, by default, {opt cmdstring}.  {hi:beginoptions}
changes the current rstring to {opt optstring}.  {hi:endoptions} changes it
back to {opt cmdstring}.  So there are two strings being
built.  When the dialog program exits normally, if there is anything in 
{opt optstring}, trailing spaces are removed from {opt cmdstring}, a comma and
a space are added, the contents of {opt optstring} are added, and all that is
returned.  Thus a dialog program can have many
{hi:beginoptions}/{hi:endoptions} blocks, but all the options will
appear at the end of the {opt cmdstring}.

{pstd}
The command-construction commands {opt option} and {opt optionarg} are
documented below because they usually appear inside a 
{hi:beginoptions}/{hi:endoptions} block, but they can be used outside
{hi:beginoptions}/{hi:endoptions} blocks, too.  Also all the other
command-construction commands can be used inside a
{hi:beginoptions}/{hi:endoptions} block, and using {opt put} is
particularly common.


{marker remarks5.4.8.1}{...}
{title:5.4.8.1 option}

{title:Syntax}

{p 8 18 2}
{hi:option} {it:ename} [{it:ename} [ . . . ]]

{pstd}
where {it:ename} must be a numeric control with 0 indicating that the option
is not desired.

{pstd}
Use of {opt option()} communication:  {opt option()} specifies the name of 
the option.


{title:Description}

{pstd}
{hi:option} adds nothing to the current rstring if any of the 
{it:enames} specified are hidden or disabled.  Otherwise, for each 
{it:ename} specified, if {it:ename} is not equal to 0, the contents of 
its {opt option()} are displayed.


{title:Remarks}

{pstd}
{hi:option} is an easy way to output switch options such as {hi:noconstant}
and {hi:detail}.  You simply code 

       {cmd:option d1.sw}

{pstd}
where you have previously defined 

       {hi:CHECKBOX} {cmd:sw . . . , option(detail) . . .} 

{pstd}
Here {cmd:detail} will be output if the user checked the box.


{marker remarks5.4.8.2}{...}
{title:5.4.8.2 optionarg}

{title:Syntax}

{p 8 21 2}
{hi:optionarg} [{it:style}] {it:ename} 
   [ [{it:style}] {it:ename} [. . .] ]

{pstd}
where each {it:ename} may be a numeric or string control and {it:style} is

{p2colset 5 20 22 2}{...}
{p2col :{it:style}}Meaning{p_end}
{p2line}
{p2col :{opt /asis}}do not quote{p_end}
{p2col :{opt /quoted}}do quote{p_end}
{p2col :{opt /oquoted}}quote if necessary{p_end}
{p2col :{help format:{bf:%}{it:fmt}}}for use with numeric{p_end}
{p2line}
{p2colreset}{...}

{pstd}
Use of {opt option()} communication:  {opt option()} specifies the name of 
the option.


{title:Description}

{pstd}
{hi:optionarg} adds nothing to the current rstring if any of the
{it:enames} specified are hidden or disabled.  Otherwise, for each {it:ename}
specified, if {it:ename} is not equal to {cmd:""}, the {it:ename}'s 
{opt option()} is output, followed by "{cmd:(}",  the {it:ename}'s
contents, and "{cmd:)}" with blanks added before and after.


{title:Remarks}

{pstd}
{hi:optionarg} is an easy way to output single-argument options such as
{opt title()} or {opt level()}; for example,

       optionarg /oquoted d1.ttl

       if ! d1.level.isdefault() {
           optionarg d1.level
       }

{pstd}
where you have previously defined 

       {hi:EDIT}    {cmd:ttl   . . . , . . . label(title) . . .}
       {hi:SPINNER} {cmd:level . . . , . . . label(level) . . .}


{marker remarks5.5}{...}
{title:5.5 Command-execution commands}

{pstd}
Commands are executed automatically when a program is invoked by an input control's
{opt uaction()} option.  Programs so invoked are called u-action programs.
No command is executed when a program is invoked by an input control's 
{opt iaction()} option.  Programs so invoked are called i-action programs.

{pstd}
The {cmd:stata} and {cmd:clear} commands are for use if 

{phang}
1.  you want to write a u-action program that executes more than 
    one Stata command, or

{phang}
2.  you want to write an i-action program that executes one or more 
    Stata commands (also known as heavyweight i-action programs).


{marker remarks5.5.1}{...}
{title:5.5.1 stata}

{title:Syntax}

{p 8 17 2}
{hi:stata}

{p 8 17 2}
{hi:stata hidden} [{cmd:immediate}|{cmd:queue}]

{pstd}
Use of {opt option()} communication:  None.


{title:Description}

{pstd}
{hi:stata} executes the current {opt cmdstring, optstring} and 
displays the command in the Results window before execution, just
as if the user had typed it.

{pstd}
{hi:stata hidden} executes the current {opt cmdstring, optstring} but
does not display the command in the Results window before execution.
{hi:stata hidden} may optionally be called with either of two modifiers:
{hi:queue} or {hi:immediate}.  If neither modifier is specified, 
{hi:immediate} is implied.

{pstd}
{hi:immediate} causes the command to execute at once, waits for 
the command to finish, and sets {cmd:_rc} to contain the return 
code.  Because the command is to be executed immediately, the dialog
engine will complain if Stata is not idle.

{pstd}
{hi:queue} causes the command to be placed into the command buffer,
allowing it to be executed as soon as Stata becomes idle.
The behavior of {hi:stata} and {hi:stata hidden queue} are identical
except that {hi:stata hidden queue} does not echo the command. 


{title:Important notes about stata hidden immediate}

{pstd}
A unique situation can occur when {cmd:stata hidden immediate} is used
in an {help dialogs##remarks5.6:initialization script or program}.
Stata dialogs are considered asynchronous, meaning that Stata 
dialogs can be loaded through the menu and help systems even when 
Stata is busy processing an ado program.  Because {cmd:stata hidden immediate}
relies on ado processing and because ado processing is synchronous,
dialogs that call {cmd:stata hidden immediate} during initialization can only
be used synchronously.  That means these types of dialogs cannot
be loaded while Stata is busy processing other tasks. Because of this, the 
dialog must be notified that it is special in this regard.  This is done
by placing the dialog directive {cmd:SYNCHRONOUS_ONLY} in the 
dialog box program just after the {cmd: VERSION} statement.

{pstd}
{cmd:SYNCHRONOUS_ONLY} performs one other important function.  Dialogs 
that are launched by using the {cmd:db} command cause Stata to become  
busy and remain busy until the dialog is completely loaded.  After all, 
{cmd:db} is an ado program, and until the dialog
loads and {cmd:db} subsequently exits execution, Stata is busy.  The
{cmd:SYNCHRONOUS_ONLY} directive lets the dialog engine know 
that executing {cmd:stata hidden immediate} during initialization routines
is allowed even when the dialog is launched with an ado program.


{marker remarks5.5.2}{...}
{title:5.5.2 clear}

{title:Syntax}

{p 8 17 2}
{hi:clear} [{cmd:curstring}|{cmd:cmdstring}|{cmd:optstring}]

{pstd}
Use of {opt option()} communication:  None.


{title:Description}

{pstd}
{hi:clear} is seldom used and is typically specified without
arguments.  {hi:clear} clears (resets to {cmd:""}) the specified return
string or, if it is specified without arguments, clears {opt cmdstring} and 
{opt optstring}.  If {opt curstring} is specified, {hi:clear} clears the
current return string, which is {opt cmdstring} by default or {opt optstring}
within a {cmd:beginoptions}/{cmd:endoptions} block.


{marker remarks5.6}{...}
{title:5.6 Special scripts and programs}

{pstd}
Sometimes, it may be useful to have a script or program run automatically,
either just before dialog-box controls are created or just after.  The 
following scripts and programs are special, and when they are defined, they 
run automatically.

{p2colset 5 30 32 2}{...}
{p2col :Name}Function{p_end}
{p2line}
{p2col :{opt PREINIT_SCRIPT}}script that runs before any dialog box controls are created{p_end}
{p2col :{opt PREINIT_PROGRAM}}program that runs before any dialog box controls are created{p_end}

{p2col :{opt POSTINIT_SCRIPT}}script that runs after all dialog box controls are created{p_end}
{p2col :{opt POSTINIT_PROGRAM}}program that runs after all dialog box controls are created{p_end}

{p2col :{opt PREINIT}}shortcut for {opt PREINIT_SCRIPT}{p_end}
{p2col :{opt POSTINIT}}shortcut for {opt POSTINIT_SCRIPT}{p_end}

{p2col :{opt ON_DOTPROMPT}}program that runs when Stata returns from executing an
	interactive command; ON_DOTPROMPT program should never call the
	dialog system's {cmd:{help dialogs##remarks5.5.1:stata}} command,
        because that would result in infinite recursion{p_end}
{p2line}
{p2colreset}{...}

{pstd}
Often it is desirable to encapsulate individual dialog tabs into 
{it:.idlg} files, particularly when a dialog tab is used
in many different dialog boxes.  In those circumstances, a dialog tab 
can use its own initialization script or program.  The following naming
conventions are used to define these scripts and programs.

{p2colset 5 30 32 2}{...}
{p2col :Name}Function{p_end}
{p2line}
{p2col :{it:tabname_}{opt PREINIT_SCRIPT}}script that runs before controls on dialog {it:tabname} are created{p_end}
{p2col :{it:tabname}_{opt PREINIT_PROGRAM}}program that runs before controls on dialog {it:tabname} are created{p_end}

{p2col :{it:tabname}_{opt POSTINIT_SCRIPT}}script that runs after controls on dialog {it:tabname} are created{p_end}
{p2col :{it:tabname}_{opt POSTINIT_PROGRAM}}program that runs after controls on dialog {it:tabname} are created{p_end}

{p2col :{it:tabname}_{opt PREINIT}}shortcut for {it:tabname}_{opt PREINIT_SCRIPT}{p_end}
{p2col :{it:tabname}_{opt POSTINIT}}shortcut for {it:tabname}_{opt POSTINIT_SCRIPT}{p_end}
{p2line}
{p2colreset}{...}

{pstd}
The order of execution for dialog initialization is as follows:

{p2colset 5 9 11 2}{...}
{p2col :1.}Execute {opt PREINIT} script or program for the dialog box.{p_end}
{p2col :2.}Execute {opt PREINIT} scripts and programs for each dialog tab using
	the order in which the tabs are created.{p_end}
{p2col :3.}Create all controls for the entire dialog box.{p_end}
{p2col :4.}Execute {opt POSTINIT} scripts and programs for each dialog tab using
	the order in which the tabs are created.{p_end}
{p2col :5.}Execute {opt POSTINIT} script or program for the dialog box.{p_end}


{marker remarks6.}{...}
{title:6. Properties}

{pstd}
Properties are used to store information that is useful for dialog box
programming. Properties may be of type {opt STRING}, {opt DOUBLE}, or
{opt BOOLEAN} and do not have a visual representation on the dialog box.
Special variants of these basic types are available.  These variants,
{opt PSTRING}, {opt PDOUBLE}, and {opt PBOOLEAN}, are considered
persistent and are identical to their counterparts.
The contents of these persistent types do not get destroyed when a 
dialog is reset.  Usually, the base types should be used. Application
of the persistent types should be reserved for special circumstances.
See {helpb dialogs##remarks2.5.7:create} for information about creating
new instances of a property.


{title:Member functions}

{p2colset 5 28 32 2}{...}
{p2col :{opt STRING}}{it:propertyname}{opt .setvalue} {it:{help dialogs##specialdefs.:strvalue}}{p_end}
{p2col :}{it:propertyname}{opt .setstring} {it:{help dialogs##specialdefs.:strvalue}}; 
	synonym for {opt .setvalue}{p_end}
{p2col :}{it:propertyname}{opt .append} {it:{help dialogs##specialdefs.:strvalue}}{p_end}
{p2col :}{it:propertyname}{opt .tokenize} {it:classArrayName}{p_end}
{p2col :}{it:propertyname}{opt .tokenizeOnStr} {it:classArrayName} {it:{help dialogs##specialdefs.:strvalue}} {p_end}
{p2col :}{it:propertyname}{opt .tokenizeOnChars} {it:classArrayName} {it:{help dialogs##specialdefs.:strvalue}} {p_end}
{p2col :}{it:propertyname}{opt .expandNumlist}{p_end}
{p2col :}{it:propertyname}{opt .storeDialogClassName}{p_end}
{p2col :}{it:propertyname}{opt .storeClsArrayToQuotedStr} {it:classArrayName}{p_end}

{p2col :{opt DOUBLE}}{it:propertyname}{opt .setvalue} {it:{help dialogs##specialdefs.:value}}{p_end}
{p2col :}{it:propertyname}{opt .increment}{p_end}
{p2col :}{it:propertyname}{opt .decrement}{p_end}
{p2col :}{it:propertyname}{opt .add} {it:{help dialogs##specialdefs.:value}}{p_end}
{p2col :}{it:propertyname}{opt .subtract} {it:{help dialogs##specialdefs.:value}}{p_end}
{p2col :}{it:propertyname}{opt .multiply} {it:{help dialogs##specialdefs.:value}}{p_end}
{p2col :}{it:propertyname}{opt .divide} {it:{help dialogs##specialdefs.:value}}{p_end}
{p2col :}{it:propertyname}{opt .storeClsArraySize} {it:classArrayName}{p_end}

{p2col :{opt BOOLEAN}}{it:propertyname}{opt .settrue}{p_end}
{p2col :}{it:propertyname}{opt .setfalse}{p_end}
{p2col :}{it:propertyname}{opt .storeClsObjectExists} {it:objectName}{p_end}
{p2colreset}{...}


{marker specialdefs.}{...}
{title:Special definitions}

{p2colset 8 32 34 2}{...}
{p2col :{it:strvalue}}Definition{p_end}
{p2line}
{p2col :{cmd:"}{it:string}{cmd:"}}quoted string literal{p_end}
{p2col :{cmd:literal} {it:string}}same as {it:string}{p_end}
{p2col :{opt c(name)}}contents of {opt c(name)}; see {manhelp creturn P}{p_end}
{p2col :{opt r(name)}}contents of {opt r(name)}; see {manhelp return P}{p_end}
{p2col :{opt e(name)}}contents of {opt e(name)}; see {manhelp ereturn P}{p_end}
{p2col :{opt s(name)}}contents of {opt s(name)}; see {manhelp return P}{p_end}
{p2col :{cmd:char} {it:varname}[{it:charname}]}value of characteristic; see
     {manhelp char P}{p_end}
{p2col :{cmd:global} {it:name}}contents of global macro {cmd:$}{it:name}{p_end}
{p2col :{cmd:class} {it:objectName}}contents of a class system object;
object name may be a fully qualified object name, or it may be given
in the scope of the dialog box{p_end}
{p2line}
{p2colreset}{...}

{p2colset 8 32 34 2}{...}
{p2col :{it:value}}Definition{p_end}
{p2line}
{p2col :{it:#}}a numeric literal{p_end}
{p2col :{opt literal} {it:#}}same as {it:#}{p_end}
{p2col :{opt c(name)}}value of {opt c(name)}; see {manhelp creturn P}{p_end}
{p2col :{opt r(name)}}value of {opt r(name)}; see {manhelp return P}{p_end}
{p2col :{opt e(name)}}value of {opt e(name)}; see {manhelp ereturn P}{p_end}
{p2col :{opt s(name)}}value of {opt s(name)}; see {manhelp return P}{p_end}
{p2col :{cmd:global} {it:name}}value of global macro {cmd:$}{it:name}{p_end}
{p2col :{cmd:class} {it:objectName}}contents of a class system object.
The object name may be a fully qualified object name or it may be given
in the scope of the dialog box.{p_end}
{p2line}
{p2colreset}{...}


{marker remarks7.}{...}
{title:7. Child dialogs}

{title:Syntax}

{p 8 15 2}
{cmd:create CHILD} {it:dialogname} [{cmd:AS} {it:referenceName}]
[{cmd:,} {opt nomodal} {opt allowsubmit} {opt allowcopy}
{opt message(string)}]


{title:Member functions}

{p2colset 5 29 32 2}{...}
{p2col :{cmd:settitle} {it:string}}sets the title text of the child 
	dialog box{p_end}
{p2col :{cmd:setExitString} {it:string}}informs the child where to save the 
	command string when the {cmd:OK} or {cmd:Submit} button is clicked on 
	{p_end}
{p2col :{cmd:setOkAction} {it:string}}informs the child that it is to
	invoke a specific action in the parent when the {cmd:OK} button 
	is clicked on and the child exits{p_end}
{p2col :{cmd:setSubmitAction} {it:string}}informs the child that it is to
	invoke a specific action in the parent when the {cmd:Submit} 
	button is clicked on{p_end}
{p2col :{cmd:setExitAction} {it:string}}informs the child that it is to
	invoke a specific action in the parent when the {cmd:OK} or 
	{cmd:Submit} button is clicked on; note that {cmd:setExitAction} 
	has the same effect as calling both {cmd:setOkAction} and 
	{cmd:setSubmitAction} with the same argument{p_end}
{p2col :{cmd:create} {it:property}}allows the parent to create properties 
	in the child; see {it:{help dialogs##remarks6.:6. Properties}}{p_end}
{p2col :{cmd:callthru} {it:gaction}}allows the parent to call global actions
	in the context of the child
{p_end}
{p2colreset}{...}


{title:Description}

{pstd}
Child dialogs are dialogs that are spawned by another dialog.  These dialogs
form a relationship where the initial dialog is referred to as the parent and
all dialogs spawned from that parent are referred to as its children.
In most circumstances, the children collect information and return that
information to the parent for later use.  Unless {cmd:AS} {it:referencename}
has been specified, children are referenced through the {it:dialogname}.


{title:Options}

{phang}
{opt nomodal} suppresses the default modal behavior of a child dialog unless 
	the {cmd:MODAL} directive was specifically used inside the child
	dialog resource file.

{phang}
{opt allowsubmit} allows for the use of the {cmd:Submit} button on the dialog
	box.  By default, the {cmd:Submit} button is removed if it has
	been declared in the child dialog resource file.

{phang}
{opt allowcopy} allows for the use of the {cmd:Copy} button on the dialog
	box.  By default, the {cmd:Copy} button is removed if it has
	been declared in the child dialog resource file.

{phang}
{opt message(string)} specifies that {it:string} be passed to the child dialog 
	box, where it can be referenced from {opt STRING} property named
	{opt __MESSAGE}.


{marker remarks7.1}{...}
{title:7.1 Referencing the parent}

{pstd}
While it is normally not necessary, it is sometimes useful for a child
dialog box to give special instructions or information to its parent.
All child dialog boxes contain a special object named {cmd:PARENT}, 
which can be used with a member program named {cmd:callthru}.
{cmd:PARENT.callthru} can be used to call any intermediate action in 
the context of the parent dialog box.


{marker remarks8.}{...}
{title:8. Example}

{pstd}
The following example will execute the {cmd:summarize} command.  In addition
to the copy below, a copy can be found among the Stata distribution materials.
You can type

        {cmd:. which sumexample.dlg}

{pstd}
to find out where it is.


        {hline 20} sumexample.dlg {hline}
        // sumexample 
        // version 1.0.0

        VERSION {ccl stata_version}

        POSITION . . 320 200

        DIALOG main, title("Example simple summarize dialog") tabtitle("Main")
        BEGIN
          TEXT     lab      10   10  300    ., label("Variables to summarize:")
          VARLIST  vars      @  +20    @    ., label("Variables to sum")
        END

        DIALOG options, tabtitle("Options")
        BEGIN
          CHECKBOX detail   10   10  300    .,				///
	  	label("Show detailed statistics")			///
                option("detail")					///
                onclickoff(`"options.status.setlabel "(detail is off)""') ///
                onclickon(`"gaction options.status.setlabel "(detail is on)""')
        
          TEXT     status    @  +20    @    .,				///
	  	label("This label won't be seen")

          BUTTON   btnhide   @  +30  200    .,				///
	  	label("Hide other controls") push("script hidethem")
          BUTTON   btnshow   @  +30    @    .,				///
	  	label("Show other controls") push("script showthem")
          BUTTON   btngrey   @  +30    @    .,				///
	  	label("Disable other controls") push("script disablethem")
          BUTTON   btnnorm   @  +30    @    .,				///
	  	label("Enable other controls") push("script enablethem")

        END

        SCRIPT hidethem
        BEGIN
          gaction main.lab.hide
          main.vars.hide
          options.detail.hide
          options.status.hide
        END

        SCRIPT showthem
        BEGIN
          main.lab.show
          main.vars.show
          options.detail.show
          options.status.show
        END


        SCRIPT disablethem
        BEGIN
          main.lab.disable
          main.vars.disable
          options.detail.disable
          options.status.disable
        END

        SCRIPT enablethem
        BEGIN
          main.lab.enable
          main.vars.enable
          options.detail.enable
          options.status.enable
        END


        OK      ok1, label("Ok")
        CANCEL  can1
        SUBMIT  sub1
        HELP    hlp1, view("help summarize")
        RESET   res1

        PROGRAM command
        BEGIN
          put "summarize"
          varlist main.vars   /* varlist [main.vars] to make it optional */
          beginoptions
            option options.detail
          endoptions
        END
        {hline 20} sumexample.dlg {hline}


{marker AppendixA}{...}
{title:Appendix A:  Jargon}

{phang}
{bf:action:}   
See {help dialogs##iaction:{it:i-action}}
and 
{help dialogs##uaction:{it:u-action}}.

{phang}
{bf:browser:}  
See {help dialogs##file_chooser:{it:file chooser}}.

{phang}
{bf:button:}  
A type of input control; a button causes an i-action to occur
when it is clicked on.  Also see
{help dialogs##u-action_buttons:{it:u-action buttons}},
{help dialogs##helper_buttons:{it:helper buttons}}, and
{help dialogs##radio_buttons:{it:radio buttons}}.

{phang}
{bf:checkbox:}  
A type of numeric input control; the user may either check or
uncheck what is presented; suitable for obtaining yes/no responses.  A
checkbox has value 0 or 1, depending on whether the item is checked.

{phang}
{bf:combo box:}  
A type of string input control that has an edit field at the
top and a list box underneath.  Combo boxes come in three flavors:

{pmore}
A regular combo box has an edit field and a list below it.  The user may
choose from the list or type into the edit field.

{pmore}
A drop-down combo box also has an edit field and a list, but only the edit
field shows.  The user can click to expose the list.  The user may choose from
the list or type in the edit field.

{pmore}
A drop-down-list combo box is more like a list box.  An edit field is
displayed.  The list is hidden, and the user can click to expose the list, 
but the user can only choose elements from the list; he or she cannot type 
in the edit field.

{marker control}{...}
{phang}
{bf:control:}  
See {help dialogs##input_control:{it:input control}}
and {help dialogs##static_control:{it:static control}}.

{phang}
{bf:control status:}  
Whether a control (input or static) is disabled or enabled, hidden or shown.

{phang}
{bf:dialog(s):}  
The main components of a dialog box in that the dialogs contain all the
controls except for the u-action buttons.

{phang}
{bf:dialog box:}  
Something that pops up onto the screen that the user fills in; when the
user clicks on an action button, the dialog box causes something to happen
(namely, Stata to execute a command).

{pmore}
A dialog box is made up of one or more dialogs, u-action buttons, and a title
bar.

{pmore}
If the dialog box contains more than one dialog, only one of the dialogs shows
at a time, which one being determined by the tab selected.

{phang}
{bf:dialog program:}  
See {help dialogs##PROGRAM:{it:PROGRAM}}.

{marker disabled_and_enabled}{...}
{phang}
{bf:disabled and enabled:}  
A control that is disabled is visually grayed out; otherwise, it is enabled.
The user cannot modify disabled input controls.  Also see
{help dialogs##hidden_and_exposed:{it:hidden and exposed}}.

{phang}
{bf:.dlg file:}  
The file containing the code defining a dialog box and its actions.
If the file is named {it:xyz}{cmd:.dlg}, the dialog box is said to be named
{it:xyz}.

{phang}
{bf:dlg-program:}  
The entire contents of a {cmd:.dlg} file; the code defining a dialog box and
its actions.

{phang}
{bf:edit field:}  
A type of string input control; a box in which the user may type text.

{phang}
{bf:enabled and disabled:}  
See {help dialogs##disabled_and_enabled:{it:disabled and enabled}}.

{phang}
{bf:exposed and hidden:}  
See {help dialogs##hidden_and_exposed:{it:hidden and exposed}}.

{phang}
{bf:file browser:}  
See {help dialogs##file_chooser:{it:file chooser}}.

{marker file_chooser}{...}
{phang}
{bf:file chooser:}  
A type of string input control; presents a list of files from which the user
may choose one or type a filename.

{phang}
{bf:frame:}  
A type of static control; a rectangle drawn around a group of controls.

{phang}
{bf:group box:}  
A type of static control; a rectangle drawn around a group of controls with
descriptive text at the top.

{marker helper_buttons}{...}
{phang}
{bf:helper buttons:}  
The buttons {hi:Help} and {hi:Reset}.  When {hi:Help} is clicked on, the help
topic for the dialog box is displayed.  When {hi:Reset} is clicked on, the
control values of the dialog box are reset to their defaults.

{marker hidden_and_exposed}{...}
{phang}
{bf:hidden and exposed:}  
A control that is removed from the screen is said to be hidden; otherwise, it
is exposed.  Hidden input controls cannot be manipulated by the user.  A
control would also not be shown when it is contained in a dialog that does not
have its tab selected in a multidialog dialog box; in this case, it may be
invisible, but whether it is hidden or exposed is another matter.  Also see
{help dialogs##disabled_and_enabled:{it:disabled and enabled}}.

{marker iaction}{...}
{phang}
{bf:i-action:}  
An intermediate action usually caused by the interaction of a user with an
input control, such as hiding or showing and disabling or enabling other
controls; opening the Viewer to display something; or executing a {hi:SCRIPT}
or a {hi:PROGRAM}.

{marker input_control}{...}
{phang}
{bf:input control:}  
A screen element that the user fills in or sets.  Controls include checkboxes,
buttons, radio buttons, edit fields, spinners, file choosers, etc.  Input
controls have (set) values, which can be string, numeric, or special.  These
values reflect how the user has "filled in" the control.  Input controls are
said to be string or numeric depending on the type of result they obtain (and
how they store it).

{pmore}
Also see {help dialogs##static_control:{it:static control}}.

{phang}
{bf:label or title:}  
See {help dialogs##title_or_label:{it:title or label}}.

{phang}
{bf:list:}  
A programming concept; a vector of elements.

{phang}
{bf:list box:}  
A type of string input control; presents a list of items from which the user
may choose.  A list box has (sets) a string value.

{phang}
{bf:numeric input control:}  
An input control that returns a numeric value associated with it.

{phang}
{bf:position:}  
Where something is located, measured from the top left by how far to the right
it is ({it:x}) and how far down it is ({it:y}).

{marker PROGRAM}{...}
{phang}
{bf:PROGRAM:}  
A programming concept dealing with the implementation of dialogs.
{hi:PROGRAM}s may be used to implement i-actions or u-actions.  Also see
{help dialogs##SCRIPT:{it:SCRIPT}}.

{marker radio_buttons}{...}
{phang}
{bf:radio buttons:}  
A set of numeric input controls, each a button, of which only one may be
selected at a time; suitable for obtaining categorical responses.  Each radio
button in the set has (sets) a numeric value, 0 or 1, depending on which
button is selected.  Only one in the set will be 1.

{marker SCRIPT}{...}
{phang}
{bf:SCRIPT:}  
A programming concept dealing with the implementation of dialogs.  An array of
i-actions to be executed one after the other; errors that occur do not stop
subsequent actions from being attempted.  Also see
{help dialogs##PROGRAM:{it:PROGRAM}}.

{phang}
{bf:size:}  
How large something is, measured from its top-left corner, as a width
({it:xsize}) and height ({it:ysize}).  Height is measured from the
top down.

{phang}
{bf:spinner:}  
A type of numeric input control; presents a numeric value that the user may
increase or decrease over a range.  A spinner has (sets) a numeric value.

{marker static_control}{...}
{phang}
{bf:static control:}  
A screen element similar to an input control, except that the end user cannot
interact with it.  Static controls include static text and
lines drawn around controls visually to group them together (group boxes and
frames).  Also see
{help dialogs##control:{it:control}} and
{help dialogs##input_control:{it:input control}}.

{phang}
{bf:static text:}  
A static control specifying text to be placed on a dialog.

{phang}
{bf:string input control:}  
An input control that returns a string value associated with it.

{phang}
{bf:tabs:}  
The small labels at the top of each dialog (when there is more
than one dialog associated with the dialog box) and on which the user clicks
to select the dialog to be filled in.

{marker title_or_label}{...}
{phang}
{bf:title or label:}  
The fixed text that appears above or on objects such as dialog boxes and
buttons.  Controls are usually said to be labeled, whereas dialog boxes are
said to be titled.

{marker uaction}{...}
{phang}
{bf:u-action:}  
What a dialog box causes to happen after the user has filled it in and clicked
on a u-action (ultimate action) button.  The point of a dialog box is to
result in a u-action.

{marker u-action_buttons}{...}
{phang}
{bf:u-action buttons:}  
The buttons {hi:OK}, {hi:Submit}, {hi:Cancel}, and {hi:Copy}; clicking on one
causes the ultimate action (u-action) associated with the button to occur and,
perhaps, the dialog box to close.

{phang}
{bf:varlist or varname control:}  
A type of string input control; an edit field that also accepts input from
the Variables window.  This control also contains a combo-box-style list of
the variables.  A varlist or varname control has (sets) a string value.


{marker AppendixB}{...}
{title:Appendix B:  Class definition of dialog boxes}

{pstd}
Dialog boxes are implemented in terms of class programming; see
{manhelp class P}.

{pstd}
The top-level class instance of a dialog box defined in {it:dialogbox}
{cmd:.dlg} is {cmd:.}{it:dialogbox}{cmd:_dlg}.  Dialogs and controls are
nested within that, so {cmd:.}{it:dialogbox}{cmd:_dlg}{cmd:.}{it:dialogname}
would refer to a dialog, and
{bind:{cmd:.}{it:dialogbox}{cmd:_dlg}{cmd:.}{it:dialogname}{cmd:.}{it:controlname}}
would refer to a control in the dialog.

{pstd}
{bind:{cmd:.}{it:dialogbox}{cmd:_dlg}{cmd:.}{it:dialogname}{cmd:.}{it:controlname}{cmd:.value}} 
is the current value of the control, which will be either a {cmd:string} or
a {cmd:double}.  You must not change this value.

{pstd}
The member functions of the controls are implemented as member functions of
{cmd:.}{it:dialogbox}{cmd:_dlg}{cmd:.}{it:dialogname.controlname} and 
may be called in the standard way.


{marker AppendixC}{...}
{title:Appendix C:  Interface guidelines for dialog boxes}

{pstd}
One of Stata's strengths is its strong support for cross-platform 
use -- datasets and programs are completely compatible across platforms.
This includes dialogs written in the dialog-programming language.  Although
Mac, Windows, and X Windows share many common graphical user-interface
elements and concepts, they all vary slightly in their appearance and
implementation.  This variation makes it difficult to design dialogs that look
and behave the same across all platforms.  Dialogs should look pleasant on
screen to enhance their usability, and achieving this goal often means being
platform specific when laying out controls.  This often leads to undesirable
results on other platforms.

{pstd}
The dialog-programming language was written with this in mind, and dialogs
that appear and behave the same across multiple operating systems and appear
pleasant can be created by following some simple guidelines.

{phang}
{bf:Use default heights where applicable}:
    Varying vertical-size requirements of controls across different
    operating systems can cause a dialog that appears properly on one platform
    to display controls that overlap one another on another platform.  Using
    the default {it:ysize} of {cmd:.} takes these variations into account and
    allows for much easier placement and alignment of controls.  Some controls
    (list boxes, regular combo boxes, group boxes, and frames) still require
    their {it:ysize} to be specified because their vertical size determines
    how much information they can reveal.

{phang}
{bf:Use all horizontal space available}: 
    Different platforms use different types of fonts to display
    text labels and control values.  These variations can cause some control
    labels to be truncated (or even word wrapped) if their {it:xsize} is not
    large enough for a platform's system font.  To prevent this from
    happening, specify an {it:xsize} that is as large as possible.  For each
    column of controls, specify the entire column width for each control's
    {it:xsize}, even for controls where it is obviously unnecessary.  This
    reduces the chances of a control's label being truncated on another
    platform and also allows you to make changes to the label without constantly 
    having to adjust the {it:xsize}.  If your control barely fits into the
    space allocated to it, consider making your dialog slightly larger.

{phang}
{bf:Use the appropriate alignment for static text controls}:
    The variations in system fonts also make it difficult to horizontally
    align static text controls with other controls.  Placing a static text
    control next to an edit field may look good on one platform but show up
    with too much space between the controls on another or even show up
    truncated.

{pmore}
    One solution is to place static text controls above controls that have an
    edit field and make the static text control as wide as possible.  This
    gives more room for the static text control and makes it easier to
    left-justify it with other controls.

{pmore}
    When placing a static text control to the left of a
    control is more appropriate (such as From: and To: edit fields), use
    right-alignment rather than the default left-alignment.  The two controls
    will then be equally spaced apart on all platforms.  Again be sure to make
    the static text control slightly wider than necessary -- do not try to
    left-justify a right-aligned static text control with controls above and
    below it because it may not appear left-justified on other platforms or
    may even be truncated.

{phang}
{bf:Do not crowd controls}:
    Without making your dialog box unnecessarily large, use all the space that
    is available.  Organize related controls close together, and put some
    distance between unrelated ones.  Do not overload users with lots of
    controls in one dialog.  If necessary, group controls in separate
    dialogs.  Most importantly, be consistent in how you layout controls.

{phang}
{bf:All vertical size and spacing of controls involves multiples of 10 pixels}:  
    The default {it:ysize} for most controls is 20 pixels.  Related controls
    are typically spaced 10 pixels apart, and unrelated ones are at least 20
    pixels apart.

{phang}
{bf:Use the appropriate control for the job}:
    Checkboxes have two states: on or off.  A radio-button group consisting
    of two radio buttons similarly has two states.  A checkbox is appropriate
    when the action taken is either on or off or easy to infer (for
    example, {bf:Use constant}).  A two-radio-button group is appropriate when
    the opposite state cannot be inferred (for example, {bf:Display graph} and
    {bf:Display table}).

{pmore}
    Radio-button groups should contain at least two radio buttons and no more
    than about seven.  If you need more choices, consider using a drop-down-list
    combo box or, if the number of choices is greater than about 12, a
    list box.  If you require a control that allows multiple selections,
    consider a regular combo box or drop-down combo box.  Drop-down combo boxes
    can be cumbersome to use if the number of choices is great, so use a
    regular combo box unless space is limited.

{phang}
{bf:Understand control precedence for mouse clicks}:
    Because of the limited size of dialogs, you may want to place several
    controls within the same area and hide and show them as necessary.  It is
    also useful to place controls within other controls, such as group boxes
    and frames, for organizational and presentational purposes.  However, the
    order of creation and placement and size of controls can affect
    which controls receive mouse clicks first or whether they receive them at
    all.

{pmore}
    The control where this can be problematic is the radio button.  On some
    platforms, the space occupied by a group of radio buttons is not the space
    occupied by the individual radio buttons.  It is inclusive to the
    space occupied by the radio button that is closest to the top-left corner
    of the dialog, the widest radio button, and the bottommost radio button.
    To prevent a group of radio buttons from preventing mouse clicks
    being received by other controls, Stata gives precedence to all other
    controls except for group boxes and frames.  The order of precedence for
    controls that can receive mouse clicks is the following: first, all
    controls other than radio buttons and checkbox group boxes, then radio
    buttons, then checkbox group boxes.

{pmore}
    If you intend to place two or more groups of radio buttons in the same
    area and show and hide them as necessary, be sure that when you hide the
    radio buttons from a group, you hide all radio buttons from a group.
    The radio-button group with precedence over other groups will continue to
    have precedence as long as any of its radio buttons are visible.  Mouse
    clicks in the space occupied by nonvisible radio buttons in a group with
    precedence will not pass through to any other groups occupying the same
    space.

{pmore}
    It is always safe to place controls within frames, group boxes, and
    checkbox group boxes because all other controls take precedence over those
    controls.

{pmore}
    In practice, you should never hide a radio button from a group without
    hiding the rest of the radio buttons from the group.  Consider simply
    disabling the radio button or buttons instead.  It is also not a good idea
    to hide or show radio buttons from different groups to make them 
    appear that they are from the same group.  That simply will not work
    on some platforms and is generally a bad idea, anyway.

{pmore}
    Radio buttons have precedence over checkbox group boxes.  You may place
    radio buttons within a checkbox group box, but do not place a checkbox
    group box within the space occupied by a group of radio buttons.  If you
    do, you may not be able to click on the checkbox control on some
    platforms.
{p_end}


{marker faqs}{...}
{title:Frequently asked questions}

{pstd}See
{browse "http://www.stata.com/support/faqs/lang/#dialog":dialog programming FAQs} on the Stata website.{p_end}
