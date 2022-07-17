package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.FlxSprite;

class JeffryGoneSubstate extends MusicBeatSubstate
{
	var jeffryScreen:FlxSprite;

	public function new()
	{
		super();
		
		jeffryScreen = new FlxSprite().loadGraphic(Paths.image('killcount/jefferson'));
		jeffryScreen.x = -120;
		jeffryScreen.y = -50;

		add(jeffryScreen);

		FlxG.sound.playMusic(Paths.music('jeffryAmbience'));

		if(FlxG.save.data.instRespawn)
		{
			endBullshit();
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.ACCEPT)
		{
			endBullshit();
		}

		if (controls.BACK)
		{
			FlxG.sound.music.stop();

			if (PlayState.isStoryMode)
				FlxG.switchState(new StoryMenuState());
			else
				FlxG.switchState(new FreeplayState());

		}
	}

	var isEnding:Bool = false;

	function endBullshit():Void
	{
		if (!isEnding)
		{
			isEnding = true;
			FlxG.sound.music.stop();
			new FlxTimer().start((!FlxG.save.data.instRespawn ? 0.7 : 0), function(tmr:FlxTimer)
			{
				FlxG.camera.fade(FlxColor.BLACK, (!FlxG.save.data.instRespawn ? 2 : 0), false, function()
				{
					FlxG.switchState(new PlayState());
				});
			});
		}
	}
}
