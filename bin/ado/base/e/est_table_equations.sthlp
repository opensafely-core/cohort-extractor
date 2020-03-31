{smcl}
{* *! version 1.0.4  09jul2013}{...}
{vieweralsosee "[R] estimates" "help estimates"}{...}
Help on specifying {cmd:equations} for {cmd:estimates table}
{hline}

{pstd}
A single number # matches equation # in all models.  Separate multiple
terms with a comma ({cmd:,}).

    {hline -2}
{p 4 20 2}
{cmd:1} {space 13} matches the first equation in all models
into {cmd:#1}, matches other equations by name.  The dialog
box provides a radio button for this common special case.
{p_end}

{p 4 20 2}
{cmd:2} {space 13} matches the second equation in all models
into {cmd:#1} (not {cmd:#2}), matches other equations by name
{p_end}

{p 4 20 2}
{cmd:1,2} {space 11} matches the first equation in all models into {cmd:#1},
matches the second equation in all models into {cmd:#2}, matches other
equations by name
{p_end}
    {hline -2}


{pstd}
You can add names to the matched equations.  Beware: names you specify should
not be existing equation names in the models.

    {hline -2}
{p 4 20 2}
{cmd:mean = 1} {space 6} matches the first equation in all models
into {cmd:mean}, matches other equations by name
{p_end}

{p 4 20 2}
{cmd:mean=1, var=2} {space 1} matches the first equation in all models
into {cmd:mean}, matches the second equation in all models into {cmd:var},
matches other equations by name
{p_end}
    {hline -2}


{pstd}
You may also specify equation numbers for each model, divided optionally by a
colon ({cmd::}).  The examples below assume you are making a table for three
models.

    {hline -2}
{p 4 20 2}
{cmd:1:2:3} {space 9} matches equation 1 in model 1 with equation 2 in model 2
and equation 3 in model 3 into one {cmd:#1}, matching all other equations
by name.
{p_end}

{p 4 20 2}
{cmd:1:1:1} {space 9} matches equation 1 in all three models. As shown above,
you may also type a single {cmd:1}.
{p_end}

{p 4 20 2}
{cmd:lp = 1:.:2} {space 4} matches equation 1 in model 1 and equation 2
in model 3 into equation {cmd:lp}; no equation from model 2 is matched
into {cmd:lp}.  Again, other equations are matched by name.
{p_end}
    {hline -2}


{pstd}
And you can write complicated matching patterns, combining all of these
constructs, if you really need them:

    {hline -2}
    {cmd:one = 1, two = 2:.:2, three = .:3:3, four = 4}
    {hline -2}
