# Flask Based Weather App Deployment with Chef

This project demonstrates automated deployment of a Python Flask app using Chef.

## Structure

- `cookbooks/`: Contains the Chef cookbook `flask_app`.
- `recipes/default.rb`: Installs dependencies and configures Flask, Gunicorn, and Nginx.
- `templates/`: Includes Nginx and systemd templates.
- `Berksfile`: Manages cookbook dependencies.
- `.kitchen.yml`: Optional for local testing with Test Kitchen.

## Setup

1. Install ChefDK
2. Run `berks install`
3. Use `kitchen converge` to apply locally or use knife to deploy remotely

## App

The app is deployed to `/opt/flask_app` and served via Nginx at `http://localhost`.
