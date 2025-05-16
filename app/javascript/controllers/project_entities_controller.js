import { Controller } from "@hotwired/stimulus"
export default class extends Controller {
    static targets = ["peid","title","description","priority","assigned"]
    handleDelete(event){
      this.closeShowModal(event)
      this.cleanUpLooseEndActions(event)
    }
    clearForm(event){
      console.log("Form clearing attempted");

        if (event.detail.success) {
            console.log("Form clearing started");
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
      url: String,
      peid: String//project entry id
    }
    //remove onclicks from the deleted project entry actions and change the id to Deleted Entry
    cleanUpLooseEndActions(event) {
      const actionBody = document.getElementById("actions_body");
      if (!actionBody) {
        console.error("No actions_body element found");
        return;
      }
    
      // Iterate over the child elements of #actions_body
      const actions = actionBody.children;
      for (let actionIndex = 0; actionIndex < actions.length; actionIndex++) {
        const currentAction = actions[actionIndex];
    
        // Find the <h4> tag containing the ID
        const idElement = currentAction.querySelector("h4");
        if (idElement && idElement.innerHTML.trim() === this.peidValue.toString()) {
          // Remove the onclick attribute
          currentAction.removeAttribute("onclick");
    
          // Update the innerHTML to indicate the entry was deleted
          idElement.innerHTML = "Deleted Entry";
        }
      }
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
      closeShowModal(){
        console.log("closing show modal");
        const modal = document.getElementById("displayProjectEntryModal");
        const modalInstance = window.bootstrap.Modal.getOrCreateInstance(modal)
        modalInstance.hide();
    }
}
