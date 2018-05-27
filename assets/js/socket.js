// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".

// To use Phoenix channels, the first step is to import Socket
// and connect at the socket path in "lib/web/endpoint.ex":
import {Socket} from "phoenix"

let socket = new Socket("/socket", {params: {token: window.userToken}})

socket.connect()

// Now that you are connected, you can join channels with a topic:
let channel           = socket.channel("game", "muh_player"+Math.random())
let chatInput         = document.querySelector("#chat-input")
let messagesContainer = document.querySelector("#messages")

channel.on("sub:move", payload => {
  update_sub(payload)
})

channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })



var subs = new Map()

class Sub {
  constructor(data) {
    this._data = data
    this._element = document.createElement("div")
    this._element.setAttribute("class", "sub")
    messagesContainer.appendChild(this._element)
  }

  update(data) {
    this._data = data
    this._element.setAttribute("style", "left: " + this._data.position.x + "px; top: "+this._data.position.y+"px;")
  }

}

function update_sub(data) {
  if (subs[data.player_id] == null) {
    subs[data.player_id] = new Sub(data)
  }

  subs[data.player_id].update(data)
}

export default socket
