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
font_import()

cp_all_with_2020_fixed <- readxl::read_xlsx("CSV Files//corp_76to20_bystate.xlsx") %>%
  mutate("race_fixed" = ifelse(race == "HP", "AI", race)) %>%
  group_by(YEAR, race_fixed) %>%
  summarise(cp_sum = sum(CORP_),
            enr_sum = sum(ENR_)) %>%
  mutate(cp_rate = cp_sum / enr_sum) %>% 
  filter(YEAR >= 1975) %>%
  mutate("legend_text" = ifelse(race_fixed == "sumrace", "All Students",
                         ifelse(race_fixed == "AI", "American Indian / Alaskan Native",
                         ifelse(race_fixed == "AS", "Asian / Pacific Islander",
                         ifelse(race_fixed == "BL", "Black / African American",
                         ifelse(race_fixed == "HI", "Hispanic",
                         ifelse(race_fixed == "HP", "Native Hawaiian / Pacific Islander",
                         ifelse(race_fixed == "MR", "Multi-racial",
                         ifelse(race_fixed == "WH", "White", "check")))))))),
         "size" = ifelse(race_fixed == "sumrace", "all", "not_all")) %>%
  filter(race_fixed %in% c("AI", "AS", "BL", "HI", "WH")) %>%
  ggplot(data = ., aes(x = YEAR, y = cp_rate, color = legend_text, size = size)) +
  geom_line(lineend = "round", size = 1) +
  guides(color = guide_legend(title = "Racial Group", byrow = TRUE),
         size = "none") +
  scale_color_manual(values = eight_colors,
                     labels = function(x) str_wrap(x, width = 20)) +
  scale_y_continuous(labels = scales::percent) +
  xlim(1970, 2020) +
  labs(title = "Corporal Punishment (CP)",
       x = "",
       y = "CP Rate") +
  theme_minimal() +
  theme(plot.title.position = "plot",
        plot.title = element_text(family = "Seaford", face = "bold", size = 14, hjust = 0.5,
                                  margin = margin(t = 0, r = 0, b = 5, l = 0)),
        axis.title = element_text(family = "Seaford", face = "bold", size = 10),
        axis.title.x = element_text(margin = margin(t = 5, r = 0, b = 0, l = 0)),
        axis.title.y = element_text(margin = margin(t = 0, r = 10, b = 0, l = 10)),
        axis.text = element_text(family = "Seaford", face = "plain", size = 7),
        legend.title = element_text(family = "Seaford", face = "bold", size = 10),
        legend.text = element_text(family = "Seaford", face = "plain", size = 7))

cp_all_rr_with_2020_fixed <- readxl::read_xlsx("CSV Files//corp_76to20_bystate.xlsx") %>%
  filter(race != "sumrace") %>%
  mutate("race_adjusted" = ifelse(race %!in% c("BL", "HI", "WH", "AI", "AS"), "OTHER", race)) %>%
  filter(YEAR > 1974) %>%
  group_by(race_adjusted, YEAR) %>%
  summarise(ENR = sum(ENR_),
            CORP = sum(CORP_)) %>%
  pivot_wider(names_from = "race_adjusted", values_from = c("ENR", "CORP")) %>%
  mutate("bl_rate" = CORP_BL / ENR_BL,
         "wh_rate" = CORP_WH / ENR_WH) %>%
  mutate("bl_wh_rr" = bl_rate / wh_rate,
         "bl_wh_rd" = (CORP_BL / ENR_BL) - (CORP_WH / ENR_WH),
         "bl_hi_rr" = (CORP_BL / ENR_BL) / (CORP_HI / ENR_HI),
         "bl_hi_rd" = (CORP_BL / ENR_BL) - (CORP_HI / ENR_HI),
         "hi_wh_rr" = (CORP_HI / ENR_HI) / (CORP_WH / ENR_WH),
         "hi_wh_rd" = (CORP_HI / ENR_HI) - (CORP_WH / ENR_WH),
         "ot_wh_rr" = (CORP_OTHER / ENR_OTHER) / (CORP_WH / ENR_WH),
         "ot_wh_rd" = (CORP_OTHER / ENR_OTHER) - (CORP_WH / ENR_WH),
         "ai_wh_rr" = (CORP_AI / ENR_AI) / (CORP_WH / ENR_WH),
         "ai_wh_rd" = (CORP_AI / ENR_AI) - (CORP_WH / ENR_WH),
         "as_wh_rr" = (CORP_AS / ENR_AS) / (CORP_WH / ENR_WH),
         "as_wh_rd" = (CORP_AS / ENR_AS) - (CORP_WH / ENR_WH)) %>%
  pivot_longer(cols = c(bl_wh_rr, bl_hi_rr, hi_wh_rr, ot_wh_rr, ai_wh_rr, as_wh_rr,
                        bl_wh_rd, bl_hi_rd, hi_wh_rd, ot_wh_rd, ai_wh_rd, as_wh_rd), 
               names_to = "type", values_to = "value") %>%
  mutate("legend_text" = ifelse(type == "bl_wh_rr", "Black / White Risk Ratio",
                         ifelse(type == "hi_wh_rr", "Hispanic / White Risk Ratio",
                         ifelse(type == "bl_wh_rd", "Black / White Risk Difference",
                         ifelse(type == "hi_wh_rd", "Hispanic / White Risk Difference",
                         ifelse(type == "ai_wh_rr", "American Indian or Alaskan Native / White Risk Ratio",
                         ifelse(type == "ai_wh_rd", "American Indian or Alaskan Native / White Risk Difference",
                         ifelse(type == "as_wh_rr", "Asian or Pacific Islander / White Risk Ratio",
                         ifelse(type == "as_wh_rd", "Asian or Pacific Islander / White Risk Difference",
                                "other"))))))))) %>%
  distinct() %>%
  filter(type %in% c("bl_wh_rr", "hi_wh_rr", "ai_wh_rr", "as_wh_rr")) %>%
  ggplot(data = ., aes(x = YEAR, y = value, color = legend_text)) +
  geom_line(size = 1, lineend = "round") +
  guides(color = guide_legend(title = "Racial Group", byrow = TRUE)) +
  scale_color_manual(values = three_colors,
                     labels = function(x) str_wrap(x, width = 20)) +
  xlim(1970, 2020) +
  ylim(0, 4) +
  labs(title = "Corporal Punishment (CP)",
       x = "Year",
       y = "CP Risk Ratio",) +
  theme_minimal() +
  theme(plot.title.position = "plot",
        plot.title = element_text(family = "Seaford", face = "bold", size = 14, hjust = 0.5),
        axis.title = element_text(family = "Seaford", face = "bold", size = 10),
        axis.title.x = element_text(margin = margin(t = 5, r = 0, b = 0, l = 0)),
        axis.title.y = element_text(margin = margin(t = 0, r = 20, b = 0, l = 10)),
        axis.text = element_text(family = "Seaford", face = "plain", size = 7),
        legend.title = element_text(family = "Seaford", face = "bold", size = 10),
        legend.text = element_text(family = "Seaford", face = "plain", size = 7),
        plot.caption = element_text(family = "Seaford", size = 7, hjust = 0))

