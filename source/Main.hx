package;

import flixel.FlxGame;
import flixel.FlxState;
import openfl.Assets;
import openfl.Lib;
import flixel.FlxG;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.events.Event;

class Main extends Sprite
{
	var gameWidth:Int = 1280; // Width of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var gameHeight:Int = 720; // Height of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var initialState:Class<FlxState> = TitleState; // The FlxState the game starts with.
	var zoom:Float = -1; // If -1, zoom is automatically calculated to fit the window dimensions.
	var framerate:Int = 120; // How many frames per second the game should run at.
	var skipSplash:Bool = true; // Whether to skip the flixel splash screen that appears in release mode.
	var startFullscreen:Bool = false; // Whether to start the game in fullscreen on desktop targets
	public static var engineVersion:String = "1.7.0";
	public static var gameVersion:String = "2.0.1";

	// You can pretty much ignore everything from here on - your code should go in your states.
	public static function setupSaveData()
	{
		if(FlxG.save.data.downscroll == null)
			FlxG.save.data.downscroll = false;
		if(FlxG.save.data.skillIssue == null)
			FlxG.save.data.skillIssue = false;
		if(FlxG.save.data.bgNotes == null)
			FlxG.save.data.bgNotes = false;
		if(FlxG.save.data.hitSounds == null)
			FlxG.save.data.hitSounds = false;
		if(FlxG.save.data.middlescroll == null)
			FlxG.save.data.middlescroll = false;
		if(FlxG.save.data.pauseCountdown == null)
			FlxG.save.data.pauseCountdown = false;
		if(FlxG.save.data.instRespawn == null)
			FlxG.save.data.instRespawn = false;
		if(FlxG.save.data.preloadCharacters == null)
			FlxG.save.data.preloadCharacters = false;
		if(FlxG.save.data.botAutoPlay == null)
			FlxG.save.data.botAutoPlay = false;
		if(FlxG.save.data.fps == null)
			FlxG.save.data.fps = true;
		if(FlxG.save.data.eventThing == null)
			FlxG.save.data.eventThing = true;
		if(FlxG.save.data.framerateDraw == null)
			FlxG.save.data.framerateDraw = 120;
		if(FlxG.save.data.shadersOn == null)
			FlxG.save.data.shadersOn = true;
		if(FlxG.save.data.mem == null)
			FlxG.save.data.mem = true;
		if(FlxG.save.data.fullscreen == null)
			FlxG.save.data.fullscreen = false;
		if(FlxG.save.data.uiOption == null)
			FlxG.save.data.uiOption = 2;
		if(FlxG.save.data.showEnemyNotes == null)
			FlxG.save.data.showEnemyNotes = false;
	}
	public static function main():Void
	{
		Lib.current.addChild(new Main());
	}
	public function new()
	{
		super();


		if (stage != null)
		{
			init();
		}
		else
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
	}

	private function init(?E:Event):Void
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}

		setupGame();
	}

	private function setupGame():Void
	{
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;

		if (zoom == -1)
		{
			var ratioX:Float = stageWidth / gameWidth;
			var ratioY:Float = stageHeight / gameHeight;
			zoom = Math.min(ratioX, ratioY);
			gameWidth = Math.ceil(stageWidth / zoom);
			gameHeight = Math.ceil(stageHeight / zoom);
		}

		#if !debug
		initialState = TitleState;
		#end

		addChild(new FlxGame(gameWidth, gameHeight, initialState, zoom, framerate, framerate, skipSplash, startFullscreen));
		

			
		
		#if !mobile
		
		fpsCounter = new FPSCounter(10, 3);
		addChild(fpsCounter);
		if(FlxG.save.data.fps == null)
			FlxG.save.data.fps = true;
		toggleFPS(FlxG.save.data.fps);
		#end

		setupSaveData();
	}
	var fpsCounter:FPSCounter;

	public function toggleFPS(fpsEnabled:Bool):Void {
		fpsCounter.visible = fpsEnabled;
	}
}
