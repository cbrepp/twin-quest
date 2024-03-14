' Resources:
' book.png - Empty book by Darkmoon_Art (https://pixabay.com/illustrations/reserve-pages-empty-book-open-book-3057904/)
' castle.mp3 - Royal vibes (harp guitar and tuba) (https://freesound.org/people/kbrecordzz/sounds/595865/)
' dragon.mp3 - The Roar of a 5-Headed Dragon (https://freesound.org/people/bevibeldesign/sounds/366095/)
' epic.mp3 - Epic Trailer Background Music (https://freesound.org/people/Migfus20/sounds/560454/)
' fluff.wav - Spanish Lick I, Acoustic- AB split stereo pair (Oktava).wav (https://freesound.org/people/debudding/sounds/44366/)
' gianni.mp3 - bonfire flames sizzling (https://freesound.org/people/florianreichelt/sounds/563764/)
' grey.mp3 - 8-Bit Coin Or Power Up FX For Retro Video Games (https://freesound.org/people/Cloud-10/sounds/647977/)
' magic.mp3 - Magic.mp3 (https://freesound.org/people/Bastianhallo/sounds/434050/)
' turn-page.mp3 - page turn (https://freesound.org/people/partheeban/sounds/457767/)
' wayne-chung.jpg - Image of Wayne Chung wondering what's going on
' wayne-chung.mp3 - Wang Chung "Everybody Have Fun Tonight" snippet
' wilderness.mp3 - birds_210513_0088.mp3 (https://freesound.org/people/titi2/sounds/571247/)
' woods.mp3 - forestsurroundings.mp3 (https://freesound.org/people/Luftrum/sounds/48411/)
' zara.mp3 - Cash Register (https://freesound.org/people/kiddpark/sounds/201159/)

' Declare shared variables
' TODO - Get rid of ALL shared variables
Dim Shared game, gameChoices$, gameChoicesCol%, gameChoicesRow%, sceneChoices$, sceneChoicesCol%, sceneChoicesRow%

Type Book
    chapter As String
    firstRow As Integer
    image As Long
    isOver As Integer
    isRightHanded As Integer
    lastRow As Integer
    pageTurnSound As Long
    title As String
    version As String
End Type

' Initialize the game
Dim game As Book
game.title = "Twin Quest"
game.version = "0.1.0"
game.chapter = ""
game.isOver = 0
game.isRightHanded = 1
game.image = _LoadImage("book.png", 32)
game.firstRow = 3 ' book.png allows for row 3 as the first row for text
game.lastRow = 46 ' book.png allows for row 46 as the first row for text

' Configure application window
_Title game.title$ + " " + game.version ' Set the application window's title

' Display "splash screen"
' TODO - Make this a proper subroutine
GoSub WayneChungScreen

' Display pre-chapter pages with epic music
game.pageTurnSound = PlaySound&("turn-page.mp3", 1, 0)
epicMusic& = PlaySound&("epic.mp3", 1, 1)
Call DisplayTitlePage(game)
Call DisplayHighScoresPage(game)
GoSub Init
StopSound epicMusic&

GoSub InitLevel1
choice$ = "MOVE AHEAD"

' Main game loop
Do
    GoSub RefreshScreen
    If game.isOver Then
        _Continue
    End If
    Color _RGB(0, 0, 0)
    Print
    sceneChoicesRow% = CsrLin
    scenePrompt$ = "Scene Choices: "
    Call PrintText(game, "story", CsrLin, scenePrompt$)
    sceneChoicesCol% = Len(scenePrompt$) + 1
    Locate sceneChoicesRow%, sceneChoicesCol%
    Color _RGB(0, 139, 139)
    Call PrintText(game, "story", CsrLin, sceneChoices$)
    Color _RGB(0, 0, 0)
    gameChoicesRow% = CsrLin
    gamePrompt$ = "Game Choices: "
    Call PrintText(game, "story", CsrLin, gamePrompt$)
    gameChoicesCol% = Len(gamePrompt$) + 1
    Locate gameChoicesRow%, gameChoicesCol%
    Color _RGB(0, 139, 139)
    Call PrintText(game, "story", CsrLin, gameChoices$)
    Color _RGB(0, 0, 0)
    Call PrintText(game, "story", CsrLin, "[Use arrow keys to turn and move]")
    Print
    choice$ = GetInput$("Enter Choice", 1, 1, 40)
Loop While game.isOver = 0

' Check if the player has earned a spot on the HIGH SCORES list
If score% > 0 Then
    GoSub ChallengeHighScores
End If

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
        If (rank% = 0) And (score% > fileLineScore%) Then
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
    Call PrintText(game, "story", CsrLin, "You have a new high score... rank " + LTrim$(Str$(rank%)) + "!")
    highScoreInitials$ = GetInput$("Enter your initials", 0, 0, 3)
    highScores(rank%) = LTrim$(Str$(score%)) + "   " + highScoreInitials$ + "   " + Date$
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

Init:
Dim textLines(30) As String
score% = 0
exitGameAction$ = "EXIT GAME"
Dim directions(4) As String
directions(1) = "NORTH"
directions(2) = "EAST"
directions(3) = "SOUTH"
directions(4) = "WEST"
gameChoices$ = "CREDITS,HIGH SCORES," + exitGameAction$
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
sceneChoices$ = "GREYSON,ZARA"
Do
    character$ = ""
    Call TurnPage(game)
    Print
    sceneChoicesRow% = CsrLin
    prompt$ = "Character Choices: "
    Call PrintText(game, "story", CsrLin, prompt$)
    Color _RGB(0, 139, 139)
    sceneChoicesCol% = Len(prompt$) + 1
    Locate sceneChoicesRow%, sceneChoicesCol%
    Call PrintText(game, "story", CsrLin, sceneChoices$)
    Print
    character$ = GetInput$("Enter Choice", 0, 1, 7)
