**Introduction**

Turn-based strategy games have remained popular for a long time. The game of chess, which dates back nearly 5000 years, is a good example. Despite having straightforward rules, these games provide infinite possibilities and react to human competition, offering players a very exciting experience.

Turn-based strategy games swiftly migrated to computers as the digital era came into being. The 1967 video game "Feudal," created by Steve Estvanik, is an early example of this type of game. Games like Tic-Tac-Toe, which simply need a pen, paper, and an opponent, are considerably easier to play than chess and feudal. Each player marks an empty square, in turn, using one of two different shapes. The first player to obtain a certain number of shapes in a row wins. Each player is limited to using one shape. If every square is filled and no one achieves this objective, the game is a draw.

A Tic-Tac-Toe variant named "Triangles vs. Circles" has been utilized in this project. To win, you must arrange four of the same shapes in a row on the 10x10 game board. If no winner has been determined after 25 moves, the game is declared a draw.

This game was developed for Field Programmable Gate Arrays (FPGAs). The capacity to edit hardware using Hardware Description Languages (HDLs) and digital design tools like Quartus II is provided by FPGAs, which are specialized integrated circuits. In comparison to conventional CPUs found in regular computers, this capacity to alter the hardware enables for quicker processing speeds and better configurability.

The VGA (Video Graphics Array) protocol is used to facilitate game display on a monitor. The VGA protocol, created by IBM in 1987, functions as a controller for video displays. It provides a variety of display modes. This project uses a 3-channel, 16-bit, 60 Hz, 640x480 resolution mode.

**Design Requirements**

**A. Game Logic Requirements**

Players are represented on the 10x10 grid-based game board by triangular and circular shapes. Up until a player successfully lines up four identical shapes in a row, the game is played in a loop. If neither player completes this task in 25 moves, the game is declared a draw.

A move is periodically deleted from the board—every six moves, on average. Moreover, a square that has already taken an input cannot get any other input. The game board is reset to its initial state, and a new game begins after a waiting period of 10 seconds following the conclusion of a game.

**B. Input And Output Requirements**

The game uses three buttons on the board labeled "logic-0," "logic-1," and "activate" to simplify input processes. In the input process, these buttons have specific purposes. The input data is made up of 8 bits, where the first 4 bits correspond to the game board's rows and the final 4 bits to its columns. The activate button initiates the transmission of the player's input to the operational logic component once they have entered their desired move using the logic-0 and logic-1 buttons.

The game uses a 60 MHz clock frequency and a 640x480 VGA (Video Graphics Array) resolution for its visuals. This setup guarantees a high-quality visual representation on the screen, delivering the best possible user experience while playing.