oss_all_with_2020 <- read_csv("CSV Files//suspensions_data.csv") %>%
  mutate(YEAR = as.numeric(gsub(2021, 2020, YEAR))) %>%
  drop_na(STATE_CODE) %>%
  mutate("race_fixed" = ifelse(race == "HP", "AI", race)) %>%
  group_by(YEAR, race_fixed) %>%
  summarise("oss_sum" = sum(OSS_),
            "oss_mem" = sum(MEM_)) %>%
  mutate(oss_rate = oss_sum / oss_mem) %>% 
  filter(YEAR >= 1975) %>%
  mutate("legend_text" = ifelse(race_fixed == "total", "All Students",
                         ifelse(race_fixed == "AI", "American Indian / Alaskan Native",
                         ifelse(race_fixed == "AS", "Asian / Pacific Islander",
                         ifelse(race_fixed == "BL", "Black / African American",
                         ifelse(race_fixed == "HI", "Hispanic",
                         ifelse(race_fixed == "HP", "Native Hawaiian / Pacific Islander",
                         ifelse(race_fixed == "MR", "Multi-racial",
                         ifelse(race_fixed == "WH", "White", "check"))))))))) %>%
  filter(race_fixed %in% c("AI", "AS", "BL", "HI", "WH")) %>%
  ggplot(data = ., aes(x = YEAR, y = oss_rate, color = legend_text)) +
  geom_line(lineend = "round", size = 1) +
  guides(color = guide_legend(title = "Racial Group", byrow = TRUE)) +
  scale_color_manual(values = eight_colors,
                     labels = function(x) str_wrap(x, width = 20)) +
  scale_y_continuous(labels = scales::percent,
                     limits = c(0, 0.165)) +
  xlim(1970, 2020) +
  labs(title = "Out-of-School Suspension (OSS)",
       x = "",
       y = "OSS Rate") +
  theme_minimal() +
  theme(plot.title.position = "plot",
        plot.title = element_text(family = "Seaford", face = "bold", size = 14, hjust = 0.5,
                                  margin = margin(t = 0, r = 0, b = 5, l = 0)),
        axis.title = element_text(family = "Seaford", face = "bold", size = 10),
        axis.title.x = element_text(margin = margin(t = 5, r = 0, b = 0, l = 0)),
        axis.title.y = element_text(margin = margin(t = 0, r = 10, b = 0, l = 10)),
        axis.text = element_text(family = "Seaford", face = "plain", size = 7),
        legend.title = element_text(family = "Seaford", face = "bold", size = 10),
        legend.text = element_text(family = "Seaford", face = "plain", size = 7))

