import { Controller } from "@hotwired/stimulus"
export default class extends Controller {
    static targets = ["title","description","priority"]
    clearForm(event){
        console.log("submit was called at least");
        
        if (event.detail.success) {
            let modal = document.getElementById("exampleModal");
            let modalInstance = window.bootstrap.Modal.getInstance(modal)
            modalInstance.hide();
            this.titleTarget.value = ""
            this.descriptionTarget.value = ""
            this.priorityTarget.value = ""
        }
    }
}
