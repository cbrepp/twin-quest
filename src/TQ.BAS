' Twin Quest version 0.0.1
' Copyright (C) 2024 Wayne Chung Enterprises
'
' To Run: F5
' To Exit: Enter "EXIT" at any prompt
'
' =======================================================================
'
' Grab your favorite twin and embark on a magical adventure!
' Will you find fame?  Will you find fortune?
' Or will you find... doom and despair?
'
' Goals:
' 1) Find the gold.
' 2) Slay the fearsome dragon.
' 3) Tame the adorable black cat.
' 4) Exit the world through the hidden magic door.
'

DECLARE FUNCTION GridCell$ (x AS INTEGER, y AS INTEGER)

COMMON SHARED playerX AS INTEGER, playerY AS INTEGER, playerDirection AS INTEGER, gameOver AS INTEGER

GOSUB TitleScreen
GOSUB Init

DO
        GOSUB RefreshScreen
        GOSUB GetInput
LOOP WHILE gameOver% = 0

END

Init:
score% = 0
playerX% = 2
playerY% = 1
DIM directions(4) AS STRING
directions(1) = "NORTH"
directions(2) = "EAST"
directions(3) = "SOUTH"
directions(4) = "WEST"
playerDirection% = 3
gameOver% = 0
basicChoices$ = "LOOK,MOVE AHEAD,TURN LEFT,TURN RIGHT,CREDITS,EXIT"
choices$ = basicChoices$
DIM world(3, 3) AS STRING
world(1, 1) = "WILDERNESS"
world(2, 1) = "WILDERNESS"
world(3, 1) = "MAGIC RING OF TOADSTOOLS"
world(1, 2) = "GIANNI'S DEN"
world(2, 2) = "WOODS"
world(3, 2) = "MOUNT FLUFF"
world(2, 3) = "CASTLE"
world(3, 3) = "DRAGON'S DEN"
doorX% = 2
doorY% = 0
choice$ = "LOOK"
inventory$ = "NOTHING"
dragonDead% = 0
catTamed% = 0
GOSUB SelectCharacter
RETURN

SelectCharacter:
availableCharacters$ = "GREYSON,ZARA"
DO
        GOSUB PrintHeader
        PRINT
        PRINT "Select Player:"
        PRINT " " + availableCharacters$
        PRINT
        INPUT "Enter Choice: ", character$
        character$ = RTRIM$(LTRIM$(UCASE$(character$)))
LOOP WHILE INSTR(1, ("," + availableCharacters$ + ",GREY,EXIT,"), ("," + character$ + ",")) = 0
IF character$ = "ZARA" THEN
        world(1, 3) = "ZARA'S STORE"
ELSE
        IF (character$ = "GREYSON") OR (character$ = "GREY") THEN
                character$ = "GREYSON"
                world(1, 3) = "GREYSON'S GAME ROOM"
        ELSE
                END
        END IF
END IF

RETURN

TitleScreen:
SCREEN 12
GOSUB PrintHeader
COLOR 4
PRINT
PRINT "                              ___, ____--'"
PRINT "                         _,-.'_,-'      ("
PRINT "                      ,-' _.-''....____("
PRINT "            ,))_     /  ,'\ `'-.     (          /\"
PRINT "    __ ,+..a`  \(_   ) /   \    `'-..(         /  \"
PRINT "    )`-;...,_   \(_ ) /     \  ('''    ;'^^`\ <./\.>"
PRINT "        ,_   )   |( )/   ,./^``_..._  < /^^\ \_.))"
PRINT "       `=;; (    (/_')-- -'^^`      ^^-.`_.-` >-'"
PRINT "       `=\\ (                             _,./"
PRINT "         ,\`(                         )^^^"
PRINT "           ``;         __-'^^\       /"
PRINT "             / _>---^^^   `\..`-.    ``'."
PRINT "            / /               / /``'`; /"
PRINT "           / /          ,-=='-`=-'  / /"
PRINT "     ,-=='-`=-.               ,-=='-`=-."
PRINT "   *******************************************"
PRINT
PRINT
COLOR 15
PRINT "Press any key to continue"
DO
LOOP UNTIL INKEY$ <> ""
RETURN

