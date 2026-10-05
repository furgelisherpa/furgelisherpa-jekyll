# furgelisherpa-jekyll

A minimal, text-first Jekyll theme: JetBrains Mono, black text on white, clean
HTML5, no JavaScript.

Everything the theme renders comes from your own Markdown and your own
`_config.yml`. There are no theme-specific page conventions to learn, no
required plugins, and no build-time magic. A site is a handful of `.md` files
with front matter plus one `theme:` line.

Two documents come with the theme:

- [`docs/configuration.md`](docs/configuration.md) is the reference for every
  setting and every front matter key.
- [`example_site/`](example_site/) is a complete, buildable site you can copy
  from.

Both are in the repository rather than the packaged gem, so those links only
resolve when browsing the repository.

## Installation

### From RubyGems

Add the gem to your site's `Gemfile`:

```ruby
gem "furgelisherpa-jekyll"
```

And to your site's `_config.yml`:

```yaml
theme: "furgelisherpa-jekyll"
```

Then:

```sh
bundle install
```

### From GitHub, before a RubyGems release

To use an unreleased commit, point the gem at the repository:

```ruby
gem "furgelisherpa-jekyll", github: "furgelisherpa/furgelisherpa-jekyll"
```

This requires the repository to be pushed with at least one commit -- the
Bundler GitHub source runs `git clone`, so it cannot work against an empty
repository.

To pin a branch, tag or commit, add a `ref:`:

```ruby
gem "furgelisherpa-jekyll", github: "furgelisherpa/furgelisherpa-jekyll", branch: "main"
```

## Configuration

The theme ships defaults for `google_font`, `css_path` and `favicon`, so the
two lines above are enough to get a working site. A minimal `_config.yml`:

```yaml
title: "Example Site"
description: "An example site."
url: "https://example.com"
theme: "furgelisherpa-jekyll"
```

A fuller starting point, with every key the theme reads:

```yaml
title: "Example Site"
site_name: "Example Site"
description: "An example site."
url: "https://example.com"
baseurl: ""
lang: "en"
timezone: "Asia/Kathmandu"

author:
  name: "Example Author"
  social:
    - "https://example.com/"

nav:
  - title: "Home"
    url: "/"
  - title: "About"
    url: "/about.html"
  - title: "Blog"
    url: "/blogs.html"

blog_url: "/blogs.html"
back_text: "Back to Blog"
permalink: /blogs/:title.html

footer:
  start_year: 2026

theme: "furgelisherpa-jekyll"
google_font: "JetBrains Mono"
sass:
  sourcemap: never
```

`docs/configuration.md` documents what each key does, its default, and the
three-state behaviour of `google_font`. Read it rather than copying this block
blind -- it is a summary, not the reference.

## Layouts

| Layout | For |
| --- | --- |
| `home` | The landing page. Adds `tagline` under the header. |
| `page` | An ordinary static page. |
| `post` | A blog post. Adds the date and a "back to blog" link. |
| `blog` | A blog index. Appends the shared post list after your content. |
| `not-found` | The 404 page. Always `noindex`, never emits a canonical URL. |

`default` wraps them all and is the base you would use directly only if none of
the others fit.

### Front matter

| Key | Type | Default | Used for |
| --- | --- | --- | --- |
| `title` | string | none | The `<title>` suffix and the post list text. |
| `heading` | string | `title` | The `<h1>`, when you want it to differ from `title`. |
| `title_tag` | string | `"<title> - <site_name>"` | The full `<title>`, bypassing the suffix. |
| `description` | string | `site.description` | The meta description and `og:description`. |
| `tagline` | string | none | A short line under the header. |
| `last_updated` | string or date | none | A "Last updated" line above the footer. |
| `noindex` | boolean | `false` | Emits `<meta name="robots" content="noindex">` and drops the canonical URL and `og:*` tags. |
| `jsonld` | boolean | `false` | Renders a schema.org `Person` JSON-LD block. |
| `og_type` | string | `"website"`, or `"article"` on posts | The `og:type` value. |
| `permalink` | string | Jekyll's default | The output URL, for pages and posts alike. |

