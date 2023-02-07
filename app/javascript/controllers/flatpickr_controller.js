import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr";

// Connects to data-controller="flatpickr"
export default class extends Controller {
  static targets = [ "startTime", "endTime" ]

  connect() {
    flatpickr(this.startTimeTarget, {
      format: "d.m.y",
      altFormat: "d.m.y",
      altInput: true,
      defaultDate: Date.today
    })
    flatpickr(this.endTimeTarget, {
      format: "d.m.y",
      altFormat: "d.m.y",
      altInput: true,
      defaultDate: Date.tomorrow
    })
  }
}
