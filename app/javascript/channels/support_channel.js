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
                const messagesContainer = document.getElementById("messages");

                if (messagesContainer && data.html) {
                    messagesContainer.insertAdjacentHTML("beforeend", data.html);

                    // auto scroll
                    messagesContainer.scrollTop = messagesContainer.scrollHeight;
                }
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
