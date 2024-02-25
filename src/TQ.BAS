DECLARE FUNCTION GridCell$ (x AS INTEGER, y AS INTEGER)

Common Shared playerX As Integer, playerY As Integer, playerDirection As Integer, gameOver As Integer

GoSub TitleScreen
GoSub Init

Do
    GoSub RefreshScreen
    GoSub GetInput
Loop While gameOver% = 0

End

Init:
score% = 0
playerX% = 2
playerY% = 1
Dim directions(4) As String
directions(1) = "NORTH"
directions(2) = "EAST"
directions(3) = "SOUTH"
directions(4) = "WEST"
playerDirection% = 3
gameOver% = 0
basicChoices$ = "LOOK,MOVE AHEAD,TURN LEFT,TURN RIGHT,CREDITS,EXIT"
choices$ = basicChoices$
Dim world(3, 3) As String
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
GoSub SelectCharacter
Return

SelectCharacter:
availableCharacters$ = "GREYSON,ZARA"
Do
    GoSub PrintHeader
    Print
    Print "Select Player:"
    Print " " + availableCharacters$
    Print
    Input "Enter Choice: ", character$
    character$ = RTrim$(LTrim$(UCase$(character$)))
Loop While InStr(1, ("," + availableCharacters$ + ",GREY,EXIT,"), ("," + character$ + ",")) = 0
If character$ = "ZARA" Then
    world(1, 3) = "ZARA'S STORE"
Else
    If (character$ = "GREYSON") Or (character$ = "GREY") Then
        character$ = "GREYSON"
        world(1, 3) = "GREYSON'S GAME ROOM"
    Else
        End
    End If
End If

Return

TitleScreen:
Screen 12
GoSub PrintHeader
Color 4
Print
Print "                              ___, ____--'"
Print "                         _,-.'_,-'      ("
Print "                      ,-' _.-''....____("
Print "            ,))_     /  ,'\ `'-.     (          /\"
Print "    __ ,+..a`  \(_   ) /   \    `'-..(         /  \"
Print "    )`-;...,_   \(_ ) /     \  ('''    ;'^^`\ <./\.>"
Print "        ,_   )   |( )/   ,./^``_..._  < /^^\ \_.))"
Print "       `=;; (    (/_')-- -'^^`      ^^-.`_.-` >-'"
Print "       `=\\ (                             _,./"
Print "         ,\`(                         )^^^"
Print "           ``;         __-'^^\       /"
Print "             / _>---^^^   `\..`-.    ``'."
Print "            / /               / /``'`; /"
Print "           / /          ,-=='-`=-'  / /"
Print "     ,-=='-`=-.               ,-=='-`=-."
Print "   *******************************************"
Print
Print
Color 15
Print "Press any key to continue"
Do
Loop Until InKey$ <> ""
Return

PrintHeader:
Cls
Locate 1, 1
Color 3
Print "Twin Quest version 0.0.1                Wayne Chung Enterprises"
Color 15
Print
Color 8
Print "_" + character$ + String$(62 - Len(character$), "_")
Color 15
Return

RefreshScreen:
GoSub PrintHeader
If choice$ = "EXIT" Then
    GoSub ExitAction
End If
If choice$ = "CREDITS" Then
    GoSub CreditsAction
End If
If choice$ = "LOOK" Then
    GoSub LookAction
End If
If choice$ = "MOVE AHEAD" Then
    GoSub MoveAheadAction
End If
If choice$ = "TURN LEFT" Then
    GoSub TurnLeftAction
End If
If choice$ = "TURN RIGHT" Then
    GoSub TurnRightAction
End If
If (choice$ = "PLAY GAME") And (InStr(1, choices$, "PLAY GAME") > 0) Then
    GoSub PlayGameAction
End If
If (choice$ = "SPEAK NAME") And (InStr(1, choices$, "SPEAK NAME") > 0) Then
    GoSub SpeakNameAction
End If
If (choice$ = "CHASE BUNNIES") And (InStr(1, choices$, "CHASE BUNNIES") > 0) Then
    GoSub ChaseBunniesAction
