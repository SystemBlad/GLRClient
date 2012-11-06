package com.glr.vod.view 
{
    import com.glr.vod.controller.*;
    import com.glr.vod.facade.*;
    import com.glr.vod.model.*;
    import flash.display.*;
    
    public class Mediator extends com.glr.vod.facade.Notifier
    {
        public function Mediator(arg1:String, arg2:flash.display.Sprite, arg3:com.glr.vod.model.Model, arg4:com.glr.vod.controller.Controller)
        {
            super(arg1);
            this.main = arg2;
            this.model = arg3;
            this.controller = arg4;
            this.onRegister();
            return;
        }

        protected function onRegister():void
        {
            return;
        }

        protected var main:flash.display.Sprite;

        protected var model:com.glr.vod.model.Model;

        protected var controller:com.glr.vod.controller.Controller;
    }
}
