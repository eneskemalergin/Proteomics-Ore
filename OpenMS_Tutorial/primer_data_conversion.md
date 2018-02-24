# Data Conversion


OpenMS can handle number of formats however to make things smooth with least error possible OpenMS encourages us to use mzML[1]. mzML is an open format that combined the best aspects of predecessors mzData and mzXML with a collaborative effort of [HUPO-PSI](http://www.psidev.info/) and [SPC](http://tools.proteomecenter.org/software.php) So we want to convert our data format to mzML, if it's not already in that format. For the conversion the OpenMS tutorial suggests using _MSConvert_ which is a tool part of _ProteoWizard_ package. The tutorial also says that due to restrictions from the instrument vendors file format conversion is only possible on Windows, which I am sure there is a way for us open-source users to solve. Here is the solution; in the ubuntu's own package servers they include ProteoWizard package[2]. We can simply install the package with the following command:

```Bash
sudo apt install libpwiz-tools
```

In Windows there is a graphical user interface version of the convertion tool ```MSConvertGUI``` however for Ubuntu there is only command line version available, which is more than enough for me. I can access the command just by typing ```msconvert``` on my ubuntu system after installing ```libpwiz-tools```. Now let's run an example conversion. I couldn't add the data into the github repository because of the size restrictions however I could reference the source of the data in the README.

The good thing about the ```msconvert``` command line tool is that we can use it in the bash scripts allowing to include in a larger scale automated analysis.

```Bash
# Will print all options and information
msconvert --help

# Assuming 

```






## References

1. Deutsch, E. W. Mass Spectrometer Output File Format mzML. _Methods in Molecular Biology Proteome Bioinformatics 319–331 (2009)_. doi:10.1007/978-1-60761-444-9_22
2. ProteoWizard command line tools. Launchpad Available at: https://launchpad.net/ubuntu/xenial/ package/libpwiz-tools. (Accessed: 23rd February 2018)
3.