End If
If (choice$ = "TAME FLUFF") And (InStr(1, choices$, "TAME FLUFF") > 0) Then
    GoSub TameFluffAction
End If
If (choice$ = "TAKE GOLD") And (InStr(1, choices$, "TAKE GOLD") > 0) Then
    GoSub TakeGoldAction
Else
    ' TODO - Dumb place to put this but TAKE GOLD removes a choice
    If InStr(1, ("," + choices$ + ","), ("," + choice$ + ",")) = 0 Then
        GoSub DumbAction
    End If
End If
Color 8
Print "_______________________________________________________________"
Color 7
curRow% = CsrLin
Print "Inventory: " + inventory$
Locate curRow%, 54
Print "Score:" + Str$(score%)
Print
If (playerX% > 0) And (playerY% > 0) And (gameOver% = 0) Then
    mapInfo1$ = "Location:" + Str$(playerX%) + "," + LTrim$(Str$(playerY%))
    mapInfo2$ = "Facing: " + directions(playerDirection%)
Else
    mapInfo1$ = ""
    mapInfo2$ = ""
End If
Print " Map"
Print "--" + "*" + "--"
Print "|" + GridCell$(1, 1) + GridCell$(2, 1) + GridCell$(3, 1) + "|" + "   " + mapInfo1$
Print "|" + GridCell$(1, 2) + GridCell$(2, 2) + GridCell$(3, 2) + "|" + "   " + mapInfo2$
Print "|" + GridCell$(1, 3) + GridCell$(2, 3) + GridCell$(3, 3) + "|"
Print "-----" '
Color 15
Return

GetInput:
If gameOver% = 1 Then
    End
End If
Print
Print "Choices:"
Print " " + choices$
Print
Input "Enter Choice: ", choice$
choice$ = RTrim$(LTrim$(UCase$(choice$)))
Return

ExitAction:
gameOver% = 1
Print
If InStr(1, ("," + inventory$ + ","), ",GOLD,") > 0 Then
    Print "But you were doing so well!  The magic door is out there."
    Print "You found the gold but didn't bring it home."
End If
Print "Your quest has ended... no fame.  And certainly no fortune."
Print "REMEMBER: Quitters never win."
Print
Return

CreditsAction:
Color 3
Print
Print "CREDITS"
Print
Print "Business Manager: Wayne Chung"
Print "Executive Producer: Wayne Chung"
Print "Power of Attorney: Wayne Chung"
Print "Development: Mylee and Mr. Chris"
Print "Creative Design: Zara and Greyson"
Print "Hair and Makeup: Ima Sue Pretty"
Print "Wardrobe Design: Aslan"
Color 15
Return

LookAction:
playerView$ = world(playerX%, playerY%)
Print
Print "You are in " + playerView$ + "."
If playerView$ = "WILDERNESS" Then
    Color 2
    Print "You see nothing but tall grass and cute bunnies."
End If
If playerView$ = "WOODS" Then
    Color 7
    Randomize Timer
    nightOwlChance% = Int(Rnd * 3) + 1
    If nightOwlChance% = 3 Then
        Print "The sky is dark and you hear the sound of flapping wings."
        Print "By the time you look up it's too late.  Night Owl has claimed"
        Print "you as his prey!  What an unfortunate way to end your journey."
        Print
        Color 15
        Print "You have died."
        If score% > 0 Then
            Print "Score -" + LTrim$(Str$(score%))
            score% = 0
        End If
        gameOver% = 1
    Else
        If nightOwlChance% = 2 Then
            Print "The sky is dark and you hear the sound of flapping wings."
            Print "By the time you look up there's already a scream close by"
            Print "as Night Owl has claimed a poor creature as his prey.  You"
            Print "have escaped death.  But... for how long?"
        Else
            Print "The sky is dark and Night Owl is hiding somewhere.  You must"
            Print "take care to tread lightly lest a noise alert Night Owl to"
            Print "your whereabouts.  Be very, very quiet."
        End If
    End If
