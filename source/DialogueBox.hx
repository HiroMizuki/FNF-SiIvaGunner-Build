package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.system.FlxSound;

using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;

	var curCharacter:String = '';

	var dialogueList:Array<String> = [];

	var rumble:FlxSound = new FlxSound().loadEmbedded(Paths.sound('hotline'));

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;

	var dropText:FlxText;
	var haveHand = true;
	var dadPortrait = true;

	public var finishThing:Void->Void;
	public var nextDialogueThing:Void->Void = null;
	public var skipDialogueThing:Void->Void = null;

	var portraitLeft:FlxSprite;
	var portraitMiddle:FlxSprite;
	var portraitRight:FlxSprite;

	var handSelect:FlxSprite;
	var bgFade:FlxSprite;

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();

		switch (Paths.formatToSongPath(PlayState.SONG.song))
		{
			default:
				FlxG.sound.playMusic(Paths.music('Lunchbox-' + ClientPrefs.lunchbox.toLowerCase().replace(' ', '-')), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'roses' | 'roses-(beta-mix)' | 'roses-(in-game-version)' | 'roses-(itchio-build)' | 'roses-(ost-version)':
				//nothing!!!!!!
			case 'thorns':
				FlxG.sound.playMusic(Paths.music('LunchboxGyigas'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'thorns-(beta-mix)':
				FlxG.sound.playMusic(Paths.music('LunchboxScary'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'ballistic':
				FlxG.sound.list.add(rumble);
				new FlxTimer().start(10, function(tmr:FlxTimer) {
					rumble.play(false, 5);
				});
				
				rumble.looped = true;
		}

		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFB3DFd8);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		add(bgFade);

		handSelect = new FlxSprite(1042, 590).loadGraphic(Paths.image('weeb/pixelUI/hand_textbox'));
		handSelect.setGraphicSize(Std.int(handSelect.width * PlayState.daPixelZoom * 0.9));
		handSelect.updateHitbox();
		handSelect.visible = false;

		new FlxTimer().start(0.83, function(tmr:FlxTimer)
		{
			bgFade.alpha += (1 / 5) * 0.7;
			if (bgFade.alpha > 0.7)
				bgFade.alpha = 0.7;
		}, 5);

		box = new FlxSprite(-20, 45);
		
		var hasDialog = false;
		switch (Paths.formatToSongPath(PlayState.SONG.song))
		{
			case 'senpai' | 'senpai-(beta-mix)':
				hasDialog = true;
				box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-pixel');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear instance 1', [4], "", 24);

			case 'wocky' | 'beathoven':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('dialogueBoxKapi');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear instance 1', [0], "", 24);
				haveHand = false;

			case 'senpai-(in-game-version)':
				hasDialog = true;
				box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-pixelHYPNO');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear instance 1', [4], "", 24);

			case 'roses':
				hasDialog = true;
				FlxG.sound.play(Paths.sound('ANGRY_TEXT_BOX'));
				box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-TB3');
				box.animation.addByPrefix('normalOpen', 'SENPAI ANGRY IMPACT SPEECH', 24, false);
				box.animation.addByIndices('normal', 'SENPAI ANGRY IMPACT SPEECH instance 1', [4], "", 24);
				dadPortrait = false;

			case 'roses-(beta-mix)':
				hasDialog = true;
				FlxG.sound.play(Paths.sound('ANGRY_TEXT_BOX'));
				box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-willSmith');
				box.animation.addByPrefix('normalOpen', 'SENPAI ANGRY IMPACT SPEECH', 24, false);
				box.animation.addByIndices('normal', 'SENPAI ANGRY IMPACT SPEECH instance 1', [4], "", 24);
				dadPortrait = false;

			case 'roses-(in-game-version)' | 'roses-(itchio-build)':
				hasDialog = true;
				FlxG.sound.play(Paths.sound('ANGRY_TEXT_BOX'));
				box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-senpaiMad');
				box.animation.addByPrefix('normalOpen', 'SENPAI ANGRY IMPACT SPEECH', 24, false);
				box.animation.addByIndices('normal', 'SENPAI ANGRY IMPACT SPEECH instance 1', [4], "", 24);
				dadPortrait = false;

			case 'roses-(ost-version)':
				hasDialog = true;
				FlxG.sound.play(Paths.sound('ANGRY_SKELETRON_BOX'));
				box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-terraria');
				box.animation.addByPrefix('normalOpen', 'SENPAI ANGRY IMPACT SPEECH', 24, false);
				box.animation.addByIndices('normal', 'SENPAI ANGRY IMPACT SPEECH instance 1', [4], "", 24);
				dadPortrait = false;

			case 'thorns' | 'thorns-(beta-mix)':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-evil');
				box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
				box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
				box.animation.addByIndices('normal', 'Spirit Textbox spawn instance 1', [11], "", 24);
				dadPortrait = false;

				var face:FlxSprite = new FlxSprite(320, 170);

				switch (Paths.formatToSongPath(PlayState.SONG.song))
				{
					case 'thorns':
						face.loadGraphic(Paths.image('weeb/gariwaldFaceForward'));
						face.setGraphicSize(Std.int(face.width * 6));
					
					case 'thorns-(beta-mix)':
						box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-mother');
						box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
						box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
						box.animation.addByIndices('normal', 'Spirit Textbox spawn instance 1', [11], "", 24);
					
						face.loadGraphic(Paths.image('weeb/giygasFaceForward'));
						face.setGraphicSize(Std.int(face.width * 6));

						handSelect.loadGraphic(Paths.image('weeb/pixelUI/arrow_textbox'));
				}

				add(face);
			
			case 'lo-fight' | 'overhead' | 'ballistic' | 'ballistic-(beta-mix)':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('speech_bubble_talking', 'shared');
				box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);
				box.animation.addByIndices('normal', 'speech bubble normal', [11], "", 24);
				box.antialiasing = ClientPrefs.globalAntialiasing;
				box.y = FlxG.height - 285;
				box.x = 20;
				haveHand = false;
		}

		this.dialogueList = dialogueList;
		
		if (!hasDialog)
			return;
		
		switch(Paths.formatToSongPath(PlayState.SONG.song)) {
			default:
				portraitLeft = new FlxSprite(-20, 40);
				portraitLeft.frames = Paths.getSparrowAtlas('weeb/senpaiPortrait');
				portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
				portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
				portraitLeft.updateHitbox();
				portraitLeft.scrollFactor.set();
				add(portraitLeft);
				portraitLeft.visible = false;
				portraitLeft.screenCenter(X);

			case 'senpai-(in-game-version)':
				portraitLeft = new FlxSprite(-20, 40);
				portraitLeft.frames = Paths.getSparrowAtlas('weeb/hypiiPortrait');
				portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
				portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
				portraitLeft.updateHitbox();
				portraitLeft.scrollFactor.set();
				add(portraitLeft);
				portraitLeft.visible = false;
				portraitLeft.screenCenter(X);

			case 'lunchbox-in-game-version':
				portraitLeft = new FlxSprite(-20, 40);
				portraitLeft.frames = Paths.getSparrowAtlas('weeb/wrrPortrait');
				portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
				portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
				portraitLeft.updateHitbox();
				portraitLeft.scrollFactor.set();
				add(portraitLeft);
				portraitLeft.visible = false;
				portraitLeft.screenCenter(X);

			case 'lo-fight':
				portraitLeft = new FlxSprite(200, FlxG.height - 525);
				portraitLeft.frames = Paths.getSparrowAtlas('whittyPort');
				portraitLeft.animation.addByPrefix('enter', 'Whitty Portrait Normal instance', 24, false);
				portraitLeft.updateHitbox();
				portraitLeft.scrollFactor.set();
				add(portraitLeft);
				portraitLeft.visible = false;

			case 'overhead':
				portraitLeft = new FlxSprite(200, FlxG.height - 525);
				portraitLeft.frames = Paths.getSparrowAtlas('marsPort');
				portraitLeft.animation.addByPrefix('enter', 'Whitty Portrait Agitated instance', 24, false);
				portraitLeft.updateHitbox();
				portraitLeft.scrollFactor.set();
				add(portraitLeft);
				portraitLeft.visible = false;

			case 'ballistic':
				portraitLeft = new FlxSprite(200, FlxG.height - 525);
				portraitLeft.frames = Paths.getSparrowAtlas('whittyMiamiPort');
				portraitLeft.animation.addByPrefix('enter', 'Whitty Portrait Crazy instance', 24, true);
				portraitLeft.setGraphicSize(Std.int(portraitLeft.width * 0.8));
				portraitLeft.updateHitbox();
				portraitLeft.scrollFactor.set();
				add(portraitLeft);
				portraitLeft.visible = false;
		}

		switch(Paths.formatToSongPath(PlayState.SONG.song)) {
			default:
				portraitRight = new FlxSprite(0, 40);
				portraitRight.frames = Paths.getSparrowAtlas('weeb/bfPortrait');
				portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
				portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.9));
				portraitRight.updateHitbox();
				portraitRight.scrollFactor.set();
				add(portraitRight);
				portraitRight.visible = false;

			case 'roses':
				portraitRight = new FlxSprite(0, 40);
				portraitRight.frames = Paths.getSparrowAtlas('weeb/GM08Portrait');
				portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
				portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.9));
				portraitRight.updateHitbox();
				portraitRight.scrollFactor.set();
				add(portraitRight);
				portraitRight.visible = false;

			case 'roses-(ost-version)':
				portraitRight = new FlxSprite(0, 40);
				portraitRight.frames = Paths.getSparrowAtlas('weeb/bfTRRPortrait');
				portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
				portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.9));
				portraitRight.updateHitbox();
				portraitRight.scrollFactor.set();
				add(portraitRight);
				portraitRight.visible = false;

			case 'senpai-(in-game-version)':
				portraitRight = new FlxSprite(0, 40);
				portraitRight.frames = Paths.getSparrowAtlas('weeb/bfSquisherZPortrait');
				portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
				portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.9));
				portraitRight.updateHitbox();
				portraitRight.scrollFactor.set();
				add(portraitRight);
				portraitRight.visible = false;
		
			case 'lo-fight' | 'overhead' | 'ballistic-(beta-mix)':
				portraitRight = new FlxSprite(800, FlxG.height - 489);
				portraitRight.frames = Paths.getSparrowAtlas('boyfriendPort');
				portraitRight.animation.addByPrefix('enter', 'BF Portrait Enter', 24, false);
				portraitRight.updateHitbox();
				portraitRight.scrollFactor.set();
				add(portraitRight);
				portraitRight.visible = false;

			case 'ballistic':
				portraitRight = new FlxSprite(800, FlxG.height - 459);
				portraitRight.frames = Paths.getSparrowAtlas('boyfriendMiamiPort');
				portraitRight.animation.addByPrefix('enter', 'BF portrait enter instance', 24, true);
				portraitRight.setGraphicSize(Std.int(portraitRight.width * 0.8));
				portraitRight.updateHitbox();
				portraitRight.scrollFactor.set();
				add(portraitRight);
				portraitRight.visible = false;
		}

		box.animation.play('normalOpen');			
		box.updateHitbox();
		add(box);

		box.screenCenter(X);

		if (haveHand)
			add(handSelect);

		if (!talkingRight)
		{
			// box.flipX = true;
		}

		dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
		dropText.font = 'Pixel Arial 11 Bold';
		dropText.color = 0xFFD89494;

		swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
		swagDialogue.font = 'Pixel Arial 11 Bold';
		swagDialogue.color = 0xFF3F2021;

		switch (Paths.formatToSongPath(PlayState.SONG.song))
		{
			case 'lo-fight' | 'overhead' | 'ballistic':
				dropText.font = 'VCR OSD Mono';
				swagDialogue.font = 'VCR OSD Mono';
		}

		switch (Paths.formatToSongPath(PlayState.SONG.song)) {
			case 'ballistic':
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('ballistic'), 0.6)];
			case 'lo-fight' | 'overhead':
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('whitty'), 0.6)];
			default:
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
		}

		add(dropText);
		add(swagDialogue);
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;
	var dialogueEnded:Bool = false;

	override function update(elapsed:Float)
	{
		// HARD CODING CUZ IM STUPDI
		switch (Paths.formatToSongPath(PlayState.SONG.song)) {
			case 'roses':
				portraitLeft.visible = false;
			case 'thorns':
				portraitLeft.visible = false;
				swagDialogue.color = FlxColor.WHITE;
				dropText.color = FlxColor.BLACK;
		}

		dropText.text = swagDialogue.text;

		if (box.animation.curAnim != null)
		{
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
			{
				box.animation.play('normal');
				dialogueOpened = true;
			}
		}

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if(PlayerSettings.player1.controls.ACCEPT)
		{
			if (dialogueEnded)
			{
				if(Paths.formatToSongPath(PlayState.SONG.song).startsWith('lunchbox')) {
					MusicBeatState.switchState(new options.OptionsState());
					FlxG.sound.playMusic(Paths.music(TitleState.titleSong));
				}
				
				if (dialogueList[1] == null && dialogueList[0] != null)
				{
					if (!isEnding)
					{
						isEnding = true;
						FlxG.sound.play(Paths.sound('clickText'), 0.8);	

						switch (Paths.formatToSongPath(PlayState.SONG.song)) {
							default:
								FlxG.sound.music.fadeOut(1.5, 0);
							case 'ballistic':
								rumble.fadeOut();
						}

						new FlxTimer().start(0.2, function(tmr:FlxTimer)
						{
							box.alpha -= 1 / 5;
							bgFade.alpha -= 1 / 5 * 0.7;
							portraitLeft.visible = false;
							portraitRight.visible = false;
							swagDialogue.alpha -= 1 / 5;
							handSelect.alpha -= 1 / 5;
							dropText.alpha = swagDialogue.alpha;
						}, 5);

						new FlxTimer().start(1.5, function(tmr:FlxTimer)
						{
							finishThing();
							kill();
							trace('dialogue ended');
						});
					}
				}
				else
				{
					dialogueList.remove(dialogueList[0]);
					startDialogue();
					FlxG.sound.play(Paths.sound('clickText'), 0.8);
				}
			}
			else if (dialogueStarted)
			{
				FlxG.sound.play(Paths.sound('clickText'), 0.8);
				swagDialogue.skip();
				
				if(skipDialogueThing != null) {
					skipDialogueThing();
				}
			}
		}
		
		super.update(elapsed);
	}

	var isEnding:Bool = false;

	function startDialogue():Void
	{
		cleanDialog();
		// var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[0], false, true);
		// dialogue = theDialog;
		// add(theDialog);

		// swagDialogue.text = ;
		swagDialogue.resetText(dialogueList[0]);
		swagDialogue.start(0.04, true);
		swagDialogue.completeCallback = function() {
			handSelect.visible = true;
			dialogueEnded = true;
		};

		handSelect.visible = false;
		dialogueEnded = false;
		switch (curCharacter)
		{
			case 'dad':
				portraitRight.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.visible = dadPortrait;
					portraitLeft.animation.play('enter');
					switch (Paths.formatToSongPath(PlayState.SONG.song)) {
						case 'ballistic':
							swagDialogue.sounds = [FlxG.sound.load(Paths.sound('ballistic'), 0.6)];
						case 'lo-fight' | 'overhead':
							swagDialogue.sounds = [FlxG.sound.load(Paths.sound('whitty'), 0.6)];
					}
				}
			case 'bf':
				portraitLeft.visible = false;
				if (!portraitRight.visible)
				{
					portraitRight.visible = true;
					portraitRight.animation.play('enter');
					swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
				}
		}
		if(nextDialogueThing != null) {
			nextDialogueThing();
		}
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();
	}
}
