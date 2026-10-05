# Configuration

Every setting below is optional. The theme ships its own `_config.yml` with
defaults, and Jekyll merges it into your site automatically, so a site that only
declares `theme: furgelisherpa-jekyll` already builds correctly. Each key below
documents that default, so you only set a key when you want something different.

For a working starting point, see [`example_site/_config.yml`](../example_site/_config.yml).

## Full configuration template

```yaml
# --- Site identity ---
title: "Example Site"                # no default
site_name: "Example Site"            # defaults to `title`
description: "An example site."      # no default
url: "https://example.com"           # no default; no trailing slash
baseurl: ""                          # defaults to ""
lang: "en"                           # defaults to "en"
timezone: "Asia/Kathmandu"           # no default; see the date note below

# --- Author ---
author:
  name: "Example Author"             # defaults to `title`
  social:                            # defaults to omitted
    - "https://example.com/"

# --- Navigation ---
nav:                                 # omit or [] to render no navigation
  - title: "Home"
    url: "/"
  - title: "About"
    url: "/about.html"

# --- Blog ---
blog_url: "/blogs.html"              # default: /blogs.html
back_text: "Back to Blog"            # default: Back to Blog
permalink: /blogs/:title.html        # no default; this is a sensible example

# --- Footer ---
footer:
  # text: "Copyright (c) Example"    # replaces the whole line when set
  start_year: 2026                   # default: omitted, so no year range

# --- Theme ---
theme: "furgelisherpa-jekyll"
google_font: "JetBrains Mono"        # default: JetBrains Mono; "" omits the link
# css_path: "/assets/css/style.css"  # default: /assets/css/style.css
# favicon: "/assets/favicon.jpg"     # default: /assets/favicon.jpg
sass:
  sourcemap: never                   # default: Jekyll's own default (a .map file)
```

## Site keys

| Key | Type | Default | Used for |
| --- | --- | --- | --- |
| `title` | string | none | Site title. Fallback for `site_name`, `author.name` and the generated footer line. |
| `site_name` | string | `title` | `og:site_name`, and the suffix appended to `<title>`. |
| `description` | string | none | `<meta name="description">` and `og:description` when a page sets none. |
| `url` | string | none | Origin used to build canonical URLs, `og:url` and the JSON-LD `url`. Set it to your real origin. |
| `baseurl` | string | `""` | Subpath the site is served from, e.g. `"/blog"`. |
| `lang` | string | `"en"` | Value of `<html lang>`. |
| `timezone` | string | build machine's | Jekyll's own setting. Set it explicitly: post dates are formatted with Liquid's `date` filter, which renders in the timezone of the machine doing the build, so a front matter time can display as a different calendar day depending on where you build. |

## Author keys

| Key | Type | Default | Used for |
| --- | --- | --- | --- |
| `author.name` | string | `title` | `<meta name="author">` and the JSON-LD `name`. |
| `author.social` | list of URLs | omitted | Each entry becomes one item of the JSON-LD `sameAs` array. Leave it out (or set `[]`) and `sameAs` is omitted from the JSON-LD entirely rather than emitted as an empty array, which would be invalid. |

The JSON-LD block is only rendered on pages that set `jsonld: true` in front
matter.

## Navigation

`nav` is a list of `{ title, url }` pairs, rendered in order. Omit the key or
set it to `[]` and no `<nav>` element is rendered at all.

```yaml
nav:
  - title: "Home"
    url: "/"
  - title: "About"
    url: "/about.html"
  - title: "Blog"
    url: "/blogs.html"
```

Each `url` must be the path a visitor actually types -- the **output** path,
including the `.html` extension. Jekyll exposes an HTML page internally as
`/about` without the extension, so the theme strips `.html` from both sides
before comparing; writing `url: /about` would therefore not match. `url`s that
do not start with `/` are treated as external and rendered without the current
item treatment.

## Blog

| Key | Type | Default | Used for |
| --- | --- | --- | --- |
| `blog_url` | string | `"/blogs.html"` | Target of the "back" link shown at the bottom of every post. |
| `back_text` | string | `"Back to Blog"` | Label for that link. |
| `permalink` | string | none | Post URL pattern. See below. |

## Permalinks

### Posts

Jekyll's default post permalink embeds the year and month. To get flat URLs, set:

```yaml
permalink: /blogs/:title.html
```

`:basename` is **not** valid in a post permalink. Jekyll raises `The URL
template doesn't have basename keys` and the build fails; `:basename` is a page
placeholder only.

`:title` resolves to the post's `slug` front matter if present, otherwise to the
filename slugified. A post stored as `_posts/2026-03-14-hello-world.md` slugs to
`hello-world`. Two consequences worth knowing:

- **Do not append an extension twice.** The placeholder already ends in
  `.html`, so `permalink: /blogs/:title` would write `hello-world.html` but
  `permalink: /blogs/:title.html` is the form that keeps the canonical URL and
  the permalink in agreement. If you use an extensionless pattern such as
  `/blogs/:title`, be aware the theme's canonical-link logic restores `.html`
  for you, because Jekyll only appends the extension when writing the file.
- **Slugify surprises are real.** The default slugifier treats any run of
  non-alphanumeric characters as a separator, so the title `It's a Jekyll Theme`
  becomes `it-s-a-jekyll-theme`. Set `slug` explicitly when a title contains
  punctuation and you want a specific URL:

  ```yaml
  ---
  title: "It's a Jekyll Theme"
  slug: its-a-jekyll-theme
  ---
  ```

### Pages

