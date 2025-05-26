package states;

import flixel.FlxState;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxTimer;
import objects.Character; // Import your Character class

class CharacterSelectState extends FlxState {
    private var switchTimer:FlxTimer;
    private var idleTimer:FlxTimer;

    private var currentCharacterIndex:Int = 0;
    private var currentFormIndex:Int = 0;

    private var displayText:FlxText;
    private var instructions:FlxText;
    private var previewCharacter:Character; // Use Character instead of FlxSprite

    private var selected:Bool = false;

    private var characters:Array<{ 
        name:String, 
        displayName:String, 
        forms:Array<{ name:String, displayName:String }> 
    }> = [
        { 
            name: "bf", 
            displayName: "Boyfriend", 
            forms: [
                { name: "bf", displayName: "Default" },
                { name: "bofriend", displayName: "Bofriend" }
            ]
        },
            { 
            name: "foolish-cat", 
            displayName: "Foolish Cat", 
            forms: [
                { name: "foolish-cat", displayName: "Foolish Cat" }
            ]
        }
    ];

    override public function create():Void {
        super.create();

        var bg = new FlxSprite();
        bg.loadGraphic(Paths.image("charSelect/background")); // no .png needed
        bg.updateHitbox(); // update collision box after resizing
        bg.screenCenter();
        add(bg);

        FlxG.sound.playMusic(Paths.music("characterSelect"), 1, true);

        displayText = new FlxText(0, 10, FlxG.width, "", 32);
        displayText.setFormat(Paths.font("vcr.ttf"), 24, 0xFFFFFF, "center");
        displayText.setBorderStyle(FlxTextBorderStyle.OUTLINE, 0xFF000000, 2); // Black outline with 2px thickness
        add(displayText);

        instructions = new FlxText(0, FlxG.height - 74, FlxG.width, "", 32);
        instructions.setFormat(Paths.font("vcr.ttf"), 24, 0xFFFFFF, "center");
        instructions.setBorderStyle(FlxTextBorderStyle.OUTLINE, 0xFF000000, 2); // Black outline with 2px thickness
        add(instructions);

        switchTimer = new FlxTimer();

        updateDisplayText();

        startIdleAnimationLoop(); // Start idle animation timer loop
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        if (!selected) {
            if (FlxG.keys.justPressed.LEFT) {
                FlxG.sound.play(Paths.sound("scrollMenu"), 1);
                currentCharacterIndex--;
                if (currentCharacterIndex < 0) currentCharacterIndex = characters.length - 1;
                currentFormIndex = 0;
                updateDisplayText();
            } else if (FlxG.keys.justPressed.RIGHT) {
                FlxG.sound.play(Paths.sound("scrollMenu"), 1);
                currentCharacterIndex++;
                if (currentCharacterIndex >= characters.length) currentCharacterIndex = 0;
                currentFormIndex = 0;
                updateDisplayText();
            } else if (FlxG.keys.justPressed.UP) {
                FlxG.sound.play(Paths.sound("scrollMenu"), 1);
                var formsCount = characters[currentCharacterIndex].forms.length;
                currentFormIndex--;
                if (currentFormIndex < 0) currentFormIndex = formsCount - 1;
                updateDisplayText();
            } else if (FlxG.keys.justPressed.DOWN) {
                FlxG.sound.play(Paths.sound("scrollMenu"), 1);
                var formsCount = characters[currentCharacterIndex].forms.length;
                currentFormIndex++;
                if (currentFormIndex >= formsCount) currentFormIndex = 0;
                updateDisplayText();
            }
        }

        if (FlxG.keys.justPressed.ENTER) {
            if (!selected) {
                selected = true;

                // Stop idle timer when selected
                if (idleTimer != null) {
                    idleTimer = null;
                }

                FlxG.sound.music.stop();
                FlxG.sound.playMusic(Paths.music("gameOverEnd"), 1, false);

                if (previewCharacter.animation.exists("hey")) {
                    previewCharacter.animation.play("hey");
                } else {
                    previewCharacter.animation.play("singUP");
                }

                switchTimer.start(2);
                switchTimer.onComplete = function(timer:FlxTimer) {
                    var chosenChar = characters[currentCharacterIndex];
                    var chosenForm = chosenChar.forms[currentFormIndex];

                    PlayState.playerCharacterName = chosenForm.name;
                    LoadingState.loadAndSwitchState(new PlayState());
                };
            }
        }
    }

    private function updateDisplayText():Void {
        var charData = characters[currentCharacterIndex];
        var formData = charData.forms[currentFormIndex];
        displayText.text = 'Character: ' + charData.displayName + '\nForm: ' + formData.displayName;
        instructions.text = 
            "← / → : Change Character\n" +
            "↑ / ↓ : Change Form";


        updatePreviewCharacter();
    }

    private function updatePreviewCharacter():Void {
        // Remove old previewCharacter if it exists
        if (previewCharacter != null) {
            remove(previewCharacter);
            previewCharacter.destroy();
            previewCharacter = null;
        }

        var formName = characters[currentCharacterIndex].forms[currentFormIndex].name;

        previewCharacter = new Character(0, 0, formName);
        previewCharacter.scale.x = -1;
        previewCharacter.screenCenter();

        add(previewCharacter);
    }

    private function startIdleAnimationLoop():Void {
        if (selected) return; // Don’t start if already selected

        idleTimer = new FlxTimer();

        idleTimer.start(60 / 110);
        idleTimer.onComplete = function(timer:FlxTimer) {
            if (previewCharacter != null && !selected) {
                previewCharacter.animation.play("idle", true);
            }
            if (!selected) {
                // Restart timer for continuous looping
                startIdleAnimationLoop();
            }
        };
    }
}
