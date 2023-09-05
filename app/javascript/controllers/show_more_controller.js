import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["description", "toggleButton"];

  connect() {
    console.log('show more connected!!!')
    this.showLess();
    this.truncateDescription();
  }

  toggleVisibility() {
    if (this.isDescriptionVisible()) {
      this.showLess();
    } else {
      this.showMore();
    }
  }

  showMore() {
    this.descriptionTarget.style.maxHeight = "none";
    this.toggleButtonTarget.textContent = "Show Less";
  }

  showLess() {
    this.descriptionTarget.style.maxHeight = "4em";
    this.toggleButtonTarget.textContent = "Show More";
  }

  isDescriptionVisible() {
    return this.descriptionTarget.style.maxHeight !== "4em";
  }

  truncateDescription() {
    const maxHeight = "4em";
    if (this.descriptionTarget.scrollHeight > parseInt(maxHeight)) {
      this.descriptionTarget.style.maxHeight = maxHeight;
      this.descriptionTarget.style.overflow = "hidden"; // Add overflow: hidden;
      this.toggleButtonTarget.style.display = "block";
    }
  } 
}
