package com.letv.aiLoader.kernel 
{
    import flash.events.*;
    
    public interface IKernel extends flash.events.IEventDispatcher
    {
        function destroy():void;

        function start(arg1:Array):void;
    }
}
