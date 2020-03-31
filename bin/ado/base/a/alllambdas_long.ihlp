{* *! version 1.0.0  22jun2019}{...}
{phang2}
{cmd:alllambdas} specifies that models be fit for all lambdas in the grid or
until the {opt stop(#)} tolerance is reached.  By default, models are
calculated sequentially from largest to smallest lambda, and the CV function
is calculated after each model is fit.  If a minimum of the CV function is
found, the computation ends at that point without evaluating additional
smaller lambdas.

{pmore2}
{cmd:alllambdas} computes models for these additional smaller lambdas.
Because computation time is greater for smaller lambda, specifying
{cmd:alllambdas} may increase computation time manyfold.  Specifying
{cmd:alllambdas} is typically done only when a full plot of the CV function is
wanted for assurance that a true minimum has been found.  Regardless of
whether {cmd:alllambdas} is specified, the selected lambda* will be the same.
