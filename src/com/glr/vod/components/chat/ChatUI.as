package com.glr.vod.components.chat 
{
    import com.glr.components.*;
    import com.glr.vod.components.chat.classes.*;
    import flash.geom.*;
    import flash.utils.*;
    
    public class ChatUI extends com.glr.components.UIComponent
    {
        public function ChatUI(arg1:Object)
        {
            super(arg1);
            return;
        }

        public override function resize(arg1:flash.geom.Rectangle):void
        {
            var loc1:*=null;
            if (skin && skin.stage) 
            {
                if (skin && skin.stage) 
                {
                    if (skin.back) 
                    {
                        skin.back.height = arg1.height;
                    }
                    loc1 = arg1.clone();
                    skin.people.y = skin.back.height - skin.people.height;
                    loc1 = arg1.clone();
                    loc1.y = 20;
                    loc1.height = skin.people.y - loc1.y - 10;
                    this.display.resize(loc1);
                    skin.x = arg1.x;
                    skin.y = arg1.y;
                }
            }
            return;
        }

        public function setMsg(arg1:Object):void
        {
            var info:Object;

            var loc1:*;
            info = arg1;
            try 
            {
                this.display.msg = info;
            }
            catch (e:Error)
            {
            };
            return;
        }

        public function clearMsg():void
        {
            var loc1:*;
            try 
            {
                this.display.clearMsg();
            }
            catch (e:Error)
            {
            };
            return;
        }

        public function initMedia():void
        {
            this.enabled = true;
            this.setLoop();
            return;
        }

        protected override function init():void
        {
            if (skin) 
            {
                this.display = new com.glr.vod.components.chat.classes.DisplayUI(skin.display, config);
                this.display.addEventListener(com.glr.vod.components.chat.ChatEvent.CHANGE_PROMPT, this.onChangePrompt);
                this.enabled = false;
                if (skin.people) 
                {
                    skin.people.txt.text = "...";
                }
            }
            return;
        }

        internal function setLoop():void
        {
            this.peopleLoop();
            flash.utils.setInterval(this.peopleLoop, 60000);
            return;
        }

        internal function peopleLoop():void
        {
            if (skin.people) 
            {
                skin.people.txt.text = 20 + int(Math.random() * 40) + "人在线";
            }
            return;
        }

        internal function onChangePrompt(arg1:com.glr.vod.components.chat.ChatEvent):void
        {
            var loc1:*=new com.glr.vod.components.chat.ChatEvent(com.glr.vod.components.chat.ChatEvent.CHANGE_PROMPT);
            loc1.dataProvider = arg1.dataProvider;
            dispatchEvent(loc1);
            return;
        }

        internal var display:com.glr.vod.components.chat.classes.DisplayUI;
    }
}
