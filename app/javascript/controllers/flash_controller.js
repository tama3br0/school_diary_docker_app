import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    const flashMessages = document.getElementById('flash_messages');
    if (flashMessages) {
      flashMessages.style.display = 'block';
    }
  }
}
