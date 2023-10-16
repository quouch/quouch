import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"

export default class extends Controller {
  static values = { chatId: Number, currentUserId: Number }
  static targets = ['messages', 'form']

  connect() {
    this.channel = createConsumer().subscriptions.create(
      { channel: 'ChatChannel', id: this.chatIdValue },
      { received: data => this.#insertMessageAndScrollDown(data) }
      )
      this.messagesTarget.lastElementChild.scrollIntoView(true, {block: 'end'})
    console.log(`Subscribed to the chat with the id ${this.chatIdValue}.`)
  }

  #insertMessageAndScrollDown(data) {
    const empty = document.querySelector('.chat__messages--empty')
    if (empty) empty.remove()
    const currentUserIsSender = this.currentUserIdValue === data.sender_id
    const messageElement = this.#buildMessageElement(currentUserIsSender, data.message)
    this.messagesTarget.insertAdjacentHTML('beforeend', messageElement)
    this.messagesTarget.lastElementChild.scrollIntoView(true, {block: 'end'})
    swal({
      title: 'Thank Quouch now for providing this service to you! 🙏',
      text: 'Support our team by donating to our crowdfunding campaign. Your support can save Quouch. The coolest rewards are waiting for you 🏆👀',
      button: 'Take me there!'
    }).then((result) => {
      if (result) {
        // If the user clicks "Yes, I have", open the link
        window.location.href = 'https://www.kickstarter.com/projects/norafromquouch/quouch-couch-surfing-for-queer-people-and-women/rewards';
      }
    })
  }

  #buildMessageElement(currentUserIsSender, message) {
    return `
      <div class="${this.#justifyClass(currentUserIsSender)}">
        <div class="${this.#userStyleClass(currentUserIsSender)}">
          ${message}
        </div>
      </div>
    `
  }

  #justifyClass(currentUserIsSender) {
    return currentUserIsSender ? "chat__message chat__message--right" : "chat__message chat__message--left"
  }

  #userStyleClass(currentUserIsSender) {
    return currentUserIsSender ? "message chat__sender" : "message chat__receiver"
  }

  resetForm(event) {
    event.preventDefault()
    event.target.reset()
  }

  disconnect() {
    console.log('Unsubscribed from the chat')
    this.channel.unsubscribe()
  }
}
