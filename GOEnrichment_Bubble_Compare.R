## Purpose of this script is to create a GOEnrichment summary
##  plot for both PDX and Patient Data.
## Input Files:
##  - human_data_path
##  - pdx_data_path
## Output File:
##  - output_figure_path
##
## Author: Enes Kemal Ergin
## Date: October 31, 2018


## TODO: Because there is a mis-labeling that puts 'Yes' to Gene column,
## we are missing Genes that makes up the size of the bubbles. Since,
## there is only one value in Gene (Yes) it affects the size of the bubbles.
## Find a way to make it robust.

#args = commandArgs(trailingOnly=TRUE)


normalize <- function(x) {
  return ((x - min(x)) / (max(x) - min(x)))
}

suppressMessages(library(tidyverse))
suppressMessages(library(cowplot))
suppressMessages(library(ggrepel))

# test if there is at least one argument: if not, return an error
# if (length(args)==0) {
#   stop("At least two arguments must be supplied (input file).n", call.=FALSE)
# } else if (length(args)>3) {
#   stop("More than two arguments passed, only input file is required...", call.=FALSE)
# }

# # # Take the first argument from terminal call and pass it to a variable
# # inp1_path <- args[1]
# # inp2_path <- args[2]
# # Select file name from full path
# file1_name <- tail(unlist(strsplit(inp1_path, '/')), n=1)
# file2_name <- tail(unlist(strsplit(inp2_path, '/')), n=1)
# # select sample name from full path
# # samp_name <- tail(unlist(strsplit(file_name, '_')), n=1)
# # Create output path
# output1_path <- paste0(unlist(strsplit(inp1_path, '.tsv')), '.png')
# output2_path <- paste0(unlist(strsplit(inp2_path, '.tsv')), '.png')

# Human data path goes here
human_data_path <- './Data/PatientsOnly_GOPROCESS_EE.xls'
# Read the tab seperated data with header provided
human_data <- read.csv(human_data_path, header=TRUE, sep="\t")
# If there is a miss labeling put them to Highlight
human_data$Highlight[human_data$Genes == 'Yes'] <- 'Yes'
# Convert Factor column to character column
human_data$Genes <- as.character(human_data$Genes)
# Remove if there are yes in the Genes column, remove it with empty string
human_data$Genes[human_data$Genes == 'Yes'] <- 'No Gene'
#Take -log10 of the column FDR.q.value
human_data$FDR.q.value <- -log10(human_data$FDR.q.value)
# Order the dataframe by FDR.q.value column
human_data$Description <- factor(human_data$Description, levels=human_data$Description[order(human_data$FDR.q.value)])
# Convert factor column to character column
human_data$Genes <- as.character(human_data$Genes)
# Create genecount column
human_data <- human_data %>%
  mutate(GeneCount = str_count(Genes, ",") + 1 ) %>%
  mutate(Interested = ifelse(Highlight == 'Yes', TRUE, FALSE))

# PDX data path goes here
pdx_data_path <- './Data/PDXonly_GOPROCESS_EE.xls'
# Read the tab seperated data with header provided
pdx_data <- read.csv(pdx_data_path, header=TRUE, sep="\t")
# If there is a miss labeling put them to Highlight
pdx_data$Highlight[pdx_data$Genes == 'Yes'] <- 'Yes'
# Convert Factor column to character column
pdx_data$Genes <- as.character(pdx_data$Genes)
# Remove if there are yes in the Genes column, remove it with empty string
pdx_data$Genes[pdx_data$Genes == 'Yes'] <- 'No Gene'
#Take -log10 of the column FDR.q.value
pdx_data$FDR.q.value <- -log10(pdx_data$FDR.q.value)
# Order the dataframe by FDR.q.value column
pdx_data$Description <- factor(pdx_data$Description, levels=pdx_data$Description[order(pdx_data$FDR.q.value)])
# Convert factor column to character column
pdx_data$Genes <- as.character(pdx_data$Genes)
# Create genecount column
pdx_data <- pdx_data %>%
  mutate(GeneCount = str_count(Genes, ",") + 1 )  %>%
  mutate(Interested = ifelse(Highlight == 'Yes', TRUE, FALSE))

human_plot <- human_data %>%
  ggplot(aes(x=Enrichment, y=FDR.q.value, label=Description)) +
  geom_point(alpha=0.7, aes(color=Interested, size=GeneCount)) +
  scale_color_manual(values=c('#C0C0C0', '#E4001B')) +
  geom_text_repel(data = subset(human_data, Interested),
                  size = 8,
                  segment.size = 1,
                  segment.colour = 'grey50',
                  box.padding = unit(0.35, "lines"),
                  point.padding = unit(0.3, "lines"),
                  nudge_x = 10 - subset(human_data, Interested)$Interested) +
  theme_cowplot() +
  labs(title='GOEnrichment Summary - Human',
       x='Enrichment',
       y='Log FDR q-value',
       size= 'Number of Genes',
       color= 'GO Term of Interest') +
  scale_size(range = c(5, 12))

pdx_plot <- pdx_data %>%
  ggplot(aes(x=Enrichment, y=FDR.q.value, size=GeneCount, label=Description)) +
  geom_text_repel(data = subset(pdx_data, Interested),
                  size = 8,
                  segment.size = 1,
                  segment.colour = 'grey50',
                  box.padding = unit(0.35, "lines"),
                  point.padding = unit(0.3, "lines"),
                  nudge_x = 10 - subset(pdx_data, Interested)$Interested) +
  geom_point(alpha=0.7, aes(color=Interested, size=GeneCount)) +
  scale_color_manual(values=c('#C0C0C0', '#E4001B')) +
  theme_cowplot() +
  labs(title='GOEnrichment Summary - PDX',
       x='Enrichment',
       y='Log FDR q-value',
       size= 'Number of Genes',
       color= 'GO Term of Interest') +
  scale_size(range = c(5, 12))

output_figure_path <- './GOEnrichment_Compare_patientPDX.png'

save_plot(output_figure_path,
          plot_grid(human_plot, pdx_plot),
          base_height = 15, base_aspect_ratio = 3)