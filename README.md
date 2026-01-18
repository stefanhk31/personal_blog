# Personal Blog

[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]
[![Powered by Dart Frog](https://img.shields.io/endpoint?url=https://tinyurl.com/dartfrog-badge)](https://dartfrog.vgv.dev)

My personal blog website.

Blog content provided by [Butter CMS](butter_cms_link). 

## Running Locally

Dependencies need to be fetched for every package in the project. The easiest way to do this is by running `very_good packages get -r`, a command made available via the [Very Good CLI](https://pub.dev/packages/very_good_cli). 

Run `dart_frog dev` to serve the app locally. Running the app properly requires two environment variables:

- `BUTTER_CMS_API_KEY`: the api key that enables access to the CMS content.
- `BASE_APP_URL`: the base url of the app that is being served. Running locally, this will default to `http://localhost:8080`. Note the lack of a `/` at the end.
- `BASE_NEWSLETTER_URL`: the base url of the newsletter service. Needed for subscriptions.
- `CAPTCHA_SITE_KEY`: the frontend site key for captcha verification. Needed for the subscriber form.
- `CAPTCHA_SECRET_KEY`: the backend key for captcha verification. Needed for the subscriber form.

## Updating Styles

Styling uses [TailwindCSS](https://v3.tailwindcss.com/). New CSS content is generated in `public/output.css` on each save when the styles are being watched. To watch, run `npm install` (if you have not done so previously) and then `npm run watch`.

[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
