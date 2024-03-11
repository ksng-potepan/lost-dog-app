# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
pin "passwords/new", preload: false
pin "passwords/edit", preload: false
pin "passwords/session", preload: false
pin "layouts/hamburger", preload: false
pin "ambles/step-form", preload: false
pin "ambles/modal", preload: false
pin "protects/step-form", preload: false
pin "protects/modal", preload: false
