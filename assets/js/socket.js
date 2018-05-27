// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".

// To use Phoenix channels, the first step is to import Socket
// and connect at the socket path in "lib/web/endpoint.ex":
import {Socket} from "phoenix"

let socket = new Socket("/socket", {params: {token: window.userToken}})

socket.connect()

// Now that you are connected, you can join channels with a topic:
let channel           = socket.channel("game", "muh_player")
let chatInput         = document.querySelector("#chat-input")
let messagesContainer = document.querySelector("#messages")

channel.on("sub:move", payload => {
  let messageItem = document.createElement("li");
  messageItem.innerText = payload.position.x;
  messagesContainer.appendChild(messageItem);
});

// chatInput.addEventListener("keypress", event => {
//   if(event.keyCode === 13){
//     channel.push("new_msg", {body: chatInput.value})
//     chatInput.value = ""
//   }
// })

channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })

export default socket
