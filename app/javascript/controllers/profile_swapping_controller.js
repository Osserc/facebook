import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="profile-swapping"
export default class extends Controller {
  static targets = [ "swapRibbonDefault", "swapRibbonBack", "swapTab", "swapTabDefault"  ]

  connect() {
  }

  swap() {
    this.swapTabTarget.classList.remove("dormant");
    this.swapTabDefaultTarget.classList.add("dormant");
    this.swapRibbonDefaultTarget.classList.add("dormant");
    this.swapRibbonBackTarget.classList.remove("dormant");
  }

  unswap() {
    this.swapTabTarget.classList.add("dormant");
    this.swapTabDefaultTarget.classList.remove("dormant");
    this.swapRibbonDefaultTarget.classList.remove("dormant");
    this.swapRibbonBackTarget.classList.add("dormant");
  }
}
