# "https://data.rda.ucar.edu/d084001/2024/20241001/gfs.0p25.2024100100.f006.grib2"

# get current script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

get_date() {
    local offset=$1
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # For Linux systems
        date -u -d "-$offset days" +"%Y%m%d"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # For macOS systems
        date -u -v -"${offset}"d +"%Y%m%d"
    else
        echo "Unsupported OS type: $OSTYPE" >&2
        exit 1
    fi
}

mkdir output

# get date from today to a year ago
for i in {1..364}
do
    date_str=$(get_date "$i")
    echo $date_str
    # get year, month, day
    year=${date_str:0:4}
    month=${date_str:4:2}
    day=${date_str:6:2}
    echo "https://data.rda.ucar.edu/d084001/${year}/{$year}${month}${day}/gfs.0p25.${date_str}00.f006.grib2" 

    curl "https://data.rda.ucar.edu/d084001/${year}/{$year}${month}${day}/gfs.0p25.${date_str}00.f006.grib2" --output "gfs.0p25.${date_str}00.f006.grib2"
    curl "https://data.rda.ucar.edu/d084001/${year}/{$year}${month}${day}/gfs.0p25.${date_str}06.f006.grib2" --output "gfs.0p25.${date_str}06.f006.grib2"
    curl "https://data.rda.ucar.edu/d084001/${year}/{$year}${month}${day}/gfs.0p25.${date_str}12.f006.grib2" --output "gfs.0p25.${date_str}12.f006.grib2"
    curl "https://data.rda.ucar.edu/d084001/${year}/{$year}${month}${day}/gfs.0p25.${date_str}18.f006.grib2" --output "gfs.0p25.${date_str}18.f006.grib2"

    ${SCRIPT_DIR}/bin/linux-wgrib2 -match_fs "SNOD" -grib output/snow_${date_str}.grib2 gfs.0p25.${date_str}00.f006.grib2
    ${SCRIPT_DIR}/bin/linux-wgrib2 -match_fs "SNOD" -grib output/snow_${date_str}.grib2 gfs.0p25.${date_str}06.f006.grib2
    ${SCRIPT_DIR}/bin/linux-wgrib2 -match_fs "SNOD" -grib output/snow_${date_str}.grib2 gfs.0p25.${date_str}12.f006.grib2
    ${SCRIPT_DIR}/bin/linux-wgrib2 -match_fs "SNOD" -grib output/snow_${date_str}.grib2 gfs.0p25.${date_str}18.f006.grib2
    
done