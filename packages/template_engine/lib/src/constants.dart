import 'dart:io';

/// The default meta title for the blog site. Reflects the entire site content,
/// not the content of an individual post.
const defaultMetaTitle = "Stefan's Blog";

/// The default meta description for the blog site. Reflects the entire site
/// content, not the content of an individual post.
const defaultMetaDescription =
    'Exploring my journey '
    'in software, the outdoors, and life in general.';

/// The current year, used in the footer of the blog site.
int currentYear = DateTime.now().year;

/// URL to the default meta image that will be displayed when sharing
/// to Facebook and Twitter.
const defaultMetaImageUrl = 'https://cdn.buttercms.com/k0VqhfH2Tqaem5CBGcAA';

/// Default meta context map for the blog site.
/// Should be injected into blog overview page.
/// Blog detail pages will take their description based on the
/// blog post they are displaying.
final defaultMetaContext = <String, String>{
  'metaTitle': defaultMetaTitle,
  'metaDescription': defaultMetaDescription,
};

/// Global context map for the blog site.
/// Should be injected into every template.
final globalContext = <String, dynamic>{
  'baseAppUrl': Platform.environment['BASE_APP_URL'] ?? '',
  'captchaSiteKey': Platform.environment['CAPTCHA_SITE_KEY'] ?? '',
  'year': currentYear,
};
