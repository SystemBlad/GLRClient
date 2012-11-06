package com.glr.vod.components.loading 
{
    import com.glr.components.*;
    import com.glr.vod.model.specail.*;
    import com.greensock.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.net.*;
    import flash.text.*;
    
    public class LoadingUI extends com.glr.components.UIComponent
    {
        public function LoadingUI(arg1:Object)
        {
            super(arg1);
            return;
        }

        public override function resize(arg1:flash.geom.Rectangle):void
        {
            if (skin && skin.stage && skin.visible) 
            {
                if (skin.back) 
                {
                    skin.back.width = skin.stage.stageWidth;
                    skin.back.height = skin.stage.stageHeight;
                }
                if (skin.tip) 
                {
                    skin.tip.x = (skin.back.width - skin.tip.width) / 2;
                    skin.tip.y = (skin.back.height - skin.tip.height) / 2;
                }
            }
            return;
        }

        public function errorConfig():void
        {
            var loc1:*;
            try 
            {
                skin.tip.label.visible = true;
                skin.tip.label.htmlText = "Error：无法正常服务,建议<a href=\'event:aa\'>刷新</a>页面重试";
            }
            catch (e:Error)
            {
            };
            try 
            {
                skin.tip.loading.visible = false;
            }
            catch (e:Error)
            {
            };
            return;
        }

        public function hide():void
        {
            if (skin && skin.stage) 
            {
                com.greensock.TweenLite.to(skin, 0.5, {"alpha":0, "onComplete":this.onHideComplete});
            }
            return;
        }

        internal function onHideComplete():void
        {
            var loc1:*;
            try 
            {
                skin.parent.removeChild(skin);
            }
            catch (e:Error)
            {
            };
            return;
        }

        protected override function init():void
        {
            var css:flash.text.StyleSheet;

            var loc1:*;
            css = null;
            try 
            {
                skin.tip.label.visible = false;
                css = new flash.text.StyleSheet();
                css.parseCSS(com.glr.vod.model.specail.Config.CSS);
                skin.tip.label.styleSheet = css;
                skin.tip.label.addEventListener(flash.events.TextEvent.LINK, this.onLabelLink);
            }
            catch (e:Error)
            {
            };
            return;
        }

        internal function onLabelLink(arg1:flash.events.TextEvent):void
        {
            var event:flash.events.TextEvent;
            var url:String;

            var loc1:*;
            url = null;
            event = arg1;
            try 
            {
                url = com.glr.vod.model.specail.FlashVarVO.getInstance().url;
                if (url) 
                {
                    flash.net.navigateToURL(new flash.net.URLRequest(url), "_self");
                }
            }
            catch (e:Error)
            {
            };
            return;
        }
    }
}