PrintHeader:
CLS
LOCATE 1, 1
COLOR 3
PRINT "Twin Quest version 0.0.1                Wayne Chung Enterprises"
COLOR 15
PRINT
COLOR 8
PRINT "_" + character$ + STRING$(62 - LEN(character$), "_")
COLOR 15
RETURN

RefreshScreen:
GOSUB PrintHeader
IF choice$ = "EXIT" THEN
        GOSUB ExitAction
END IF
IF choice$ = "CREDITS" THEN
        GOSUB CreditsAction
END IF
IF choice$ = "LOOK" THEN
        GOSUB LookAction
END IF
IF choice$ = "MOVE AHEAD" THEN
        GOSUB MoveAheadAction
END IF
IF choice$ = "TURN LEFT" THEN
        GOSUB TurnLeftAction
END IF
IF choice$ = "TURN RIGHT" THEN
        GOSUB TurnRightAction
END IF
IF (choice$ = "PLAY GAME") AND (INSTR(1, choices$, "PLAY GAME") > 0) THEN
        GOSUB PlayGameAction
END IF
IF (choice$ = "SPEAK NAME") AND (INSTR(1, choices$, "SPEAK NAME") > 0) THEN
        GOSUB SpeakNameAction
END IF
IF (choice$ = "CHASE BUNNIES") AND (INSTR(1, choices$, "CHASE BUNNIES") > 0) THEN
        GOSUB ChaseBunniesAction
END IF
IF (choice$ = "TAME FLUFF") AND (INSTR(1, choices$, "TAME FLUFF") > 0) THEN
        GOSUB TameFluffAction
END IF
IF (choice$ = "TAKE GOLD") AND (INSTR(1, choices$, "TAKE GOLD") > 0) THEN
        GOSUB TakeGoldAction
ELSE
        ' TODO - Dumb place to put this but TAKE GOLD removes a choice
        IF INSTR(1, ("," + choices$ + ","), ("," + choice$ + ",")) = 0 THEN
                GOSUB DumbAction
        END IF
END IF
COLOR 8
PRINT "_______________________________________________________________"
COLOR 7
curRow% = CSRLIN
PRINT "Inventory: " + inventory$
LOCATE curRow%, 54
PRINT "Score:" + STR$(score%)
PRINT
IF (playerX% > 0) AND (playerY% > 0) AND (gameOver% = 0) THEN
        mapInfo1$ = "Location:" + STR$(playerX%) + "," + LTRIM$(STR$(playerY%))
        mapInfo2$ = "Facing: " + directions(playerDirection%)
ELSE
        mapInfo1$ = ""
        mapInfo2$ = ""
END IF
PRINT " Map"
PRINT "--" + "*" + "--"
PRINT "|" + GridCell$(1, 1) + GridCell$(2, 1) + GridCell$(3, 1) + "|" + "   " + mapInfo1$
PRINT "|" + GridCell$(1, 2) + GridCell$(2, 2) + GridCell$(3, 2) + "|" + "   " + mapInfo2$
PRINT "|" + GridCell$(1, 3) + GridCell$(2, 3) + GridCell$(3, 3) + "|"
PRINT "-----"'
COLOR 15
RETURN

GetInput:
IF gameOver% = 1 THEN
        END
END IF
PRINT
PRINT "Choices:"
PRINT " " + choices$
PRINT
INPUT "Enter Choice: ", choice$
choice$ = RTRIM$(LTRIM$(UCASE$(choice$)))
RETURN

ExitAction:
gameOver% = 1
PRINT
IF INSTR(1, ("," + inventory$ + ","), ",GOLD,") > 0 THEN
        PRINT "But you were doing so well!  The magic door is out there."
        PRINT "You found the gold but didn't bring it home."
END IF
        PRINT "Your quest has ended... no fame.  And certainly no fortune."
        PRINT "REMEMBER: Quitters never win."
PRINT
RETURN

