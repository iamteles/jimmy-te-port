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

class CreditsState extends MusicBeatState
{
	public var curSelected:Int = 0;
	public static var creditsInfo:Array<Array<String>> = [
		['teles', 'coder', 'https://www.youtube.com/c/telesfnf'],
		['tr1ngle', 'coder', '']
	];
	public var menuItems:FlxTypedGroup<Alphabet>;

	public override function create()
	{
		super.create();
		menuItems = new FlxTypedGroup<Alphabet>();

		var bg:Sprite = new Sprite(0, 0).loadGraphics(Paths.image("menuBG"));
		//bg.setGraphicSize(Std.int(bg.width * 1.12));
		bg.screenCenter();
		add(bg);

		for(i in 0...creditsInfo.length)
		{
			var textItem:Alphabet = new Alphabet(0, (70 * i) + 30, creditsInfo[i][0], true, false);
			//textItem.setGraphicSize(Std.int(textItem.width * 0.6));
			//textItem.screenCenter(X);
			//item.screenCenter(Y);
			textItem.x = 0;
			textItem.y = i * 500;
			menuItems.add(textItem);
			textItem.ID = i;
		}
		add(menuItems);
	}

	function changeItem(val:Int = 0)
	{
		curSelected += val;

		if (curSelected >= creditsInfo.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = creditsInfo.length - 1;
	}
}