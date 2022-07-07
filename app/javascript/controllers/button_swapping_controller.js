import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="button-swapping"
export default class extends Controller {
  static targets = [ "editButton", "editForm" ]

  connect() {
  }

  swap() {
    this.editFormTarget.action = `${this.editButtonTarget.dataset.value.slice(0, -5)}`;
    this.editButtonTarget.dataset.value = `${this.editButtonTarget.dataset.value.slice(0, -5)}`;
    this.editFormTarget.dataset.action = "turbo:frame-load@window->button-swapping#unswap"
    this.editButtonTarget.innerHTML = "Close"
  }

  unswap() {
    this.editFormTarget.action = `${this.editButtonTarget.dataset.value}` + `/edit`;
    this.editButtonTarget.dataset.value = `${this.editButtonTarget.dataset.value}` + `/edit`;
    this.editFormTarget.dataset.action = "turbo:frame-load@window->button-swapping#swap";
    this.editButtonTarget.innerHTML = "Edit"
  }
}