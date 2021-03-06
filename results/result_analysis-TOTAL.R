library("xlsx")
library("ggplot2")
library("sets")
library("keras")
library("stringr")
#install.packages("xlsx")

setwd("D:/Usuarios/cvazquezlos/GitHub/Genetic-programming-for-Artificial-Neural-Networks/results")
#setwd("~/GitHub/Evolutionary-Approaches-for-Artificial-Neural-Networks/results")

TARGET_FOLDER <- "./classification/iris/total"

# Analysis of the resulting dataframes for each execution
BASE_DATA_FRAME <- data.frame(architecture = character(),
                              saved_model = character(),
                              acc_train = double(),
                              acc_validation = double(),
                              acc_test = double(),
                              stringsAsFactors = FALSE)
executions <- list.files(TARGET_FOLDER)

executions_results <- BASE_DATA_FRAME
y <- lapply(executions, function (x) {
  df = readRDS(paste0(TARGET_FOLDER, "/", x, "/execution_results.rds"))
  executions_results <<- rbind(executions_results, df[,c("architecture", "saved_model", "acc_train", "acc_validation", "acc_test")])
})
rm("y")
executions_results$architecture <- as.character(executions_results$architecture)
executions_results$architecture <- gsub("_", "/", executions_results$architecture)
executions_results$saved_model <- NULL
analysis_results <- aggregate(executions_results[,c(1:4)], 
                              by = list(executions_results$architecture), 
                              FUN = sd)
analysis_results$architecture <- NULL
colnames(analysis_results) <- c("architecture", "acc_train", "acc_validation", "acc_test")
analysis_results$architecture <- gsub("_", "/", analysis_results$architecture)
analysis_results$percentage <- unlist(lapply(analysis_results$architecture, function(x) {
  round((nrow(executions_results[executions_results$architecture == x,])/nrow(executions_results) * 100), 2)
}))
analysis_results <- analysis_results[order(analysis_results$percentage, decreasing = TRUE),]
row.names(analysis_results) <- c(1:nrow(analysis_results))
write.csv(analysis_results, file = "../results/classification/iris/executions_results_total_SD.csv")
write.xlsx(analysis_results, file = "../results/classification/iris/executions_results_total_SD.xlsx")

# Plotting the executions
executions_plotting_data <- data.frame(generation = c(1:29), stringsAsFactors = F)
z <- lapply(c(1:80), function(x) {
  df = readRDS(paste0("../results/classification/iris/total/", x, "/", x, "_results.rds"))[, c(2:3)]
  n_colnames = c(paste0("avg_loss", x), paste0("best_loss", x))
  colnames(df) = n_colnames
  n = nrow(df)
  if (n != 29) {
    remaining_rows = 29 - n
    aux = data.frame(col1 = rep(NA, remaining_rows), col2 = rep(NA, remaining_rows), stringsAsFactors = F)
    colnames(aux) = n_colnames
    df = rbind(df, aux)
  }
  df[,paste0("avg_loss", x)] = as.double(df[,paste0("avg_loss", x)])
  df[,paste0("best_loss", x)] = as.double(df[,paste0("best_loss", x)])
  executions_plotting_data <<- cbind(executions_plotting_data, df)
})

avg_selected_cols <- colnames(executions_plotting_data)[c(FALSE, TRUE)]
best_selected_cols <- tail(colnames(executions_plotting_data)[c(TRUE, FALSE)], -1)

avg_loss_mean <- rowMeans(executions_plotting_data[,avg_selected_cols], na.rm = TRUE)
best_loss_mean <- rowMeans(executions_plotting_data[,best_selected_cols], na.rm = TRUE)
executions_plotting_data <- cbind(executions_plotting_data, avg_loss_mean)
executions_plotting_data <- cbind(executions_plotting_data, best_loss_mean)

