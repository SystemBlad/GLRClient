package com.glr.vod.facade 
{
    import com.glr.vod.controller.*;
    import com.glr.vod.model.*;
    import com.glr.vod.view.mediator.*;
    
    import flash.display.*;
    
    public class Facade extends Object
    {
        public function Facade(arg1:flash.display.Sprite, url:String)
        {
            super();
            var loc1:*=new com.glr.vod.model.Model();
            var loc2:*=new com.glr.vod.controller.Controller(loc1, url);
            this.init = new com.glr.vod.view.mediator.GlobalMediator(arg1, loc1, loc2);
          //  this.menu = new com.glr.vod.view.mediator.MenuMediator(arg1, loc1, loc2);
            this.player = new com.glr.vod.view.mediator.PlayerMediator(arg1, loc1, loc2);
           // this.chat = new com.glr.vod.view.mediator.ChatMediator(arg1, loc1, loc2);
            this.loading = new com.glr.vod.view.mediator.LoadingMediator(arg1, loc1, loc2);
            //this.prompt = new com.glr.vod.view.mediator.PromptMediator(arg1, loc1, loc2);
            return;
        }

        internal var menu:com.glr.vod.view.mediator.MenuMediator;

        internal var player:com.glr.vod.view.mediator.PlayerMediator;

        internal var chat:com.glr.vod.view.mediator.ChatMediator;

        internal var loading:com.glr.vod.view.mediator.LoadingMediator;

        internal var init:com.glr.vod.view.mediator.GlobalMediator;

        internal var prompt:com.glr.vod.view.mediator.PromptMediator;
    }
}
