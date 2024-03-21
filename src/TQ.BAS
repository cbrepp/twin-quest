' Resources:
' bionic-bunny.jpg - Bionic Bunny Soldier by Zara
' book.png - Empty book by Darkmoon_Art (https://pixabay.com/illustrations/reserve-pages-empty-book-open-book-3057904/)
' castle.mp3 - Royal vibes (harp guitar and tuba) (https://freesound.org/people/kbrecordzz/sounds/595865/)
' clouds.png - OpenClipart-Vectors (https://pixabay.com/vectors/sunrise-clouds-rising-sun-sky-sun-153600/)
' dragon.mp3 - The Roar of a 5-Headed Dragon (https://freesound.org/people/bevibeldesign/sounds/366095/)
' elevator.wav - music elevator ext (https://freesound.org/people/Jay_You/sounds/467240/)
' elevator-doors.png - Krolestwo_Nauki (https://pixabay.com/vectors/elevator-elevator-door-building-6232385/)
' elevator-open.mp3 - Elevator ding door open close, noisy, 10.mp3 (https://freesound.org/people/TRP/sounds/576359/)
' epic.mp3 - Epic Trailer Background Music (https://freesound.org/people/Migfus20/sounds/560454/)
' fluff.jpg - Gallant Sir Fluff on a mountain by Mr. Chris
' fluff2.jpg - Gallant Sir Fluff looking perplexed by Mr. Chris
' fluff.wav - Spanish Lick I, Acoustic- AB split stereo pair (Oktava).wav (https://freesound.org/people/debudding/sounds/44366/)
' gianni.mp3 - bonfire flames sizzling (https://freesound.org/people/florianreichelt/sounds/563764/)
' gianni.jpg - Son of Fluff climbing a stair railing by Mr. Chris
' gianni2.jpg - Son of Fluff curled up on a blanket by Mr. Chris
' grey.mp3 - 8-Bit Coin Or Power Up FX For Retro Video Games (https://freesound.org/people/Cloud-10/sounds/647977/)
' inventory.mp3 - Cash Register (https://freesound.org/people/kiddpark/sounds/201159/)
' magic.mp3 - Magic.mp3 (https://freesound.org/people/Bastianhallo/sounds/434050/)
' mylee.jpg - Mylee Marie by Mr. Chris
' points.mp3 - 320655__rhodesmas__level-up-01.mp3 (https://freesound.org/people/shinephoenixstormcrow/sounds/337049/)
' select-player.png - Image by johngelling from Pixabay (https://pixabay.com/vectors/people-man-woman-child-boy-girl-1886412/)
' select-player-grey.png - Image by johngelling from Pixabay (https://pixabay.com/vectors/people-man-woman-child-boy-girl-1886412/)
' select-player-zara.png - Image by johngelling from Pixabay (https://pixabay.com/vectors/people-man-woman-child-boy-girl-1886412/)
' suspense.mp3 - Drone Background Music (https://freesound.org/people/Migfus20/sounds/561085/)
' turn-page.mp3 - page turn (https://freesound.org/people/partheeban/sounds/457767/)
' wayne-chung.jpg - Image of Wayne Chung wondering what's going on
' wayne-chung.mp3 - Wang Chung "Everybody Have Fun Tonight" snippet
' wilderness.mp3 - birds_210513_0088.mp3 (https://freesound.org/people/titi2/sounds/571247/)
' woods.mp3 - forestsurroundings.mp3 (https://freesound.org/people/Luftrum/sounds/48411/)
' zara.mp3 - 050816 a crowded grocery store Sapporo.mp3 (https://freesound.org/people/pflanigan/sounds/390254/)

Type TextCursor
    lastColumn As Integer
    lastControlRow As Integer
    lastStoryRow As Integer
End Type

' TODO - Extract map properties into a new Map type
Type Book
    basicStoryChoices As String
    chapter As String
    controlChoices As String
    controlChoicesColumn As Integer
    controlChoicesRow As Integer
    cursor As TextCursor
    doorX As Integer
    doorY As Integer
    experiencePoints As Integer
    firstRow As Integer
    hitPoints As Integer
    image As Long
    inventory As String
    inventorySound As Long
    isCatTamed As Integer
    isDragonDead As Integer
    isOver As Integer
    isRightHanded As Integer
    lastRow As Integer
    leftPageStartingColumn As Integer
    level As Integer
    levelSize As Integer
    magicPoints As Integer
    maxPageLength As Integer
    pageNumber As Integer
    pageTurnSound As Long
    player As String
    playerDirection As Integer
    playerX As Integer
    playerY As Integer
    pointsSound As Long
    rightPageStartingColumn As Integer
    score As Integer
    secretChoices As String
    storyChoices As String
    storyChoicesColumn As Integer
    storyChoicesRow As Integer
    storySound As Long
    title As String
    twin As String
    version As String
End Type

' Initialize the game
Dim game As Book
game.title = "Twin Quest"
game.version = "0.1.0"
game.chapter = ""
game.isOver = 0
game.isRightHanded = 1 ' Are the game controls on the right page? (1/0)
game.image = _LoadImage("book.png", 32)
game.firstRow = 3 ' book.png allows for row 3 as the first row for text
game.lastRow = 46 ' book.png allows for row 46 as the last row for text
game.leftPageStartingColumn = 15 ' book.png allows for column 15 as the first column for starting text on the left page
game.rightPageStartingColumn = 83 ' book.png allows for column 83 as the first column for starting text on the right page
game.maxPageLength = 66 ' book.png allows for 66 characters of text on a single line of a single page
game.controlChoicesColumn = 0
game.controlChoicesRow = 0
game.storyChoices = "" ' current choices for the player
game.storyChoicesColumn = 0
game.storyChoicesRow = 0
game.player = "" ' GREYSON or ZARA
game.controlChoices = "CREDITS,FLIP BOOK,HIGH SCORES,EXIT GAME"
game.basicStoryChoices = "LOOK,LISTEN"
game.secretChoices = "MOVE AHEAD,MOVE BACKWARDS,TURN LEFT,TURN RIGHT,ALL THE THINGS"
game.score = 0
game.inventory = ""
game.isDragonDead = 0
game.isCatTamed = 0
game.storySound = 0
game.hitPoints = 100
game.magicPoints = 0
game.experiencePoints = 0

' Configure application window
_Title game.title$ + " " + game.version ' Set the application window's title

' Display "splash screen"
Call DisplaySplashScreen(game)

' Initialize common sounds
game.inventorySound = _SndOpen("inventory.mp3")
game.pointsSound = _SndOpen("points.mp3")

' Display pre-chapter pages with epic music
game.pageTurnSound = PlaySound&("turn-page.mp3", 1, 0)
game.storySound = PlaySound&("epic.mp3", 1, 1)
Call DisplayTitlePage(game)
game.chapter = "CREDITS"
Call DisplayCreditsPage(game)
game.chapter = "HIGH SCORES"
Call DisplayHighScoresPage(game)
game.chapter = "SELECT MAIN CHARACTER"
Call DisplaySelectPlayerPage(game)

' Start the actual story
game.chapter = "INTRODUCTION"
game.pageNumber = 1
game.storyChoices = game.basicStoryChoices
Dim world(5, 5) As String
Dim directions(4) As String
directions(1) = "NORTH"
directions(2) = "EAST"
directions(3) = "SOUTH"
directions(4) = "WEST"
Dim mapInfo(5) As String
Dim playerSymbol(4) As String
playerSymbol(1) = "^"
playerSymbol(2) = ">"
playerSymbol(3) = "v"
playerSymbol(4) = "<"
GoSub InitLevel1

' Main game loop
choice$ = ""
Do
    Call RefreshStoryPage(game, choice$, world(), directions())
    Call RefreshControlPage(game, world(), directions(), mapInfo(), playerSymbol())
    If game.isOver Then
        _Continue
    End If

    Color _RGB(0, 0, 0)

    ' TODO - Refactor this to be a re-usable story mode that activates before the story prompt
    If game.chapter = "INTRODUCTION" Then
        Call DisplayIntroduction(game, world(), directions(), mapInfo(), playerSymbol())
        If game.chapter = "CHAPTER 1" Then
            ' Every first step in every great adventure is... a first step
            choice$ = "MOVE AHEAD"
        End If
    Else
        ' Prompt for choice
        Locate game.cursor.lastStoryRow + 1, 1
        choice$ = StoryPrompt$(game, "Story Choices", game.storyChoices, 1, 1, 40)
    End If
Loop While game.isOver = 0

' TODO - Play a game over sound

' Check if the player has earned a spot on the HIGH SCORES list
If game.score > 0 Then
    GoSub ChallengeHighScores
End If

Locate game.cursor.lastStoryRow + 2, 1
Call PrintPageText(game, "story", CsrLin, " _____ _            _____           _")
Call PrintPageText(game, "story", CsrLin, "|_   _| |__   ___  | ____|_ __   __| |")
Call PrintPageText(game, "story", CsrLin, "  | | | '_ \ / _ \ |  _| | '_ \ / _` |")
Call PrintPageText(game, "story", CsrLin, "  | | | | | |  __/ | |___| | | | (_| |")
Call PrintPageText(game, "story", CsrLin, "  |_| |_| |_|\___| |_____|_| |_|\__,_|")
Call PrintPageText(game, "story", CsrLin + 1, "(Press any key to exit the program)")

End

ChallengeHighScores:
Dim highScores(10) As String
For i% = 1 To 10
    highScores(i%) = ""
Next i%
rank% = 0
If _FileExists("high-scores.txt") Then
    Open "high-scores.txt" For Input As #1
    i% = 1
    Do Until EOF(1)
        Input #1, fileLine$
        fileLineScore% = Val(Mid$(fileLine$, 1, 3))
        If (rank% = 0) And (game.score > fileLineScore%) Then
            rank% = i%
            i% = i% + 1 ' Move Over, Beethoven
        End If
        If i% <= 10 Then
            highScores(i%) = fileLine$
        End If
        i% = i% + 1
    Loop
    Close #1
    If i% <= 10 Then
        rank% = i%
    End If
Else
    rank% = 1
End If
If rank% > 0 Then
    Print
    Call PrintPageText(game, "story", CsrLin, "You have a new high score... rank " + LTrim$(Str$(rank%)) + "!")
    highScoreInitials$ = GetInput$(game, "Enter your initials", 0, 0, 3)
    highScores(rank%) = LTrim$(Str$(game.score)) + "   " + highScoreInitials$ + "   " + Date$
    Open "high-scores.txt" For Output As #1
    For i% = 1 To 10
        If (highScores(i%) <> "") Then
            Print #1, highScores(i%)
        End If
    Next i%
    Close #1
    Call DisplayHighScoresPage(game)
End If
Return

InitLevel1:
game.level = 1
game.levelSize = 3
game.doorX = 2
game.doorY = 0
game.playerX = game.doorX
game.playerY = game.doorY
game.playerDirection = 3
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
If game.player = "ZARA" Then
    world(1, 3) = "ZARA'S STORE"
