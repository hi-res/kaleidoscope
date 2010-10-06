package {
	import flash.events.Event;
	import flash.display.Stage;
	import flash.geom.Point;

	public class MouseDrift {
		private var _stage : Stage;
		private var _drift : Point = new Point();

		public function MouseDrift(stage : Stage) {
			_stage = stage;
			_stage.addEventListener(Event.ENTER_FRAME, eEnterFrame);
		}

		private function eEnterFrame(event : Event) : void {
			update();
		}

		private function update() : void {
			var mx : int = Math.min(Math.max(_stage.mouseX, 1), _stage.stageWidth - 1);
			var my : int = Math.min(Math.max(_stage.mouseY, 1), _stage.stageHeight - 1);

			var dx : Number = .5 + ((mx / _stage.stageWidth) * .5 - .25);
			var dy : Number = .5 + ((my / _stage.stageHeight) * 1 - .5);

			_drift.x += ( dx - _drift.x ) * .05;
			_drift.y += ( dy - _drift.y ) * .05;
		}

		public function get x():Number{
			return _drift.x;
		}
		
		public function get y():Number{
			return _drift.y;
		}
	}
}
