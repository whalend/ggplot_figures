# Creating a figure describing the relationship between bay laurel density and symptomatic leaf count from 2004-2012

# Load libraries
library(plyr)
library(dplyr)
library(ggplot2)
library(grid)
library(tidyr)
library(knitr)

setwd("~/GitHub/ggplot_figures")

# Read in data ####
bay_dens <- readRDS("bay_dens.rds")
str(bay_dens)
summary(bay_dens)

bay_slc <- readRDS("bay_slc.rds")
str(bay_slc)
summary(bay_slc)

# Tidy data ####
bay_dens <- bay_dens %>% gather(year, density, umca_ct_04:umca_ct_11) %>% 
      mutate(year = extract_numeric(year), year = as.factor(year+2000))

bay_slc <- bay_slc %>% gather(year, slc, cum_slc_04:cum_slc_11) %>% 
      mutate(year = extract_numeric(year), year = as.factor(year+2000))

bay_vars1 <- inner_join(bay_dens,bay_slc, by = c("plotid","year"))
str(bay_vars1)
head(bay_vars1)
#saveRDS(bay_vars1, file = "bay_variables.rds")
#bay_vars1 <- readRDS("bay_variables.rds")

# Check variable distributions ####
par(mfrow=c(2,1))
hist(bay_vars1$density, main = "Bay laurel density")
hist(bay_vars1$slc, main = "Bay laurel symptomatic leaf count")
```

These show some pretty severe right skew, so I tried a log transformation:
      
      ```{r Log-transformed histograms, fig.width=6, fig.height=9, echo=TRUE}
par(mfrow=c(2,1))
hist(log(bay_vars1$density), main = "Bay laurel density")
hist(log(bay_vars1$slc), main = "Bay laurel symptomatic leaf count")

# Plot data ####
p1 <- qplot(log(bay_dens+1), log(slc+1), data = bay_vars1 %>% group_by(plotid, year), color = year, facets = year~., xlab = "Bay Laurel Density", ylab = "Symptomatic Leaf Count", main = "ln(Symptomatic Leaf Count) vs ln(Bay Laurel Density)")

# Add smooth line to get a better idea of the magnitude of change ####
p1 + geom_smooth(aes(group=year), method="lm", size = 0.5)

# Calculate the regression equation and r-square for each linear model ####
reg_eqn <- function(df) {
      y = log(df$slc+1)
      x = log(df$bay_dens+1)
      m <- lm(y ~ x, data = df)
      
      a <- coef(m)[1]
      b <- coef(m)[2]
      r2 <- summary(m)$r.squared
      
      expr <- substitute(italic(y) == a + b %.% italic(x)*","~~italic(r)^2~"="~r2,
                         list(a = format(a, digits = 2),
                              b = format(b, digits = 2),
                              r2 = format(r2, digits = 3)))
      c(lab = as.character(as.expression(expr)))
}
eqns <- ddply(bay_vars1, "year", reg_eqn)

# Add the equations to the plot ####
p1 + geom_smooth(aes(group=year), method="lm", size = 0.5) +
      geom_text(aes(x = 0, y = 3, label = lab), data = eqns, parse = T, hjust = 0, vjust = -1.5) +
      theme_bw() +
      theme(legend.position="none") +
      theme(panel.margin = unit(0.7,"lines"))

# Finalized plotting code ####
# Hat-tip to Noam Ross' blog post here <http://www.noamross.net/blog/2013/11/20/formatting-plots-for-pubs.html>

p1a <- ggplot(data = bay_vars1 %>% group_by(year), 
              aes(x = log(bay_dens+1), y = log(slc+1), color = year)) + 
      geom_point(size=3, alpha = 0.3) + 
      geom_smooth(method="lm", size = 0.5) + 
      geom_text(aes(x = 0, y = 3, label = lab), data = eqns, parse = T, 
                hjust = 0, vjust = -1.5) + 
      facet_grid(year~.)
p1a + theme_bw() +
      theme(legend.position = "none") +
      theme(panel.margin = unit(0.7, "lines")) +
      labs(x = "Log bay laurel density", y = "Log bay laurel symptomatic leaf count")

# A couple of alternative ways to export the plot ####
# You can also do this from the plotting device

#`ggsave` defaults to saving the last plot that you displayed, and for a default size uses the size of the current graphics device. It also guesses the type of graphics device from the extension. This means the only argument you need to supply is the filename
ggsave("supp_figure/slc_vs_dens.svg", width = 6, height = 9)

#This is a `base` approach for exporting the final figure to PDF
pdf(file = "supp_figure/slc_vs_dens.pdf", width = 6, height = 9, useDingbats=F)
p1a + theme_bw() +
      theme(legend.position = "none") +
      theme(panel.margin = unit(0.7, "lines")) +
      labs(x = "Log bay laurel density", y = "Log bay laurel symptomatic leaf count")
dev.off()

