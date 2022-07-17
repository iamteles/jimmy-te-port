package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.util.FlxColor;

using StringTools;

class Character extends Sprite
{
	public var animOffsets:Map<String, Array<Dynamic>>;
	public var debugMode:Bool = false;

	public var isPlayer:Bool = false;
	public var curCharacter:String = 'bf';

	public var holdTimer:Float = 0;
	
	public var noteSkin:String = "";

	public var healthBarColor:FlxColor = FlxColor.GRAY;

	public var animState:String = "";

	public function new(x:Float, y:Float, ?character:String = "bf", ?isPlayer:Bool = false)
	{
		super(x, y);

		animOffsets = new Map<String, Array<Dynamic>>();
		curCharacter = character;
		this.isPlayer = isPlayer;

		var tex:FlxAtlasFrames;
		antialiasing = true;

		switch (curCharacter)
		{
			case 'gf':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('characters/GF_ass_sets no speakers');
				frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('danceLeftH', 'GF Dancing Beat happy0', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRightH', 'GF Dancing Beat happy0', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('danceLeftS', 'GF Dancing Beat sad0', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRightS', 'GF Dancing Beat sad0', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);
				healthBarColor.setRGB(165, 0, 77, 255);
				loadOffsetFile("gf");

				playAnim('danceRight');

			case 'gf-pixel':
				tex = Paths.getSparrowAtlas('characters/gfPixel');
				frames = tex;
				animation.addByIndices('singUP', 'GF IDLE', [2], "", 24, false);
				animation.addByIndices('danceLeft', 'GF IDLE', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF IDLE', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				loadOffsetFile(curCharacter);
				healthBarColor.setRGB(165, 0, 77, 255);
				playAnim('danceRight');

				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				updateHitbox();
				antialiasing = false;

			case 'dad':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/DADDY_DEAREST');
				frames = tex;
				animation.addByPrefix('idle', 'Dad idle dance', 24, false);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24, false);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24, false);
				healthBarColor.setRGB(175, 102, 206, 255);
				loadOffsetFile(curCharacter);

				playAnim('idle');
			
			case 'jimmy':
				// jimby
				tex = Paths.getSparrowAtlas('characters/Jimmy_ASSets');
				frames = tex;
				animation.addByPrefix('idle', 'jimmyidle0', 24, false);
				animation.addByPrefix('singUP', 'jimmyup0', 24, false);
				animation.addByPrefix('singRIGHT', 'jimmy right0', 24, false);
				animation.addByPrefix('singDOWN', 'jimmy down0', 24, false);
				animation.addByPrefix('singLEFT', 'jimmyleft0', 24, false);
				healthBarColor.setRGB(255, 79, 79, 255);
				loadOffsetFile(curCharacter);

				playAnim('idle');

			case 'jimmyPLAYER':
				// jimby
				tex = Paths.getSparrowAtlas('characters/Jimmy_ASSets');
				frames = tex;
				animation.addByPrefix('idle', 'jimmyidle0', 24, false);
				animation.addByPrefix('singUP', 'jimmyup0', 24, false);
				animation.addByPrefix('singRIGHT', 'jimmyleft0', 24, false);
				animation.addByPrefix('singDOWN', 'jimmy down0', 24, false);
				animation.addByPrefix('singLEFT', 'jimmy right0', 24, false);
				healthBarColor.setRGB(255, 79, 79, 255);
				loadOffsetFile(curCharacter);

				playAnim('idle');

			case 'ylyl':
				// jimby
				tex = Paths.getSparrowAtlas('characters/jimby if he real');
				frames = tex;
				animation.addByPrefix('idle', 'jimmy idle0', 24, false);
				animation.addByPrefix('singUP', 'jimmy up note0', 24, false);
				animation.addByPrefix('singRIGHT', 'jimmy right note0', 24, false);
				animation.addByPrefix('singDOWN', 'jimmy down note0', 24, false);
				animation.addByPrefix('singLEFT', 'jimmy left note0', 24, false);
				healthBarColor.setRGB(148, 47, 255, 255);
				loadOffsetFile(curCharacter);

				playAnim('idle');

			case 'jeffgone':
				// jif
				tex = Paths.getSparrowAtlas('characters/Jeffry Gone');
				frames = tex;
				animation.addByPrefix('idle', 'Jeffry Idle', 24, false);
				animation.addByPrefix('singUP', 'Jeffry Up', 24, false);
				animation.addByPrefix('singRIGHT', 'Jeffry Right', 24, false);
				animation.addByPrefix('singDOWN', 'Jeffry Down0', 24, false);
				animation.addByPrefix('singLEFT', 'Jeffry Left', 24, false);
				animation.addByPrefix('scared', 'Jeffry Laugh', 24, false);
				healthBarColor.setRGB(255, 255, 255, 255);
				loadOffsetFile(curCharacter);

				playAnim('idle');

			case 'bryce':
				tex = Paths.getSparrowAtlas('characters/Bryce_assets');
				frames = tex;
				animation.addByPrefix('idle', 'BRYCE IDLE', 24, false);
				animation.addByPrefix('singUP', 'BRYCE north', 24, false);
				animation.addByPrefix('singRIGHT', 'BRYCE right0', 24, false);
				animation.addByPrefix('singDOWN', 'BRYCE down0', 24, false);
				animation.addByPrefix('singLEFT', 'BRYCE Left0', 24, false);
				healthBarColor.setRGB(0, 97, 255, 255);
				loadOffsetFile(curCharacter);

				playAnim('idle');

			case 'maid':
				tex = Paths.getSparrowAtlas('characters/jimmyMaid');
				frames = tex;
				animation.addByPrefix('idle', 'Maid Idle', 24, false);
				animation.addByPrefix('singUP', 'Maid Up', 24, false);
				animation.addByPrefix('singRIGHT', 'Maid Right', 24, false);
				animation.addByPrefix('singDOWN', 'Maid Down', 24, false);
				animation.addByPrefix('singLEFT', 'Maid Left', 24, false);
				healthBarColor.setRGB(255, 133, 133, 255);
				loadOffsetFile(curCharacter);

				playAnim('idle');
			case 'blaze':
				tex = Paths.getSparrowAtlas('characters/Blaze');
				frames = tex;
				animation.addByPrefix('idle', 'Blaze Idle', 24, false);
				animation.addByPrefix('singUP', 'Blaze Up', 24, false);
				animation.addByPrefix('singRIGHT', 'Blaze Right', 24, false);
				animation.addByPrefix('singDOWN', 'Blaze Down', 24, false);
				animation.addByPrefix('singLEFT', 'Blaze Left', 24, false);
				healthBarColor.setRGB(255, 255, 255, 255);
				loadOffsetFile(curCharacter);

				playAnim('idle');

			case 'chara':
				tex = Paths.getSparrowAtlas('characters/Chara');
				frames = tex;
				animation.addByPrefix('idle', 'Chara Idle', 24, false);
				animation.addByPrefix('singUP', 'Chara Up', 24, false);
				animation.addByPrefix('singRIGHT', 'Chara Right', 24, false);
				animation.addByPrefix('singDOWN', 'Chara Down', 24, false);
				animation.addByPrefix('singLEFT', 'Chara Left', 24, false);
				healthBarColor.setRGB(180, 255, 255, 255);
				loadOffsetFile(curCharacter);

				playAnim('idle');

			case 'corruption':
				tex = Paths.getSparrowAtlas('characters/Corruption');
				frames = tex;
				animation.addByPrefix('idle', 'Corruption Idle', 24, false);
				animation.addByPrefix('singUP', 'Corruption Up', 24, false);
				animation.addByPrefix('singRIGHT', 'Corruption Right', 24, false);
				animation.addByPrefix('singDOWN', 'Corruption Down', 24, false);
				animation.addByPrefix('singLEFT', 'Corruption Left', 24, false);
				healthBarColor.setRGB(255, 255, 255, 255);
				loadOffsetFile(curCharacter);

				playAnim('idle');

			case 'crunchy':
				tex = Paths.getSparrowAtlas('characters/Crunchy');
				frames = tex;
				animation.addByPrefix('idle', 'Teater Idle', 24, false);
				animation.addByPrefix('singUP', 'Teater Up', 24, false);
				animation.addByPrefix('singRIGHT', 'Teater Right', 24, false);
				animation.addByPrefix('singDOWN', 'Teater Down', 24, false);
				animation.addByPrefix('singLEFT', 'Teater Left', 24, false);
				healthBarColor.setRGB(255, 255, 255, 255);
				loadOffsetFile(curCharacter);

				playAnim('idle');

			case 'parallax':
				tex = Paths.getSparrowAtlas('characters/Parallax');
				frames = tex;
				animation.addByPrefix('idle', 'Parallax Idle', 24, false);
				animation.addByPrefix('singUP', 'Parallax Up', 24, false);
				animation.addByPrefix('singRIGHT', 'Parallax Right', 24, false);
				animation.addByPrefix('singDOWN', 'Parallax Down', 24, false);
				animation.addByPrefix('singLEFT', 'Parallax Left', 24, false);
				healthBarColor.setRGB(255, 255, 255, 255);
				loadOffsetFile(curCharacter);

				playAnim('idle');

			case 'mysterymonkey':
				tex = Paths.getSparrowAtlas('characters/mystery_monkey');
				frames = tex;
				animation.addByPrefix('idle', 'Its Too Late0', 24, false);
				animation.addByPrefix('singUP', 'UpSingPose', 24, false);
				animation.addByPrefix('singRIGHT', 'RightSingPose', 24, false);
				animation.addByPrefix('singDOWN', 'DownSingPose', 24, false);
				animation.addByPrefix('singLEFT', 'LeftSingPose', 24, false);
				animation.addByPrefix('singUPalt', 'AltUpSing', 24, false);
				animation.addByPrefix('singRIGHTalt', 'AltRightSing', 24, false);
				animation.addByPrefix('singDOWNalt', 'ALTDownsing', 24, false);
				animation.addByPrefix('singLEFTalt', 'AltLeftSing', 24, false);
				healthBarColor.setRGB(255, 133, 133, 255);
				loadOffsetFile('mm');

				playAnim('idle');

			case 'chickfila':
				tex = Paths.getSparrowAtlas('characters/bfChickFilA');
				frames = tex;
				animation.addByPrefix('idle', 'Suit BF Idle', 24, false);
				animation.addByPrefix('singUP', 'Suit BF Up', 24, false);
				animation.addByPrefix('singRIGHT', 'Suit BF Right', 24, false);
				animation.addByPrefix('singDOWN', 'Suit BF Down', 24, false);
				animation.addByPrefix('singLEFT', 'Suit BF Left', 24, false);
				healthBarColor.setRGB(49, 176, 209, 255);

				//flipX = true;
				
				loadOffsetFile(curCharacter);

				playAnim('idle');

			case 'gfMaid':
				tex = Paths.getSparrowAtlas('characters/gfMaid');
				frames = tex;
				animation.addByIndices('danceLeft', 'Maid GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'Maid GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				healthBarColor.setRGB(165, 0, 77, 255);
				loadOffsetFile(curCharacter);
				playAnim('danceRight');
				
			case 'pico':
				tex = Paths.getSparrowAtlas('characters/Pico_FNF_assetss');
				frames = tex;
				animation.addByPrefix('idle', "Pico Idle Dance", 24, false);
				animation.addByPrefix('singUP', 'pico Up note0', 24, false);
				animation.addByPrefix('singDOWN', 'Pico Down Note0', 24, false);
				// Need to be flipped! REDO THIS LATER!
				animation.addByPrefix('singLEFT', 'Pico Note Right0', 24, false);
				animation.addByPrefix('singRIGHT', 'Pico NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'Pico NOTE LEFT miss', 24, false);
				animation.addByPrefix('singLEFTmiss', 'Pico Note Right Miss', 24, false);
				
				animation.addByPrefix('singUPmiss', 'pico Up note miss', 24, false);
				animation.addByPrefix('singDOWNmiss', 'Pico Down Note MISS', 24, false);
				animation.addByPrefix('spinMic', 'PICO SPIN GUN', 24, false);
				healthBarColor.setRGB(183, 216, 85, 255);
				loadOffsetFile(curCharacter);
				
				playAnim('idle');

				flipX = true;

			case 'bf':
				var tex = Paths.getSparrowAtlas('characters/BOYFRIEND');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);
				animation.addByPrefix('spinMic', 'BF MIC SPIN', 24, false);
				animation.addByPrefix('scared', 'BF idle shaking', 24);
				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				loadOffsetFile(curCharacter);

				healthBarColor.setRGB(49, 176, 209, 255);
	

				playAnim('idle');

				flipX = true;
			case 'jeffry-bf':
				var tex = Paths.getSparrowAtlas('characters/Jeffry_BF');
				frames = tex;
				animation.addByPrefix('idle', 'GoneSlayerBF idle0', 24, false);
				animation.addByPrefix('singUP', 'GoneSlayerBF up0', 24, false);
				animation.addByPrefix('singDOWN', 'GoneSlayerBF down0', 24, false);
				animation.addByPrefix('singUPmiss', 'GoneSlayerBF missup0', 24, false);
				animation.addByPrefix('singDOWNmiss', 'GoneSlayerBF missdown0', 24, false);
				animation.addByPrefix('singLEFT', 'GoneSlayerBF left0', 24, false);
				animation.addByPrefix('singRIGHT', 'GoneSlayerBF right0', 24, false);
				animation.addByPrefix('singLEFTmiss', 'GoneSlayerBF missleft0', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'GoneSlayerBF missright0', 24, false);
				loadOffsetFile(curCharacter);

				healthBarColor.setRGB(76, 129, 229, 255);
	

				playAnim('idle');

				//flipX = true;
			case 'bfF':
				var tex = Paths.getSparrowAtlas('characters/BOYFRIEND');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);
				animation.addByPrefix('spinMic', 'BF MIC SPIN', 24, false);
				animation.addByPrefix('scared', 'BF idle shaking', 24);
				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE LEFT MISS', 24, false);
				loadOffsetFile(curCharacter);

				healthBarColor.setRGB(49, 176, 209, 255);
	

				playAnim('idle');

				//flipX = true;

		}

