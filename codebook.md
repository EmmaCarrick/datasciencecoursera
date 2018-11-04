
#Codebook

###Processing
The following steps were performed on the data:

1 - download and extract from zip

2 - read into R assuming any whitespace as separator

3 - bind subject and label data as additional columns to each data set

4 - bind the data sets together

5 - discard columns that contain any of: min, max, Coeff, mad, sma, nergy, iqr, entropy, correl, skew, urtos, Freq

6 - substitutes activity keys for activity text

7 - renames columns according to the mapping in the associated file namemapping.txt

A file alldata.txt is created at this point

8 - groups data by subjects and activities

9 - calculates the grouped means

A file groupedmeans.txt is created at this point


###Data description
The included file namemapping.txt contains a mapping of original feature identifiers to column names. 