package {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Matrix;
	import flash.net.URLRequest;

	/**
	 * @author mikepro
	 */
	public class SequenceLoader extends EventDispatcher {
		private var _dir : String;
		private var _count : int;
		private var _loader : Loader;
		private var _loadCount : int;
		private var _loadTotal : int;
		private var _bdAr : Array = [];

		public function SequenceLoader(directory : String, imageCount : int) {
			_dir = directory;
			_count = imageCount;
			super();
		}

		public function load() : void {
			_loadCount = 1;
			_loadTotal = _count;
			loadNext();
		}

		private function loadNext() : void {
			_loader = new Loader();
			var s : String = _dir;
			s += _loadCount + ".jpg";
			_loader.load(new URLRequest(s));
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadComplete);
		}

		private function loadComplete(event : Event) : void {
			var bd : BitmapData;
			var b : Bitmap;
			b = Bitmap(_loader.getChildAt(0));

			bd = new BitmapData(b.width * 2 - 2, b.height * 2 - 2, true);
			bd.draw(b);

			var mFlip : Matrix = new Matrix();
			mFlip.scale(1, -1);
			mFlip.ty = b.height * 2;
			bd.draw(b, mFlip);

			mFlip = new Matrix();
			mFlip.scale(-1, 1);
			mFlip.ty = 1;
			mFlip.tx = b.width * 2;
			bd.draw(b, mFlip);

			mFlip = new Matrix();
			mFlip.scale(-1, -1);
			mFlip.ty = b.height * 2;
			mFlip.tx = b.width * 2;
			bd.draw(b, mFlip);

			_bdAr.push(bd);
			_loadCount++;
			if (_loadCount <= _loadTotal) {
				dispatchEvent(new SequenceLoaderEvent(SequenceLoaderEvent.IMAGE_LOADED));
				loadNext();
			}
			else loadDone();
		}

		private function loadDone() : void {
			dispatchEvent(new SequenceLoaderEvent(SequenceLoaderEvent.COMPLETE));
		}

		public function getBitmapDataByIndex(i : int) : BitmapData {
			return _bdAr[i];
		}

		public function get imageCount() : int {
			return _count;
		}
	}
}
