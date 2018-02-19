# Installing KNIME

KNIME is a workflow engine we will use with OpenMS. Here are the installation steps:

```Bash
# Download the latest linux build
wget https://download.knime.org/analytics-platform/linux/knime-latest-linux.gtk.x86_64.tar.gz

# Extract from .tar.gz
tar -xvzf knime_3.5.2.linux.gtk.x86_64.tar.gz
# Move to ~/Development folder if not there
mv -rf knime_3.5.2 ~/Development/
# Get into the folder downloaded
cd knime_3.5.2
# run the knime
./knime
```

It will ask to give a workspace path. I chose to put it in the Development as well. ```/home/eneskemal/Development/knime-workspace```


After opening the KNIME, we should add the OpenMS extension to KNIME:

1. Go to __File__ tab.
2. Click __install KNIME extensions...__
3. Select the OpenMS under   _KNIME Community Contributions - Bioinformatics & NGS_
4. Follow the instructions. After the installation is done the KNIME will restart.


I also saved the KNIME softare into the Launcher so that I can reach it without typing ```./knime``` in the source folder everytime.
