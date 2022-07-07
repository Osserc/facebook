import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="tab-swapping"
export default class extends Controller {
  static targets = [ "swapRibbonDefault", "swapRibbonBack", "swapTab", "swapTabDefault" ]

  connect() {
    console.log("Sup");
  }

  swap() {
    this.swapTabTargets.forEach(target => {
      target.classList.remove("dormant");
    });
    this.swapTabDefaultTarget.classList.add("dormant");
    this.swapRibbonDefaultTarget.classList.add("dormant");
    this.swapRibbonBackTarget.classList.remove("dormant");
  }

  unswap() {
    this.swapTabTargets.forEach(target => {
      target.classList.add("dormant");
    });
    this.swapTabDefaultTarget.classList.remove("dormant");
    this.swapRibbonDefaultTarget.classList.remove("dormant");
    this.swapRibbonBackTarget.classList.add("dormant");
  }
}
