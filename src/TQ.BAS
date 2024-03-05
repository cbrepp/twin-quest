' Resources:
' castle.mp3 - Royal vibes (harp guitar and tuba) (https://freesound.org/people/kbrecordzz/sounds/595865/)
' dragon.mp3 - The Roar of a 5-Headed Dragon (https://freesound.org/people/bevibeldesign/sounds/366095/)
' fluff.wav - Spanish Lick I, Acoustic- AB split stereo pair (Oktava).wav (https://freesound.org/people/debudding/sounds/44366/)
' gianni.mp3 - bonfire flames sizzling (https://freesound.org/people/florianreichelt/sounds/563764/)
' grey.mp3 - 8-Bit Coin Or Power Up FX For Retro Video Games (https://freesound.org/people/Cloud-10/sounds/647977/)
' magic.mp3 - Magic.mp3 (https://freesound.org/people/Bastianhallo/sounds/434050/)
' title.mp3 - Epic Trailer Background Music (https://freesound.org/people/Migfus20/sounds/560454/)
' wayne-chung.jpg - Image of Wayne Chung wondering what's going on
' wayne-chung.mp3 - Wang Chung "Everybody Have Fun Tonight" snippet
' wilderness.mp3 - birds_210513_0088.mp3 (https://freesound.org/people/titi2/sounds/571247/)
' woods.mp3 - forestsurroundings.mp3 (https://freesound.org/people/Luftrum/sounds/48411/)
' zara.mp3 - Cash Register (https://freesound.org/people/kiddpark/sounds/201159/)

' Declare game functions and subroutines
DECLARE FUNCTION Contains% (myString AS STRING, token AS STRING, delimiter AS STRING)
DECLARE FUNCTION GetInput$ (prompt AS STRING, enableArrowKeys AS INTEGER)
DECLARE FUNCTION PlaySound& (file AS STRING, volume AS SINGLE, loopSound As INTEGER)
DECLARE SUB ReplaySound (soundHandle AS LONG, volume AS SINGLE, loopSound As INTEGER)
DECLARE SUB StopSound (soundHandle AS LONG)

' Configure application window
_Title "Twin Quest"

' Display splash screen
GoSub WayneChungScreen

' Display epic opening screens
titleMusic& = PlaySound&("title.mp3", 1, 1)
GoSub TitleScreen
GoSub Init
StopSound titleMusic&

GoSub InitLevel1
choice$ = "MOVE AHEAD"

Do
    GoSub RefreshScreen
    If gameOver% Then
        End
    End If
    Color 15
    Print
    sceneChoicesRow% = CsrLin
    scenePrompt$ = "Scene Choices: "
    Print scenePrompt$
    Locate sceneChoicesRow%, Len(scenePrompt$) + 1
    Color 3
    Print sceneChoices$
    Color 15
    gameChoicesRow% = CsrLin
    gamePrompt$ = "Game Choices: "
    Print gamePrompt$
    Locate gameChoicesRow%, Len(gamePrompt$) + 1
    Color 3
    Print gameChoices$
    Color 15
    Print "[Use arrow keys to turn and move]"
    Print
    choice$ = GetInput$("Enter Choice", 1)
Loop While gameOver% = 0

End

Init:
score% = 0
exitGameAction$ = "EXIT GAME"
Dim directions(4) As String
directions(1) = "NORTH"
directions(2) = "EAST"
directions(3) = "SOUTH"
directions(4) = "WEST"
gameOver% = 0
gameChoices$ = "CREDITS," + exitGameAction$
basicChoices$ = "LOOK,LISTEN"
sceneChoices$ = basicChoices$
secretChoices$ = "MOVE AHEAD,MOVE BACKWARDS,TURN LEFT,TURN RIGHT,ALL THE THINGS"
sceneSound& = 0
Dim world(5, 5) As String
Dim mapInfo(5) As String
Dim playerSymbol(4) As String
playerSymbol(1) = "^"
playerSymbol(2) = ">"
playerSymbol(3) = "v"
playerSymbol(4) = "<"
sceneSound& = 0
inventory$ = "NOTHING"
dragonDead% = 0
catTamed% = 0
GoSub SelectCharacter
Return