End If
If playerView$ = "MAGIC RING OF TOADSTOOLS" Then
    Color 6
    Print "A magical place of faeries and giant mushrooms!"
    Print "A simple wooden sign sits in the center of this place.  On"
    Print "this sign reads a simple message..."
    Print
    Print "'Speak the name of the spirit that dwells in this place and"
    Print "be gifted with a magical item.'"
End If
If playerView$ = "MOUNT FLUFF" Then
    Color 15
    Print "You come upon the base of a mountain and see a gallant white"
    Print "tom cat wearing boots and playing a spanish guitar.  His"
    Print "melody hypnotizes you.  And my... he is so fluffy!"
    Print "You are astonished to learn that this cat can speak.  He"
    Print "enjoys challenging others to a guessing game.  If you solve"
    Print "his riddle, he might just give you a prize."
End If
If playerView$ = "GIANNI'S DEN" Then
    Color 8
    Print "You find yourself in a dark cave.  A fire burns deep inside."
    Print "You explore the cave and find yourself face to face with an"
    Print "adorable black cat curled up on a Pittsburgh Steelers blanket."
    Print "He's so cuuuuuuute!"
    Print
    If InStr(1, ("," + inventory$ + ","), ",RING OF TAMING") > 0 Then
        If catTamed% = 0 Then
            catTamed% = 1
            Print "You use your ring of taming on him and he jumps into"
            Print "your waiting arms.  You pet him for hours and hours."
            Color 15
            Print "Score +100"
            score% = score% + 100
        Else
            Print "He meows with delight when he sees you and jumps into"
            Print "your waiting arms.  Oh what a wonderful cat he is!"
        End If
    Else
        Print "You attempt to pet him but he runs away.  If only you could"
        Print "tame him.  But such a feat would require strong magic..."
    End If
End If
If playerView$ = "DRAGON'S DEN" Then
    Color 4
    If dragonDead% = 0 Then
        Print "You find yourself in a dark cave.  A fire burns deep inside."
        Print "You explore the cave and find yourself face to face with a"
        Print "ferocious dragon!"
    Else
        Print "The dragon once lived here until you, an amazing hero, slew it!"
        Print "Paintings depicting your heroic act now cover the wall, a tribute"
        Print "from the townspeople you saved!"
    End If
    If (InStr(1, ("," + inventory$ + ","), ",GOLD,") > 0) And (InStr(1, ("," + inventory$ + ","), ",SWORD,") = 0) And (InStr(1, ("," + inventory$ + ","), ",UNO REVERSE,") = 0) Then
        Print "The greedy dragon sees your gold and blasts you with"
        Print "its burning fire.  With no defense, you are burned to death."
        Print "Alas, this is the end of your quest."
        Print
        Color 15
        Print "You have died."
        Print "Score -" + LTrim$(Str$(score%))
        score% = 0
        gameOver% = 1
    Else
        If InStr(1, ("," + inventory$ + ","), ",GOLD,") = 0 Then
            Print "With nothing heavy to carry you are able to run away"
            Print "before the dragon can end your quest."
        Else
            If (InStr(1, ("," + inventory$ + ","), ",SWORD,") > 0) And (dragonDead% = 0) Then
                Print "With quick reflexes you use your mighty sword to slay the dragon."
                Print "The townspeople are saved.  And you are today a hero!!!"
                score% = score% + 100
                Color 15
                Print "Score +100"
                dragonDead% = 1
            Else
                If (InStr(1, ("," + inventory$ + ","), ",UNO REVERSE,") > 0) And (dragonDead% = 0) Then
                    Print "With quick reflexes you use your UNO REVERSE card to send the dragon's"
                    Print "flames back at it.  With each fiery burst, the dragon destroys itself."
                    Print "The townspeople are saved.  And you are today a hero!!!"
                    score% = score% + 100
                    Color 15
                    Print "Score +100"
                    dragonDead% = 1
                End If
            End If
        End If
    End If
End If
If playerView$ = "CASTLE" Then
    Color 14
    Print "What a magnificent castle!  But no one is home."
