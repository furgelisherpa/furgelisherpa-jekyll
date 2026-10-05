---
layout: post
title: Hello World
date: 2026-03-14
description: The first post on this example site.
---

The first example post. It has no `slug` in its front matter, so its URL comes
from the `:title` placeholder in `permalink`, which slugifies the title to
`hello-world`.

The date above is in the past on purpose. Jekyll will happily build a post dated
in the future, but it will not appear in the post list until that date passes.

Dates here are plain `YYYY-MM-DD` values with no time and no offset. The theme
formats a post date with Liquid's `date` filter, which renders in the timezone
of the machine doing the build -- so an explicit `18:30 +0000` would print as
the following day when building somewhere east of UTC. A bare date has no such
ambiguity.