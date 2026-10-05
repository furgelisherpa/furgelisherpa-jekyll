---
layout: post
title: "It's a Jekyll Theme"
slug: its-a-jekyll-theme
heading: Why This Theme Exists
date: 2026-08-22
description: A post whose visible heading differs from its title.
---

Two front matter keys are demonstrated here.

First, the title contains an apostrophe. Left alone, the `:title` placeholder
would slugify it to `it-s-a-jekyll-theme`, so this post sets an explicit `slug`
to keep the URL clean. A `slug` always wins over the title.

Second, `heading` overrides the `<h1>` shown by the shared header, while the
post list on the blog index keeps showing `title`. That is the difference
between the two entries below.