InitLevel1:
level% = 1
levelSize% = 3
doorX% = 2
doorY% = 0
playerX% = doorX%
playerY% = doorY%
playerDirection% = 3
' TODO - Refactor to make the world a 3 node array, with the first node being the level
' Future idea is to add a spell for warping to a cell on an unlocked level
world(1, 1) = "WILDERNESS"
world(2, 1) = "WILDERNESS"
world(3, 1) = "MAGIC RING OF TOADSTOOLS"
world(1, 2) = "GIANNI'S DEN"
world(2, 2) = "WOODS"
world(3, 2) = "MOUNT FLUFF"
world(2, 3) = "CASTLE"
world(3, 3) = "DRAGON'S DEN"
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

InitLevel2:
level% = 2
levelSize% = 5
doorX% = 3
doorY% = 0
playerX% = doorX%
playerY% = doorY%
playerDirection% = 3
world(1, 1) = "WILDERNESS"
world(2, 1) = "WILDERNESS"
world(3, 1) = "WILDERNESS"
world(4, 1) = "WILDERNESS"
world(5, 1) = "WILDERNESS"
world(1, 2) = "WILDERNESS"
world(2, 2) = "WILDERNESS"
world(3, 2) = "WILDERNESS"
world(4, 2) = "WILDERNESS"
world(5, 2) = "WILDERNESS"
world(1, 3) = "WILDERNESS"
world(2, 3) = "WILDERNESS"
world(3, 3) = "WILDERNESS"
world(4, 3) = "WILDERNESS"
world(5, 3) = "WILDERNESS"
world(1, 4) = "WILDERNESS"
world(2, 4) = "WILDERNESS"
world(3, 4) = "WILDERNESS"
world(4, 4) = "WILDERNESS"
world(5, 4) = "WILDERNESS"
world(1, 5) = "WILDERNESS"
world(2, 5) = "WILDERNESS"
world(3, 5) = "WILDERNESS"
world(4, 5) = "WILDERNESS"
world(5, 5) = "WILDERNESS"
Return

SelectCharacter:
availableCharacters$ = "GREYSON,ZARA"
Do
    character$ = ""
    GoSub PrintHeader
    Print
    Print "Select Player:"
    Print " " + availableCharacters$
    Print
    character$ = GetInput$("Enter Choice", 0)
Loop While Not Contains%(availableCharacters$ + ",GREY," + exitGameAction$, character$, ",")
Return

' Display the splash screen
WayneChungScreen:
' Play Wayne Chung's theme song
wayneChungMusic& = PlaySound&("wayne-chung.mp3", 1, 0)
' Display Wayne Chung's picture
Cls
wayneChungImage& = _LoadImage("wayne-chung.jpg", 32) 'load the image file to be drawn
Screen wayneChungImage&
' Display overlay text
Locate 7, 2
Print "Wayne Chung Enterprises"
Locate 9, 9
Print "presents"
Locate 46, 2
' Suspend program execution for 5 seconds or until the user presses the any key
Sleep 5
' Stop playing Wayne Chung's theme music and remove his picture
StopSound wayneChungMusic&
Screen 12
_FreeImage wayneChungImage& ' Free up memory used by the image
Return

' Display the title screen
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
GoSub PressAnyKey
Return

PrintHeader:
Cls
Locate 1, 1
Color 15
Print "Twin Quest version 0.1.0               Wayne Chung Enterprises"
Print
Color 8
Print "_" + character$ + String$(62 - Len(character$), "_")
Color 15
Return

RefreshScreen:
GoSub PrintHeader
If (Not Contains%(sceneChoices$, choice$, ",")) And (Not Contains%(gameChoices$, choice$, ",")) And (Not Contains%(secretChoices$, choice$, ",")) Then
    ' Handle invalid choice
    GoSub DumbAction
