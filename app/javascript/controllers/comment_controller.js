import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["title","body"]
    clearForm(event){
        console.log("submit was called at least")
        if (event.detail.success) {
            this.titleTarget.value = ""
            this.bodyTarget.value = ""
        }
    }
}
