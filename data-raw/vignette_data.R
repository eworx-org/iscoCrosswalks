library(data.table)

foundation_skills <- fread("data-raw/foundation_skills.csv")
foundation_skills <- fread(csv_path, dec = ",")
foundation_skills[, `ISCO code` := as.character(`ISCO code`)]
foundation_skills <- merge(foundation_skills, isco,
                           by.x = "ISCO code", by.y = "code")
foundation_skills <- foundation_skills[, .(Occupations, preferredLabel, Skill, Value)]
usethis::use_data(foundation_skills, overwrite = TRUE)
