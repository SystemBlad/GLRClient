package com.glr.vod.components.chat.classes 
{
    import com.glr.components.error.*;
    import com.glr.vod.components.chat.*;
    import com.glr.vod.identity.*;
    import com.glr.vod.model.specail.*;
    import com.greensock.*;
    import flash.display.*;
    import flash.events.*;
    import flash.filters.*;
    import flash.geom.*;
    import flash.net.*;
    import flash.system.*;
    import flash.text.*;
    
    public class ChatItem extends flash.display.Sprite
    {
        public function ChatItem(arg1:Object, arg2:Object)
        {
            super();
            this.info = arg2;
            this.skin = arg1 as flash.display.Sprite;
            if (this.skin) 
            {
                addChild(this.skin);
                this.init();
            }
            else 
            {
                throw new com.glr.components.error.ComponentError("ChatItem.Skin Error");
            }
            return;
        }

        public function destroy():void
        {
            var loc1:*;
            this.removeListener();
            this.destroyHeadIcon(true);
            try 
            {
                this.skin.parent.removeChild(this.skin);
            }
            catch (e:Error)
            {
            };
            this.skin = null;
            this.info = null;
            return;
        }

        public function get fromID():String
        {
            var loc1:*;
            try 
            {
                return this.info.id;
            }
            catch (e:Error)
            {
            };
            return "未知";
        }

        public function get fromUser():String
        {
            var loc1:*;
            if (this.identity == com.glr.vod.identity.Identity.SYS_USER) 
            {
                return "课程小秘书";
            }
            try 
            {
                return this.info.name;
            }
            catch (e:Error)
            {
            };
            return "未知";
        }

        public function get identity():String
        {
            var loc1:*;
            try 
            {
                return this.info.identity;
            }
            catch (e:Error)
            {
            };
            return com.glr.vod.identity.Identity.LIVE_SUBSCRIBER;
        }

        public function get userpic():String
        {
            var loc1:*;
            try 
            {
                return this.info.avatar;
            }
            catch (e:Error)
            {
            };
            return null;
        }

        public function get content():String
        {
            var value:String;
            var arr:Array;
            var j:int;
            var linkStr:String;
            var linkNewStr:String;
            var linkPosition:int;

            var loc1:*;
            value = null;
            arr = null;
            j = 0;
            linkStr = null;
            linkNewStr = null;
            linkPosition = 0;
            try 
            {
                value = this.info.value;
                arr = value.split(" ");
                value = "";
                j = 0;
                while (j < arr.length) 
                {
                    linkStr = arr[j];
                    linkNewStr = "";
                    linkPosition = linkStr.indexOf("http://");
                    if (linkPosition >= 0) 
                    {
                        linkNewStr = linkNewStr + linkStr.substr(0, linkPosition);
                        linkNewStr = linkNewStr + ("<a href=\'" + linkStr.substr(linkPosition) + "\' target=\'_blank\'>" + linkStr.substr(linkPosition));
                        linkNewStr = linkNewStr + "</a>";
                    }
                    else 
                    {
                        linkNewStr = linkStr;
                    }
                    if (j != 0) 
                    {
                        value = value + (" " + linkNewStr);
                    }
                    else 
                    {
                        value = value + linkNewStr;
                    }
                    ++j;
                }
                return value;
            }
            catch (e:Error)
            {
            };
            return "内容未知";
        }

        public function set shutup(arg1:Boolean):void
        {
            if (this.skin["mute"]) 
            {
                this.skin["mute"].gotoAndStop(arg1 ? 2 : 1);
            }
            return;
        }

        internal function init():void
        {
            var format:flash.text.TextFormat;
            var css:flash.text.StyleSheet;

            var loc1:*;
            this.skin.filters = [new flash.filters.GlowFilter(10066329, 0.5, 1, 1)];
            if (this.skin["username"]) 
            {
                this.skin["username"].wordWrap = false;
                this.skin["username"].text = this.fromUser;
                this.skin["username"].mouseEnabled = false;
                this.skin["username"].mouseWheelEnabled = false;
            }
            this.skin["content"] = new flash.text.TextField();
            this.skin["content"].x = 56;
            this.skin["content"].y = 6;
            this.skin["content"].width = 210;
            this.skin.addChild(this.skin["content"]);
            format = new flash.text.TextFormat();
            format.font = "微软雅黑,Arial,宋体";
            format.color = "0x5B5B5B";
            this.skin["content"].defaultTextFormat = format;
            css = new flash.text.StyleSheet();
            css.parseCSS(com.glr.vod.model.specail.Config.CSS);
            this.skin["content"].htmlText = this.fromUser + " : " + this.content;
            this.skin["content"].wordWrap = true;
            this.skin["content"].multiline = true;
            this.skin["content"].autoSize = "left";
            this.skin["content"].styleSheet = css;
            var loc2:*=this.identity;
            switch (loc2) 
            {
                case com.glr.vod.identity.Identity.LIVE_PUBLISHER:
                {
                    if (this.skin["mute"]) 
                    {
                        this.skin["mute"].visible = false;
                    }
                    if (this.skin["identify"]) 
                    {
                        this.skin["identify"].gotoAndStop(1);
                    }
                    break;
                }
                case com.glr.vod.identity.Identity.LIVE_SUBSCRIBER:
                {
                    if (this.skin["identify"]) 
                    {
                        this.skin["identify"].gotoAndStop(2);
                    }
                    break;
                }
                case com.glr.vod.identity.Identity.SYS_USER:
                {
                    if (this.skin["mute"]) 
                    {
                        this.skin["mute"].visible = false;
                    }
                    if (this.skin["identify"]) 
                    {
                        this.skin["identify"].gotoAndStop(3);
                    }
                    break;
                }
            }
            if (this.skin["mute"]) 
            {
                this.skin["mute"].visible = false;
            }
            if (this.identity != com.glr.vod.identity.Identity.SYS_USER) 
            {
                if (this.userpic && !(this.userpic == "")) 
                {
                    this.setupHeadIcon();
                }
            }
            else 
            {
                try 
                {
                    this.skin["head"]["defaultIcon"].gotoAndStop(2);
                }
                catch (e:Error)
                {
                };
            }
            if (this.identity != com.glr.vod.identity.Identity.SYS_USER) 
            {
                this.skin["head"].addEventListener(flash.events.MouseEvent.ROLL_OVER, this.onShowPrompt);
                this.skin["head"].addEventListener(flash.events.MouseEvent.ROLL_OUT, this.onHidePrompt);
            }
            this.skin["head"].mouseChildren = false;
            this.skin["back"].back.height = this.skin["content"].y + this.skin["content"].height + 3;
            if (this.skin["gap"]) 
            {
                this.skin["gap"].height = this.skin["back"].y + this.skin["back"].height + 2;
            }
            return;
        }

        internal function removeListener():void
        {
            var loc1:*;
            try 
            {
                com.greensock.TweenLite.killTweensOf(this);
            }
            catch (e:Error)
            {
            };
            if (this.skin["head"]) 
            {
                this.skin["head"].removeEventListener(flash.events.MouseEvent.ROLL_OVER, this.onShowPrompt);
                this.skin["head"].removeEventListener(flash.events.MouseEvent.ROLL_OUT, this.onHidePrompt);
            }
            return;
        }

        internal function setupHeadIcon():void
        {
            var loc1:*;
            this.loader = new flash.display.Loader();
            this.loader.contentLoaderInfo.addEventListener(flash.events.IOErrorEvent.IO_ERROR, this.onLoadError);
            this.loader.contentLoaderInfo.addEventListener(flash.events.SecurityErrorEvent.SECURITY_ERROR, this.onLoadError);
            this.loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, this.onLoadComplete);
            try 
            {
                this.loader.load(new flash.net.URLRequest(this.userpic), new flash.system.LoaderContext(true));
            }
            catch (e:Error)
            {
                destroyHeadIcon(true);
            }
            return;
        }

        internal function onLoadError(arg1:*=null):void
        {
            this.destroyHeadIcon(true);
            return;
        }

        internal function onLoadComplete(arg1:flash.events.Event):void
        {
            var event:flash.events.Event;

            var loc1:*;
            event = arg1;
            this.destroyHeadIcon(false);
            try 
            {
                this.skin["head"]["defaultIcon"].visible = false;
            }
            catch (e:Error)
            {
            };
            try 
            {
                this.loader.height = this.skin["head"]["back"].width;
                this.loader.width = this.skin["head"]["back"].width;
            }
            catch (e:Error)
            {
            };
            try 
            {
                this.skin["head"]["area"].addChild(this.loader);
            }
            catch (e:Error)
            {
            };
            return;
        }

        internal function destroyHeadIcon(arg1:Boolean=false):void
        {
            var gc:Boolean=false;

            var loc1:*;
            gc = arg1;
            try 
            {
                this.loader.close();
            }
            catch (e:Error)
            {
            };
            if (this.loader) 
            {
                this.loader.contentLoaderInfo.removeEventListener(flash.events.IOErrorEvent.IO_ERROR, this.onLoadError);
                this.loader.contentLoaderInfo.removeEventListener(flash.events.SecurityErrorEvent.SECURITY_ERROR, this.onLoadError);
                this.loader.contentLoaderInfo.removeEventListener(flash.events.Event.COMPLETE, this.onLoadComplete);
                if (gc) 
                {
                    try 
                    {
                        this.loader.parent.removeChild(this.loader);
                    }
                    catch (e:Error)
                    {
                    };
                    this.loader.unload();
                    this.loader.unloadAndStop();
                    this.loader = null;
                }
            }
            return;
        }

        internal function onShowPrompt(arg1:flash.events.MouseEvent):void
        {
            var event:flash.events.MouseEvent;
            var obj:Object;
            var currentP:flash.geom.Point;
            var p:flash.geom.Point;
            var bitmapdata:flash.display.BitmapData;
            var e:com.glr.vod.components.chat.ChatEvent;

            var loc1:*;
            bitmapdata = null;
            event = arg1;
            obj = this.info;
            obj["visible"] = true;
            currentP = new flash.geom.Point(this.skin["head"].x + this.skin["head"].width / 2, this.skin["head"].y + this.skin["head"].height / 2);
            p = this.skin.localToGlobal(currentP);
            if (p.y > this.stage.stageHeight / 2) 
            {
                currentP.y = this.skin["head"].y;
                obj["choose"] = "up";
            }
            else 
            {
                currentP.y = this.skin["head"].y + this.skin["head"].height;
                obj["choose"] = "down";
            }
            p = this.skin.localToGlobal(currentP);
            obj["position"] = p;
            try 
            {
                bitmapdata = this.loader.content["bitmapData"].clone();
            }
            catch (e:Error)
            {
            };
            obj["bitmapData"] = bitmapdata;
            e = new com.glr.vod.components.chat.ChatEvent(com.glr.vod.components.chat.ChatEvent.CHANGE_PROMPT);
            e.dataProvider = obj;
            dispatchEvent(e);
            return;
        }

        internal function onHidePrompt(arg1:flash.events.MouseEvent):void
        {
            var loc1:*=new com.glr.vod.components.chat.ChatEvent(com.glr.vod.components.chat.ChatEvent.CHANGE_PROMPT);
            loc1.dataProvider = {"visible":false};
            dispatchEvent(loc1);
            return;
        }

        protected var info:Object;

        protected var skin:flash.display.Sprite;

        internal var loader:flash.display.Loader;
    }
}
