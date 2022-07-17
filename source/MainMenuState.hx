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

using StringTools;

class MainMenuState extends MusicBeatState
{
	public var curSelected:Int = 0;
	public static var items:Array<String> = ["story mode", "freeplay", "jimmy", "bryce", "zach", "credits", "options"];
	public static var bgs:Array<String> = ["menuBGblurred"];
	public var menuItems:FlxTypedGroup<Sprite>;

	var leftArrow:Sprite;
	var rightArrow:Sprite;
	public override function create()
	{
		super.create();
		menuItems = new FlxTypedGroup<Sprite>();

		if (!FlxG.sound.music.playing || FlxG.sound.music.volume == 0)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}
	

		/*var bg:Sprite = new Sprite(0, 0);
		bg.frames = Paths.getSparrowAtlas(Paths.image(bgs[FlxG.random.int(0, bgs.length - 1)]));
		bg.animation.addByPrefix('anim', 'anim', 24, true);
		bg.screenCenter();
		bg.animation.play("anim");
		add(bg);*/

		var bg:Sprite = new Sprite(0, 0).loadGraphics(Paths.image(bgs[FlxG.random.int(0, bgs.length - 1)]));
		bg.setGraphicSize(Std.int(bg.width * 1.12));
		bg.screenCenter();
		add(bg);


		for(i in 0...items.length)
		{
			var item:Sprite = new Sprite(0, 0).loadGraphics(Paths.image("menu/" + items[i].toLowerCase()));
			item.setGraphicSize(Std.int(item.width * 0.6));
			item.screenCenter(X);
			//item.screenCenter(Y);
			item.x = 0;
			item.y = 1200;
			menuItems.add(item);

			item.ID = i;
		}

		add(menuItems);

		leftArrow = new Sprite().loadGraphics(Paths.image("menu/leftArrow"));
		leftArrow.y = 270;
		leftArrow.x = 0;


		rightArrow = new Sprite().loadGraphics(Paths.image("menu/leftArrow"));
		rightArrow.y = 270;
		rightArrow.x = 1100;
		rightArrow.flipX = true;

		add(leftArrow);
		add(rightArrow);

		var versionShit:FlxText = new FlxText(5, FlxG.height - 36, 0, "YLYL Funkin:" + " 1.8.8" , 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		var engineVersionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, "Tr1NgleEngine version:" + Main.engineVersion, 12);
		engineVersionShit.scrollFactor.set();
		engineVersionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(engineVersionShit);
	}
	var daChangingSpeedLerpYeRatioA:Float = 0.2;
	var startedChangeState:Bool = false;
	public override function update(elapsed:Float)
	{
		super.update(elapsed);
		if(controls.LEFT_PUI)
			changeItem(-1);
		if(controls.RIGHT_PUI)
			changeItem(1);
		if(FlxG.keys.justPressed.SEVEN)
		{
			PlayState.SONG = Song.loadFromJson(Highscore.formatSong('robbery', 2), 'robbery');
			PlayState.isStoryMode = false;
			PlayState.storyDifficulty = 2;
			LoadingState.loadAndSwitchState(new PlayState());
		}
		if(controls.LEFTUI)
		{
			leftArrow.color = FlxColor.YELLOW;
			leftArrow.alpha = 0.95;
			leftArrow.setGraphicSize(Std.int(leftArrow.width * 0.55));
		}
		else
		{
			leftArrow.color = FlxColor.WHITE;
			leftArrow.alpha = 0.95;
			leftArrow.setGraphicSize(Std.int(leftArrow.width * 0.5));
		}
		if(controls.RIGHTUI)
		{
			rightArrow.color = FlxColor.YELLOW;
			rightArrow.alpha = 0.95;
			rightArrow.setGraphicSize(Std.int(rightArrow.width * 0.55));
		}
		else
		{
			rightArrow.color = FlxColor.WHITE;
			rightArrow.alpha = 0.95;
			rightArrow.setGraphicSize(Std.int(rightArrow.width * 0.5));
		}

		if(controls.ACCEPT && !startedChangeState)
		{
			switch (items[curSelected])
			{
				case "jimmy" | "bryce" | "zach":
				{
					switch (items[curSelected])
					{
						case "jimmy":
							FlxG.openURL('https://www.youtube.com/c/JimmyHereOfficial');
						case "bryce":
							FlxG.openURL('https://www.youtube.com/c/BryceUp');
						case "zach":
							FlxG.openURL('https://twitter.com/StreamMGMT');
					}
				}
				default:
				{
					startedChangeState = true;
					FlxTween.tween(FlxG.camera, {y: -900}, 0.9, {
						ease: FlxEase.quadInOut
					});
					FlxG.sound.play(Paths.sound('confirmMenu'));
					FlxFlicker.flicker(menuItems.members[curSelected], 1, 0.06, false, false, function(flick:FlxFlicker)
					{
						switch (items[curSelected])
						{
							case "story mode":
								//FlxG.switchState(new StoryMenuState());
								FlxG.switchState(new FreeplayState());
							case "freeplay":
								FlxG.switchState(new FreeplayState());
							case "credits":
								FlxG.switchState(new FreeplayState());
							case "options":
								FlxG.switchState(new OptionsMenu());
						}
					});
				}
			}		
		}
		menuItems.forEach(function(item:Sprite)
		{
			if(item.ID == curSelected)
			{
				item.x = CoolUtil.coolLerp(item.x, -60, daChangingSpeedLerpYeRatioA);
				//item.y = CoolUtil.coolLerp(item.y, 0, daChangingSpeedLerpYeRatioA);
				item.y = CoolUtil.coolLerp(item.y, -120, daChangingSpeedLerpYeRatioA);
				//item.color = CoolUtil.smoothColorChange(item.color, FlxColor.YELLOW, daChangingSpeedLerpYeRatioA);
				item.alpha = CoolUtil.coolLerp(item.alpha, 1, daChangingSpeedLerpYeRatioA);
			}
			else
			{
				item.y = CoolUtil.coolLerp(item.y, -80, daChangingSpeedLerpYeRatioA);
				if(item.ID < curSelected)
				{
					item.x = CoolUtil.coolLerp(item.x, (-item.width / 2 * (curSelected - item.ID)) + 100 * (item.ID - curSelected + 1) - 350, daChangingSpeedLerpYeRatioA);
					//item.color = CoolUtil.smoothColorChange(item.color, FlxColor.WHITE, daChangingSpeedLerpYeRatioA);
					item.alpha = CoolUtil.coolLerp(item.alpha, 0.7, daChangingSpeedLerpYeRatioA);
				}
				if(item.ID > curSelected)
				{
					//item.x = CoolUtil.coolLerp(item.x, ((1280 - item.width / 2) * (item.ID - curSelected)) + 100 * (curSelected - item.ID + 1), daChangingSpeedLerpYeRatioA);
					item.x = CoolUtil.coolLerp(item.x, ((1280 - item.width / 2) * (item.ID - curSelected)) + 100 * (curSelected - item.ID + 1) + 350, daChangingSpeedLerpYeRatioA);
					//item.color = CoolUtil.smoothColorChange(item.color, FlxColor.WHITE, daChangingSpeedLerpYeRatioA);
					item.alpha = CoolUtil.coolLerp(item.alpha, 0.7, daChangingSpeedLerpYeRatioA);
				}
			}
		});
	}
	function changeItem(val:Int = 0)
	{
		curSelected += val;

		if (curSelected >= items.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = items.length - 1;
		// there was code using FlxTween but its sucks so im using Lerp instead
	}
}