End If
If playerView$ = "ZARA'S STORE" Then
    Color 5
    Print "There are a lot of fun things to buy. Of particular note you"
    Print "see a mighty silver sword, fit for slaying a dragon."
    If (InStr(1, ("," + inventory$ + ","), ",GOLD,") > 0) And (InStr(1, ("," + inventory$ + ","), ",SWORD,") = 0) Then
        Print "You deposit some gold coins into the vending machine..."
        inventory$ = inventory$ + ",SWORD"
        Color 15
        Print "Inventory +SWORD"
    Else
        If InStr(1, ("," + inventory$ + ","), ",SWORD,") > 0 Then
            Print "That mighty sword is in your hand... perhaps you should"
            Print "use it for some heroic deed?"
        Else
            Print "Maybe some day you'll return when you have some money."
        End If
    End If
End If
If playerView$ = "GREYSON'S GAME ROOM" Then
    Color 1
    Print "Oh my!  Every game known to mankind can be found for sale in"
    Print "this room.  A particular game catches your eye... UNO."
    If (InStr(1, ("," + inventory$ + ","), ",GOLD,") > 0) And (InStr(1, ("," + inventory$ + ","), ",UNO REVERSE,") = 0) Then
        Print "You leave some gold coins on the table in exchange for the UNO deck."
        Print "You look at the cards and discover the legendary... UNO REVERSE!!!"
        inventory$ = inventory$ + ",UNO REVERSE"
        Color 15
        Print "Inventory +UNO REVERSE"
    Else
        If InStr(1, ("," + inventory$ + ","), ",UNO REVERSE,") > 0 Then
            Print "That mighty deck is in your hand... perhaps you should"
            Print "use it for some heroic deed?"
        Else
            Print "Maybe some day you'll return when you have some money."
        End If
    End If
End If
Print
If (playerView$ = "CASTLE") And (InStr(1, ("," + inventory$ + ","), ",GOLD,") = 0) Then
    Color 14
    Print "Beautiful gold coins are scattered around.  Will you take them?"
    Print
End If
aheadX% = playerX%
aheadY% = playerY%
If directions(playerDirection%) = "NORTH" Then
    aheadY% = aheadY% - 1
End If
If directions(playerDirection%) = "EAST" Then
    aheadX% = aheadX% + 1
End If
If directions(playerDirection%) = "SOUTH" Then
    aheadY% = aheadY% + 1
End If
If directions(playerDirection%) = "WEST" Then
    aheadX% = aheadX% - 1
End If
If (aheadX% = doorX%) And (aheadY% = doorY%) Then
    Color 6
    Print "Ahead you see a magic door.  Perhaps an exit to this world?"
Else
    If gameOver% = 0 Then
        If (aheadX% = 0) Or (aheadX% = 4) Or (aheadY% = 0) Or (aheadY% = 4) Then
            Color 15
            Print "There is nothing ahead.  You are facing the edge of the world."
        Else
            Color 15
            Print "Ahead you see " + world(aheadX%, aheadY%) + "."
        End If
    End If
End If
Color 15
Return

MoveAheadAction:
aheadX% = playerX%
aheadY% = playerY%
If directions(playerDirection%) = "NORTH" Then
    aheadY% = aheadY% - 1
End If
If directions(playerDirection%) = "EAST" Then
    aheadX% = aheadX% + 1
End If
If directions(playerDirection%) = "SOUTH" Then
    aheadY% = aheadY% + 1
End If
If directions(playerDirection%) = "WEST" Then
    aheadX% = aheadX% - 1
End If
If (aheadX% = doorX%) And (aheadY% = doorY%) Then
    playerX% = aheadX%
    playerY% = aheadY%
    gameOver% = 1
    Print
    Print "You have exited the world."
    Print
    If InStr(1, inventory$, "GOLD") > 0 Then
        Print
        Print "You have safely brought your riches back home."
        Print "Fame and fortune are yours."
        Print "YOU HAVE WON THE GAME!!!"
        If score% = 300 Then
            Color 3
            Print "MAXIMUM SCORE!!!"
        End If
    Else
        Print
        Print "You did not return home with the gold."
        Print "This is a horrible fate."
        Print "YOU HAVE LOST THE GAME."
    End If
