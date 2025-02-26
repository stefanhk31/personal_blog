# Template Engine

[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![Powered by Mason](https://img.shields.io/endpoint?url=https%3A%2F%2Ftinyurl.com%2Fmason-badge)](https://github.com/felangel/mason)
[![License: MIT][license_badge]][license_link]

This Dart package provides an engine to build stringified HTML content with dynamic data using [mustache](https://mustache.github.io/mustache.5.html) syntax.

## Basic Usage

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
);

await engine.render('example.html', context: {
        'name': 'Stefan'
    });
```

This will generate the following output:

```
<div>
Hello Stefan
</div>
```

## Wrappers

Values can also be wrapped in an `{{#}}` open tag and `{{/}}` close tag.
These tags signify one of three things:

### Conditionals

A boolean conditional will display inner content if the condition is `true`.

`example.html`:

```
{{#isMorning}}
<div>Good morning!</div>
{{/isMorning}}
```

Dart:

```
await engine.render('example.html', context: {
        'isMorning': DateTime.now().hour < 12
    });
```

The above code will only output the html within `{{#isMorning}}` tag when the `isMorning` bool returns true.

Conditionals can be negative when wrapped in `{{^}}` and `{{/}}`.

`example.html`:

```
{{^isMorning}}
<div>Good afternoon!</div>
{{/isMorning}}
```

Dart:

```
await engine.render('example.html', context: {
        'isMorning': DateTime.now().hour < 12
    });
```

Conditional logic can be applied to handle nullable content:

`example.html`:

```
<div>{{firstName}}</div>
{{#lastName}}
<div>{{lastName}}</div>
{{/lastName}}
```

Dart:

```
await engine.render('example.html', context: {
        'firstName': 'Stefan',
        'lastName': 'Hodges-Kluck'
    });
```

OR 

```
await engine.render('example.html', context: {
        'firstName': 'Stefan',
        'lastName': null
    });
```

Output:

```
<div>Stefan</div>
<div>Hodges-Kluck</div>
```

OR 

```
<div>Stefan</div>
```

### Lists

Lists will display HTML content for each child in the list.

`example.html`:

```
{{#pets}}
<div>{{name}} is a {{type}}</div>
{{/pets}}
```

Dart:

```
await engine.render('example.html', context: {
        'pets': [
            {
                'name': 'Jadzia',
                'type': 'cat'
            }, 
            {
                'name': 'Rowena',
                'type': 'cat'
            }
        ]
    });
```

Output:

```
<div>Jadzia is a cat</div>
<div>Rowena is a cat</div>
```

### Maps

Maps will display HTML content for every field present in the map.

`example.html`:

```
{{#user}}
<div>{{name}}</div>
<div>{{email}}</div>
<div>{{dob}}</div>
{{/user}}
```

Dart:

```
await engine.render('example.html', context: {
        'user': [
            {
                'name': 'Stefan',
                'email': 'stefan@example.com',
                'dob': '1/1/1900'
            }
        ]
    });
```

Output:

```
<div>Stefan</div>
<div>stefan@example.com</div>
<div>1/1/1900</div>
```

## Comments

Comments can be made with a `{{!}}` tag, and will be ignored:

`example.html`:

```
{{! I am a comment }}
<div>Hello</div>
```

Output:

```
<div>Hello</div>
```