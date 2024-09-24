library(tidyverse)
library(ggpubr)
library(tidycensus)
library(cowplot)

### nflplotR provides ggpreview() function
library(nflplotR)

### Used to filter values not within a vector; inverse of %in%
'%!in%' <- function(x,y)!('%in%'(x,y))

### extrafont provides ability to use system fonts in ggplot
library(extrafont)
loadfonts(device = "win")
#font_import()

eight_colors <- c("#CC7A28", "#A3CB3A", "#49B67F", "#3E5AA8", "#AC4A4A")
three_colors <- c("#CC7A28", "#A3CB3A", "#49B67F", "#3E5AA8")

cp_always_ggplot <- ggplot(data = cp_always, aes(x = YEAR, y = cp_rate, color = legend_text)) +
  geom_line(size = 1, lineend = "round") +
  guides(color = guide_legend(title = "Racial Group", byrow = TRUE)) +
  scale_color_manual(values = eight_colors,
                     labels = function(x) str_wrap(x, width = 20)) +
  scale_y_continuous(labels = scales::percent,
                     limits = c(0, 0.165)) +
  xlim(1970, 2020) +
  labs(title = str_wrap("Corporal Punishment (CP) in States That Never Explicitely Enacted a Ban", 35),
       x = "Year",
       y = "CP Rate") +
  theme_minimal() +
  theme(plot.title.position = "plot",
        plot.title = element_text(family = "Seaford", face = "bold", size = 14, hjust = 0.5,
                                  margin = margin(t = 0, r = 0, b = 15, l = 0)),
        axis.title = element_text(family = "Seaford", face = "bold", size = 10),
        axis.title.x = element_text(margin = margin(t = 5, r = 0, b = 0, l = 0)),
        axis.title.y = element_text(margin = margin(t = 0, r = 20, b = 0, l = 10)),
        axis.text = element_text(family = "Seaford", face = "plain", size = 7),
        legend.title = element_text(family = "Seaford", face = "bold", size = 10),
        legend.text =element_text(family = "Seaford", face = "plain", size = 7),
        legend.spacing.y = unit(0.125, "in"))

cp_rr_always_ggplot <- ggplot(cp_rr_rd_always %>% filter(type %in% c("bl_wh_rr", "hi_wh_rr", "ai_wh_rr", "as_wh_rr")), 
                              aes(x = YEAR, y = value, color = legend_text)) +
  geom_line(size = 1, lineend = "round") +
  guides(color = guide_legend(title = "Racial Group", byrow = TRUE)) +
  scale_color_manual(values = three_colors,
                     labels = function(x) str_wrap(x, width = 20)) +
  xlim(1970, 2020) +
  ylim(0, 4) +
  labs(x = "",
       y = "CP Risk Ratio") +
  theme_minimal() +
  theme(plot.title.position = "plot",
        plot.title = element_text(family = "Seaford", face = "bold", size = 14, hjust = 0.5),
        axis.title = element_text(family = "Seaford", face = "bold", size = 10),
        axis.title.x = element_text(margin = margin(t = 5, r = 0, b = 0, l = 0)),
        axis.title.y = element_text(margin = margin(t = 0, r = 20, b = 0, l = 10)),
        axis.text = element_text(family = "Seaford", face = "plain", size = 7),
        legend.title = element_text(family = "Seaford", face = "bold", size = 10),
        legend.text = element_text(family = "Seaford", face = "plain", size = 7),
        legend.spacing.y = unit(0.125, "in"))

### You will get more than 50 warning messages when you run this!
### If they are about font width, you can ignore them. The code will still work.
### These font errors are a result of using a custom font (Seaford, in this case).

racial_group_legend <- get_legend(oss_all_ggplot + theme(legend.position = "right",
                                                         legend.margin = margin(0, 0, 0, -50, unit = "pt"),
                                                         legend.title = element_blank(),
                                                         legend.spacing.y = unit(0.125, "in")))
rr_legend <- get_legend(oss_rr_ggplot + theme(legend.position = "right",
                                              legend.margin = margin(0, 0, 0, -50, unit = "pt"),
                                              legend.title = element_blank(),
                                              legend.spacing.y = unit(0.125, "in")))

socius_combined_always <- plot_grid(plot_grid(cp_always_ggplot + theme(legend.position = "hidden"),
                                              cp_rr_always_ggplot + theme(legend.position = "hidden"),
                                              ncol = 1),
                                    plot_grid(racial_group_legend,
                                              rr_legend,
                                              ncol = 1),
                                    ncol = 2, rel_widths = c(1, 0.4375))

ggsave(plot = socius_combined_always, filename = "Exports//socius_always_legal_all_years.pdf", 
       device = cairo_pdf, width = 8, height = 5, units = "in")

ggsave(plot = socius_combined_always, filename = "Exports//socius_always_legal_all_years.png", 
       width = 8, height = 5, units = "in", dpi = 600, bg = "white")

ggsave(plot = socius_combined_always, filename = "Exports//socius_always_legal_all_years.jpeg", 
       width = 8, height = 5, units = "in", dpi = 600, bg = "white")


