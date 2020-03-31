{smcl}
{* *! version 1.0.4  11feb2011}{...}
{* this hlp file is called by anova.dlg and testanova.dlg}{...}
{vieweralsosee "[R] anova" "help anova"}{...}
{title:ANOVA model examples}

    {c TLC}{hline 25}{c TT}{hline 41}{c TRC}
    {c |} Model {space 18}{c |} Description {space 28}{c |}
    {c LT}{hline 25}{c +}{hline 41}{c RT}
    {c |} {cmd:a}                       {c |} one factor                              {c |}
    {c |} {cmd:a b}                     {c |} two factors                             {c |}
    {c |} {cmd:a b a#b}                 {c |} two factors plus interaction            {c |}
    {c |} {cmd:a##b}                    {c |} two factors plus interaction            {c |}
    {c |} {cmd:a b c}                   {c |} three factors                           {c |}
    {c |} {cmd:a b c a#b a#c b#c}       {c |} three factors plus two-way interactions {c |}
    {c |} {cmd:a b c a#b a#c b#c a#b#c} {c |} three factors plus all interactions     {c |}
    {c |} {cmd:a##b##c}                 {c |} three factors plus all interactions     {c |}
    {c BLC}{hline 25}{c BT}{hline 41}{c BRC}


{title:Nested ANOVA model examples}

    Model:  {cmd:district / school|district /}

    {c TLC}{hline 17}{c TT}{hline 27}{c TT}{hline 17}{c TRC}
    {c |} Term {space 11}{c |} Meaning {space 18}{c |} Error term      {c |}
    {c LT}{hline 17}{c +}{hline 27}{c +}{hline 17}{c RT}
    {c |} {cmd:district}        {c |} {cmd:district} {space 17}{c |} {cmd:school|district} {c |}
    {c |} {cmd:school|district} {c |} {cmd:school} nested in {cmd:district} {c |} residual error  {c |}
    {c BLC}{hline 17}{c BT}{hline 27}{c BT}{hline 17}{c BRC}


    Model:  {cmd:t / c|t / d|c|t / p|d|c|t /}

    {c TLC}{hline 9}{c TT}{hline 39}{c TT}{hline 13}{c TRC}
    {c |} Term    {c |} Meaning {space 30}{c |} Error term  {c |}
    {c LT}{hline 9}{c +}{hline 39}{c +}{hline 13}{c RT}
    {c |} {cmd:t}       {c |} {cmd:t} {space 36}{c |} {cmd:c|t}         {c |}
    {c |} {cmd:c|t}     {c |} {cmd:c} nested in {cmd:t} {space 24}{c |} {cmd:d|c|t}       {c |}
    {c |} {cmd:d|c|t}   {c |} {cmd:d} nested in {cmd:c} nested in {cmd:t} {space 12}{c |} {cmd:p|d|c|t}     {c |}
    {c |} {cmd:p|d|c|t} {c |} {cmd:p} nested in {cmd:d} nested in {cmd:c} nested in {cmd:t} {c |} resid. err. {c |}
    {c BLC}{hline 9}{c BT}{hline 39}{c BT}{hline 13}{c BRC}


{title:Split-plot ANOVA model example}

    Model:  {cmd:p / c|p s p#s / c#s|p / g|c#s|p /}

    {c TLC}{hline 9}{c TT}{hline 42}{c TT}{hline 13}{c TRC}
    {c |} Term    {c |} Meaning {space 33}{c |} Error term  {c |}
    {c LT}{hline 9}{c +}{hline 42}{c +}{hline 13}{c RT}
    {c |} {cmd:p}       {c |} {cmd:p} {space 39}{c |} {cmd:c|p}         {c |}
    {c |} {cmd:c|p}     {c |} {cmd:c} nested in {cmd:p} {space 27}{c |}{space 13}{c |}
    {c |} {cmd:s}       {c |} {cmd:s} {space 39}{c |} {cmd:c#s|p}       {c |}
    {c |} {cmd:p#s}     {c |} {cmd:p} by {cmd:s} interaction {space 22}{c |} {cmd:c#s|p}       {c |}
    {c |} {cmd:c#s|p}   {c |} {cmd:c} by {cmd:s} interaction nested in {cmd:p}           {c |} {cmd:g|c#s|p}     {c |}
    {c |} {cmd:g|c#s|p} {c |} {cmd:g} nested in {cmd:c} by {cmd:s}, which is nested in {cmd:p} {c |} resid. err. {c |}
    {c BLC}{hline 9}{c BT}{hline 42}{c BT}{hline 13}{c BRC}
