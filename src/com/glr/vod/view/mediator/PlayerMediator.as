package com.glr.vod.view.mediator 
{
    import com.glr.vod.components.player.*;
    import com.glr.vod.controller.*;
    import com.glr.vod.facade.*;
    import com.glr.vod.model.*;
    import com.glr.vod.model.specail.*;
    import com.glr.vod.notify.*;
    import com.glr.vod.view.*;
    import flash.display.*;
    import flash.geom.*;
    
    public class PlayerMediator extends com.glr.vod.view.Mediator
    {
        public function PlayerMediator(arg1:flash.display.Sprite, arg2:com.glr.vod.model.Model, arg3:com.glr.vod.controller.Controller)
        {
            super(NAME, arg1, arg2, arg3);
            return;
        }

        protected override function listInteresting():Array
        {
            return [com.glr.vod.notify.InitNotiy.GOT_SKIN, com.glr.vod.notify.InitNotiy.GOT_API, com.glr.vod.notify.InitNotiy.GOT_MEDIA, com.glr.vod.notify.InitNotiy.GOT_SCROLL, com.glr.vod.notify.ErrorNotify.ERROR_LIST, com.glr.vod.notify.ErrorNotify.ERROR_MEDIA, com.glr.vod.notify.GlobalNotify.GLOBAL_RESIZE, com.glr.vod.notify.LogicNotify.METADATA, com.glr.vod.notify.LogicNotify.MOUSE_SO_CHANGE, com.glr.vod.notify.LogicNotify.PAGE_SO_CHANGE, com.glr.vod.notify.LogicNotify.UPDATE_TIME, com.glr.vod.notify.LogicNotify.GOT_TEXT_PEN, com.glr.vod.notify.LogicNotify.CLEAR_GRAPHICS, com.glr.vod.notify.LogicNotify.BUFFER_EMPTY, com.glr.vod.notify.LogicNotify.BUFFER_FULL, com.glr.vod.notify.LogicNotify.PLAY_STOP];
        }

        protected override function handleNotification(arg1:com.glr.vod.facade.Notification):void
        {
            var notify:com.glr.vod.facade.Notification;
            var rect:flash.geom.Rectangle;

            var loc1:*;
            rect = null;
            notify = arg1;
            try 
            {
                var loc2 = notify.name;
                switch (loc2) 
                {
                    case com.glr.vod.notify.LogicNotify.UPDATE_TIME:
                    {
                        this.player.updateTime(notify.body);
                        break;
                    }
                    case com.glr.vod.notify.InitNotiy.GOT_SKIN:
                    {
                        this.skin = notify.body.skin;
                        break;
                    }
                    case com.glr.vod.notify.InitNotiy.GOT_API:
                    {
                        this.initSKin(this.skin);
                        break;
                    }
                    case com.glr.vod.notify.InitNotiy.GOT_MEDIA:
                    {
                        this.player.initMedia();
                        break;
                    }
                    case com.glr.vod.notify.InitNotiy.GOT_SCROLL:
                    {
                        this.player.page = notify.body;
                        break;
                    }
                    case com.glr.vod.notify.ErrorNotify.ERROR_SCROLL:
                    {
                        break;
                    }
                    case com.glr.vod.notify.ErrorNotify.ERROR_LIST:
                    {
                        this.player.page = notify.body;
                        break;
                    }
                    case com.glr.vod.notify.ErrorNotify.ERROR_MEDIA:
                    {
                        this.player.mediaDataError();
                        break;
                    }
                    case com.glr.vod.notify.GlobalNotify.GLOBAL_RESIZE:
                    {
                        rect = notify.body ? notify.body.clone() as flash.geom.Rectangle : com.glr.vod.model.specail.Config.rootRect.clone();
                        rect.y = loc2 = 0;
                        rect.x = loc2;
                        rect.width = rect.width;// - com.glr.vod.model.specail.Config.CHAT_WID;
                        this.player.resize(rect);
                        break;
                    }
                    case com.glr.vod.notify.LogicNotify.METADATA:
                    {
                        this.player.metadata = notify.body;
                        break;
                    }
                    case com.glr.vod.notify.LogicNotify.MOUSE_SO_CHANGE:
                    {
                        this.player.penPosition = notify.body;
                        break;
                    }
                    case com.glr.vod.notify.LogicNotify.PAGE_SO_CHANGE:
                    {
                        controller.initScroll(notify.body);
                        break;
                    }
                    case com.glr.vod.notify.LogicNotify.GOT_TEXT_PEN:
                    {
                        this.player.textPen = notify.body;
                        break;
                    }
                    case com.glr.vod.notify.LogicNotify.CLEAR_GRAPHICS:
                    {
                        this.player.clearGraphics();
                        break;
                    }
                    case com.glr.vod.notify.LogicNotify.BUFFER_EMPTY:
                    {
                        this.player.bufferEmpty();
                        break;
                    }
                    case com.glr.vod.notify.LogicNotify.BUFFER_FULL:
                    {
                        this.player.bufferFull();
                        break;
                    }
                    case com.glr.vod.notify.LogicNotify.PLAY_STOP:
                    {
                        this.player.stopVideo();
                        break;
                    }
                }
            }
            catch (e:Error)
            {
            };
            return;
        }

        internal function initSKin(arg1:Object):void
        {
            this.player = new com.glr.vod.components.player.PlayerUI(arg1.player, {"pubpic":model.config.avatar_t});
            this.player.addEventListener(com.glr.vod.components.player.PlayerEvent.SEEK_TO, this.onSeekTo);
            this.player.addEventListener(com.glr.vod.components.player.PlayerEvent.PAUSE, this.onPause);
            this.player.addEventListener(com.glr.vod.components.player.PlayerEvent.RESUME, this.onResume);
            this.player.addEventListener(com.glr.vod.components.player.PlayerEvent.VOLUME_CHANGE, this.onVolumeChange);
            return;
        }

        internal function onSeekTo(arg1:com.glr.vod.components.player.PlayerEvent):void
        {
            controller.seekTo(arg1.dataProvider);
            return;
        }

        internal function onPause(arg1:com.glr.vod.components.player.PlayerEvent):void
        {
            controller.pauseVideo();
            return;
        }

        internal function onResume(arg1:com.glr.vod.components.player.PlayerEvent):void
        {
            controller.resumeVideo();
            return;
        }

        internal function onVolumeChange(arg1:com.glr.vod.components.player.PlayerEvent):void
        {
            controller.setVolume(arg1.dataProvider as Number);
            return;
        }

        public static const NAME:String="playerMediator";

        internal var player:com.glr.vod.components.player.PlayerUI;

        internal var skin:Object;
    }
}
