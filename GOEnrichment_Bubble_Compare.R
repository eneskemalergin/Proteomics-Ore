args = commandArgs(trailingOnly=TRUE)

suppressMessages(library(tidyverse))
suppressMessages(library(cowplot))

# test if there is at least one argument: if not, return an error
if (length(args)==0) {
  stop("At least two arguments must be supplied (input file).n", call.=FALSE)
} else if (length(args)>3) {
  stop("More than two arguments passed, only input file is required...", call.=FALSE)
}

# Take the first argument from terminal call and pass it to a variable
inp1_path <- args[1]
inp2_path <- args[2]
# Select file name from full path
file1_name <- tail(unlist(strsplit(inp1_path, '/')), n=1)
file2_name <- tail(unlist(strsplit(inp2_path, '/')), n=1)
# select sample name from full path
# samp_name <- tail(unlist(strsplit(file_name, '_')), n=1)
# Create output path
output1_path <- paste0(unlist(strsplit(inp1_path, '.tsv')), '.png')
output2_path <- paste0(unlist(strsplit(inp2_path, '.tsv')), '.png')

# Read the tab seperated data with header provided
human_data <- read.csv(inp1_path, header=TRUE, sep="\t")

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



# Read the tab seperated data with header provided
pdx_data <- read.csv(inp2_path, header=TRUE, sep="\t")

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
    ggplot(aes(x=Enrichment, y=FDR.q.value, size=GeneCount, label=Description)) +
      geom_point(alpha=0.7, aes(color=Interested)) +
      scale_color_manual(values=c('#C0C0C0', '#E4001B')) +
      geom_text_repel(data = subset(human_data, Interested),
                      size = 5,
                      segment.size = 0.2,
                      segment.colour = 'grey50',
                      box.padding = unit(0.35, "lines"),
                      point.padding = unit(0.3, "lines"),
                      nudge_x = 10 - subset(human_data, Interested)$Interested) +
      theme_cowplot() +
      labs(title='GOEnrichment Summary - Human',
           x='Enrichment',
           y='Log FDR q-value',
           size= 'Number of Genes',
           color= 'GO Term of Interest')

  pdx_plot <- pdx_data %>%
    ggplot(aes(x=Enrichment, y=FDR.q.value, size=GeneCount, label=Description)) +
      geom_text_repel(data = subset(pdx_data, Interested),
                      size = 5,
                      segment.size = 0.2,
                      segment.colour = 'grey50',
                      box.padding = unit(0.35, "lines"),
                      point.padding = unit(0.3, "lines"),
                      nudge_x = 10 - subset(pdx_data, Interested)$Interested) +
      geom_point(alpha=0.7, aes(color=Interested)) +
      scale_color_manual(values=c('#C0C0C0', '#E4001B')) +
      theme_cowplot() +
      labs(title='GOEnrichment Summary - PDX',
           x='Enrichment',
           y='Log FDR q-value',
           size= 'Number of Genes',
           color= 'GO Term of Interest')

save_plot('./GOEnrichment_Compare_patientPDX.png',
          plot_grid(human_plot, pdx_plot),
          base_width = 18, base_height = 9)