Else
    If (game.player = "GREYSON") Or (game.player = "GREY") Then
        game.player = "GREYSON"
        world(1, 3) = "GREYSON'S GAME ROOM"
    Else
        End
    End If
End If

Return

InitLevel2:
game.level = 2
game.levelSize = 5
game.doorX = 3
game.doorY = 0
game.playerX = game.doorX
game.playerY = game.doorY
game.playerDirection = 3
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

Sub AllTheThingsAction (game As Book)
    thingDone% = 0
    If game.level = 1 Then
        If game.isDragonDead = 0 Then
            game.isDragonDead = 1
            Call IncreaseScore(game, 100)
            Call PrintPageText(game, "story", CsrLin, "You slew the dragon!")
            Call PrintPageText(game, "story", CsrLin, "Score +100")
            thingDone% = 1
        End If
        If game.isCatTamed = 0 Then
            game.isCatTamed = 1
            Call IncreaseScore(game, 100)
            Call PrintPageText(game, "story", CsrLin, "You tamed the elusive cat!")
            Call PrintPageText(game, "story", CsrLin, "Score +100")
            thingDone% = 1
        End If
        If Not Contains%(game.inventory, "RING OF TAMING", ",") Then
            Call IncreaseInventory(game, "RING OF TAMING")
            Call PrintPageText(game, "story", CsrLin, "You obtained the Ring of Taming!")
            Call PrintPageText(game, "story", CsrLin, "Inventory +RING OF TAMING")
            Call PrintPageText(game, "story", CsrLin, "(Does not work on large creatures.)")
            thingDone% = 1
        End If
        If Not Contains%(game.inventory, "GOLD", ",") Then
            Call IncreaseInventory(game, "GOLD")
            Call IncreaseScore(game, 100)
            Call PrintPageText(game, "story", CsrLin, "You obtained the Gold!")
            Call PrintPageText(game, "story", CsrLin, "Score +100")
            Call PrintPageText(game, "story", CsrLin, "Inventory +GOLD")
            thingDone% = 1
        End If
        If (game.player = "GREYSON") And (Not Contains%(game.inventory, "UNO REVERSE", ",")) Then
            Call IncreaseInventory(game, "UNO REVERSE")
            Call PrintPageText(game, "story", CsrLin, "You obtained the legendary UNO Reverse card!")
            Call PrintPageText(game, "story", CsrLin, "Inventory +UNO REVERSE")
            thingDone% = 1
        End If
        If (game.player = "ZARA") And (Not Contains%(game.inventory, "SWORD", ",")) Then
            Call IncreaseInventory(game, "SWORD")
            Call PrintPageText(game, "story", CsrLin, "You obtained the legendary SWORD!")
            Call PrintPageText(game, "story", CsrLin, "Inventory +SWORD")
            thingDone% = 1
        End If
        If thingDone% = 0 Then
            Call PrintPageText(game, "story", CsrLin, "You have done all the things for level " + LTrim$(Str$(game.level)) + ".")
        End If
    End If
End Sub

' Chase bunnies action
'
' Parameters:
' game - Book instance
Sub ChaseBunniesAction (game As Book)
    Color _RGB(0, 100, 0) ' dark green
    Call PrintPageText(game, "story", CsrLin, "Seems like an unimportant thing to do but nonetheless you try to chase some of the bunnies.")
    Call PrintPageText(game, "story", CsrLin + 1, "And...")

    Randomize Timer
    bunnyChance% = Int(Rnd * 3) + 1
    If bunnyChance% = 3 Then
        bunnyImage& = _LoadImage("bionic-bunny.jpg")
        Call DisplayImage(game, "story", bunnyImage&)
        Call PrintPageText(game, "story", CsrLin + 1, "Instead the bunnies start chasing you!  What are they, bionic???  You run as fast as you can to get away.")
        Call PrintPageText(game, "story", CsrLin + 1, "It would be best to forget this ever happened and continue on with your quest.")
    Else
        Call PrintPageText(game, "story", CsrLin + 1, "You can't catch a single one.  They are too fast!  Oh well, next time maybe.  You need to continue on with your quest.")
    End If

    If bunnyChance% = 3 Then
        _FreeImage bunnyImage&
    End If
End Sub

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

' Display the credits page
'
' Parameters:
' game - Book instance
Sub DisplayCreditsPage (game As Book)
    Call TurnPage(game, 1)
    Call PrintPageText(game, "story", CsrLin, "Business Manager: Wayne Chung")
    Call PrintPageText(game, "story", CsrLin, "Executive Producer: Wayne Chung")
    Call PrintPageText(game, "story", CsrLin, "Power of Attorney: Wayne Chung")
    Call PrintPageText(game, "story", CsrLin, "Development: Mylee and Mr. Chris")
    Call PrintPageText(game, "story", CsrLin, "Creative Design: Zara and Greyson")
    Call PressAnyKey(game, "control")
End Sub

' Display the high scores page
'
' Parameters:
' game - Book instance
Sub DisplayHighScoresPage (game As Book)
    Call TurnPage(game, 1)

    If _FileExists("high-scores.txt") Then
        Open "high-scores.txt" For Input As #1
        Do Until EOF(1)
            Input #1, fileLine$
            Call PrintPageText(game, "story", CsrLin, fileLine$)
        Loop
        Close #1
    Else
        Call PrintPageText(game, "story", CsrLin, "N/A")
    End If

    If game.isOver = 0 Then
        Call PressAnyKey(game, "control")
    End If
End Sub

' Display an image on a designated book page
'
' Parameters:
' game - Book instance
' page - (STORY/CONTROL) Which page of the book to use
' image - Image to display
Sub DisplayImage (game As Book, page As String, image As Long)
    ' Determine left edge of the designated page
    page = UCase$(page)
    If ((page = "STORY") And (game.isRightHanded = 1)) Or ((page = "CONTROL") And (game.isRightHanded = 0)) Then
        leftColumn% = game.leftPageStartingColumn
    Else
        If ((page = "STORY") And (game.isRightHanded = 0)) Or ((page = "CONTROL") And (game.isRightHanded = 1)) Then
            leftColumn% = game.rightPageStartingColumn
        Else
            If 1 / 0 Then
                ' Let the programmer know that they dorked things
            End If
        End If
    End If

    ' Calculate the top-left edge of the image
    centerColumn% = Int(leftColumn% + (game.maxPageLength / 2)) ' Calculate the middle column on the page
    imageWidth% = _Width(image)
    imageHeight% = _Height(image)
    imageColumn% = centerColumn% - Int((imageWidth% / _FontWidth) / 2) - 1
    imageRow% = CsrLin
    imageX% = imageColumn% * _FontWidth
    imageY% = imageRow% * _FontHeight
    _PutImage (imageX%, imageY%), image

    ' Move the cursor to the next row after the image
    nextRow% = imageRow% + _Ceil(imageHeight% / _FontHeight) + 1
    Locate nextRow%, leftColumn%
End Sub

