{smcl}
{* *! version 1.0.17  15may2018}{...}
{vieweralsosee undocumented "help undocumented"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] Dialog programming" "help dialog_programming"}{...}
{viewerjumpto "Description" "dialog_undocumented##description"}{...}
{viewerjumpto "Remarks" "dialog_undocumented##remarks"}{...}
{title:Title}

{p2colset 5 31 33 2}{...}
{p2col:{hi:[P] Dialog programming} {hline 2}}Dialog programming{p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
Dialog-box programs -- also called dialog resource files -- allow
you to define the appearance of a dialog box, specify how its controls work
when the user fills it in (such as hiding or disabling specific controls), and
specify the ultimate action to be taken (such as running a Stata command) when
the user clicks on {hi:OK} or {hi:Submit}.  Below are undocumented features of
dialog-box programs.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

	{help dialog_undocumented##remarks1:1. Controls}
	  {help dialog_undocumented##remarks1.1:1.1 TREEVIEW tree input control}
          {help dialog_undocumented##remarks1.2:1.2 EXP expression input control}
	  {help dialog_undocumented##remarks1.3:1.3 Display system fonts in COMBOBOX list input control}

	{help dialog_undocumented##remarks2:2.Built-in member functions for dialog boxes }

	{help dialog_undocumented##remarks3:3.Built-in member functions for dialogs }

	{help dialog_undocumented##remarks4:4. Properties}

	{help dialog_undocumented##remarks5:5. Utilities}


{marker remarks1}{...}
{title:1. Controls}


{marker remarks1.1}{...}
{title:1.1 TREEVIEW tree input control}

{pstd}
The full documentation for TREEVIEW can be found in
{manhelp dialog_programming P:Dialog programming}; see
{help dialog_programming##remarks3.6.17:3.6.17 TREEVIEW tree input control}.


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


    {title:Undocumented option}

{phang}
{opt idx_to_parent} specifies that the integer portion from the list
specification takes on a new meaning.  The first part encloses a nonnegative
integer in square brackets to denote the relationship of the nodes. A {cmd:0}
means that this item is a root of the tree. Other nonzero integers mean that
the item is a child of another node. For instance, {it:k} means that the item
is a child node of the {it:k}th element in the content list. The second part
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
            [6]SubItem C
        END
    . . .
    DIALOG . . .
        BEGIN
            . . .
            TEXT     ourlab    10  10  200   ., label("Pick an item")
            TREEVIEW ourtree   @   +20 150 200, contents(ourcontentlist)
            . . .
        END

{phang}
By default, nodes are specified by their depth.


{marker remarks1.2}{...}
{title:1.2 EXP expression input control}

{pstd}
The full documentation for EXP can be found in
{manhelp dialog_programming P:Dialog programming}; see
{help dialog_programming##remarks3.6.15:3.6.15 EXP expression input control}.


    {title:Syntax}

{p 8 14 2}
EXP  {it:newcontrolname} {it:x} {it:y} {it:xsize} {it:ysize}
     [{cmd:,} {opt l:abel}("{it:string}") {opt e:rror}("{it:string}")
     {opt default(defstrval)} {opt nomem:ory}
     {opt onchange(iaction)} {opt op:tion(optionname)}
     {cmd:tooltip("}{it:string}{cmd:")}]


    {title:Undocumented options}

{phang}
{opt matrixonly} specifies that only the estimation results matrices, return
results matrices, user-defined matrices, and matrix functions tree-view
categories be displayed in the expression builder.

{phang}
{opt simple} specifies that only the functions, coefficients, estimation
results, return results, macros, and scalar tree-view categories be displayed
in the expression builder.

{phang}
{opt parameter} adds the category parameters to the tree-view categories
display in the expression builder.


{marker remarks1.3}{...}
{title:1.3 Display system fonts in COMBOBOX list input control}

{pstd}
The combo box will contain all available fonts for the current operating
system when the contents list is initialized with {cmd:fonts}

{p 8 14 2}
COMBOBOX {it:newcontrolname} {it:x} {it:y} {it:xsize} {it:ysize}{cmd:,} {opt cont:ents}({cmd:fonts}){cmd:}

{phang}
The full documentation for COMBOBOX can be found in 
{manhelp dialog_programming P:Dialog programming}; see 
{help dialog_programming##remarks3.6.8:3.6.8 COMBOBOX list input control}.


    {title:Undocumented member function for COMBOBOX list input control}

{phang}
{cmd:.loadfontstyles}{break} 
	causes a COMBOBOX control to load all available font styles for a 
	specific font that was selected from a COMBOBOX control that uses {cmd:fonts}
	as its contents list. To display font styles, you must have two 
	COMBOBOX controls. The first combo box uses the contents list specified 
	by {cmd:fonts} to load the operating system fonts; the second combo box 
	uses {cmd:.loadfontstyles} to load the font styles for the chosen font 
	into its own contents list.


    {title:Example}
    
    DIALOG sample
        BEGIN
            . . .
            COMBOBOX	cb_font    10  10  150   110, contents(fonts) 	///
			label("Font") onselchange(program style_change)
            COMBOBOX 	cb_style   180 @   150 	 110, label("Style")	///
			contents(font_style_list)
            . . .
        END

    LIST font_style_list
        BEGIN
	    Regular
	    Bold
	    Italic
	    Bold Italic
        END
    . . .
    PROGRAM style_change
        BEGIN
            . . .
	    call sample.cb_font.withvalue sample.cb_style.loadfontstyles "@"
            . . .
        END	
	
	
{marker remarks2}{...}
{title:2. Built-in member functions for dialog boxes}

{pstd}
The built-in functions below operate on a dialog resource, otherwise
known as a dialog box.

{pstd}
The built-in functions are the following:

{phang}
{cmd:.Submit}{break}
	causes the dialog box to submit its current command string to Stata.
	This is equivalent to clicking on the {hi:Submit} button in the dialog
        box.

{phang}
{cmd:.GetSubmit}{break}
	causes the dialog box to process the u-action associated with
	the {hi:Submit} button and display the contents of the command string.
	Alternatively, the name of a previously declared {cmd:STRING} property
	can be supplied to receive the contents of the command string.
	
{phang}
{cmd:.Ok}{break}
	causes the dialog box to submit its current command string to Stata and
	close.  This is equivalent to clicking on the {hi:Ok} button in the
        dialog box.  

{phang}
{cmd:.Reset}{break}
	causes the dialog box to reset.  This is equivalent to clicking on the 
	{hi:(R)} button in the dialog box.
	
{phang}
{cmd:.Cancel}{break}
	causes the dialog box to close.  This is equivalent to clicking on the 
	{hi:Cancel} button in the dialog box.
	
{phang}
{cmd:.Execute} {it:executionstring}{break}
	causes the dialog box to execute some task specified by 
	{it:executionstring}.  Usually, this is a {cmd:script}
	or {cmd:program} defined in the dialog box.
	
{p 8 8 2}
	{hi:Example:}
	
{p 12 12 2}	
	{it:dlgresource}{cmd:.Execute "program main_hide_controls"}

{phang}
{cmd:.SaveState}{break}
	causes the dialog box to save its current state.  This
	happens automatically when the {hi:Submit} or {hi:OK} button is
        clicked on in the dialog box.

	
{marker remarks3}{...}
{title:3. Built-in member functions for dialogs}

{pstd}
The built-in functions below operate on dialogs, otherwise
known as dialog tabs.

{pstd}
The built-in functions are

{phang}
{cmd:.setactive}{break}
	causes a tab to become active.  This is equivalent to clicking on
	the button associated with a dialog tab.

	
{marker remarks4}{...}
{title:4. Properties}

{pstd}
{opt SVECTOR} is a vector property that can store up to 1000 string values.

{phang}
Member functions:

{p2colset 8 32 34 2}{...}
{p2col :type}member functions{p_end}
{p2line}
{p2col :{opt SVECTOR}}{it:propertyname}{opt .dropall}{p_end}
{p2col :}{it:propertyname}{opt .copyFromArray} {it:classArrayName}{p_end}
{p2col :}{it:propertyname}{opt .copyToArray} {it:classArrayName}{p_end}
{p2col :}{it:propertyname}{opt .copyToString} {it:stringPropertyName}{p_end}
{p2col :}{it:propertyname}{opt .findstr} {it:{help dialogs##specialdefs.:strvalue}}{p_end}
{p2col :}{it:propertyname}{opt .store} {it:#} {it:{help dialogs##specialdefs.:strvalue}}{p_end}
{p2col :}{it:propertyname}{opt .swap} {it:#} {it:#}{p_end}
{p2line}
{p 7 14 2}Note:  {it:propertyname}{opt .findstr} sets the {opt position} data 
member to the index of the first matching {it:{help dialogs##specialdefs.:strvalue}}, 
or 0 if the {it:{help dialogs##specialdefs.:strvalue}} is not found. 
{p2colreset}{...}


{marker remarks5}{...}
{title:5. Utilities}

{phang}
{cmd:_dialog discard [{it:objectname}]}{break}
	causes the dialog specified by {it:dlgname} and all of its class system
	objects	to be destroyed.  If a {it:dlgname} is not specified, all 
	dialogs and their class system objects will be destroyed.
{p_end}