Pages take `permalink:` in their own front matter rather than a site-wide
setting. Setting it explicitly is what keeps an old URL from moving:

```yaml
---
layout: page
title: About
permalink: /about.html
---
```

A page permalink may use `:basename`, which a post permalink may not.

## Footer

`footer.text` replaces the entire footer line when set, including the copyright
symbol and any years. When it is absent, the theme generates the line from
`footer.start_year` and `author.name`:

```yaml
footer:
  start_year: 2026
  # -> "Copyright (c) 2026-Present Example Author"
```

With `start_year` omitted, no year range is shown.

## Stylesheet and favicon

Both default to files bundled with the theme, so a site gets a working
stylesheet and favicon with no configuration:

```yaml
css_path: "/assets/css/style.css"
favicon: "/assets/favicon.jpg"
```

`css_path` may point at any URL; the theme emits it through `relative_url`, so a
`baseurl` is applied automatically.

`favicon` also drives the `type` attribute, which is inferred from the file
extension: `.jpg`/`.jpeg` give `image/jpeg`, `.png` gives `image/png`, `.svg`
gives `image/svg+xml`, `.ico` gives `image/x-icon` and `.gif` gives
`image/gif`. An unrecognised extension yields an empty `type`, so prefer one of
the five above.

### Fonts

`google_font` is the family name requested from Google Fonts. Spaces are
converted to `+` automatically, so `"JetBrains Mono"` becomes
`family=JetBrains+Mono`.

This key is tri-state, which is why it is worth stating plainly:

| Value | Result |
| --- | --- |
| unset | The `<link>` uses the bundled default, `JetBrains Mono`. |
| `""` or `false` | The `<link>` to Google Fonts is omitted entirely. |
| any other string | The `<link>` requests that family. |

If you set `google_font: ""` to drop the web font, remember the stylesheet still
refers to the family by name; override the font in your own CSS if you need a
different face.

## Sass source maps

Jekyll 3.7 and newer emit a `style.css.map` next to the compiled stylesheet.
Setting the following removes it from the output, which is useful when you
publish a build directory and do not want the map shipped:

```yaml
sass:
  sourcemap: never
```

## Front matter

### All layouts

| Key | Type | Default | Used for |
| --- | --- | --- | --- |
| `title` | string | none | `<title>` suffix, `og:title`, post list text, and the `<h1>` when `heading` is unset. |
| `heading` | string | `title` | The `<h1>`. Set it when you want a visible heading that differs from the title, for example a shorter one. |
| `title_tag` | string | `"<title> - <site_name>"` | Full `<title>`, bypassing the automatic suffix. |
| `description` | string | `site.description` | Page description and `og:description`. |
| `tagline` | string | none | A short line under the header. Renders anywhere it is set. |
| `last_updated` | string or date | none | A "Last updated" line above the footer. |
| `noindex` | boolean | `false` | Emits `<meta name="robots" content="noindex">` and suppresses the canonical link and all `og:*` tags. |
| `og_type` | string | `"website"`, or `"article"` on posts | The `og:type` value. |
| `jsonld` | boolean | `false` | Renders a schema.org `Person` JSON-LD block in the `<head>`. |
| `permalink` | string | Jekyll's default | Output URL. Works for both pages and posts; see [Permalinks](#permalinks). |

### Posts only

| Key | Type | Default | Used for |
| --- | --- | --- | --- |
| `date` | date | Filename date | The date above the post body. Prefer a bare `YYYY-MM-DD`: the theme formats it with Liquid's `date` filter, which renders in the timezone of the machine doing the build, so an explicit time with an offset can print as a different calendar day. Set `timezone:` in `_config.yml` to pin this. |
| `slug` | string | Slugified `title` | Overrides the `:title` permalink placeholder. |

## Pages your site must provide

The theme does not ship these, because each one is site-specific:

- **`/404.html`.** Create a page at `404.md` with `layout: not-found` and an
  explicit `permalink: /404.html`. Jekyll's development server and most static
  hosts serve it for unmatched paths. Pages using that layout are always
  `noindex`, so they are never submitted to search engines and never emit a
  canonical link.
- **`robots.txt`.** Generate it from a `robots.txt` file in your source
  directory, with `layout: null` and `permalink: /robots.txt`, so that
  `site.url` is substituted correctly:

  ```text
  ---
  layout: null
  permalink: /robots.txt
  ---

  User-agent: *
  Disallow:

  Sitemap: {{ site.url }}/sitemap.xml
  ```

- **`CNAME`.** For a custom domain, a `CNAME` file in your source directory.
  GitHub Pages ignores it when you deploy through a GitHub Actions workflow --
  with Actions you set the domain in **Settings → Pages → Custom domain**
  instead.
- **A sitemap.** The theme deliberately does not depend on `jekyll-sitemap`,
  because a theme dependency would force the plugin on every site that uses the
  theme. Enable it yourself in your own `Gemfile` (`gem "jekyll-sitemap"`) and
  in your own `_config.yml` (`plugins: [jekyll-sitemap]`). `lastmod` comes from
  each file's modification time unless you set `last_modified_at` in front
  matter, and on GitHub Actions a fresh checkout gives every file the checkout
  time -- so `lastmod` reflects the deploy, not your last edit. Add
  `sitemap: false` to the 404 page.

## Ignoring the theme configuration

Jekyll merges the theme's `_config.yml` into your site's. To ignore it
completely, set this in your own configuration:

```yaml
ignore_theme_config: true
```

The theme is written to tolerate this: every setting it reads has a hard-coded
fallback, so the build output is byte-for-byte identical either way.