Loop While Not Contains%(sceneChoices$ + ",GREY," + exitGameAction$, character$, ",")
Return

' Display the splash screen
WayneChungScreen:
' Play Wayne Chung's theme song
wayneChungMusic& = PlaySound&("wayne-chung.mp3", 1, 0)
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
StopSound wayneChungMusic&

Screen _NewImage(1280, 793, 32)
Cls , _RGB(0, 0, 0)
_PutImage , game.image
'
'Cls
'book& = _LoadImage("book.png", 32) 'load the image file to be drawn
'Screen book&

_FreeImage wayneChungImage& ' Free up memory used by the image
Return

RefreshScreen:
Call TurnPage(game)
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
    If choice$ = "HIGH SCORES" Then
        Call DisplayHighScoresPage(game)
    End If '
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
        ' Refresh the scene's description
        Call PressAnyKey(game)
        choice$ = "LOOK"
        Call TurnPage(game)
        GoSub LookAction
    End If
    If (choice$ = "SPEAK NAME") Then
        GoSub SpeakNameAction
        Call PressAnyKey(game)
        choice$ = "LOOK"
        Call TurnPage(game)
        GoSub LookAction
    End If
    If (choice$ = "CHASE BUNNIES") Then
        GoSub ChaseBunniesAction
    End If
    If (choice$ = "TAME FLUFF") Then
        GoSub TameFluffAction
        Call PressAnyKey(game)
        choice$ = "LOOK"
        Call TurnPage(game)
        GoSub LookAction
    End If
    If (choice$ = "TAKE GOLD") Then
        GoSub TakeGoldAction
    End If
    If (choice$ = "ALL THE THINGS") Then
        GoSub AllTheThingsAction
    End If
End If

Color _RGB(169, 169, 169)
Call PrintText(game, "story", CsrLin, "_______________________________________________________________")
Color _RGB(192, 192, 192)
curRow% = CsrLin
Call PrintText(game, "story", CsrLin, "Inventory: " + inventory$)
Locate curRow%, 54
Call PrintText(game, "story", CsrLin, "Score:" + Str$(score%))
Print
' Display the map
For i = 1 To 5 Step 1
    mapInfo(i) = ""
Next
If (playerX% > 0) And (playerY% > 0) And (game.isOver = 0) Then
    mapInfo(1) = "Level: " + LTrim$(Str$(level%))
    mapInfo(2) = "Location: " + LTrim$(Str$(playerX%)) + "," + LTrim$(Str$(playerY%))
    mapInfo(3) = "Facing: " + directions(playerDirection%)
End If
Call PrintText(game, "story", CsrLin, String$((levelSize% - 1) / 2, " ") + "Map")
curRow% = CsrLin
Call PrintText(game, "story", CsrLin, String$(levelSize% + 2, "-")) ' Top border
For y = 1 To levelSize% Step 1
    Call PrintText(game, "story", CsrLin, "|" + String$(levelSize%, " ") + "|" + "   " + mapInfo(y))
Next
Call PrintText(game, "story", CsrLin, String$(levelSize% + 2, "-")) ' Bottom border
nextRow% = CsrLin
Locate curRow% + doorY%, 1 + doorX%
Call PrintText(game, "story", CsrLin, "*")
If game.isOver = 0 Then
    symbol$ = playerSymbol(playerDirection%)
    Locate curRow% + playerY%, 1 + playerX%
    Call PrintText(game, "story", CsrLin, symbol$)
End If
Color _RGB(0, 0, 0)
Locate nextRow%, 1
Return

ExitAction:
game.isOver = 1
Print
If Contains%(inventory$, "GOLD", ",") Then
    Call PrintText(game, "story", CsrLin, "But you were doing so well!  The magic door is out there.")
    Call PrintText(game, "story", CsrLin, "You found the gold but didn't bring it home.")
End If
Call PrintText(game, "story", CsrLin, "Your quest has ended... no fame.  And certainly no fortune.")
Call PrintText(game, "story", CsrLin, "REMEMBER: Quitters never win.")
Print
Return

CreditsAction:
Color _RGB(0, 0, 0)
Print
Call PrintText(game, "story", CsrLin, "CREDITS")
Print
Call PrintText(game, "story", CsrLin, "Business Manager: Wayne Chung")
Call PrintText(game, "story", CsrLin, "Executive Producer: Wayne Chung")
Call PrintText(game, "story", CsrLin, "Power of Attorney: Wayne Chung")
Call PrintText(game, "story", CsrLin, "Development: Mylee and Mr. Chris")
Call PrintText(game, "story", CsrLin, "Creative Design: Zara and Greyson")
Return

ListenAction:
Color _RGB(0, 0, 0)
scene$ = world(playerX%, playerY%)
Print
Call PrintText(game, "story", CsrLin, "You are in " + playerView$ + ".")
' Decribe what the player is hearing, and restart audio if not currently playing
If sceneSound& = 0 Then
    Color _RGB(0, 0, 0)
    Call PrintText(game, "story", CsrLin, "You hear nothing.")
