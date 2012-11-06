package com.glr.vod 
{
    import com.glr.test.DeviceLogger;
    import com.glr.vod.facade.*;
    
    import flash.display.*;
    import flash.events.*;
    import flash.system.*;
    
    import org.lin.log4j.*;
    
    public class Vod extends flash.display.Sprite
    {
		
		var _url;
        public function Vod(url:String)
        {
			_url = url; 
            super();
            //flash.system.Security.allowDomain("*");
            //flash.system.Security.allowInsecureDomain("*");
            if (stage) 
            {
                this.onAdd();
            }
            else 
            {
                addEventListener(flash.events.Event.ADDED_TO_STAGE, this.onAdd);
            }
            return;
        }

        internal function onAdd(arg1:flash.events.Event=null):void
        {
            removeEventListener(flash.events.Event.ADDED_TO_STAGE, this.onAdd);
            stage.align = flash.display.StageAlign.TOP_LEFT;
            stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
            stage.stageFocusRect = false;
            this.facade = new com.glr.vod.facade.Facade(this, _url);
            return;
        }

        public static function log(arg1:*, arg2:String="info"):void
        {
            var loc1:*;
            (loc1 = _log)[arg2](arg1);
			
			var deviceLogger:DeviceLogger = DeviceLogger.getInstance();
			
			deviceLogger.log(arg1);
			
            return;
        }

        internal static const _log:org.lin.log4j.ILogger=org.lin.log4j.Log.getLogger("com.glr.vod");

        internal var facade:com.glr.vod.facade.Facade;
    }
}
