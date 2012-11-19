package com.components
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class PenContainer extends Sprite
	{
		
		public var cWidth:Number;
		public var cHeight:Number;
		public var pen:Sprite = new Sprite();
		public var penColor:uint;
		
		public var penX:Number;
		public var penY:Number;
		
		private var pen_draw:Boolean;
		
		public function PenContainer()
		{
			super();
			
			buildPen(0xcccccc);
			
			addChild(pen);
			pen.visible = false;
			this.addEventListener(Event.ADDED_TO_STAGE, onAdd);
			
		}
		
		private function onAdd(e:Event):void{
			
			//cHeight = this.stage.stageHeight;
			
		}
		
		public function buildPen(c:Number):void
		{
			this.penColor = c;
			pen.graphics.clear();
			pen.graphics.beginFill(this.penColor);
			pen.graphics.drawCircle(0, 0, 6);
			pen.graphics.endFill();
			return;
		}
		
		public function clearGraphic():void{
			this.pen_draw = false;
			this.graphics.clear();
			
		}
		
		
		public function set penPosition(arg1:Object):void
		{
			
				pen.visible = arg1.visible;
				if (arg1.visible) 
				{
					
					pen.x = arg1.penScaleX  * this.cWidth;
					pen.y = arg1.penScaleY  * this.cHeight;
					if (arg1.color != this.penColor) 
					{
						this.buildPen(arg1.color);
					}
					if (arg1.draw) 
					{
						if (this.pen_draw) 
						{
							this.graphics.lineTo( this.cWidth * arg1.penScaleX,  this.cHeight * arg1.penScaleY);
						}
						else 
						{
							this.pen_draw = true;
							this.graphics.lineStyle(5, arg1.color);
							this.graphics.moveTo( this.cWidth * arg1.penScaleX, this.cHeight * arg1.penScaleY);
						}
					}
					else 
					{
						this.pen_draw = false;
						this.graphics.endFill();
					}
					
					penX = pen.x;
					penY = pen.y;
					
					//trace(pen.x, pen.y);
				}
			
			return;
		}

		
	}
}