CreditsAction:
COLOR 3
PRINT
PRINT "CREDITS"
PRINT
PRINT "Business Manager: Wayne Chung"
PRINT "Executive Producer: Wayne Chung"
PRINT "Power of Attorney: Wayne Chung"
PRINT "Development: Mylee and Mr. Chris"
PRINT "Creative Design: Zara and Greyson"
PRINT "Hair and Makeup: Ima Sue Pretty"
PRINT "Wardrobe Design: Aslan"
COLOR 15
RETURN

LookAction:
playerView$ = world(playerX%, playerY%)
PRINT
PRINT "You are in " + playerView$ + "."
IF playerView$ = "WILDERNESS" THEN
        COLOR 2
        PRINT "You see nothing but tall grass and cute bunnies."
END IF
IF playerView$ = "WOODS" THEN
        COLOR 7
        RANDOMIZE TIMER
        nightOwlChance% = INT(RND * 3) + 1
        IF nightOwlChance% = 3 THEN
                PRINT "The sky is dark and you hear the sound of flapping wings."
                PRINT "By the time you look up it's too late.  Night Owl has claimed"
                PRINT "you as his prey!  What an unfortunate way to end your journey."
                PRINT
                COLOR 15
                PRINT "You have died."
                IF score% > 0 THEN
                        PRINT "Score -" + LTRIM$(STR$(score%))
                        score% = 0
                END IF
                gameOver% = 1
        ELSE
                IF nightOwlChance% = 2 THEN
                        PRINT "The sky is dark and you hear the sound of flapping wings."
                        PRINT "By the time you look up there's already a scream close by"
                        PRINT "as Night Owl has claimed a poor creature as his prey.  You"
                        PRINT "have escaped death.  But... for how long?"
                ELSE
                        PRINT "The sky is dark and Night Owl is hiding somewhere.  You must"
                        PRINT "take care to tread lightly lest a noise alert Night Owl to"
                        PRINT "your whereabouts.  Be very, very quiet."
                END IF
        END IF
END IF
IF playerView$ = "MAGIC RING OF TOADSTOOLS" THEN
        COLOR 6
        PRINT "A magical place of faeries and giant mushrooms!"
        PRINT "A simple wooden sign sits in the center of this place.  On"
        PRINT "this sign reads a simple message..."
        PRINT
        PRINT "'Speak the name of the spirit that dwells in this place and"
        PRINT "be gifted with a magical item.'"
END IF
IF playerView$ = "MOUNT FLUFF" THEN
        COLOR 15
        PRINT "You come upon the base of a mountain and see a gallant white"
        PRINT "tom cat wearing boots and playing a spanish guitar.  His"
        PRINT "melody hypnotizes you.  And my... he is so fluffy!"
        PRINT "You are astonished to learn that this cat can speak.  He"
        PRINT "enjoys challenging others to a guessing game.  If you solve"
        PRINT "his riddle, he might just give you a prize."
END IF
IF playerView$ = "GIANNI'S DEN" THEN
        COLOR 8
        PRINT "You find yourself in a dark cave.  A fire burns deep inside."
        PRINT "You explore the cave and find yourself face to face with an"
        PRINT "adorable black cat curled up on a Pittsburgh Steelers blanket."
        PRINT "He's so cuuuuuuute!"
        PRINT
        IF INSTR(1, ("," + inventory$ + ","), ",RING OF TAMING") > 0 THEN
                IF catTamed% = 0 THEN
                        catTamed% = 1
                        PRINT "You use your ring of taming on him and he jumps into"
                        PRINT "your waiting arms.  You pet him for hours and hours."
                        COLOR 15
                        PRINT "Score +100"
                        score% = score% + 100
                ELSE
                        PRINT "He meows with delight when he sees you and jumps into"
                        PRINT "your waiting arms.  Oh what a wonderful cat he is!"
                END IF
        ELSE
                PRINT "You attempt to pet him but he runs away.  If only you could"
                PRINT "tame him.  But such a feat would require strong magic..."
        END IF
