import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static values = {
        url: String
      }

  generate(event) {
    event.preventDefault()
    console.log("generate was called")
    // Make AJAX request to generate invite
    console.log("url: "+ this.urlValue)
    fetch(this.urlValue, {
      method: "GET",
      headers: {
        "Accept": "application/json"
      }
    })
    .then(response => response.json())
    .then(data => {
      // Copy to clipboard
      console.log(data)
      this.copyToClipboard(data.link)
    })
    .catch(error => console.error("Error generating invite:", error))
  }

  copyToClipboard(link) {
    navigator.clipboard.writeText(link)
      .then(() => {
        alert("Invite link copied to clipboard!")
      })
      .catch(err => {
        console.error("Failed to copy to clipboard:", err)
      })
  }
}
