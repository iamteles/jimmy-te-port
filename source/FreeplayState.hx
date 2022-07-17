package;

import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import Math;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
#if desktop
import sys.FileSystem;
import sys.io.File;
#end

#if windows
import Discord.DiscordClient;
#end

using StringTools;

class FreeplayState extends MusicBeatState
{
	var songs:Array<SongMetadata> = [];

	var selector:FlxText;
	var curSelected:Int = 0;
	var curDifficulty:Int = 1;

	var scoreText:FlxText;
	var maxAccText:FlxText;
	var comboText:FlxText;
	var diffText:FlxText;
	var lerpScore:Int = 0;
	var intendedScore:Int = 0;
	var lerpMaxAcc:Float = 0;
	var intendedMaxAcc:Float = 0;
	var lerpCombo:Int = 0;
	var intendedCombo:Int = 0;

	var maxDiff:Int = 0;

	var diffString:String = "-hard";

	public var curSelectedSongHaveFunkyDiff:Bool = false;

	public var bg:Sprite;

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;

	private var iconArray:Array<HealthIcon> = [];

	override function create()
	{
		var initSonglist = CoolUtil.coolTextFile(Paths.txt('freeplaySonglist'));

		for (i in 0...initSonglist.length)
		{
			var data:Array<String> = initSonglist[i].split(':');
			songs.push(new SongMetadata(data[0], Std.parseInt(data[2]), data[1], data[3]));
		}

		if (!FlxG.sound.music.playing || FlxG.sound.music.volume == 0)
			{
				FlxG.sound.playMusic(Paths.music('freakyMenu'));
			}
	
		

		 #if windows
		 // Updating Discord Rich Presence
		 DiscordClient.changePresence("In the Freeplay Menu", null);
		 #end

		var isDebug:Bool = false;

		#if debug
		isDebug = true;
		#end

		// LOAD MUSIC

		// LOAD CHARACTERS

		bg = new Sprite().loadGraphics(Paths.image('menuDesat'));
		bg.color = FlxColor.WHITE;
		add(bg);

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for (i in 0...songs.length)
		{
			
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i].songName, true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpSongs.add(songText);
			
			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			icon.sprTracker = songText;

			// using a FlxGroup is too much fuss!
			iconArray.push(icon);
			add(icon);

			// songText.x += 40;
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			// songText.screenCenter(X);
		}

		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 10);
		// scoreText.autoSize = false;
		scoreText.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT);
		// scoreText.alignment = RIGHT;

		

		maxAccText = new FlxText(FlxG.width * 0.7, 20, 0, "", 10);
		// scoreText.autoSize = false;
		maxAccText.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT);
		// scoreText.alignment = RIGHT;

		comboText = new FlxText(FlxG.width * 0.7, 35, 0, "", 10);
		// scoreText.autoSize = false;
		comboText.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT);
		// scoreText.alignment = RIGHT;

		var scoreBG:Sprite = new Sprite(scoreText.x - 6, 0).makeGraphics(Std.int(FlxG.width * 0.35), 66, 0xFF000000);
		scoreBG.alpha = 0.6;
		add(scoreBG);

		diffText = new FlxText(scoreText.x + 220, scoreText.y + 42, 0, "", 16);
		diffText.font = scoreText.font;
		add(diffText);

		add(scoreText);
		add(maxAccText);
		add(comboText);

		changeSelection();
		changeDiff();

		// FlxG.sound.playMusic(Paths.music('title'), 0);
		// FlxG.sound.music.fadeIn(2, 0, 0.8);
		selector = new FlxText();

		selector.size = 40;
		selector.text = ">";
		// add(selector);

		var swag:Alphabet = new Alphabet(1, 0, "swag");

		// JUST DOIN THIS SHIT FOR TESTING!!!
		/* 
			var md:String = Markdown.markdownToHtml(Assets.getText('CHANGELOG.md'));

			var texFel:TextField = new TextField();
			texFel.width = FlxG.width;
			texFel.height = FlxG.height;
			// texFel.
			texFel.htmlText = md;

			FlxG.stage.addChild(texFel);

			// scoreText.textField.htmlText = md;

			trace(md);
		 */

		super.create();
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String, color:String)
	{
		songs.push(new SongMetadata(songName, weekNum, songCharacter, color));
	}

	public function addWeek(songs:Array<String>, weekNum:Int, ?songCharacters:Array<String>, ?color:Array<String>)
	{
		if (songCharacters == null)
			songCharacters = ['bf'];

		var num:Int = 0;
		for (song in songs)
		{
			addSong(song, weekNum, songCharacters[num], color[num]);

			if (songCharacters.length != 1)
				num++;
		}
	}

	override function update(elapsed:Float)
	{
		
		super.update(elapsed);

		Conductor.songPosition = FlxG.sound.music.time;

		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		bg.color = CoolUtil.smoothColorChange(bg.color, songs[curSelected].color, 0.045);


		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.4));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;

		scoreText.text = "BEST SCORE:" + lerpScore;



		lerpCombo = Math.floor(FlxMath.lerp(lerpCombo, intendedCombo, 0.4));

		if (Math.abs(lerpCombo - intendedCombo) <= 10)
			lerpCombo = intendedCombo;

		comboText.text = "BEST COMBO:" + lerpCombo;



		lerpMaxAcc = FlxMath.lerp(lerpMaxAcc, intendedMaxAcc, 0.4);

		if (Math.abs(lerpMaxAcc - intendedMaxAcc) <= 10)
			lerpMaxAcc = intendedMaxAcc;

		maxAccText.text = "AVERAGE ACCURACY:" + lerpMaxAcc + "%";

		var upP = controls.UP_PUI;
		var downP = controls.DOWN_PUI;
		var accepted = controls.ACCEPT;

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}

		if (controls.LEFT_PUI)
			changeDiff(-1);
		if (controls.RIGHT_PUI)
			changeDiff(1);

		if (controls.BACK)
		{
			FlxG.switchState(new MainMenuState());
		}
		curSelectedSongHaveFunkyDiff = 
		Assets.exists(Paths.json(songs[curSelected].songName.toLowerCase() + "/" + songs[curSelected].songName.toLowerCase() + "-funky"))
		 && 
		Assets.exists(Paths.instFunky(songs[curSelected].songName.toLowerCase()));
		
		if (accepted)
		{
			trace(curSelectedSongHaveFunkyDiff);
			trace(Paths.instFunky(songs[curSelected].songName.toLowerCase()));
			var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty);
			var poop2:String = songs[curSelected].songName.toLowerCase();
			var poop3:Int = songs[curSelected].week;
			var poop4:Int = curDifficulty;
			trace(poop);
			trace(poop2);
			trace(poop3);
			trace(poop4);

			
			

			PlayState.SONG = Song.loadFromJson(poop, poop2);
			#if desktop
			if(FileSystem.exists(Paths.json(poop2 + "/" + poop2 + "-events")))
				PlayState.EVENTS = EventSystemChart.loadFromJson(poop2 + "-events", poop2);
			else
			{
				PlayState.EVENTS = 
				{
					notes: []
				};
			}
			#else
			if(Assets.exists(Paths.json(poop2 + "/" + poop2 + "-events")))
				PlayState.EVENTS = EventSystemChart.loadFromJson(poop2 + "-events", poop2);
			else
			{
				PlayState.EVENTS = 
				{
					notes: []
				};
			}
			#end
			
			PlayState.isStoryMode = false;
			PlayState.storyDifficulty = poop4;
			PlayState.storyWeek = poop3;
			trace('CUR WEEK' + PlayState.storyWeek);
			
			PlayState.deathCounter = 0;
			CoolUtil.preloadImages(new PlayState());
			
		}
	}

	function changeDiff(change:Int = 0)
	{
		curDifficulty += change;

		maxDiff = 6;

		if (curDifficulty < 0)
			curDifficulty = maxDiff - 1;
		if (curDifficulty > maxDiff - 1)
			curDifficulty = 0;


		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		intendedMaxAcc = Highscore.getAcc(songs[curSelected].songName, curDifficulty);
		intendedCombo = Highscore.getCombo(songs[curSelected].songName, curDifficulty);
		#end
	
		switch (curDifficulty)
		{
			case 0:
				diffText.text = "< EASY >";
				diffString = "-easy";
			case 1:
				diffText.text = '< NORMAL >';
				diffString = "";
			case 2:
				diffText.text = "< HARD >";
				diffString = "-hard";
			case 3:
				diffText.text = "< HARD + >";
				diffString = "-hardplus";
			case 4:
				diffText.text = "< HARD ++ >";
				diffString = "-hardplusplus";
			case 5:
				diffText.text = "< TRADITIONAL >";
				diffString = "-trad";
			}
	}


	function changeSelection(change:Int = 0)
	{
		#if !switch
		// NGio.logEvent('Fresh');
		#end

		// NGio.logEvent('Fresh');
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;

		

		// selector.y = (70 * curSelected) + 30;

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		intendedMaxAcc = Highscore.getAcc(songs[curSelected].songName, curDifficulty);
		intendedCombo = Highscore.getCombo(songs[curSelected].songName, curDifficulty);
		// lerpScore = 0;
		#end

		#if PRELOAD_ALL
		//FlxG.sound.playMusic(Paths.inst(songs[curSelected].songName), 0);
		#end

		var bullShit:Int = 0;

		for (i in 0...iconArray.length)
		{
			iconArray[i].alpha = 0.6;
		}

		iconArray[curSelected].alpha = 1;

		for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
		curSelectedSongHaveFunkyDiff = Assets.exists(Paths.json(songs[curSelected].songName.toLowerCase() + "/" + songs[curSelected].songName.toLowerCase() + "-easy"));
		changeDiff(0);
	}
}

class SongMetadata
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";
	public var color:FlxColor = FlxColor.WHITE;

	public function new(song:String, week:Int, songCharacter:String, color:String)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
		this.color = FlxColor.fromString(color);
	}
}