END IF
IF playerView$ = "DRAGON'S DEN" THEN
        COLOR 4
        IF dragonDead% = 0 THEN
                PRINT "You find yourself in a dark cave.  A fire burns deep inside."
                PRINT "You explore the cave and find yourself face to face with a"
                PRINT "ferocious dragon!"
        ELSE
                PRINT "The dragon once lived here until you, an amazing hero, slew it!"
                PRINT "Paintings depicting your heroic act now cover the wall, a tribute"
                PRINT "from the townspeople you saved!"
        END IF
        IF (INSTR(1, ("," + inventory$ + ","), ",GOLD,") > 0) AND (INSTR(1, ("," + inventory$ + ","), ",SWORD,") = 0) AND (INSTR(1, ("," + inventory$ + ","), ",UNO REVERSE,") = 0) THEN
                PRINT "The greedy dragon sees your gold and blasts you with"
                PRINT "its burning fire.  With no defense, you are burned to death."
                PRINT "Alas, this is the end of your quest."
                PRINT
                COLOR 15
                PRINT "You have died."
                PRINT "Score -" + LTRIM$(STR$(score%))
                score% = 0
                gameOver% = 1
        ELSE
                IF INSTR(1, ("," + inventory$ + ","), ",GOLD,") = 0 THEN
                        PRINT "With nothing heavy to carry you are able to run away"
                        PRINT "before the dragon can end your quest."
                ELSE
                        IF (INSTR(1, ("," + inventory$ + ","), ",SWORD,") > 0) AND (dragonDead% = 0) THEN
                                PRINT "With quick reflexes you use your mighty sword to slay the dragon."
                                PRINT "The townspeople are saved.  And you are today a hero!!!"
                                score% = score% + 100
                                COLOR 15
                                PRINT "Score +100"
                                dragonDead% = 1
                        ELSE
                                IF (INSTR(1, ("," + inventory$ + ","), ",UNO REVERSE,") > 0) AND (dragonDead% = 0) THEN
                                        PRINT "With quick reflexes you use your UNO REVERSE card to send the dragon's"
                                        PRINT "flames back at it.  With each fiery burst, the dragon destroys itself."
                                        PRINT "The townspeople are saved.  And you are today a hero!!!"
                                        score% = score% + 100
                                        COLOR 15
                                        PRINT "Score +100"
                                        dragonDead% = 1
                                END IF
                        END IF
                END IF
        END IF
END IF
IF playerView$ = "CASTLE" THEN
        COLOR 14
        PRINT "What a magnificent castle!  But no one is home."
END IF
IF playerView$ = "ZARA'S STORE" THEN
        COLOR 5
        PRINT "There are a lot of fun things to buy. Of particular note you"
        PRINT "see a mighty silver sword, fit for slaying a dragon."
        IF (INSTR(1, ("," + inventory$ + ","), ",GOLD,") > 0) AND (INSTR(1, ("," + inventory$ + ","), ",SWORD,") = 0) THEN
                PRINT "You deposit some gold coins into the vending machine..."
                inventory$ = inventory$ + ",SWORD"
                COLOR 15
                PRINT "Inventory +SWORD"
        ELSE
                IF INSTR(1, ("," + inventory$ + ","), ",SWORD,") > 0 THEN
                        PRINT "That mighty sword is in your hand... perhaps you should"
                        PRINT "use it for some heroic deed?"
                ELSE
                        PRINT "Maybe some day you'll return when you have some money."
                END IF
        END IF
END IF
IF playerView$ = "GREYSON'S GAME ROOM" THEN
        COLOR 1
        PRINT "Oh my!  Every game known to mankind can be found for sale in"
        PRINT "this room.  A particular game catches your eye... UNO."
        IF (INSTR(1, ("," + inventory$ + ","), ",GOLD,") > 0) AND (INSTR(1, ("," + inventory$ + ","), ",UNO REVERSE,") = 0) THEN
                PRINT "You leave some gold coins on the table in exchange for the UNO deck."
                PRINT "You look at the cards and discover the legendary... UNO REVERSE!!!"
                inventory$ = inventory$ + ",UNO REVERSE"
                COLOR 15
                PRINT "Inventory +UNO REVERSE"
        ELSE
                IF INSTR(1, ("," + inventory$ + ","), ",UNO REVERSE,") > 0 THEN
                        PRINT "That mighty deck is in your hand... perhaps you should"
                        PRINT "use it for some heroic deed?"
                ELSE
                        PRINT "Maybe some day you'll return when you have some money."
                END IF
        END IF