' Display the introduction
'
' Parameters:
' game - Book instance
' world() - World data
' directions() - Cardinal directions
' mapInfo() - Map data
' playerSymbol() - Player map symbols
Sub DisplayIntroduction (game As Book, world() As String, directions() As String, mapInfo() As String, playerSymbol() As String)
    ' TODO - Would be nice to add back and forward arrows in the bottom corners of the story page.

    If game.pageNumber = 1 Then
        Call StopSound(game.storySound)
        game.storySound = PlaySound&("suspense.mp3", 1, 1)
        Call PrintPageText(game, "story", game.firstRow + 2, game.twin + ": " + Chr$(34) + "Ahh!!!  " + game.player + "!!!  Save me!!!" + Chr$(34))
        Call PressAnyKey(game, "story")
        Call PrintPageText(game, "story", CsrLin + 1, game.player + ": " + Chr$(34) + "I don't know if I can, but I will try!!!" + Chr$(34))
        Call PressAnyKey(game, "story")
        Call PrintPageText(game, "story", CsrLin + 1, game.twin + ": " + Chr$(34) + game.player + " he got me!!!  A big black cat got me!!!" + Chr$(34))
        Call PressAnyKey(game, "story")
        Call PrintPageText(game, "story", CsrLin + 1, "You set down the game controller you were holding (and what a shame, you were about to beat the Ender Dragon) and run toward the sound of your twin's voice just in time to see the door to the leprechaun closet in the back bedroom slam shut.  You run to the closet door, open it, and what you see next takes your breath away...")
        Call PressAnyKey(game, "story")
        Call PrintPageText(game, "story", CsrLin + 1, "Sticking your head into what was supposed to be a small closet you look around at what appears to be the surface of a cloud floating high above Pendleton, Indiana.  You wonder if this is perhaps a magic portal.")
        Call PressAnyKey(game, "story")
        Call PrintPageText(game, "story", CsrLin + 1, "You cautiously tap the cloud with your hand and discover that it's firm enough to walk on.  You then oh so very carefully put one foot into the closet, lower your head, and step through the doorway so you can get a better look...")
        Call PressAnyKey(game, "story")
        game.pageNumber = 2
    Else
        If game.pageNumber = 2 Then
            cloudsImage& = _LoadImage("clouds.png")
            elevatorDoorsImage& = _LoadImage("elevator-doors.png")
            Locate game.firstRow + 2, 1
            Call DisplayImage(game, "story", cloudsImage&)
            Locate game.firstRow + 2, 1
            Call DisplayImage(game, "story", elevatorDoorsImage&)
            Call PrintPageText(game, "story", CsrLin + 2, "You are now standing on the surface of a cloud floating high up in the sky.  You look around and see nothing but the large poofy white cloud, the blue sky, the bright yellow sun... and... what appears to be elevator doors in the middle of the cloud.")
            Call PressAnyKey(game, "story")
            Call PrintPageText(game, "story", CsrLin + 1, "Anxiety and fear grip you.  But you have no choice.  You must save " + game.twin + ".  And so...")
            Call PressAnyKey(game, "story")
            elevator& = PlaySound&("elevator-open.mp3", 1, 1)
            Call PrintPageText(game, "story", CsrLin + 1, "You press the elevator button to open the door.  And... you step inside...")
            Call PressAnyKey(game, "story")
            Call StopSound(elevator&)
            game.pageNumber = 3

            _FreeImage elevatorDoorsImage&
            _FreeImage cloudsImage&
        Else
            If game.pageNumber = 3 Then
                Call StopSound(game.storySound)
                game.storySound = PlaySound&("elevator.wav", 1, 1)
                Locate game.firstRow + 2, 1
                myleeImage& = _LoadImage("mylee.jpg")
                Call DisplayImage(game, "story", myleeImage&)
                Call PrintPageText(game, "story", CsrLin + 2, "Mylee: " + Chr$(34) + "Oh hey kid." + Chr$(34))
                Call PressAnyKey(game, "story")
                Call PrintPageText(game, "story", CsrLin + 1, "You're confused for a moment.  Inside the elevator there's a cat perched up on a shelf by the main elevator switch.  Is a cat operating this elevator?  And... did that cat just talk???")
                Call PressAnyKey(game, "story")
                Call PrintPageText(game, "story", CsrLin + 1, "Mylee: " + Chr$(34) + "You're wondering if I just talked even though I'm a cat.  And the answer is 'yes'.  Yes I did." + Chr$(34))
                Call PressAnyKey(game, "story")
                Call PrintPageText(game, "story", CsrLin + 1, "Wait, what?  Can this talking cat read your mind?")
                Call PressAnyKey(game, "story")
                Call PrintPageText(game, "story", CsrLin + 1, "Mylee: " + Chr$(34) + "And you're probably wondering now if I can read your mind.  The answer to that is... no.  And I definitely wouldn't want to if I could.  You humans are just too weird." + Chr$(34))
                Call PressAnyKey(game, "story")
                Call PrintPageText(game, "story", CsrLin + 1, "Weird is right.")
                Call PressAnyKey(game, "story")
                Call PrintPageText(game, "story", CsrLin + 1, "Mylee: " + Chr$(34) + "Enough small talk, human.  You look confused.  How about you ask me some questions." + Chr$(34))
                Call PressAnyKey(game, "story")
                game.pageNumber = 4

                _FreeImage myleeImage&
            Else
                If game.pageNumber = 4 Then
                    Call PrintPageText(game, "story", game.firstRow + 2, "Mylee: " + Chr$(34) + "You look like you're new to this so I'll help you out.  See that 'Ask Mylee' prompt below?  It's giving you some choices.  Pick one.  You can learn about this game before you begin your quest." + Chr$(34))
                    currentRow% = CsrLin
                    Locate currentRow% + 2, 1
                    choice$ = StoryPrompt$(game, "Ask Mylee", "WHO ARE YOU,WHERE IS MY TWIN,WHO IS BIG CHUNG,NOTHING", 0, 1, 16)
                    If choice$ = "WHO ARE YOU" Then
                        Call PrintPageText(game, "story", currentRow% + 8, "Mylee: " + Chr$(34) + "I'm Mylee Marie!" + Chr$(34))
                        Call PressAnyKey(game, "story")
                        Call PrintPageText(game, "story", CsrLin + 1, "You wait a moment for Mylee to say more but she doesn't.  Okay... at least you got her name.")
                        Call PressAnyKey(game, "story")
                    Else
                        If choice$ = "WHERE IS MY TWIN" Then
                            Call PrintPageText(game, "story", currentRow% + 8, "Mylee: " + Chr$(34) + "Oh you poor kid.  I'm afraid your twin was captured by my younger brother, Big Chung.  It is a shame." + Chr$(34))
                            Call PressAnyKey(game, "story")
                        Else
                            If choice$ = "WHO IS BIG CHUNG" Then
                                Call PrintPageText(game, "story", currentRow% + 8, "Mylee: " + Chr$(34) + "Oh he's quite the cat!  His appetite is as big as they come.  Some day he may eat the whole world.  But for now it seems like he's settled on your twin." + Chr$(34))
                                Call PressAnyKey(game, "story")
                                Call PrintPageText(game, "story", CsrLin + 1, game.player + ": " + Chr$(34) + "He's going to eat " + game.twin + "???" + Chr$(34))
                                Call PressAnyKey(game, "story")
                                Call PrintPageText(game, "story", CsrLin + 1, "Mylee: " + Chr$(34) + "Perhaps.  But you might have some time.  He just ate an entire Red Lobster restaurant for breakfast this morning so he might be full.  I bet your twin is an appetizer for later." + Chr$(34))
                                Call PressAnyKey(game, "story")
                                Call PrintPageText(game, "story", CsrLin + 1, game.player + ": " + Chr$(34) + "That's horrible!!!" + Chr$(34))
                                Call PressAnyKey(game, "story")
                                Call PrintPageText(game, "story", CsrLin + 1, "Mylee: " + Chr$(34) + "Don't I know it, kid.  But hey, tell you what... these elevator doors can take you to a magical world.  If you want to save your twin, gain some experience out there and then come back.  If you bring me some GOLD I'll take you to the level that Big Chung hangs out on.  But be careful, Night Owl and a Dragon like gold and if you remove any from their level they might come after you.  Best slay that dragon if you can and ask my friend Gianni for help with that Night Owl problem.  Don't you dare try to fight Night Owl in a dark place.  He'll swoop down on you before you have a chance to defend yourself." + Chr$(34))
                                Call PressAnyKey(game, "story")
                            Else
                                If choice$ = "NOTHING" Then
                                    Call PrintPageText(game, "story", currentRow% + 8, "Mylee: " + Chr$(34) + "Nothing else, huh.  Okay.  Well take this then..." + Chr$(34))
                                    Call IncreaseInventory(game, "GAME BOOK")
                                    currentRow% = CsrLin ' Remember the current row because refreshing the control page will change it
                                    Call RefreshControlPage(game, world(), directions(), mapInfo(), playerSymbol())
                                    Call PrintPageText(game, "story", currentRow% + 1, "INVENTORY +GAME BOOK")
                                    Call PrintPageText(game, "story", CsrLin + 1, "Mylee: " + Chr$(34) + "It's called a 'GAME BOOK'.  It will give you some options on the other page for exiting the game and stuff.  Maybe if you can find that SPELL BOOK I lost you'll have two books and a way to defeat Big Chung.  But don't worry, things like that have a way of turning up eventually.  Even when you don't think you'll find them again they make their way back to you." + Chr$(34))
                                    Call PressAnyKey(game, "story")
                                    Call PrintPageText(game, "story", CsrLin + 1, game.player + ": " + Chr$(34) + "Umm, thanks?" + Chr$(34))
                                    Call PressAnyKey(game, "story")
                                    Call PrintPageText(game, "story", CsrLin + 1, "Mylee: " + Chr$(34) + "You're welcome.  Now off with you!  I'll open the magic elevator doors for you.  Remember: Don't die.  And... bring me back some gold!!!" + Chr$(34))
                                    Call PressAnyKey(game, "story")
                                    elevator& = PlaySound&("elevator-open.mp3", 1, 1)
                                    Call PrintPageText(game, "story", CsrLin + 1, "It would seem like you're no longer welcome in this elevator.  MYLEE flips a switch and the doors open.  You walk out and find that you are no longer on the cloud...")
                                    Call PressAnyKey(game, "story")
                                    Call StopSound(elevator&)
                                    game.chapter = "CHAPTER 1"
                                End If
                            End If
                        End If
                    End If
                Else
                End If
            End If
        End If
    End If
End Sub

' Display the select player page
'
' Parameters:
' game - Book instance
Sub DisplaySelectPlayerPage (game As Book)
    ' TODO - Add the ability to hover over a portion of the image to highlight one of the players and let a mouse click auto-select that player
    ' TODO - Display a brief description of the highlighted player
    selectPlayerImage& = _LoadImage("select-player.png")
    turnPageSound% = 1

    Do
        Call TurnPage(game, turnPageSound%)
        Call DisplayImage(game, "story", selectPlayerImage&)
        game.player = StoryPrompt$(game, "Player Choices", "GREYSON,ZARA", 0, 1, 7)
        turnPageSound% = 0 ' If the player enters an incorrect choice and the page is turned to reset the screen, be silent
    Loop While Not Contains%(game.storyChoices + ",GREY", game.player, ",")

    If game.player = "ZARA" Then
        game.twin = "GREYSON"
    Else
        game.twin = "ZARA"
    End If

    _FreeImage selectPlayerImage&
End Sub

' Display the splash screen
'
' Parameters:
' game - Book instance
Sub DisplaySplashScreen (game As Book)
    ' Play Wayne Chung's theme song
    game.storySound = PlaySound&("wayne-chung.mp3", 1, 0)
    ' Display Wayne Chung's picture
    Cls
    wayneChungImage& = _LoadImage("wayne-chung.jpg", 32) 'load the image file to be drawn
    Screen wayneChungImage&
    _ScreenMove ((_DesktopWidth \ 2) - (_Width \ 2)) - 3, ((_DesktopHeight \ 2) - (_Height \ 2)) - 29 - 400 ' Center the application window (400 offsets two stacked monitors)
    ' Display overlay text
    Color _RGB(0, 0, 0)
    _PrintMode _KeepBackground
    Locate 7, 2
    Print "Wayne Chung Enterprises"
    Locate 9, 9
    Print "presents"
    Locate 46, 2
    ' Suspend program execution for 5 seconds or until the user presses the any key
    Sleep 5
    ' Stop playing Wayne Chung's theme music and remove his picture (New screen must be set without Chung's picture before it is free'ed)
    StopSound game.storySound

    ' Display the book picture so Wayne Chung's picture can be freed from memory
    Screen _NewImage(1280, 793, 32)
    Cls , _RGB(0, 0, 0)
    _PutImage , game.image
    _FreeImage wayneChungImage& ' Free up memory used by the image
End Sub

