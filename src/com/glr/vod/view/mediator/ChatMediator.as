package com.glr.vod.view.mediator 
{
    import com.glr.vod.components.chat.*;
    import com.glr.vod.controller.*;
    import com.glr.vod.facade.*;
    import com.glr.vod.identity.*;
    import com.glr.vod.model.*;
    import com.glr.vod.model.specail.*;
    import com.glr.vod.notify.*;
    import com.glr.vod.view.*;
    import flash.display.*;
    import flash.geom.*;
    import flash.media.*;
    
    public class ChatMediator extends com.glr.vod.view.Mediator
    {
        public function ChatMediator(arg1:flash.display.Sprite, arg2:com.glr.vod.model.Model, arg3:com.glr.vod.controller.Controller)
        {
            super(NAME, arg1, arg2, arg3);
            return;
        }

        protected override function listInteresting():Array
        {
            return [com.glr.vod.notify.InitNotiy.GOT_SKIN, com.glr.vod.notify.InitNotiy.GOT_API, com.glr.vod.notify.InitNotiy.GOT_MEDIA, com.glr.vod.notify.GlobalNotify.GLOBAL_RESIZE, com.glr.vod.notify.LogicNotify.GOT_CLAP, com.glr.vod.notify.LogicNotify.GOT_USER_SAY, com.glr.vod.notify.LogicNotify.CLEAR_MSG];
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
                    case com.glr.vod.notify.InitNotiy.GOT_SKIN:
                    {
                        this.skin = notify.body.skin;
                        break;
                    }
                    case com.glr.vod.notify.InitNotiy.GOT_API:
                    {
                        this.initSkin(this.skin);
                        break;
                    }
                    case com.glr.vod.notify.InitNotiy.GOT_MEDIA:
                    {
                        this.initMedia();
                        break;
                    }
                    case com.glr.vod.notify.GlobalNotify.GLOBAL_RESIZE:
                    {
                        rect = notify.body ? notify.body.clone() as flash.geom.Rectangle : com.glr.vod.model.specail.Config.rootRect.clone();
                        rect.x = rect.width; //- com.glr.vod.model.specail.Config.CHAT_WID;
                        rect.y = 5;
                        rect.width = com.glr.vod.model.specail.Config.CHAT_WID;
                        rect.height = rect.height - 10;
                        this.chat.resize(rect);
                        break;
                    }
                    case com.glr.vod.notify.LogicNotify.GOT_CLAP:
                    {
                        this.gotClap(notify.body);
                        break;
                    }
                    case com.glr.vod.notify.LogicNotify.GOT_USER_SAY:
                    {
                        this.chat.setMsg(notify.body);
                        break;
                    }
                    case com.glr.vod.notify.LogicNotify.CLEAR_MSG:
                    {
                        this.chat.clearMsg();
                        sendNotification(com.glr.vod.notify.AssistNotify.CHANGE_PROMPT, {"visible":false});
                        break;
                    }
                }
            }
            catch (e:Error)
            {
            };
            return;
        }

        internal function initSkin(arg1:Object):void
        {
            this.chat = new com.glr.vod.components.chat.ChatUI(arg1.chat);
            this.chat.addEventListener(com.glr.vod.components.chat.ChatEvent.CHANGE_PROMPT, this.onChangePrompt);
            return;
        }

        internal function onChangePrompt(arg1:com.glr.vod.components.chat.ChatEvent):void
        {
            sendNotification(com.glr.vod.notify.AssistNotify.CHANGE_PROMPT, arg1.dataProvider);
            return;
        }

        internal function initMedia():void
        {
            this.chat.initMedia();
            this.chat.clearMsg();
            if (model.config.notice) 
            {
                this.chat.setMsg({"id":null, "name":null, "identity":com.glr.vod.identity.Identity.SYS_USER, "avatar":null, "value":model.config.notice});
            }
            return;
        }

        internal function gotClap(arg1:Object):void
        {
            if (this.sound) 
            {
                this.channel.stop();
            }
            this.sound = null;
            this.sound = new this.GUZHANG() as flash.media.Sound;
            this.channel = this.sound.play();
            this.channel.soundTransform = new flash.media.SoundTransform(2);
            if (this.chat) 
            {
                arg1.value = "\"为精彩的讲课鼓掌\"";
                this.chat.setMsg(arg1);
            }
            return;
        }

        internal const GUZHANG:Class=com.glr.vod.view.mediator.ChatMediator_GUZHANG;

        public static const NAME:String="chatView";

        internal var chat:com.glr.vod.components.chat.ChatUI;

        internal var skin:Object;

        internal var channel:flash.media.SoundChannel;

        internal var sound:flash.media.Sound;
    }
}
