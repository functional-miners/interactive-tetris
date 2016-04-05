import {Socket} from "phoenix";

function translateKeyToEvent(event) {
  let key = event.keyIdentifier || event.key;

  switch(key) {
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

function translateToHumanFriendlyMove(event) {
  switch(event) {
    case "move_left":
      return "moved current piece to the left";

    case "move_right":
      return "moved current piece to the right";

    case "rotate_cw":
      return "rotated current piece";
  }

  return "did nothing.";
}

const ID_EXTRACTOR = /\/rooms\/([a-zA-Z0-9]{8}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{4}-[a-zA-Z0-9]{12})\/game/;

let roomNameElement;
let pointsElement;
let connectedClientsElement;

let historyContainerElement;

let onTick = (handler) => {
  let parts = ID_EXTRACTOR.exec(window.location.pathname);

  if (Array.isArray(parts) && parts.length > 1) {
    let roomId = parts[1];

    roomNameElement = document.querySelector("#room-name");
    pointsElement = document.querySelector("#points");
    connectedClientsElement = document.querySelector("#connected-clients-count");

    historyContainerElement = document.querySelector("#history-container");

    let socket = new Socket("/ws");
    socket.connect();

    let channel = socket.channel("tetris", { roomId: roomId, user: window.USERNAME });

    channel.on("game:state", state => {
      if (state.active) {
        handler(state);

        roomNameElement.innerText = state.name;
        pointsElement.innerText = state.points;
        connectedClientsElement.innerText = state.connected_users;
      } else {
        channel.push("end", { roomId: roomId });
      }
    });

    channel.on("game:end", () => {
      window.location.pathname = window.location.pathname.replace("game", "summary");
    });

    channel.on("game:movement", movement => {
      if (movement.event !== "noop") {
        let historyElement = document.createElement("div");

        historyElement.classList.add("history-element");
        historyElement.innerText = `User '${movement.user}' ${translateToHumanFriendlyMove(movement.event)}.`;

        historyContainerElement.appendChild(historyElement);
        historyContainerElement.scrollTop = historyContainerElement.scrollHeight;
      }
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
    console.error("Cannot connect to the channel with unknown room ID:", window.location.pathname);
  }
};

export default onTick;
