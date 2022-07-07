import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="navbar-swapping"
export default class extends Controller {
  static targets = [ "navbar", "navbarShower" ]
  connect() {
    console.log("Always on");
  }

  swap() {
    this.navbarTarget.classList.add("active");
    this.navbarShowerTarget.classList.add("moved");
    this.navbarShowerTarget.dataset.action = "click->navbar-swapping#unswap";
  }

  unswap() {
    this.navbarTarget.classList.remove("active");
    this.navbarShowerTarget.classList.remove("moved");
    this.navbarShowerTarget.dataset.action = "click->navbar-swapping#swap";
  }
}