Else
    ' Handle valid choices
    If choice$ = exitGameAction$ Then
        GoSub ExitAction
    End If
    If choice$ = "CREDITS" Then
        GoSub CreditsAction
    End If
    If choice$ = "LOOK" Then
        GoSub LookAction
    End If
    If choice$ = "LISTEN" Then
        GoSub ListenAction
    End If
    If choice$ = "MOVE AHEAD" Then
        GoSub MoveAheadAction
    End If
    If choice$ = "MOVE BACKWARDS" Then
        GoSub MoveBackwardsAction
    End If
    If choice$ = "TURN LEFT" Then
        GoSub TurnLeftAction
    End If
    If choice$ = "TURN RIGHT" Then
        GoSub TurnRightAction
    End If
    If (choice$ = "PLAY GAME") Then
        GoSub PlayGameAction
    End If
    If (choice$ = "SPEAK NAME") Then
        GoSub SpeakNameAction
    End If
    If (choice$ = "CHASE BUNNIES") Then
        GoSub ChaseBunniesAction
    End If
    If (choice$ = "TAME FLUFF") Then
        GoSub TameFluffAction
    End If
    If (choice$ = "TAKE GOLD") Then
        GoSub TakeGoldAction
    End If
    If (choice$ = "ALL THE THINGS") Then
        GoSub AllTheThingsAction
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
' Display the map
For I = 1 To 5 Step 1
    mapInfo(I) = ""
Next
If (playerX% > 0) And (playerY% > 0) And (gameOver% = 0) Then
    mapInfo(1) = "Level: " + LTrim$(Str$(level%))
    mapInfo(2) = "Location: " + LTrim$(Str$(playerX%)) + "," + LTrim$(Str$(playerY%))
    mapInfo(3) = "Facing: " + directions(playerDirection%)
End If
Print String$((levelSize% - 1) / 2, " ") + "Map"
curRow% = CsrLin
Print String$(levelSize% + 2, "-") ' Top border
For y = 1 To levelSize% Step 1
    Print "|" + String$(levelSize%, " ") + "|" + "   " + mapInfo(y)
Next
Print String$(levelSize% + 2, "-") ' Bottom border
nextRow% = CsrLin
Locate curRow% + doorY%, 1 + doorX%
Print "*"
If gameOver% = 0 Then
    symbol$ = playerSymbol(playerDirection%)
    Locate curRow% + playerY%, 1 + playerX%
    Print symbol$
End If
Color 15
Locate nextRow%, 1
Return

ExitAction:
gameOver% = 1
Print
If Contains%(inventory$, "GOLD", ",") Then
    Print "But you were doing so well!  The magic door is out there."
    Print "You found the gold but didn't bring it home."
End If
Print "Your quest has ended... no fame.  And certainly no fortune."
Print "REMEMBER: Quitters never win."
Print
Return

CreditsAction:
Color 15
Print
Print "CREDITS"
Print
Print "Business Manager: Wayne Chung"
Print "Executive Producer: Wayne Chung"
Print "Power of Attorney: Wayne Chung"
Print "Development: Mylee and Mr. Chris"
Print "Creative Design: Zara and Greyson"
Return

ListenAction:
Color 15
scene$ = world(playerX%, playerY%)
Print
Print "You are in " + playerView$ + "."
' Decribe what the player is hearing, and restart audio if not currently playing
If sceneSound& = 0 Then
    Color 15
    Print "You hear nothing."
Else
    If _SndPlaying(sceneSound&) = 0 Then
        ReplaySound sceneSound&, 1, 0
    End If
    If scene$ = "WILDERNESS" Then
        Color 2
        Print "You hear birds singing and perhaps some insects."
        Print "There is also a slight breeze.  These are the typical"
        Print "sounds of nature."
    End If
    If scene$ = "MAGIC RING OF TOADSTOOLS" Then
        Color 6
        Print "You hear... magic, perhaps?  You attempt to focus"
        Print "on the sound but it disappears from your mind."
    End If
    If scene$ = "GIANNI'S DEN" Then
        Color 8
        Print "You hear the crackle of a campfire in a vacuous"
        Print "space.  The sounds of the outside world are muted."
        Print "This is a peaceful place."
    End If
    If scene$ = "WOODS" Then
        Color 7
        Print "You hear the typical sounds of the woods at night."
        Print "There are birds.  Definitely crows.  Maybe a"
        Print "woodpecker.  And... the hooting of an owl?"
    End If
    If scene$ = "MOUNT FLUFF" Then
        Color 15
        Print "Oh my!  What magnificent guitar strumming!  The"
        Print "styling is firm and decisive and yet also..."
        Print "romantic."
    End If
    If scene$ = "CASTLE" Then
        Color 14
        Print "You hear royal music... A harp!  A guitar!  And also"
        Print "the deep sound of a tuba.  How splendid!  The music"
        Print "carries loudly from the castle courtyard.  However,"
        Print "you hear nothing from within the castle."
    End If
    If scene$ = "DRAGON'S DEN" Then
        Color 4
        If dragonDead% = 0 Then
            Print "You hear the fearsome roar of a dragon!"
            Print "There is no time to stop and listen to it!"
        End If
    End If
    If scene$ = "GREYSON'S GAME ROOM" Then
        Color 1
        Print "You hear the typical sounds of an arcade."
        Print "Sounds like someone just got a power up?"
    End If
    If scene$ = "ZARA'S STORE" Then
        Color 5
        Print "You hear the hustling and bustling sounds of"
        Print "a successful store.  Sounds like someone just"
        Print "made a sale?"
    End If
