# Out of state?

MassWateR can be used anywhere with a few caveats. MassWateR was
developed specifically for organizations in Massachusetts to support the
data submission process to Massachusetts Department of Environmental
Protection (Mass DEP). However, the structure, logic, and approach to
analyzing data are universal and could be used by any organization. Here
is a list of the MassWateR elements that are specific to Massachusetts:

1.  **Parameter thresholds** - [Standard
    thresholds](https://github.com/massbays-tech/MassWateR/raw/refs/heads/main/inst/extdata/ThresholdMapping.xlsx)
    have been included for some parameters so that a threshold line can
    be easily added to the analysis graphs. Some of these thresholds
    have been defined by Mass DEP or MassBays, while others are EPA
    standards. There are two ways to handle this if the thresholds are
    not relevant. You can simply turn the thresholds off in the graphing
    functions with the `thresh = "none"` argument, or you can manually
    add your own as described in the [modifying
    plots](https://massbays-tech.github.io/MassWateR/articles/modifying.html)
    vignette.
2.  **Mapping water bodies** - In the mapping function
    [`anlzMWRmap()`](https://massbays-tech.github.io/MassWateR/reference/anlzMWRmap.md),
    there is an option to add a waterbody layer
    (`addwater = "high"/"medium"/"low"`). This waterbody layer only
    includes watersheds that have portions in Massachusetts. If you are
    outside of Massachusetts, you can still use the base maps available
    with the maptype argument or you can add your own waterbody layer
    following the instructions in the [modifying
    plots](https://massbays-tech.github.io/MassWateR/articles/modifying.html)
    vignette.
3.  **QC Report format** - The QC Report Word document that is created
    with the
    [`qcMWRreview()`](https://massbays-tech.github.io/MassWateR/reference/qcMWRreview.md)
    function has been designed jointly with Mass DEP based on their
    requirements. Mass DEP has approved this format for data submissions
    from Massachusetts organizations. This document may not meet the
    requirements of other state organizations. However, the structure
    and logic of the document are theoretically universal. We believe
    that it should meet the QC needs of any state. Also, it can be
    easily customized since it is a Word document.
4.  **Time-zone** - The WQX output file that is created with the
    [`tabMWRwqx()`](https://massbays-tech.github.io/MassWateR/reference/tabMWRwqx.md)
    function is hard-coded to fill in the *WQX Activity Start Time Zone*
    field with `"EDT"`. If this is not the correct time zone for your
    organization, you can manually change the time zone in your WQX
    upload file prior to uploading to WQX.
5.  **Sample Collection Method** - In the WQX output file, if you do not
    define your own Sample Collection Method and Context, MassWateR will
    default the Method ID `"Grab-MassWateR"` and the Method Context
    `"MassWateR"`. Even though these names include the prefix “Mass”,
    there is nothing specific to Massachusetts about this sampling
    method. Further, the recommended solution is to define your own
    method and context in WQX.

In future updates we may expand the scope beyond Massachusetts, but for
now you are welcome to use the package with the considerations mentioned
above.
