# Melbourne Magics

A map of Melbourne cafes where people rate each cafe's Magic (a double ristretto with steamed milk).

## What's here

| File | Purpose |
| --- | --- |
| `index.html` | The whole app: layout, styles and code |
| `data.js` | 2,738 cafes and the suburb boundaries |
| `streets.js` | Streets, main roads, parks and water for the map |

## Running it

Open `index.html` in a browser, or host the three files on any static host (GitHub Pages works).

Outside claude.ai the app runs in preview mode: the map, search and cafe pages all work, but ratings, favourites and photos stay on screen only and are not saved or shared. Saving relies on the storage that claude.ai provides to published pages. A standalone public version needs its own backend for accounts, ratings and photos.

## Data sources

- Cafes, streets, parks and water: © OpenStreetMap contributors, licensed under the Open Database Licence (ODbL). https://www.openstreetmap.org/copyright
- Suburb boundaries: Victorian locality boundaries from data.gov.au.

The map covers Craigieburn to Chelsea and Werribee to Ringwood.
