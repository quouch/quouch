import { Controller } from '@hotwired/stimulus';
import Toastify from 'toastify-js'

export default class extends Controller {
  static targets = ['link', 'note'];

  copyLink(event) {
    navigator.clipboard.writeText(this.linkTarget.value);
    Toastify({
      text: 'Copied!',
      // duration: 3000,
      destination: "https://github.com/apvarun/toastify-js",
      newWindow: true,
      gravity: 'bottom', // `top` or `bottom`
      position: 'center', // `left`, `center` or `right`
      stopOnFocus: true, // Prevents dismissing of toast on hover
      style: {
        background: '#F3EAF6',
        padding: '.7rem 1rem',
        borderRadius: '16px',
        width: 'fit-content',
        color: '#333333'
      },
      onClick: function(){} // Callback after click
    }).showToast();
  }
}