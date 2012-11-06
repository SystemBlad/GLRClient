package com.glr.vod.controller.skiner 
{
    import com.glr.vod.*;
    import com.glr.vod.controller.*;
    
    import flash.display.*;
	import flash.system.LoaderContext;
    import flash.events.*;
    
    public class Skiner extends flash.events.EventDispatcher
    {
        public function Skiner()
        {
            super();
            return;
        }

        public function destroy():void
        {
            this.loaderGc();
            return;
        }

        public function start():void
        {
            this.loaderGc();
            this._loader = new flash.display.Loader();
			var context:LoaderContext = new LoaderContext();
			context.allowLoadBytesCodeExecution = true;
            this._loader.contentLoaderInfo.addEventListener(flash.events.IOErrorEvent.IO_ERROR, this.onLoadError);
            this._loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, this.onLoadComplete);
            com.glr.vod.Vod.log("Skiner Start");
            this._loader.loadBytes(new this.Skin(), context);
            return;
        }

        protected function onLoadError(arg1:*=null):void
        {
			
			
            this.loaderGc();
            dispatchEvent(new com.glr.vod.controller.LoadEvent(com.glr.vod.controller.LoadEvent.LOAD_ERROR));
            return;
        }

        protected function onLoadComplete(arg1:flash.events.Event):void
        {
            var event:flash.events.Event;
            var result:Object;
            var e:com.glr.vod.controller.LoadEvent;

            var loc1:*;
            result = null;
            e = null;
            event = arg1;
            try 
            {
                result = event.target.content;
                if (result.skin) 
                {
                    com.glr.vod.Vod.log("Skiner Load Complete");
					
                    e = new com.glr.vod.controller.LoadEvent(com.glr.vod.controller.LoadEvent.LOAD_COMPLETE);
                    e.dataProvider = result;
                    dispatchEvent(e);
                    this.loaderGc();
                }
                else 
                {
                    this.onLoadError();
                }
            }
            catch (e:Error)
            {
                onLoadError();
            }
            return;
        }

        protected function loaderGc():void
        {
            var loc1:*;
            try 
            {
                this._loader.close();
            }
            catch (e:Error)
            {
            };
            if (this._loader) 
            {
                this._loader.unload();
                this._loader.unloadAndStop();
                this._loader.contentLoaderInfo.removeEventListener(flash.events.IOErrorEvent.IO_ERROR, this.onLoadError);
                this._loader.contentLoaderInfo.removeEventListener(flash.events.Event.COMPLETE, this.onLoadComplete);
            }
            this._loader = null;
            return;
        }

        public static function getInstance():com.glr.vod.controller.skiner.Skiner
        {
            if (_instance == null) 
            {
                _instance = new Skiner();
            }
            return _instance;
        }

        internal const Skin:Class=com.glr.vod.controller.skiner.Skiner_Skin;

        protected var _loader:flash.display.Loader;

        internal static var _instance:com.glr.vod.controller.skiner.Skiner;
    }
}