Else
    If _SndPlaying(sceneSound&) = 0 Then
        ReplaySound sceneSound&, 1, 0
    End If
    If scene$ = "WILDERNESS" Then
        Color _RGB(0, 255, 0)
        Call PrintText(game, "story", CsrLin, "You hear birds singing and perhaps some insects.")
        Call PrintText(game, "story", CsrLin, "There is also a slight breeze.  These are the typical")
        Call PrintText(game, "story", CsrLin, "sounds of nature.")
    End If
    If scene$ = "MAGIC RING OF TOADSTOOLS" Then
        Color _RGB(184, 115, 51)
        Call PrintText(game, "story", CsrLin, "You hear... magic, perhaps?  You attempt to focus")
        Call PrintText(game, "story", CsrLin, "on the sound but it disappears from your mind.")
    End If
    If scene$ = "GIANNI'S DEN" Then
        Color _RGB(169, 169, 169)
        Call PrintText(game, "story", CsrLin, "You hear the crackle of a campfire in a vacuous")
        Call PrintText(game, "story", CsrLin, "space.  The sounds of the outside world are muted.")
        Call PrintText(game, "story", CsrLin, "This is a peaceful place.")
    End If
    If scene$ = "WOODS" Then
        Color _RGB(92, 64, 51)
        Call PrintText(game, "story", CsrLin, "You hear the typical sounds of the woods at night.")
        Call PrintText(game, "story", CsrLin, "There are birds.  Definitely crows.  Maybe a")
        Call PrintText(game, "story", CsrLin, "woodpecker.  And... the hooting of an owl?")
    End If
    If scene$ = "MOUNT FLUFF" Then
        Color _RGB(0, 0, 0)
        Call PrintText(game, "story", CsrLin, "Oh my!  What magnificent guitar strumming!  The")
        Call PrintText(game, "story", CsrLin, "styling is firm and decisive and yet also...")
        Call PrintText(game, "story", CsrLin, "romantic.")
    End If
    If scene$ = "CASTLE" Then
        Color _RGB(255, 255, 0)
        Call PrintText(game, "story", CsrLin, "You hear royal music... A harp!  A guitar!  And also")
        Call PrintText(game, "story", CsrLin, "the deep sound of a tuba.  How splendid!  The music")
        Call PrintText(game, "story", CsrLin, "carries loudly from the castle courtyard.  However,")
        Call PrintText(game, "story", CsrLin, "you hear nothing from within the castle.")
    End If
    If scene$ = "DRAGON'S DEN" Then
        Color _RGB(255, 0, 0)
        If dragonDead% = 0 Then
            Call PrintText(game, "story", CsrLin, "You hear the fearsome roar of a dragon!")
            Call PrintText(game, "story", CsrLin, "There is no time to stop and listen to it!")
        End If
    End If
    If scene$ = "GREYSON'S GAME ROOM" Then
        Color _RGB(0, 0, 255)
        Call PrintText(game, "story", CsrLin, "You hear the typical sounds of an arcade.")
        Call PrintText(game, "story", CsrLin, "Sounds like someone just got a power up?")
    End If
    If scene$ = "ZARA'S STORE" Then
        Color _RGB(255, 0, 255)
        Call PrintText(game, "story", CsrLin, "You hear the hustling and bustling sounds of")
        Call PrintText(game, "story", CsrLin, "a successful store.  Sounds like someone just")
        Call PrintText(game, "story", CsrLin, "made a sale?")
    End If
End If
Color _RGB(0, 0, 0)
Return

LookAction:
playerView$ = world(playerX%, playerY%)
Print
Call PrintText(game, "story", CsrLin, "You are in " + playerView$ + ".")
If playerView$ = "WILDERNESS" Then
    Color _RGB(0, 255, 0)
    Call PrintText(game, "story", CsrLin, "You see nothing but tall grass and cute bunnies.")
    Call PrintText(game, "story", CsrLin, "The sun is shining brightly.")
End If
If playerView$ = "WOODS" Then
    Color _RGB(192, 192, 192)
    Randomize Timer
    nightOwlChance% = Int(Rnd * 3) + 1
    If nightOwlChance% = 3 Then
        Call PrintText(game, "story", CsrLin, "The sky is dark and you hear the sound of flapping wings.")
        Call PrintText(game, "story", CsrLin, "By the time you look up it's too late.  Night Owl has claimed")
        Call PrintText(game, "story", CsrLin, "you as his prey!  What an unfortunate way to end your journey.")
        Print
        Color _RGB(0, 0, 0)
        Call PrintText(game, "story", CsrLin, "You have died.")
        If score% > 0 Then
            Call PrintText(game, "story", CsrLin, "Score -" + LTrim$(Str$(score%)))
            score% = 0
        End If
        game.isOver = 1
    Else
        If nightOwlChance% = 2 Then
            Call PrintText(game, "story", CsrLin, "The sky is dark and you hear the sound of flapping wings.")
            Call PrintText(game, "story", CsrLin, "By the time you look up there's already a scream close by")
            Call PrintText(game, "story", CsrLin, "as Night Owl has claimed a poor creature as his prey.  You")
            Call PrintText(game, "story", CsrLin, "have escaped death.  But... for how long?")
        Else
            Call PrintText(game, "story", CsrLin, "The sky is dark and Night Owl is hiding somewhere.  You must")
            Call PrintText(game, "story", CsrLin, "take care to tread lightly lest a noise alert Night Owl to")
            Call PrintText(game, "story", CsrLin, "your whereabouts.  Be very, very quiet.")
        End If
    End If
End If
If playerView$ = "MAGIC RING OF TOADSTOOLS" Then
    Color _RGB(184, 115, 51)
    Call PrintText(game, "story", CsrLin, "A magical place of faeries and giant mushrooms!")
    Call PrintText(game, "story", CsrLin, "A simple wooden sign sits in the center of this place.  On")
    Call PrintText(game, "story", CsrLin, "this sign reads a simple message...")
    Print
    Call PrintText(game, "story", CsrLin, "'Speak the name of the spirit that dwells in this place and")
    Call PrintText(game, "story", CsrLin, "be gifted with a magical item.'")
End If
If playerView$ = "MOUNT FLUFF" Then
    Color _RGB(0, 0, 0)
    Call PrintText(game, "story", CsrLin, "You come upon the base of a mountain and see a gallant white")
    Call PrintText(game, "story", CsrLin, "tom cat wearing boots and playing a spanish guitar.  His")
    Call PrintText(game, "story", CsrLin, "melody hypnotizes you.  And my... he is so fluffy!")
    Call PrintText(game, "story", CsrLin, "You are astonished to learn that this cat can speak.  He")
    Call PrintText(game, "story", CsrLin, "enjoys challenging others to a guessing game.  If you solve")
    Call PrintText(game, "story", CsrLin, "his riddle, he might just give you a prize.")
