import { Controller } from "@hotwired/stimulus"
export default class extends Controller {
    static targets = ["title","description","priority","assigned"]
    clearForm(event){
        console.log("submit was called at least");
        
        if (event.detail.success) {
            const modal = document.getElementById("newProjectEntryModal");
            const modalInstance = window.bootstrap.Modal.getOrCreateInstance(modal)
            modalInstance.hide();
            this.titleTarget.value = "";
            this.descriptionTarget.value = "";
            this.priorityTarget.value = "";
            this.assignedTarget.value = "";
        }
    }
    static values = {
        url: String
      }

      show(event) {
        event.preventDefault()
        const modal = document.getElementById("displayProjectEntryModal")
        const modalInstance = window.bootstrap.Modal.getOrCreateInstance(modal)
        const frame = document.querySelector("turbo-frame#project_entry_frame")
        if (frame && this.urlValue) {
          frame.src = this.urlValue
        }
        modalInstance.show();
        
      }
}
