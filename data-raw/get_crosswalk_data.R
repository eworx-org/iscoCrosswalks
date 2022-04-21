onet_data <- "https://www.onetcenter.org/dl_files/OccupationalListings.zip"
dest_file <- "data-raw/onet_classification/OccupationalListings.zip"

download.file(onet_data, dest_file)
unzip(dest_file, exdir = "data-raw/onet_classification")

crosswalks_data <-
  "https://ibs.org.pl/app/uploads/2016/04/onetsoc_to_isco_cws_ibs.zip"
dest_file <- "data-raw/stata_dset/onetsoc_to_isco_cws_ibs.zip"
download.file(crosswalks_data, dest_file)
unzip(dest_file, exdir = "data-raw/stata_dset/")
