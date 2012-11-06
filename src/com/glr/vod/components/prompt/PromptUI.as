package com.glr.vod.components.prompt 
{
    import com.glr.components.*;
    import com.greensock.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.net.*;
    import flash.utils.*;
    
    public class PromptUI extends com.glr.components.UIComponent
    {
        public function PromptUI(arg1:Object, arg2:Object=null)
        {
            super(arg1, arg2);
            return;
        }

        public function display(arg1:Object):void
        {
            var value:Object;
            var prompt:flash.display.MovieClip;
            var otherPrompt:flash.display.MovieClip;
            var p:flash.geom.Point;
            var bit:flash.display.Bitmap;

            var loc1:*;
            prompt = null;
            otherPrompt = null;
            p = null;
            bit = null;
            value = arg1;
            this.setDelay(false);
            if (value.visible) 
            {
                p = skin.globalToLocal(value.position);
                skin.up.visible = false;
                skin.down.visible = false;
                prompt = value.choose != "up" ? skin.down : skin.up;
                prompt.visible = true;
                prompt.x = p.x;
                prompt.y = p.y;
                prompt.alpha = 0;
                com.greensock.TweenLite.to(prompt, 0.3, {"alpha":1});
                if (prompt["username"]) 
                {
                    prompt["username"].text = "用户: " + value.name + "";
                }
                if (prompt["schoolTxt"]) 
                {
                    if (value.school) 
                    {
                        prompt["schoolTxt"].text = "学校: " + value.school;
                    }
                    else 
                    {
                        prompt["schoolTxt"].text = "学校: 未知";
                    }
                }
                if (prompt["gradeTxt"]) 
                {
                    if (value.major && value.grade) 
                    {
                        prompt["gradeTxt"].text = "详细: " + value.major + " " + value.grade;
                    }
                    else 
                    {
                        prompt["gradeTxt"].text = "专业班级: 未知";
                    }
                }
                if (prompt["head"] && value.space) 
                {
                    this.spaceurl = value.space;
                    prompt["head"].buttonMode = true;
                    prompt["head"].addEventListener(flash.events.MouseEvent.CLICK, this.onSpace);
                }
                else 
                {
                    this.spaceurl = null;
                    prompt["head"].buttonMode = false;
                    prompt["head"].removeEventListener(flash.events.MouseEvent.CLICK, this.onSpace);
                }
                try 
                {
                    bit = prompt["head"]["area"].getChildAt(0) as flash.display.Bitmap;
                }
                catch (e:Error)
                {
                };
                if (bit && bit.bitmapData) 
                {
                    bit.bitmapData.dispose();
                    bit.bitmapData = null;
                }
                if (value.bitmapData) 
                {
                    if (bit == null) 
                    {
                        bit = new flash.display.Bitmap();
                    }
                    bit.bitmapData = value.bitmapData;
                    prompt["head"]["area"].addChild(bit);
                    try 
                    {
                        bit.height = prompt["head"]["back"].width;
                        bit.width = prompt["head"]["back"].width;
                    }
                    catch (e:Error)
                    {
                    };
                    try 
                    {
                        prompt["head"]["defaultIcon"].visible = false;
                    }
                    catch (e:Error)
                    {
                    };
                }
                else 
                {
                    try 
                    {
                        prompt["head"]["defaultIcon"].visible = true;
                    }
                    catch (e:Error)
                    {
                    };
                }
            }
            else 
            {
                this.setDelay(true);
            }
            return;
        }

        protected function setDelay(arg1:Boolean):void
        {
            flash.utils.clearTimeout(this.timeout);
            if (arg1) 
            {
                this.timeout = flash.utils.setTimeout(this.onDelay, 500);
            }
            return;
        }

        protected function onDelay():void
        {
            if (skin.up && skin.up.visible) 
            {
                com.greensock.TweenLite.to(skin.up, 0.3, {"alpha":0, "onComplete":this.onHideComplete, "onCompleteParams":[skin.up]});
            }
            if (skin.down && skin.down.visible) 
            {
                com.greensock.TweenLite.to(skin.down, 0.3, {"alpha":0, "onComplete":this.onHideComplete, "onCompleteParams":[skin.down]});
            }
            return;
        }

        protected function onHideComplete(arg1:flash.display.MovieClip):void
        {
            arg1.visible = false;
            return;
        }

        protected override function init():void
        {
            if (skin) 
            {
                var loc1:*;
                skin.y = loc1 = 0;
                skin.x = loc1;
                if (skin.up) 
                {
                    skin.up.visible = false;
                    if (skin.up.username) 
                    {
                        skin.up.username.mouseEnabled = false;
                    }
                    if (skin.up.back) 
                    {
                        skin.up.back.mouseEnabled = false;
                        skin.up.back.mouseChildren = false;
                    }
                }
                if (skin.down) 
                {
                    skin.down.visible = false;
                    if (skin.down.username) 
                    {
                        skin.down.username.mouseEnabled = false;
                    }
                    if (skin.down.back) 
                    {
                        skin.down.back.mouseEnabled = false;
                        skin.down.back.mouseChildren = false;
                    }
                }
                this.addListener();
            }
            return;
        }

        internal function addListener():void
        {
            if (skin.up) 
            {
                skin.up.addEventListener(flash.events.MouseEvent.ROLL_OVER, this.onRollOver);
                skin.up.addEventListener(flash.events.MouseEvent.ROLL_OUT, this.onRollOut);
            }
            if (skin.down) 
            {
                skin.down.addEventListener(flash.events.MouseEvent.ROLL_OVER, this.onRollOver);
                skin.down.addEventListener(flash.events.MouseEvent.ROLL_OUT, this.onRollOut);
            }
            return;
        }

        internal function onRollOver(arg1:flash.events.MouseEvent):void
        {
            this.setDelay(false);
            return;
        }

        internal function onRollOut(arg1:flash.events.MouseEvent):void
        {
            this.onDelay();
            return;
        }

        internal function onSpace(arg1:flash.events.MouseEvent):void
        {
            if (this.spaceurl) 
            {
                flash.net.navigateToURL(new flash.net.URLRequest(this.spaceurl), "_blank");
            }
            return;
        }

        internal var timeout:int;

        internal var spaceurl:String;
    }
}
