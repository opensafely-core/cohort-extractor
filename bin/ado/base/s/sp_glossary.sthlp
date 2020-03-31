{smcl}
{* *! version 1.0.3  15may2018}{...}
{vieweralsosee "[SP] Glossary" "mansection SP Glossary"}{...}
{viewerjumpto "Description" "sp_glossary##description"}{...}
{viewerjumpto "Glossary" "sp_glossary##glossary"}{...}
{p2colset 1 18 20 2}{...}
{p2col:{bf:[SP] Glossary} {hline 2}}Glossary of terms{p_end}
{p2col:}({mansection SP Glossary:View complete PDF manual entry}){p_end}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}Commonly used terms are defined here.


{marker glossary}{...}
{title:Glossary}

{phang}
{bf:adjacent}.
        Two 
	{help sp_glossary##areas:areas} are said to be adjacent if they share a
        {help sp_glossary##border_and_vertex:border}.  Also see 
	{help sp_glossary##contiguity_matrix:{it:contiguity matrix}}.

{phang}
{bf:AR(1)}.
        See {help sp_glossary##autoregressive_errors:{it:autoregressive errors}}.

{marker areal_data}{...}
{phang}
{bf:areal data}.
	Areal data is a term for data on areas.  SAR models are appropriate
	for areal and {help sp_glossary##lattice_data:lattice data}.

{marker areas}{...}
{phang}
{bf:areas}.
	Areas is an informal term for 
	{help sp_glossary##geographic_units:geographic units}.

{phang}
{bf:attributes}.
        Attributes is the name given to the variables included 
        in standard-format 
	{help sp_glossary##shapefiles:shapefiles}.

{marker autoregressive_errors}{...}
{phang}
{bf:autoregressive errors}.
        Spatially autoregressive errors account for spatially
        lagged correlation of the residuals.  rho is the correlation
        parameter.  It is not a correlation coefficient, but it shares
        certain properties with correlation coefficients.  It is
        bounded by -1 and 1, and 0 has the same meaning, namely, no
        correlation.

{marker autoregressive_models}{...}
{phang}
{bf:autoregressive models}.
	  Spatially autoregressive models include a spatially lagged dependent
	  variable or
	  {help sp_glossary##spatially_autoregressive_errors:spatially autoregressive errors}.  See {manlink SP Intro 1}.

{marker balanced_and_strongly_balanced}{...}
{phang}
{bf:balanced and strongly balanced}.
        Panel data are balanced if each panel contains the same
        number of observations.  They are strongly balanced if
        they record data for the same times (subcategory).

{marker border_and_vertex}{...}
{phang}
{bf:border and vertex}.
        Consider the following map:

                                  +-------+
                                  |       |
                       +----------+   C   |
                       |    B     |       |
                 +----------------+-------+
                 |          A     |
                 +----------------+

{pmore}
        A and B share a border because there is a line segment
        separating them.  For the same reasons, B and C share a border.

{pmore}
        A and C share a vertex.  They have only a single point in common.

{pmore}
        How should you treat vertex-only adjacency?  This issue arises
        when constructing a
	{help sp_glossary##contiguity_matrix:contiguity matrix}.  It is up to
	you whether a vertex in common is sufficient to label the areas as
	contiguous.  Vertex-only adjacency occurs frequently when the shapes
	of the geographic units are rectangular.

{marker choropleth_map}{...}
{phang}
{bf:choropleth map}.
        A choropleth map is a map in which shading or coloring is 
        used to indicate values of a variable within areas.

{marker contiguity_matrix}{...}
{phang}
{bf:contiguity matrix and ex post contiguity matrix}.
        A contiguity matrix is a symmetric matrix containing 0s
        and 1s before normalization, with 1s indicating that areas are
        adjacent.

{pmore}
	{helpb spmatrix create:spmatrix create contiguity} creates contiguity
	matrices and other matrices that would not be considered contiguity
	matrices by the above definition.  It can create first-order neighbor
	matrices containing 0s and 1s.  That is a contiguity matrix.  It can
	create first- and second-order neighbor matrices containing 0s and 1s.
	That is not a contiguity matrix strictly speaking.  And it can create
	other matrices where second-order neighbors are recorded as 0.5 or any
	other value of your choosing.

{pmore}
        And finally, even if the matrix started out as a contiguity
        matrix strictly speaking, after normalization the two values
        that it contains are 0 and c.

{pmore}
	As a result, commands like {helpb spmatrix summarize} 
        use a different definition for contiguity matrix.

{pmore}
        An ex post contiguity matrix is any matrix in which all
        values are either 0 or c, a positive constant.
	It is meaningful to count neighbors in such cases.  Thus, 
        the matrix {cmd:W2} created by typing

{pmore2}
{cmd:. spmatrix create contiguity W2, second}

{pmore}
        is an ex post contiguity matrix, and the matrix {cmd:W}
        created by typing

{pmore2}
{cmd:. spmatrix create contiguity W, first second(0.5)}

{pmore}
        is not.

{marker coordinate_system}{...}
{phang}
{bf:coordinate system}.
        A coordinate system is the encoding used by numbers used
        to designate locations.  Latitude and longitude are a
        coordinate system.  As far as Sp is concerned, the only other
        coordinate system is planar.  Planar coordinates are also known
        as rectangular or Cartesian coordinates.  In theory,
        standard-format {help sp_glossary##shapefiles:shapefiles} provide planar
        coordinates.  In practice, they sometimes use latitude and
        longitude, but standards for encoding the system used are still
        developing.  See {manhelp spdistance SP} for a more complete description,
        and see {manlink SP Intro 4} for how you can determine
        whether coordinates are planar or latitude and longitude.

{phang}
{bf:covariate}.
       See {help sp_glossary##explanatory_variable:{it:explanatory variable}}.

{marker cross_sectional_data}{...}
{phang}
{bf:cross-sectional data}.
          Cross-sectional data contain one observation per 
          {help sp_glossary##spatial_units:spatial unit}.
	  Also see {help sp_glossary##panel_data:{it:panel data}}.

{phang}
{bf:.dbf files}.
         See {help sp_glossary##shapefiles:{it:shapefiles}}.

{phang}
{bf:dependent variable}.
          See
	  {help sp_glossary##outcome_variable:{it:outcome variable}}.

{marker distance_matrix}{...}
{phang}
{bf:distance matrix}.
        A distance matrix is a spatial weighting matrix 
        based on some function of distance.  Usually that function 
        is 1/distance, and the matrix is then called an 
	{help sp_glossary##inverse_distance_spatial_weighting_matrix:inverse-distance spatial weighting matrix}.
     
{marker explanatory_variable}{...}
{phang}
{bf:explanatory variable}.
        An explanatory variable is a variable that appears 
        on the right-hand side of the equation used to "explain" the
        values of the 
	{help sp_glossary##outcome_variable:outcome variable}.

{phang}
{bf:FIPS codes}.
        FIPS stands for federal information processing
        standard.  FIPS codes are used for designating areas of
        the United States.  At the most detailed level is the five-digit
	FIPS county codes, which range from 01001 for Autauga County in
        Alabama to 78030 for St. Thomas Island in the Virgin Islands.
        The FIPS county code includes counties, 
        U.S. possessions, and freely associated areas.

{pmore}
        The first two digits of the five-digit code are
        FIPS state codes.  The two-digit code covers 
        states, U.S. possessions, and freely associated areas.

{pmore}
        The five-digit code appears in some datasets as the 
        two-digit state code plus a three-digit county code.  The full 
        five-digit code is formed by joining the two-digit and three-digit 
        codes.

{marker geographic_units}{...}
{phang}
{bf:geographic units}.
        Geographic units is the generic term for places or areas
        such as zip-code areas, census blocks, cities, counties,
        countries, and the like.  The units do not need to be based on
        geography.  They could be network nodes, for instance.
        In this manual, we also use the words places and areas 
        for the geographic units.  Also see 
	{help sp_glossary##spatial_units:{it:spatial units}}.

{phang}
{bf:GIS data}.
	GIS is an acronym for geographic information system.  Some of the
	information in {help sp_glossary##shapefiles:shapefiles} is from such
	systems.

{phang}
{bf:ID, _ID variable}.
        An ID variable is a variable that uniquely identifies the
        observations.  Sp's {cmd:_ID} variable is an example of an ID
        variable that uniquely identifies the 
	{help sp_glossary##geographic_units:geographic units}.
         Sp's {cmd:_ID} variable is a numeric variable that
        uniquely identifies the observations in cross-sectional data
        and uniquely identifies the panels in panel data.

{phang}
{bf:idistance spatial weighting matrix}.
        An idistance spatial weighting matrix is Sp jargon for an
	{help sp_glossary##inverse_distance_spatial_weighting_matrix:inverse-distance spatial weighting matrix}.

{phang}
{bf:i.i.d.}
        I.i.d. stands for independent and identically
        distributed.  A variable is i.i.d. when each observation of
        the variable has the same probability distribution as all the
        other observations and all are independent of one another.

{phang}
{bf:imported spatial weighting matrix}.
        An imported spatial weighting matrix is a
	{help sp_glossary##spatial_weighting_matrix:spatial weighting matrix}
	created with the {cmd:spmatrix} {cmd:import} command.

{phang}
{bf:instrumental variables}.
        Instrumental variables are variables related to 
        the covariates (explanatory variables) and unrelated to 
        the errors (residuals).

{marker inverse_distance_spatial_weighting_matrix}{...}
{phang}
{bf:inverse-distance spatial weighting matrix}.
        An inverse-distance spatial weighting matrix is a
        matrix in which the elements W_{i,j} before
        normalization contain the reciprocal of the distance between
        places j and i.  The term is also used for inverse-distance
        matrices in which places farther apart than a specified
        distance are set to 0.

{phang}
{bf:lags}.
        See {help sp_glossary##spatial_lags:{it:spatial lags}}.

{phang}
{bf:latitude and longitude}.
        See {help sp_glossary##coordinate_system:{it:coordinate system}}.

{marker lattice_data}{...}
{phang}
{bf:lattice data}.
         Lattice data are a kind of area data.  In lattice data,
         all places are vertices appearing on a grid.
         SAR models are appropriate for lattice data and
	 {help sp_glossary##areal_data:areal data}.

{phang}
{bf:neighbors, first- and second-order}.
        First-order neighbors share 
        {help sp_glossary##border_and_vertex:borders}.  Second-order
        neighbors are neighbors of neighbors.

{phang}
{bf:normalized spatial weighting matrix}.
        A normalized spatial weighting matrix is a 
	{help sp_glossary##spatial_weighting_matrix:spatial weighting matrix}
	multiplied by a constant to improve numerical accuracy and to make
	nonexplosive autoregressive parameters bounded by -1 and 1.
	See {mansection SP spregressRemarksandexamplesChoosingweightingmatricesandtheirnormalization:{it:Choosing weighting matrices and their normalization}}
	in {bf:[SP] spregress} for details about normalization.

{marker outcome_variable}{...}
{phang}
{bf:outcome variable (dependent variable)}.
        The outcome variable of a model is the variable appearing 
        on the left-hand side of the equation.  It is the variable 
        being "explained" or predicted.

{marker panel_data}{...}
{phang}
{bf:panel data}.
          Panel data contain data on 
	  {help sp_glossary##geographic_units:geographic units}
          at various times.  Each observation contains data on a
          geographic unit at a particular time, and thus the data 
          contain multiple observations per geographic unit.  Also see
          {help sp_glossary##cross_sectional_data:{it:cross-sectional data}}.

{phang}
{bf:places}.
	Places is an informal term for 
	{help sp_glossary##geographic_units:geographic units}.

{marker planar_coordinates}{...}
{phang}
{bf:planar coordinates}.
        See {help sp_glossary##coordinate_system:{it:coordinate system}}.

{phang}
{bf:proximity matrix}.
        Proximity matrix is another word for 
        {help sp_glossary##distance_matrix:distance matrix}.

{phang}
{bf:SAR}.
        SAR stands for spatial autoregressive or simultaneous
        autoregressive, which themselves mean the same thing but 
        are used by researchers in different fields.  See
        {help sp_glossary##autoregressive_models:{it:autoregressive models}}
        and
	{help sp_glossary##autoregressive_errors:{it:autoregressive errors}}.

{marker shapefiles}{...}
{phang}
{bf:shapefiles}.
        Shapefiles are files defining maps and more that you find
        on the web.  A shapefile might be {it:name}{cmd:.zip}.
	{it:name}{cmd:.zip} contains {it:name}{cmd:.shp},
	{it:name}{cmd:.dbf}, and files with other suffixes.

{pmore}
        In this manual, shapefiles are also the shapefiles as
        described above translated into Stata format.  They are Stata
        datasets named {it:name}{cmd:_shp.dta}.

{pmore}
        To distinguish the two meanings, we refer to standard-format
        and Stata-format shapefiles.

{phang}
{bf:Sp}.
        Sp stands for spatial and refers to the SAR system
        described in this manual.

{phang}
{bf:Sp data}.
        Sp data are data that have been {cmd:spset}, whether
        directly or indirectly.  You can type {cmd:spset} without
        arguments to determine whether your data are {cmd:spset}.

{marker spatial_lags}{...}
{phang}
{bf:spatial lags}.
        Spatial lags are the spatial analogy of time-series lags.
        In time series, the lag of x_t is x_{t-1}.  In spatial 
        analysis, the lag of x_i -- x in place i -- is a weighted
        sum of x in nearby places given by {bf:W}{bf:x}.
        See {manlink SP Intro 1}.

{marker spatial_units}{...}
{phang}
{bf:spatial units}.
       Spatial units is the term we use for the units measuring 
       distance when the coordinates are 
       {help sp_glossary##planar_coordinates:planar}.  For
       instance, New York and Boston might be recorded in planar units
       as being at ({cmd:_CX}, {cmd:_CY}) = (1.3, 7.836)
       and (1.447, 7.118).  In that case, the distance between them is
       0.0284 spatial units.  Because they are about 190 miles apart,
       evidently a spatial unit is 6,690 miles.  Also see
       {manhelp spdistance SP}.

{marker spatial_weighting_matrix}{...}
{phang}
{bf:spatial weighting matrix}.
       A spatial weighting matrix is square matrix {bf:W}.
       {bf:W}{bf:x} plays the same role in spatial analysis that
       L.{bf:x} plays in time-series analysis.  One can
       think of {bf:W}'s elements as recording the potential
       spillover for place j to i.

{pmore}
       Spatial weighting matrices have zero on the diagonal and nonzero
       or zero values elsewhere.  A
       {help sp_glossary##contiguity_matrix:contiguity spatial weighting matrix}
       would have 0s and 1s.  W_{i,j} = W_{j,i} would equal 1 when i and j
       were neighbors.

{pmore}
       The scale in which the elements of spatial weighting matrices
       are recorded is irrelevant.  See {manlink SP Intro 2}.

{marker spatially_autoregressive_errors}{...}
{phang}
{bf:spatially autoregressive errors}.
        See {help sp_glossary##autoregressive_errors:{it:autoregressive errors}}.

{phang}
{bf:spillover effects}.
	Spillover effects and potential spillover effects
        are the informal words we use to describe the elements of a
        {help sp_glossary##spatial_weighting_matrix:spatial weighting matrix}.
	W_{i,j} records the (potential) spillover from place j to i.  See
	{manlink SP Intro 2}.

{phang}
{bf:standard-format shapefile}.
       See {help sp_glossary##shapefiles:{it:shapefiles}}.

{phang}
{bf:Stata-format shapefile}.
      See {help sp_glossary##shapefiles:{it:shapefiles}}.

{phang}
{bf:strongly balanced}.
      See {help sp_glossary##balanced_and_strongly_balanced:{it:balanced and strongly balanced}}.
 
{phang}
{bf:time variable}.  The time variable is the variable in panel data that
      identifies the second level of the panel.  The variable is not required
      to measure time, but it usually does.

{phang}
{bf:user-defined matrix}.
       A user-defined matrix is a
       {help sp_glossary##spatial_weighting_matrix:spatial weighting matrix}
       created by typing

            {cmd:spmatrix} {cmd:userdefined} 

            {cmd:spmatrix} {cmd:fromdata} 

            {cmd:spmatrix} {cmd:spfrommata} 

{phang}
{bf:vertex}.
       See {help sp_glossary##border_and_vertex:{it:border and vertex}}.
{p_end}
