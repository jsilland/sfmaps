# San Francisco Maps

A [Kepler.gl](https://kepler.gl/)-based app to visualize public data sets pertaining to the city of San Francisco.

## Running the app

You need to have [Docker](https://www.docker.com/) installed on your computer and be okay with running a command on the Terminal. Running the `build.sh` script at the root of the repository will:

- generate all data sets with the most up to date data
- build a container with the application code and the data sets
- start the container

```sh
$ ./build.sh
```

Once the script stops spewing output, open [localhost:49160](http://localhost:49160) in your browser and geek out!

## Data sources

### Police incidents

This layer contains the incidents as reported to and tracked by the SFPD. It is downloaded from [data.sfgov.org](https://data.sfgov.org) as a CSV file and transformed into a GeoJSON `FeatureCollection` where each feature is an incident. Each item contains the lat/lng, the category and subcategory and the date and time of the incident. The data is truncated to the past 1 year from the time the script is run.

Visually, the data is aggregated using [hexagonal binning](https://datavizproject.com/data-type/hexagonal-binning/). Other visualization techniques in Kepler (e.g. heatmap) do not do as good a job of representing the data because the geographic resolution of the data seems arbitrarily rounded to street intersections. Concretely speaking, this means an incident's lat/lng is not that of the actual incident but that of the nearest intersection.

You can use Kepler's filtering to select a specific date range or category of incidents.

## Developing SF Maps

Running SF Maps locally is a two-step process: generating the datasets and running the application. Past datasets are also checked in GitHub, so you don't need to generate them yourself.

### Datasets

Docker is the recommended way to generate the dataset reliably.

All the code needed to generate / pull the data is in the `maps/` directory. Monthly releases are distributed in `maps/releases/<year>.<month>`. When it is loaded in the browser, the Kepler app will load a root configuration file which contains the metadata for each dataset: name, description, URL of the dataset, URL of the preview picture, URL of the visualization configuration, etc… Example below:

```json
[
  {
    "id": "incidents",
    "label": "Police Department Incident Reports",
    "queryType": "sample",
    "imageUrl": "http://localhost:49160/public/incidents.png",
    "description": "Location and categories of SFPD incident reports (limited to the past year)",
    "size": 138361,
    "visible": true,
    "dataUrl": "http://localhost:49160/public/incidents.geojson",
    "configUrl": "http://localhost:49160/public/incidents.json"
  }
]
```

The role of `maps/maps.sh` is to generate all the datasets and the root configuration file. This script is intended to be run within the Docker image defined in `maps/Dockerfile`, which is in charge of installing the required tools. All of this is orchestrated by `maps/build.sh`, which is in charge of:

1. Setting up the release directories
2. Building the `sfmapsdata` container, which contains useful tools for downloading and massaging JSON and CSV data
  1. [`curl`](https://curl.haxx.se/)
  1. [`jq`](https://stedolan.github.io/jq/)
  2. [`mlr`](https://github.com/johnkerl/miller)
3. Running `maps.sh` in the container
  1. For each dataset, e.g. incidents, generate the data and move it to the release directory
  2. For each dataset, publish the preview picture and the visualization configuration
  3. Generate the root configuration file
4. Symlink the newest release to the `latest/` subdirectory

`maps/build.sh` takes a single argument, which is the base URL from where the datasets and config files will be served from. It defaults to the releases published in GitHub but can be changed for local development:

```sh
$ maps/build.sh http://localhost:49160/public # For Docker
$ maps/build.sh http://localhost:8080/public # For local development
```

#### Structure of a dataset

See `maps/incidents` to grasp what goes into defining a data set:

- `build.sh`: responsible for assembling the dataset and outputting data consumable by the Kepler app. In this case, it downloads the data uses `mlr` and `jq` to filter and transform the data into a valid GeoJSON `FeatureCollection`.
- `filter.jq`: for readability, the JQ filter was used in `build.sh` was extracted to this file.
- `config.json`: metadata declaration that will get integrated as an item in the root configuration file. This is actually a `jq` template which will get rendered by the root `maps.sh` script.
- `incidents.png`: a 480×340 preview of the data.

### Running the application

First of all, generate the data, then create symlinks to the generated data into the locations where the application code expects them

```sh
$ maps/build.sh http://localhost:8080/public
$ ln -s maps/releases/latest public
```

Then install the application dependencies and run it. This requires [`npm`](https://www.npmjs.com/) and [`yarn`](https://yarnpkg.com).

```
$ yarn --ignore-engines
$ npm start
```

Then direct your browser to [`localhost:8080`](http://localhost:8080). The server will hot-reload changes to the JavaScript and to the data.
