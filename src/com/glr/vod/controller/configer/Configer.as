package com.glr.vod.controller.configer 
{
    import com.adobe.serialization.json.*;
    import com.glr.vod.controller.*;
    import com.letv.aiLoader.*;
    import com.letv.aiLoader.events.*;
    import com.letv.aiLoader.type.*;
    
    import flash.events.*;
    
    public class Configer extends flash.events.EventDispatcher
    {
        public function Configer()
        {
            super();
            return;
        }

        public function destroy():void
        {
            this.loaderGc();
            return;
        }

        public function start(arg1:String):void
        {
			
			trace(arg1)
            if (arg1 == null || arg1 == "") 
            {
                this.onLoadError();
                return;
            }
            this.loaderGc();
            this._loader = new com.letv.aiLoader.AILoader();
            this._loader.addEventListener(com.letv.aiLoader.events.AILoaderEvent.LOAD_ERROR, this.onLoadError);
            this._loader.addEventListener(com.letv.aiLoader.events.AILoaderEvent.LOAD_COMPLETE, this.onLoadComplete);
            this._loader.setup([{"type":com.letv.aiLoader.type.ResourceType.TEXT, "url":arg1}]);
            return;
        }

        protected function onLoadError(arg1:com.letv.aiLoader.events.AILoaderEvent=null):void
        {
            this.loaderGc();
			
            dispatchEvent(new com.glr.vod.controller.LoadEvent(com.glr.vod.controller.LoadEvent.LOAD_ERROR));
            return;
        }

        protected function onLoadComplete(arg1:com.letv.aiLoader.events.AILoaderEvent):void
        {
			
			trace("loadcom");
            var event:com.letv.aiLoader.events.AILoaderEvent;
            var value:String;
            var obj:Object;
            var flvFlag:Boolean;
            var actionFlag:Boolean;
            var e:com.glr.vod.controller.LoadEvent;

            var loc1:*;
            value = null;
            obj = null;
            flvFlag = false;
            actionFlag = false;
            e = null;
            event = arg1;
           // try 
           // {
                value = String(event.dataProvider.content);
                trace("vale  " + value);
				
				var myPattern:RegExp = /\\/g; 
				
				//var str = (event.dataProvider.content as String).replace(myPattern, "");
				
				//trace(str)
                obj = com.adobe.serialization.json.JSON.decode(event.dataProvider.content);
				
				//obj.flv_path = "aaa";
				//obj.action_path = "bbb"
				
				trace("value1 " + obj)
				
				
                flvFlag = obj.hasOwnProperty("flv_path");
                actionFlag = obj.hasOwnProperty("action_path");
				
				
                if (flvFlag && actionFlag) 
                {
                    e = new com.glr.vod.controller.LoadEvent(com.glr.vod.controller.LoadEvent.LOAD_COMPLETE);
                    e.dataProvider = obj;
                    dispatchEvent(e);
                    this.loaderGc();
                }
                else 
                {
					//trace("erroreeeee");
                    this.onLoadError();
                }
           // }
           /* catch (e:Error)
            {
				trace("erroreeeee");
                onLoadError();
            }*/
            return;
        }

        protected function loaderGc():void
        {
            if (this._loader) 
            {
                this._loader.destroy();
                this._loader.removeEventListener(com.letv.aiLoader.events.AILoaderEvent.LOAD_ERROR, this.onLoadError);
                this._loader.removeEventListener(com.letv.aiLoader.events.AILoaderEvent.LOAD_COMPLETE, this.onLoadComplete);
            }
            this._loader = null;
            return;
        }

        public static function getInstance():com.glr.vod.controller.configer.Configer
        {
            if (_instance == null) 
            {
                _instance = new Configer();
            }
            return _instance;
        }

        internal const URL:String="http://www.glr.cn/playerapi.php?appid=";

        protected var _loader:com.letv.aiLoader.AILoader;

        internal static var _instance:com.glr.vod.controller.configer.Configer;
    }
}
