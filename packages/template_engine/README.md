# Template Engine

[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![Powered by Mason](https://img.shields.io/endpoint?url=https%3A%2F%2Ftinyurl.com%2Fmason-badge)](https://github.com/felangel/mason)
[![License: MIT][license_badge]][license_link]

This Dart package provides an engine to build stringified HTML content with dynamic data using [mustache](https://mustache.github.io/mustache.5.html) syntax.

## Usage

Given the following `example.html` file:

```
<div>
Hello {{name}}
</div>
```
Create a `TemplateEngine` to render the content of the HTML file with the variable `{{name}}` filled in with a value from `context`:

```
final engine = TemplateEngine(
    basePath: 'my/base/path/to/html/files',
    context: {
        'name': 'Stefan'
    }
);
```

This will generate the following output:

```
<div>
Hello Stefan
</div>
```

# TODO: add what mustache is supported (lists, maps, bools/null-checks negations, comments)