package com.letv.aiLoader.utils 
{
    import flash.system.*;
    import flash.utils.*;
    
    public class DeCompress extends Object
    {
        public function DeCompress()
        {
            super();
            return;
        }

        public static function decode(arg1:flash.utils.ByteArray):flash.utils.ByteArray
        {
            if (arg1 == null || arg1.length < 16) 
            {
                return null;
            }
            var loc1:*=new flash.utils.ByteArray();
            loc1.length = arg1[5] | arg1[6] << 8 | arg1[7] << 16 | arg1[8] << 24;
            return new Decoder().decode(arg1[0], arg1, 13, loc1, 0, loc1.length) ? loc1 : null;
        }

        public static function decodeSWF(arg1:flash.utils.ByteArray):flash.utils.ByteArray
        {
            if (int(flash.system.Capabilities.version.split(new RegExp("[ ,]+"))[1]) > 10) 
            {
                return arg1;
            }
            if (arg1 == null || arg1.length < 32) 
            {
                return null;
            }
            var loc1:*=new flash.utils.ByteArray();
            loc1.length = arg1[4] | arg1[5] << 8 | arg1[6] << 16 | arg1[7] << 24;
            if (!new Decoder().decode(arg1[12], arg1, 17, loc1, 8, loc1.length - 8)) 
            {
                return null;
            }
            var loc2:*=0;
            while (loc2 < 8) 
            {
                loc1[loc2] = arg1[loc2];
                ++loc2;
            }
            loc1[0] = 70;
            loc1[3] = arg1[13] > 0 ? arg1[13] : 10;
            return loc1;
        }
    }
}

import __AS3__.vec.*;
import flash.utils.*;


class Decoder extends Object
{
    public function Decoder()
    {
        super();
        return;
    }