oss_all_rr_with_2020 <- read_csv("CSV Files//suspensions_data.csv") %>%
  mutate(YEAR = as.numeric(gsub(2021, 2020, YEAR))) %>%
  filter(STATE_CODE %!in% cp_states & STATE_CODE %!in% c("NJ", "MA")) %>%
  filter(race != "total") %>%
  mutate("race_adjusted" = ifelse(race %!in% c("BL", "HI", "WH", "AI", "AS"), "OTHER", race)) %>%
  filter(YEAR > 1974) %>%
  group_by(race_adjusted, YEAR) %>%
  summarise(ENR = sum(MEM_),
            CORP = sum(OSS_)) %>%
  pivot_wider(names_from = "race_adjusted", values_from = c("ENR", "CORP")) %>%
  mutate("bl_rate" = CORP_BL / ENR_BL,
         "wh_rate" = CORP_WH / ENR_WH) %>%
  mutate("bl_wh_rr" = bl_rate / wh_rate,
         "bl_wh_rd" = (CORP_BL / ENR_BL) - (CORP_WH / ENR_WH),
         "bl_hi_rr" = (CORP_BL / ENR_BL) / (CORP_HI / ENR_HI),
         "bl_hi_rd" = (CORP_BL / ENR_BL) - (CORP_HI / ENR_HI),
         "hi_wh_rr" = (CORP_HI / ENR_HI) / (CORP_WH / ENR_WH),
         "hi_wh_rd" = (CORP_HI / ENR_HI) - (CORP_WH / ENR_WH),
         "ot_wh_rr" = (CORP_OTHER / ENR_OTHER) / (CORP_WH / ENR_WH),
         "ot_wh_rd" = (CORP_OTHER / ENR_OTHER) - (CORP_WH / ENR_WH),
         "ai_wh_rr" = (CORP_AI / ENR_AI) / (CORP_WH / ENR_WH),
         "ai_wh_rd" = (CORP_AI / ENR_AI) - (CORP_WH / ENR_WH),
         "as_wh_rr" = (CORP_AS / ENR_AS) / (CORP_WH / ENR_WH),
         "as_wh_rd" = (CORP_AS / ENR_AS) - (CORP_WH / ENR_WH)) %>%
  pivot_longer(cols = c(bl_wh_rr, bl_hi_rr, hi_wh_rr, ot_wh_rr, ai_wh_rr, as_wh_rr,
                        bl_wh_rd, bl_hi_rd, hi_wh_rd, ot_wh_rd, ai_wh_rd, as_wh_rd), 
               names_to = "type", values_to = "value") %>%
  mutate("legend_text" = ifelse(type == "bl_wh_rr", "Black / White Risk Ratio",
                         ifelse(type == "hi_wh_rr", "Hispanic / White Risk Ratio",
                         ifelse(type == "bl_wh_rd", "Black / White Risk Difference",
                         ifelse(type == "hi_wh_rd", "Hispanic / White Risk Difference",
                         ifelse(type == "ai_wh_rr", "American Indian or Alaskan Native / White Risk Ratio",
                         ifelse(type == "ai_wh_rd", "American Indian or Alaskan Native / White Risk Difference",
                         ifelse(type == "as_wh_rr", "Asian or Pacific Islander / White Risk Ratio",
                         ifelse(type == "as_wh_rd", "Asian or Pacific Islander / White Risk Difference",
                                "other"))))))))) %>%
  distinct() %>%
  filter(type %in% c("bl_wh_rr", "hi_wh_rr", "ai_wh_rr", "as_wh_rr")) %>%
  ggplot(data = ., aes(x = YEAR, y = value, color = legend_text)) +
  geom_line(size = 1, lineend = "round") +
  guides(color = guide_legend(title = "Racial Group", byrow = TRUE)) +
  scale_color_manual(values = three_colors,
                     labels = function(x) str_wrap(x, width = 20)) +
  xlim(1970, 2020) +
  ylim(-0.05, 4.25) +
  labs(title = "Out-of-School Suspension (OSS)",
       x = "Year",
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

socius_with_2020 <- plot_grid(
          plot_grid(oss_all_with_2020 + theme(legend.position = "hidden"),
                    oss_all_rr_with_2020 + theme(legend.position = "hidden",
                                                plot.title = element_blank()),
                    ncol = 1),
          plot_grid(cp_all_with_2020_fixed + theme(legend.position = "hidden"),
                    cp_all_rr_with_2020_fixed + theme(legend.position = "hidden",
                                                      plot.title = element_blank()),
                    ncol = 1),
          plot_grid(racial_group_legend,
                    rr_legend,
                    ncol = 1),
          ncol = 3, rel_widths = c(1, 1, 0.4375))

ggsave(plot = socius_with_2020, filename = "Exports//socius_all_states_all_years_with_2020.pdf", 
       device = cairo_pdf, width = 8, height = 5, units = "in")

ggsave(plot = socius_with_2020, filename = "Exports//socius_all_states_all_years_with_2020.png", 
       width = 8, height = 5, units = "in", dpi = 600, bg = "white")

ggsave(plot = socius_with_2020, filename = "Exports//socius_all_states_all_years_with_2020.jpeg", 
       width = 8, height = 5, units = "in", dpi = 600, bg = "white")
