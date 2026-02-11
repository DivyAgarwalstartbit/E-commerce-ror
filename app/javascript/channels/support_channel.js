// app/javascript/channels/support_chat_channel.js
import consumer from "./consumer"

document.addEventListener("turbolinks:load", () => {
    const messagesDiv = document.getElementById("messages")
    if (!messagesDiv) return

    const conversationId = messagesDiv.dataset.conversationId
    if (!conversationId) {
        console.error("No conversationId found!")
        return
    }

    consumer.subscriptions.create(
        { channel: "SupportChatChannel", conversation_id: conversationId },
        {
            connected() {
                console.log("Connected to SupportChatChannel for conversation", conversationId)
            },
            received(data) {
                console.log("Received data:", data)
                const div = document.createElement("div")
                div.className = `message ${data.sender.toLowerCase()}`
                div.innerHTML = `<strong>${data.sender}:</strong> ${data.body}`
                messagesDiv.appendChild(div)
                messagesDiv.scrollTop = messagesDiv.scrollHeight
            }
        }
    )

    const messageForm = document.getElementById("message_form")
    if (messageForm) {
        messageForm.addEventListener("ajax:success", () => {
            messageForm.querySelector("input[type='text']").value = ""
        })
    }
})
