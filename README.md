# Making figures using `ggplot2`
Currently there is only one "final" figure created to illustrate relationship measured across multiple years (repeated measures). Hopefully there will be more at some point...

### Repeated measures figure
I needed to create a  figure to visualize the relationship between California bay laurel density and symptomatic leaf counts from 2004-2012. California bay laurel is the host of *Phytophthora ramorum* that is responsible for the majority of the pathogen spread. *P. ramorum* causes the disease sudden oak death in California & Oregon. More details on the disease, pathogen, and research efforts can be found at [suddenoakdeath.org](http://www.suddenoakdeath.org). The pathogen is environmentally sensitive, so we expect for disease intensity to vary from year to year.

The complete set of steps is in [slc_dens_fig.Rmd](https://github.com/whalend/ggplot_figures/blob/master/slc_dens_fig.Rmd), with a truncated version of the code in [supp_figure.Rmd](https://github.com/whalend/ggplot_figures/blob/master/supp_figure.Rmd). Either should produce a figure that looks something like this:

![Leaf Symptoms vs. Stem Density of Bay Laurel](https://github.com/whalend/ggplot_figures/blob/master/figure/Final%20ggplot.png)

