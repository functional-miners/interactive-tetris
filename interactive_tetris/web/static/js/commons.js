function brushFor(type) {
  switch(type) {
    case "board":      return "rgb(0,0,0)";
    case "background": return "rgb(255, 255, 255)";
    case "ell":        return "rgb(255, 150, 0)";
    case "jay":        return "rgb(12, 0, 255)";
    case "ess":        return "rgb(5, 231, 5)";
    case "zee":        return "rgb(255, 17, 17)";
    case "bar":        return "rgb(0, 240, 255)";
    case "oh":         return "rgb(247, 255, 17)";
    case "tee":        return "rgb(100, 255, 17)";
  }

  return "rgb(128, 128, 128)";
}

function shapeFrom(number) {
  switch(number) {
    case 1: return "ell";
    case 2: return "jay";
    case 3: return "ess";
    case 4: return "zee";
    case 5: return "bar";
    case 6: return "oh";
    case 7: return "tee";
  }

  return "";
}

function getNumberFrom(piece) {
  return Math.max.apply(null, [].concat.apply([], piece));
}

function centerFor(number) {
  switch(number) {
    case 1: return { x: 1, y: 0 };
    case 2: return { x: 1, y: 0 };
    case 3: return { x: 1, y: 1 };
    case 4: return { x: 1, y: 1 };
    case 5: return { x: 0, y: 2 };
    case 6: return { x: 1, y: 1 };
    case 7: return { x: 0, y: 1 };
  }

  return { x: 0, y: 0 };
}

export { brushFor, shapeFrom, getNumberFrom, centerFor };
