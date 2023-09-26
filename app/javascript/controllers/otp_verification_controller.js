// import { Controller } from "@hotwired/stimulus"

// // Connects to data-controller="otp-verification"
// export default class extends Controller {
//   static targets = ["passwordField"];

//   connect() {
//     console.log("OTP Verification method")
//     this.hidePasswordField();
//   }

//   showPasswordField() {
//     this.passwordFieldTarget.style.display = "block";
//   }

//   hidePasswordField() {
//     this.passwordFieldTarget.style.display = "none";
//   }

//   onOtpChange(event) {
//     const otpValue = event.target.value;
//     if (/^\d{6}$/.test(otpValue)) {
//       this.showPasswordField();
//       // Trigger a Turbo Stream to replace the password field div
//       const frame = document.querySelector("[data-turbo-frame='password-frame']");
//       TurboStreams.visit(frame.getAttribute("id"));
//       this.hideErrorMessage(); // Hide the error message if OTP is valid
//     } else {
//       this.hidePasswordField();
//     }
//   }
// }