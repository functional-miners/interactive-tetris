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

let onTick = (handler) => {
  // TODO: Update UI with current data.
  // TODO: Get room_id from URL.

  let roomId = "abcdef";

  let socket = new Socket("/ws");
  socket.connect();

  let channel = socket.channel("tetris", { roomId: roomId });

  channel.on("game:state", state => {
    handler(state);
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
};

export default onTick;