Else
    If (aheadX% = 0) Or (aheadX% = 4) Or (aheadY% = 0) Or (aheadY% = 4) Then
        Print
        Print "There is nothing ahead.  You are facing the edge of the world."
        Print
        Print "Jumping off the edge of the world is NOT allowed in this game."
    Else
        playerX% = aheadX%
        playerY% = aheadY%
        If (world(playerX%, playerY%) = "CASTLE") And (InStr(1, ("," + inventory$ + ","), ",GOLD,") = 0) Then
            choices$ = basicChoices$ + ",TAKE GOLD"
        Else
            If world(playerX%, playerY%) = "MOUNT FLUFF" Then
                choices$ = basicChoices$ + ",PLAY GAME"
                If InStr(1, ("," + inventory$ + ","), ",RING OF TAMING,") > 0 Then
                    choices$ = choices$ + ",TAME FLUFF"
                End If
            Else
                If world(playerX%, playerY%) = "MAGIC RING OF TOADSTOOLS" Then
                    choices$ = basicChoices$ + ",SPEAK NAME"
                Else
                    If world(playerX%, playerY%) = "WILDERNESS" Then
                        choices$ = basicChoices$ + ",CHASE BUNNIES"
                    Else
                        choices$ = basicChoices$
                    End If
                End If
            End If
        End If
        GoSub LookAction
    End If
End If
Return

TurnLeftAction:
playerDirection% = playerDirection% - 1
If playerDirection% = 0 Then
    playerDirection% = 4
End If
GoSub LookAction
Return

TurnRightAction:
playerDirection% = playerDirection% + 1
If playerDirection% = 5 Then
    playerDirection% = 1
End If
GoSub LookAction
Return

TakeGoldAction:
choices$ = basicChoices$
If InStr(1, ("," + inventory$ + ","), ",GOLD,") = 0 Then
    score% = score% + 100
    Print
    Print "All the gold now belongs to you!"
    Color 15
    Print "Score +100"
    Print "Inventory +GOLD"
    Print
    If inventory$ = "NOTHING" Then
        inventory$ = "GOLD"
    Else
        inventory$ = inventory$ + ",GOLD"
    End If
End If
Return

PlayGameAction:
GoSub PrintHeader
Color 15
Print
Print "Fluffy Cat: Answer me this, and a magical name I will give to you."
Print
Print "What is blue... and is also the sky?"
Print
Input "You: ", riddle$
riddle$ = RTrim$(LTrim$(UCase$(riddle$)))
If (riddle$ = "THE SKY") Or (riddle$ = "THE BLUE SKY") Or (riddle$ = "BLUE SKY") Then
    riddle$ = "SKY"
End If
Print
If riddle$ = "SKY" Then
    Print "Fluffy Cat: Alas you have bested me!  And that was my"
    Print "finest riddle!  Very well then.  A deal is a deal. The"
    Print "magical name you seek is... SHMEBULOCK."
Else
    If riddle$ = "EXIT" Then
        GoSub ExitAction
    Else
        Print "Fluffy Cat: Aha!  It appears that I have bested you!  That"
        Print "answer is INCORRECT.  No one is as clever as I!"
        Print
        Print "Better luck next time."
    End If
End If
Return

