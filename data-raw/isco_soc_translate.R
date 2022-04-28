library(crosswalkR)
library(data.table)

isco_data <- fread("data-raw/europass_survey_custom_data.csv")
names(isco_data)
mandatory_cols <- c("job", "value")
setnames(isco_data, c("latest_job_isco3", "count"), mandatory_cols)
categorical_vars <- names(isco_data)[!names(isco_data) %in% mandatory_cols]

soc_data <- isco_soc_crosswalk(isco_data, soc_lvl = "soc_3",
                               brkd_cols = categorical_vars)

setnames(soc_data, "soc_label", "job")
soc_isco_crosswalk(soc_data,
                   soc_lvl = "soc_3",
                   isco_lvl = 3,
                   brkd_col = categorical_vars)

all(categorical_vars %in%names(soc_data))

fwrite(soc_data, file = "data-raw/soc_data.csv")