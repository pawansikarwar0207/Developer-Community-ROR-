import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="autocomplete"
export default class extends Controller {

  static targets = ["input", "results"];

  connect() {
    console.log('autocomplete connected!!!')
    this.hideResults();
    this.inputTarget.addEventListener("input", this.search.bind(this));
  }

  search(){
    const query = this.inputTarget.value;
    fetch(`/autocomplete?q=${query}`)
    .then((response) => response.json())
    .then((data) => {
      this.displayResults(data);
    });
  }

  displayResults(data){
    console.log('displayResults called')
    this.resultsTarget.innerHTML = "";
    data.forEach((result) => {
      const resultElement = document.createElement("div");
      resultElement.textContent = result;
      resultElement.addEventListener("click", () => {
        this.selectResult(result);
      });
      this.resultsTarget.appendChild(resultElement);
    });

    // Show the results container
    this.showResults();
  }

  selectResult(result) {
    // Handle the selection of a result, e.g., populate the input field
    this.inputTarget.value = result;

    // Hide the results container
    this.hideResults();
  }

  showResults() {
    this.resultsTarget.classList.add("show"); // Add a CSS class to show the dropdown
  }

    hideResults() {
    this.resultsTarget.classList.remove("show"); // Remove the CSS class to hide the dropdown
  }


}
