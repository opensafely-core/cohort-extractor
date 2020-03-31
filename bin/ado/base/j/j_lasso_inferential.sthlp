{smcl}
{* *! version 1.0.0  24jun2019}{...}
{vieweralsosee "[LASSO] Inference requirements" "mansection LASSO Inferencerequirements"}{...}
{title:Requirements for inference}

{pstd}
The {cmd:ds}, {cmd:po}, and {cmd:xpo} commands, like other estimation
procedures, require certain conditions be met so that their inferential
results are valid.  In addition, the plugin and CV selection methods have
distinct properties and may perform differently under some conditions.


{title:Remarks}

{pstd}
We assume you have read {manlink LASSO Lasso inference intro}.

{pstd}
We fit a model with, for example, {cmd:dsregress} with the default plugin
selection method, and then we refit the model using CV.  We get slightly
different results.  Which is correct?

{pstd}
Plugin and CV are more than just different numerical techniques for model
estimation.  They make different assumptions, have different requirements, and
have different properties.  Asking which is correct has only one answer.  Each
is correct when their assumptions and requirements are met.

{pstd}
In terms of practical advice, we have two alternative recommendations.

{pstd}
The first one involves lots of computer time.

{phang2}
1. Fit the model with {cmd:xpo} and the default plugin.

{phang2}
2. Fit the model with {cmd:xpo} and CV.

{phang2}
3. Compare results.  If they are similar, use the results from step 1.

{pstd}
This alternative will save computer time.

{phang2}
1. Fit the model with {cmd:ds} with the default plugin.

{phang2}
2. Fit it again with {cmd:ds} but with CV.

{phang2}
3. Fit it again with {cmd:po} with the default plugin.

{phang2}
4. Fit it again with {cmd:po} but with CV.

{phang2}
5. Compare results.  If they are similar, you are likely 
          on solid ground.  If so, perform step 6.

{phang2}
6. Fit the model again with {cmd:xpo} with the default 
          plugin and use those results.

{pstd}
You can combine these two recommendations.  Start with the alternative,
and if it fails at step 5, follow the first set of recommendations.
{p_end}
