variable "heroku_email" {}
variable "heroku_api_key" {}


provider "heroku" {
  email   = "${var.heroku_email}"
  api_key = "${var.heroku_api_key}"
}

resource "heroku_app" "default" {
  name   = "taskch6toch7"
  region = "us"
  
}

resource "heroku_addon" "database" {
  app  = "${heroku_app.default.name}"
  plan = "heroku-postgresql:hobby-dev"
}
