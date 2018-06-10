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

channel.on("torpedo:move", payload => {
  update_torpedo(payload)
})


channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })


var subs = new Map()
var torpedos = new Map()

class Sub {
  constructor(data) {
    this._data = data
    this._geometry = new THREE.SphereGeometry(1, 50, 50, 0, Math.PI * 1, 0, Math.PI * 1);
    this._material = new THREE.MeshBasicMaterial( { color: '#'+(0x1000000+(Math.random())*0xffffff).toString(16).substr(1,6) } );
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

class Torpedo {
  constructor(data) {
    this._data = data
    this._geometry = new THREE.SphereGeometry(0.5, 50, 50, 0, Math.PI * 1, 0, Math.PI * 1);
    this._material = new THREE.MeshBasicMaterial( { color: '#'+(0x1000000+(Math.random())*0xffffff).toString(16).substr(1,6) } );
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

document.addEventListener('keydown', function(event) {
  if (event.repeat) {
    return
  }
  switch(event.code) {
    case 'KeyA':
      sendStartDirection("left")
      break;
    case 'KeyS':
      sendStartDirection("down")
      break;
    case 'KeyD':
      sendStartDirection("right")
      break;
    case 'KeyW':
      sendStartDirection("up")
      break;
    case 'KeyJ':
      fireTorpedo("left")
      break;
    case 'KeyK':
      fireTorpedo("down")
      break;
    case 'KeyL':
      fireTorpedo("right")
      break;
    case 'KeyI':
      fireTorpedo("up")
      break;
  }
});

document.addEventListener('keyup', function(event) {
  if (event.repeat) {
    return
  }
  switch(event.code) {
    case 'KeyA':
      sendEndDirection("left")
      break;
    case 'KeyS':
      sendEndDirection("down")
      break;
    case 'KeyD':
      sendEndDirection("right")
      break;
    case 'KeyW':
      sendEndDirection("up")
      break;
  }
});

function sendStartDirection(direction) {
  channel.push("sub:start_direction", {player_id: player_id, direction: direction})
}

function sendEndDirection(direction) {
  channel.push("sub:end_direction", {player_id: player_id, direction: direction})
}

function fireTorpedo(direction) {
  channel.push("sub:fire_torpedo", {player_id: player_id, direction: direction})
}


function update_sub(data) {
  if (subs[data.id] == null) {
    subs[data.id] = new Sub(data)
  }

  subs[data.id].update(data)
}

function update_torpedo(data) {
  if (torpedos[data.id] == null) {
    torpedos[data.id] = new Torpedo(data)
  }

  torpedos[data.id].update(data)
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
