# Makefile
# Ian Flores, Betty Zhou
#
# This Makefile generates all data files, figures and report of the San Francisco
# Crime Resolution Model Project.
#
# Usage:
# To run all sripts: make all
# To clean all outputs: make clean

# run all scripts
all : data/san_francisco_clean.csv results/figures/ results/figures/SF_crime.png data/san_francisco_features.csv data/feature_results.csv docs/san_francisco_report.md

# downloads data from the SF portal API, cleans it, and saves it as a CSV file.
data/san_francisco_clean.csv : src/01_clean_data.py
	python src/01_clean_data.py 100000 data/san_francisco_clean.csv

# generates exploratory data analysis figures
results/figures/ : src/02_EDA.py data/san_francisco_clean.csv
	python src/02_EDA.py data/san_francisco_clean.csv results/figures/

# generates a map of San Francisco with crime density overlayed on top as a png output
results/figures/SF_crime.png : src/03_Exploratory_SF_map.R data/san_francisco_clean.csv
	Rscript src/03_Exploratory_SF_map.R data/san_francisco_clean.csv results/figures/

# extracts and formats the features necessary for the Decision Tree Classifier
data/san_francisco_features.csv : src/03_feature_engineering.py data/san_francisco_clean.csv
	python src/03_feature_engineering.py data/san_francisco_clean.csv data/san_francisco_features.csv

# trains the Decision Tree Classifier.
data/feature_results.csv : src/04_decison_tree.py data/san_francisco_features.csv
	python src/04_decison_tree.py data/san_francisco_features.csv data/feature_results.csv

# generates the final report
docs/san_francisco_report.md : results/figures/ data/
	Rscript -e "rmarkdown::render('docs/san_francisco_report.Rmd')"

# clean all output of makefile
clean :
	rm -f results/figures/*.png
	rm -f data/*.csv
	rm docs/san_francisco_report.md