A post also reads `date` and `slug`; a page reads nothing else. The
`permalink` key is covered under [Permalinks](#permalinks).

## Includes

| Include | For |
| --- | --- |
| `head.html` | The whole `<head>`: meta tags, canonical URL, `og:*`, font link, stylesheet, favicon, JSON-LD. |
| `header.html` | The `<h1>`. |
| `nav.html` | The navigation, driven entirely by the `nav` config key. |
| `footer.html` | The footer line. |
| `post-list.html` | The dated post list, newest first. |

## Colours and fonts

### Fonts

The `google_font` key names the Google Fonts family, and spaces are converted
to `+` for you. It has three states worth knowing:

| Value | Result |
| --- | --- |
| unset | Uses the bundled default, `JetBrains Mono`. |
| `""` or `false` | Omits the Google Fonts `<link>` entirely. |
| any other string | Requests that family. |

```yaml
google_font: "Iosevka"
```

If you set it to `""`, override the font family in your own CSS as well --
otherwise the stylesheet still names JetBrains Mono and the browser falls back
to its next available font.

### Colours

All colours and sizes live in `_sass/_variables.scss` in the theme. There are
two ways to change them, and **only the second one works** for a partial you
have not copied.

**Appending CSS to the theme's entry point.** Create
`assets/css/style.scss` in your site:

```scss
---
---

@use "base";
@use "layout";
@use "components";
@use "content";

body { color: #123456; }
a { color: #654321; }
.page { max-width: 33rem; }
```

Your file replaces the theme's, so it must `@use` the partials you want to keep
and then add your own rules after them. Equal-specificity rules later in the
file win, so no `!important` is needed. This is the simplest approach and the
one to reach for.

**Copying partials to edit the variables.** To change a value *inside* the
theme's own rules, copy the partial that uses it into your site's `_sass/`
directory alongside your own `_variables.scss`:

```sh
mkdir -p _sass assets/css
cp "$(bundle show furgelisherpa-jekyll)/_sass/_variables.scss" _sass/
cp "$(bundle show furgelisherpa-jekyll)/_sass/_base.scss"   _sass/
cp "$(bundle show furgelisherpa-jekyll)/_sass/_layout.scss" _sass/
```

Edit the copied `_variables.scss`, and keep an entry point that loads your
copies plus the theme's remaining partials:

```scss
---
---

@use "base";
@use "layout";
@use "components";
@use "content";
```

Which partials you must copy depends on which variables you are changing:
`$color-black`, `$color-link`, `$color-muted` and `$font-size-base` are used by
`_base.scss`; `$page-max-width` is used by `_layout.scss`; `$color-code-block-bg`
and `$color-code-inline-bg` are used by `_content.scss`. Copy the one that
reads the variable you want to change.

Copying only `_variables.scss` and no partials does nothing. Sass resolves
`@use "variables"` relative to the file that contains it, so each theme partial
finds the theme's own `_variables.scss` before any load path is consulted. This
is why the variable file alone is not enough, and it is worth knowing before you
spend time on it.

## What a theme gem cannot ship

A theme gem can only contain what is inside the gem directory. These stay with
your site, and none of them are part of the theme.

### `robots.txt`

Generate it from your site so `site.url` is correct:

```text
---
layout: null
permalink: /robots.txt
---

User-agent: *
Disallow:

Sitemap: {{ site.url }}/sitemap.xml
```

Save that as `robots.txt` in your site's source directory. `layout: null` stops
Jekyll wrapping it in your pages; `permalink: /robots.txt` stops it becoming
`robots.html`.

### `CNAME`

For a custom domain on GitHub Pages, add a `CNAME` file containing just your
domain. Note that **GitHub Pages ignores `CNAME` when you deploy with a custom
GitHub Actions workflow** -- with Actions you set the domain in
**Settings → Pages → Custom domain** instead.

### Your root pages

Including the 404 page:

```yaml
---
layout: not-found
permalink: /404.html
sitemap: false
title: Page Not Found
---
```

`permalink: /404.html` is explicit rather than relying on the filename, and
`sitemap: false` keeps the error page out of your sitemap if you use one.

### Sitemap

The theme does not depend on `jekyll-sitemap`, on purpose: a dependency here
would force it on every site that uses the theme, whether or not you want a
sitemap. Enable it yourself in your site's own `Gemfile`:

```ruby
gem "jekyll-sitemap"
```

and in your site's `_config.yml`:

```yaml
plugins:
  - jekyll-sitemap
```

Two things to know. `lastmod` comes from each file's modification time unless
you set `last_modified_at` in front matter -- and on GitHub Actions a fresh
checkout gives every file the *checkout time*, so `lastmod` is the time of the
deploy rather than the time you last edited anything. Set `last_modified_at`
explicitly if that matters to you.

## Permalinks

For posts, set a flat permalink:

```yaml
permalink: /blogs/:title.html
```

`:basename` is **not** valid in a post permalink -- Jekyll raises `The URL
template doesn't have basename keys` and the build fails. `:basename` is a page
placeholder only. `:title` is the one to use for posts.

The `:title` slug comes from the post's **filename**. A post stored as
`_posts/2026-03-14-hello-world.md` slugs to `hello-world` and lands at
`/blogs/hello-world.html`, so the filename and the URL are kept in step. Set
`slug:` in front matter to override it.

Because the default slugifier treats any run of non-alphanumeric characters as a
separator, a title like `It's a Jekyll Theme` would slug to
`it-s-a-jekyll-theme`. Set `slug:` when a title contains punctuation and you
want a specific URL.

Do not append an extension twice. The placeholder already ends in `.html`, so
`permalink: /blogs/:title.html` is correct.

Pages take `permalink:` per page in front matter:

```yaml
---
layout: page
title: About
permalink: /about.html
---
```

## Deploying with GitHub Actions

GitHub's built-in Pages build runs Jekyll with a fixed plugin allow-list and
will not run a custom workflow. Deploying through Actions instead removes that
restriction, so `jekyll-sitemap` and other gems work without an allow-list
entry.

The template below is provided as a starting point and is **not tested here** --
this repository has no Actions runner, and no deployment workflow is committed.
Adjust the branch and paths before relying on it.

```yaml
name: Deploy to GitHub Pages

on:
  push:
    branches: [main]
  workflow_dispatch:

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: pages
  cancel-in-progress: false

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: ruby/setup-ruby@v1
        with:
          ruby-version: "3.3"
          bundler-cache: true
      - run: bundle exec jekyll build --trace
      - uses: actions/upload-pages-artifact@v3
        with:
          path: _site

  deploy:
    needs: build
    runs-on: ubuntu-latest
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    steps:
      - id: deployment
        uses: actions/deploy-pages@v4
```

`bundler-cache: true` runs `bundle install` for you using your `Gemfile.lock`.

## Migrating from hand-written HTML

Moving an existing static site onto this theme is mostly a matter of putting
front matter in front of the Markdown you already have.

1. **Move pages into the repository root as `.md`.** Cut the `<body>` contents
   of each page into Markdown. Keep the page's file name, or set `permalink:` to
   preserve the old URL exactly.

2. **Map the head values onto front matter.** Anything you wrote by hand in
   `<head>` becomes a front matter key:

   | Was in your HTML | Becomes |
   | --- | --- |
   | `<title>` | `title:` (and `title_tag:` for the full string) |
   | `<meta name="description">` | `description:` |
   | `<link rel="canonical">` | derived from `url:` and `baseurl:`; set those instead |
   | `og:title`, `og:description`, `og:type` | derived; override with `title:`, `description:`, `og_type:` |
   | `<meta name="robots" content="noindex">` | `noindex: true` |
   | your JSON-LD block | `jsonld: true`, plus `author.name` and `author.social` in `_config.yml` |

   The canonical URL is generated, not set per page. Set `url:` and `baseurl:`
   once in `_config.yml` and every page gets a correct canonical link.

3. **Move posts into `_posts/`** with a dated filename. The date prefix is
   required, the rest of the name becomes the `:title` slug, so
   `2026-03-14-hello-world.md` gives `/blogs/hello-world.html`. If your old post
   URLs differed, set `slug:` or an explicit `permalink:` to keep them.

4. **Delete the hand-written `sitemap.xml`.** It will be overwritten by the
   build, and it belongs in `_site/`, never in your source. Generate it with
   `jekyll-sitemap` instead.

5. **Diff the old and new sites URL by URL before switching.** This is the step
   worth doing properly. Fetch every URL you care about from both the current
   site and the new build, and compare status codes and normalized markup. Look
   for redirects you did not intend, canonical URLs that changed, and pages that
   vanished. Keep the old site reachable until the diff is clean.

Set `timezone:` in `_config.yml` while you are migrating. Post dates are
formatted with Liquid's `date` filter, which renders in the timezone of the
machine doing the build, so a front matter time can display as a different
calendar day depending on where the build runs. A `timezone:` setting fixes
that, and bare `YYYY-MM-DD` dates avoid the question entirely.

## Contributing

Issues and pull requests are welcome at
<https://github.com/furgelisherpa/furgelisherpa-jekyll/issues>.

Run the example site to check a change:

```sh
cd example_site
bundle install
bundle exec jekyll serve
```

## License

MIT. See [LICENSE.txt](LICENSE.txt).