executions_plot <- ggplot(data = executions_plotting_data, aes(x = generation)) +
  geom_point(aes(y = avg_loss1), shape = 20, colour = "gray") +
  geom_point(aes(y = avg_loss2), shape = 20, colour = "gray") +
  geom_point(aes(y = avg_loss3), shape = 20, colour = "gray") +
  geom_point(aes(y = avg_loss4), shape = 20, colour = "gray") +
  geom_point(aes(y = avg_loss5), shape = 20, colour = "gray") +
  geom_point(aes(y = avg_loss6), shape = 20, colour = "gray") +
  geom_point(aes(y = avg_loss7), shape = 20, colour = "gray") +
  geom_point(aes(y = avg_loss8), shape = 20, colour = "gray") +
  geom_point(aes(y = avg_loss9), shape = 20, colour = "gray") +
  geom_point(aes(y = avg_loss10), shape = 20, colour = "gray") +
  geom_point(aes(y = avg_loss11), shape = 20, colour = "gray") +
  geom_point(aes(y = avg_loss12), shape = 20, colour = "gray") +
  geom_point(aes(y = avg_loss13), shape = 20, colour = "gray") +
  geom_point(aes(y = avg_loss14), shape = 20, colour = "gray") +
  geom_point(aes(y = avg_loss15), shape = 20, colour = "gray") +
  geom_point(aes(y = avg_loss16), shape = 20, colour = "gray") +
  geom_point(aes(y = avg_loss17), shape = 20, colour = "gray") +
  geom_point(aes(y = avg_loss18), shape = 20, colour = "gray") +
  geom_point(aes(y = avg_loss19), shape = 20, colour = "gray") +
  geom_point(aes(y = avg_loss20), shape = 20, colour = "gray") +
  geom_point(aes(y = avg_loss21), shape = 20, colour = "gray") +
  geom_point(aes(y = avg_loss22), shape = 20, colour = "gray") +
  geom_point(aes(y = avg_loss23), shape = 20, colour = "gray") +
  geom_point(aes(y = avg_loss24), shape = 20, colour = "gray") +
  geom_point(aes(y = avg_loss25), shape = 20, colour = "gray") +
  geom_point(aes(y = avg_loss26), shape = 20, colour = "gray") +
  geom_point(aes(y = avg_loss27), shape = 20, colour = "gray") +
  geom_point(aes(y = avg_loss28), shape = 20, colour = "gray") +
  geom_point(aes(y = avg_loss29), shape = 20, colour = "gray") +
  geom_point(aes(y = avg_loss30), shape = 20, colour = "gray") +
  geom_point(aes(y = avg_loss31), shape = 20, colour = "gray") +
  geom_point(aes(y = avg_loss32), shape = 20, colour = "gray") +
  geom_point(aes(y = avg_loss33), shape = 20, colour = "gray") +
  geom_point(aes(y = avg_loss34), shape = 20, colour = "gray") +
  geom_point(aes(y = avg_loss35), shape = 20, colour = "gray") +
  geom_point(aes(y = avg_loss36), shape = 20, colour = "gray") +
  geom_point(aes(y = avg_loss37), shape = 20, colour = "gray") +
  geom_point(aes(y = avg_loss38), shape = 20, colour = "gray") +
  geom_point(aes(y = avg_loss39), shape = 20, colour = "gray") +
  geom_point(aes(y = avg_loss40), shape = 20, colour = "gray") +
  geom_point(aes(y = avg_loss41), shape = 20, colour = "gray") +
  geom_point(aes(y = avg_loss42), shape = 20, colour = "gray") +
  geom_point(aes(y = avg_loss43), shape = 20, colour = "gray") +
  geom_point(aes(y = avg_loss44), shape = 20, colour = "gray") +
  geom_point(aes(y = avg_loss45), shape = 20, colour = "gray") +
  geom_point(aes(y = avg_loss46), shape = 20, colour = "gray") +
  geom_point(aes(y = avg_loss47), shape = 20, colour = "gray") +
  geom_point(aes(y = avg_loss48), shape = 20, colour = "gray") +
  geom_point(aes(y = avg_loss49), shape = 20, colour = "gray") +
  geom_point(aes(y = avg_loss50), shape = 20, colour = "gray") +
  geom_point(aes(y = avg_loss51), shape = 20, colour = "gray") +
  geom_point(aes(y = avg_loss52), shape = 20, colour = "gray") +
  geom_point(aes(y = avg_loss53), shape = 20, colour = "gray") +
  geom_point(aes(y = avg_loss54), shape = 20, colour = "gray") +
  geom_point(aes(y = avg_loss55), shape = 20, colour = "gray") +
  geom_point(aes(y = avg_loss56), shape = 20, colour = "gray") +
  geom_point(aes(y = avg_loss57), shape = 20, colour = "gray") +
  geom_point(aes(y = avg_loss58), shape = 20, colour = "gray") +
  geom_point(aes(y = avg_loss59), shape = 20, colour = "gray") +
  geom_point(aes(y = avg_loss60), shape = 20, colour = "gray") +
  geom_point(aes(y = avg_loss61), shape = 20, colour = "gray") +
  geom_point(aes(y = avg_loss62), shape = 20, colour = "gray") +
  geom_point(aes(y = avg_loss63), shape = 20, colour = "gray") +
  geom_point(aes(y = avg_loss64), shape = 20, colour = "gray") +
  geom_point(aes(y = avg_loss65), shape = 20, colour = "gray") +
  geom_point(aes(y = avg_loss66), shape = 20, colour = "gray") +
  geom_point(aes(y = avg_loss67), shape = 20, colour = "gray") +
  geom_point(aes(y = avg_loss68), shape = 20, colour = "gray") +
  geom_point(aes(y = avg_loss69), shape = 20, colour = "gray") +
  geom_point(aes(y = avg_loss70), shape = 20, colour = "gray") +
  geom_point(aes(y = avg_loss71), shape = 20, colour = "gray") +
  geom_point(aes(y = avg_loss72), shape = 20, colour = "gray") +
  geom_point(aes(y = avg_loss73), shape = 20, colour = "gray") +
  geom_point(aes(y = avg_loss74), shape = 20, colour = "gray") +
  geom_point(aes(y = avg_loss75), shape = 20, colour = "gray") +
  geom_point(aes(y = avg_loss76), shape = 20, colour = "gray") +
  geom_point(aes(y = avg_loss77), shape = 20, colour = "gray") +
  geom_point(aes(y = avg_loss78), shape = 20, colour = "gray") +
  geom_point(aes(y = avg_loss79), shape = 20, colour = "gray") +
  geom_point(aes(y = avg_loss80), shape = 20, colour = "gray") +
  geom_point(aes(y = best_loss1), shape = 20, colour = "gray") +
  geom_point(aes(y = best_loss2), shape = 20, colour = "gray") +
  geom_point(aes(y = best_loss3), shape = 20, colour = "gray") +
  geom_point(aes(y = best_loss4), shape = 20, colour = "gray") +
  geom_point(aes(y = best_loss5), shape = 20, colour = "gray") +
  geom_point(aes(y = best_loss6), shape = 20, colour = "gray") +
  geom_point(aes(y = best_loss7), shape = 20, colour = "gray") +
  geom_point(aes(y = best_loss8), shape = 20, colour = "gray") +
  geom_point(aes(y = best_loss9), shape = 20, colour = "gray") +
  geom_point(aes(y = best_loss10), shape = 20, colour = "gray") +
  geom_point(aes(y = best_loss11), shape = 20, colour = "gray") +
  geom_point(aes(y = best_loss12), shape = 20, colour = "gray") +
  geom_point(aes(y = best_loss13), shape = 20, colour = "gray") +
  geom_point(aes(y = best_loss14), shape = 20, colour = "gray") +
  geom_point(aes(y = best_loss15), shape = 20, colour = "gray") +
  geom_point(aes(y = best_loss16), shape = 20, colour = "gray") +
  geom_point(aes(y = best_loss17), shape = 20, colour = "gray") +
  geom_point(aes(y = best_loss18), shape = 20, colour = "gray") +
  geom_point(aes(y = best_loss19), shape = 20, colour = "gray") +
  geom_point(aes(y = best_loss20), shape = 20, colour = "gray") +
  geom_point(aes(y = best_loss21), shape = 20, colour = "gray") +
  geom_point(aes(y = best_loss22), shape = 20, colour = "gray") +
  geom_point(aes(y = best_loss23), shape = 20, colour = "gray") +
  geom_point(aes(y = best_loss24), shape = 20, colour = "gray") +
  geom_point(aes(y = best_loss25), shape = 20, colour = "gray") +
  geom_point(aes(y = best_loss26), shape = 20, colour = "gray") +
  geom_point(aes(y = best_loss27), shape = 20, colour = "gray") +
  geom_point(aes(y = best_loss28), shape = 20, colour = "gray") +
  geom_point(aes(y = best_loss29), shape = 20, colour = "gray") +
  geom_point(aes(y = best_loss30), shape = 20, colour = "gray") +
  geom_point(aes(y = best_loss31), shape = 20, colour = "gray") +
  geom_point(aes(y = best_loss32), shape = 20, colour = "gray") +
  geom_point(aes(y = best_loss33), shape = 20, colour = "gray") +
  geom_point(aes(y = best_loss34), shape = 20, colour = "gray") +
  geom_point(aes(y = best_loss35), shape = 20, colour = "gray") +
  geom_point(aes(y = best_loss36), shape = 20, colour = "gray") +
  geom_point(aes(y = best_loss37), shape = 20, colour = "gray") +
  geom_point(aes(y = best_loss38), shape = 20, colour = "gray") +
  geom_point(aes(y = best_loss39), shape = 20, colour = "gray") +
  geom_point(aes(y = best_loss40), shape = 20, colour = "gray") +
  geom_point(aes(y = best_loss41), shape = 20, colour = "gray") +
  geom_point(aes(y = best_loss42), shape = 20, colour = "gray") +
  geom_point(aes(y = best_loss43), shape = 20, colour = "gray") +
  geom_point(aes(y = best_loss44), shape = 20, colour = "gray") +
  geom_point(aes(y = best_loss45), shape = 20, colour = "gray") +
  geom_point(aes(y = best_loss46), shape = 20, colour = "gray") +
  geom_point(aes(y = best_loss47), shape = 20, colour = "gray") +
  geom_point(aes(y = best_loss48), shape = 20, colour = "gray") +
  geom_point(aes(y = best_loss49), shape = 20, colour = "gray") +
  geom_point(aes(y = best_loss50), shape = 20, colour = "gray") +
  geom_point(aes(y = best_loss51), shape = 20, colour = "gray") +
  geom_point(aes(y = best_loss52), shape = 20, colour = "gray") +
  geom_point(aes(y = best_loss53), shape = 20, colour = "gray") +
  geom_point(aes(y = best_loss54), shape = 20, colour = "gray") +
  geom_point(aes(y = best_loss55), shape = 20, colour = "gray") +
  geom_point(aes(y = best_loss56), shape = 20, colour = "gray") +
  geom_point(aes(y = best_loss57), shape = 20, colour = "gray") +
  geom_point(aes(y = best_loss58), shape = 20, colour = "gray") +
  geom_point(aes(y = best_loss59), shape = 20, colour = "gray") +
  geom_point(aes(y = best_loss60), shape = 20, colour = "gray") +
  geom_point(aes(y = best_loss61), shape = 20, colour = "gray") +
  geom_point(aes(y = best_loss62), shape = 20, colour = "gray") +
  geom_point(aes(y = best_loss63), shape = 20, colour = "gray") +
  geom_point(aes(y = best_loss64), shape = 20, colour = "gray") +
  geom_point(aes(y = best_loss65), shape = 20, colour = "gray") +
  geom_point(aes(y = best_loss66), shape = 20, colour = "gray") +
  geom_point(aes(y = best_loss67), shape = 20, colour = "gray") +
  geom_point(aes(y = best_loss68), shape = 20, colour = "gray") +
  geom_point(aes(y = best_loss69), shape = 20, colour = "gray") +
  geom_point(aes(y = best_loss70), shape = 20, colour = "gray") +
  geom_point(aes(y = best_loss71), shape = 20, colour = "gray") +
  geom_point(aes(y = best_loss72), shape = 20, colour = "gray") +
  geom_point(aes(y = best_loss73), shape = 20, colour = "gray") +
  geom_point(aes(y = best_loss74), shape = 20, colour = "gray") +
  geom_point(aes(y = best_loss75), shape = 20, colour = "gray") +
  geom_point(aes(y = best_loss76), shape = 20, colour = "gray") +
  geom_point(aes(y = best_loss77), shape = 20, colour = "gray") +
  geom_point(aes(y = best_loss78), shape = 20, colour = "gray") +
  geom_point(aes(y = best_loss79), shape = 20, colour = "gray") +
  geom_point(aes(y = best_loss80), shape = 20, colour = "gray") +
  geom_line(aes(y = avg_loss_mean, colour = "Media"), size = 1) +
  geom_line(aes(y = best_loss_mean, colour = "Mejores"), size = 1) +
  xlab("Generaciones") +
  scale_x_continuous(breaks = seq(1, 29, 2)) +
  ylab("Categorical cross-entropy") +
  scale_y_continuous(breaks = c(0.0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0,1.1,1.2,1.3,1.4,1.5)) +
  scale_colour_manual("Individuos", values = c("Media" = "red", "Mejores" = "blue")) +
  ggtitle("Entrenamiento total de los individuos") + 
  theme_classic() + 
  theme(
    panel.grid.minor = element_blank(),
    panel.grid.major = element_line(colour = "#E8E8E8"),
    text = element_text(size = 20, family = "Cambria"),
    plot.title = element_text(family = "Cambria", size = 25, hjust = 0.5, margin = margin(0, 0, 25, 0))
  )
print(executions_plot)
