# OpenMS Installation on Ubuntu 16.04.03 LTS

> February 17 2018

This installation guide is for setting up the Core C++ Libraries for OpenMS.

Create a directory called Development to Home.
  - ```mkdir ~/Development```

For the time I am writing this, OpenMS folder name was ```OpenMS-2.3.0``` . Add that folder in Development folder we just created. __I will change the name of the folder to ```OpenMS``` for the sake of easiness to follow original instructions!!__

Install the the dependencies for ubuntu 16.04 from it's main repositories:

```Bash
sudo apt-get install build-essential cmake autoconf patch libtool automake
sudo apt-get install qt4-default libqtwebkit-dev
sudo apt-get install libeigen3-dev libwildmagic-dev \
      libxerces-c-dev libboost-all-dev libsvn-dev libgsl-dev libbz2-dev
```

For the other dependencies we will use contrib folder that comes with the source folder to install them.

```Bash
# in the ~/Development/
mkdir contrib-build
# Get inside the contrib-build folder
cd contrib-build

# Shows the list of make-able files from the source contrib file
cmake -DBUILD_TYPE=LIST ../OpenMS/contrib

# Then we build the files there are 2 options:
#  1: Build individually
#  2: Build them all

# Build individually:
# cmake -DBUILD_TYPE=SEQAN ../OpenMS/contrib
# cmake -DBUILD_TYPE=WILDMAGIC ../OpenMS/contrib
# cmake -DBUILD_TYPE=EIGEN ../OpenMS/contrib
# ...

# Build them all:
#   DNUMBER_OF_JOBS is number of threads to use
cmake -DBUILD_TYPE=ALL -DNUMBER_OF_JOBS=8 ../OpenMS/contrib
# Takes about 10 min with 8 threads
```

Now we will build the OpenMS

```Bash
# create a folder in ~/Development/
mkdir OpenMS-build
# Get inside the OpenMS-build flder
cd OpenMS-build

# Configure OpenMS with contrib libraries
cmake -DOPENMS_CONTRIB_LIBS="/home/eneskemal/Development/contrib-build/" -DBOOST_USE_STATIC=OFF -DCMAKE_PREFIX_PATH="/usr;/usr/local" ../OpenMS

# And now we need to build everything
make

# This will take a lot of time, so be ready to wait a lot...
```

After building OpenMS we have to configure the paths so that we can use it like out of the box every time. Adding the following to ```~/.bashrc``` will do the trick:


```Bash
# Adding the environment variable LD_LIBRARY_PATH to bashrc
export LD_LIBRARY_PATH="/home/eneskemal/Development/OpenMS-build/lib:$LD_LIBRARY_PATH"

# To use TOPP from everywhere we will add the bin folder to the main PATH
export PATH="/home/eneskemal/Development/OpenMS-build/bin:$PATH"
# This is necessary to use the TOPP tools from TOPPView

# After saving the changes to the .bashrc file re-run the file.
source ~/.bashrc
```

After these steps are done it will be ready to use. Just run the ```FileInfo``` command to see if it finds the command. If so that means the configuration is done. Let's run the final test to see everything build without an error.

```Bash
ctest -R TOPP_ -j 4
```
This command  will run number of test by running the script ~800 and will show the error or non-error ones.

Fin!
