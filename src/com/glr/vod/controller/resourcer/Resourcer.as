package com.glr.vod.controller.resourcer 
{
    import com.glr.vod.controller.*;
    import com.letv.aiLoader.*;
    import com.letv.aiLoader.events.*;
    import com.letv.aiLoader.type.*;
    import flash.events.*;
    
    public class Resourcer extends flash.events.EventDispatcher
    {
        public function Resourcer()
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
            if (arg1 == null || arg1 == "") 
            {
                this.onLoadError();
                return;
            }
            this.loaderGc();
            this._loader = new com.letv.aiLoader.AILoader();
            this._loader.addEventListener(com.letv.aiLoader.events.AILoaderEvent.LOAD_ERROR, this.onLoadError);
            this._loader.addEventListener(com.letv.aiLoader.events.AILoaderEvent.LOAD_COMPLETE, this.onLoadComplete);
            this._loader.setup([{"type":com.letv.aiLoader.type.ResourceType.FLASH, "url":arg1}]);
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
            var result:Object;
            var e:com.glr.vod.controller.LoadEvent;

            var loc1:*;
            result = null;
            e = null;
            event = arg1;
            try 
            {
                result = event.dataProvider;
                e = new com.glr.vod.controller.LoadEvent(com.glr.vod.controller.LoadEvent.LOAD_COMPLETE);
                e.dataProvider = result;
                dispatchEvent(e);
                this.loaderGc(false);
            }
            catch (e:Error)
            {
                onLoadError();
            }
            return;
        }

        protected function loaderGc(arg1:Boolean=true):void
        {
            if (this._loader) 
            {
                if (arg1) 
                {
                    this._loader.destroy();
                }
                this._loader.removeEventListener(com.letv.aiLoader.events.AILoaderEvent.LOAD_ERROR, this.onLoadError);
                this._loader.removeEventListener(com.letv.aiLoader.events.AILoaderEvent.LOAD_COMPLETE, this.onLoadComplete);
            }
            this._loader = null;
            return;
        }

        public static function getInstance():com.glr.vod.controller.resourcer.Resourcer
        {
            if (_instance == null) 
            {
                _instance = new Resourcer();
            }
            return _instance;
        }

        protected var _loader:com.letv.aiLoader.AILoader;

        internal static var _instance:com.glr.vod.controller.resourcer.Resourcer;
    }
}
