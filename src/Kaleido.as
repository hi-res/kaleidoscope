package {
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.TriangleCulling;
	import flash.events.Event;


	public class Kaleido extends Sprite {


		internal var i : int, j : int, tmp : Number;
		internal const HALFSQRT3 : Number = 0.866025403784438;
		internal const D : Number = 120.0 / 180.0 * Math.PI;

		private var _vertices : Vector.<Number> = new Vector.<Number>(),
		_indices : Vector.<int> = new Vector.<int>(),
		_uvtData : Vector.<Number> = new Vector.<Number>(),
		_points : Array;

		private var _bitmapData : BitmapData;
		private var _currentBitmapData : int = 0;
		private var _size : Number = 600;
		private var _offsetA : Number = .5;
		private var _offsetB : Number = .5;
		private var _sprite : Sprite;
		private var _phase : Number = 0.0;

		private var _dir : Boolean;
		private var _mouseDrift : MouseDrift;
		private var _sequence : SequenceLoader;

		public function Kaleido(sequence:SequenceLoader) {
			_sequence = sequence;
			addChild(_sprite = new Sprite());
			_sequence.addEventListener(SequenceLoaderEvent.IMAGE_LOADED, eLoadComplete);
			_sequence.load();
			addEventListener(Event.ADDED_TO_STAGE,eAddedToStage);
		}

		private function eAddedToStage(event : Event) : void {
			_mouseDrift = new MouseDrift(stage);
		}

		private function eLoadComplete(event : Event) : void {
			if(_sequence.loadCount < 3) return;
			init();
			play();
			_sequence.removeEventListener(SequenceLoaderEvent.IMAGE_LOADED, eLoadComplete);
		}

		public function play() : void {
			addEventListener(Event.ENTER_FRAME, render);
		}

		public function stop() : void {
			removeEventListener(Event.ENTER_FRAME, render);
		}

		protected function init(e : Event = null) : void {
			var po : Object;
			var id : int = 0,xp : Number, yp : Number;
			var offX:int = 1200;
			var offY:int = 1038;
			var triangs : Array = [], paths : Array = [], tr : Array;
			var n : int = 4 + 800 / _size;
			var m : int = 3 + 600 / _size / HALFSQRT3;

			var uvIndex : int;
			_vertices = new Vector.<Number>();
			// x,y,z -coordinates
			_indices = new Vector.<int>();
			// triangle mesh
			_uvtData = new Vector.<Number>();
			_points = [];

			// fill the stage (with triangles
			for (j = 0; j != m; j++) {
				paths[j] = [];

				yp = _size * j * HALFSQRT3;
				uvIndex = ((j & 1) == 0) ? 0 : 2;

				for (i = 0; i != n; i++) {
					xp = (i - 0.5 * (j & 1)) * _size ;
					po = {x:xp - offX, y:yp - offY, id:id++, uvIndex:uvIndex};

					paths[j].push(po);
					_points.push(po);

					uvIndex = (uvIndex + 2) % 3;
				}

				if (j != 0) {
					triangulatePaths(paths[j - 1], paths[j], false, triangs);
				}
			}

			for each ( tr in triangs) _indices.push(tr[0].id, tr[1].id, tr[2].id);

			_bitmapData = _sequence.getBitmapDataByIndex(0);
		}

		// generates a triangle strip between two arrays of _points
		private function triangulatePaths(path0 : Array, path1 : Array, closed : Boolean = false, triangles : Array = null) : Array {
			if (triangles == null) triangles = [];
			var index0 : int = 0,index1 : int = 0, dist0 : Number, dist1 : Number;

			var po0 : * = path0[index0];
			var po1 : * = path1[index1];

			// if 'closed' push the first point as last one as well
			if (closed && path0.length > 1 && po0 != path0[path0.length - 1] ) path0.push(po0);
			if (closed && path1.length > 1 && po1 != path1[path1.length - 1] ) path1.push(po1);

			// choose the new triangle by a shorter diagonal
			while (index0 < path0.length - 1 && index1 < path1.length - 1) {
				dist0 = (tmp = po0.x - path1[index1 + 1].x) * tmp + (tmp = po0.y - path1[index1 + 1].y) * tmp;
				dist1 = (tmp = po1.x - path0[index0 + 1].x) * tmp + (tmp = po1.y - path0[index0 + 1].y) * tmp;
				triangles.push([po0, po1, (dist0 < dist1) ? po1 = path1[++index1] : po0 = path0[++index0]]);
			}

			// creates a fan of triangles if the other path's already ended
			while (index0 + 1 < path0.length) triangles.push([po0, po1, po0 = path0[++index0]]);

			while (index1 + 1 < path1.length) triangles.push([po0, po1, po1 = path1[++index1]]);

			return triangles;
		}

		private function render(e : Event = null) : void {
			if (_currentBitmapData == _sequence.loadCount - 1) _dir = false;
			else if (_currentBitmapData == 0) _dir = true;

			_currentBitmapData = (_dir) ? _currentBitmapData + 1 : _currentBitmapData - 1;
			_bitmapData = _sequence.getBitmapDataByIndex(_currentBitmapData);
			_phase += 0.01;
			
			_offsetA = _mouseDrift.x;
			_offsetB = _mouseDrift.y;

			var uvIndices : Array = [{u:_offsetA + _offsetB * Math.cos(_phase - D), v:_offsetA + _offsetB * Math.sin(_phase - D)}, {u:_offsetA + _offsetB * Math.cos(_phase), v:_offsetA + _offsetB * Math.sin(_phase)}, {u:_offsetA + _offsetB * Math.cos(_phase + D), v:_offsetA + _offsetB * Math.sin(_phase + D)}];

			_uvtData = new Vector.<Number>();
			_vertices = new Vector.<Number>();

			for each (var po:Object in _points) {
				_uvtData.push(uvIndices[po.uvIndex].u, uvIndices[po.uvIndex].v);
				_vertices.push(po.x, po.y);
			}

			_sprite.graphics.clear();
			_sprite.graphics.beginBitmapFill(_bitmapData, null, true, true);
			_sprite.graphics.drawTriangles(_vertices, _indices, _uvtData, TriangleCulling.NONE);
			_sprite.graphics.endFill();
		}
	}
}
