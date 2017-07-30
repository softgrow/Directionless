# Directionless
Govhack 2017 - Deep analysis of Bluetooth traffic data

## Files to look at
* 0916.csv - a CSV file containing a list of road segments
** From the left
** Intersection From
** Intersection To
** 1st (busiest destination)
** 2nd (2nd busiest destination)

The average time for each stream of traffic is shown, along with the number of vehicles for:
* As a whole
* Busiest destination
* Second busiest destination
* ..

* get_data.sh - script to automate downloading and processing data
* *.pl - Perl programs to manipulate data
* logo* - our project logo

# Prequesites
* Needs a shell
* Perl
* Internet connection to download raw data and intermediate files