END IF
PRINT
IF (playerView$ = "CASTLE") AND (INSTR(1, ("," + inventory$ + ","), ",GOLD,") = 0) THEN
        COLOR 14
        PRINT "Beautiful gold coins are scattered around.  Will you take them?"
        PRINT
END IF
aheadX% = playerX%
aheadY% = playerY%
IF directions(playerDirection%) = "NORTH" THEN
        aheadY% = aheadY% - 1
END IF
IF directions(playerDirection%) = "EAST" THEN
        aheadX% = aheadX% + 1
END IF
IF directions(playerDirection%) = "SOUTH" THEN
        aheadY% = aheadY% + 1
END IF
IF directions(playerDirection%) = "WEST" THEN
        aheadX% = aheadX% - 1
END IF
IF (aheadX% = doorX%) AND (aheadY% = doorY%) THEN
        COLOR 6
        PRINT "Ahead you see a magic door.  Perhaps an exit to this world?"
ELSE
        IF gameOver% = 0 THEN
                IF (aheadX% = 0) OR (aheadX% = 4) OR (aheadY% = 0) OR (aheadY% = 4) THEN
                        COLOR 15
                        PRINT "There is nothing ahead.  You are facing the edge of the world."
                ELSE
                        COLOR 15
                        PRINT "Ahead you see " + world(aheadX%, aheadY%) + "."
                END IF
        END IF
END IF
COLOR 15
RETURN

MoveAheadAction:
aheadX% = playerX%
aheadY% = playerY%
IF directions(playerDirection%) = "NORTH" THEN
        aheadY% = aheadY% - 1
END IF
IF directions(playerDirection%) = "EAST" THEN
        aheadX% = aheadX% + 1
END IF
IF directions(playerDirection%) = "SOUTH" THEN
        aheadY% = aheadY% + 1
END IF
IF directions(playerDirection%) = "WEST" THEN
        aheadX% = aheadX% - 1
END IF
IF (aheadX% = doorX%) AND (aheadY% = doorY%) THEN
        playerX% = aheadX%
        playerY% = aheadY%
        gameOver% = 1
        PRINT
        PRINT "You have exited the world."
        PRINT
        IF INSTR(1, inventory$, "GOLD") > 0 THEN
                PRINT
                PRINT "You have safely brought your riches back home."
                PRINT "Fame and fortune are yours."
                PRINT "YOU HAVE WON THE GAME!!!"
                IF score% = 300 THEN
                        COLOR 3
                        PRINT "MAXIMUM SCORE!!!"
                END IF
        ELSE
                PRINT
                PRINT "You did not return home with the gold."
                PRINT "This is a horrible fate."
                PRINT "YOU HAVE LOST THE GAME."
        END IF
ELSE
        IF (aheadX% = 0) OR (aheadX% = 4) OR (aheadY% = 0) OR (aheadY% = 4) THEN
                PRINT
                PRINT "There is nothing ahead.  You are facing the edge of the world."
                PRINT
                PRINT "Jumping off the edge of the world is NOT allowed in this game."
        ELSE
                playerX% = aheadX%
                playerY% = aheadY%
                IF (world(playerX%, playerY%) = "CASTLE") AND (INSTR(1, ("," + inventory$ + ","), ",GOLD,") = 0) THEN
                        choices$ = basicChoices$ + ",TAKE GOLD"
                ELSE
                        IF world(playerX%, playerY%) = "MOUNT FLUFF" THEN
                                choices$ = basicChoices$ + ",PLAY GAME"
                                IF INSTR(1, ("," + inventory$ + ","), ",RING OF TAMING,") > 0 THEN
                                choices$ = choices$ + ",TAME FLUFF"
                                END IF
                        ELSE
                                IF world(playerX%, playerY%) = "MAGIC RING OF TOADSTOOLS" THEN
                                        choices$ = basicChoices$ + ",SPEAK NAME"
                                ELSE
                                        IF world(playerX%, playerY%) = "WILDERNESS" THEN
                                                choices$ = basicChoices$ + ",CHASE BUNNIES"
                                        ELSE
                                                choices$ = basicChoices$
                                        END IF
                                END IF
                        END IF
                END IF
                GOSUB LookAction
        END IF
