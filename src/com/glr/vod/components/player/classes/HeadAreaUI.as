package com.glr.vod.components.player.classes 
{
    import com.glr.components.*;
    import com.glr.vod.model.specail.*;
    import com.greensock.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.net.*;
    import flash.system.*;
    import flash.utils.*;
    
    public class HeadAreaUI extends com.glr.components.UIComponent
    {
        public function HeadAreaUI(arg1:Object, arg2:Object)
        {
            super(arg1, arg2);
            return;
        }

        public override function resize(arg1:flash.geom.Rectangle):void
        {
            if (skin && skin.stage) 
            {
                this.originalX = arg1.width - skin.width / 2 - 10;
                this.originalY = arg1.height - skin.height / 2 - com.glr.vod.model.specail.Config.C_HEI - 20 - 10;
                com.greensock.TweenLite.to(skin, 0.3, {"x":this.originalX, "y":this.originalY});
            }
            return;
        }

        public override function set enabled(arg1:Boolean):void
        {
            super.enabled = arg1;
            if (arg1) 
            {
                this.setupHeadIcon();
            }
            return;
        }

        protected override function init():void
        {
            var loc1:*;
            visible = false;
            try 
            {
                skin.cacheAsBitmap = true;
            }
            catch (e:Error)
            {
            };
            try 
            {
                skin.mouseChildren = false;
            }
            catch (e:Error)
            {
            };
            try 
            {
                skin.mouseEnabled = false;
            }
            catch (e:Error)
            {
            };
            return;
        }

        internal function setupHeadIcon():void
        {
            var loc1:*;
            if (this.loader == null) 
            {
                this.loader = new flash.display.Loader();
                this.loader.contentLoaderInfo.addEventListener(flash.events.IOErrorEvent.IO_ERROR, this.onLoadError);
                this.loader.contentLoaderInfo.addEventListener(flash.events.SecurityErrorEvent.SECURITY_ERROR, this.onLoadError);
                this.loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, this.onLoadComplete);
                try 
                {
                    this.loader.load(new flash.net.URLRequest(config.pubpic), new flash.system.LoaderContext(true));
                }
                catch (e:Error)
                {
                    onLoadError();
                }
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
                this.loader.content["smoothing"] = true;
            }
            catch (e:Error)
            {
            };
            if (skin.masker) 
            {
                this.loader.height = skin.masker.width;
                this.loader.width = skin.masker.width;
                this.loader.y =  (-skin.masker.width) / 2;
                this.loader.x = (-skin.masker.width) / 2;
            }
            if (skin.container) 
            {
                skin.container.addChild(this.loader);
            }
            if (skin) 
            {
                skin.alpha = 0;
                skin.x = this.originalX - 200;
                skin.y = this.originalY - 300;
                visible = true;
                com.greensock.TweenLite.to(skin, 0.5, {"alpha":1, "x":this.originalX, "y":this.originalY});
                flash.utils.setInterval(this.onLoop, 3000);
            }
            return;
        }

        internal function onLoop():void
        {
            var loc1:*=new com.greensock.TimelineLite();
            loc1.append(new com.greensock.TweenLite(skin, 0.5, {"alpha":0.6}));
            loc1.append(new com.greensock.TweenLite(skin, 0.5, {"alpha":1}));
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

        internal var originalX:Number=0;

        internal var originalY:Number=0;

        internal var loader:flash.display.Loader;
    }
}
