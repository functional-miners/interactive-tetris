import * as commons from "./commons";

function drawSquare(context, x, y, brush) {
  let side = 25;
  let trueX = side * x;
  let trueY = side * y;

  context.fillStyle = brush;
  context.fillRect(trueX, trueY, side, side);
}

function drawPixelArray(context, pixelArray, initialX, initialY) {
  for(let i = 0; i < pixelArray.length; ++i) {
    for(let j = 0; j < pixelArray[0].length; ++j) {
      let number = pixelArray[i][j];
      let brush;

      switch(number) {
        case 0:
          brush = commons.brushFor("background");
          break;

        default:
          brush = commons.brushFor(commons.shapeFrom(number));
          break;
      }

      drawSquare(context, initialX + j, initialY + i, brush);
    }
  }
}

function clearNext(context){
  let emptyNext = [
    [0,0,0,0],
    [0,0,0,0],
    [0,0,0,0],
    [0,0,0,0]
  ];

  drawPixelArray(context, emptyNext, 0, 0);
}

function drawNextPiece(context, next) {
  let center = commons.centerFor(commons.getNumberFrom(next));

  drawPixelArray(context, next, center.x, center.y);
}

function drawFrame(context, board) {
  let brush = commons.brushFor("board");
  let boardWidth = board[0].length;
  let boardHeight = board.length;

  for(let x = 0; x <= boardWidth + 1; ++x) {
    drawSquare(context, x, boardHeight, brush);
  }

  for(let y = 0; y < boardHeight; ++y) {
    drawSquare(context, 0, y, brush);
    drawSquare(context, boardWidth + 1, y, brush);
  }
}

function drawNext(context, next) {
  clearNext(context);
  drawNextPiece(context, next);
}

function drawBoard(context, board) {
  drawFrame(context, board);
  drawPixelArray(context, board, 1, 0);
}

function draw(mainContext, previewContext, state) {
  drawBoard(mainContext, state.board);
  drawNext(previewContext, state.next);
}

export default draw;