    public function decode(arg1:int, arg2:flash.utils.ByteArray, arg3:int, arg4:flash.utils.ByteArray, arg5:int, arg6:int):Boolean
    {
        var loc1:*=0;
        var loc2:*=0;
        var loc3:*=0;
        var loc4:*=0;
        var loc5:*=0;
        var loc6:*=0;
        var loc7:*=0;
        var loc8:*=0;
        var loc9:*=0;
        var loc10:*=0;
        var loc28:*=0;
        var loc29:*=0;
        var loc30:*=0;
        var loc31:*=0;
        var loc32:*=0;
        var loc33:*=0;
        var loc34:*=0;
        var loc35:*=0;
        var loc36:*=0;
        var loc37:*=0;
        var loc11:*=1 << arg1 / 9 / 5;
        var loc12:*=arg1 / 9 % 5;
        var loc13:*=arg1 % 9;
        var loc14:*=(1 << loc12 - 1);
        var loc15:*=1 << loc13 + loc12;
        var loc16:*=new Vector.<int>(114, true);
        var loc17:*=new Vector.<int>(12, true);
        var loc18:*=new Vector.<int>(12, true);
        var loc19:*=new Vector.<int>(12, true);
        var loc20:*=new Vector.<int>(12, true);
        var loc21:*=new Vector.<int>(192, true);
        var loc22:*=new Vector.<int>(192, true);
        var loc23:*=new Vector.<Vector.<int>>(loc15, true);
        var loc24:*=new Vector.<BitTreeDecoder>(4, true);
        var loc25:*=new BitTreeDecoder(4);
        var loc26:*=new LenDecoder(loc11);
        var loc27:*=new LenDecoder(loc11--);
        initBitModels(loc22);
        initBitModels(loc18);
        initBitModels(loc19);
        initBitModels(loc20);
        initBitModels(loc21);
        initBitModels(loc17);
        initBitModels(loc16);
        loc6 = 0;
        while (loc6 < loc15) 
        {
            var loc38:*;
            loc23[loc6] = loc38 = new Vector.<int>(768, true);
            initBitModels(loc38);
            ++loc6;
        }
        loc6 = 0;
        while (loc6 < 4) 
        {
            loc24[loc6] = new BitTreeDecoder(6);
            ++loc6;
        }
        loc6 = 0;
        while (loc6 < 5) 
        {
            this.code = this.code << 8 | arg2[arg3 + loc6];
            ++loc6;
        }
        this.inputPos = this.inputPos + arg3;
        this.inputData = arg2;
        while (loc5 < arg6) 
        {
            loc28 = loc5 & loc11;
            if (this.decodeBit(loc21, (loc3 << 4) + loc28) == 0) 
            {
                loc6 = ((loc5 & loc14) << loc13) + ((loc4 & 255) >>> 8 - loc13);
                if (loc3 < 7) 
                {
                    loc4 = 1;
                    while (loc4 < 256) 
                    {
                        loc4 = loc4 << 1 | this.decodeBit(loc23[loc6], loc4);
                    }
                }
                else 
                {
                    loc29 = arg4[(arg5 - loc7 - 1)];
                    loc4 = 1;
                    while (loc4 < 256) 
                    {
                        loc30 = loc29 >> 7 & 1;
                        loc1 = this.decodeBit(loc23[loc6], (1 + loc30 << 8) + loc4);
                        loc4 = loc4 << 1 | loc1;
                        if (loc30 != loc1) 
                        {
                            while (loc4 < 256) 
                            {
                                loc4 = loc4 << 1 | this.decodeBit(loc23[loc6], loc4);
                            }
                        }
                        loc29 = loc29 << 1;
                    }
                }
                loc3 = loc3 < 4 ? 0 : loc3 < 10 ? loc3 - 3 : loc3 - 6;
                arg4[loc38 = arg5++] = loc4;
                ++loc5;
                continue;
            }
            if (this.decodeBit(loc17, loc3) != 1) 
            {
                loc10 = loc9;
                loc9 = loc8;
                loc8 = loc7;
                loc3 = loc3 < 7 ? 7 : 10;
                loc2 = loc27.decode(this, loc28) + 2;
                if ((loc32 = loc24[loc2 - 2 < 4 ? loc2 - 2 : 3].decode(this)) >= 4) 
                {
                    loc33 = (loc32 >> 1 - 1);
                    loc7 = (2 | loc32 & 1) << loc33;
                    if (loc32 < 14) 
                    {
                        loc34 = 1;
                        loc35 = 0;
                        loc36 = (loc7 - loc32 - 1);
                        loc37 = 0;
                        while (loc37 < loc33) 
                        {
                            loc1 = this.decodeBit(loc16, loc36 + loc34);
                            loc34 = (loc34 = loc34 << 1) + loc1;
                            loc35 = loc35 | loc1 << loc37;
                            ++loc37;
                        }
                        loc7 = loc7 + loc35;
                    }
                    else if ((loc7 = (loc7 = loc7 + (this.decodeDirectBits(loc33 - 4) << 4)) + loc25.reverseDecode(this)) < 0) 
                    {
                        if (loc7 == -1) 
                        {
                            break;
                        }
                        return false;
                    }
                }
                else 
                {
                    loc7 = loc32;
                }
            }
            else 
            {
                loc2 = 0;
                if (this.decodeBit(loc18, loc3) != 0) 
                {
                    if (this.decodeBit(loc19, loc3) != 0) 
                    {
                        if (this.decodeBit(loc20, loc3) != 0) 
                        {
                            loc31 = loc10;
                            loc10 = loc9;
                        }
                        else 
                        {
                            loc31 = loc9;
                        }
                        loc9 = loc8;
                    }
                    else 
                    {
                        loc31 = loc8;
                    }
                    loc8 = loc7;
                    loc7 = loc31;
                }
                else if (this.decodeBit(loc22, (loc3 << 4) + loc28) == 0) 
                {
                    loc3 = loc3 < 7 ? 9 : 11;
                    loc2 = 1;
                }
                if (loc2 == 0) 
                {
                    loc2 = loc26.decode(this, loc28) + 2;
                    loc3 = loc3 < 7 ? 8 : 11;
                }
            }
            loc6 = 0;
            while (loc6 < loc2) 
            {
                arg4[arg5] = arg4[(arg5 - loc7 - 1)];
                ++arg5;
                ++loc6;
            }
            loc5 = loc5 + loc2;
            loc4 = arg4[(arg5 - 1)];
        }
        arg2 = null;
        return true;
    }

