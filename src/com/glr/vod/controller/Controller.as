package com.glr.vod.controller 
{
    import com.glr.vod.*;
    import com.glr.vod.controller.action.*;
    import com.glr.vod.controller.configer.*;
    import com.glr.vod.controller.resourcer.*;
    import com.glr.vod.controller.skiner.*;
    import com.glr.vod.facade.*;
    import com.glr.vod.media.*;
    import com.glr.vod.model.*;
    import com.glr.vod.model.specail.*;
    import com.glr.vod.notify.*;
    
    public class Controller extends com.glr.vod.facade.Notifier
    {
		
		var _url;
        public function Controller(arg1:com.glr.vod.model.Model, url:String)
        {
			_url = url;
            this.videoplayer = com.glr.vod.media.MediaPlayer.getInstance();
            super("controller", false);
            this.model = arg1;
            return;
        }

        public function init(arg1:Object):void
        {
            com.glr.vod.Vod.log("Controller Init");
            this.model.initFlashVars(arg1);
            this.model.initConfig(null);
            this.initSkin();
            return;
        }

        public function initConfig():void
        {
            com.glr.vod.Vod.log("Config Load Start");
            var loc1:*=com.glr.vod.controller.configer.Configer.getInstance();
            loc1.addEventListener(com.glr.vod.controller.LoadEvent.LOAD_ERROR, this.onLoadConfigError);
            loc1.addEventListener(com.glr.vod.controller.LoadEvent.LOAD_COMPLETE, this.onLoadConfigComplete);
            //loc1.start(this.model.flashvars.appid);
            loc1.start(_url);
			return;
        }

        protected function onLoadConfigError(arg1:com.glr.vod.controller.LoadEvent=null):void
        {
			
            com.glr.vod.Vod.log("Config Load Error", "error");
            sendNotification(com.glr.vod.notify.ErrorNotify.ERROR_CONFIG);
            return;
        }

        protected function onLoadConfigComplete(arg1:com.glr.vod.controller.LoadEvent):void
        {
            com.glr.vod.Vod.log("Config Load Complete");
            this.model.initRemote(arg1.dataProvider);
            if (this.model.config.flv_path) 
            {
                this.model.setting.flv = this.model.config.flv_path;
                this.initList();
            }
            else 
            {
                this.onLoadConfigError();
            }
            return;
        }

        public function initSkin():void
        {
            com.glr.vod.Vod.log("Skin Load Start");
            var loc1:*=com.glr.vod.controller.skiner.Skiner.getInstance();
            loc1.addEventListener(com.glr.vod.controller.LoadEvent.LOAD_ERROR, this.onLoadSkinError);
            loc1.addEventListener(com.glr.vod.controller.LoadEvent.LOAD_COMPLETE, this.onLoadSkinComplete);
            loc1.start();
            return;
        }

        protected function onLoadSkinError(arg1:com.glr.vod.controller.LoadEvent):void
        {
            com.glr.vod.Vod.log("Skin Load Error", "error");
            return;
        }

        protected function onLoadSkinComplete(arg1:com.glr.vod.controller.LoadEvent):void
        {
            com.glr.vod.Vod.log("Skin Load Complete");
            com.glr.vod.model.specail.ConfigVO.getInstance().skinDomain = arg1.dataProvider.loaderInfo.applicationDomain;
            sendNotification(com.glr.vod.notify.InitNotiy.GOT_SKIN, arg1.dataProvider);
            sendNotification(com.glr.vod.notify.GlobalNotify.GLOBAL_RESIZE);
            this.initConfig();
            return;
        }

        public function initList():void
        {
            var loc1:*=com.glr.vod.controller.action.Actioner.getInstance();
            loc1.init(this.model);
            loc1.addEventListener(com.glr.vod.controller.LoadEvent.LOAD_ERROR, this.onLoadListError);
            loc1.addEventListener(com.glr.vod.controller.LoadEvent.LOAD_COMPLETE, this.onLoadListComplete);
            com.glr.vod.Vod.log("Action Load Start " + this.model.config.action_path);
            loc1.start(this.model.config.action_path);
            return;
        }

        protected function onLoadListError(arg1:com.glr.vod.controller.LoadEvent):void
        {
            com.glr.vod.Vod.log("Action Load Error ");
            sendNotification(com.glr.vod.notify.ErrorNotify.ERROR_LIST, {"total":0, "index":1, "content":null});
            sendNotification(com.glr.vod.notify.InitNotiy.GOT_API, [0, this.model.setting.totalPage]);
            sendNotification(com.glr.vod.notify.GlobalNotify.GLOBAL_RESIZE);
            this.videoplayer.init(this.model);
            return;
        }

        protected function onLoadListComplete(arg1:com.glr.vod.controller.LoadEvent):void
        {
            com.glr.vod.Vod.log("Action Load Complete");
            sendNotification(com.glr.vod.notify.InitNotiy.GOT_API, [0, this.model.setting.totalPage]);
            sendNotification(com.glr.vod.notify.GlobalNotify.GLOBAL_RESIZE);
            this.videoplayer.init(this.model);
            return;
        }

        public function initScroll(arg1:Object):void
        {
            var loc1:*=com.glr.vod.controller.resourcer.Resourcer.getInstance();
            loc1.addEventListener(com.glr.vod.controller.LoadEvent.LOAD_ERROR, this.onLoadScrollError);
            loc1.addEventListener(com.glr.vod.controller.LoadEvent.LOAD_COMPLETE, this.onLoadScrollComplete);
            if (arg1) 
            {
                if (arg1.hasOwnProperty("page") && arg1["page"] is Array) 
                {
                    this.model.setting.currentPage = arg1["page"][0];
                    this.model.setting.totalPage = arg1["page"][1];
                }
                if (arg1.hasOwnProperty("url")) 
                {
                    com.glr.vod.Vod.log("Page Load " + arg1["url"] + " " + this.model.setting.currentPage + "/" + this.model.setting.totalPage);
                    this.model.setting.currentUrl = arg1["url"];
                    loc1.start(arg1["url"]);
                }
            }
            return;
        }

        protected function onLoadScrollError(arg1:com.glr.vod.controller.LoadEvent):void
        {
            com.glr.vod.Vod.log("Page Load Error", "error");
            sendNotification(com.glr.vod.notify.ErrorNotify.ERROR_SCROLL);
            return;
        }

        protected function onLoadScrollComplete(arg1:com.glr.vod.controller.LoadEvent):void
        {
            com.glr.vod.Vod.log("Page Load Complete " + this.model.setting.currentPage);
            sendNotification(com.glr.vod.notify.InitNotiy.GOT_SCROLL, {"total":this.model.setting.totalPage, "index":this.model.setting.currentPage, "content":arg1.dataProvider});
            this.videoplayer.resetActionBack();
            return;
        }

        public function seekTo(arg1:Object):void
        {
            this.videoplayer.seekTo(arg1);
            return;
        }

        public function pauseVideo():void
        {
            this.videoplayer.pause();
            return;
        }

        public function resumeVideo():void
        {
            this.videoplayer.resume();
            return;
        }

        public function setVolume(arg1:Number=1):void
        {
            this.model.setting.volume = arg1;
            this.videoplayer.volume = this.model.setting.volume;
            return;
        }

        internal var model:com.glr.vod.model.Model;

        internal var videoplayer:com.glr.vod.media.MediaPlayer;
    }
}
