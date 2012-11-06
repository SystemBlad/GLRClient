package com.glr.vod.components.chat.classes 
{
    import com.glr.components.list.*;
    import com.glr.vod.components.chat.*;
    import com.glr.vod.model.specail.*;
    import com.greensock.*;
    import com.letv.aiLoader.tools.*;
    import flash.geom.*;
    
    public class DisplayUI extends com.glr.components.list.VBox
    {
        public function DisplayUI(arg1:Object, arg2:Object)
        {
            this.config = arg2;
            super(arg1, arg2, 20);
            return;
        }

        public override function resize(arg1:flash.geom.Rectangle):void
        {
            if (skin && skin.stage) 
            {
                skin.y = arg1.y;
                this.height = arg1.height;
                if (skin.back) 
                {
                    skin.back.height = arg1.height;
                }
            }
            return;
        }

        public function set msg(arg1:Object):void
        {
            var loc1:*=null;
            if (this.itemClass) 
            {
                if (arg1) 
                {
                    loc1 = new com.glr.vod.components.chat.classes.ChatItem(new this.itemClass(), arg1);
                    loc1.addEventListener(com.glr.vod.components.chat.ChatEvent.CHANGE_PROMPT, this.onDisplayPrompt);
                    loc1.alpha = 0.5;
                    com.greensock.TweenLite.to(loc1, 0.3, {"alpha":1});
                    this.addItem(loc1);
                }
            }
            return;
        }

        public function clearMsg():void
        {
            var loc1:*=0;
            var loc2:*=0;
            if (stack) 
            {
                loc1 = stack.length;
                loc2 = 0;
                while (loc2 < loc1) 
                {
                    stack[loc2].removeEventListener(com.glr.vod.components.chat.ChatEvent.CHANGE_PROMPT, this.onDisplayPrompt);
                    ++loc2;
                }
            }
            this.dataProvider = null;
            com.letv.aiLoader.tools.GC.gc();
            return;
        }

        protected override function init():void
        {
            var loc1:*;
            super.init();
            try 
            {
                this.itemClass = com.glr.vod.model.specail.ConfigVO.getInstance().skinDomain.getDefinition("com.glr.components.ChatItem") as Class;
            }
            catch (e:Error)
            {
            };
            return;
        }

        internal function onDisplayPrompt(arg1:com.glr.vod.components.chat.ChatEvent):void
        {
            var loc1:*=new com.glr.vod.components.chat.ChatEvent(com.glr.vod.components.chat.ChatEvent.CHANGE_PROMPT);
            loc1.dataProvider = arg1.dataProvider;
            dispatchEvent(loc1);
            return;
        }

        internal var itemClass:Class;
    }
}
