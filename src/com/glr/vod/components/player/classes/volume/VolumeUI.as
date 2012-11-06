package com.glr.vod.components.player.classes.volume 
{
    import com.glr.components.*;
    import com.glr.components.dragbar.*;
    import com.glr.vod.components.player.*;
    import com.glr.vod.model.specail.*;
    import flash.events.*;
    
    public class VolumeUI extends com.glr.components.UIComponent
    {
        public function VolumeUI(arg1:Object, arg2:Object=null)
        {
            super(arg1, arg2);
            return;
        }

        protected override function init():void
        {
            if (skin) 
            {
                this.dragbar = new com.glr.components.dragbar.Dragbar(skin);
                this.dragbar.addEventListener(com.glr.components.dragbar.DragbarEvent.CHANGE, this.onChange);
                if (skin.icon) 
                {
                    skin.icon.gotoAndStop(2);
                    skin.icon.addEventListener(flash.events.MouseEvent.CLICK, this.onMute);
                }
                this.dragbar.percent = 1.5 / com.glr.vod.model.specail.Config.VOLUME_MAX;
                this.onChange();
            }
            return;
        }

        internal function onChange(arg1:com.glr.components.dragbar.DragbarEvent=null):void
        {
            if (this.dragbar.percent != 0) 
            {
                skin.icon.gotoAndStop(2);
            }
            else 
            {
                skin.icon.gotoAndStop(1);
            }
            var loc1:*=this.dragbar.percent * com.glr.vod.model.specail.Config.VOLUME_MAX;
            var loc2:*=new com.glr.vod.components.player.PlayerEvent(com.glr.vod.components.player.PlayerEvent.VOLUME_CHANGE);
            loc2.dataProvider = loc1;
            dispatchEvent(loc2);
            return;
        }

        internal function onMute(arg1:flash.events.MouseEvent):void
        {
            var event:flash.events.MouseEvent;

            var loc1:*;
            event = arg1;
            try 
            {
                if (skin.icon.currentFrame != 1) 
                {
                    this.dragbar.percent = 0;
                }
                else 
                {
                    this.dragbar.percent = 1.5 / com.glr.vod.model.specail.Config.VOLUME_MAX;
                }
                this.onChange();
            }
            catch (e:Error)
            {
            };
            return;
        }

        internal var dragbar:com.glr.components.dragbar.Dragbar;
    }
}
