# Personal Blog

[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]
[![Powered by Dart Frog](https://img.shields.io/endpoint?url=https://tinyurl.com/dartfrog-badge)](https://dartfrog.vgv.dev)

My personal blog website. HTML content is served from Dart Frog and styled by .

Blog content provided by [Butter CMS](butter_cms_link). 

## Running Locally

Run `dart_frog dev` to serve the app locally. Running the app properly requires two environment variables:

- `BUTTER_CMS_API_KEY`: the api key that enables access to the CMS content. Should be a JSON object: `"{\"BUTTER_CMS_API_KEY\":\"butter-cms-key\"}"`
- `BASE_BLOGS_URL`: the base url of the content on `blog_overview_page.html`. Should be a `localhost` url with the `blogs` path: `http://localhost:8080/blogs`.

## Updating Styles

Styling uses [TailwindCSS](https://v3.tailwindcss.com/). New CSS content is generated in `public/output.css` on each save when the styles are being watched. To watch, run `npm run watch`.

[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis