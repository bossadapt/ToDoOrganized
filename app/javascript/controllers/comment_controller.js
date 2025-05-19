import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["title","body"]
    clearForm(event){
        if (event.detail.success) {
            this.titleTarget.value = ""
            this.bodyTarget.value = ""
        }
    }
}
