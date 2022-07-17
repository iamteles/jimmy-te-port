package;

import lime.utils.Assets;
import flixel.util.FlxColor;
import flixel.math.FlxMath;
import flixel.FlxG;
import flixel.graphics.FlxGraphic;
import openfl.display.BitmapData;
import openfl.utils.Assets as OpenFlAssets;
#if cpp
import sys.FileSystem;
import sys.io.File;
#end
import flixel.FlxSprite;
import flixel.text.FlxText;
using StringTools;

import flixel.math.FlxRandom;

class CoolUtil
{
	public static var difficultyArray:Array<String> = ['EASY', "NORMAL", "HARD", "HARDPLUS", "HARDPLUSPLUS", "TRADITIONAL"];

	public static function getTextFileContent(path:String):String // returns the content of the text file at runtime ig
	{
		#if cpp
		if (FileSystem.exists(path)) return File.getContent(path);
		#end
		return "";
	}

	public static function difficultyString():String
	{
		return difficultyArray[PlayState.storyDifficulty];
	}

	public static function coolTextFile(path:String):Array<String>
	{
		var daList:Array<String> = Assets.getText(path).trim().split('\n');

		for (i in 0...daList.length)
		{
			daList[i] = daList[i].trim();
		}

		return daList;
	}

	public static function numberArray(max:Int, ?min = 0):Array<Int>
	{
		var dumbArray:Array<Int> = [];
		for (i in min...max)
		{
			dumbArray.push(i);
		}
		return dumbArray;
	}

	public static function smoothColorChange(from:FlxColor, to:FlxColor, speed:Float = 0.045):FlxColor
	{

	    var result:FlxColor = FlxColor.fromRGBFloat
	    (
	        CoolUtil.coolLerp(from.redFloat, to.redFloat, speed), //red

	        CoolUtil.coolLerp(from.greenFloat, to.greenFloat, speed), //green

	        CoolUtil.coolLerp(from.blueFloat, to.blueFloat, speed) //blue
	    );
		if (Math.abs(result.redFloat - to.redFloat) <= speed * 2.01)
			result.redFloat = to.redFloat;
		if (Math.abs(result.greenFloat - to.greenFloat) <= speed * 2.01)
			result.greenFloat = to.greenFloat;
		if (Math.abs(result.blueFloat - to.blueFloat) <= speed * 2.01)
			result.blueFloat = to.blueFloat;
	    return result;

	   

	}

	public static function preloadImages(loadState:MusicBeatState)
	{
		FlxGraphic.defaultPersist = FlxG.save.data.preloadCharacters;
		//if(FlxG.save.data.preloadCharacters)
		//{
		//	FlxG.switchState(new PreloadingState(loadState));
		//}
		//else
		//	LoadingState.loadAndSwitchState(loadState, true);
		FlxG.switchState(new PreloadingState(loadState));
	}
	
	public static function camLerpShit(a:Float):Float
	{
		return FlxG.elapsed / 0.016666666666666666 * a;
	}
	public static function coolLerp(a:Float, b:Float, c:Float):Float
	{
		return a + CoolUtil.camLerpShit(c) * (b - a);
	}
}
class PreloadingState extends MusicBeatState
{
	private var loadState:MusicBeatState;
	private var infoText:FlxText;
	public function new(loadState:MusicBeatState)
	{
		super();
		this.loadState = loadState;
		transIn = null;
		transOut = null;
	}
	public override function create()
	{
		super.create();
		
		var randomBG:Int = FlxG.random.int(1,4);

		var bg:Sprite = new Sprite().loadGraphics(Paths.image('loadingScreens/load' + randomBG));
		//var bg:Sprite = new Sprite().loadGraphics(Paths.image('loadingScreens/load'));
		bg.antialiasing = true;
		add(bg);
			
		if(!FlxG.save.data.preloadCharacters)
			{
				LoadingState.loadAndSwitchState(loadState, true);
			}
		else
			{
				sys.thread.Thread.create(()->
				{
					caching();
				});				
			}
		
	}
	function caching()
	{
		var images = [];
		var imagesPaths = [];
		
		#if cpp
		if (FlxG.save.data.preloadCharacters)
		{
			trace("caching images...");
			for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/images")))
			{
				//trace(i);
				if (!i.endsWith(".png"))
					continue;
				if(i.split(".")[1] == "png")
				{
					imagesPaths.push("assets/images/" + i);
					images.push(i.split(".")[0]);
				}
			}
			for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/shared/images")))
			{
				//trace(i);
				if (!i.endsWith(".png"))
					continue;
				if(i.split(".")[1] == "png")
				{
					imagesPaths.push("assets/shared/images/" + i);
					images.push(i.split(".")[0]);
				}
			}
			for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/images/icons")))
			{
				//trace(i);
				if (!i.endsWith(".png"))
					continue;
				if(i.split(".")[1] == "png")
				{
					imagesPaths.push("assets/images/icons/" + i);
					images.push(i.split(".")[0]);
				}
			}
			for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/images/characters")))
			{
				//trace(i);
				if (!i.endsWith(".png"))
					continue;
				if(i.split(".")[1] == "png")
				{
					imagesPaths.push("assets/images/characters/" + i);
					images.push(i.split(".")[0]);
				}
			}
			if(FileSystem.exists("assets/week" + PlayState.storyWeek + "/images"))
			{
				for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/week" + PlayState.storyWeek + "/images")))
				{
					//trace(i);
					if (!i.endsWith(".png"))
						continue;
					if(i.split(".")[1] == "png")
					{
						imagesPaths.push("assets/week" + PlayState.storyWeek + "/images/" + i);
						images.push(i.split(".")[0]);
					}
				}
			}
		}
		#end
		//trace(images);
		if (FlxG.save.data.preloadCharacters)
		{
			for (i in 0 ... images.length) 
			{
				if (!OpenFlAssets.cache.hasBitmapData(imagesPaths[i]))
				{
					OpenFlAssets.loadBitmapData(imagesPaths[i]).onComplete(function(image)
					{
					});
					
				}
			}
		}
		LoadingState.loadAndSwitchState(loadState, true);
	}
}