SpeakNameAction:
GoSub PrintHeader
Color 6
Print
Input "You: ", nameGuess$
nameGuess$ = RTrim$(LTrim$(UCase$(nameGuess$)))
Print
If (nameGuess$ = "SHMEBULOCK") Then
    Print "           ,"
    Print "          / \"
    Print "         /   \"
    Print "        /     \"
    Print "       /_______\"
    Print "       // . . \\"
    Print "      (/(__7__)\)"
    Print "      |'-' = `-'|"
    Print "      |         |"
    Print "      /\       /\"
    Print "     /  '.   .'  \"
    Print "    / /|  `v`  |\ \"
    Print "    \ \|===[]==|/ /"
    Print "     '-|_______|-'"
    Print "        |__|__|"
    Print "        |--|--|"
    Print "       (__)`(__)"
    Print
    Print "Magic Gnome: Shmebulock!  Shmebulock... Shmebulock."
    Print "Shmebulock?  Shmebulock, Shmebulock.  Shme... bulock!"
    Print
    Print
    Color 15
    Print "Press any key to continue"
    Do
    Loop Until InKey$ <> ""
    If InStr(1, ("," + inventory$ + ","), (",RING OF TAMING,")) = 0 Then
        Print
        Print "Inventory +RING OF TAMING"
        Print "(Does not work on large creatures.)"
    Else
        Print
        Print "You look down at your ring and it glows with power."
    End If
    If inventory$ = "NOTHING" Then
        inventory$ = "RING OF TAMING"
    Else
        If InStr(1, ("," + inventory$ + ","), (",RING OF TAMING,")) = 0 Then
            inventory$ = inventory$ + ",RING OF TAMING"
        End If
    End If
Else
    If nameGuess$ = "EXIT" Then
        GoSub ExitAction
    Else
        If (nameGuess$ = "MAGNIFICO") Or (nameGuess$ = "DRACO") Then
            Print "You wait... and wait some more.  But... nothing happens!"
            Print "Perhaps you spoke the wrong name?"
            Print
            Print "Good guess though!"
        Else
            Print "You wait... and wait some more.  But... nothing happens!"
            Print "Perhaps you spoke the wrong name?"
            Print
            Print "Better luck next time."
        End If
    End If
End If
Return

TameFluffAction:
GoSub PrintHeader
Color 15
Print
Print "                ____"
Print "                \ _ `\ "
Print "                 | \  `\._"
Print "                 |  |  _/ `-.._"
Print "                 |  /-'  // /.'`-. .--.__"
Print "                 /-'    || // //  |    __\"
Print "               ./   .` |\///_//   \  /'   |"
Print "             .'.-.__.` \ |/'-' .'  \|    /"
Print "            / ( ____`.\ |/ .' '.'   |\  /"
Print "           /  -//   \     /- _  '     `'|"
Print "           |  ||o    ;       __`--      |"
Print "           |   \\   /      //  `.  \    |"
Print "           \    `---'     |/o    \_ )   \"
Print "         _ _\_    /       |      /       |"
Print "       _-_`-__-_.-'|__    \`-..-'       /"
Print "      '  .--_--_-.. \_\/_              /"
Print "        ' /    \... / .. \_-___       / \"
Print "         /      `-._| ..-._--___     /   \"
Print "        /    .---.|  `-.__/`--.__---'     |"
Print "       /_.--/ . . \__/   _   `--._-.      |"
Print "    .-'    | || | |   .-' `-.     \ `\    |"
Print "  .'       `-\/\|-'  |  / /  \     `\ \   |"
Print " /                    \/ | .  |           |"
Print "/                      \_/_/ / \          |"
Print "|  magnifico               \/   \         |"
Print
Print
Print "Press any key to continue"
Do
Loop Until InKey$ <> ""
Return

ChaseBunniesAction:
Print
Color 2
Print "Seems like an unimportant thing to do but nonetheless"
Print "you try to chase some of the bunnies.  And... you can't"
Print "catch a single one.  They are too fast!  Oh well, time"
Print "to continue on with your quest."
Return

DumbAction:
Print
Print "That is NOT a choice.  Better luck next time."
Print
Return

Function GridCell$ (x As Integer, y As Integer)
    GridCell$ = " "
    If (playerX% = x) And (playerY% = y) And (gameOver% = 0) Then
        If playerDirection% = 1 Then
            GridCell$ = "^"
        End If
        If playerDirection% = 2 Then
            GridCell$ = ">"
        End If
        If playerDirection% = 3 Then
            GridCell$ = "v"
        End If
        If playerDirection% = 4 Then
            GridCell$ = "<"
        End If
    End If
End Function

