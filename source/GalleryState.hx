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

class GalleryState extends MusicBeatState
{
	public var curSelected:Int = 0;
	public static var items:Array<String> = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19"];
	public static var description:Array<String> = ["Jeffry Gone early idle", "Early logo", "Early bryce bg", "Scrapped jimmy room remake", "Early menu bg", "Jeffry", "Everyone in the teams favourite image", "Mystery maam", "Maid concept art", "Chickfila BF Homestuck edition. Canonically homofobic", "Maid gf Homestuck edition", "Them", "Killcount concept", "Jimussy concept icons", "Jimmy concept icons", "Sniper monkey", "Misc concepts", "???", "Doogal."];
	public static var peopleMade:Array<String> = ["Corruption", "Santry", "Corruption", "Corruption", "Santry", "Corruption", "Corruption", "Crunchy", "Corruption", "Corruption", "Corruption", "Corruption", "Corruption", "Diamond", "Santry", "Crunchy", "Crunchy", "Crunchy", "Crunchy"];
	public static var bgs:Array<String> = ["menuBGblurred"];
	public var menuItems:FlxTypedGroup<Sprite>;

	var tipTextArray:Array<String> = "E/Q - Camera Zoom
	\nR - Reset Camera Zoom
	\nArrow Keys - Scroll\n".split('\n');

	var zoomAmmount:Int = 100;

	var leftArrow:Sprite;
	var rightArrow:Sprite;

	var itemScale:Float = 1;

	var descText:FlxText;
	var descTextTwo:FlxText;



	public override function create()
	{
		super.create();
		menuItems = new FlxTypedGroup<Sprite>();

		if (!FlxG.sound.music.playing || FlxG.sound.music.volume == 0)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}
	
		var bg:Sprite = new Sprite(0, 0).loadGraphics(Paths.image(bgs[FlxG.random.int(0, bgs.length - 1)]));
		bg.setGraphicSize(Std.int(bg.width * 1.12));
		bg.screenCenter();
		add(bg);

		for(i in 0...items.length)
		{
			var item:Sprite = new Sprite(0, 0).loadGraphics(Paths.image("gallery/" + items[i].toLowerCase()));
			item.screenCenter(X);
			item.screenCenter(Y);
			menuItems.add(item);

			item.ID = i;
		}

		add(menuItems);

		descText = new FlxText(50, 600, 1180, "", 32);
		descText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		descText.scrollFactor.set();
		descText.borderSize = 2.4;
		add(descText);

		descTextTwo = new FlxText(50, 640, 1180, "", 32);
		descTextTwo.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		descTextTwo.scrollFactor.set();
		descTextTwo.borderSize = 2.4;
		add(descTextTwo);

		for (i in 0...tipTextArray.length-1)
		{
			var tipText:FlxText = new FlxText(FlxG.width - 320, FlxG.height - 15 - 16 * (tipTextArray.length - i), 300, tipTextArray[i], 12);
			tipText.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE_FAST, FlxColor.BLACK);
			tipText.scrollFactor.set();
			tipText.borderSize = 2.4;
			add(tipText);
		}

		leftArrow = new Sprite().loadGraphics(Paths.image("menu/leftArrow"));
		leftArrow.y = 270;
		leftArrow.x = 0;


		rightArrow = new Sprite().loadGraphics(Paths.image("menu/leftArrow"));
		rightArrow.y = 270;
		rightArrow.x = 1100;
		rightArrow.flipX = true;

		add(leftArrow);
		add(rightArrow);
		
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
		if(controls.LEFTUI)
		{
			leftArrow.color = FlxColor.YELLOW;
			leftArrow.alpha = 0.95;
			leftArrow.setGraphicSize(Std.int(leftArrow.width * 0.55));
			itemScale = 1;
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
			itemScale = 1;
		}
		else
		{
			rightArrow.color = FlxColor.WHITE;
			rightArrow.alpha = 0.95;
			rightArrow.setGraphicSize(Std.int(rightArrow.width * 0.5));
		}

		if (FlxG.keys.justPressed.R) {
			itemScale = 1;
		}

		
		if (FlxG.keys.pressed.E && itemScale < 3) {
			itemScale += elapsed * itemScale;
			if(itemScale > 3) itemScale = 3;
		}
		if (FlxG.keys.pressed.Q && itemScale > 0.1) {
			itemScale -= elapsed * itemScale;
			if(itemScale < 0.1) itemScale = 0.1;
		}

		if (controls.BACK)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			FlxG.switchState(new MainMenuState());
		}

		menuItems.forEach(function(item:Sprite)
		{
			if(item.ID == curSelected)
			{
				item.visible = true;

				item.setGraphicSize(Std.int(item.width * itemScale));
			}
			else
			{
				item.visible = false;
			}
		});

		descText.text = description[curSelected];
		descTextTwo.text = peopleMade[curSelected];
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
