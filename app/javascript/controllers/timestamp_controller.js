import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="timestamp"
export default class extends Controller {
  static targets = ['created']
  static values = {
    time: String
  }

  connect() {
    this.adjustTimezone();
  }

  adjustTimezone() {
    const utcTime = new Date(this.timeValue);
    const monthNames = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'];
    const month = monthNames[utcTime.getMonth()];
    const day = utcTime.getDate();
    const localTimeStr = utcTime.toLocaleString('en-US', {
      hour: '2-digit',
      minute: '2-digit',
      hour12: true
    });
    this.createdTarget.innerText = `${month} ${day} ⋅ ${localTimeStr}`;
  }
}