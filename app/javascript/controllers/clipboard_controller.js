import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static values = {
        url: String
      }

  generate(event) {
    event.preventDefault()
    // Make AJAX request to generate invite
    fetch(this.urlValue, {
      method: "GET",
      headers: {
        "Accept": "application/json, text/vnd.turbo-stream.html"
      }
    })
    .then(async (response) => {
      const contentType = response.headers.get("Content-Type");
      if (contentType.includes("application/json")) {
        const data = await response.json();
        this.copyToClipboard(data.link);
      } else if (contentType.includes("text/vnd.turbo-stream.html")) {
        const html = await response.text();
        const template = document.createElement("template");
        template.innerHTML = html.trim();
        const stream = template.content.querySelector("turbo-stream");

        if (stream) {
          const templateContent = stream.querySelector("template");
          if (templateContent) {
            const domTarget = document.getElementById("flash");
            domTarget.innerHTML = templateContent.innerHTML.trim();
          } else {
            console.error("No template content found in turbo-stream.");
          }
        } else {
          console.error("No turbo-stream element found in response.");
        }
      } else {
        throw new Error("Unsupported content type: " + contentType);
      }
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
