import 'dart:io';

class TicTacToe {
  late List<List<String>> board;
  late String currentPlayer;
  late StringBuffer outputPre;
  String? winner;

  TicTacToe() {
    board = List.generate(3, (_) => List.filled(3, ' '));
    currentPlayer = 'X';
    outputPre = StringBuffer();
  }

  void printBoard() {
    outputPre.write('-------------\n');
    for (var row in board) {
      outputPre.write('| ${row[0]} | ${row[1]} | ${row[2]} |\n');
      outputPre.write('-------------\n');
    }
  }

  bool isValidMove(int row, int col) {
    return row >= 0 && row < 3 && col >= 0 && col < 3 && board[row][col] == ' ';
  }

  void makeMove(int row, int col) {
    if (isValidMove(row, col)) {
      board[row][col] = currentPlayer;
      printBoard();
      if (checkWin(row, col)) {
        winner = currentPlayer;
        outputPre.write('$winner wins!\n');
        restartGameAfterDelay();
      } else {
        checkDraw();
        switchPlayer();
        promptPlayer();
      }
    } else {
      outputPre.write('Invalid move. Please try again.\n');
      promptPlayer(); // Prompt the same player again
    }
  }

  void switchPlayer() {
    currentPlayer = (currentPlayer == 'X') ? 'O' : 'X';
  }

  bool checkWin(int row, int col) {
    return board[row].every((element) => element == currentPlayer) ||
        board.every((row) => row[col] == currentPlayer) ||
        (row == col &&
            board[0][0] == currentPlayer &&
            board[1][1] == currentPlayer &&
            board[2][2] == currentPlayer) ||
        (row + col == 2 &&
            board[0][2] == currentPlayer &&
            board[1][1] == currentPlayer &&
            board[2][0] == currentPlayer);
  }

  void checkDraw() {
    if (!board.any((row) => row.contains(' '))) {
      winner = null;
      outputPre.write('The game is a draw!\n');
      restartGameAfterDelay();
    }
  }

  void restartGameAfterDelay() {
    Future.delayed(Duration(seconds: 3), () {
      outputPre.write('Restarting game...\n');
      resetGame();
      playGame();
    });
  }

  void playGame() {
    outputPre.write('Welcome to Tic-Tac-Toe!\n');
    printBoard();
    promptPlayer();
  }

  void promptPlayer() {
    if (winner != null) {
      outputPre.write('Player $winner is the winner!\n');
      stdout.write(outputPre);
    } else {
      outputPre.write('Player $currentPlayer, enter a number between 1 and 9:\n');
      stdout.write(outputPre);

      String? move = stdin.readLineSync();

      if (move != null && move.isNotEmpty) {
        var parsedMove = int.tryParse(move);

        if (parsedMove != null && parsedMove >= 1 && parsedMove <= 9) {
          var row = (parsedMove - 1) ~/ 3;
          var col = (parsedMove - 1) % 3;
          makeMove(row, col);
        } else {
          outputPre.write('Invalid input. Please enter a number between 1 and 9.\n');
          promptPlayer(); // Prompt the same player again
        }
      } else {
        outputPre.write('Invalid input. Please enter a number between 1 and 9.\n');
        promptPlayer(); // Prompt the same player again
      }
    }
  }

  void resetGame() {
    board = List.generate(3, (_) => List.filled(3, ' '));
    currentPlayer = 'X';
    outputPre.clear();
    winner = null;
  }
}

void main() {
  TicTacToe game = TicTacToe();
  game.playGame();
}
