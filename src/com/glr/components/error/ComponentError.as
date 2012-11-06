package com.glr.components.error 
{
    public class ComponentError extends Error
    {
        public function ComponentError(arg1:*="", arg2:*=0)
        {
            super(arg1, arg2);
            return;
        }

        public static const ENTER_INSTANCE_INVALID:String="enterInstanceInvalid";
    }
}
