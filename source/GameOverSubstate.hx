package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;

class GameOverSubstate extends MusicBeatSubstate
{
	//var camFollow:FlxObject;

	var stageSuffix:String = "";

	var daSong:String = "gameOver";

	var restartSprite:Sprite;

	var isEnding:Bool = false;

	public function new(x:Float, y:Float)
	{
		var daStage = PlayState.curStage;
		var daBf:String = '';
		switch (daStage)
		{
			case 'jimmyroom':
				daSong = 'isntHere';
			case 'bryceroom':
				daSong = 'youGood';
			case 'creep':
				daSong = 'coolBananas';
			default:
				daSong = 'gameOver';
		}

		super();

		Conductor.songPosition = 0;

		

		//camFollow = new FlxObject(bf.getGraphicMidpoint().x, bf.getGraphicMidpoint().y, 1, 1);
		//add(camFollow);

		restartSprite = new Sprite(0, 0).loadGraphics(Paths.image('restart'));
		restartSprite.alpha = 0;
		restartSprite.screenCenter(X);
		restartSprite.screenCenter(Y);
		add(restartSprite);

		FlxG.sound.play(Paths.sound('fnf_loss_sfx'));
		Conductor.changeBPM(100);

		// FlxG.camera.followLerp = 1;
		// FlxG.camera.focusOn(FlxPoint.get(FlxG.width / 2, FlxG.height / 2));
		FlxG.camera.scroll.set();
		FlxG.camera.target = null;
		
		if(FlxG.save.data.instRespawn)
		{
			endBullshit();
		}

	}

	var isStarted = false;
	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.ACCEPT)
		{
			endBullshit();
		}

		if(!isStarted)
		{
			new FlxTimer().start(1.8, function(tmr:FlxTimer)
				{
					isStarted = true;
					FlxTween.tween(restartSprite, {alpha: 1}, 4);
				});
		}

		

		if (controls.BACK)
		{
			FlxG.sound.music.stop();


			if (PlayState.isStoryMode)
				FlxG.switchState(new StoryMenuState());
			else
				FlxG.switchState(new FreeplayState());

		}



		if (FlxG.sound.music.playing)
		{
			Conductor.songPosition = FlxG.sound.music.time;
		}
		else if (!isEnding && isStarted)
		{
			FlxG.sound.playMusic(Paths.music("gameovers/" + daSong));
		}

		/*
		if (bf.animation.curAnim.name == 'firstDeath' && bf.animation.curAnim.curFrame == 12)
		{
			//FlxG.camera.follow(camFollow, LOCKON, 0.01);
		}
		*/

	}

	override function beatHit()
	{
		super.beatHit();

		FlxG.log.add('beat');
	}



	function endBullshit():Void
	{
		if (!isEnding)
		{
			isEnding = true;
			//bf.playAnim('deathConfirm', true);
			FlxG.sound.music.stop();
			FlxG.sound.play(Paths.music("gameovers/" + daSong + "End"));
			FlxG.camera.flash(FlxColor.WHITE, 1);
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
