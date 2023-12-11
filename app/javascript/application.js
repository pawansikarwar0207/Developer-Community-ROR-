// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import * as bootstrap from "bootstrap"

import Rails from '@rails/ujs'
Rails.start()

// window.bootstrap = bootstrap;

import 'bootstrap';
import { Application } from "@hotwired/stimulus";

// import moment from 'moment';
// import { Calendar } from '@fullcalendar/core';

//const application = Application.start();
//const context = require.context("../controllers", true, /\.js$/);
//application.load(context);import "trix"


import ("trix")
import ("@rails/actiontext")