End If
If playerView$ = "GIANNI'S DEN" Then
    Color _RGB(169, 169, 169)
    Call PrintText(game, "story", CsrLin, "You find yourself in a dark cave.  A fire burns deep inside.")
    Call PrintText(game, "story", CsrLin, "You explore the cave and find yourself face to face with an")
    Call PrintText(game, "story", CsrLin, "adorable black cat curled up on a Pittsburgh Steelers blanket.")
    Call PrintText(game, "story", CsrLin, "He's so cuuuuuuute!")
    Print
    If Contains%(inventory$, "RING OF TAMING", ",") Then
        If catTamed% = 0 Then
            catTamed% = 1
            Call PrintText(game, "story", CsrLin, "You use your ring of taming on him and he jumps into")
            Call PrintText(game, "story", CsrLin, "your waiting arms.  You pet him for hours and hours.")
            Color _RGB(0, 0, 0)
            Call PrintText(game, "story", CsrLin, "Score +100")
            score% = score% + 100
        Else
            Call PrintText(game, "story", CsrLin, "He meows with delight when he sees you and jumps into")
            Call PrintText(game, "story", CsrLin, "your waiting arms.  Oh what a wonderful cat he is!")
        End If
    Else
        Call PrintText(game, "story", CsrLin, "You attempt to pet him but he runs away.  If only you could")
        Call PrintText(game, "story", CsrLin, "tame him.  But such a feat would require strong magic...")
    End If
End If
If playerView$ = "DRAGON'S DEN" Then
    Color _RGB(255, 0, 0)
    If dragonDead% = 0 Then
        Call PrintText(game, "story", CsrLin, "You find yourself in a dark cave.  A fire burns deep inside.")
        Call PrintText(game, "story", CsrLin, "You explore the cave and find yourself face to face with a")
        Call PrintText(game, "story", CsrLin, "ferocious dragon!")
    Else
        If sceneSound& <> 0 Then
            StopSound sceneSound&
            sceneSound& = 0
        End If
        Call PrintText(game, "story", CsrLin, "The dragon once lived here until you, an amazing hero, slew it!")
        Call PrintText(game, "story", CsrLin, "Paintings depicting your heroic act now cover the wall, a tribute")
        Call PrintText(game, "story", CsrLin, "from the townspeople you saved!")
    End If
    If (Contains%(inventory$, "GOLD", ",")) And (Not Contains%(inventory$, "SWORD", ",")) And (Not Contains%(inventory$, "UNO REVERSE", ",")) Then
        Call PrintText(game, "story", CsrLin, "The greedy dragon sees your gold and blasts you with")
        Call PrintText(game, "story", CsrLin, "its burning fire.  With no defense, you are burned to death.")
        Call PrintText(game, "story", CsrLin, "Alas, this is the end of your quest.")
        Print
        Color _RGB(0, 0, 0)
        Call PrintText(game, "story", CsrLin, "You have died.")
        Call PrintText(game, "story", CsrLin, "Score -" + LTrim$(Str$(score%)))
        score% = 0
        game.isOver = 1
    Else
        If Not Contains%(inventory$, "GOLD", ",") Then
            Call PrintText(game, "story", CsrLin, "With nothing heavy to carry you are able to run away")
            Call PrintText(game, "story", CsrLin, "before the dragon can end your quest.")
        Else
            StopSound sceneSound&
            sceneSound& = 0
            If (Contains%(inventory$, "SWORD", ",")) And (dragonDead% = 0) Then
                Call PrintText(game, "story", CsrLin, "With quick reflexes you use your mighty sword to slay the dragon.")
                Call PrintText(game, "story", CsrLin, "The townspeople are saved.  And you are today a hero!!!")
                score% = score% + 100
                Color _RGB(0, 0, 0)
                Call PrintText(game, "story", CsrLin, "Score +100")
                dragonDead% = 1
            Else
                If (Contains%(inventory$, "UNO REVERSE", ",")) And (dragonDead% = 0) Then
                    Call PrintText(game, "story", CsrLin, "With quick reflexes you use your UNO REVERSE card to send the dragon's")
                    Call PrintText(game, "story", CsrLin, "flames back at it.  With each fiery burst, the dragon destroys itself.")
                    Call PrintText(game, "story", CsrLin, "The townspeople are saved.  And you are today a hero!!!")
                    score% = score% + 100
                    Color _RGB(0, 0, 0)
                    Call PrintText(game, "story", CsrLin, "Score +100")
                    dragonDead% = 1
                End If
            End If
        End If
    End If
End If
If playerView$ = "CASTLE" Then
    Color _RGB(255, 255, 0)
    Call PrintText(game, "story", CsrLin, "What a magnificent castle!  But no one is home.")
    Call PrintText(game, "story", CsrLin, "Perhaps the royal court fled because of BIG CHUNG?")
End If
If playerView$ = "ZARA'S STORE" Then
    Color _RGB(255, 0, 255)
    Call PrintText(game, "story", CsrLin, "There are a lot of fun things to buy. Of particular note you")
    Call PrintText(game, "story", CsrLin, "see a mighty silver sword, fit for slaying a dragon.")
    If (Contains%(inventory$, "GOLD", ",")) And (Not Contains%(inventory$, "SWORD", ",")) Then
        Call PrintText(game, "story", CsrLin, "You deposit some gold coins into the vending machine...")
        inventory$ = inventory$ + ",SWORD"
        Color _RGB(0, 0, 0)
        Call PrintText(game, "story", CsrLin, "Inventory +SWORD")
    Else
        If Contains%(inventory$, "SWORD", ",") Then
            Call PrintText(game, "story", CsrLin, "That mighty sword is in your hand... perhaps you should")
            Call PrintText(game, "story", CsrLin, "use it for some heroic deed?")
        Else
            Call PrintText(game, "story", CsrLin, "Maybe some day you'll return when you have some money.")
        End If
    End If
