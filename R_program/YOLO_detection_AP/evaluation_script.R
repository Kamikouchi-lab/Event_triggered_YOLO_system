library(ggplot2)
library("ggsignif")
library(tidyverse)
library(RVAideMemoire)

text_label_of_legend_50 <- c("AP50 of copulation",
                           "AP50 of solo",
                           "mAP50")

text_label_of_legend_75 <- c("AP75 of copulation",
                             "AP75 of solo",
                             "mAP75")

Setting <- list(theme(plot.margin = unit(c(1, 1, 1, 1), "lines")),
                theme_classic(),
                theme(axis.title.y = element_text(size = 15, vjust = 2)),
                theme(axis.title.x = element_text(size = 15)),
                theme(axis.text.y = element_text(size = 15, colour = "black")),
                scale_y_continuous(limits = c(0.5, 1), breaks = seq(0.5, 1, 0.25), expand = c(0, 0)),
                scale_x_continuous(limits = c(0, 2100), breaks = seq(0, 2000, 500), expand = c(0, 0)),
                theme(axis.text.x = element_text(size = 15, colour = "black")),
                theme(legend.position = "right"))


df_evaluation <- readr::read_csv("evaluation_data_for_models.csv")
print(df_evaluation)

df_evaluation_long = df_evaluation %>%
  pivot_longer(cols = c('AP50_cop', 'AP50_solo', 'mAP50', 'AP75_cop', 'AP75_solo', 'mAP75'),
               names_to = "AP_list",
               values_to = "AP_value")

df_ap50<- df_evaluation_long %>%
  filter(AP_list %in% c('AP50_cop', 'AP50_solo', 'mAP50'))
head(df_ap50)

df_ap75 <- df_evaluation_long %>%
  filter(AP_list %in% c('AP75_cop', 'AP75_solo', 'mAP75'))
head(df_ap75)




gp1 = ggplot(data = df_ap50, aes(x = training_frames, y = AP_value, color = AP_list)) + 
  geom_point() +
  geom_line()+
  labs(title="AP50", x = "Training images", y = "Value")+
  scale_color_discrete(name = element_blank(), labels = text_label_of_legend_50)+
  Setting
gp1

gp2 = ggplot(data = df_ap75, aes(x = training_frames, y = AP_value, color = AP_list)) + 
  geom_point() +
  geom_line()+
  labs(title="AP75", x = "Training images", y = "Value")+
  scale_color_discrete(name = element_blank(), labels = text_label_of_legend_75)+
  Setting
gp2


# install.packages("gridExtra")
library(gridExtra)
g1 <- ggplotGrob(gp1)
g2 <- ggplotGrob(gp2)
g <- rbind(g1, g2, size = "first")
g$widths = grid::unit.pmax(g1$widths, g2$widths)
plot(g)

# install.packages("cowplot")
library(cowplot)
gp3 = plot_grid(gp1, gp2)


ggsave("./model_evaluation.png", g, width = 5, height = 5, dpi = 500)