END IF
RETURN

TurnLeftAction:
playerDirection% = playerDirection% - 1
IF playerDirection% = 0 THEN
        playerDirection% = 4
END IF
GOSUB LookAction
RETURN

TurnRightAction:
playerDirection% = playerDirection% + 1
IF playerDirection% = 5 THEN
        playerDirection% = 1
END IF
GOSUB LookAction
RETURN

TakeGoldAction:
choices$ = basicChoices$
IF INSTR(1, ("," + inventory$ + ","), ",GOLD,") = 0 THEN
        score% = score% + 100
        PRINT
        PRINT "All the gold now belongs to you!"
        COLOR 15
        PRINT "Score +100"
        PRINT "Inventory +GOLD"
        PRINT
        IF inventory$ = "NOTHING" THEN
                inventory$ = "GOLD"
        ELSE
                inventory$ = inventory$ + ",GOLD"
        END IF
END IF
RETURN

PlayGameAction:
GOSUB PrintHeader
COLOR 15
PRINT
PRINT "Fluffy Cat: Answer me this, and a magical name I will give to you."
PRINT
PRINT "What is blue... and is also the sky?"
PRINT
INPUT "You: ", riddle$
riddle$ = RTRIM$(LTRIM$(UCASE$(riddle$)))
IF (riddle$ = "THE SKY") OR (riddle$ = "THE BLUE SKY") OR (riddle$ = "BLUE SKY") THEN
        riddle$ = "SKY"
END IF
PRINT
IF riddle$ = "SKY" THEN
        PRINT "Fluffy Cat: Alas you have bested me!  And that was my"
        PRINT "finest riddle!  Very well then.  A deal is a deal. The"
        PRINT "magical name you seek is... SHMEBULOCK."
ELSE
        IF riddle$ = "EXIT" THEN
                GOSUB ExitAction
        ELSE
                PRINT "Fluffy Cat: Aha!  It appears that I have bested you!  That"
                PRINT "answer is INCORRECT.  No one is as clever as I!"
                PRINT
                PRINT "Better luck next time."
        END IF
END IF
RETURN

SpeakNameAction:
GOSUB PrintHeader
COLOR 6
PRINT
INPUT "You: ", nameGuess$
nameGuess$ = RTRIM$(LTRIM$(UCASE$(nameGuess$)))
PRINT
IF (nameGuess$ = "SHMEBULOCK") THEN
        PRINT "           ,"
        PRINT "          / \"
        PRINT "         /   \"
        PRINT "        /     \"
        PRINT "       /_______\"
        PRINT "       // . . \\"
        PRINT "      (/(__7__)\)"
        PRINT "      |'-' = `-'|"
        PRINT "      |         |"
        PRINT "      /\       /\"
        PRINT "     /  '.   .'  \"
        PRINT "    / /|  `v`  |\ \"
        PRINT "    \ \|===[]==|/ /"
        PRINT "     '-|_______|-'"
        PRINT "        |__|__|"
        PRINT "        |--|--|"
        PRINT "       (__)`(__)"
        PRINT
        PRINT "Magic Gnome: Shmebulock!  Shmebulock... Shmebulock."
        PRINT "Shmebulock?  Shmebulock, Shmebulock.  Shme... bulock!"
        PRINT
        PRINT
        COLOR 15
        PRINT "Press any key to continue"
        DO
        LOOP UNTIL INKEY$ <> ""
        IF INSTR(1, ("," + inventory$ + ","), (",RING OF TAMING,")) = 0 THEN
                PRINT
                PRINT "Inventory +RING OF TAMING"
                PRINT "(Does not work on large creatures.)"
        ELSE
                PRINT
                PRINT "You look down at your ring and it glows with power."
        END IF
        IF inventory$ = "NOTHING" THEN
                inventory$ = "RING OF TAMING"
        ELSE
                IF INSTR(1, ("," + inventory$ + ","), (",RING OF TAMING,")) = 0 THEN
                        inventory$ = inventory$ + ",RING OF TAMING"
                END IF
        END IF
