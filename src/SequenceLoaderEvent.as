package {
	import flash.events.Event;

	/**
	 * @author mikepro
	 */
	public class SequenceLoaderEvent extends Event {
		
		public static const IMAGE_LOADED:String = "IMAGE_LOADED";
		public static const COMPLETE:String = "COMPLETE";
		
		public function SequenceLoaderEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		}
	}
}
