package {
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;

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
	 
	
	public class Main extends Sprite {
		private var holder : Sprite;
		private var kaleido : Kaleido;
		private var sequence : SequenceLoader;

		public function Main() : void {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.frameRate = 40;
			
			addChild(holder = new Sprite());
			sequence = new SequenceLoader('sequence/',67);
			holder.addChild(kaleido = new Kaleido(sequence));
			addEventListener(Event.ADDED_TO_STAGE, eAdded);
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