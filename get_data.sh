set -u
set -x
# Get the data from Data.sa.gov.au
WANTED_DATA=bluetoothrecords.zip
if [ ! -f $WANTED_DATA ]
  then
    curl -o $WANTED_DATA https://data.sa.gov.au/data/dataset/611230b9-ef4d-4f58-aa5a-56e20222ffe8/resource/14141d46-6f74-4d09-b331-36ccaa5ec4a5/download/bluetoothrecords.zip
fi
# Sort the data how we want and make it smaller for sorting on small disks
SORTED_DATA=data.gz
if [ ! -f $SORTED_DATA ]
  then
    echo this will take about ten minutes, please be patient!
    unzip -p $WANTED_DATA | cut -c 1-4,6-7,9-10,12-13,15-16,18-19,27- \
      | sort -S 1G -t, -k 3 -k 1 | gzip -c > $SORTED_DATA
fi
# Get the site data
SITE_DATA=bluetoothsites.zip
if [ ! -f $SITE_DATA ]
  then
    curl -o $SITE_DATA https://data.sa.gov.au/data/dataset/54b072b7-ce24-48f5-9b57-e5e9bf380c00/resource/428f2fed-f206-4ade-8043-9597643ea2c8/download/bluetoothsites.zip
fi
# Get the triples
TRIPLES=triple_sorted.gz
if [ ! -f $TRIPLES ]
  then
    gzip -cd $SORTED_DATA > order.csv
    perl get_triples.pl | sort -S 2G | gzip -c > $TRIPLES
    rm order.csv
fi
