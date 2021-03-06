library("cowplot")
library("ggplot2")

HISTORIES_DIRECTORY <- "../results/classification/iris/partial/"

histories <- list.files(HISTORIES_DIRECTORY)
histories <- as.numeric(histories[!is.na(as.numeric(histories))])

final_populations <- data.frame(id = character(), 
                                architecture = character(), 
                                evaluated = character(), 
                                loss = character(), 
                                metric = character(), 
                                saved_model = character(), 
                                execution = character(),
                                stringsAsFactors = FALSE)
y <- lapply(histories, function(x) {
  aux = readRDS(paste0(HISTORIES_DIRECTORY, x, "/final_population.rds"))
  aux$execution = rep(x, nrow(aux))
  final_populations <<- rbind(final_populations, aux)
})

for (i in c(1:nrow(final_populations))) {
  row = final_populations[i,]
  aux = readRDS(paste0(HISTORIES_DIRECTORY, row$execution, "/history/", row$saved_model, ".rds"))
  aux = aux[aux$data == "training",]
  plot = ggplot(NULL, aes(epoch, value)) +
    geom_smooth(data = aux[aux$metric == "loss",], aes(colour = "Loss")) +
    geom_smooth(data = aux[aux$metric == "acc",], aes(colour = "Accuracy")) +
    scale_colour_manual("Métrica", values = c("Loss" = "red", "Accuracy" = "blue")) +
    xlab("Épocas") +
    ylab("Valor")
    ggtitle(paste0("Individuo ", row$architecture, " de la ejecución ", row$execution)) + theme_classic() + theme(plot.title = element_text(hjust = 0.5))
  save_plot(paste0(HISTORIES_DIRECTORY, "partially_training/", row$saved_model, "-", row$execution, ".png"), plot)
}