End If
Color 15
Return

LookAction:
playerView$ = world(playerX%, playerY%)
Print
Print "You are in " + playerView$ + "."
If playerView$ = "WILDERNESS" Then
    Color 2
    Print "You see nothing but tall grass and cute bunnies."
    Print "The sun is shining brightly."
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
    If Contains%(inventory$, "RING OF TAMING", ",") Then
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
        If sceneSound& <> 0 Then
            StopSound sceneSound&
            sceneSound& = 0
        End If
        Print "The dragon once lived here until you, an amazing hero, slew it!"
        Print "Paintings depicting your heroic act now cover the wall, a tribute"
        Print "from the townspeople you saved!"
    End If
    If (Contains%(inventory$, "GOLD", ",")) And (Not Contains%(inventory$, "SWORD", ",")) And (Not Contains%(inventory$, "UNO REVERSE", ",")) Then
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
        If Not Contains%(inventory$, "GOLD", ",") Then
            Print "With nothing heavy to carry you are able to run away"
            Print "before the dragon can end your quest."
        Else
            StopSound sceneSound&
            sceneSound& = 0
            If (Contains%(inventory$, "SWORD", ",")) And (dragonDead% = 0) Then
                Print "With quick reflexes you use your mighty sword to slay the dragon."
                Print "The townspeople are saved.  And you are today a hero!!!"
                score% = score% + 100
                Color 15
                Print "Score +100"
                dragonDead% = 1
            Else
                If (Contains%(inventory$, "UNO REVERSE", ",")) And (dragonDead% = 0) Then
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
    Print "Perhaps the royal court fled because of BIG CHUNG?"
End If
If playerView$ = "ZARA'S STORE" Then
    Color 5
    Print "There are a lot of fun things to buy. Of particular note you"
    Print "see a mighty silver sword, fit for slaying a dragon."
    If (Contains%(inventory$, "GOLD", ",")) And (Not Contains%(inventory$, "SWORD", ",")) Then
        Print "You deposit some gold coins into the vending machine..."
        inventory$ = inventory$ + ",SWORD"
        Color 15
        Print "Inventory +SWORD"
    Else
        If Contains%(inventory$, "SWORD", ",") Then
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
    If (Contains%(inventory$, "GOLD", ",")) And (Not Contains%(inventory$, "UNO REVERSE", ",")) Then
        Print "You leave some gold coins on the table in exchange for the UNO deck."
        Print "You look at the cards and discover the legendary... UNO REVERSE!!!"
        inventory$ = inventory$ + ",UNO REVERSE"
        Color 15
        Print "Inventory +UNO REVERSE"
    Else
        If Contains%(inventory$, "UNO REVERSE", ",") Then
            Print "That mighty deck is in your hand... perhaps you should"
            Print "use it for some heroic deed?"
        Else
            Print "Maybe some day you'll return when you have some money."
        End If
    End If
End If
Print
If (playerView$ = "CASTLE") And (Not Contains%(inventory$, "GOLD", ",")) Then
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
        If (aheadX% = 0) Or (aheadX% = (levelSize% + 1)) Or (aheadY% = 0) Or (aheadY% = (levelSize% + 1)) Then
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
    If Contains%(inventory$, "GOLD", ",") Then
        Print
        Print "You have safely brought your riches back home."
        Print "Fame and fortune are yours."
        Print "YOU HAVE WON THE GAME!!!"
        If score% = 300 Then
            Color 15
            Print "MAXIMUM SCORE!!!"
        End If
    Else
        Print
        Print "You did not return home with the gold."
        Print "This is a horrible fate."
        Print "YOU HAVE LOST THE GAME."
    End If
