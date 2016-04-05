import {Socket} from "phoenix";

function translateKeyToEvent(event) {
  let key = event.keyIdentifier || event.key;

  switch(key){
    case "Left":
    case "ArrowLeft":
      return "move_left";

    case "Right":
    case "ArrowRight":
      return "move_right";

    case "Up":
    case "ArrowUp":
      return "rotate_cw";

    default:
      return "noop";
  }
}

const ID_EXTRACTOR = /\/rooms\/([a-zA-Z0-9]{8}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{12})\/game/;

let roomNameElement;
let pointsElement;
let connectedClientsElement;

let onTick = (handler) => {
  let parts = ID_EXTRACTOR.exec(window.location.pathname);

  if (Array.isArray(parts) && parts.length > 1) {
    let roomId = parts[1];

    roomNameElement = document.querySelector("#room-name");
    pointsElement = document.querySelector("#points");
    connectedClientsElement = document.querySelector("#connected-clients-count");

    let socket = new Socket("/ws");
    socket.connect();

    let channel = socket.channel("tetris", { roomId: roomId });

    channel.on("game:state", state => {
      handler(state);

      roomNameElement.innerText = state.name;
      pointsElement.innerText = state.points;
      connectedClientsElement.innerText = state.connected_users;
    });

    channel.join()
      .receive("ok", state => {
        console.info("Connected successfully to the channel: %s", roomId);
      })
      .receive("error", error => {
        console.error("Unable to join because of error:", error);
      });

    window.onkeyup = function(event) {
      event.preventDefault();
      channel.push("event", { event: translateKeyToEvent(event) });
    };
  } else {
    console.error("Cannot connect to the channel with unknown RoomId:", window.location.pathname);
  }
};

export default onTick;