End If
If playerView$ = "GREYSON'S GAME ROOM" Then
    Color _RGB(0, 0, 255)
    Call PrintText(game, "story", CsrLin, "Oh my!  Every game known to mankind can be found for sale in")
    Call PrintText(game, "story", CsrLin, "this room.  A particular game catches your eye... UNO.")
    If (Contains%(inventory$, "GOLD", ",")) And (Not Contains%(inventory$, "UNO REVERSE", ",")) Then
        Call PrintText(game, "story", CsrLin, "You leave some gold coins on the table in exchange for the UNO deck.")
        Call PrintText(game, "story", CsrLin, "You look at the cards and discover the legendary... UNO REVERSE!!!")
        inventory$ = inventory$ + ",UNO REVERSE"
        Color _RGB(0, 0, 0)
        Call PrintText(game, "story", CsrLin, "Inventory +UNO REVERSE")
    Else
        If Contains%(inventory$, "UNO REVERSE", ",") Then
            Call PrintText(game, "story", CsrLin, "That mighty deck is in your hand... perhaps you should")
            Call PrintText(game, "story", CsrLin, "use it for some heroic deed?")
        Else
            Call PrintText(game, "story", CsrLin, "Maybe some day you'll return when you have some money.")
        End If
    End If
End If
Print
If (playerView$ = "CASTLE") And (Not Contains%(inventory$, "GOLD", ",")) Then
    Color _RGB(255, 255, 0)
    Call PrintText(game, "story", CsrLin, "Beautiful gold coins are scattered around.  Will you take them?")
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
    Color _RGB(184, 115, 51)
    Call PrintText(game, "story", CsrLin, "Ahead you see a magic door.  Perhaps an exit to this world?")
Else
    If game.isOver = 0 Then
        If (aheadX% = 0) Or (aheadX% = (levelSize% + 1)) Or (aheadY% = 0) Or (aheadY% = (levelSize% + 1)) Then
            Color _RGB(0, 0, 0)
            Call PrintText(game, "story", CsrLin, "There is nothing ahead.  You are facing the edge of the world.")
        Else
            Color _RGB(0, 0, 0)
            Call PrintText(game, "story", CsrLin, "Ahead you see " + world(aheadX%, aheadY%) + ".")
        End If
    End If
End If
Color _RGB(0, 0, 0)
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
    game.isOver = 1
    Print
    Call PrintText(game, "story", CsrLin, "You have exited the world.")
    Print
    If Contains%(inventory$, "GOLD", ",") Then
        Print
        Call PrintText(game, "story", CsrLin, "You have safely brought your riches back home.")
        Call PrintText(game, "story", CsrLin, "Fame and fortune are yours.")
        Call PrintText(game, "story", CsrLin, "YOU HAVE WON THE GAME!!!")
        If score% = 300 Then
            Call PrintText(game, "story", CsrLin, "MAXIMUM SCORE!!!")
        End If
    Else
        Print
        Call PrintText(game, "story", CsrLin, "You did not return home with the gold.")
        Call PrintText(game, "story", CsrLin, "This is a horrible fate.")
        Call PrintText(game, "story", CsrLin, "YOU HAVE LOST THE GAME.")
    End If
Else
    If (aheadX% = 0) Or (aheadX% = (levelSize% + 1)) Or (aheadY% = 0) Or (aheadY% = (levelSize% + 1)) Then
        Print
        Call PrintText(game, "story", CsrLin, "There is nothing ahead.  You are facing the edge of the world.")
        Print
        Call PrintText(game, "story", CsrLin, "Jumping off the edge of the world is NOT allowed in this game.")
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
Call PrintText(game, "story", CsrLin, "Please don't try walking backwards.  You might trip.")
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
    Call PrintText(game, "story", CsrLin, "All the gold now belongs to you!")
    Color _RGB(0, 0, 0)
    Call PrintText(game, "story", CsrLin, "Score +100")
    Call PrintText(game, "story", CsrLin, "Inventory +GOLD")
    Print
    If inventory$ = "NOTHING" Then
        inventory$ = "GOLD"
    Else
        inventory$ = inventory$ + ",GOLD"
    End If
End If
Return

PlayGameAction:
Call TurnPage(game)
Color _RGB(0, 0, 0)
Print
Call PrintText(game, "story", CsrLin, "Fluffy Cat: Answer me this, and a magical name I will give to you.")
Print
Call PrintText(game, "story", CsrLin, "What is blue... and is also the sky?")
Print
riddle$ = GetInput$("You", 0, 0, 40)
If (riddle$ = "THE SKY") Or (riddle$ = "THE BLUE SKY") Or (riddle$ = "BLUE SKY") Then
    riddle$ = "SKY"
End If
Print
If riddle$ = "SKY" Then
    Call PrintText(game, "story", CsrLin, "Fluffy Cat: Alas you have bested me!  And that was my")
    Call PrintText(game, "story", CsrLin, "finest riddle!  Very well then.  A deal is a deal. The")
    Call PrintText(game, "story", CsrLin, "magical name you seek is... SHMEBULOCK.")
Else
    If riddle$ = exitGameAction$ Then
        GoSub ExitAction
    Else
        Call PrintText(game, "story", CsrLin, "Fluffy Cat: Aha!  It appears that I have bested you!  That")
        Call PrintText(game, "story", CsrLin, "answer is INCORRECT.  No one is as clever as I!")
        Print
        Call PrintText(game, "story", CsrLin, "Better luck next time.")
    End If
End If
Print
Return

