import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="autocomplete"
export default class extends Controller {

  static targets = ["input", "results"];

  connect() {
    console.log('autocomplete connected!!!')
    // this.hideResults();
    this.inputTarget.addEventListener("input", this.search.bind(this));
    this.resultsTarget.addEventListener("click", this.handleResultClick.bind(this));
  }

  search(){
    const query = this.inputTarget.value;
    const url = `/posts/autocomplete?q=${query}`;
    fetch(url, {
      method: "GET", // Make sure it's a GET request for autocomplete.
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content,
      },
    })
    .then((response) => response.json())
    .then((data) => {
      this.displayResults(data);
    });
  }

  handleResultClick(event) {
    if (event.target.tagName === "LI") {
      const selectedTitle = event.target.textContent;
      this.inputTarget.value = selectedTitle;
      this.resultsTarget.innerHTML = ""; // Clear the results

      // Trigger a search for posts when an item is selected
      this.searchPosts(selectedTitle);
    }
  }

  searchPosts(title) {
    // Make an AJAX request to search for posts with the selected title
    fetch(`/posts/search?title=${title}`)
      .then((response) => response.json())
      .then((data) => {
        // Handle the search results as needed
        console.log(data);
      });
  }

  displayResults(results){
    this.resultsTarget.innerHTML = "";

    results.forEach((post) => {
      this.resultsTarget.classList.add("show");
      const listItem = document.createElement("li");
      listItem.textContent = post.title;
      this.resultsTarget.appendChild(listItem);
    });
  }

  selectResult(result) {
    // Handle the selection of a result, e.g., populate the input field
    this.inputTarget.value = result;

    // Hide the results container
    this.hideResults();
  }

  // showResults() {
  //   this.resultsTarget.classList.add("show"); // Add a CSS class to show the dropdown
  // }

  // hideResults() {
  //   this.resultsTarget.classList.remove("show"); // Remove the CSS class to hide the dropdown
  // }


}