ELSE
        IF nameGuess$ = "EXIT" THEN
                GOSUB ExitAction
        ELSE
                IF (nameGuess$ = "MAGNIFICO") OR (nameGuess$ = "DRACO") THEN
                        PRINT "You wait... and wait some more.  But... nothing happens!"
                        PRINT "Perhaps you spoke the wrong name?"
                        PRINT
                        PRINT "Good guess though!"
                ELSE
                        PRINT "You wait... and wait some more.  But... nothing happens!"
                        PRINT "Perhaps you spoke the wrong name?"
                        PRINT
                        PRINT "Better luck next time."
                END IF
        END IF
END IF
RETURN

TameFluffAction:
GOSUB PrintHeader
COLOR 15
PRINT
PRINT "                ____"
PRINT "                \ _ `\ "
PRINT "                 | \  `\._"
PRINT "                 |  |  _/ `-.._"
PRINT "                 |  /-'  // /.'`-. .--.__"
PRINT "                 /-'    || // //  |    __\"
PRINT "               ./   .` |\///_//   \  /'   |"
PRINT "             .'.-.__.` \ |/'-' .'  \|    /"
PRINT "            / ( ____`.\ |/ .' '.'   |\  /"
PRINT "           /  -//   \     /- _  '     `'|"
PRINT "           |  ||o    ;       __`--      |"
PRINT "           |   \\   /      //  `.  \    |"
PRINT "           \    `---'     |/o    \_ )   \"
PRINT "         _ _\_    /       |      /       |"
PRINT "       _-_`-__-_.-'|__    \`-..-'       /"
PRINT "      '  .--_--_-.. \_\/_              /"
PRINT "        ' /    \... / .. \_-___       / \"
PRINT "         /      `-._| ..-._--___     /   \"
PRINT "        /    .---.|  `-.__/`--.__---'     |"
PRINT "       /_.--/ . . \__/   _   `--._-.      |"
PRINT "    .-'    | || | |   .-' `-.     \ `\    |"
PRINT "  .'       `-\/\|-'  |  / /  \     `\ \   |"
PRINT " /                    \/ | .  |           |"
PRINT "/                      \_/_/ / \          |"
PRINT "|  magnifico               \/   \         |"
PRINT
PRINT
PRINT "Press any key to continue"
DO
LOOP UNTIL INKEY$ <> ""
RETURN

ChaseBunniesAction:
PRINT
COLOR 2
PRINT "Seems like an unimportant thing to do but nonetheless"
PRINT "you try to chase some of the bunnies.  And... you can't"
PRINT "catch a single one.  They are too fast!  Oh well, time"
PRINT "to continue on with your quest."
RETURN

DumbAction:
PRINT
PRINT "That is NOT a choice.  Better luck next time."
PRINT
RETURN

FUNCTION GridCell$ (x AS INTEGER, y AS INTEGER)
        GridCell$ = " "
        IF (playerX% = x) AND (playerY% = y) AND (gameOver% = 0) THEN
                IF playerDirection% = 1 THEN
                        GridCell$ = "^"
                END IF
                IF playerDirection% = 2 THEN
                        GridCell$ = ">"
                END IF
                IF playerDirection% = 3 THEN
                        GridCell$ = "v"
                END IF
                IF playerDirection% = 4 THEN
                        GridCell$ = "<"
                END IF
        END IF
END FUNCTION