Else
    If (aheadX% = 0) Or (aheadX% = (levelSize% + 1)) Or (aheadY% = 0) Or (aheadY% = (levelSize% + 1)) Then
        Print
        Print "There is nothing ahead.  You are facing the edge of the world."
        Print
        Print "Jumping off the edge of the world is NOT allowed in this game."
    Else
        ' Advance the player to the next scene
        lastScene$ = world(playerX%, playerY%)
        playerX% = aheadX%
        playerY% = aheadY%
        scene$ = world(playerX%, playerY%)

        ' Update the scene's sound
        If lastScene$ <> scene$ Then
            ' Stop playing the current scene's sound, if any
            If sceneSound& <> 0 Then
                StopSound sceneSound&
            End If

            ' Start playing the new scene's sound, if any
            If scene$ = "WILDERNESS" Then
                sceneSound& = PlaySound&("wilderness.mp3", 1, 1)
            End If
            If scene$ = "MAGIC RING OF TOADSTOOLS" Then
                sceneSound& = PlaySound&("magic.mp3", 1, 0)
            End If
            If scene$ = "GIANNI'S DEN" Then
                sceneSound& = PlaySound&("gianni.mp3", 1, 1)
            End If
            If scene$ = "WOODS" Then
                sceneSound& = PlaySound&("woods.mp3", 1, 1)
            End If
            If scene$ = "MOUNT FLUFF" Then
                sceneSound& = PlaySound&("fluff.wav", 1, 0)
            End If
            If scene$ = "CASTLE" Then
                sceneSound& = PlaySound&("castle.mp3", 1, 0)
            End If
            If scene$ = "DRAGON'S DEN" Then
                If dragonDead% = 0 Then
                    sceneSound& = PlaySound&("dragon.mp3", 1, 0)
                Else
                    If sceneSound& <> 0 Then
                        StopSound sceneSound&
                        sceneSound& = 0
                    End If
                End If
            End If
            If scene$ = "GREYSON'S GAME ROOM" Then
                sceneSound& = PlaySound&("grey.mp3", 1, 0)
            End If
            If scene$ = "ZARA'S STORE" Then
                sceneSound& = PlaySound&("zara.mp3", 1, 0)
            End If
        End If

        ' Add special choices specific to the new scene
        sceneChoices$ = basicChoices$
        If (scene$ = "CASTLE") And (Not Contains%(inventory$, "GOLD", ",")) Then
            sceneChoices$ = sceneChoices$ + ",TAKE GOLD"
        Else
            If scene$ = "MOUNT FLUFF" Then
                sceneChoices$ = sceneChoices$ + ",PLAY GAME"
                If Contains%(inventory$, "RING OF TAMING", ",") Then
                    sceneChoices$ = sceneChoices$ + ",TAME FLUFF"
                End If
            Else
                If scene$ = "MAGIC RING OF TOADSTOOLS" Then
                    sceneChoices$ = sceneChoices$ + ",SPEAK NAME"
                Else
                    If scene$ = "WILDERNESS" Then
                        sceneChoices$ = sceneChoices$ + ",CHASE BUNNIES"
                    End If
                End If
            End If
        End If

        ' Refresh the scene's description
        GoSub LookAction
    End If
End If
Return

MoveBackwardsAction:
Print
Print "Please don't try walking backwards.  You might trip."
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
sceneChoices$ = basicChoices$
If Not Contains%(inventory$, "GOLD", ",") Then
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
riddle$ = GetInput$("You", 0)
If (riddle$ = "THE SKY") Or (riddle$ = "THE BLUE SKY") Or (riddle$ = "BLUE SKY") Then
    riddle$ = "SKY"
End If
Print
If riddle$ = "SKY" Then
    Print "Fluffy Cat: Alas you have bested me!  And that was my"
    Print "finest riddle!  Very well then.  A deal is a deal. The"
    Print "magical name you seek is... SHMEBULOCK."
