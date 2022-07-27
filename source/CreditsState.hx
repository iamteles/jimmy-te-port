package;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import lime.utils.Assets;

using StringTools;

class CreditsState extends MusicBeatState
{
	var curSelected:Int = 1;

	private var grpOptions:FlxTypedGroup<Alphabet>;
	private var iconArray:Array<AttachedSprite> = [];

	private static var creditsStuff:Array<Dynamic> = [ //Name - Icon name - Description - Link - BG Color
		['YLYL Funkin Team'],
		['CrunchyNG', 'CrunchyNG', 'Lead director, composer and artist. "I fucking hate fnf /pos"', 'https://twitter.com/NgCrunchy',	0xFFC30085],
		['teles', 'teles', 'Lead coder. "IT KEEPS HAPPENING"', 'https://twitter.com/itzteles_aa', 0xFFC30085],
		['Haminaya', 'haminaya', 'Composer. "Its all about love"', 'https://www.youtube.com/channel/UCDVlFnVUHW-Cw1obDZgFW-w', 0xFFC30085],
		['Corruption', 'Corruption', 'Artist, Animator, Charter, Musician. "You have 24 hours, start running"', 'https://twitter.com/file_corruption', 0xFFC30085],
		['Parallax', 'Parallax', 'Charter. "FUNK CITY SUCKS"', 'https://www.youtube.com/channel/UCwta8MCs7Sld8q7WSMEHZRw', 0xFFC30085],
		['CharaWhy', 'Chara', 'Musician. "Balls"', 'https://www.youtube.com/channel/UCiEUXX_YWxVevGxSRYCM5Cw', 0xFFC30085],
		['Diamond', 'diamond', 'Charter. "I just had diarrhea"', 'https://twitter.com/DiamonDiglett42', 0xFFC30085],
		['YaBoiJustin', 'justin', 'Animator, charter. "I am Jeffrey Gones father"', 'https://mobile.twitter.com/yaboijustingg', 0xFFC30085],
		['GhostMakesArt', 'ghost', 'Concept artist, moral support. "You ever wanna pop your eardrums with a thumbtack?"', 'https://scratch.mit.edu/users/SonicBoi39/', 0xFFC30085],
		['Blaze', 'blaze', 'Charter. "The"', 'https://www.youtube.com/channel/UCxHjDEbm-RWWr_PSodXAZbg', 0xFFC30085],
		['Fidy50', 'fidy50', 'Charter. "I have become tired of charting end my pain"', ' https://twitter.com/50Fidy', 0xFFC30085],
		['Santry 999', 'Santry', 'Concept artist. "The Force shouldnt be called an ability, because everyone would be able to use it"', 'https://twitter.com/SanticraftMagm1?t=t_q0mOb7xQo8GuClDD893w&s=09', 0xFFC30085],
		['Ekuyomi', 'eku',		'Charter.',				'https://www.youtube.com/channel/UC9_iUObu1h3ec779vsPsc6w/featured',		0xFFC30085],
		['BCTIX', 'bctix', 'Charter, coder.', '',	0xFFC30085],
		['niffirg', 'niffirg', 'Charter.', 'https://twitter.com/n1ffirg',	0xFFC30085],
		['Syembol', 'who', 'Artist.', '',	0xFFC30085],
		['Noodles', 'who', 'Charter.', '',	0xFFC30085],
		['Pandaity', 'who', 'Coder.', 'https://www.youtube.com/channel/UCgFcmR6XRkmzvJ-5KfkcAUA', 0xFFC30085],
		['Ooum', 'who', 'Charter.', 'https://twitter.com/cacdastral',	0xFFC30085],
		['Z_Liv', 'who', 'Charter.', '',	0xFFC30085]
	];

	var bg:FlxSprite;
	var descText:FlxText;
	var intendedColor:Int;
	var colorTween:FlxTween;

	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		add(bg);

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		for (i in 0...creditsStuff.length)
		{
			var isSelectable:Bool = !unselectableCheck(i);
			var optionText:Alphabet = new Alphabet(0, 70 * i, creditsStuff[i][0], !isSelectable, false);
			optionText.isMenuItem = true;
			optionText.screenCenter(X);
			if(isSelectable) {
				optionText.x -= 70;
			}
			//optionText.forceX = optionText.x;
			//optionText.yMult = 90;
			optionText.targetY = i;
			grpOptions.add(optionText);

			if(isSelectable) {
				var icon:AttachedSprite = new AttachedSprite('credits/' + creditsStuff[i][1]);
				icon.xAdd = optionText.width + 10;
				icon.sprTracker = optionText;
	
				// using a FlxGroup is too much fuss!
				iconArray.push(icon);
				add(icon);
			}
		}

		descText = new FlxText(50, 600, 1180, "", 32);
		descText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		descText.scrollFactor.set();
		descText.borderSize = 2.4;
		add(descText);

		bg.color = creditsStuff[curSelected][4];
		intendedColor = bg.color;
		changeSelection();
		super.create();
	}

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		var upP = controls.UP_PUI;
		var downP = controls.DOWN_PUI;

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}

		if (controls.BACK)
		{
			if(colorTween != null) {
				colorTween.cancel();
			}
			FlxG.sound.play(Paths.sound('cancelMenu'));
			FlxG.switchState(new MainMenuState());
		}
		if(controls.ACCEPT) {
			FlxG.openURL(creditsStuff[curSelected][3]);
		}
		super.update(elapsed);
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		do {
			curSelected += change;
			if (curSelected < 0)
				curSelected = creditsStuff.length - 1;
			if (curSelected >= creditsStuff.length)
				curSelected = 0;
		} while(unselectableCheck(curSelected));

		var newColor:Int = creditsStuff[curSelected][4];
		if(newColor != intendedColor) {
			if(colorTween != null) {
				colorTween.cancel();
			}
			intendedColor = newColor;
			colorTween = FlxTween.color(bg, 1, bg.color, intendedColor, {
				onComplete: function(twn:FlxTween) {
					colorTween = null;
				}
			});
		}

		var bullShit:Int = 0;

		for (item in grpOptions.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			if(!unselectableCheck(bullShit-1)) {
				item.alpha = 0.6;
				if (item.targetY == 0) {
					item.alpha = 1;
				}
			}
		}
		descText.text = creditsStuff[curSelected][2];
	}

	private function unselectableCheck(num:Int):Bool {
		return creditsStuff[num].length <= 1;
	}
}
