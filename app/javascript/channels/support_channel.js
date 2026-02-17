// app/javascript/channels/support_chat_channel.js
import consumer from "./consumer"

document.addEventListener("turbolinks:load", () => {
    const messagesDivs = document.querySelectorAll("[id^='messages_']")
    messagesDivs.forEach((messagesDiv) => {
        const conversationId = messagesDiv.dataset.conversationId
        if (!conversationId) return

        const subscription = consumer.subscriptions.create(
            { channel: "SupportChatChannel", conversation_id: conversationId },
            {
                connected() { console.log("Connected to SupportChatChannel", conversationId) },
                received(data) {
                    if (data.html) {
                        messagesDiv.insertAdjacentHTML("beforeend", data.html)
                        messagesDiv.scrollTop = messagesDiv.scrollHeight
                    }
                }
            }
        )

        const forms = document.querySelectorAll(`[id^='message_form_${conversationId}']`)
        forms.forEach(form => {
            console.log("user form", form)
            form.addEventListener("ajax:success", () => {
                form.querySelector("input[type='text']").value = ""
                console.log("wefkjn")
            })
        })
    })
})
