import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"

export default class extends Controller {
  static values = { chatId: Number, currentUserId: Number }
  static targets = ['messages', 'form']

  connect() {
    this.messagesTarget.scrollIntoView(true, {block: 'end'})
    this.channel = createConsumer().subscriptions.create(
      { channel: 'ChatChannel', id: this.chatIdValue },
      { received: data => this.#insertMessageAndScrollDown(data) }
    )
    console.log(`Subscribed to the chat with the id ${this.chatIdValue}.`)
  }

  #insertMessageAndScrollDown(data) {
    const empty = document.querySelector('.chat__messages--empty')
    if (empty) empty.style.remove()
    const currentUserIsSender = this.currentUserIdValue === data.sender_id
    const messageElement = this.#buildMessageElement(currentUserIsSender, data.message)
    this.messagesTarget.insertAdjacentHTML('beforeend', messageElement)
    this.messagesTarget.scrollTo(0, this.messagesTarget.scrollHeight)
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
    return currentUserIsSender ? "chat__message chat__message--left" : "chat__message chat__message--right"
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