SpeakNameAction:
Call TurnPage(game)
Color _RGB(184, 115, 51)
Print
nameGuess$ = GetInput$("You", 0, 0, 10)
Print
If (nameGuess$ = "SHMEBULOCK") Then
    Call PrintText(game, "story", CsrLin, "           ,")
    Call PrintText(game, "story", CsrLin, "          / \")
    Call PrintText(game, "story", CsrLin, "         /   \")
    Call PrintText(game, "story", CsrLin, "        /     \")
    Call PrintText(game, "story", CsrLin, "       /_______\")
    Call PrintText(game, "story", CsrLin, "       // . . \\")
    Call PrintText(game, "story", CsrLin, "      (/(__7__)\)")
    Call PrintText(game, "story", CsrLin, "      |'-' = `-'|")
    Call PrintText(game, "story", CsrLin, "      |         |")
    Call PrintText(game, "story", CsrLin, "      /\       /\")
    Call PrintText(game, "story", CsrLin, "     /  '.   .'  \")
    Call PrintText(game, "story", CsrLin, "    / /|  `v`  |\ \")
    Call PrintText(game, "story", CsrLin, "    \ \|===[]==|/ /")
    Call PrintText(game, "story", CsrLin, "     '-|_______|-'")
    Call PrintText(game, "story", CsrLin, "        |__|__|")
    Call PrintText(game, "story", CsrLin, "        |--|--|")
    Call PrintText(game, "story", CsrLin, "       (__)`(__)")
    Print
    Call PrintText(game, "story", CsrLin, "Magic Gnome: Shmebulock!  Shmebulock... Shmebulock.")
    Call PrintText(game, "story", CsrLin, "Shmebulock?  Shmebulock, Shmebulock.  Shme... bulock!")
    Print
    If Not Contains%(inventory$, "RING OF TAMING", ",") Then
        Call PrintText(game, "story", CsrLin, "Inventory +RING OF TAMING")
        Call PrintText(game, "story", CsrLin, "(Does not work on large creatures.)")
    Else
        Call PrintText(game, "story", CsrLin, "You look down at your ring and it glows with power.")
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
            Call PrintText(game, "story", CsrLin, "You wait... and wait some more.  But... nothing happens!")
            Call PrintText(game, "story", CsrLin, "Perhaps you spoke the wrong name?")
            Print
            Call PrintText(game, "story", CsrLin, "Good guess though!")
        Else
            Call PrintText(game, "story", CsrLin, "You wait... and wait some more.  But... nothing happens!")
            Call PrintText(game, "story", CsrLin, "Perhaps you spoke the wrong name?")
            Print
            Call PrintText(game, "story", CsrLin, "Better luck next time.")
        End If
    End If
End If
Print
Return

TameFluffAction:
Call TurnPage(game)
Color _RGB(0, 0, 0)
Print
Call PrintText(game, "story", CsrLin, "                ____")
Call PrintText(game, "story", CsrLin, "                \ _ `\ ")
Call PrintText(game, "story", CsrLin, "                 | \  `\._")
Call PrintText(game, "story", CsrLin, "                 |  |  _/ `-.._")
Call PrintText(game, "story", CsrLin, "                 |  /-'  // /.'`-. .--.__")
Call PrintText(game, "story", CsrLin, "                 /-'    || // //  |    __\")
Call PrintText(game, "story", CsrLin, "               ./   .` |\///_//   \  /'   |")
Call PrintText(game, "story", CsrLin, "             .'.-.__.` \ |/'-' .'  \|    /")
Call PrintText(game, "story", CsrLin, "            / ( ____`.\ |/ .' '.'   |\  /")
Call PrintText(game, "story", CsrLin, "           /  -//   \     /- _  '     `'|")
Call PrintText(game, "story", CsrLin, "           |  ||o    ;       __`--      |")
Call PrintText(game, "story", CsrLin, "           |   \\   /      //  `.  \    |")
Call PrintText(game, "story", CsrLin, "           \    `---'     |/o    \_ )   \")
Call PrintText(game, "story", CsrLin, "         _ _\_    /       |      /       |")
Call PrintText(game, "story", CsrLin, "       _-_`-__-_.-'|__    \`-..-'       /")
Call PrintText(game, "story", CsrLin, "      '  .--_--_-.. \_\/_              /")
Call PrintText(game, "story", CsrLin, "        ' /    \... / .. \_-___       / \")
Call PrintText(game, "story", CsrLin, "         /      `-._| ..-._--___     /   \")
Call PrintText(game, "story", CsrLin, "        /    .---.|  `-.__/`--.__---'     |")
Call PrintText(game, "story", CsrLin, "       /_.--/ . . \__/   _   `--._-.      |")
Call PrintText(game, "story", CsrLin, "    .-'    | || | |   .-' `-.     \ `\    |")
Call PrintText(game, "story", CsrLin, "  .'       `-\/\|-'  |  / /  \     `\ \   |")
Call PrintText(game, "story", CsrLin, " /                    \/ | .  |           |")
Call PrintText(game, "story", CsrLin, "/                      \_/_/ / \          |")
Call PrintText(game, "story", CsrLin, "|  magnifico               \/   \         |")
Print
Print
Return

ChaseBunniesAction:
Print
Color _RGB(0, 255, 0)
Call PrintText(game, "story", CsrLin, "Seems like an unimportant thing to do but nonetheless")
Call PrintText(game, "story", CsrLin, "you try to chase some of the bunnies.  And... you can't")
Call PrintText(game, "story", CsrLin, "catch a single one.  They are too fast!  Oh well, time")
Call PrintText(game, "story", CsrLin, "to continue on with your quest.")
Return

DumbAction:
Print
Call PrintText(game, "story", CsrLin, "That is NOT a choice.  Better luck next time.")
Print
Return

AllTheThingsAction:
Print
thingDone% = 0
If level% = 1 Then
    If dragonDead% = 0 Then
        dragonDead% = 1
        score% = score% + 100
        Call PrintText(game, "story", CsrLin, "You slew the dragon!")
        Call PrintText(game, "story", CsrLin, "Score +100")
        thingDone% = 1
    End If
    If catTamed% = 0 Then
        catTamed% = 1
        score% = score% + 100
        Call PrintText(game, "story", CsrLin, "You tamed the elusive cat!")
        Call PrintText(game, "story", CsrLin, "Score +100")
        thingDone% = 1
    End If
    If Not Contains%(inventory$, "RING OF TAMING", ",") Then
        If inventory$ = "NOTHING" Then
            inventory$ = "RING OF TAMING"
        Else
            inventory$ = inventory$ + ",RING OF TAMING"
        End If
        Call PrintText(game, "story", CsrLin, "You obtained the Ring of Taming!")
        Call PrintText(game, "story", CsrLin, "Inventory +RING OF TAMING")
        Call PrintText(game, "story", CsrLin, "(Does not work on large creatures.)")
        thingDone% = 1
    End If
    If Not Contains%(inventory$, "GOLD", ",") Then
        If inventory$ = "NOTHING" Then
            inventory$ = "GOLD"
        Else
            inventory$ = inventory$ + ",GOLD"
        End If
        score% = score% + 100
        Call PrintText(game, "story", CsrLin, "You obtained the Gold!")
        Call PrintText(game, "story", CsrLin, "Score +100")
        Call PrintText(game, "story", CsrLin, "Inventory +GOLD")
        thingDone% = 1
    End If
    If (character$ = "GREYSON") And (Not Contains%(inventory$, "UNO REVERSE", ",")) Then
        If inventory$ = "NOTHING" Then
            inventory$ = "UNO REVERSE"
        Else
            inventory$ = inventory$ + ",UNO REVERSE"
        End If
        Call PrintText(game, "story", CsrLin, "You obtained the legendary UNO Reverse card!")
        Call PrintText(game, "story", CsrLin, "Inventory +UNO REVERSE")
        thingDone% = 1
    End If
    If (character$ = "ZARA") And (Not Contains%(inventory$, "SWORD", ",")) Then
        If inventory$ = "NOTHING" Then
            inventory$ = "SWORD"
        Else
            inventory$ = inventory$ + ",SWORD"
        End If
        Call PrintText(game, "story", CsrLin, "You obtained the legendary SWORD!")
        Call PrintText(game, "story", CsrLin, "Inventory +SWORD")
        thingDone% = 1
    End If
    If thingDone% = 0 Then
        Call PrintText(game, "story", CsrLin, "You have done all the things for level " + LTrim$(Str$(level%)) + ".")
    End If
End If
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

' Display the high scores pages
' Parameters:
' game - Book instance
Sub DisplayHighScoresPage (game As Book)
    If game.chapter = "" Then
        game.chapter = "HIGH SCORES"
    End If

    Call TurnPage(game)
    Color _RGB(0, 0, 0) ' black

    If _FileExists("high-scores.txt") Then
        Open "high-scores.txt" For Input As #1
        Do Until EOF(1)
            Input #1, fileLine$
            Call PrintText(game, "story", CsrLin, fileLine$)
        Loop
        Close #1
    Else
        Call PrintText(game, "story", CsrLin, "N/A")
    End If

    Print
    Print

    If game.isOver = 0 Then
        Call PressAnyKey(game)
    End If

    If game.chapter = "HIGH SCORES" Then
        game.chapter = ""
    End If
End Sub

' Display the title page
'
' Parameters:
' game - Book instance
Sub DisplayTitlePage (game As Book)
    Call TurnPage(game)
    Color _RGB(139, 0, 0) ' dark red
    ' TODO - Since TurnPage() moves the cursor to row 5, can the row parameters all just be CsrLin?
    Call PrintText(game, "story", 5, "                                   ___, ____--'")
    Call PrintText(game, "story", 6, "                              _,-.'_,-'      (")
    Call PrintText(game, "story", 7, "                           ,-' _.-''....____(")
    Call PrintText(game, "story", 8, "                 ,))_     /  ,'\ `'-.     (          /\")
    Call PrintText(game, "story", 9, "         __ ,+..a`  \(_   ) /   \    `'-..(         /  \")
    Call PrintText(game, "story", 10, "         )`-;...,_   \(_ ) /     \  ('''    ;'^^`\ <./\.>")
    Call PrintText(game, "story", 11, "             ,_   )   |( )/   ,./^``_..._  < /^^\ \_.))")
    Call PrintText(game, "story", 12, "            `=;; (    (/_')-- -'^^`      ^^-.`_.-` >-'")
    Call PrintText(game, "story", 13, "            `=\\ (                             _,./")
    Call PrintText(game, "story", 14, "              ,\`(                         )^^^")
    Call PrintText(game, "story", 15, "                ``;         __-'^^\       /")
    Call PrintText(game, "story", 16, "                  / _>---^^^   `\..`-.    ``'.")
    Call PrintText(game, "story", 17, "                 / /               / /``'`; /")
    Call PrintText(game, "story", 18, "                / /          ,-=='-`=-'  / /")
    Call PrintText(game, "story", 19, "          ,-=='-`=-.               ,-=='-`=-.")
    Color _RGB(0, 0, 0) ' black
    Call PrintText(game, "story", 20, "        *******************************************")
    Call PrintText(game, "story", 21, "                    T W I N   Q U E S T")
    Print
    Print
    Call PressAnyKey(game)
End Sub

' Get input from the user
'
' TODO - Shared variables gameChoices$, gameChoicesCol%, gameChoicesRow%, sceneChoices$, sceneChoicesCol%, sceneChoicesRow%
'        are needed to resolve which choice is selected when the mouse is used
'
' Parameters:
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
Function GetInput$ (prompt As String, enableArrowKeys As Integer, enableMouse As Integer, maxLength As Integer)
    inp$ = ""
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
    Color _RGB(0, 0, 0)
    Print prompt + ": "
    currentRow% = CsrLin - 1
    currentCol% = Len(prompt + ": ") + 1
    Locate currentRow%, currentCol%
    Color _RGB(0, 139, 139)
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
                If (mouseRow% = gameChoicesRow%) Then
                    possibleChoices$ = gameChoices$
                    possibleChoicesCol% = gameChoicesCol%
                Else
                    If (mouseRow% = sceneChoicesRow%) Then
                        possibleChoices$ = sceneChoices$
                        possibleChoicesCol% = sceneChoicesCol%
                    End If
                End If
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
                            Color _RGB(0, 0, 0)
                            Print inp$
                        Else
                            ' User only hovered over a new choice
                            If highlightedChoice$ <> choice$ Then
                                If highlightedChoice$ <> "" Then
                                    ' Remove the highlight from the last highlighted choice
                                    Locate highlightedChoiceRow%, highlightedChoiceCol%
                                    Color _RGB(0, 139, 139)
                                    Print highlightedChoice$
                                End If
                                ' Highlight the new choice
                                highlightedChoiceRow% = mouseRow%
                                highlightedChoiceCol% = possibleChoicesCol% + choiceLeftPos% - 1
                                Locate highlightedChoiceRow%, highlightedChoiceCol%
                                Color _RGB(0, 0, 0)
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
                        Color _RGB(0, 0, 0)
                        Print UCase$(c$)
                        Locate currentRow%, currentCol% + 1
                        Color _RGB(0, 139, 139)
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
                        Color _RGB(0, 139, 139)
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
                                Color _RGB(0, 0, 0)
                                Print inp$
                            End If
                        End If
                        ' Down arrow
                        If c$ = Chr$(0) + "P" Then
                            If RTrim$(LTrim$(inp$)) = "" Then
                                inp$ = "MOVE BACKWARDS"
                                c$ = Chr$(13)
                                Locate currentRow%, currentCol%
                                Color _RGB(0, 0, 0)
                                Print inp$
                            End If
                        End If
                        ' Left arrow
                        If c$ = Chr$(0) + "K" Then
                            If RTrim$(LTrim$(inp$)) = "" Then
                                inp$ = "TURN LEFT"
                                c$ = Chr$(13)
                                Locate currentRow%, currentCol%
                                Color _RGB(0, 0, 0)
                                Print inp$
                            End If
                        End If
                        ' Right arrow
                        If c$ = Chr$(0) + "M" Then
                            If RTrim$(LTrim$(inp$)) = "" Then
                                inp$ = "TURN RIGHT"
                                c$ = Chr$(13)
                                Locate currentRow%, currentCol%
                                Color _RGB(0, 0, 0)
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
    ' Clear the cursor
    Locate currentRow%, currentCol%
    Print " "
    ' Trim whitespace from the beginning and end of the input string
    GetInput$ = RTrim$(LTrim$(inp$))
    ' Reset the foreground text color
    Color _RGB(0, 0, 0)
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
Sub PressAnyKey (game As Book)
    ' Display the prompt text
    Color _RGB(0, 139, 139) ' Dark cyan
    curRow% = CsrLin
    ' TODO - Right align this text
    prompt$ = "Press any key to turn the page"
    Call PrintText(game, "story", game.lastRow, prompt$)
    ' Suspend program execution until the any key is pressed
    Sleep
    _KeyClear
    ' Clear the prompt text with spaces
    Call PrintText(game, "story", game.lastRow, String$(Len(prompt$), " "))
    ' Reposition the cursor
    Locate curRow%, 1
End Sub

' Print text on the book
'
' Parameters:
' game - Book instance
' page - (STORY/CONTROL) Which page of the book to use
' row - Text row
' text - Text to print
Sub PrintText (game As Book, page As String, row As Integer, text As String)
    ' Determine the starting position for the text based on the designated page
    page = UCase$(page)
    If ((page = "STORY") And (game.isRightHanded = 1)) Or ((page = "CONTROL") And (game.isRightHanded = 0)) Then
        ' book.png offers a left-hand page where text should start at position 15
        column% = 15
    Else
        If ((page = "STORY") And (game.isRightHanded = 0)) Or ((page = "CONTROL") And (game.isRightHanded = 1)) Then
            ' book.png offers a right-hand page where text should start at position 83
            column% = 83
        Else
            If 1 / 0 Then
                ' Let the programmer know they passed something... sinister
            End If
        End If
    End If

    ' About 66 characters can fit on a line before the edge of the page is reached.
    ' Wrap the text to make it fit the pages.
    startingTextLength = 0
    Do
        Locate row, column%
        textLength = Len(text)
        If startingTextLength = 0 Then
            startingTextLength = textLength
        End If
        If textLength > 66 Then
            ' Word wrap
            firstSpacePosition = _InStrRev(66, text, " ")
            If firstSpacePosition > 0 Then
                ' Display all characters up to the first space at or to the left of position 66
                Print Left$(text, firstSpacePosition)
                text = LTrim$(Mid$(text, firstSpacePosition + 1, textLength))
            Else
                ' Display the first 65 characters plus a hyphen
                Print Left$(text, 65) + "-"
                text = LTrim$(Mid$(text, 66, textLength))
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

' Wipe the current screen and redisplay the book image
'
' Parameters:
' game - Book instance
Sub TurnPage (game As Book)
    ' Play a sound for turning the page
    Call ReplaySound(game.pageTurnSound, 1, 0)

    Cls , _RGB(0, 0, 0) ' Clear screen with black as the background color
    _PutImage , game.image ' Display the main book image
    _PrintMode _KeepBackground ' Preserve the image background when printing text
    Color _RGB(0, 0, 0) ' black

    ' Print the page headers (the book image allows for text starting on row 3)
    If game.chapter <> "" Then
        ' TODO - Need to right-align the text on the right-hand page
        Call PrintText(game, "control", game.firstRow, UCase$(game.title))
        Call PrintText(game, "story", game.firstRow, UCase$(game.chapter))
    End If

    ' All non-header text should begin on row 5 to accommodate the book image
    Locate game.firstRow + 2, 1
End Sub

