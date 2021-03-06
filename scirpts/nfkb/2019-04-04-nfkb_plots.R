### ###
### 2019-04-04 manuscript
### ###
library(SCRC)
library(future)


#### initiaialisation ####
force.run <- TRUE
output.path <- "../resources/nfkb/2019-04-12/"
dir.create(path = output.path,
           recursive = TRUE)

signal = "signal"
sample = "sample"
response.ts =
  c("0",  "3",  "6",  "9",
    "12", "15", "18", "21",
    "24", "27", "30", "33",
    "36", "39", "42", "45",
    "48", "51", "54", "57",
    "60")
response.tp18 =
  c("18")
parallel_cores = 8
bootstrap = TRUE
bootstrap.number = 64
bootstrap.sample_size = 1000

#### ITRC model ####
## ts
path.model_ts <- paste(output.path, "model_ts.RDS", sep = "/")
model.ts <- NULL
if(file.exists(path.model_ts)){
  model.ts <- readRDS(path.model_ts)
}
if(is.null(model.ts) | force.run){
#  plan(multiprocess)
  model.ts <-
    ITRC(
      data = ITRC::data.itrc.nfkb.all,
      signal = signal,
      sample = sample,
      response = response.ts,
      parallel_cores = parallel_cores,
      bootstrap.number = bootstrap.number,
      bootstrap = bootstrap,
      bootstrap.sample_size = bootstrap.sample_size,
      bootstrap.test.sample = TRUE,
      bootstrap.test.number = 4
    )
  saveRDS(object = model.ts,
          file = path.model_ts)
}
##tp18
path.model_tp18 <- paste(output.path, "model_tp18.RDS", sep = "/")
model.tp18 <- NULL
if(file.exists(path.model_tp18)){
  model.tp18 <- readRDS(path.model_tp18)
}
if(is.null(model.tp18) | force.run){
  model.tp18 <-
    ITRC(
      data = ITRC::data.itrc.nfkb.all,
      signal = signal,
      sample = sample,
      response = response.tp18,
      parallel_cores = parallel_cores,
      bootstrap.number = bootstrap.number,
      bootstrap = bootstrap,
      bootstrap.sample_size = bootstrap.sample_size
    )
  saveRDS(object = model.tp18,
          file = path.model_tp18)
}
#### ITRC plots ####
# col.rescaled <- "signal_rescaled"
# signals.rescale.df <-
#   rescaleSignalsValues.DataFrame(
#     model = model.ts,
#     col.to.rescale = model.ts$signal,
#     col.rescaled   = col.rescaled,
#     rescale.fun = function(x){log(x = x, base = 10)}
#   )

theme.signal <-
  ITRC::GetRescaledSignalTheme(
    model = model.ts,
    rescale.fun = function(x){log(x = x, base = 10)}
  )

g.nfkb.ts <-
  ITRC::plotITRCWaves(
    model = model.ts)

model.ts <-
  ComputeRC(model.ts,
           parallel_cores = 4,
           rc_type = "median")

model.ts <-
  ComputeRC(model.ts,
            parallel_cores = 4,
            rc_type = "median") <-
  ComputeRC(model.ts,
            parallel_cores = 4,
            rc_type = "mean")

model.ts$rc.sum_mean %>%
  dplyr::select_("signal", "`18`") %>%
  dplyr::rename(mean = `18`) %>%
  dplyr::left_join(
    model.ts$rc.sum_median %>%
      dplyr::select_("signal", "`18`") %>%
      dplyr::rename(median = `18`),
    by = "signal"
  ) ->
  rc.sum




g.nfkb.ts.comparison <-
  ITRC::plotITRCWaves.Comparison(
    model = model.ts,
    data = rc.sum,
    theme.signal  = theme.signal,
    variable.to.compare = "mean",
    variable.to.rescale = c("mean", "median"),
    pallete.args = list(option = "B", end = 0.75, begin = 0.25),
    theme.data.line = list(
      color = "red",
      linetype = 3,
      size = 1.5),
    theme.data.points = NULL
)
g.nfkb.ts.comparison

# g.nfkb.tp18 <-
#   ITRC::plotITRCWaves(
#     model = model.tp18)

#### ####
model.tp18$itrc %>%
  dplyr::left_join(
    theme.signal$signals.rescale.df,
    by = model.ts$signal) %>%
  dplyr::mutate(type = "itrc") ->
  model.tp18$itrc.rescaled

g.nfkb.ts.comparison +
  ggplot2::geom_line(
    data = model.tp18$itrc.rescaled,
    mapping = ggplot2::aes_string(
      x = theme.signal$col.rescaled,
      y = "itrc",
      group = "type"
    )
  ) +
  ggplot2::geom_point(
    data = model.tp18$itrc.rescaled,
    mapping = ggplot2::aes_string(
      x = theme.signal$col.rescaled,
      y = "itrc"
    )
  ) ->
  g.nfkb


ggplot2::ggsave(
  filename = paste(output.path, "nfkb_comparison_tstp.pdf", sep = "/"),
  plot = g.nfkb,
  width = 8,
  height = 6,
  useDingbats = FALSE
  )

#### #####
panel_tc <-
  data.frame(
    signal =c(0,0.01,0.03,0.1, 0.2, 0.5, 1, 2, 4, 10, 100),
    panel_row= c(1, 2, 3 , 4,  5,  6,  1,  2, 3, 4, 5),
    panel_col = c(1, 1, 1 , 1,  1,  1,  2,  2, 2, 2, 2)
  )

cm <- ITRC::plotCofusionMatrix(model = model.ts)
model.ts$data %>% tidyr::gather(colnames(model.ts$data)[-c(1,2)], key = "time", value = "response")  %>%
  dplyr::mutate(time = as.numeric(time)) %>%
  dplyr::left_join(panel_tc, by = "signal") ->
  data_tc


library(SCRC)
  
  library(ggplot2)
  
  library(tidyverse)

  g_traj <- ggplot(data_tc,
          aes(x = as.numeric(time), y = response, group = sample)) +
    geom_line(alpha = 0.01, size = 0.025) +
    facet_grid(panel_row ~ panel_col) + 
    SCRC::theme_scrc() +
    coord_cartesian(ylim = c(0,10))

  ggplot2::ggsave(
    filename = paste(output.path, "nfkb_cm.pdf", sep = "/"),
    plot = cm,
    width = 8,
    height = 8,
    useDingbats = FALSE
  )
  
  ggplot2::ggsave(
    filename = paste(output.path, "nfkb_traj.pdf", sep = "/"),
    plot = g_traj,
    width = 12,
    height = 8,
    useDingbats = FALSE
  )
  