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

### Corporal punishment graph panels
cp_all_ggplot <- ggplot(data = cp_all, aes(x = YEAR, y = cp_rate, color = legend_text, size = size)) +
  geom_line(lineend = "round", size = 1) +
  scale_size_manual(values = c("all" = 1.5, "not_all" = .75)) +
  guides(color = guide_legend(title = "Racial Group", byrow = TRUE),
         size = "none") +
  scale_color_manual(values = eight_colors,
                     labels = function(x) str_wrap(x, width = 20)) +
  scale_y_continuous(labels = scales::percent,
                     limits = c(0, 0.075)) +
  xlim(1970, 2020) +
  labs(title = "Corporal Punishment (CP)",
       x = "Year",
       y = "CP Rate") +
  theme_minimal() +
  theme(plot.title.position = "plot",
        plot.title = element_text(family = "Seaford", face = "bold", size = 14, hjust = 0.5,
                                  margin = margin(t = 0, r = 0, b = 15, l = 0)),
        axis.title = element_text(family = "Seaford", face = "bold", size = 10),
        axis.title.x = element_text(margin = margin(t = 5, r = 0, b = 0, l = 0)),
        axis.title.y = element_text(margin = margin(t = 0, r = 10, b = 0, l = 10)),
        axis.text = element_text(family = "Seaford", face = "plain", size = 7),
        legend.title = element_text(family = "Seaford", face = "bold", size = 10),
        legend.text = element_text(family = "Seaford", face = "plain", size = 7))

cp_rr_ggplot <- ggplot(cp_rr_rd_all %>% filter(type %in% c("bl_wh_rr", "hi_wh_rr", "ai_wh_rr", "as_wh_rr")), 
                       aes(x = YEAR, y = value, color = legend_text)) +
  geom_line(size = 1, lineend = "round") +
  guides(color = guide_legend(title = "Racial Group", byrow = TRUE)) +
  scale_color_manual(values = three_colors,
                     labels = function(x) str_wrap(x, width = 20)) +
  xlim(1970, 2020) +
  ylim(0, 4) +
  labs(title = "Corporal Punishment (CP)",
       x = "",
       y = "CP Risk Ratio") +
  theme_minimal() +
  theme(plot.title.position = "plot",
        plot.title = element_text(family = "Seaford", face = "bold", size = 14, hjust = 0.5),
        axis.title = element_text(family = "Seaford", face = "bold", size = 10),
        axis.title.x = element_text(margin = margin(t = 5, r = 0, b = 0, l = 0)),
        axis.title.y = element_text(margin = margin(t = 0, r = 20, b = 0, l = 10)),
        axis.text = element_text(family = "Seaford", face = "plain", size = 7),
        legend.title = element_text(family = "Seaford", face = "bold", size = 10),
        legend.text = element_text(family = "Seaford", face = "plain", size = 7))

### OSS graph panels
oss_all_ggplot <- ggplot(data = oss_all, aes(x = YEAR, y = oss_rate, color = legend_text)) +
  geom_line(lineend = "round", size = 1) +
  guides(color = guide_legend(title = "Racial Group", byrow = TRUE)) +
  scale_color_manual(values = eight_colors,
                     labels = function(x) str_wrap(x, width = 20)) +
  scale_y_continuous(labels = scales::percent,
                     limits = c(0, 0.165)) +
  xlim(1970, 2020) +
  labs(title = "Out-of-School Suspension (OSS)",
       x = "Year",
       y = "OSS Rate") +
  theme_minimal() +
  theme(plot.title.position = "plot",
        plot.title = element_text(family = "Seaford", face = "bold", size = 14, hjust = 0.5,
                                  margin = margin(t = 0, r = 0, b = 15, l = 0)),
        axis.title = element_text(family = "Seaford", face = "bold", size = 10),
        axis.title.x = element_text(margin = margin(t = 5, r = 0, b = 0, l = 0)),
        axis.title.y = element_text(margin = margin(t = 0, r = 10, b = 0, l = 10)),
        axis.text = element_text(family = "Seaford", face = "plain", size = 7),
        legend.title = element_text(family = "Seaford", face = "bold", size = 10),
        legend.text = element_text(family = "Seaford", face = "plain", size = 7))

oss_rr_ggplot <- ggplot(oss_rr_rd_all %>% filter(type %in% c("bl_wh_rr", "hi_wh_rr", "ai_wh_rr", "as_wh_rr")), 
                        aes(x = YEAR, y = value, color = legend_text)) +
  geom_line(size = 1, lineend = "round") +
  guides(color = guide_legend(title = "Racial Group", byrow = TRUE)) +
  scale_color_manual(values = three_colors,
                     labels = function(x) str_wrap(x, width = 20)) +
  xlim(1970, 2020) +
  ylim(-0.05, 4) +
  labs(title = "Out-of-School Suspension (OSS)",
       x = "",
       y = "OSS Risk Ratio") +
  theme_minimal() +
  theme(plot.title.position = "plot",
        plot.title = element_text(family = "Seaford", face = "bold", size = 14, hjust = 0.5),
        axis.title = element_text(family = "Seaford", face = "bold", size = 10),
        axis.title.x = element_text(margin = margin(t = 5, r = 0, b = 0, l = 0)),
        axis.title.y = element_text(margin = margin(t = 0, r = 20, b = 0, l = 10)),
        axis.text = element_text(family = "Seaford", face = "plain", size = 7),
        legend.title = element_text(family = "Seaford", face = "bold", size = 10),
        legend.text =element_text(family = "Seaford", face = "plain", size = 7))

### You will get more than 50 warning messages when you run this!
### If they are about font width, you can ignore them. The code will still work.
### These font errors are a result of using a custom font (Seaford, in this case).

### Pulling legends as individual objects
racial_group_legend <- get_legend(oss_all_ggplot + theme(legend.position = "right",
                                                         legend.margin = margin(0, 0, 0, -50, unit = "pt"),
                                                         legend.title = element_blank(),
                                                         legend.spacing.y = unit(0.125, "in")))
rr_legend <- get_legend(oss_rr_ggplot + theme(legend.position = "right",
                                              legend.margin = margin(0, 0, 0, -50, unit = "pt"),
                                              legend.title = element_blank(),
                                              legend.spacing.y = unit(0.125, "in")))

### Combined layout
all_states_rr <- plot_grid(plot_grid(oss_all_ggplot + theme(legend.position = "hidden"),
                                     cp_all_ggplot + theme(legend.position = "hidden"),
                                     racial_group_legend,
                                     ncol = 3,
                                     rel_widths = c(1, 1, 0.5)),
                           plot_grid(oss_rr_ggplot + theme(legend.position = "hidden",
                                                           plot.title = element_blank()),
                                     cp_rr_ggplot + theme(legend.position = "hidden",
                                                          plot.title = element_blank()),
                                     rr_legend,
                                     ncol = 3,
                                     rel_widths = c(1, 1, 0.5)),
                           nrow = 2)

ggsave(plot = all_states_rr, filename = "Exports//socius_all_states_all_years_rr.pdf", 
       device = cairo_pdf, width = 8, height = 4, units = "in")

ggsave(plot = all_states_rr, filename = "Exports//socius_all_states_all_years_rr.png", 
       width = 8, height = 5, units = "in", dpi = 600, bg = "white")

ggsave(plot = all_states_rr, filename = "Exports//socius_all_states_all_years_rr.jpeg", 
       width = 8, height = 5, units = "in", dpi = 600, bg = "white")