' Display the title page
'
' Parameters:
' game - Book instance
Sub DisplayTitlePage (game As Book)
    Call TurnPage(game, 1)
    Color _RGB(139, 0, 0) ' dark red
    ' TODO - Since TurnPage() moves the cursor to row 5, can the row parameters all just be CsrLin?
    Call PrintPageText(game, "story", 5, "                                   ___, ____--'")
    Call PrintPageText(game, "story", 6, "                              _,-.'_,-'      (")
    Call PrintPageText(game, "story", 7, "                           ,-' _.-''....____(")
    Call PrintPageText(game, "story", 8, "                 ,))_     /  ,'\ `'-.     (          /\")
    Call PrintPageText(game, "story", 9, "         __ ,+..a`  \(_   ) /   \    `'-..(         /  \")
    Call PrintPageText(game, "story", 10, "         )`-;...,_   \(_ ) /     \  ('''    ;'^^`\ <./\.>")
    Call PrintPageText(game, "story", 11, "             ,_   )   |( )/   ,./^``_..._  < /^^\ \_.))")
    Call PrintPageText(game, "story", 12, "            `=;; (    (/_')-- -'^^`      ^^-.`_.-` >-'")
    Call PrintPageText(game, "story", 13, "            `=\\ (                             _,./")
    Call PrintPageText(game, "story", 14, "              ,\`(                         )^^^")
    Call PrintPageText(game, "story", 15, "                ``;         __-'^^\       /")
    Call PrintPageText(game, "story", 16, "                  / _>---^^^   `\..`-.    ``'.")
    Call PrintPageText(game, "story", 17, "                 / /               / /``'`; /")
    Call PrintPageText(game, "story", 18, "                / /          ,-=='-`=-'  / /")
    Call PrintPageText(game, "story", 19, "          ,-=='-`=-.               ,-=='-`=-.")
    Color _RGB(0, 0, 0) ' black
    Call PrintPageText(game, "story", 20, "        *******************************************")
    Call PrintPageText(game, "story", 21, "                    T W I N   Q U E S T")
    Call PrintPageText(game, "story", 24, "                            b y")
    Call PrintPageText(game, "story", 26, "                  Wayne Chung Enterprises")
    Print
    Print
    Call PressAnyKey(game, "control")
End Sub

Sub DumbAction (game As Book)
    Call PrintPageText(game, "story", CsrLin, "That is NOT a choice.  Better luck next time.")
    Print
End Sub

Sub ExitAction (game As Book)
    game.isOver = 1
    If Contains%(game.inventory, "GOLD", ",") Then
        Call PrintPageText(game, "story", CsrLin, "But you were doing so well!  You could have tried returning the GOLD to the elevator.")
        Call PrintPageText(game, "story", CsrLin, "You found the GOLD but didn't bring it home.")
    End If
    Call PrintPageText(game, "story", CsrLin, "Your quest has ended... no fame.  And certainly no fortune.")
    Call PrintPageText(game, "story", CsrLin, "REMEMBER: Quitters never win.")
End Sub

' Get input from the user
'
' Parameters:
' game - Book instance
' prompt - Text to display
' enableArrowKeys - Enable use of the keyboard arrow keys? (1/0)
'                   Up - "MOVE AHEAD"
'                   Down - "MOVE BACKWARDS"
'                   Left - "TURN LEFT"
'                   Right - "TURN RIGHT"
' enableMouse - Enable use of the mouse? (1/0)
' maxLength - Maximum number of characters to input
'
' Returns:
' User input
Function GetInput$ (game As Book, prompt As String, enableArrowKeys As Integer, enableMouse As Integer, maxLength As Integer)
    ' TODO - When printing text on an image, the runtime won't keep track of the image area being printed on and there is no clean way
    ' to remove text without implementing something that does this via a command like GET that copies each slice of a region that could
    ' be printed on so it can be redisplayed later.
    inp$ = ""
    While _MouseInput <> 0 ' Read the mouse input until there is no more left to clear previous clicks
    Wend
    highlightedChoice$ = ""
    highlightedChoiceRow% = 0
    highlightedChoiceCol% = 0
    If enableMouse Then
        ' TODO - This is an ugly work-around to not being able to section out the mouse calculations into a subroutine
        fakeInput% = 1
    Else
        fakeInput% = 0
    End If
    cursor$ = Chr$(178)
    currentRow% = CsrLin
    If game.isRightHanded Then
        startingColumn% = game.leftPageStartingColumn ' Story page is the left-hand page
    Else
        startingColumn% = game.rightPageStartingColumn ' Story page is the right-hand page
    End If
    Color _RGB(0, 0, 0) ' black
    Locate currentRow%, startingColumn%
    Print prompt + ": "
    _PrintMode _FillBackground ' Replace background instead of displaying just text over the image
    Color _RGB(255, 255, 255), _RGB(255, 255, 255) ' white on white
    Locate currentRow%, startingColumn% + Len(prompt + ": ")
    Print String$(maxLength + 1, " ") ' Print spaces to clear the field and make all white so that a white block can be used to erase characters
    currentCol% = startingColumn% + Len(prompt + ": ")
    Locate currentRow%, currentCol%
    Color _RGB(0, 139, 139), _RGB(255, 255, 255) ' dark cyan
    Print cursor$
    c$ = ""
    While c$ <> Chr$(13)
        c$ = ""
        While (c$ = "") And (Not _MouseInput) And (Not fakeInput%)
            c$ = InKey$
        Wend
        ' If InKey$ is still empty, that means _MouseInput is set
        If c$ = "" Then
            ' Handle the mouse event
            If enableMouse Then
                If fakeInput% = 1 Then
                    fakeInput% = 0
                End If
                ' Calculate the row and column of the current mouse position
                mouseRow% = _Ceil(_MouseY / _FontHeight)
                mouseCol% = _Ceil(_MouseX / _FontWidth)
                ' The possible choices are limited to the current row
                possibleChoices$ = ""
                If (mouseRow% = game.controlChoicesRow) Then
                    possibleChoices$ = game.controlChoices
                    possibleChoicesCol% = game.controlChoicesColumn
                Else
                    If (mouseRow% = game.storyChoicesRow) Then
                        possibleChoices$ = game.storyChoices
                        possibleChoicesCol% = game.storyChoicesColumn
                    End If
                End If
                'Print "mouseRow%=" + Str$(mouseRow%) + ", mouseCol%=" + Str$(mouseCol%) + ", game.storyChoicesRow=" + Str$(game.storyChoicesRow) + ", game.storyChoicesColumn=" + Str$(game.storyChoicesColumn) + ", game.storyChoices=" + game.storyChoices
                ' Evaluate whethere there are possible choices on the current row and the mouse cursor's column position is in the range of the possible choices
                choice$ = ""
                If (possibleChoices$ <> "") And (mouseCol% >= possibleChoicesCol%) And (mouseCol% <= (possibleChoicesCol% + Len(possibleChoices$) - 1)) Then
                    choicePosition% = mouseCol% - possibleChoicesCol% + 1 ' Get the exact character position of the current choices string... 1 to the length of the choices
                    If Mid$(possibleChoices$, choicePosition%, 1) <> "," Then
                        ' Calculate rightmost character position of the current choice by looking for the next comma
                        choiceRightPos% = InStr(choicePosition%, possibleChoices$, ",")
                        If choiceRightPos% = 0 Then
                            ' There was no comma to the right of the current character so this must be the final choice
                            choiceRightPos% = Len(possibleChoices$)
                        Else
                            ' The rightmost character is 1 less than the position of the comma
                            choiceRightPos% = choiceRightPos% - 1
                        End If
                        ' Calculate leftmost character position of the current choice by looking for the previous comma
                        choiceLeftPos% = _InStrRev(choicePosition%, possibleChoices$, ",")
                        If choiceLeftPos% = 0 Then
                            ' There was no comma to the left of the current character so this must be the first choice
                            choiceLeftPos% = 1
                        Else
                            ' The leftmost character is 1 greater than the position of the comma
                            choiceLeftPos% = choiceLeftPos% + 1
                        End If
                        ' Extract the current choice using the leftmost and rightmost character positions
                        choice$ = Mid$(possibleChoices$, choiceLeftPos%, choiceRightPos% - choiceLeftPos% + 1)
                        If _MouseButton(1) = -1 Then
                            ' Handle a click using the left mouse button
                            inp$ = choice$
                            c$ = Chr$(13)
                            Locate currentRow%, currentCol%
                            Color _RGB(0, 0, 0), _RGB(255, 255, 255) ' black on white
                            Print inp$
                        Else
                            ' User only hovered over a new choice
                            If highlightedChoice$ <> choice$ Then
                                If highlightedChoice$ <> "" Then
                                    ' Remove the highlight from the last highlighted choice
                                    Locate highlightedChoiceRow%, highlightedChoiceCol%
                                    Color _RGB(0, 139, 139), _RGB(255, 255, 255) ' dark cyan on white
                                    Print highlightedChoice$
                                End If
                                ' Highlight the new choice
                                highlightedChoiceRow% = mouseRow%
                                highlightedChoiceCol% = possibleChoicesCol% + choiceLeftPos% - 1
                                Locate highlightedChoiceRow%, highlightedChoiceCol%
                                Color _RGB(0, 255, 255), _RGB(255, 255, 255) ' cyan on white
                                Print choice$
                                highlightedChoice$ = choice$
                            End If
                        End If
                    End If
                End If
                ' Handle no current choice and yet there was a highlighted choice the last time there was a mouse event
                If (choice$ = "") And (highlightedChoice$ <> "") Then
                    ' Remove the highlight from the last highlighted choice
                    Locate highlightedChoiceRow%, highlightedChoiceCol%
                    Color _RGB(0, 139, 139)
                    Print highlightedChoice$
                    highlightedChoice$ = ""
                    highlightedChoiceRow% = 0
                    highlightedChoiceCol% = 0
                End If
            End If
        Else
            If (Asc(c$) >= 32) And (Asc(c$) <= 126) Then
                ' Alphanumeric characters
                If (inp$ = "") And ((c$ = " ") Or (c$ = Chr$(13))) Then
                    ' Ignore the space key or enter key if nothing else has been entered
                Else
                    If Len(inp$) < maxLength Then
                        inp$ = (inp$ + UCase$(c$))
                        Locate currentRow%, currentCol%
                        Color _RGB(0, 0, 0), _RGB(255, 255, 255) ' black on white
                        Print UCase$(c$)
                        Locate currentRow%, currentCol% + 1
                        Color _RGB(0, 139, 139), _RGB(255, 255, 255) ' dark cyan on white
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
                        Color _RGB(0, 139, 139), _RGB(255, 255, 255) ' dark cyan on white
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
                                Color _RGB(0, 0, 0), _RGB(255, 255, 255) ' black on white
                                Print inp$
                            End If
                        End If
                        ' Down arrow
                        If c$ = Chr$(0) + "P" Then
                            If RTrim$(LTrim$(inp$)) = "" Then
                                inp$ = "MOVE BACKWARDS"
                                c$ = Chr$(13)
                                Locate currentRow%, currentCol%
                                Color _RGB(0, 0, 0), _RGB(255, 255, 255) ' black on white
                                Print inp$
                            End If
                        End If
                        ' Left arrow
                        If c$ = Chr$(0) + "K" Then
                            If RTrim$(LTrim$(inp$)) = "" Then
                                inp$ = "TURN LEFT"
                                c$ = Chr$(13)
                                Locate currentRow%, currentCol%
                                Color _RGB(0, 0, 0), _RGB(255, 255, 255) ' black on white
                                Print inp$
                            End If
                        End If
                        ' Right arrow
                        If c$ = Chr$(0) + "M" Then
                            If RTrim$(LTrim$(inp$)) = "" Then
                                inp$ = "TURN RIGHT"
                                c$ = Chr$(13)
                                Locate currentRow%, currentCol%
                                Color _RGB(0, 0, 0), _RGB(255, 255, 255) ' black on white
                                Print inp$
                            End If
                        End If
                    End If
                End If
            End If
        End If
    Wend
    ' Clear the current input
    _KeyClear
    ' TODO - If the player uses the mouse to click a choice, blanking the prompt actually blanks the first character of the choice... oops
    ' Clear the cursor
    'Locate currentRow%, currentCol%
    'Print " "
    ' Trim whitespace from the beginning and end of the input string
    GetInput$ = RTrim$(LTrim$(inp$))
    If highlightedChoice$ <> "" Then
        ' Remove the highlight from the last highlighted choice
        Locate highlightedChoiceRow%, highlightedChoiceCol%
        Color _RGB(0, 139, 139), _RGB(255, 255, 255) ' dark cyan on white
        Print highlightedChoice$
    End If
    ' Reset the foreground text color and print mode of printing text over the book image
    _PrintMode _KeepBackground
    Color _RGB(0, 0, 0)
End Function

' Parameters:
' game - Book instance
' item - Item to add to the inventory
Sub IncreaseInventory (game As Book, item As String)
    If Not Contains%(game.inventory, item, ",") Then
        If game.inventory = "" Then
            game.inventory = item
        Else
            game.inventory = game.inventory + "," + item
        End If
        Call ReplaySound(game.inventorySound, 1, 0)
    End If
End Sub

' Parameters:
' game - Book instance
' points - Number of points by which to increase the score
Sub IncreaseScore (game As Book, points As Integer)
    game.score = game.score + points
    game.experiencePoints = game.experiencePoints + points
    Call ReplaySound(game.pointsSound, 1, 0)
End Sub

Sub ListenAction (game As Book, world() As String)
    scene$ = world(game.playerX, game.playerY)
    Call PrintPageText(game, "story", CsrLin, "You are in " + scene$ + ".")
    ' Decribe what the player is hearing, and restart audio if not currently playing
    If game.storySound = 0 Then
        Call PrintPageText(game, "story", CsrLin, "You hear nothing.")
    Else
        If _SndPlaying(game.storySound) = 0 Then
            ReplaySound game.storySound, 1, 0
        End If
        If scene$ = "WILDERNESS" Then
            Color _RGB(0, 100, 0) ' dark green
            Call PrintPageText(game, "story", CsrLin, "You hear birds singing and perhaps some insects.")
            Call PrintPageText(game, "story", CsrLin, "There is also a slight breeze.  These are the typical")
            Call PrintPageText(game, "story", CsrLin, "sounds of nature.")
        End If
        If scene$ = "MAGIC RING OF TOADSTOOLS" Then
            Color _RGB(184, 115, 51)
            Call PrintPageText(game, "story", CsrLin, "You hear... magic, perhaps?  You attempt to focus")
            Call PrintPageText(game, "story", CsrLin, "on the sound but it disappears from your mind.")
        End If
        If scene$ = "GIANNI'S DEN" Then
            Color _RGB(169, 169, 169)
            Call PrintPageText(game, "story", CsrLin, "You hear the crackle of a campfire in a vacuous")
            Call PrintPageText(game, "story", CsrLin, "space.  The sounds of the outside world are muted.")
            Call PrintPageText(game, "story", CsrLin, "This is a peaceful place.")
        End If
        If scene$ = "WOODS" Then
            Color _RGB(92, 64, 51)
            Call PrintPageText(game, "story", CsrLin, "You hear the typical sounds of the woods at night.")
            Call PrintPageText(game, "story", CsrLin, "There are birds.  Definitely crows.  Maybe a")
            Call PrintPageText(game, "story", CsrLin, "woodpecker.  And... the hooting of an owl?")
        End If
        If scene$ = "MOUNT FLUFF" Then
            Color _RGB(0, 0, 0)
            Call PrintPageText(game, "story", CsrLin, "Oh my!  What magnificent guitar strumming!  The")
            Call PrintPageText(game, "story", CsrLin, "styling is firm and decisive and yet also...")
            Call PrintPageText(game, "story", CsrLin, "romantic.")
        End If
        If scene$ = "CASTLE" Then
            Color _RGB(255, 255, 0)
            Call PrintPageText(game, "story", CsrLin, "You hear royal music... A harp!  A guitar!  And also")
            Call PrintPageText(game, "story", CsrLin, "the deep sound of a tuba.  How splendid!  The music")
            Call PrintPageText(game, "story", CsrLin, "carries loudly from the castle courtyard.  However,")
            Call PrintPageText(game, "story", CsrLin, "you hear nothing from within the castle.")
        End If
        If scene$ = "DRAGON'S DEN" Then
            Color _RGB(255, 0, 0)
            If game.isDragonDead = 0 Then
                Call PrintPageText(game, "story", CsrLin, "You hear the fearsome roar of a dragon!")
                Call PrintPageText(game, "story", CsrLin, "There is no time to stop and listen to it!")
            End If
        End If
        If scene$ = "GREYSON'S GAME ROOM" Then
            Color _RGB(0, 0, 255)
            Call PrintPageText(game, "story", CsrLin, "You hear the typical sounds of an arcade.")
            Call PrintPageText(game, "story", CsrLin, "Sounds like someone just got a power up?")
        End If
        If scene$ = "ZARA'S STORE" Then
            Color _RGB(255, 0, 255)
            Call PrintPageText(game, "story", CsrLin, "You hear the hustling and bustling sounds of")
            Call PrintPageText(game, "story", CsrLin, "a successful store.  Sounds like someone just")
            Call PrintPageText(game, "story", CsrLin, "made a sale?")
        End If
    End If
    Color _RGB(0, 0, 0)
End Sub

Sub LookAction (game As Book, world() As String, directions() As String)
    playerView$ = world(game.playerX, game.playerY)
    Call PrintPageText(game, "story", CsrLin, "You are in " + playerView$ + ".")
    If playerView$ = "WILDERNESS" Then
        Color _RGB(0, 100, 0) ' dark green
        Call PrintPageText(game, "story", CsrLin, "You see nothing but tall grass and cute bunnies.")
        Call PrintPageText(game, "story", CsrLin, "The sun is shining brightly.")
    End If
    If playerView$ = "WOODS" Then
        Color _RGB(192, 192, 192)
        Randomize Timer
        nightOwlChance% = Int(Rnd * 3) + 1
        If nightOwlChance% = 3 Then
            Call PrintPageText(game, "story", CsrLin, "The sky is dark and you hear the sound of flapping wings.")
            Call PrintPageText(game, "story", CsrLin, "By the time you look up it's too late.  Night Owl has claimed")
            Call PrintPageText(game, "story", CsrLin, "you as his prey!  What an unfortunate way to end your journey.")
            Print
            Color _RGB(0, 0, 0)
            Call PrintPageText(game, "story", CsrLin, "You have died.")
            If game.score > 0 Then
                Call PrintPageText(game, "story", CsrLin, "Score -" + LTrim$(Str$(game.score)))
                game.score = 0
            End If
            game.isOver = 1
        Else
            If nightOwlChance% = 2 Then
                Call PrintPageText(game, "story", CsrLin, "The sky is dark and you hear the sound of flapping wings.")
                Call PrintPageText(game, "story", CsrLin, "By the time you look up there's already a scream close by")
                Call PrintPageText(game, "story", CsrLin, "as Night Owl has claimed a poor creature as his prey.  You")
                Call PrintPageText(game, "story", CsrLin, "have escaped death.  But... for how long?")
            Else
                Call PrintPageText(game, "story", CsrLin, "The sky is dark and Night Owl is hiding somewhere.  You must")
                Call PrintPageText(game, "story", CsrLin, "take care to tread lightly lest a noise alert Night Owl to")
                Call PrintPageText(game, "story", CsrLin, "your whereabouts.  Be very, very quiet.")
            End If
        End If
    End If
    If playerView$ = "MAGIC RING OF TOADSTOOLS" Then
        Color _RGB(184, 115, 51)
        Call PrintPageText(game, "story", CsrLin, "A magical place of faeries and giant mushrooms!")
        Call PrintPageText(game, "story", CsrLin, "A simple wooden sign sits in the center of this place.  On")
        Call PrintPageText(game, "story", CsrLin, "this sign reads a simple message...")
        Print
        Call PrintPageText(game, "story", CsrLin, "'Speak the name of the spirit that dwells in this place and")
        Call PrintPageText(game, "story", CsrLin, "be gifted with a magical item.'")
    End If
    If playerView$ = "MOUNT FLUFF" Then
        fluffImage& = _LoadImage("fluff.jpg")
        Call DisplayImage(game, "story", fluffImage&)
        Color _RGB(0, 0, 0)
        Call PrintPageText(game, "story", CsrLin + 1, "You come upon the base of a mountain and see a gallant white tom cat wearing boots and playing a spanish guitar.  His melody hypnotizes you.  And my... he is so fluffy!")
        Call PrintPageText(game, "story", CsrLin + 1, "You are astonished to learn that this cat can speak.  He enjoys challenging others to a guessing game.  If you solve his riddle, he might just give you a prize.")
        _FreeImage fluffImage&
    End If
    If playerView$ = "GIANNI'S DEN" Then
        Color _RGB(169, 169, 169)
        Call PrintPageText(game, "story", CsrLin, "You find yourself in a dark cave.  A fire burns deep inside.  You explore the cave and find yourself face to face with an adorable black cat curled up on a Pittsburgh Steelers blanket.")
        Call PrintPageText(game, "story", CsrLin + 1, "He's so cuuuuuuute!")
        Print
        If Contains%(game.inventory, "RING OF TAMING", ",") Then
            gianniImage& = _LoadImage("gianni.jpg")
            Call DisplayImage(game, "story", gianniImage&)
            _FreeImage gianniImage&
            If game.isCatTamed = 0 Then
                game.isCatTamed = 1
                Call PrintPageText(game, "story", CsrLin + 1, "You use your ring of taming on him and he jumps into your waiting arms.  You pet him for hours and hours.")
                Color _RGB(0, 0, 0)
                Call PrintPageText(game, "story", CsrLin, "Score +100")
                Call IncreaseScore(game, 100)
            Else
                Call PrintPageText(game, "story", CsrLin + 1, "He meows with delight when he sees you and jumps into your waiting arms.  Oh what a wonderful cat he is!")
            End If
        Else
            gianniImage& = _LoadImage("gianni2.jpg")
            Call DisplayImage(game, "story", gianniImage&)
            _FreeImage gianniImage&
            Call PrintPageText(game, "story", CsrLin + 1, "You attempt to pet him but he climbs a stair railing to get away.  If only you could tame him.  But such a feat would require strong magic...")
        End If
    End If
    If playerView$ = "DRAGON'S DEN" Then
        Color _RGB(255, 0, 0)
        If game.isDragonDead = 0 Then
            Call PrintPageText(game, "story", CsrLin, "You find yourself in a dark cave.  A fire burns deep inside.")
            Call PrintPageText(game, "story", CsrLin, "You explore the cave and find yourself face to face with a")
            Call PrintPageText(game, "story", CsrLin, "ferocious dragon!")
        Else
            If game.storySound <> 0 Then
                StopSound game.storySound
                game.storySound = 0
            End If
            Call PrintPageText(game, "story", CsrLin, "The dragon once lived here until you, an amazing hero, slew it!")
            Call PrintPageText(game, "story", CsrLin, "Paintings depicting your heroic act now cover the wall, a tribute")
            Call PrintPageText(game, "story", CsrLin, "from the townspeople you saved!")
        End If
        If (Contains%(game.inventory, "GOLD", ",")) And (Not Contains%(game.inventory, "SWORD", ",")) And (Not Contains%(game.inventory, "UNO REVERSE", ",")) Then
            Call PrintPageText(game, "story", CsrLin, "The greedy dragon sees your gold and blasts you with")
            Call PrintPageText(game, "story", CsrLin, "its burning fire.  With no defense, you are burned to death.")
            Call PrintPageText(game, "story", CsrLin, "Alas, this is the end of your quest.")
            Print
            Color _RGB(0, 0, 0)
            Call PrintPageText(game, "story", CsrLin, "You have died.")
            Call PrintPageText(game, "story", CsrLin, "Score -" + LTrim$(Str$(game.score)))
            game.score = 0
            game.isOver = 1
        Else
            If Not Contains%(game.inventory, "GOLD", ",") Then
                Call PrintPageText(game, "story", CsrLin, "With nothing heavy to carry you are able to run away")
                Call PrintPageText(game, "story", CsrLin, "before the dragon can end your quest.")
            Else
                StopSound game.storySound
                game.storySound = 0
                If (Contains%(game.inventory, "SWORD", ",")) And (game.isDragonDead = 0) Then
                    Call PrintPageText(game, "story", CsrLin, "With quick reflexes you use your mighty sword to slay the dragon.")
                    Call PrintPageText(game, "story", CsrLin, "The townspeople are saved.  And you are today a hero!!!")
                    Call IncreaseScore(game, 100)
                    Color _RGB(0, 0, 0)
                    Call PrintPageText(game, "story", CsrLin, "Score +100")
                    game.isDragonDead = 1
                Else
                    If (Contains%(game.inventory, "UNO REVERSE", ",")) And (game.isDragonDead = 0) Then
                        Call PrintPageText(game, "story", CsrLin, "With quick reflexes you use your UNO REVERSE card to send the dragon's")
                        Call PrintPageText(game, "story", CsrLin, "flames back at it.  With each fiery burst, the dragon destroys itself.")
                        Call PrintPageText(game, "story", CsrLin, "The townspeople are saved.  And you are today a hero!!!")
                        Call IncreaseScore(game, 100)
                        Color _RGB(0, 0, 0)
                        Call PrintPageText(game, "story", CsrLin, "Score +100")
                        game.isDragonDead = 1
                    End If
                End If
            End If
        End If
    End If
    If playerView$ = "CASTLE" Then
        Color _RGB(255, 255, 0)
        Call PrintPageText(game, "story", CsrLin, "What a magnificent castle!  But no one is home.")
        Call PrintPageText(game, "story", CsrLin, "Perhaps the royal court fled because of BIG CHUNG?")
    End If
    If playerView$ = "ZARA'S STORE" Then
        Color _RGB(255, 0, 255)
        Call PrintPageText(game, "story", CsrLin, "There are a lot of fun things to buy. Of particular note you")
        Call PrintPageText(game, "story", CsrLin, "see a mighty silver sword, fit for slaying a dragon.")
        If (Contains%(game.inventory, "GOLD", ",")) And (Not Contains%(game.inventory, "SWORD", ",")) Then
            Call PrintPageText(game, "story", CsrLin, "You deposit some gold coins into the vending machine...")
            Call IncreaseInventory(game, "SWORD")
            Color _RGB(0, 0, 0)
            Call PrintPageText(game, "story", CsrLin, "Inventory +SWORD")
        Else
            If Contains%(game.inventory, "SWORD", ",") Then
                Call PrintPageText(game, "story", CsrLin, "That mighty sword is in your hand... perhaps you should")
                Call PrintPageText(game, "story", CsrLin, "use it for some heroic deed?")
            Else
                Call PrintPageText(game, "story", CsrLin, "Maybe some day you'll return when you have some money.")
            End If
        End If
    End If
    If playerView$ = "GREYSON'S GAME ROOM" Then
        Color _RGB(0, 0, 255)
        Call PrintPageText(game, "story", CsrLin, "Oh my!  Every game known to mankind can be found for sale in")
        Call PrintPageText(game, "story", CsrLin, "this room.  A particular game catches your eye... UNO.")
        If (Contains%(game.inventory, "GOLD", ",")) And (Not Contains%(game.inventory, "UNO REVERSE", ",")) Then
            Call PrintPageText(game, "story", CsrLin, "You leave some gold coins on the table in exchange for the UNO deck.")
            Call PrintPageText(game, "story", CsrLin, "You look at the cards and discover the legendary... UNO REVERSE!!!")
            Call IncreaseInventory(game, "UNO REVERSE")
            Color _RGB(0, 0, 0)
            Call PrintPageText(game, "story", CsrLin, "Inventory +UNO REVERSE")
        Else
            If Contains%(game.inventory, "UNO REVERSE", ",") Then
                Call PrintPageText(game, "story", CsrLin, "That mighty deck is in your hand... perhaps you should")
                Call PrintPageText(game, "story", CsrLin, "use it for some heroic deed?")
            Else
                Call PrintPageText(game, "story", CsrLin, "Maybe some day you'll return when you have some money.")
            End If
        End If
    End If
    Print
    If (playerView$ = "CASTLE") And (Not Contains%(game.inventory, "GOLD", ",")) Then
        Color _RGB(255, 255, 0)
        Call PrintPageText(game, "story", CsrLin, "Beautiful gold coins are scattered around.  Will you take them?")
        Print
    End If
    aheadX% = game.playerX
    aheadY% = game.playerY
    If directions(game.playerDirection) = "NORTH" Then
        aheadY% = aheadY% - 1
    End If
    If directions(game.playerDirection) = "EAST" Then
        aheadX% = aheadX% + 1
    End If
    If directions(game.playerDirection) = "SOUTH" Then
        aheadY% = aheadY% + 1
    End If
    If directions(game.playerDirection) = "WEST" Then
        aheadX% = aheadX% - 1
    End If
    If (aheadX% = game.doorX) And (aheadY% = game.doorY) Then
        Color _RGB(184, 115, 51)
        Call PrintPageText(game, "story", CsrLin, "Ahead you see an elevator.  Perhaps an exit to this world?")
    Else
        If game.isOver = 0 Then
            If (aheadX% = 0) Or (aheadX% = (game.levelSize + 1)) Or (aheadY% = 0) Or (aheadY% = (game.levelSize + 1)) Then
                Color _RGB(0, 0, 0)
                Call PrintPageText(game, "story", CsrLin, "There is nothing ahead.  You are facing the edge of the world.")
            Else
                Color _RGB(0, 0, 0)
                Call PrintPageText(game, "story", CsrLin, "Ahead you see " + world(aheadX%, aheadY%) + ".")
            End If
        End If
    End If
    Color _RGB(0, 0, 0)
End Sub

Sub MoveAheadAction (game As Book, world() As String, directions() As String)
    aheadX% = game.playerX
    aheadY% = game.playerY
    If directions(game.playerDirection) = "NORTH" Then
        aheadY% = aheadY% - 1
    End If
    If directions(game.playerDirection) = "EAST" Then
        aheadX% = aheadX% + 1
    End If
    If directions(game.playerDirection) = "SOUTH" Then
        aheadY% = aheadY% + 1
    End If
    If directions(game.playerDirection) = "WEST" Then
        aheadX% = aheadX% - 1
    End If
    If (aheadX% = game.doorX) And (aheadY% = game.doorY) Then
        game.playerX = aheadX%
        game.playerY = aheadY%
        game.isOver = 1
        Call PrintPageText(game, "story", CsrLin, "You have exited the world.")
        If Contains%(game.inventory, "GOLD", ",") Then
            Call PrintPageText(game, "story", CsrLin, "You have safely brought your riches back home.")
            Call PrintPageText(game, "story", CsrLin, "Fame and fortune are yours.")
            Call PrintPageText(game, "story", CsrLin, "YOU HAVE WON THE GAME!!!")
            If game.score = 300 Then
                Call PrintPageText(game, "story", CsrLin, "MAXIMUM SCORE!!!")
            End If
        Else
            Call PrintPageText(game, "story", CsrLin, "You did not return home with the gold.")
            Call PrintPageText(game, "story", CsrLin, "This is a horrible fate.")
            Call PrintPageText(game, "story", CsrLin, "YOU HAVE LOST THE GAME.")
        End If
    Else
        If (aheadX% = 0) Or (aheadX% = (game.levelSize + 1)) Or (aheadY% = 0) Or (aheadY% = (game.levelSize + 1)) Then
            Call PrintPageText(game, "story", CsrLin, "There is nothing ahead.  You are facing the edge of the world.")
            Print
            Call PrintPageText(game, "story", CsrLin, "Jumping off the edge of the world is NOT allowed in this game.")
        Else
            ' Advance the player to the next scene
            lastScene$ = world(game.playerX, game.playerY)
            game.playerX = aheadX%
            game.playerY = aheadY%
            scene$ = world(game.playerX, game.playerY)

            ' Update the scene's sound
            If lastScene$ <> scene$ Then
                ' Stop playing the current scene's sound, if any
                If game.storySound <> 0 Then
                    StopSound game.storySound
                End If

                ' Start playing the new scene's sound, if any
                If scene$ = "WILDERNESS" Then
                    game.storySound = PlaySound&("wilderness.mp3", 1, 1)
                End If
                If scene$ = "MAGIC RING OF TOADSTOOLS" Then
                    game.storySound = PlaySound&("magic.mp3", 1, 0)
                End If
                If scene$ = "GIANNI'S DEN" Then
                    game.storySound = PlaySound&("gianni.mp3", 1, 1)
                End If
                If scene$ = "WOODS" Then
                    game.storySound = PlaySound&("woods.mp3", 1, 1)
                End If
                If scene$ = "MOUNT FLUFF" Then
                    game.storySound = PlaySound&("fluff.wav", 1, 0)
                End If
                If scene$ = "CASTLE" Then
                    game.storySound = PlaySound&("castle.mp3", 1, 0)
                End If
                If scene$ = "DRAGON'S DEN" Then
                    If game.isDragonDead = 0 Then
                        game.storySound = PlaySound&("dragon.mp3", 1, 0)
                    Else
                        If game.storySound <> 0 Then
                            StopSound game.storySound
                            game.storySound = 0
                        End If
                    End If
                End If
                If scene$ = "GREYSON'S GAME ROOM" Then
                    game.storySound = PlaySound&("grey.mp3", 1, 0)
                End If
                If scene$ = "ZARA'S STORE" Then
                    game.storySound = PlaySound&("zara.mp3", 1, 1)
                End If
            End If

            ' Add special choices specific to the new scene
            game.storyChoices = game.basicStoryChoices
            If (scene$ = "CASTLE") And (Not Contains%(game.inventory, "GOLD", ",")) Then
                game.storyChoices = game.storyChoices + ",TAKE GOLD"
            Else
                If scene$ = "MOUNT FLUFF" Then
                    game.storyChoices = game.storyChoices + ",PLAY GAME"
                    If Contains%(game.inventory, "RING OF TAMING", ",") Then
                        game.storyChoices = game.storyChoices + ",TAME FLUFF"
                    End If
                Else
                    If scene$ = "MAGIC RING OF TOADSTOOLS" Then
                        game.storyChoices = game.storyChoices + ",SPEAK NAME"
                    Else
                        If scene$ = "WILDERNESS" Then
                            game.storyChoices = game.storyChoices + ",CHASE BUNNIES"
                        End If
                    End If
                End If
            End If

            ' Refresh the scene's description
            Call LookAction(game, world(), directions())
        End If
    End If
End Sub

Sub MoveBackwardsAction (game As Book)
    Call PrintPageText(game, "story", CsrLin, "Please don't try walking backwards.  You might trip.")
End Sub

' Play fluffy game action
'
' Parameters:
' game - Book instance
Sub PlayGameAction (game As Book)
    Call TurnPage(game, 1)
    Call PrintPageText(game, "story", CsrLin, "FLUFFY CAT: " + Chr$(34) + "Answer me this, and a magical name I will give to you." + Chr$(34))
    Call PrintPageText(game, "story", CsrLin + 1, Chr$(34) + "What is blue... and is also the sky?" + Chr$(34))
    Print
    riddle$ = GetInput$(game, "You", 0, 0, 40)
    If (riddle$ = "THE SKY") Or (riddle$ = "THE BLUE SKY") Or (riddle$ = "BLUE SKY") Then
        riddle$ = "SKY"
    End If
    Print
    If riddle$ = "SKY" Then
        fluffImage& = _LoadImage("fluff2.jpg")
        Call DisplayImage(game, "story", fluffImage&)
        Call PrintPageText(game, "story", CsrLin + 1, "FLUFFY CAT: " + Chr$(34) + "Alas you have bested me!  And that was my finest riddle!  Very well then.  A deal is a deal. The magical name you seek is... SHMEBULOCK." + Chr$(34))
        _FreeImage fluffImage&
    Else
        If riddle$ = "EXIT GAME" Then
            Call ExitAction(game)
        Else
            fluffImage& = _LoadImage("fluff3.jpg")
            Call DisplayImage(game, "story", fluffImage&)
            Call PrintPageText(game, "story", CsrLin, "FLUFFY CAT: " + Chr$(34) + "Aha!  It appears that I have bested you!  That answer is INCORRECT.  No one is as clever as I!" + Chr$(34))
            Call PrintPageText(game, "story", CsrLin + 1, "Better luck next time.")
            _FreeImage fluffImage&
        End If
    End If
End Sub

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
    ' TODO - ReplaceSound() should be called, but you can't call a sub/function from another sub/function
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

' Prompt the user to press the any key in order to turn the page
'
' Parameters:
' game - Book instance
' page - (STORY/CONTROL) Which page of the book to use
Sub PressAnyKey (game As Book, page As String)
    ' Display the prompt text
    Color _RGB(0, 139, 139) ' dark cyan
    curRow% = CsrLin
    page = UCase$(page)
    If page = "STORY" Then
        prompt$ = "Press any key to continue"
    Else
        prompt$ = "Press any key to turn the page -->"
    End If
    Call PrintPageText(game, page, game.lastRow - 1, prompt$)
    ' Suspend program execution until the any key is pressed
    ' TODO - Refactor this so the mouse can be used to click the text
    Sleep
    _KeyClear
    ' Reposition the cursor
    Color _RGB(0, 0, 0) ' black
    Locate curRow%, 1
End Sub

' Print text on a designated book page
'
' Parameters:
' game - Book instance
' page - (STORY/CONTROL) Which page of the book to use
' row - Text row
' text - Text to print
Sub PrintPageText (game As Book, page As String, row As Integer, text As String)
    lastColumn = 0

    ' Determine the starting position for the text based on the designated page
    page = UCase$(page)
    If ((page = "STORY") And (game.isRightHanded = 1)) Or ((page = "CONTROL") And (game.isRightHanded = 0)) Then
        column% = game.leftPageStartingColumn
    Else
        If ((page = "STORY") And (game.isRightHanded = 0)) Or ((page = "CONTROL") And (game.isRightHanded = 1)) Then
            If (row = game.firstRow) Or (row = (game.lastRow - 1)) Then
                ' By convention, right-align text on the first row of the right-hand page
                column% = (game.rightPageStartingColumn + game.maxPageLength) - Len(text)
            Else
                column% = game.rightPageStartingColumn
            End If
        Else
            If 1 / 0 Then
                ' Let the programmer know they passed something... sinister
            End If
        End If
    End If

    ' Wrap the text to make it fit the pages.
    startingTextLength = 0
    Do
        Locate row, column%
        game.cursor.lastColumn = column%
        textLength = Len(text)
        If startingTextLength = 0 Then
            startingTextLength = textLength
        End If
        If textLength > game.maxPageLength Then
            ' Word wrap
            firstSpacePosition = _InStrRev(game.maxPageLength, text, " ")
            If firstSpacePosition > 0 Then
                ' Display all characters up to the first space at or to the left of position 66
                Print Left$(text, firstSpacePosition)
                text = LTrim$(Mid$(text, firstSpacePosition + 1, textLength))
            Else
                ' Display as many characters of the text that can fit on the line plus a hyphen
                Print Left$(text, game.maxPageLength - 1) + "-"
                text = LTrim$(Mid$(text, game.maxPageLength, textLength))
            End If
        Else
            ' All text can fit on the current line
            If startingTextLength = textLength Then
                ' Allow the text to begin with one or more spaces if this is the first (non-wrapped) text line
                Print text
            Else
                Print LTrim$(text)
            End If
            text = ""
        End If
        row = row + 1
    Loop Until text = ""

    If page = "STORY" Then
        game.cursor.lastStoryRow = CsrLin
    Else
        game.cursor.lastControlRow = CsrLin
    End If
End Sub

' Refresh the control page
'
' Parameters:
' game - Book instance
' world() - World data
' directions() - Cardinal directions
' mapInfo() - Map data
' playerSymbol() - Player map symbols
Sub RefreshControlPage (game As Book, world() As String, directions() As String, mapInfo() As String, playerSymbol() As String)
    Color _RGB(146, 146, 146) ' darker grey
    firstRow% = game.firstRow + 2
    Call PrintPageText(game, "control", firstRow%, "_" + game.player + String$(62 - Len(game.player), "_"))
    Color _RGB(0, 0, 0) ' black
    Call PrintPageText(game, "control", CsrLin, "Score: " + LTrim$(Str$(game.score)))
    Call PrintPageText(game, "control", CsrLin, "Inventory: " + game.inventory)
    Print
    Call PrintPageText(game, "control", CsrLin, "HP:" + Str$(game.hitPoints))
    Call PrintPageText(game, "control", CsrLin, "MP:" + Str$(game.magicPoints))
    Call PrintPageText(game, "control", CsrLin, "XP:" + Str$(game.experiencePoints))
    Color _RGB(146, 146, 146) ' darker grey
    Call PrintPageText(game, "control", CsrLin, "_______________________________________________________________")
    Color _RGB(0, 0, 0) ' black
    Print

    ' Display the map
    For i% = 1 To 5 Step 1
        mapInfo(i%) = ""
    Next
    If (game.playerX > 0) And (game.playerY > 0) And (game.isOver = 0) Then
        mapInfo(1) = "Level: " + LTrim$(Str$(game.level))
        mapInfo(2) = "Location: " + LTrim$(Str$(game.playerX)) + "," + LTrim$(Str$(game.playerY))
        mapInfo(3) = "Facing: " + directions(game.playerDirection)
    End If
    Call PrintPageText(game, "control", CsrLin, String$((game.levelSize - 1) / 2, " ") + "Map")
    curRow% = CsrLin
    Call PrintPageText(game, "control", CsrLin, String$(game.levelSize + 2, "-")) ' Top border
    For y% = 1 To game.levelSize Step 1
        Call PrintPageText(game, "control", CsrLin, "|" + String$(game.levelSize, " ") + "|" + "   " + mapInfo(y%))
    Next
    Call PrintPageText(game, "control", CsrLin, String$(game.levelSize + 2, "-")) ' Bottom border
    nextRow% = CsrLin
    Locate curRow% + game.doorY, game.doorX + game.cursor.lastColumn
    Print "*"
    If (game.isOver = 0) And (game.playerX > 0) And (game.playerY > 0) Then
        symbol$ = playerSymbol(game.playerDirection)
        Locate curRow% + game.playerY, game.playerX + game.cursor.lastColumn
        Print symbol$
    End If
    Color _RGB(0, 0, 0)
    Locate nextRow%, 1

    ' Display game control choices
    If Contains%(game.inventory, "GAME BOOK", ",") Then
        Color _RGB(0, 0, 0) ' black
        Locate game.cursor.lastControlRow + 1, 1
        game.controlChoicesRow = CsrLin + 1
        gamePrompt$ = "Game Choices: "
        Call PrintPageText(game, "control", CsrLin, gamePrompt$)
        _PrintMode _FillBackground ' Replace background instead of displaying just text over the image
        Color _RGB(0, 139, 139), _RGB(255, 255, 255) ' dark cyan on white
        controlChoices$ = game.controlChoices
        Call PrintPageText(game, "control", CsrLin, controlChoices$)
        game.controlChoicesColumn = game.cursor.lastColumn
        _PrintMode _KeepBackground
        Color _RGB(0, 0, 0)
        Call PrintPageText(game, "control", CsrLin, "[Use arrow keys to turn and move]")
    End If
End Sub

' Refresh the story page by evaluating a choice from the player
'
' Parameters:
' game - Book instance
' choice - Player's selected choice
' world() - World data
' directions() - Cardinal directions
Sub RefreshStoryPage (game As Book, choice As String, world() As String, directions() As String)
    If (Not Contains%(game.storyChoices, choice, ",")) And (Not Contains%(game.controlChoices, choice, ",")) And (Not Contains%(game.secretChoices, choice, ",")) Then
        Call TurnPage(game, 0)
        If choice <> "" Then
            ' Handle invalid choice
            Call DumbAction(game)
        End If
    Else
        ' Reset the screen
        Call TurnPage(game, 1)
        ' Handle valid choices
        If choice = "EXIT GAME" Then
            Call ExitAction(game)
        End If
        If choice = "LOOK" Then
            Call LookAction(game, world(), directions())
        End If
        If choice = "CREDITS" Then
            Call DisplayCreditsPage(game)
            choice = "LOOK"
            Call TurnPage(game, 1)
            Call LookAction(game, world(), directions())
        End If
        If choice = "HIGH SCORES" Then
            Call DisplayHighScoresPage(game)
            choice = "LOOK"
            Call TurnPage(game, 1)
            Call LookAction(game, world(), directions())
        End If
        If choice = "FLIP BOOK" Then
            If game.isRightHanded = 0 Then
                game.isRightHanded = 1
            Else
                game.isRightHanded = 0
            End If
            Call TurnPage(game, 0)
            Call LookAction(game, world(), directions())
        End If
        If choice = "GO RIGHT-HANDED" Then
            game.isRightHanded = 1
            game.controlChoices = "CREDITS,GO LEFT-HANDED,HIGH SCORES,EXIT GAME"
            Call TurnPage(game, 0)
            Call LookAction(game, world(), directions())
        End If
        If choice = "LISTEN" Then
            Call ListenAction(game, world())
        End If
        If choice = "MOVE AHEAD" Then
            Call MoveAheadAction(game, world(), directions())
        End If
        If choice = "MOVE BACKWARDS" Then
            Call MoveBackwardsAction(game)
        End If
        If choice = "TURN LEFT" Then
            Call TurnLeftAction(game, world(), directions())
        End If
        If choice = "TURN RIGHT" Then
            Call TurnRightAction(game, world(), directions())
        End If
        If (choice = "PLAY GAME") Then
            Call PlayGameAction(game)
            ' Refresh the scene's description
            Call PressAnyKey(game, "control")
            choice = "LOOK"
            Call TurnPage(game, 1)
            Call LookAction(game, world(), directions())
        End If
        If (choice = "SPEAK NAME") Then
            Call SpeakNameAction(game)
            Call PressAnyKey(game, "control")
            choice = "LOOK"
            Call TurnPage(game, 1)
            Call LookAction(game, world(), directions())
        End If
        If (choice = "CHASE BUNNIES") Then
            Call ChaseBunniesAction(game)
        End If
        If (choice = "TAME FLUFF") Then
            Call TameFluffAction(game)
            Call PressAnyKey(game, "control")
            choice = "LOOK"
            Call TurnPage(game, 1)
            Call LookAction(game, world(), directions())
        End If
        If (choice = "TAKE GOLD") Then
            Call TakeGoldAction(game)
        End If
        If (choice = "ALL THE THINGS") Then
            Call AllTheThingsAction(game)
        End If
    End If
End Sub

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

Sub SpeakNameAction (game As Book)
    Call TurnPage(game, 1)
    Color _RGB(184, 115, 51)
    Print
    nameGuess$ = GetInput$(game, "You", 0, 0, 10)
    Print
    If (nameGuess$ = "SHMEBULOCK") Then
        Call PrintPageText(game, "story", CsrLin, "           ,")
        Call PrintPageText(game, "story", CsrLin, "          / \")
        Call PrintPageText(game, "story", CsrLin, "         /   \")
        Call PrintPageText(game, "story", CsrLin, "        /     \")
        Call PrintPageText(game, "story", CsrLin, "       /_______\")
        Call PrintPageText(game, "story", CsrLin, "       // . . \\")
        Call PrintPageText(game, "story", CsrLin, "      (/(__7__)\)")
        Call PrintPageText(game, "story", CsrLin, "      |'-' = `-'|")
        Call PrintPageText(game, "story", CsrLin, "      |         |")
        Call PrintPageText(game, "story", CsrLin, "      /\       /\")
        Call PrintPageText(game, "story", CsrLin, "     /  '.   .'  \")
        Call PrintPageText(game, "story", CsrLin, "    / /|  `v`  |\ \")
        Call PrintPageText(game, "story", CsrLin, "    \ \|===[]==|/ /")
        Call PrintPageText(game, "story", CsrLin, "     '-|_______|-'")
        Call PrintPageText(game, "story", CsrLin, "        |__|__|")
        Call PrintPageText(game, "story", CsrLin, "        |--|--|")
        Call PrintPageText(game, "story", CsrLin, "       (__)`(__)")
        Print
        Call PrintPageText(game, "story", CsrLin, "Magic Gnome: Shmebulock!  Shmebulock... Shmebulock.")
        Call PrintPageText(game, "story", CsrLin, "Shmebulock?  Shmebulock, Shmebulock.  Shme... bulock!")
        Print
        If Not Contains%(game.inventory, "RING OF TAMING", ",") Then
            Call PrintPageText(game, "story", CsrLin, "Inventory +RING OF TAMING")
            Call PrintPageText(game, "story", CsrLin, "(Does not work on large creatures.)")
        Else
            Call PrintPageText(game, "story", CsrLin, "You look down at your ring and it glows with power.")
        End If
        Call IncreaseInventory(game, "RING OF TAMING")
    Else
        If nameGuess$ = "EXIT GAME" Then
            Call ExitAction(game)
        Else
            If (nameGuess$ = "MAGNIFICO") Or (nameGuess$ = "DRACO") Then
                Call PrintPageText(game, "story", CsrLin, "You wait... and wait some more.  But... nothing happens!")
                Call PrintPageText(game, "story", CsrLin, "Perhaps you spoke the wrong name?")
                Print
                Call PrintPageText(game, "story", CsrLin, "Good guess though!")
            Else
                Call PrintPageText(game, "story", CsrLin, "You wait... and wait some more.  But... nothing happens!")
                Call PrintPageText(game, "story", CsrLin, "Perhaps you spoke the wrong name?")
                Print
                Call PrintPageText(game, "story", CsrLin, "Better luck next time.")
            End If
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

' Prompt the player for a story choice
'
' Parameters:
' game - Book instance
' prompt - Prompt text
' choices - Comma-delimited prompt choices
' enableArrowKeys - Enable use of the keyboard arrow keys? (1/0)
'                   Up - "MOVE AHEAD"
'                   Down - "MOVE BACKWARDS"
'                   Left - "TURN LEFT"
'                   Right - "TURN RIGHT"
' enableMouse - Enable use of the mouse? (1/0)
' inputLength - Max number of characters allowed for user input
'
' Returns:
' User input
Function StoryPrompt$ (game As Book, prompt As String, choices As String, enableArrowKeys As Integer, enableMouse As Integer, inputLength As Integer)
    prompt = prompt + ": "
    game.storyChoices = choices
    startingRow% = CsrLin
    game.storyChoicesRow = startingRow% + 1
    Call PrintPageText(game, "story", startingRow%, prompt)
    _PrintMode _FillBackground ' Replace background instead of displaying just text over the image
    Color _RGB(0, 139, 139), _RGB(255, 255, 255) ' dark cyan on white
    pageChoicesText$ = game.storyChoices ' TODO - This is dumb.  All variables passed to a function are passed by reference.  PrintPageText() will empty out the game.storyChoices if you pass them directly.
    Call PrintPageText(game, "story", CsrLin, pageChoicesText$)
    game.storyChoicesColumn = game.cursor.lastColumn
    _PrintMode _KeepBackground
    Print
    StoryPrompt$ = GetInput$(game, "Enter Choice", enableArrowKeys, enableMouse, inputLength)
End Function

Sub TakeGoldAction (game As Book)
    game.storyChoices = game.basicStoryChoices
    If Not Contains%(game.inventory, "GOLD", ",") Then
        Call IncreaseScore(game, 100)
        Print
        Call PrintPageText(game, "story", CsrLin, "All the gold now belongs to you!")
        Call PrintPageText(game, "story", CsrLin, "Score +100")
        Call PrintPageText(game, "story", CsrLin, "Inventory +GOLD")
        Print
        Call IncreaseInventory(game, "GOLD")
    End If
End Sub

Sub TameFluffAction (game As Book)
    Call TurnPage(game, 1)
    Call PrintPageText(game, "story", CsrLin, "                ____")
    Call PrintPageText(game, "story", CsrLin, "                \ _ `\ ")
    Call PrintPageText(game, "story", CsrLin, "                 | \  `\._")
    Call PrintPageText(game, "story", CsrLin, "                 |  |  _/ `-.._")
    Call PrintPageText(game, "story", CsrLin, "                 |  /-'  // /.'`-. .--.__")
    Call PrintPageText(game, "story", CsrLin, "                 /-'    || // //  |    __\")
    Call PrintPageText(game, "story", CsrLin, "               ./   .` |\///_//   \  /'   |")
    Call PrintPageText(game, "story", CsrLin, "             .'.-.__.` \ |/'-' .'  \|    /")
    Call PrintPageText(game, "story", CsrLin, "            / ( ____`.\ |/ .' '.'   |\  /")
    Call PrintPageText(game, "story", CsrLin, "           /  -//   \     /- _  '     `'|")
    Call PrintPageText(game, "story", CsrLin, "           |  ||o    ;       __`--      |")
    Call PrintPageText(game, "story", CsrLin, "           |   \\   /      //  `.  \    |")
    Call PrintPageText(game, "story", CsrLin, "           \    `---'     |/o    \_ )   \")
    Call PrintPageText(game, "story", CsrLin, "         _ _\_    /       |      /       |")
    Call PrintPageText(game, "story", CsrLin, "       _-_`-__-_.-'|__    \`-..-'       /")
    Call PrintPageText(game, "story", CsrLin, "      '  .--_--_-.. \_\/_              /")
    Call PrintPageText(game, "story", CsrLin, "        ' /    \... / .. \_-___       / \")
    Call PrintPageText(game, "story", CsrLin, "         /      `-._| ..-._--___     /   \")
    Call PrintPageText(game, "story", CsrLin, "        /    .---.|  `-.__/`--.__---'     |")
    Call PrintPageText(game, "story", CsrLin, "       /_.--/ . . \__/   _   `--._-.      |")
    Call PrintPageText(game, "story", CsrLin, "    .-'    | || | |   .-' `-.     \ `\    |")
    Call PrintPageText(game, "story", CsrLin, "  .'       `-\/\|-'  |  / /  \     `\ \   |")
    Call PrintPageText(game, "story", CsrLin, " /                    \/ | .  |           |")
    Call PrintPageText(game, "story", CsrLin, "/                      \_/_/ / \          |")
    Call PrintPageText(game, "story", CsrLin, "|  magnifico               \/   \         |")
End Sub

Sub TurnLeftAction (game As Book, world() As String, directions() As String)
    game.playerDirection = game.playerDirection - 1
    If game.playerDirection = 0 Then
        game.playerDirection = 4
    End If
    Call LookAction(game, world(), directions())
End Sub

' Wipe the current screen and redisplay the book image
'
' Parameters:
' game - Book instance
' playPageSound - Play the page turn sound? (1/0)
Sub TurnPage (game As Book, playPageSound As Integer)
    If playPageSound Then
        ' Play a sound for turning the page
        Call ReplaySound(game.pageTurnSound, 1, 0)
    End If

    Cls , _RGB(0, 0, 0) ' Clear screen with black as the background color
    _PutImage , game.image ' Display the main book image
    _PrintMode _KeepBackground ' Preserve the image background when printing text
    Color _RGB(0, 0, 0) ' black

    ' Print the page headers (the book image allows for text starting on row 3)
    If game.chapter <> "" Then
        ' TODO - Need to right-align the text on the right-hand page
        Call PrintPageText(game, "story", (game.firstRow), UCase$(game.chapter))
        Call PrintPageText(game, "control", (game.firstRow), UCase$(game.title))
    End If

    ' All non-header text should begin on row 5 to accommodate the book image
    Locate game.firstRow + 2, 1
End Sub

Sub TurnRightAction (game As Book, world() As String, directions() As String)
    game.playerDirection = game.playerDirection + 1
    If game.playerDirection = 5 Then
        game.playerDirection = 1
    End If
    Call LookAction(game, world(), directions())
End Sub

