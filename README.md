# w4_GCDCP

## Before running the script
- In the same directory as **run_analysis.R**, create a new directory named **data**
- Download the data file from [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)
- Unzip the downloaded file to **data** directory (you should have **./data/UCI HAR Dataset/** after this step)

### If you wish to do this in one step
- In the same directory as **run_analysis.R**, open terminal and run the following command

```mkdir data && curl "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip" --output "UCIHARDATASET.zip" && unzip UCIHARDATASET.zip -d data```


## Running the script from Command Line
  ```Rscript run_analysis.R```

## Data processing are separated into following 3 steps (additional comments are in the script file)
- Reading metadata and measurement data into data frame
- Attributes filtering
- Data transformation by binding row and columns, melting, and grouping