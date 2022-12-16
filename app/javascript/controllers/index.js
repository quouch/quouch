import { Application } from '@hotwired/stimulus'

import ChatSubscriptionController from "./chat_subscription_controller"

window.Stimulus = Application.start()
Stimulus.register("chat-subscription", ChatSubscriptionController)
