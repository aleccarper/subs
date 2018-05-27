// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".

// To use Phoenix channels, the first step is to import Socket
// and connect at the socket path in "lib/web/endpoint.ex":
import {Socket} from "phoenix"

let socket = new Socket("/socket", {params: {token: window.userToken}})

socket.connect()

var player_id = "muh_player"+Math.random()
let channel           = socket.channel("game", player_id)
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
    this._geometry = new THREE.BoxGeometry( 1, 1, 1 );
    this._material = new THREE.MeshBasicMaterial( { color: 0x00ff00 } );
    this._model = new THREE.Mesh( this._geometry, this._material );
    scene.add(this._model);
  }

  update(data) {
    this._data = data
    this._model.position.x = this._data.position.x
    this._model.position.y = this._data.position.y
  }

  position() {
    return this._data.position
  }
}

function update_sub(data) {
  if (subs[data.player_id] == null) {
    subs[data.player_id] = new Sub(data)
  }

  subs[data.player_id].update(data)
}

var scene = new THREE.Scene();
var camera = new THREE.PerspectiveCamera( 75, window.innerWidth/window.innerHeight, 0.1, 1000 );

var renderer = new THREE.WebGLRenderer();
renderer.setSize( window.innerWidth, window.innerHeight );
document.body.appendChild( renderer.domElement );

camera.position.z = 25;

var animate = function () {
  requestAnimationFrame( animate );
  if (subs[player_id] != null) {
    camera.position.x = subs[player_id].position().x
    camera.position.y = subs[player_id].position().y
  }
  renderer.render(scene, camera);
};

animate();



export default socket
