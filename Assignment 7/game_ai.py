"""
Game AI -- this is for you to complete
"""

import requests
import time
import random

SERVER = "http://127.0.0.1:5000"  # this will not change
TEAM_ID_BASE = "graknol"  # set it to your GitHub username

teamId = TEAM_ID_BASE
teamIdSuffix = 0

TOP = 0x1
RIGHT = 0x2
BOTTOM = 0x4
LEFT = 0x8
OCCUPIED = 0x10 + 0x20


def reg():
    global teamId, teamIdSuffix
    # register using a fixed team_id
    resp = requests.get(SERVER + "/reg/" + teamId).json()  # register 1st team

    if resp["response"] == "OK":
        # save which player we are
        print("Registered successfully as Player {}".format(resp["player"]))
        return resp["player"]
    else:
        if resp["error_code"] == 1:
            teamId = teamId[1:]
            print("team_id is too long, retrying with " + teamId)
            return reg()
        if resp["error_code"] == 2:
            teamIdSuffix += 1
            teamId = TEAM_ID_BASE + str(teamIdSuffix)
            print("team_id is already taken, retrying with " + teamId)
            return reg()
        if resp["error_code"] == 3:
            print("game has already started, sleeping for 3 seconds before retrying")
            time.sleep(3.0)
            return reg()
        else:
            exit(resp["error_code"])


def boardSort(elem):
    state = elem[2]
    count = 0
    while state != 0:
        state = state & (state - 1)
        count += 1
    if count == 3:  # Free points!
        return 3
    if count == 2:  # We won't risk the opponent stealing points from us, so placing a border on a 2-square is a BIG no-no!
        return 0
    if count == 1:  # Not bad
        return 2
    else:  # Still better than a 2-square
        return 1


def play(player):
    game_over = False
    while not game_over:
        time.sleep(0.5)  # wait a bit before making a new status request
        # request the status of the game
        status = requests.get(SERVER + "/status").json()
        if status["status_code"] > 300:
            game_over = True
        elif status["status_code"] == 200 + player:  # it's our turn
            print("It's our turn ({}ms left)".format(status["time_left"]))

            # Collect information about the state of the game
            board_size = status["board_size"]
            board = status["board"]

            # Get the free squares
            open_squares = []
            for i in range(board_size*board_size):
                ix = i % board_size
                iy = int(i / board_size)
                square = board[iy][ix]
                if (square & OCCUPIED) == 0:  # Not occupied
                    open_squares.append((ix, iy, square))

            # Pick the best square, according to our heuristic
            open_squares.sort(key=boardSort, reverse=1)
            x, y, square = open_squares[0]

            # Gather the open borders and pick one at random
            remaining_borders = []
            if square & TOP == 0:
                remaining_borders.append("top")
            if square & RIGHT == 0:
                remaining_borders.append("right")
            if square & BOTTOM == 0:
                remaining_borders.append("bottom")
            if square & LEFT == 0:
                remaining_borders.append("left")
            border = remaining_borders[random.randint(
                0, len(remaining_borders) - 1)]

            # Make the move
            print("Making a move: ({},{}) {}".format(x, y, border))
            move = str(x) + "," + str(y) + "," + border
            status = requests.get(SERVER + "/move/" +
                                  teamId + "/" + move).json()


if __name__ == "__main__":
    player = reg()
    play(player)
