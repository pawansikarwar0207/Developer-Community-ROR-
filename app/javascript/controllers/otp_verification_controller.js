import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="otp-verification"
export default class extends Controller {

  connect() {
    console.log("OTP Verification method")
  }

}
