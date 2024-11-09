import os
import cdsapi

os.environ["CDSAPI_URL"] = "https://cds.climate.copernicus.eu/api/v2"
dataset = "reanalysis-era5-land"
# get day of month
import datetime

now = datetime.datetime.now()
day = now.day
month = now.month
year = now.year

if month < 10:
    month = "0" + str(month)

client = cdsapi.Client()

for i in range(day, 1, -1):
    if int(i) < 10:
        i = "0" + str(i)
    request = {
        "variable": ["snow_depth"],
        "year": f"{year}",
        "month": f"{month}",
        "day": [f"{i}"],
        "time": ["23:00"],
        "data_format": "grib",
        "download_format": "unarchived",
    }
    try:
        client.retrieve(dataset, request).download()
        break
    except Exception as e:
        print(e)
        i = int(i) - 1


if __name__ == "__main__":
    print("Downloaded file: download.grib")
