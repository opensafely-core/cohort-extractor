{smcl}
{* *! version 1.2.3  15may2018}{...}
{vieweralsosee "[P] window menu" "mansection P windowmenu"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] Dialog programming" "help dialog_programming"}{...}
{vieweralsosee "[P] window manage" "help window manage"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[P] window programming" "help window_programming"}{...}
{viewerjumpto "Syntax" "window_menu##syntax"}{...}
{viewerjumpto "Description" "window_menu##description"}{...}
{viewerjumpto "Links to PDF documentation" "window_menu##linkspdf"}{...}
{viewerjumpto "Remarks" "window_menu##remarks"}{...}
{p2colset 1 20 22 2}{...}
{p2col:{bf:[P] window menu} {hline 2}}Create menus{p_end}
{p2col:}({mansection P windowmenu:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

    Clear previously defined menu additions

{p 8 15 2}
{opt win:dow} {opt m:enu} {cmd:clear}


    Define submenus

{p 8 15 2}
{opt win:dow} {opt m:enu} {cmd:append submenu}
{cmd:"}{it:defined_menuname}{cmd:"}
{cmd:"}{it:appending_menuname}{cmd:"}


    Define menu item

{p 8 15 2}
{opt win:dow} {opt m:enu} {cmd:append item}
{cmd:"}{it:defined_menuname}{cmd:"}
{cmd:"}{it:entry_text}{cmd:"} {cmd:"}{it:command_to_execute}{cmd:"} 


    Define separator bars

{p 8 15 2}
{opt win:dow} {opt m:enu} {cmd:append separator}
{cmd:"}{it:defined_menuname}{cmd:"}


    Activate menu changes

{p 8 15 2}
{opt win:dow} {opt m:enu} {cmd:refresh}


    Add files to the Open recent menu

{p 8 15 2}
{opt win:dow} {opt m:enu} {cmd:add_recentfiles}
{cmd:"}{it:filename}{cmd:"} [ {cmd:,} {cmdab:rlev:el:(}{it:#}{cmd:)} ]


{phang}
The quotation marks above are required.

{phang}
{cmd:"}{it:defined_menuname}{cmd:"} is the name of a previously defined menu
or one of the user-accessible menus {hi:"stUser"}, {hi:"stUserData"},
{hi:"stUserGraphics"}, or {hi:"stUserStatistics"}.


{marker description}{...}
{title:Description} 

{pstd}
{cmd:window} {cmd:menu} allows you to add new menu hierarchies.


{marker linkspdf}{...}
{title:Links to PDF documentation}

        {mansection P windowmenuRemarksandexamples:Remarks and examples}

{pstd}
The above sections are not included in this help file.


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

       {hi:{help window menu##overview:Overview}}
       {hi:{help window menu##clearing:Clear previously defined menu additions}}
       {hi:{help window menu##submenus:Define submenus}}
       {hi:{help window menu##defmenu:Define menu items}}
       {hi:{help window menu##separator:Define separator bars}}
       {hi:{help window menu##menuchanges:Activate menu changes}}
       {hi:{help window menu##add_recentfiles:Add files to the Open recent menu}}
       {hi:{help window menu##keyboard:Keyboard shortcuts (Windows only)}}
       {hi:{help window menu##examples:Examples}}
       {hi:{help window menu##dialogs:Advanced features: Dialogs and built-in actions}}
       {hi:{help window menu##checkedmenu:Advanced features: Creating checked menu items}}
       {hi:{help window menu##together:Putting it all together}}


{marker overview}{...}
{title:Overview}

{pstd}
A menu is a list of choices.  Each choice may be another menu (known as a
submenu) or an item.  When you click on an item, something happens, such as a
dialog box appearing or a command being executed.  Menus may also contain
separators, which are horizontal bars that help divide the menu into groups of
related choices.

{pstd}
Stata provides the top-level menus {hi:Data}, {hi:Graphics}, {hi:Statistics},
and {hi:User} to which you may attach your own submenus, items, or separators.

{pstd}
A menu hierarchy is the collection of menus and how they relate.

{pstd}
{cmd:window} {cmd:menu} allows you to create menu hierarchies, set the text
that appears in each menu, set the actions associated with each menu item,
and add separators to menus.

{pstd}
New menu hierarchies are defined from the top down, not from
the bottom up.  Here is how you create a new menu hierarchy:

{phang}
1.  You append to some existing Stata menu a new submenu using 
    {cmd:window} {cmd:menu} {cmd:append} {cmd:submenu}.  That the new
    submenu is empty is of no consequence.

{phang}
2.  You append to the new submenu other submenus, items, or separators,
    all done with {cmd:window} {cmd:menu} {cmd:append}.  In this way,
    you fill in the new submenu you already appended in step 1.

{phang}
3.  If, in step 2, you appended submenus to the menu you defined in step 1, 
    you append to each of them so that they are fully defined.  This 
    requires even more {cmd:window} {cmd:menu} {cmd:append} commands.

{phang}
4.  You keep going like this until the full hierarchy is defined.
    Then you tell Stata's menu manager that you are done using 
    {cmd:window} {cmd:menu} {cmd:refresh}.

{pstd}
Everything you do up to step 4 is merely definitional.  At step 4, what you
have done takes effect.

{pstd}
You can add menus to Stata.  Then you can add more menus.  Later, you can add
even more menus.  What you cannot do, however, is ever delete a little bit of
what you have added.  You can add some menus and {cmd:window} {cmd:menu} 
{cmd:refresh}, then add some more and {cmd:window} {cmd:menu} {cmd:refresh},
but you cannot go back and remove part of what you added earlier.  What you
can do is remove all the menus you have added, restoring Stata to its original
configuration.  {cmd:window} {cmd:menu} {cmd:clear} does this.

{pstd}
So, in our opening example, how did the {hi:Regression} submenu ever get
defined?  By typing

       {cmd:. window menu append submenu "stUserStatistics" "Regression"}
       {cmd:. window menu append item "Regression" "Simple" . . .}
       {cmd:. window menu append item "Regression" "Multiple" . . .} 
       {cmd:. window menu append item "Regression" "Multivariate" . . .}
       {cmd:. window menu refresh}

{pstd}
{cmd:stUserStatistics} is the special name for Stata's 
{hi:User}{hline 1}{hi:Statistics} built-in menu.  The first command appended
a submenu to {cmd:stUserStatistics} named {hi:Regression}.  At this point,
{hi:Regression} is an empty submenu.

{pstd}
The next three commands filled in {hi:Regression} by appending to it.
All three are items, meaning that when chosen, they invoke some Stata command
or program.  (We have not shown you what the Stata commands are; we just put
". . ." to indicate them.)

{pstd}
Finally, {cmd:window} {cmd:menu} {cmd:refresh} told Stata we 
were done and to make our new additions available. 


{marker clearing}{...}
{title:Clear previously defined menu additions}

{p 8 18 2}
{opt win:dow} {opt m:enu} {cmd:clear}

{pstd}
clears any additions that have been made to Stata's menu system.


{marker submenus}{...}
{title:Define submenus}

{p 8 18 2}
{opt win:dow} {opt m:enu} {cmd:append submenu}
{cmd:"}{it:defined_menuname}{cmd:"} {cmd:"}{it:appending_menuname}{cmd:"}

{pstd}
defines a submenu.  This command creates a submenu with the text
{it:appending_menuname} (the double-quote characters do not appear in
the submenu when displayed) attached to the
{cmd:"}{it:defined_menuname}{cmd:"}.  It also declares that the
{cmd:"}{it:appending_menuname}{cmd:"} can later have further submenus, items,
and separators appended to it.  Submenus may be appended to Stata's built-in
{hi:User} menu using the command

{p 8 18 2}
{cmd:window menu append submenu "stUser"} {cmd:"}{it:appending_menuname}{cmd:"}

{pstd}
For example,

{p 8 18 2}
{cmd:window menu append submenu "stUser" "New Menu"}

{pstd}
appends {hi:New Menu} to Stata's {hi:User} menu.  Likewise, submenus may be
appended to the built-in submenus of {hi:User} -- {hi:Data},
{hi:Graphics}, and {hi:Statistics} -- by using {hi:stUserData},
{hi:stUserGraphics}, or {hi:stUserStatistics} as the {it:defined_menuname}.


{marker defmenu}{...}
{title:Define menu items}

{p 8 18 2}
{opt win:dow} {opt m:enu} {cmd:append item}
{cmd:"}{it:defined_menuname}{cmd:"}
{cmd:"}{it:entry_text}{cmd:"} 
{cmd:"}{it:command_to_execute}{cmd:"}

{pstd}
defines menu items.  This command creates a menu item with the text
{cmd:"}{it:entry_text}{cmd:"}, which is attached to the
{cmd:"}{it:defined_menuname}{cmd:"}.  When the item is selected by the user,
{cmd:"}{it:command_to_execute}{cmd:"} is invoked.

{pstd}
For example,

{p 8 18 2}
{cmd:window menu append item "New Menu" "Describe" "describe"}

{pstd}
appends the menu item {hi:Describe} to the {hi:New Menu} submenu defined
previously and specifies that if the user selects {hi:Describe}, the
{cmd:describe} command is to be executed.


{marker separator}{...}
{title:Define separator bars}

{p 8 18 2}
{opt win:dow} {opt m:enu} {cmd:append separator "}{it:defined_menuname}{cmd:"}

{pstd}
defines a separator bar.  The separator bar will appear in the position in
which it is declared and is attached to an existing submenu.

{pstd}
For example,

{p 8 18 2}
{cmd:window menu append separator "New Menu"}

{pstd}
adds a separator bar to {hi:New Menu}.


{marker menuchanges}{...}
{title:Activate menu changes}

{p 8 18 2}
{opt win:dow} {opt m:enu} {cmd:refresh}

{pstd}
activates the changes made to Stata's menu system.

{marker add_recentfiles}{...}
{title:Add files to the Open recent menu}

{pstd}
The {hi:Open recent} menu is a list of datasets recently used or saved by the
user.  Selecting a dataset from the menu causes Stata to execute a
{helpb use} command on the dataset to load the data.  The datasets are
represented in the list as the absolute path or URL to the dataset.

{pstd}
A dataset is added to the list if the dataset is loaded by the command
{helpb use} or saved by the command {helpb save}.
The list is ordered from the most recently used datasets to the least recently
used datasets.  The maximum number of datasets in the list is twenty and
datasets are removed from the bottom of the list when the maximum is reached.
If a dataset already exists in the list when it is to be added, the existing
entry is moved to the top of the list.

{pstd}
The list of datasets from the {hi:Open recent} menu is saved when exiting
Stata and loaded when starting Stata.  Stata removes datasets that do not
exist from the list when it exits and starts but not during a session.
Stata does not attempt to determine if a URL is valid.

{p 8 18 2}
{opt win:dow} {opt m:enu} {cmd:add_recentfiles "}{it:filename}{cmd:"}
{cmd:[ , }{opt rlev:el}{cmd:(}{it:#}{cmd:)} {cmd:]}

{pstd}
adds a dataset to the {hi:Open recent} menu under the {hi:File} menu.  Only
datasets should be added to the {hi:Open recent} menu.

{pstd}
To prevent temporary files from being added to the {hi:Open recent} menu,
Stata does not add datasets used or saved by do-files and ado-files or
when running a batch file.  However, for the cases where you do wish to add a
dataset used or saved by an ado-file or do-file, you may use the
{cmd:rlevel()} option.

{pstd}
The {cmd:rlevel()} option determines the maximum run level an ado-file
issuing the {cmd:window menu add_recentfiles} may run at for a dataset
to be added to the {hi:Open recent} menu.  If no ado-file is
running, the run level is {cmd:0}.  If an ado-file executes another ado-file
which executes another ado-file before returning to the previous ado-file,
the run level is {cmd:3}.  {cmd:rlevel(0)} adds a dataset only if no ado-file
or do-file is running and is the default.  {cmd:rlevel(3)} adds a dataset if
an ado-file is up to 3 levels deep when called.  {cmd:rlevel(-1)} adds a
dataset regardless of the run level and is the only way to add a dataset from
a do-file.

{pstd}
For example, {helpb sysuse} is implemented as an ado-file.  We want
to add datasets loaded by {cmd:sysuse} to the {hi:Open recent} menu only if
the user entered {cmd:sysuse} from the command line.  We add to
{cmd:sysuse.ado}

{p 8 18 2}
{cmd:window menu add_recentfiles} "{it:filename}"{cmd:, rlevel(1)}

{pstd}
If we had used a run level of {cmd:2}, any dataset loaded by {cmd:sysuse}
from an ado-file would be added to the {hi:Open recent} menu which
is not what we want.

{marker keyboard}{...}
{title:Keyboard shortcuts (Windows only)}

{pstd}
When you define a menu item, you may assign a keyboard shortcut.  A shortcut
(or keyboard accelerator) is a key that allows a menu item to be selected via
the keyboard in addition to the usual point-and-click method.

{pstd}
By placing an ampersand ({cmd:&}) immediately preceding a character, you
define that character to be the shortcut.  The ampersand will not appear in
the menu item, but the character following the ampersand will be
underlined to alert the user of the shortcut.  The user may then choose the
menu item by either clicking with the mouse or holding down {hi:Alt} and
pressing the shortcut key.  Actually, you only have to hold down {hi:Alt} for
the top-level menu.  For the submenus, once they are pulled down, holding down
{hi:Alt} is optional.

{pstd}
If you need to include an ampersand as part of the
{cmd:"}{it:entry_text}{cmd:"}, place two ampersands in a row.

{pstd}
It is your responsibility to avoid creating conflicting keyboard shortcuts.
When the user types in a keyboard shortcut, Stata finds the first item with
the defined shortcut.

{pstd}
Example:

{p 8 18 2}
{cmd:window menu append submenu "stUserStatistics" "&Regression"}

{pstd}
defines a new submenu named {hi:Regression} that will appear in the
{hi:User}{hline 1}{hi:Statistics} menu and that users may access by pressing
{hi:Alt-U} (to open the {hi:User} menu), then {hi:S} (to open the
{hi:Statistics} menu), and finally {hi:R}, the shortcut defined for
{hi:Regression}.


{marker examples}{...}
{title:Examples}

{pstd}
Below we use the {cmd:window} {cmd:menu} commands to add to Stata's existing
top-level menu.  The following may be typed interactively:

{p 8 8 2}
{cmd}window menu clear{break}
window menu append submenu "stUser" "&My Data"{break}
window menu append item "My Data" "&Describe data" "describe"{break}
window menu refresh{txt}

{phang}
{cmd:window} {cmd:menu} {cmd:clear} 
{break}
Clears any user-defined menu items and restores the menu system to the
default.

{phang}
{cmd:window} {cmd:menu} {cmd:append} {cmd:submenu} {cmd:"stUser"} {cmd:"&My Data"} 
{break}
Appends to the {hi:User} a new submenu called {cmd:My Data}.  Note that you
may name this new menu anything you like.  You can capitalize its name or not.
You may include spaces in it.  The new menu appears as the last item on the
{hi:User} menu.

{phang}
{cmd:window} {cmd:menu} {cmd:append} {cmd:item} {cmd:"My Data"} 
{cmd:"&Describe data"} {cmd:"describe"} 
{break}
Defines a menu item (including a keyboard shortcut) named {hi:Describe data}
to appear within the {hi:My Data} submenu.  This name is what the user will
actually see.  It also specifies the command to execute when the user selects
the menu item.  In this case, we will run the {cmd:describe} command.

{phang}
{cmd:window} {cmd:menu} {cmd:refresh}
{break}
Causes all the menu items that have been defined and appended to the default
system menus to become active and to be displayed.


{marker dialogs}{...}
{title:Advanced features:  Dialogs and built-in actions}

{pstd}
Recall that menu items can have associated actions:

{p 8 18 2}
{opt win:dow} {opt m:enu} {cmd:append item}
{cmd:"}{it:defined_menuname}{cmd:"}
{cmd:"}{it:entry_text}{cmd:"}
{cmd:"}{it:command_to_execute}{cmd:"}

{pstd}
Actions other than Stata commands and programs can be added to menus.  In the
course of designing a menu system, you may include menu items that will invoke
dialogs, open a Stata dataset, save a Stata graph, or perform some other
common Stata menu command.

{pstd}
You can specify {cmd:"}{it:command_to_execute}{cmd:"} as one of the following:

{phang}{cmd:"DB} {it:dialog_to_invoke}{cmd:"}
{break}
invokes the dialog box defined by the file {cmd:{it:dialog_to_invoke}.dlg}.
For example, specifying {cmd:"DB regress"} as the
{cmd:"}{it:command_to_execute}{cmd:"} results in the dialog box for Stata's 
{cmd:regress} command being invoked when the item is selected.

{phang}{cmd:"XEQ about"}
{break}
displays Stata's About dialog box.  The About dialog box is accessible from
the default system menu by selecting {hi:About} from the {hi:File} menu.

{phang}{cmd:"XEQ save"}
{break}
displays Stata's Save dialog box to save the dataset in memory.
This dialog box is accessed from the default system menu by selecting
{hi:Save} from the {hi:File} menu.

{phang}{cmd:"XEQ saveas"}
{break}
displays Stata's Save Data As dialog box to save the dataset in
memory.  This dialog box is accessible from the default system menu by
selecting {hi:Save as...} from the {hi:File} menu.

{phang}{cmd:"XEQ savegr"}
{break}
displays the Save Stata Graph File dialog box, which saves the currently
displayed graph.  This dialog box is accessible from the default system by
selecting {hi:Save as...} from the {hi:File} menu of the Graph Editor.

{phang}{cmd:"XEQ printgr"}
{break}
prints the graph displayed in the Graph window.  This is available in the
default menu system by selecting {hi:Print Graph} from the {hi:File} menu.
Also see {helpb window manage}.

{phang}{cmd:"XEQ use"}
{break}
displays Stata's Open dialog box, which loads a Stata dataset.  This is
available in the default menu system by selecting {hi:Open...} from the
{hi:File} menu.

{phang}{cmd:"XEQ exit"}
{break}
exits Stata.  This is available from the default menu system by selecting
{hi:Exit} from the {hi:File} menu (or selecting {hi:Quit} from the {hi:Stata}
menu on Mac).

{phang}{cmd:"XEQ conhelp"}
{break}
opens the Stata help system to the default welcome topic.  This is available
by clicking on the {hi:Help!} button in the help system.


{marker checkedmenu}{...}
{title:Advanced features:  Creating checked menu items}

{pstd}
{it:command_to_execute} in 

{p 8 18 2}
{opt win:dow} {opt m:enu} {cmd:append item}
{cmd:"}{it:defined_menuname}{cmd:"}
{cmd:"}{it:entry_text}{cmd:"}
{cmd:"}{it:command_to_execute}{cmd:"}

{pstd}
may also be specified as {hi:CHECK} {it:macroname}.

{pstd}
Another detail that menu designers may want is the ability to create checked
menu items.  A checked menu item is one that appears in the menu system as
either checked (includes a small check mark to the right) or not.

{pstd}
{hi:"CHECK {it:macroname}"} specifies that the global macro {it:macroname}
should contain the value as to whether or not the item is checked.  If the
global macro is not defined at the time that the menu item is created, Stata
defines the macro to contain zero, and the item is not checked.  If the user
selects the menu item to toggle the status of the item, Stata will
place a check mark next to the item on the menu system and redefine the global
macro to contain one.  In this way, you may write programs that access
information that you gather via the menu system.

{pstd}
Note that you should treat the contents of the global macro associated with
the checked menu item as "read only".  Changing the contents of the macro will
not be reflected in the menu system.


{marker together}{...}
{title:Putting it all together}

{pstd}
In the following example, we create a larger menu system.  Note that each
submenu defined using {cmd:window} {cmd:menu} {cmd:append} {cmd:submenu}
contains other submenus and/or items defined with {cmd:window} {cmd:menu}
{cmd:append} {cmd:item} that invoke commands.

    {hline 53} begin lgmenu.do {hline 4}
    {cmd}capture program drop mylgmenu
    program mylgmenu
       version {ccl stata_version}
       win m clear
       win m append submenu "stUserStatistics" "&Regression"
       win m append submenu "stUserStatistics" "&Tests"
    
       win m append item "Regression" "&OLS" "DB regress"
       win m append item "Regression" "Multi&variate" "choose multivariate"
    
       win m append item "stUserGraphics" "&Scatterplot" "choose scatterplot"
       win m append item "stUserGraphics" "&Histogram" "myprog1"
       win m append item "stUserGraphics" "Scatterplot &Matrix" "choose matrix"
       win m append item "stUserGraphics" "&Pie chart" "choose pie"
     
       win m append submenu "Tests" "Test of &mean"
       win m append item "Tests" "Test of &variance" "choose variance"
   
       win m append item "Test of mean" "&Unequal variances" "CHECK DB_uv"
       win m append separator "Test of mean"
       win m append item "Test of mean" "t-test &by variable" "choose by"
       win m append item "Test of mean" "t-test two &variables" "choose 2var"
    
       win m refresh
    end

    capture program drop choose
    program choose
       version {ccl stata_version}
       if "'1'" == "by" | "'1'" == "2var" {c -(}
               display as result "'1'" as text " from the menu system"
               if $DB_uv {c -(}
                       display as text "  use unequal variances"
               {c )-}
               else {c -(}
                       display as text "  use equal variances"
               {c )-}
       {c )-}
       else {c -(}
               display as result "'1'" as text " from the menu system"
       {c )-}
    end

    capture program drop myprog1
    program myprog1
       version {ccl stata_version}
       display as result "myprog1" as text " from the menu system"
    end{txt}
    {hline 53} end lgmenu.do {hline 6}

{pstd}
Running this do-file will define a program {cmd:mylgmenu} that we may use to
set the menus.  Note that, other than the {hi:OLS} item, which launches the
{cmd:regress} dialog box, the menu items will not run any interesting
commands, as the focus of the example is in the design of the menu interface
only.  To see the results, type {cmd:mylgmenu} in the Command window after you
run the do-file.  Below is an explanation of the example.

{pstd}
The command 

        {cmd:win m append submenu "stUserStatistics" "&Regression"}

{pstd}
adds a submenu named {hi:Regression} to the built-in menu {hi:Statistics}
under the {hi:User} menu.  If the user clicks on {hi:Regression}, we will
display another menu with items defined by

{p 8 18 2}{cmd:win m append item "Regression" "&OLS" "DB regress"}{p_end}
{p 8 18 2}{cmd:win m append item "Regression" "Multi&variate" "choose multivariate"}

{pstd}
Because none of these entries open further menus, they use the {cmd:item}
version instead of the {cmd:submenu} version of the {cmd:window} {cmd:menu}
{cmd:append} command.

{pstd}
Similarly, the built-in {hi:User}{hline 1}{hi:Graphics} menu is populated using
{cmd:window} {cmd:menu} {cmd:item} commands.

{p 8 18 2}{cmd:win m append item "stUserGraphics" "&Scatterplot" "choose scatterplot"}{p_end}
{p 8 18 2}{cmd:win m append item "stUserGraphics" "&Histogram" "myprog1"}{p_end}
{p 8 18 2}{cmd:win m append item "stUserGraphics" "Scatterplot &Matrix" "choose matrix"}{p_end}
{p 8 18 2}{cmd:win m append item "stUserGraphics" "&Pie chart" "choose pie"}

{pstd}
For the {hi:Tests} submenu, we decided to have one of the entries be another
submenu for illustration.  First, we declared the {hi:Tests} menu to be a
submenu of {hi:User}{hline 1}{hi:Statistics} using

{p 8 15 2}
{cmd:win m append submenu "stUserStatistics" "&Tests"}

{pstd}
We then defined the entries that were to appear below the {hi:Tests}
menu.  There are two entries:  one of them is another submenu, and the
other is an item.  For the submenu, we then defined the entries that 
are below it.

{pstd}
Finally, note how the commands that are run when the user makes a selection
from the menu system are defined.  For most cases, we simply call the same
program and pass an argument that identifies the menu item that was
selected.  Each menu item may call a different program if you prefer.
Also note how the global macro that was associated with the checked menu
item is accessed in the programs that are run.   When the item is checked,
the global macro will contain 1.  Otherwise, it contains zero.  Our
program merely has to check the contents of the global macro to see if the 
item is checked or not.
{p_end}
