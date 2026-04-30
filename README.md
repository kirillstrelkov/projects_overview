# Projects Overview

Projects Overview is a Ruby on Rails application designed to manage and track projects and their respective due dates or milestones.

## Features

- **Project Management:** Create, read, update, and delete projects. Projects have a name, description, and an overall progress indicator.
- **Milestone Tracking (Due Dates):** Manage due dates associated with specific projects. You can define a start date, end date, and weekly milestones with their respective progress percentages.
- **Authentication:** User authentication is handled by Devise. It supports OAuth integrations for Facebook, Google, and Vkontakte.
- **Admin Dashboard:** Includes a Rails Admin interface (`/admin`) for easy database management.
- **Visualizations:** Integrates with Vis.js for potential data visualizations.
- **Trello Integration:** Includes foundational routes and a controller for Trello integration.

## Tech Stack

- **Ruby:** 3.3.5
- **Rails:** 7.2.0
- **Database & Cache:** PostgreSQL, Redis
- **Frontend:** Bootstrap 3, jQuery, Font Awesome, Haml, Sass, Vis.js, Simple Form
- **Authentication:** Devise, OmniAuth (Facebook, Google, Vkontakte)
- **Admin:** Rails Admin
- **Testing:** RSpec, Cucumber, Capybara, Factory Bot, Faker, Database Cleaner
- **Code Quality:** RuboCop
- **Utilities:** Will Paginate, Jbuilder

## Getting Started

1. Clone the repository.
2. Install dependencies: `bundle install`
3. Setup database: `rails db:setup` (or `rails db:create db:migrate`)
4. Start the Rails server: `rails server`
