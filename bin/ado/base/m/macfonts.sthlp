{smcl}
{* *! version 1.1.1  11feb2011}{...}
{findalias asgsmfonts}{...}
{viewerjumpto "Changing and saving fonts and positions of your windows" "macfonts##fonts"}{...}
{viewerjumpto "Changing color schemes" "macfonts##schemes"}{...}
{viewerjumpto "Managing your preferences" "macfonts##prefs"}{...}
{viewerjumpto "Closing and opening windows" "macfonts##close_open"}{...}
{title:Title}

    {findalias gsmfonts} 


{marker fonts}{...}
{title:Changing and saving fonts and positions of your windows}

{p 4 4 2}
You can change font size in the following windows:

	{hi:Results}
	{hi:Viewer}
	{hi:Command}
	{hi:Data Editor}
	{hi:Do-file Editor}


{p 4 4 2}
To change the font size for a window:

{p 8 12 2}1.  Right-click on the window and open the {cmd:Font Size} menu.{p_end}
{p 8 12 2}2.  Select the font size.


{marker schemes}{...}
{title:Changing color schemes}

{p 4 4 2}
To change the color scheme of the {hi:Results} window:

{p 8 12 2}1.  Right-click on the Results window and select {cmd:Preferences...}{p_end}
{p 8 12 2}2.  Select the desired scheme from the {cmd:Color scheme} list.

    or

{p 8 12 2}1.  Create your own by selecting Custom 1 from the {cmd:Color scheme}
		list.{p_end}
{p 8 12 2}2.  Click the various output level buttons and select the desired
		color.{p_end}
{p 8 12 2}3.  Check the {cmd:bold} and {cmd:underline} boxes if desired.


{p 4 4 2}
To change the color scheme of the {hi:Viewer}:

{p 8 12 2}1.  Right-click on the Viewer window and select {cmd:Preferences...}{p_end}
{p 8 12 2}3.  Select the desired scheme from the {cmd:Color scheme} list.

    or

{p 8 12 2}1.  Create your own by selecting Custom 1 from the {cmd:Color scheme}
		list.{p_end}
{p 8 12 2}2.  Click the various output level buttons and select the desired
		color.{p_end}
{p 8 12 2}3.  Check the {cmd:bold} and {cmd:underline} boxes if desired.


{marker prefs}{...}
{title:Managing your preferences}

{p 4 4 2}
Your font sizes, graph settings, and window layout will be automatically saved
at the end of your Stata session.  The next time Stata comes up, it will come
up exactly as you left it.  You can also have multiple sets of saved
preferences.


{p 4 4 2}
To save your font, graph, and window preferences:

{p 8 12 2}1.  Select {cmd:Preferences > Manage Preferences > Save Preferences...} from the Stata menu.{p_end}
{p 8 12 2}2.  Enter a {it:preference_name}.


{p 4 4 2}
To load a saved preference:

{p 8 8 2}Select {cmd:Preferences > Manage Preferences > Load Preferences > }{it:preference_name} from the Stata menu.


{p 4 4 2}
To restore the factory settings for all of Stata's preferences:

{p 8 8 2}
Select {cmd:Preferences > Manage Preferences > Load Preferences > Factory Settings} from the Stata menu.


{p 4 4 2}
To restore the factory settings for just the font sizes, colors, and
window layout:

{p 8 8 2}
Select {cmd:Preferences > Manage Preferences > Load Preferences > Factory Window Settings} from the Stata menu.


{marker close_open}{...}
{title:Closing and opening windows}

{p 4 4 2}
You can close any window except the {hi:Command} window and the {hi:Results}
window.


{p 4 4 2}
If you want to open a closed window or bring a hidden one to the top:

{p 8 8 2}Select the desired window from the {cmd:Window} menu.


{p 4 4 2}
There are also buttons to bring the {hi:Graph}, {hi:Results}, {hi:Data Editor},
{hi:Do-file Editor}, and {hi:Viewer} windows to the top.
{p_end}
