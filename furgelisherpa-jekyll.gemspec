# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = "furgelisherpa-jekyll"
  spec.version       = "0.1.0"
  spec.authors       = ["Furgeli Sherpa"]
  spec.email         = ["furgelisherpa@tuta.io"]

  spec.summary       = "A minimal, text-first Jekyll theme in JetBrains Mono style."
  spec.description   = <<~DESC
    A minimal, text-first Jekyll theme. It renders JetBrains Mono, black text on
    a white background, and produces clean HTML5 with no JavaScript. Layouts,
    includes, Sass partials and assets ship with the gem; pages, permalinks,
    navigation and robots.txt stay under the site's control. Colours and fonts
    are overridable from the site. See README.md and docs/configuration.md.
  DESC
  spec.homepage      = "https://github.com/furgelisherpa/furgelisherpa-jekyll"
  spec.license       = "MIT"

  # spec.homepage is the canonical project URL, so it is repeated here as
  # homepage_uri for tooling that reads only spec.metadata. RubyGems warns when
  # homepage_uri and source_code_uri are identical, so source_code_uri points at
  # the commit history instead.
  spec.metadata = {
    "homepage_uri"      => "https://github.com/furgelisherpa/furgelisherpa-jekyll",
    "source_code_uri"   => "https://github.com/furgelisherpa/furgelisherpa-jekyll/commits",
    "bug_tracker_uri"   => "https://github.com/furgelisherpa/furgelisherpa-jekyll/issues",
  }

  # Deliberately a fixed allow-list instead of `git ls-files`: the gem must be
  # reproducible from a plain source tarball, which carries no VCS metadata.
  # Everything outside these paths -- example_site/, docs/, .github/, tests,
  # Gemfile, this gemspec and *.gem -- is intentionally excluded, as is any
  # build output such as _site/ or .jekyll-cache/.
  spec.files = Dir.chdir(__dir__) do
    Dir.glob(
      [
        "_layouts/**/*",
        "_includes/**/*",
        "_sass/**/*",
        "assets/**/*",
        "_config.yml",
        "README*",
        "LICENSE*",
      ]
    ).select { |path| File.file?(path) }.sort
  end

  spec.require_paths = ["."]
  spec.add_runtime_dependency "jekyll", "~> 4.4"

  # Matches the floor Jekyll itself imposes, so this only ever rejects a Ruby
  # that could not have loaded the theme's dependency anyway. Also silences
  # RubyGems' "specify the oldest ruby version" warning at `gem build` time.
  spec.required_ruby_version = ">= 2.7.0"
end