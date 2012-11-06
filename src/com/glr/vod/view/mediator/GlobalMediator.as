package com.glr.vod.view.mediator 
{
    import com.glr.vod.controller.*;
    import com.glr.vod.facade.*;
    import com.glr.vod.model.*;
    import com.glr.vod.model.specail.*;
    import com.glr.vod.notify.*;
    import com.glr.vod.view.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    
    public class GlobalMediator extends com.glr.vod.view.Mediator
    {
        public function GlobalMediator(arg1:flash.display.Sprite, arg2:com.glr.vod.model.Model, arg3:com.glr.vod.controller.Controller)
        {
            super(NAME, arg1, arg2, arg3);
            return;
        }

        protected override function onRegister():void
        {
            controller.init(main.stage.loaderInfo.parameters);
            return;
        }

        protected override function listInteresting():Array
        {
            return [com.glr.vod.notify.InitNotiy.GOT_SKIN, com.glr.vod.notify.InitNotiy.GOT_API, com.glr.vod.notify.InitNotiy.GOT_MEDIA, com.glr.vod.notify.GlobalNotify.GLOBAL_RESIZE, com.glr.vod.notify.ErrorNotify.ERROR_MEDIA];
        }

        protected override function handleNotification(arg1:com.glr.vod.facade.Notification):void
        {
            var notify:com.glr.vod.facade.Notification;
            var rect:flash.geom.Rectangle;

            var loc1:*;
            rect = null;
            notify = arg1;
            var loc2:*=notify.name;
            switch (loc2) 
            {
                case com.glr.vod.notify.InitNotiy.GOT_SKIN:
                {
                    this.addListener();
                    this.skin = notify.body.skin;
                    main.addChildAt(this.skin, 0);
                    this.skin.visible = false;
                    this.skin.back.visible = false;
                    break;
                }
                case com.glr.vod.notify.InitNotiy.GOT_API:
                {
                    this.skin.visible = true;
                    break;
                }
                case com.glr.vod.notify.InitNotiy.GOT_MEDIA:
                {
                    try 
                    {
                        this.skin.back.visible = true;
                    }
                    catch (e:Error)
                    {
                    };
                    break;
                }
                case com.glr.vod.notify.GlobalNotify.GLOBAL_RESIZE:
                {
                    rect = notify.body ? notify.body as flash.geom.Rectangle : com.glr.vod.model.specail.Config.rootRect.clone();
                    this.skin.x = (main.stage.stageWidth - rect.width) / 2;
                    this.skin.y = (main.stage.stageHeight - rect.height) / 2;
                    if (this.skin.back) 
                    {
                        this.skin.back.width = com.glr.vod.model.specail.Config.CHAT_WID;
                        this.skin.back.height = rect.height;
                        this.skin.back.x = rect.width - com.glr.vod.model.specail.Config.CHAT_WID;
                        this.skin.back.y = 0;
                    }
                    break;
                }
                case com.glr.vod.notify.ErrorNotify.ERROR_MEDIA:
                {
                    try 
                    {
                        this.skin.back.visible = false;
                    }
                    catch (e:Error)
                    {
                    };
                    break;
                }
            }
            return;
        }

        internal function addListener():void
        {
            main.stage.addEventListener(flash.events.Event.RESIZE, this.onResize);
            return;
        }

        internal function removeListener():void
        {
            main.stage.removeEventListener(flash.events.Event.RESIZE, this.onResize);
            return;
        }

        internal function onResize(arg1:flash.events.Event=null):void
        {
            var loc1:*=com.glr.vod.model.specail.Config.maxRect.clone();
            var loc2:*=com.glr.vod.model.specail.Config.rootRect.clone();
            var loc3:*=main.stage.stageWidth;
            var loc4:*=main.stage.stageHeight;
            var loc5:*=loc3 / loc4;
            var loc6:*=loc2.width / loc2.height;
            if (main.stage.displayState != flash.display.StageDisplayState.NORMAL) 
            {
                if (loc3 < loc1.width || loc4 < loc1.height) 
                {
                    if (loc6 > loc5) 
                    {
                        loc2.width = loc3 - 40;
                        loc2.height = loc2.width / loc6;
                    }
                    else 
                    {
                        loc2.height = loc4 - 40;
                        loc2.width = loc2.height * loc6;
                    }
                }
                else 
                {
                    loc2 = loc1;
                }
            }
            else if (loc3 < loc2.width || loc4 < loc2.height) 
            {
                if (loc6 > loc5) 
                {
                    loc2.width = loc3;
                    loc2.height = loc2.width / loc6;
                }
                else 
                {
                    loc2.height = loc4;
                    loc2.width = loc2.height * loc6;
                }
            }
            sendNotification(com.glr.vod.notify.GlobalNotify.GLOBAL_RESIZE, loc2);
            return;
        }

        public static const NAME:String="initView";

        internal var skin:flash.display.MovieClip;
    }
}
