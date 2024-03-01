import { Controller } from '@hotwired/stimulus'
import flatpickr from 'flatpickr';

// Connects to data-controller='flatpickr'
export default class extends Controller {
  static targets = [ 'startTime', 'endTime' ]

  connect() {
    flatpickr(this.startTimeTarget, this.#options(true))
    flatpickr(this.endTimeTarget, this.#options(false))
  }

  #options(isStart) {
    return {
      altFormat: 'd.m.y',
      altInput: true,
      defaultDate: isStart ? Date.today :  Date.tomorrow,
      minDate: 'today'
    }
  }

  updateEnd() {
    const fpStart = this.startTimeTarget;
    const fpEnd = flatpickr(this.endTimeTarget, this.#options(false) );
    fpEnd.set('minDate', this.#dayAfter(fpStart.value));
    console.log(fpEnd)
  }

  #dayAfter(date) {
    const result = new Date(date);
    result.setDate(result.getDate() + 1);
    return result;
  }
}