    public function decodeBit(arg1:__AS3__.vec.Vector.<int>, arg2:int):int
    {
        var loc1:*=arg1[arg2];
        var loc2:*=(this.range >>> 11) * loc1;
        if ((this.code ^ 2147483648) < (loc2 ^ 2147483648)) 
        {
            this.range = loc2;
            arg1[arg2] = loc1 + (2048 - loc1 >>> 5);
            if ((this.range & 4278190080) == 0) 
            {
                this.code = this.code << 8 | this.inputData[this.inputPos];
                var loc3:*;
                var loc4:*=((loc3 = this).inputPos + 1);
                loc3.inputPos = loc4;
                this.range = this.range << 8;
            }
            return 0;
        }
        this.range = this.range - loc2;
        this.code = this.code - loc2;
        arg1[arg2] = loc1 - (loc1 >>> 5);
        if ((this.range & 4278190080) == 0) 
        {
            this.code = this.code << 8 | this.inputData[this.inputPos];
            loc4 = ((loc3 = this).inputPos + 1);
            loc3.inputPos = loc4;
            this.range = this.range << 8;
        }
        return 1;
    }

    public function decodeDirectBits(arg1:int):int
    {
        var loc3:*=0;
        var loc1:*=0;
        var loc2:*=arg1;
        while (loc2 != 0) 
        {
            this.range = this.range >>> 1;
            loc3 = this.code - this.range >>> 31;
            this.code = this.code - (this.range & (loc3 - 1));
            loc1 = loc1 << 1 | 1 - loc3;
            if ((this.range & 4278190080) == 0) 
            {
                this.code = this.code << 8 | this.inputData[this.inputPos];
                var loc4:*;
                var loc5:*=((loc4 = this).inputPos + 1);
                loc4.inputPos = loc5;
                this.range = this.range << 8;
            }
            --loc2;
        }
        return loc1;
    }

    internal var code:int=0;

    internal var range:int=-1;

    internal var inputPos:int=5;

    internal var inputData:flash.utils.ByteArray;
}

class LenDecoder extends Object
{
    public function LenDecoder(arg1:int)
    {
        this.lowCoder = new Vector.<BitTreeDecoder>(16, true);
        this.midCoder = new Vector.<BitTreeDecoder>(16, true);
        this.highCoder = new BitTreeDecoder(8);
        this.choice = new Vector.<int>(2, true);
        super();
        initBitModels(this.choice);
        var loc1:*=0;
        while (loc1 < arg1) 
        {
            this.lowCoder[loc1] = new BitTreeDecoder(3);
            this.midCoder[loc1] = new BitTreeDecoder(3);
            ++loc1;
        }
        return;
    }

    public function decode(arg1:Decoder, arg2:int):int
    {
        if (arg1.decodeBit(this.choice, 0) == 0) 
        {
            return this.lowCoder[arg2].decode(arg1);
        }
        var loc1:*=8;
        if (arg1.decodeBit(this.choice, 1) != 0) 
        {
            loc1 = loc1 + (8 + this.highCoder.decode(arg1));
        }
        else 
        {
            loc1 = loc1 + this.midCoder[arg2].decode(arg1);
        }
        return loc1;
    }

    internal var lowCoder:__AS3__.vec.Vector.<BitTreeDecoder>;

    internal var midCoder:__AS3__.vec.Vector.<BitTreeDecoder>;

    internal var highCoder:BitTreeDecoder;

    internal var choice:__AS3__.vec.Vector.<int>;
}

class BitTreeDecoder extends Object
{
    public function BitTreeDecoder(arg1:int)
    {
        super();
        this.models = new Vector.<int>(1 << arg1, true);
        initBitModels(this.models);
        this.numBitLevels = arg1;
        return;
    }

    public function decode(arg1:Decoder):int
    {
        var loc1:*=1;
        var loc2:*=this.numBitLevels;
        while (loc2 != 0) 
        {
            loc1 = (loc1 << 1) + arg1.decodeBit(this.models, loc1);
            --loc2;
        }
        return loc1 - (1 << this.numBitLevels);
    }

    public function reverseDecode(arg1:Decoder):int
    {
        var loc4:*=0;
        var loc1:*=1;
        var loc2:*=0;
        var loc3:*=0;
        while (loc3 < this.numBitLevels) 
        {
            loc4 = arg1.decodeBit(this.models, loc1);
            loc1 = loc1 << 1;
            loc1 = loc1 + loc4;
            loc2 = loc2 | loc4 << loc3;
            ++loc3;
        }
        return loc2;
    }

    internal var numBitLevels:int;

    internal var models:__AS3__.vec.Vector.<int>;
}

const initBitModels:Function=function (arg1:__AS3__.vec.Vector.<int>):void
{
    var loc1:*=0;
    var loc2:*=arg1.length;
    while (loc1 < loc2) 
    {
        var loc3:*;
        arg1[loc1] = loc3 = 1024;
        loc3;
        ++loc1;
    }
    return;
}