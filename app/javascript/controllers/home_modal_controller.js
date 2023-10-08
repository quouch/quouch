import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="home-modal"
export default class extends Controller {
  connect() {
    swal({
      title: '🚨 We need you.',
      text: 'Have you already donated to our CROWDFUNDING CAMAPIGN? Your support can save Quouch. Check out the REWARDS you can get in return 👀',
      button: 'Take me there!'
    }).then((result) => {
      if (result) {
        // If the user clicks "Yes, I have", open the link
        window.location.href = 'https://www.kickstarter.com/projects/norafromquouch/quouch-couch-surfing-for-queer-people-and-women/rewards';
      }
    })
  }
}