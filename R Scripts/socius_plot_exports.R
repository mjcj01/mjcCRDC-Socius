library(tidyverse)

ggsave(plot = socius_with_2020, filename = "Exports//socius_all_states_all_years_with_2020.pdf", 
       device = cairo_pdf, width = 8, height = 5, units = "in")

ggsave(plot = socius_with_2020, filename = "Exports//socius_all_states_all_years_with_2020.png", 
       width = 8, height = 5, units = "in", dpi = 600, bg = "white")

ggsave(plot = socius_with_2020, filename = "Exports//socius_all_states_all_years_with_2020.jpeg", 
       width = 8, height = 5, units = "in", dpi = 600, bg = "white")



ggsave(plot = all_states, filename = "Exports//socius_all_states_all_years.pdf", 
       device = cairo_pdf, width = 8, height = 3, units = "in")

ggsave(plot = all_states, filename = "Exports//socius_all_states_all_years.png", 
       width = 8, height = 3, units = "in", dpi = 600, bg = "white")

ggsave(plot = all_states, filename = "Exports//socius_all_states_all_years.jpeg", 
       width = 8, height = 3, units = "in", dpi = 600, bg = "white")

ggsave(plot = all_states_rr, filename = "Exports//socius_all_states_all_years_rr.pdf", 
       device = cairo_pdf, width = 8, height = 4, units = "in")

ggsave(plot = all_states_rr, filename = "Exports//socius_all_states_all_years_rr.png", 
       width = 8, height = 5, units = "in", dpi = 600, bg = "white")

ggsave(plot = all_states_rr, filename = "Exports//socius_all_states_all_years_rr.jpeg", 
       width = 8, height = 5, units = "in", dpi = 600, bg = "white")

ggsave(plot = all_states_rr_rd, filename = "Exports//socius_all_states_all_years_rr_rd.pdf", 
       device = cairo_pdf, width = 8, height = 6, units = "in")

ggsave(plot = all_states_rr_rd, filename = "Exports//socius_all_states_all_years_rr_rd.png", 
       width = 8, height = 5, units = "in", dpi = 600, bg = "white")

ggsave(plot = all_states_rr_rd, filename = "Exports//socius_all_states_all_years_rr_rd.jpeg", 
       width = 8, height = 5, units = "in", dpi = 600, bg = "white")



ggsave(plot = socius_combined_always, filename = "Exports//socius_always_legal_all_years.pdf", 
       device = cairo_pdf, width = 8, height = 5, units = "in")

ggsave(plot = socius_combined_always, filename = "Exports//socius_always_legal_all_years.png", 
       width = 8, height = 5, units = "in", dpi = 600, bg = "white")

ggsave(plot = socius_combined_always, filename = "Exports//socius_always_legal_all_years.jpeg", 
       width = 8, height = 5, units = "in", dpi = 600, bg = "white")



ggsave(plot = socius_combined_universe, filename = "Exports//socius_all_states_universe_years.pdf", 
       device = cairo_pdf, width = 8, height = 5, units = "in")

ggsave(plot = socius_combined_universe, filename = "Exports//socius_all_states_universe_years.png", 
       width = 8, height = 5, units = "in", dpi = 600, bg = "white")

ggsave(plot = socius_combined_universe, filename = "Exports//socius_all_states_universe_years.jpeg", 
       width = 8, height = 5, units = "in", dpi = 600, bg = "white")



ggsave(plot = socius_combined_always_universe, filename = "Exports//socius_always_legal_universe_years.pdf", 
       device = cairo_pdf, width = 8, height = 4, units = "in")

ggsave(plot = socius_combined_always_universe, filename = "Exports//socius_always_legal_universe_years.png", 
       width = 8, height = 4, units = "in", dpi = 600, bg = "white")

ggsave(plot = socius_combined_always_universe, filename = "Exports//socius_always_legal_universe_years.jpeg", 
       width = 8, height = 4, units = "in", dpi = 600, bg = "white")
