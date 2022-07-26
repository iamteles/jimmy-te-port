package;

import cpp.abi.Abi;
import haxe.io.Float64Array;
import cpp.Function;
#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;

import flixel.util.FlxTimer;

using StringTools;

class IntroWarningState extends MusicBeatState
{
    var yesTex:FlxText;
    var noTex:FlxText;
    var curSelec:Int = 0;
    var transitioning:Bool = false;

    public override function create()
    {
        super.create();

        var bg:FlxSprite = new FlxSprite(0).loadGraphic(Paths.image('menuBGBluerred'));
		bg.screenCenter();
		add(bg);


        var warningText:FlxText = new FlxText(0, 50, 0, "WARNING", 72);
        warningText.setFormat(Paths.font("creme.ttf"), 120, FlxColor.WHITE, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        warningText.screenCenter(X);
        warningText.borderSize = 3;
        var description1:FlxText = new FlxText(0, 200, 0, "This mod contains flashing lights", 36);
        description1.setFormat(Paths.font("creme.ttf"), 50, FlxColor.WHITE, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        description1.screenCenter(X);
        description1.borderSize = 3;
        var description2:FlxText = new FlxText(0, 250, 0, "and other effects that may trigger seizures", 36);
        description2.setFormat(Paths.font("creme.ttf"), 50, FlxColor.WHITE, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        description2.screenCenter(X);
        description2.borderSize = 3;
        var description3:FlxText = new FlxText(0, 300, 0, "for people with photosensitive epilepsy.", 36);
        description3.setFormat(Paths.font("creme.ttf"), 50, FlxColor.WHITE, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        description3.screenCenter(X);
        description3.borderSize = 3;

        var askText:FlxText = new FlxText(0, 400, 0, "We recommend you leave these on for a better experience.", 36);
        askText.setFormat(Paths.font("creme.ttf"), 50, FlxColor.WHITE, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        askText.screenCenter(X);
        askText.borderSize = 3;

        yesTex = new FlxText(470, 500, "ON", 64);
        yesTex.setFormat(Paths.font("creme.ttf"), 64, FlxColor.YELLOW, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        yesTex.borderSize = 3;
        noTex = new FlxText(690, 500, "OFF", 64);
        noTex.setFormat(Paths.font("creme.ttf"), 64, FlxColor.WHITE, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        noTex.borderSize = 3;

        add(warningText);
        add(description1);
        add(description2);
        add(description3);
        add(askText);
        add(yesTex);
        add(noTex);
    }

    public override function update(elapsed:Float)
    {
        if(!transitioning)
        {
            if (FlxG.keys.justPressed.LEFT)
            {
                FlxG.sound.play(Paths.sound('scrollMenu'), 1, false);
                changeItem(-1);
            }
        
            if (FlxG.keys.justPressed.RIGHT)
            {
                FlxG.sound.play(Paths.sound('scrollMenu'), 1, false);
                changeItem(1);
            }

            if (FlxG.keys.justPressed.ENTER)
            {
                selectOption();
            }
        }
    }

    function changeItem(val:Int = 0)
    {
        curSelec += val;
        if (curSelec >= 2)
            curSelec = 0;
        if (curSelec < 0)
            curSelec = 2 - 1;
        switch(curSelec)
        {
            case 0:
                yesTex.color = FlxColor.YELLOW;
                noTex.color = FlxColor.WHITE;
            case 1:
                noTex.color = FlxColor.YELLOW;
                yesTex.color = FlxColor.WHITE;
        }
    }
    
    function selectOption()
    {
        transitioning = true;

        switch(curSelec)
        {
            case 0:
                FlxG.save.data.eventThing = true;
            case 1:
                FlxG.save.data.eventThing = false;
        }

        FlxG.save.data.hasSeenWarning = true;
        FlxG.camera.flash(FlxColor.WHITE, 1);
        FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
        new FlxTimer().start(1, function(tmr:FlxTimer)
        {
                FlxG.switchState(new MainMenuState());
        });
    }
}