package com.glr.vod.controller.action 
{
    import com.glr.vod.*;
    import com.glr.vod.controller.*;
    import com.glr.vod.model.*;
    import com.letv.aiLoader.*;
    import com.letv.aiLoader.events.*;
    import com.letv.aiLoader.type.*;
    import flash.events.*;
    
    public class Actioner extends flash.events.EventDispatcher
    {
        public function Actioner()
        {
            super();
            return;
        }

        public function destroy():void
        {
            this.loaderGc();
            return;
        }

        public function init(arg1:com.glr.vod.model.Model):void
        {
            this.model = arg1;
            return;
        }

        public function start(arg1:String):void
        {
			
			trace("arg1111 " +arg1); 
            if (arg1 == null || arg1 == "") 
            {
                this.onLoadError();
                return;
            }
            this.loaderGc();
            this.loader = new com.letv.aiLoader.AILoader();
            this.loader.addEventListener(com.letv.aiLoader.events.AILoaderEvent.LOAD_COMPLETE, this.onLoadComplete);
            this.loader.addEventListener(com.letv.aiLoader.events.AILoaderEvent.LOAD_ERROR, this.onLoadError);
            this.loader.setup([{"type":com.letv.aiLoader.type.ResourceType.TEXT, "url":arg1}]);
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
            var event:com.letv.aiLoader.events.AILoaderEvent;
            var action:String;
            var actionResult:Object;
            var ev:com.glr.vod.controller.LoadEvent;

            var loc1:*;
            action = null;
            actionResult = null;
            ev = null;
            event = arg1;
            try 
            {
                action = String(event.dataProvider.content);
				
				//trace(action.substr(1))
                action = "[" + action.substr(1) + "]";
                actionResult = JSON.parse(action);
                this.model.action = actionResult;
                ev = new com.glr.vod.controller.LoadEvent(com.glr.vod.controller.LoadEvent.LOAD_COMPLETE);
                dispatchEvent(ev);
                this.loaderGc(false);
            }
            catch (e:Error)
            {
                com.glr.vod.Vod.log("Action JSON Decoder Exception " + e.message);
                onLoadError();
            }
            return;
        }

        protected function loaderGc(arg1:Boolean=true):void
        {
            if (this.loader) 
            {
                if (arg1) 
                {
                    this.loader.destroy();
                }
                this.loader.removeEventListener(com.letv.aiLoader.events.AILoaderEvent.LOAD_ERROR, this.onLoadError);
                this.loader.removeEventListener(com.letv.aiLoader.events.AILoaderEvent.WHOLE_COMPLETE, this.onLoadComplete);
            }
            this.loader = null;
            return;
        }

        public static function getInstance():com.glr.vod.controller.action.Actioner
        {
            if (_instance == null) 
            {
                _instance = new Actioner();
            }
            return _instance;
        }

        protected var model:com.glr.vod.model.Model;

        protected var loader:com.letv.aiLoader.AILoader;

        internal static var _instance:com.glr.vod.controller.action.Actioner;
    }
}
