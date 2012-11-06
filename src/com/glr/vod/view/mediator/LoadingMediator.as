package com.glr.vod.view.mediator 
{
    import com.glr.vod.components.loading.*;
    import com.glr.vod.controller.*;
    import com.glr.vod.facade.*;
    import com.glr.vod.model.*;
    import com.glr.vod.notify.*;
    import com.glr.vod.view.*;
    import flash.display.*;
    
    public class LoadingMediator extends com.glr.vod.view.Mediator
    {
        public function LoadingMediator(arg1:flash.display.Sprite, arg2:com.glr.vod.model.Model, arg3:com.glr.vod.controller.Controller)
        {
            super(NAME, arg1, arg2, arg3);
            return;
        }

        protected override function listInteresting():Array
        {
            return [com.glr.vod.notify.InitNotiy.GOT_SKIN, com.glr.vod.notify.InitNotiy.GOT_API, com.glr.vod.notify.InitNotiy.GOT_MEDIA, com.glr.vod.notify.ErrorNotify.ERROR_CONFIG, com.glr.vod.notify.GlobalNotify.GLOBAL_RESIZE];
        }

        protected override function handleNotification(arg1:com.glr.vod.facade.Notification):void
        {
            var loc1:*=arg1.name;
            switch (loc1) 
            {
                case com.glr.vod.notify.InitNotiy.GOT_SKIN:
                {
                    main.addChild(arg1.body.loading);
                    arg1.body.loading.x = 0;
                    arg1.body.loading.y = 0;
                    this.loading = new com.glr.vod.components.loading.LoadingUI(arg1.body.loading);
                    break;
                }
                case com.glr.vod.notify.InitNotiy.GOT_API:
                {
                    this.loading.hide();
                    break;
                }
                case com.glr.vod.notify.InitNotiy.GOT_MEDIA:
                {
                    this.loading.hide();
                    break;
                }
                case com.glr.vod.notify.ErrorNotify.ERROR_CONFIG:
                {
                    this.loading.errorConfig();
                    break;
                }
                case com.glr.vod.notify.GlobalNotify.GLOBAL_RESIZE:
                {
                    this.loading.resize(null);
                    break;
                }
            }
            return;
        }

        public static const NAME:String="loadingMedaitor";

        internal var loading:com.glr.vod.components.loading.LoadingUI;
    }
}
