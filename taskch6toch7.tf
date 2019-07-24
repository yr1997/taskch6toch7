variable "heroku_email" {}
variable "heroku_api_key" {}


provider "heroku" {
  email   = "${var.heroku_email}"
  api_key = "${var.heroku_api_key}"
}

resource "heroku_app" "task_app" {
  name   = "taskch6toch7"
  region = "us"

}

resource "heroku_build" "task_build" {
  app = "${heroku_app.task_app.id}"
  
  source = {
    url = "https://github.com/yr1997/taskch6toch7/archive/v1.0.tar.gz"

  }
}


resource "heroku_addon" "database" {
  app  = "${heroku_app.task_app.name}"
  plan = "heroku-postgresql:hobby-dev"
}
