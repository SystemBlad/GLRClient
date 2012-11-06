package com.letv.aiLoader 
{
    import com.letv.aiLoader.kernel.*;
    import com.letv.aiLoader.type.*;
    
    public class KernelFactory extends Object
    {
        public function KernelFactory()
        {
            super();
            return;
        }

        public static function create(arg1:String):com.letv.aiLoader.kernel.IKernel
        {
            var loc1:*=null;
            var loc2:*=arg1;
            switch (loc2) 
            {
                case com.letv.aiLoader.type.LoadOrderType.LOAD_SINGLE:
                {
                    loc1 = new com.letv.aiLoader.kernel.SingleKernel();
                    break;
                }
                case com.letv.aiLoader.type.LoadOrderType.LOAD_MULTIPLE:
                {
                    loc1 = new com.letv.aiLoader.kernel.MultiPleKernel();
                    break;
                }
                default:
                {
                    loc1 = new com.letv.aiLoader.kernel.SingleKernel();
                    break;
                }
            }
            return loc1;
        }
    }
}
