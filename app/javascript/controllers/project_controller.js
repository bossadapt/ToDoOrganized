import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["title"];
  static values = {
    id: String,
  };

  correctProjectName(event) {
    // Log the domId value
    console.log("domId:", this.domIdValue);
    const titleInput = this.titleTarget.value;
    const listEntry = document.getElementById(this.idValue);
    if (listEntry) {
      const listContents = listEntry.getElementsByTagName("a")[0];
      if (listContents) {
        listContents.innerText = titleInput;
      }
    }
  }
}