Else
    If riddle$ = exitGameAction$ Then
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
nameGuess$ = GetInput$("You", 0)
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
    GoSub PressAnyKey
    If Contains%(inventory$, "RING OF TAMING", ",") Then
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
        If Not Contains%(inventory$, "RING OF TAMING", ",") Then
            inventory$ = inventory$ + ",RING OF TAMING"
        End If
    End If
Else
    If nameGuess$ = exitGameAction$ Then
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
GoSub PressAnyKey
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

AllTheThingsAction:
Print
thingDone% = 0
If level% = 1 Then
    If dragonDead% = 0 Then
        dragonDead% = 1
        score% = score% + 100
        Print "You slew the dragon!"
        Print "Score +100"
        thingDone% = 1
    End If
    If catTamed% = 0 Then
        catTamed% = 1
        score% = score% + 100
        Print "You tamed the elusive cat!"
        Print "Score +100"
        thingDone% = 1
    End If
    If Not Contains%(inventory$, "RING OF TAMING", ",") Then
        If inventory$ = "NOTHING" Then
            inventory$ = "RING OF TAMING"
        Else
            inventory$ = inventory$ + ",RING OF TAMING"
        End If
        Print "You obtained the Ring of Taming!"
        Print "Inventory +RING OF TAMING"
        Print "(Does not work on large creatures.)"
        thingDone% = 1
    End If
    If Not Contains%(inventory$, "GOLD", ",") Then
        If inventory$ = "NOTHING" Then
            inventory$ = "GOLD"
        Else
            inventory$ = inventory$ + ",GOLD"
        End If
        score% = score% + 100
        Print "You obtained the Gold!"
        Print "Score +100"
        Print "Inventory +GOLD"
        thingDone% = 1
    End If
    If (character$ = "GREYSON") And (Not Contains%(inventory$, "UNO REVERSE", ",")) Then
        If inventory$ = "NOTHING" Then
            inventory$ = "UNO REVERSE"
        Else
            inventory$ = inventory$ + ",UNO REVERSE"
        End If
        Print "You obtained the legendary UNO Reverse card!"
        Print "Inventory +UNO REVERSE"
        thingDone% = 1
    End If
    If (character$ = "ZARA") And (Not Contains%(inventory$, "SWORD", ",")) Then
        If inventory$ = "NOTHING" Then
            inventory$ = "SWORD"
        Else
            inventory$ = inventory$ + ",SWORD"
        End If
        Print "You obtained the legendary SWORD!"
        Print "Inventory +SWORD"
        thingDone% = 1
    End If
    If thingDone% = 0 Then
        Print "You have done all the things for level " + LTrim$(Str$(level%)) + "."
    End If
End If
Return

' Prompt the user to press the any key in order to continue
PressAnyKey:
' Display the prompt text
Color 15
curRow% = CsrLin
prompt$ = "Press any key to continue"
Print prompt$
' Suspend program execution until the any key is pressed
Sleep
_KeyClear
' Clear the prompt text with spaces
Locate curRow%, 1
Print String$(Len(prompt$), " ")
' Reposition the cursor
Locate curRow%, 1
Return

' Does a string contain a given token? (1/0)
'
' Parameters:
' myString - String to search
' token - Token to find
' delimiter - String delimiting the tokens, if any
'
' Returns:
' Token was found? (1/0)
Function Contains% (myString As String, token As String, delimiter As String)
    Contains% = InStr(1, (delimiter + myString + delimiter), (delimiter + token + delimiter)) > 0
End Function

