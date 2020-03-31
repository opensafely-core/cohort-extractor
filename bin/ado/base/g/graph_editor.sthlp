{smcl}
{* *! version 1.2.15  17apr2019}{...}
{vieweralsosee "[G-1] Graph Editor" "mansection G-1 GraphEditor"}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[G-2] graph twoway" "help twoway"}{...}
{viewerjumpto "Remarks" "graph_editor##remarks"}{...}
{viewerjumpto "Video example" "graph_editor##video"}{...}
{p2colset 1 23 25 2}{...}
{p2col:{bf:[G-1] Graph Editor} {hline 2}}Graph Editor{p_end}
{p2col:}({mansection G-1 GraphEditor:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker remarks}{...}
{title:Remarks}

{pstd}
Remarks are presented under the following headings:

            {help graph editor##quickstart:Quick start}
            {help graph editor##introduction:Introduction}
            {help graph editor##start_stop:Starting and stopping the Graph Editor}
            {help graph editor##tools:The tools}
    	        {help graph editor##pointer:The Pointer Tool}
	        {help graph editor##text_tool:Add Text Tool}
	        {help graph editor##line_tool:Add Line Tool}
	        {help graph editor##marker_tool:Add Marker Tool}
	        {help graph editor##grid_edit_tool:Grid Edit Tool}
            {help graph editor##object_browser:The Object Browser}
            {help graph editor##contextual_menus:Right-click Menus, or Contextual Menus}
            {help graph editor##standard_toolbar:The Standard Toolbar}
            {help graph editor##main_menu:The main Graph Editor menu}
            {help graph editor##grid_editing:Grid editing}
            {help graph editor##recorder:Graph Recorder}
            {help graph editor##tips_tricks:Tips, tricks, and quick edits}


{marker quickstart}{...}
{title:Quick start}

{pstd}
Start the Editor by right-clicking on any graph and selecting {bf:Start}
{bf:Graph} {bf:Editor}.  Select any of the tools along the left of the
Editor to edit the graph.  The Pointer Tool is selected by default.

{pstd}
Change the properties of objects or drag them to new locations by using the
Pointer.  As you select objects with the Pointer, a
Contextual Toolbar will appear just above the graph.  Use any of the
controls on the Contextual Toolbar to immediately change the most
important properties of the selected object.  Right-click on an object to
access more properties and operations.  Hold the {it:Shift} key when
dragging objects to constrain the movement to horizontal, vertical, or
90-degree angles.

{pstd}
Do not be afraid to try things.  If you do not like a result, change it back
with the same tool, or click on the {bf:Undo} button in the Standard Toolbar
(below the main menu).  {bf:Edit > Undo} in the main menu does the same thing.

{pstd}
Add text, lines, or markers (with optional labels) to your graph by using the
three {it:Add ...} tools.  Lines can be
changed to arrows with the Contextual Toolbar.  If you do not like
the default properties of the added objects, simply change their settings in
the Contextual Toolbar before adding the text, line, or marker.  The
new setting will then be applied to all subsequently added objects, even in
future Stata sessions.

{pstd}
Remember to reselect the Pointer Tool when you want to drag objects
or change their properties.

{pstd}
Move objects on the graph and have the rest of the objects adjust their
position to accommodate the move with the Grid Edit Tool.
With this tool, you are repositioning objects in the underlying grid
that holds the objects in the graph.  Some graphs, for example,
{help by_options:by-graphs}, are
composed of nested grids.  You can reposition objects only within the grid
that contains them; they cannot be moved to other grids.

{pstd}
You can also select objects in the Object Browser to 
the right of the graph.  This window shows a hierarchical listing of the
objects in the graph.  Clicking or right-clicking on an object in the
Browser is the same as clicking or right-clicking on the object in the
graph.

{pstd}
You can record your edits and play them back on other graphs.  Click on the
{bf:Start} {bf:Recording} button in the Standard Toolbar to begin
recording; all ensuing edits are recorded.  Click on the same button to end the
recording.  You will be prompted to name the recording.  While editing another
graph, click on the {bf:Play} {bf:Recording} button and select your recording
from the list.  Your recorded edits will be applied to the graph.  You can also
play recorded edits from the command line when a graph is created or used from
disk.  See the {cmd:play(}{it:recordingname}{cmd:)} option in
{manhelpi std_options G-3} and {manhelp graph_use G-2:graph use}.

{pstd}
Stop the Editor by selecting {bf:File > Stop} {bf:Graph} {bf:Editor} from the
main menu. You must stop the Graph Editor to enter Stata commands.

{pstd}
Start editing graphs now, or read on for a gentler introduction that discusses
some nuances of the Editor.


{marker introduction}{...}
{title:Introduction}

{pstd}
With Stata's {bf:Graph} {bf:Editor} you can change almost anything on your
graph. You can add text, lines, arrows, and markers wherever you would
like.  As you read through this documentation (or at least on your second
reading), we recommend that you open Stata, draw a graph, and try what is
described.  If you are surprised by a result, or do not like how something
looks, you can always undo the operation by pressing the {bf:Undo} button
on the Standard Toolbar (more on that later) or by selecting {bf:Edit > Undo}
from the main menu.


{marker start_stop}{...}
{title:Starting and stopping the Graph Editor}

{pstd}
To start the Editor, 1) right-click within the Graph
window and select {bf:Start} {bf:Graph} {bf:Editor}, 2) select 
{bf:File > Start Graph Editor} from
the main menu, or 3) click on the {bf:Start} {bf:Graph} {bf:Editor} button
in the toolbar.

{pstd}
To close the Editor, 1) right-click within the Graph
window and select {bf:Stop Graph Editor}, 2) select 
{bf:File > Stop Graph Editor} from the
main menu, or 3) click on the {bf:Stop Graph Editor} button in
the toolbar.

{pstd}
When in the Editor, you cannot execute Stata commands.  In
fact, the Command window is grayed out and will not accept input.


{marker tools}{...}
{title:The tools}

{pstd}
When the Graph Editor starts, you will notice several changes to the
Graph window.  The most important is the addition of a Tools
Toolbar to the left of the graph.  (You can move this toolbar under Microsoft 
Windows, and if you have previously moved it, it will appear wherever you last
placed it.)  This toolbar holds the tools you use to edit graphs.  There are
other changes to the window, but ignore these for now.

{pstd}
To use any tool, simply click on that tool. The selected tool will remain in
effect until you select another tool.

{pstd}
You are always using one of the tools.  When you first start the Editor,
the Pointer Tool is active.


{marker pointer}{...}
{pstd}
{bf:The Pointer Tool} 

{pstd}
With the Pointer Tool you can select objects, drag objects, or
modify the properties of objects.  For example, you can select a title and by
holding the left mouse button drag that title to another position on the
graph.  Hold the {it:Shift} key while dragging to constrain the direction to
horizontal, vertical, or a 90-degree angle from the original position.

{pstd}
A few graph objects cannot be moved with the Pointer, in particular, axes, plot
regions, and plots.  Moving these objects would almost certainly distort the
information in the graph.  You can reposition these objects by using the
Grid Editor Tool with a better chance of not distorting the
information; more on that later.

{pstd}
Some objects cannot by default be repositioned, but you can right-click on
many of these objects and select {bf:Unlock} {bf:Position} from the resulting
menu.  The object can then be repositioned by dragging.  If you want to relock
the object's position on the graph, just right-click on the object and select
{bf:Lock} {bf:Position}.  In the same way, you can lock the position of
objects that can normally be dragged.

{marker contextual_toolbar}{...}
{pstd}
When you select an object -- whether a title, axis, legend, scatterplot, line
plot, etc. -- you will notice that a toolbar appears (or changes)
immediately above the graph.  This is the Contextual Toolbar, with which 
you can immediately change the most important properties of the
selected object:  color, text size, or even text for titles and other text
objects; marker color, marker size, or marker symbol for scatterplots; etc.
Try it.  Select something in the graph and change one of the properties in the
Contextual Toolbar: the change is immediately reflected on the graph.

{pstd}
Only the most important properties are shown on the Contextual
Toolbar.  Most objects have many more settable properties.  You can see
and change all of an object's properties by selecting the {bf:More...} button
on the right of the Contextual Toolbar or by double-clicking on the object.
You will be presented with a dialog box with all of the object's properties.
Change one or more of those properties.  Then click on {bf:Apply} if you want to
see the changes on the graph and continue changing properties, or click on
{bf:OK} to apply the properties and dismiss the dialog box.  Click on
{bf:Cancel} to dismiss the dialog without applying any of the edits since you
last clicked on {bf:Apply}.

{pstd}
Almost anything that you can do to change the look of an object with the
{helpb graph} command, you can also do with the object's dialog box.

{pstd}
As with dragging, any changes made from the object toolbar or the dialog boxes
can be reversed by clicking on the {bf:Undo} button or by selecting
{bf:Edit > Undo} from the main menu.

{marker text_tool}{...}
{pstd}
{bf:Add Text Tool}

{pstd}
You add text by using the Add Text Tool in the Tools
Toolbar.  Select the Add Text Tool and then click anywhere in
your graph that you would like to add some text.  You will be presented with
the text dialog box.  Type your text in the {bf:Text} control.  You can change
how the text looks on the graph by changing the properties on the dialog, or
select the text later with the Pointer and make changes then.

{pstd}
If the text is not exactly where you want it, switch to the Pointer
and drag the text to the desired position.

{pstd}
As with text options in the {cmd:graph} command, you can create multiline
text by placing each line in quotation marks.  For example, 
{cmd:"The little red hen"} {cmd:"baked bread"} will appear as two lines of
text.  If you have text with embedded quotes, use compound quotes to bind the
line, for example, {cmd:`"She said to} {cmd:"use compound quotes"}
{cmd:in such cases"'}.

{pstd}
When you select the Add Text Tool, the Contextual
Toolbar shows the properties for the tool.  Any changes you make to the
properties on the toolbar will be recorded as new default
settings.  These new settings are then used on all added text.  In
fact, these settings are stored and will be used on added text whenever you
reopen the Graph Editor, either in your current Stata session or in
future Stata sessions.  When setting new default properties, you are not
limited to the settings available on the Contextual Toolbar; you can
also select the {bf:More...} button to bring up a dialog box with the complete
set of text properties.  Any changes made and saved there will also become new
defaults for adding text.  If you want to change back to the default settings
from when Stata was installed, select the {bf:Advanced} tab on the dialog and
click on {bf:Reset Defaults}.

{marker line_tool}{...}
{pstd}
{bf:Add Line Tool}

{pstd}
You add lines and arrows by using the Add Line Tool, which is
located below the Add Text Tool in the Tools Toolbar.
To add a line, click within the graph to establish a starting point, and hold
the left mouse button while dragging to the ending point.  The line's
path is shown as you drag, and the line is added when you release the left
button.  If you want an arrow rather than a line, click on the Pointer
Tool and then select whether you want the arrowhead at the beginning or at the
end of the line from the {bf:Arrowhead} control in the Contextual Toolbar.

{pstd}
After adding a line, you can use the Pointer to drag not only
the entire line but also either endpoint separately.

{pstd}
As with the Add Text Tool, you can change the default properties for added
lines by changing the settings in the Contextual Toolbar or associated dialog
box while the Add Line Tool is active.  As with the text settings, these
settings are retained until you change them again.

{pstd}
If you draw more arrows than lines, this may be the time to change your
default setting for the Add Line Tool.  Select the tool and then select
{bf:Head} in the {bf:Arrowhead} control of the Contextual Toolbar.  Now,
whenever you draw a line, an arrowhead will be drawn on the endpoint where you
release the mouse.

{marker marker_tool}{...}
{pstd}
{bf:Add Marker Tool}

{pstd}
You add markers by using the Add Marker Tool, which is located below the Add
Line Tool.  With the Add Marker Tool active, simply click anywhere you wish to
add a marker.  As with text and lines, you can change the marker's properties
immediately or later by using the Pointer Tool and the Contextual Toolbar or
the associated dialog box.

{pstd}
As with markers on plots, added markers can be labeled.  Double-click on an
added marker with the Pointer Tool (or select {bf:More...} from its Contextual
Toolbar) and use the controls on the {bf:Label} tab of the dialog box.

{pstd}
As with the other {it:Add...} tools, you can change any of the properties of
the default marker by changing settings in the Contextual
Toolbar or the associated dialog when the tool is in use.


{marker grid_edit_tool}{...}
{pstd}
{bf:Grid} {bf:Edit} {bf:Tool}

{pstd}
The final tool on the Tools Toolbar is the Grid Edit
Tool.  This is an advanced tool that moves objects within their
containing grid.  See 
{it:{help graph editor##grid_editing:Grid editing}}
for details; we mention it here only because it is part of the toolbar.

{marker object_browser}{...}
{title:The Object Browser}

{pstd}
To the right of the Graph window (unless you have moved it elsewhere or
turned it off) is the Object Browser, or just
Browser.  The Browser is for advanced use, but we mention it here
because it comes up when discussing some other tools and because there is not
much to say.  The Browser shows a hierarchical listing of all the
objects in your graph.  At the top of the hierarchy is the name of your graph,
and within that is typically a plot region ({bf:plotregion1}), the axes
({bf:yaxis1} and {bf:xaxis1}), the {bf:legend}, a {bf:note}, a {bf:caption}, a
{bf:subtitle}, a {bf:title}, and the {bf:positional titles}.  Some of these
objects contain other objects.  Most importantly, the plot region contains all
the plots, for example, {help twoway scatter:scatterplots}, 
{help twoway line:line plots}, and {help twoway area:area plots}.  These
plots are simply numbered 1 through {it:N}, where {it:N} is the number of
plots on your graph.  In addition to containing its own titles, the
{bf:legend} contains a {bf:key region} that holds the legend's components:
keys and labels.

{pstd}
Some graphs, such as {help graph bar:bar charts}, {help graph box:box plots},
{help graph dot:dot charts}, and {help graph pie:pie charts}, have slightly
different sets of objects.  {help graph combine:Combined graphs}, in addition
to their own set of titles, have a plot region that contains other graphs,
which themselves nest all the objects listed earlier.  
{help by options:By-graphs} are particularly messy in the Browser
because they are constructed with many of their objects hidden.  Showing these
objects rarely leads to anything interesting.

{pstd}
Although you may be able to largely ignore the Browser, it has several
features that are helpful.

{pstd}
First, if two or more objects occupy the same space on the graph, you will be
able to select only the topmost object.  You would have to move the upper
objects to reach a lower object.  With the Browser, you can directly
select any object, even one that is hidden by another object.  Just select the
object's name in the Browser.  That object will stay selected for dragging or
property changes through the Contextual Toolbar or associated
dialog.

{pstd}
Second, the Browser is the quickest way to add titles, notes, or captions
to a graph.  Just select one of them in the Browser and then type your title,
note, or caption in the {bf:Text} control of the Contextual Toolbar.

{pstd} As you select objects with the
Pointer, those objects are also selected and highlighted in the
Browser.  The reverse is also true: as you select objects in the
Browser, they will also be selected on the graph and their Contextual
Toolbar will be displayed.  There is no difference between selecting
objects by name in the Browser and selecting them directly on the graph
with the Pointer.  In fact, you can right-click on an object in
the Browser to access its properties.

{pstd}
If you find the Browser more of a distraction than a help, select
{bind:{bf:Tools > Hide Object Browser}} from the main menu.  You can always
reshow the Browser from the same place.


{marker contextual_menus}{...}
{title:Right-click menus, or Contextual menus}

{pstd}
You can right-click on any object to see a list of operations 
specific to the object and tool you are working with.  This feature is most
useful with the Pointer Tool.  For almost all objects, you will be offered the
following operations:

{synoptset 15}{...}
{synopt:{bf:Hide}}Hide an object that is currently shown.  This will 
		 also gray the object in the Browser.{p_end}
{synopt:{bf:Show}}Show an object that is currently hidden. 
                  Available only when selecting grayed objects in 
		  the Browser.

{synopt:{bf:Lock}}Lock the object, making it unselectable and unchangeable
			by the Pointer.  When you lock an object, a lock
			icon will appear beside the object in the Browser. 
			This is another way to select an object that is 
			underneath another object.  Lock the upper object and 
			you will be able to select the lower object.{p_end}
{synopt:{bf:Unlock}}Unlock the object, making it selectable and its
			properties changeable. Available only when selecting
			locked objects in the Browser.

{synopt:{it:xyz} {bf:Properties}}Open the properties dialog box for object
                                {it:xyz}.  The same dialog is opened by
                                double-clicking on an object or clicking on the
                                {bf:More...} button from its Contextual
                                Toolbar.


{pstd}
When you have selected an object that can be repositioned, you will also see
the following:


{synopt:{bf:Lock Position}}Lock the position of an object so that it cannot be
			dragged to a different position.  This type of lock
			is not reflected in the Browser.{p_end}
{synopt:{bf:Unlock Position}}Unlock the position of an object so that it may be
			dragged to a different position by using the Pointer.
                        Some objects are created with their position
                        locked by default to avoid accidental dragging, but
                        many may be manually unlocked with this menu item.

{pstd}
When you select a plot where individual observations are visible -- 
for example, 
{help twoway scatter:scatterplots}, {help twoway connected:connected plots},
{help twoway spike:spike plots}, {help twoway rbar:range bar plots},
{help twoway pcarrow:arrow plots} -- you will also see

{synoptset 25}{...}
{synopt:{bf:Observation Properties}}Change the properties of the currently
                                selected observation without affecting the
                                rendition of the remaining plot.  You can
                                further customize the observation later by
                                reselecting it with the Pointer.  Once
                                changed, the observation's custom properties
                                become available in the Contextual
                                Toolbar and properties dialog box.

{pstd}
When you select an axis, you will also see the following:


{synopt:{bf:Add Tick/Label}}Add a tick, label, or tick and label to the
				selected axis.

{synopt:{bf:Tick/Label Properties}}Change the properties of the
				tick or label closest to your current
                                Pointer position.  This is a quicker way
                                to customize a tick or label than navigating
                                to it through the 
				{bf:Edit or add individual ticks and labels} 
				button in the axis
                                properties dialog box.

{pstd}
Many objects with shared properties -- such as plots and labels on a 
{help graph matrix:scatterplot matrix}, bars and labels on a 
{help graph bar:bar chart}, and pie slices and labels on a 
{help graph pie:pie chart} -- will also add

{synopt:{bf:Object-specific Properties}}Change the properties of only the 
                        selected object, not all the objects that by
                        default share its properties.

{pstd}
With {bf:Object-specific Properties}, you can customize one bar, label, or
other object that you would normally want to look the same as related objects.

{pstd}
Many of the operations come in pairs, such as {bind:{bf:Hide}/{bf:Show}}.  You
are offered only the appropriate operations, for example, to {bf:Hide} a shown
object or to {bf:Show} a hidden object.


{marker standard_toolbar}{...}
{title:The Standard Toolbar}

{pstd}
The Standard Toolbar normally resides at the top of the Graph window (just
below the main menu on Unix and Windows systems).  In addition to standard
operations -- such as {bf:Open} {bf:Graph}, {bf:Save} {bf:Graph}, and {bf:Print}
{bf:Graph} -- there are several graph and Graph Editor-specific operations
available.  You can {bf:Rename} graphs, {bf:Start}/{bf:Stop}
{bf:Graph} {bf:Editor}, {bf:Show} or {bf:Hide} {bf:Object} {bf:Browser},
{bf:Deselect} the selected object, {bf:Undo} or {bf:Redo} edits, 
{help graph editor##recorder:{bf:Record}} edits, and {bf:Play} previously
recorded edits.

{pstd}
You can undo and redo up to 300 consecutive edits.

{marker main_menu}{...}
{title:The main Graph Editor menu}

{pstd}
On Unix and Windows systems, the Graph Editor menus reside on the menubar at
the top of the Graph window.  Menu locations on the Mac are a little different
than on other operating systems.  On the Mac, all the menus referenced
throughout this documentation except {bf:File}, {bf:Edit}, and {bf:Help} are
located under the {bf:Graph Editor} menu.  In addition, items found under
the {bf:Tools} menu on Windows and Unix systems are found under the
{bf:Graph Editor} menu on the Mac.

{synoptset 7}{...}
{synopt:{bf:File}}In addition to opening, closing, saving, and printing
        graphs, you can start and stop the Graph Editor from this
        menu.  The {bind:{bf:Save as...}} menu not only saves graphs in
        Stata's standard "live" format, which allows future editing in the
        Graph Editor, but also exports graphs in formats commonly
        used by other applications:  PostScript, Encapsulated PostScript
        (EPS), TIFF, and Portable Network Graphics (PNG) on all computers;
        Windows Metafile (WMF) and Windows Enhanced Metafile (EMF) on
        Microsoft Windows computers; and Portable Document Format
	(PDF) on Mac computers.

{synopt:{bf:Object}}Mirrors the operations available in the right-click
        menu for an object, with two additions:  1) you can unlock all objects
        by using {bf:Object > Unlock All Objects} and 2) you can deselect a
        selected object by using {bf:Object > Deselect}.
        On the Mac, this menu is located under the {bf:Graph Editor} menu.

{synopt:{bf:Graph}}Launches the dialog boxes for changing the properties
        of the objects that are common to most graphs (titles, axes, legends,
        etc.).  You can also launch these dialogs by double-clicking on an
        object in the graph, by double-clicking on the object's name in the
        Object Browser, by selecting {bf:Properties} from the object's
        right-click menu, or by clicking on {bf:More...} in the object's
        Contextual Toolbar.
        On the Mac, this menu is located under the {bf:Graph Editor} menu.

{synopt:{bf:Tools}}Selects the tool for editing:  {bf:Pointer}, {bf:Add}
        {bf:Text}, {bf:Add} {bf:Line}, {bf:Add} {bf:Marker}, {bf:Grid}
        {bf:Edit}.  These can also be selected from the Tools
        Toolbar.  Under {bf:Tools}, you can also control the 
        {help graph editor##recorder:Graph Recorder}.  From here you can also
        hide and show the Object Browser.  On the Mac, this menu
	is named {bf:Graph Editor} and also contains the {bf:Object} and
	{bf:Graph} menus.

{synopt:{bf:Help}}Provides access to this documentation, 
        {bind:{bf:Help > Graph Editor}}; advice on using Stata,
        {bind:{bf:Help > Advice}}; a topical overview of Stata's commands,
        {bind:{bf:Help > Contents}}; searching, {bind:{bf:Help > Search...}};
	and help on specific commands, {bind:{bf:Help > Stata command...}}.


{marker grid_editing}{...}
{title:Grid editing}

{pstd}
Click on the Grid Edit Tool to begin grid editing.  When you drag objects with
this tool, you are rearranging them on the underlying grid where {cmd:graph}
placed them.  

{pstd}
When you select an object, it will be highlighted in red and the
grid that contains the object will be shown.  You can drag the object to other
cells in that grid or to new cells that will be created between the existing
cells.  As you drag an object to other cells, those cells will appear darker
red.  If you drop the object on a darker red cell, you are placing it in that
cell along with any objects already in the cell.  As you drag over cell
boundaries, the boundary will appear darker red.  If you drop the object on a
cell boundary, a new row or column is inserted into the grid and the object is
dropped into a cell in this new row or column.

{pstd}
Regardless of whether you drag the object to an existing cell or to a new cell,
the other objects in the graph expand or contract to make room for the object
in its new position.

{pstd}
This concept sounds more difficult than it is in practice.  Draw a graph and
try it.

{pstd}
Some graphs, such as {help by option:by-graphs} and 
{help graph combine:combined graphs}, are composed of nested grids.  You can
drag objects only within the grid that contains them; you cannot drag them to
other grids.

{pstd}
One of the more useful things you can do when grid editing is to drag a title
or legend to a new position on the graph.  See 
{it:{help graph editor##tips_tricks:Tips, tricks, and quick edits}} for more
examples.

{pstd}
You can also expand or contract the number of cells that the selected object
occupies by using the Contextual Toolbar.  Most objects occupy only one 
cell by default, but there are exceptions.  If you specify the {cmd:span}
option on a title, the title will occupy all the columns in its row; see
{manhelpi title_options G-3}.  To make an object occupy more or fewer cells,
click on {bf:Expand Cell} or {bf:Contract Cell} in the Contextual Toolbar
and then select the desired direction to expand or contract.

{pstd}
You can use the Object Browser to select objects when grid editing.  With the
Browser, you can individually select among objects that occupy the same cell.
Selecting in the Browser is often easier for objects like legends, which are
themselves a grid.  In the graph, you must click on the edge of the legend to
select the whole legend and not just one of its cells.  If you have difficulty
selecting such objects in the graph, pick their name in the Object
Browser instead.

{marker recorder}{...}
{title:Graph Recorder}

{pstd}
You can record your edits and play them back on other graphs using the Graph
Recorder.  To start recording your edits, click on the {bf:Start} {bf:Recording}
button in the Standard Toolbar.  All ensuing edits are
saved as a recording.  To end a recording, click on the same 
button; you will be prompted to name your recording.
The recorded edits can be replayed on other graphs.

{pstd}
To play the edits from a recording, click on the {bf:Play} {bf:Recording}
button.  You will be presented with a list of your
recordings.  Select the recording you want to play, and the edits will be
applied to your current graph.

{pstd}
You can also play recordings from the command line.  Play a recording on the
current graph using the {cmd:graph play} command; see
{manhelp graph_play G-2:graph play}.  Play a recording as a graph is being used
from disk; see {manhelp graph_use G-2:graph use}.  Or, play a recording by
using the {cmd:play()} option at the time a graph is created; see
{manhelpi std_options G-3}.

{pstd}
Some edits from a recording may not make sense when applied to another
graph, for example, changes to a plotted line's color when played on a
scatterplot.  Such edits are ignored when a recording is played, though a note
is written to the Results window for any edits that cannot be applied to the
current graph.

{pstd}
If you want to make some edits that are not saved in the recording, select the
{bf:Pause} {bf:Recording} button.  Make any edits you do not want
recorded.  When you are ready to record more edits, click again on the
{bf:Pause} {bf:Recording} button.

{pstd}
You cannot {bf:Undo} or {bf:Redo} edits while recording.  If you set a
property and do not like the result, simply reset the property.  If you add an
object (such as a line) incorrectly, delete the added object.


{it:Technical note -- where are recordings stored?} 

{pstd}
By default, all recordings are stored in the grec subdirectory of your PERSONAL
directory.  (See {helpb sysdir} for information about your PERSONAL directory.)
The
files are stored with a .grec extension and are text files that can be opened
in any standard editor, including Stata's Do-file Editor.  They are not,
however, meant to be edited.  To remove a recording from the list of
recordings shown when the {bf:Play} {bf:Recording} button is
clicked, remove it from this directory.

{pstd}
Most recordings are meant to be used across many graph files and so belong in
the standard place.  You may, however, make some recordings that are specific
to one project, so you do not want them shown in the list presented by {bf:Play}
{bf:Recording} button.  If you want to save a recording with a
project, just browse to that location when you are prompted to save the
recording.  Recordings stored this way will not be listed when you select 
{bf:Play} {bf:Recording}.  To play these recordings, select Browse from the
list, change to the directory where you stored the recording, and open the
recording.  Your recording will be played and its edits applied.


{marker tips_tricks}{...}
{title:Tips, tricks, and quick edits}

{pstd}
Because you can change anything on the graph by using the Editor and because
many of these changes can be done from the
{help graph editor##tools:Contextual Toolbar}, there is no end to the tips,
tricks, and especially quick edits we might discuss.  Here are a few to get
you started.

	{help graph editor##save:Save your graph to disk}
	{help graph editor##bigger:Make your Graph Editor bigger}
	{help graph editor##apply:Use the Apply button on dialogs}
	{help graph editor##scatter2line:Change a scatterplot to a line plot}
	{help graph editor##grid_lines:Add vertical grid lines}
	{help graph editor##justify_title:Left-justify a centered title}
	{help graph editor##reset:Reset rather than Undo}
	{help graph editor##relative:Think relative}
	{help graph editor##refline:Add a reference line}
	{help graph editor##axis_grid:Move the y axis to the right of the graph}
	{help graph editor##legend_plreg:Move the legend into the plot region}
	{help graph editor##aspect:Change the aspect ratio of a graph}
	{help graph editor##recorder_scheme:Use the Graph Recorder to create a custom look for graphs}
	{help graph editor##rotate:Rotate a bar graph}

{pstd}
When you try these tips, remember that while the Graph Editor is open you
cannot execute Stata commands.  Exit the Editor to enter and run commands.

{marker save}{...}
{phang}
{it:Save your graph to disk.} It is a simple and obvious suggestion, but
	people with years of experience using only Stata's command-line
	graphics might lose precious work in the Graph Editor if they do not
	save the edited graph.  However, Stata will prompt you when you
	leave the Graph Editor to save any graph that has been changed. 

{pmore}
        You can draw a graph, edit it, save it to disk, restore it in a later
        Stata session, and continue editing it.

{marker bigger}{...}
{phang}
{it:Make your Graph Editor bigger.}  Stata recalls the size of Graph windows
        and the size of the Graph Editor window separately, so you can have a
        larger window for editing graphs.  It is easier to edit graphs if you
        have more room to maneuver, and they will return to their normal size
        when you exit the Editor.

{marker apply}{...}
{phang}
{it:Use the Apply button on dialogs.}  If you are unsure of 
        a change you are considering, you want to continue making changes
        using a dialog, or you just want to see what something does, click on
        the {bf:Apply} button rather than the {bf:OK} button on a dialog.  The
        {bf:Apply} button does not dismiss the dialog, so it is easy to change
        a setting back or make other changes.

{marker scatter2line}{...}
{phang}
{it:Change a scatterplot to a line plot.}  This one is truly easy, but we
        want you to explore the {help graph editor##tools:Contextual Toolbar},
        and this might be an enticement.{p_end}

{pmore}If you do not have a scatterplot handy, use one of
	U.S. life expectancy versus year,{p_end}

                {cmd:. sysuse uslifeexp}
	        {cmd:. scatter le year}
	        {it:({stata "gr_example uslifeexp: scatter le year":click to run})}

{pmore}and start the Graph Editor.{p_end}

{phang2}1.  Select the scatterplot by clicking on any of its markers.{p_end}
{phang2}2.  Select {bf:Line} from the {bf:Plottype} control in the Contextual
		Toolbar.{p_end}

{pmore}That's it!

{pmore}This method works for all plottypes that use the same number of
variables.  Scatters, lines, connecteds, areas, bars, spikes, and droplines
can all be interchanged.  So can the range plots:  rareas, rbars, rspikes,
rcapsyms, rscatters, rlines, and rconnecteds. So, too, can the
paired-coordinate plots: pcspikes, pccapsyms, pcarrows, pcbarrows, and
pcscatters.  See {manhelp twoway G-2:graph twoway} for a description of all the
plottypes.

{marker grid_lines}{...}
{phang}
{it:Add vertical grid lines.}  This one is easy too, but we really do want you 
        to explore the {help graph editor##tools:Contextual Toolbar}.
        Most graph {help schemes} show horizontal grid lines aligned with each
        tick on the y axis, but they do not show vertical grid lines.  To add
	vertical grid lines,{p_end}

{phang2}1.  Select the Pointer Tool and then click on the x axis.{p_end}
{phang2}2.  Click in the {bf:Show} {bf:Grid} button (or checkbox under Mac
and Windows) in the Contextual Toolbar.{p_end}

{pmore}That's it!

{marker justify_title}{...}
{phang}
{it:Left-justify a centered title}.  If your graph does not have a title, click
	on {bf:title} in the {help graph editor##object_browser:Object Browser}
	and add a title by typing in the {bf:Text} field of the Contextual
	Toolbar (press {it:Enter} to see the title).{p_end}

{phang2}1.  Select the Pointer Tool and then click on the title.{p_end}
{phang2}2.  Look for a control that justifies the title on the Contextual 
	    Toolbar.  There is not one.  We need more control than the toolbar
	    offers.{p_end}
{phang2}3.  Click on {bf:More...} in the Contextual Toolbar to launch
	    the dialog that controls all title properties.{p_end}
{phang2}4.  Click on the {bf:Format} tab in the dialog, and then select
            {bf:West} from the {bf:Position} control and click on the {bf:Apply}
	    button.{p_end}

{pmore}That's it!

{pmore}This might be a good time to explore the other tabs and controls on the
        {bf:Textbox} {bf:Properties} dialog.  This is the dialog available for
	almost all the text appearing on a graph, including any that you
	add with the Add Text Tool.

{marker reset}{...}
{phang}
{it:Reset rather than Undo.}  If you are using the
	{help graph editor##tools:Contextual Toolbar} or a dialog to change
	the properties of an object and you want to reverse a change you have
	just made, simply change the setting back rather than clicking on the
	{bf:Undo} button.  {bf:Undo} must completely re-create the graph, which
        takes longer than resetting a property.

{marker relative}{...}
{phang}
{it:Think relative.}  On dialogs, you can often enter anything in a control
        that you could enter in the option for the associated style or property.
        For example, in a size or thickness control, in addition to selecting
        a named size, you could specify a percentage of graph height, or you
	could enter a multiple like {cmd:*.5} to make the object half its
	current size or {cmd:*2} to make it twice its current size. 
{* This even works for colors, you can enter *.5 to make a green object half as green.}

{marker refline}{...}
{phang}
{it:Add a reference line}.  Reference lines are often added to emphasize a
	particular value on one of the axes, for example, the beginning of a
	recession or the onset of a disease.  With the Add Line Tool, you
	could simply draw a vertical or horizontal line at the desired
	position, but this method is imprecise.  Instead,{p_end}

{phang2}1.  Using the Pointer Tool, double-click on the x axis.{p_end}
{phang2}2.  Click on the {bf:Reference} {bf:line} button.{p_end}
{phang2}3.  Enter the x value where the reference line is to be drawn and
		click on {bf:OK}.{p_end}

{pmore}That's it!

{marker axis_grid}{...}
{phang}
{it:Move your y axis to the right of the graph.}{p_end}

{phang2}1.  Click on the Grid Edit Tool.{p_end}
{phang2}2.  Drag the axis to the right until the right boundary of the
		plot region glows red, and then release the mouse button.
        The plot region is in the right spot, but the ticks and labels are still
	on the wrong side.{p_end}
{phang2}3.  Right-click on the axis and select 
	{bind:{bf:Axis Properties}}.{p_end}
{phang2}4.  Click on the {bf:Advanced} button, and then select {bf:Right} from
        the {bf:Position} control in the resulting dialog.{p_end}

{pmore}That's it!


{marker legend_plreg}{...}
{phang}
{it:Move the legend into the plot region}.  If you do not have a graph with a
	legend handy, consider this line plot of female and male life
	expectancies in the United States.{p_end}

                {cmd:. sysuse uslifeexp}
	        {cmd:. scatter le_female le_male year}
	        {it:({stata "gr_example uslifeexp: scatter le_female le_male year":click to run})}

{pmore}You could just use the Pointer to drag the legend into the plot region,
        but doing so would leave unwanted space at the bottom of the graph where
        the legend formerly appeared.  Instead, use the Grid Edit Tool
	to place the legend atop the plot region, and then use the Pointer to
	fine-tune the position of the legend.{p_end}

{phang2}1.  Click on the Grid Edit Tool.{p_end}
{phang2}2.  Drag the legend over the plot region.  (The plot region should
		appear highlighted before you release the mouse button.)  If 
		you have trouble selecting the whole legend, click on its 
		name in the Object Browser, and then drag it over the 
		plot region.{p_end}
{phang2}3.  Position the legend exactly where you want it by selecting the
		Pointer and dragging the legend.{p_end}

{pmore}That's it!

{pmore}If you are using the line plot of life expectancies, you will find
	that there is no good place in the plot region for the wide and 
	short default legend.  To remedy, just change the number of
	columns in the legend from 2 to 1 by using the {bf:Columns} control in
	the legend's Contextual Toolbar.  With its new shape, the legend now
	fits nicely into several locations in the plot region.

{marker aspect}{...}
{phang}
{it:Change the aspect ratio of a graph.}  Some graphs are easier to interpret 
        when the y and x axes are the same length; that is, the graph
        has an aspect ratio of 1.  We might check the normality of a variable,
	say, trade volume stock shares in the S&P 500, by using
	{helpb qnorm}.{p_end}

                {cmd:. sysuse sp500}
	        {cmd:. qnorm volume}
	        {it:({stata "gr_example sp500: qnorm volume":click to run})}

{pmore}
	The {cmd:qnorm} command does not by default restrict the plot region
	to an aspect ratio of 1, though arguably it should.  We can fix that.
	Start the Editor and

{phang2}1.  Click on {bf:Graph} in the Object Browser.
        We could click directly on the graph, but doing so requires missing
        all the objects on the graph, so using the Browser is easier.{p_end}
{phang2}2.  Type {bf:1} in the {bf:Aspect} {bf:ratio} field of the Contextual
		Toolbar and press {it:Enter}.{p_end}

{pmore}That's it!

{marker recorder_scheme}
{phang}
{it:Use the Graph Recorder to create a custom look for graphs.} 
If you want your graphs to have a particular appearance, such as 
specific colors for each plotted line or the legend being to the right of
the plot region, you can automate this process by using the 
{help graph editor##recorder:Graph Recorder}.

{pmore}
The specific steps for creating the recording depend on the look you want to
achieve.  Here is a general outline.

{phang2}1.  Create the type of graph you want to customize -- scatterplot,
line plot, pie graph, etc.  Be sure you draw as many plots as you will ever
want to draw on a graph of this type, and also be sure to include all the
other plot elements you wish to customize -- titles, notes, etc.  For a
line plot, you might type

                {cmd:. sysuse uslifeexp, clear}
                {cmd:. line le* year, title(my title) subtitle(my subtitle) }
                {cmd:       note(my note) caption(my caption)}

{pmore2}Because there are nine variables beginning with {cmd:le}, this will
create
a line plot with nine lines -- probably more than you need.  The graph will also
have all the basic plot elements.

{phang2}2.  Start the Graph Editor.  Then start the Recorder by clicking on the
{bf:Start} {bf:Recording} button in the Standard Toolbar.

{phang2}3.  Use the Editor to make the graph look the way you want line graphs
to look.

{phang3}o{space 3}Change the color, thickness, or pattern of the first line by
selecting the line and using the 
{help graph editor##tools:Contextual Toolbar} or any of the
options available from the
{help graph editor##contextual_menus:Contextual menus}.

{pmore3}Repeat this for every line you want to change.

{pmore3}With so many lines, you may find it easier to select lines in the
legend, rather than in the plot region.

{phang3}o{space 3}Change the size, color, etc., of titles and captions.

{phang3}o{space 3}Change the orientation of axis tick labels, or even change the
suggested number of ticks.

{phang3}o{space 3}Change the background color of the graph or plot region.

{phang3}o{space 3}Move titles, legends, etc., to other locations -- for
example, move the legend to the right of the plot region.  This is usually
best done with the {help graph editor##grid_editing:Grid Edit Tool}, which
allows the other graph elements to adjust to the repositioning.

{phang3}o{space 3}Make any other changes you wish using any of the tools in
the Graph Editor.

{phang2}4.  End the Recorder by clicking on the {bf:Recording}
button again, and give the recording a name -- say, {cmd:mylineplot}.

{phang2}5.  Apply the recorded edits to any other line graph either by using the
{bf:Play} {bf:Recording} button on the Graph Editor or by using one
of the methods for playing a recording from the command line:
{helpb graph play} or {helpb play_option:play()}.

{pmore}If you wish to change the look of plots -- markers, lines, bars,
pie slices, etc. -- you must create a separate recording for each graph family
or plottype.  You need separate recordings because changes to one plottype do
not affect other plottypes.  That is, changing markers does not affect
lines.  If you wish to change only overall graph features -- background
colors, titles, legend position, etc. -- you can make one recording and play it
back on any type of graph.

{pmore}For a more general way to control how graphs look, you can
create your own scheme (see {manhelp schemes G-4:Schemes intro}).  Creating
schemes, however, requires some comfort with editing control files and a
tolerance for reading through the hundreds of settings available from schemes.
See {help scheme files} for details on how to create your own scheme.

{pmore}Note:  We said in step 1 that you should include titles,
notes, and other graph elements when creating the graph to edit.  Creating
these elements makes things easier but is usually not required.  Common graph
elements always appear in the 
{help graph editor##object_browser:Object Browser}, even if they have no text
or other contents to show on the graph; you can select them in the
Browser and change their properties, even though they do not appear on the
graph.  Such invisible elements will still be difficult to manipulate with the
{help graph editor##grid_editing:Grid Edit Tool}.  If you 
need an invisible object to relocate, click on the {bf:Pause} {bf:Recording}
button, add the object, unpause the recording, and then continue with your
edits.


{marker rotate}{...}
{phang}
{it:Rotate a bar graph.}  You can rotate the over-groups of a 
	{help graph bar:bar}, {help graph dot:dot}, or 
	{help graph box:box} chart.  This is easier to see than to 
	explain.  Let's create a bar graph of wages over three different sets of
	categories.{p_end}

                {cmd:. sysuse nlsw88}
	        {cmd:. graph bar wage, over(race) over(collgrad) over(union)}
	        {it:({stata "gr_example nlsw88: graph bar wage, over(race) over(collgrad) over(union)":click to run})}

{pmore}Start the Graph Editor.

{phang2}1.  Using the Pointer, click within the plot region, but not on any of
        the bars.{p_end}
{phang2}2.  Click on the {bf:Rotate} button in the Contextual Toolbar.{p_end}
{phang2}3.  Click on {bf:Rotate} a few more times, watching what happens on the
		graph.{p_end}

{pmore}
To see some other interesting things, click on the {bf:More...} button.  In
the resulting dialog, check {bf:Stack bars} and click on {bf:Apply}.  Then check
{bf:Graph percentages} and click on {bf:Apply}.  

{pmore}
During rotation, sometimes the labels on the x axis did not fit.  Select the
{bf:Horizontal} radio button in the dialog and click on {bf:Apply} to flip the
bar graph to horizontal, and then repeat the rotation.  Bar graphs requiring
long labels typically work better when drawn horizontally.


{marker tech_notes}{...}
{title:Technical note}

{pstd}
When the Add Text Tool, Add Line Tool, and Add Marker Tool add things to a
graph, the new object can be added to a plot region, a
subgraph, or the graph as a whole.  They will be added to the plot
region if the starting point for the added object is within a
plot region.  The same is true of subgraphs.  Otherwise, the new
objects will be added to the overall graph.

{pstd}
Why do you care?  When a line, for example, is added to a graph, its
endpoints are recorded on the generic metric of the graph, whereas
when a line is added to a plot region, the endpoints are recorded in the metric
of the x and y axes.  That is, in the plot region of a graph of
{cmd:mpg} versus {cmd:weight}, the endpoints are recorded in "miles per
gallon" and "curb weight".  If you later change the range of
the graph's axes, your line's endpoints will still be at the same
values of {cmd:mpg} and {cmd:weight}.  This is almost always what you
want.

{pstd}
If you prefer your added object to not scale with changes in the axes,
add it outside the plot region.  If you still want it on the
plot region, drag it into the plot region after adding it outside
the region.

{pstd}
If your x or y axis is on a log scale, you may be surprised at how
lines added to the plot region react when drawn.  When you are dragging the
endpoints, all will be fine.  When you drag the line as a whole,
however, the line will change its length and angle.  This happens
because dimensions in a log metric are not linear and dragging the
line affects each endpoint differently.  The Graph Editor is
not smart enough to track this nonlinearity, and the actual position of
the line appears only after you drop it.  We recommend that you
drag only the endpoints of lines added to plot regions whose 
dimensions are on a log scale.
{p_end}


{marker video}{...}
{title:Video example}

{phang2}{browse "https://www.youtube.com/watch?v=17opC4fDeME":Modifying graphs using the Graph Editor}
{p_end}
