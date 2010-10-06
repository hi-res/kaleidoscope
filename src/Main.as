package {
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;

	/**
	 * image sequence from:
	 * http://insideinsides.blogspot.com/
	 * 
	 * includes code originally from:
	 * Petri Leskinen 15.1.2009 Espoo, Finland
	 * http://pixelero.wordpress.com
	 */
	 
	 /** DIRECTIONS:
	  * 1) add your images to the 'sequence/' folder
	  * or choose your own folder below 
	  * 
	  * 2) update the image count in the SequenceLoader constructor
	  * 
	  * 3) That's it, it should compile. 
	  * 
	  * Feel free to replace the SequenceLoader with your own solution,
	  * as long as the BitmapData is readable, it should work!
	  * 
	  */
	
    [SWF(width=640,height=480,backgroundColor=0xFFFFFF)]
	
	public class Main extends Sprite {
		private var holder : Sprite;
		private var kaleido : Kaleido;
		private var sequence : SequenceLoader;
		private var text : TextField;

		public function Main() : void {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.frameRate = 30;
			
			addChild(holder = new Sprite());
			sequence = new SequenceLoader('sequence/', 67);
			holder.addChild(kaleido = new Kaleido(sequence));
			addEventListener(Event.ADDED_TO_STAGE, eAdded);
			
			// small text preloader
			addChild(text = new TextField());
			text.y = text.x = 10;
			text.width = 200;
			text.selectable = false;
			text.defaultTextFormat = new TextFormat("_sans",12,0x666666);
			sequence.addEventListener(SequenceLoaderEvent.IMAGE_LOADED, eImageLoaded);
			sequence.addEventListener(SequenceLoaderEvent.COMPLETE, eLoadComplete);
			
		}

		private function eLoadComplete(event : SequenceLoaderEvent) : void {
			removeChild(text);
		}

		private function eImageLoaded(event : SequenceLoaderEvent) : void {
			text.text = sequence.loadCount + " OF " + sequence.imageCount + " LOADED";
		}

		private function eAdded(event : Event) : void {
			stage.addEventListener(Event.RESIZE, eResize);
			layout();
		}

		private function eResize(event : Event) : void {
			layout();
		}

		private function layout() : void {
			holder.x = stage.stageWidth * .5;
			holder.y = stage.stageHeight * .5;
		}
	}
}	