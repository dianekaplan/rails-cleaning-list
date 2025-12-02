## Repo-specific Copilot instructions — rails_cleaning_app

This file helps AI coding agents (Copilot/assistant) work productively in this repository.

Key facts (discoverable):
- The repo currently has no application files at the top-level. Inspect `Gemfile`, `app/`, `config/`, `spec/` or `test/` if/when they appear.

How to behave (short):
- If the repo is empty or files are missing, ask concise clarifying questions before creating large scaffolding.
- Prioritize non-destructive changes: create small diffs, add tests, and explain assumptions in PR descriptions.

Rails-specific patterns to look for (when app exists):
- Standard Rails layout: `app/models`, `app/controllers`, `app/views`, `config/routes.rb`, `db/migrate`.
- Test frameworks: look for `spec/` (RSpec) or `test/` (Minitest). Run tests with `bundle exec rspec` or `bin/rails test`.
- Typical dev commands:
  - Install: `bundle install`
  - DB setup: `bin/rails db:create db:migrate db:seed`
  - Run tests: `bundle exec rspec` or `bin/rails test`
  - Console: `bin/rails console`
  - Server: `bin/rails server`

Agent workflows / priorities:
1. Always scan for existing tests before editing behavior. If none exist, suggest and add focused tests.
2. Keep changes small and scoped to a single responsibility (controller action, model method, migration).
3. If behavior requires date/time or external services, stub or mock in tests and document assumptions.

What to search in the repo (examples):
- `Gemfile`, `Rakefile`, `bin/rails`, `config/routes.rb`, `app/**`, `spec/**`, `test/**`, `db/migrate/**`.

When uncertain, ask the maintainer:
- "Do you want full Rails scaffolding created, or should I implement only X?"
- "Which test framework (RSpec/Minitest) and style rules (Rubocop) does this project use?"

Keep PRs clear: include short summary, files changed, test coverage added, and any assumptions or required environment variables.

If anything else in this workspace (workflows or `.qodo`) indicates project automation or agent policies, follow those artifacts first.
