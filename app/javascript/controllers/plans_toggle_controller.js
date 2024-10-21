import { Controller } from '@hotwired/stimulus'

// Connects to data-controller="plans-toggle"
export default class extends Controller {
    static targets = ['toggle', 'month', 'sixmonths', 'year']

    switch(event) {
        // Get the value of the selected radio button
        const selectedPlan = event.target.value;

        // Hide all targets initially
        this.monthTarget.classList.add('display-none');
        this.sixmonthsTarget.classList.add('display-none');
        this.yearTarget.classList.add('display-none');

        // Show the selected target based on the value of the selected radio button
        if (selectedPlan === 'monthly') {
            this.monthTarget.classList.remove('display-none');
        } else if (selectedPlan === 'six-monthly') {
            this.sixmonthsTarget.classList.remove('display-none');
        } else if (selectedPlan === 'yearly') {
            this.yearTarget.classList.remove('display-none');
        }
    }
}