		dance();

		if (isPlayer)
		{
			switch (curCharacter)
			{
				case "chickfila" | "jeffry-bf":
					//do nothin
				case "bf":
					flipX = !flipX;
				case "jimmyPLAYER":
					flipX = !flipX;
				default:
				{	
					flipX = !flipX;
					// var animArray
					var oldRight = animation.getByName('singRIGHT').frames;
					animation.getByName('singRIGHT').frames = animation.getByName('singLEFT').frames;
					animation.getByName('singLEFT').frames = oldRight;



					// IF THEY HAVE MISS ANIMATIONS??
					if (animation.getByName('singRIGHTmiss') != null)
					{
						var oldMiss = animation.getByName('singRIGHTmiss').frames;
						animation.getByName('singRIGHTmiss').frames = animation.getByName('singLEFTmiss').frames;
						animation.getByName('singLEFTmiss').frames = oldMiss;
					}
				}
			}

		}
		else
		{
			if (curCharacter.startsWith('bf'))
			{
				// var animArray
				var oldRight = animation.getByName('singRIGHT').frames;
				animation.getByName('singRIGHT').frames = animation.getByName('singLEFT').frames;
				animation.getByName('singLEFT').frames = oldRight;



				// IF THEY HAVE MISS ANIMATIONS??
				if (animation.getByName('singRIGHTmiss') != null)
				{
					var oldMiss = animation.getByName('singRIGHTmiss').frames;
					animation.getByName('singRIGHTmiss').frames = animation.getByName('singLEFTmiss').frames;
					animation.getByName('singLEFTmiss').frames = oldMiss;
				}
			}
		}
	}

	function loadOffsetFile(a:String) 
	{
        var g:Array<String> = CoolUtil.coolTextFile(Paths.txtOffsets("characters/offsets/" + a + "Offsets"));
        for (b in 0 ... g.length) 
        {
        	var c:String = g[b];
        	var j:Array<String> = c.split(" ");
        	addOffset(j[0], Std.parseInt(j[1]), Std.parseInt(j[2]));
        }
        
    }
	override function update(elapsed:Float)
	{

		if (animation.curAnim.name.startsWith('sing'))
		{
			holdTimer += elapsed;
		}
		else
			holdTimer = 0;
		if (holdTimer > Conductor.stepCrochet * 4 * 0.001)
		{
			if (animation.curAnim.name.startsWith('sing') && !animation.curAnim.name.endsWith('miss') && animation.curAnim.curFrame >= 10 && animation.curAnim.name != "spinMic" || (animation.curAnim.name == "spinMic" && animation.curAnim.finished))
				dance();
		}
		

		switch (curCharacter)
		{
			case 'gf':
				if (animation.curAnim.name == 'hairFall' && animation.curAnim.finished)
					playAnim('danceRight');
		}

		super.update(elapsed);
	}

	private var danced:Bool = false;

	/**
	 * FOR GF DANCING SHIT
	 */
	public function dance()
	{
		if (!debugMode)
		{
			switch (curCharacter)
			{
				case 'gf':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;
						if (danced)
							playAnim('danceRight' + animState, true);
						else
							playAnim('danceLeft' + animState, true);
					}

				case 'gf-christmas' | 'gfMaid':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight', true);
						else
							playAnim('danceLeft', true);
					}

				case 'gf-car':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight', true);
						else
							playAnim('danceLeft', true);
					}
				case 'gf-pixel':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight', true);
						else
							playAnim('danceLeft', true);
					}

				case 'spooky':
					danced = !danced;

					if (danced)
						playAnim('danceRight', true);
					else
						playAnim('danceLeft', true);
				default:
					playAnim('idle', true);
			}
		}
	}

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		if(animation.getByName(AnimName) == null && AnimName.startsWith("sing") && AnimName.endsWith("-alt"))
			AnimName = AnimName.replace("-alt", "");
		animation.play(AnimName, Force, Reversed, Frame);

		var daOffset = animOffsets.get(AnimName);
		if (animOffsets.exists(AnimName))
		{
			offset.set(daOffset[0], daOffset[1]);
		}
		else
			offset.set(0, 0);

		

		if (curCharacter == 'gf')
		{
			if (AnimName == 'singLEFT')
			{
				danced = true;
			}
			else if (AnimName == 'singRIGHT')
			{
				danced = false;
			}

			if (AnimName == 'singUP' || AnimName == 'singDOWN')
			{
				danced = !danced;
			}
		}
	}

	public function addOffset(name:String, x:Float = 0, y:Float = 0)
	{
		animOffsets[name] = [x, y];
	}
}
