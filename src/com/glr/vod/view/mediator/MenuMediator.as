package com.glr.vod.view.mediator 
{
    import com.glr.vod.controller.*;
    import com.glr.vod.model.*;
    import com.glr.vod.model.specail.*;
    import com.glr.vod.view.*;
    import flash.display.*;
    import flash.ui.*;
    
    public class MenuMediator extends com.glr.vod.view.Mediator
    {
        public function MenuMediator(arg1:flash.display.Sprite, arg2:com.glr.vod.model.Model, arg3:com.glr.vod.controller.Controller)
        {
            super(NAME, arg1, arg2, arg3);
            return;
        }

        protected override function onRegister():void
        {
            //var loc1:*=new flash.ui.ContextMenu();
            //loc1.hideBuiltInItems();
            //var loc2:*=new flash.ui.ContextMenuItem(com.glr.vod.model.specail.Config.VERSION, true);
            //loc1.customItems.push(loc2);
            //main.contextMenu = loc1;
            return;
        }

        public static const NAME:String="menuMediator";
    }
}