' Get input from the user
'
' Parameters:
' prompt - Text to display
' enableArrowKeys - Enable use of the keyboard arrow keys? (1/0)
'                   Up - "MOVE AHEAD"
'                   Down - "MOVE BACKWARDS"
'                   Left - "TURN LEFT"
'                   Right - "TURN RIGHT"
'
' Returns:
' User input
Function GetInput$ (prompt As String, enableArrowKeys As Integer)
    inp$ = ""
    cursor$ = Chr$(178)
    Color 15
    Print prompt + ": "
    currentRow% = CsrLin - 1
    currentCol% = Len(prompt + ": ") + 1
    Locate currentRow%, currentCol%
    Color 3
    Print cursor$
    c$ = ""
    While c$ <> Chr$(13)
        c$ = ""
        While c$ = ""
            c$ = InKey$
        Wend
        If (Asc(c$) >= 32) And (Asc(c$) <= 126) Then
            ' Alphanumeric characters
            If (inp$ = "") And ((c$ = " ") Or (c$ = Chr$(13))) Then
                ' Ignore the space key or enter key if nothing else has been entered
            Else
                If Len(inp$) < 40 Then
                    inp$ = (inp$ + UCase$(c$))
                    Locate currentRow%, currentCol%
                    Color 15
                    Print UCase$(c$)
                    Locate currentRow%, currentCol% + 1
                    Color 3
                    Print cursor$
                    currentCol% = currentCol% + 1
                Else
                    ' Ignore any input when the string gets too long
                End If
            End If
        Else
            ' Backspace character
            If c$ = Chr$(8) Then
                If Len(inp$) > 0 Then
                    inp$ = Left$(inp$, Len(inp$) - 1)
                    Locate currentRow%, currentCol% - 1
                    Color 3
                    Print cursor$ + " "
                    currentCol% = currentCol% - 1
                Else
                    ' Ignore any backspace when there is nothing left to delete
                End If
            Else
                If enableArrowKeys = 1 Then
                    ' Up arrow
                    If c$ = Chr$(0) + "H" Then
                        If RTrim$(LTrim$(inp$)) = "" Then
                            inp$ = "MOVE AHEAD"
                            c$ = Chr$(13)
                            Locate currentRow%, currentCol%
                            Color 15
                            Print inp$
                        End If
                    End If
                    ' Down arrow
                    If c$ = Chr$(0) + "P" Then
                        If RTrim$(LTrim$(inp$)) = "" Then
                            inp$ = "MOVE BACKWARDS"
                            c$ = Chr$(13)
                            Locate currentRow%, currentCol%
                            Color 15
                            Print inp$
                        End If
                    End If
                    ' Left arrow
                    If c$ = Chr$(0) + "K" Then
                        If RTrim$(LTrim$(inp$)) = "" Then
                            inp$ = "TURN LEFT"
                            c$ = Chr$(13)
                            Locate currentRow%, currentCol%
                            Color 15
                            Print inp$
                        End If
                    End If
                    ' Right arrow
                    If c$ = Chr$(0) + "M" Then
                        If RTrim$(LTrim$(inp$)) = "" Then
                            inp$ = "TURN RIGHT"
                            c$ = Chr$(13)
                            Locate currentRow%, currentCol%
                            Color 15
                            Print inp$
                        End If
                    End If
                End If
            End If
        End If
    Wend
    ' Clear the cursor
    Locate currentRow%, currentCol%
    Print " "
    ' Trim whitespace from the beginning and end of the input string
    GetInput$ = RTrim$(LTrim$(inp$))
    ' Reset the foreground text color
    Color 15
End Function

' Play a sound file
'
' Parameters:
' file - File location (WAV, OGG, or MP3 file types)
' volume - 0 to 1 value for volume (0=no sound, 1=max)
' loopSound - Play the sound in a continuous loop? (1/0)
'
' Returns:
' soundHandle&
Function PlaySound& (file As String, volume As Single, loopSound As Integer)
    soundHandle& = _SndOpen(file)
    If soundHandle& = 0 Then
        Beep
    Else
        _SndVol soundHandle&, volume
        _SndPlay soundHandle&
        If loopSound Then
            _SndLoop soundHandle&
        End If
    End If
    PlaySound& = soundHandle&
End Function

' Replay an already open sound file
'
' Parameters:
' soundHandle - LONG-type sound handle returned by PlaySound&
' volume - 0 to 1 value for volume (0=no sound, 1=max)
' loopSound - Play the sound in a continuous loop? (1/0)
Sub ReplaySound (soundHandle As Long, volume As Single, loopSound As Integer)
    If soundHandle& = 0 Then
        Beep
    Else
        _SndVol soundHandle&, volume
        _SndPlay soundHandle&
        If loopSound Then
            _SndLoop soundHandle&
        End If
    End If
End Sub

' Stop playing a sound file
'
' Parameters:
' soundHandle - LONG-type sound handle returned by PlaySound&
Sub StopSound (soundHandle As Long)
    If soundHandle <> 0 Then
        _SndStop soundHandle
        _SndClose soundHandle
    End If
End Sub
