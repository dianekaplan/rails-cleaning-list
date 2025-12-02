# rails_cleaning_app — full Rails application

This repository contains a small Rails 7 application implementing three domain models: TaskType, Cycle, and TaskInstance and a simple admin UI.

Quick start (macOS / Linux):

1. Install dependencies

```bash
gem install bundler
bundle install
```

2. Create & migrate the database

```bash
bin/rails db:create
bin/rails db:migrate
```

3. Seed demo task types (optional):

```bash
bin/rails db:seed
```

4. Start the server

```bash
bin/rails server -p 3000
```

Now visit http://localhost:3000 in your browser:

- / → current task instance list for the latest cycle
- /admin/task_types → manage task types
- /admin/cycles/new → create a cycle (creates TaskInstances for each TaskType automatically)

Run tests:

```bash
bundle exec rspec
```

If you'd like further improvements (admin authentication, API JSON endpoints, nicer UI, or additional tests), tell me and I'll add them next.
