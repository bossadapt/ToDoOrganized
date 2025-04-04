import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["buttonText"]
    select(event){
        this.buttonTextTarget.innerText = event.target.text
    }
}