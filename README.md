# Melbourne Magics

A map of Melbourne cafes where people rate each cafe's Magic (a double ristretto with steamed milk).

## What's here

| File | Purpose |
| --- | --- |
| `index.html` | The whole app: layout, styles and code |
| `config.js` | Your Supabase settings (empty = preview mode) |
| `data.js` | 2,738 cafes and the suburb boundaries |
| `streets.js` | Streets, main roads, parks and water for the map |
| `supabase/setup.sql` | One-off database setup script |

## Part 1: put it online (GitHub Pages)

1. Upload everything in this folder to a public GitHub repository.
2. In the repository go to Settings > Pages, choose "Deploy from a branch", pick `main` and save.
3. The site appears at `https://<your-username>.github.io/<repository-name>/`.

With `config.js` left empty the site runs in preview mode: the map, search and cafe pages work, but ratings, favourites and photos are not saved.

## Part 2: make ratings save (Supabase)

1. Create a project at supabase.com (Sydney region).
2. Open SQL Editor, paste in all of `supabase/setup.sql` and click Run.
3. Go to Authentication > URL Configuration. Set Site URL to your website address and add the same address under Redirect URLs.
4. Click Connect at the top of the project (or go to Settings > API Keys). Copy the Project URL and the Publishable key (starts with `sb_publishable_`) into `config.js`, then upload the changed file to GitHub. Never use the secret key.
5. Open the website, sign in with your email, then run the last line of `setup.sql` (with your email) in the SQL Editor to make yourself the admin. Admins can remove reviews and hide cafes.

People sign in with a link sent to their email, so there are no passwords. Supabase's built-in email sender only allows a few emails an hour; add your own email provider under Authentication > Emails before a public launch.

## Data sources

- Cafes, streets, parks and water: © OpenStreetMap contributors, licensed under the Open Database Licence (ODbL). https://www.openstreetmap.org/copyright
- Suburb boundaries: Victorian locality boundaries from data.gov.au.

The map covers Craigieburn to Chelsea and Werribee to Ringwood.
