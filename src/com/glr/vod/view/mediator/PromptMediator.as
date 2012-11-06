package com.glr.vod.view.mediator 
{
    import com.glr.vod.components.prompt.*;
    import com.glr.vod.controller.*;
    import com.glr.vod.facade.*;
    import com.glr.vod.model.*;
    import com.glr.vod.model.specail.*;
    import com.glr.vod.notify.*;
    import com.glr.vod.view.*;
    import flash.display.*;
    import flash.geom.*;
    
    public class PromptMediator extends com.glr.vod.view.Mediator
    {
        public function PromptMediator(arg1:flash.display.Sprite, arg2:com.glr.vod.model.Model, arg3:com.glr.vod.controller.Controller)
        {
            super(NAME, arg1, arg2, arg3);
            return;
        }

        protected override function listInteresting():Array
        {
            return [com.glr.vod.notify.InitNotiy.GOT_SKIN, com.glr.vod.notify.GlobalNotify.GLOBAL_RESIZE, com.glr.vod.notify.AssistNotify.CHANGE_PROMPT];
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
                        this.initSKin(notify.body.skin);
                        break;
                    }
                    case com.glr.vod.notify.GlobalNotify.GLOBAL_RESIZE:
                    {
                        rect = notify.body ? notify.body as flash.geom.Rectangle : com.glr.vod.model.specail.Config.rootRect;
                        this.prompt.resize(rect);
                        break;
                    }
                    case com.glr.vod.notify.AssistNotify.CHANGE_PROMPT:
                    {
                        this.prompt.display(notify.body);
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
            this.prompt = new com.glr.vod.components.prompt.PromptUI(arg1.prompt);
            return;
        }

        public static const NAME:String="promptMedaitor";

        internal var prompt:com.glr.vod.components.prompt.PromptUI;
    }
}
