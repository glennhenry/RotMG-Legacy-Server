package ion.utils.png
{
   import flash.display.BitmapData;
   import flash.utils.ByteArray;
   
   public class PNGDecoder
   {
      
      private static var infoWidth:uint;
      
      private static var infoHeight:uint;
      
      private static var infoBitDepth:int;
      
      private static var infoColourType:int;
      
      private static var infoCompressionMethod:int;
      
      private static var infoFilterMethod:int;
      
      private static var infoInterlaceMethod:int;
      
      private static var fileIn:ByteArray;
      
      private static var buffer:ByteArray;
      
      private static var scanline:int;
      
      private static var samples:int;
      
      private static const IHDR:int = 1229472850;
      
      private static const IDAT:int = 1229209940;
      
      private static const tEXt:int = 1950701684;
      
      private static const iTXt:int = 1767135348;
      
      private static const zTXt:int = 2052348020;
      
      private static const IEND:int = 1229278788;
      
      public function PNGDecoder()
      {
         super();
      }
      
      public static function decodeImage(param1:ByteArray) : BitmapData
      {
         var _loc4_:Boolean = false;
         var _loc5_:int = 0;
         if(param1 == null)
         {
            return null;
         }
         fileIn = param1;
         buffer = new ByteArray();
         samples = 4;
         fileIn.position = 0;
         if(fileIn.readUnsignedInt() != 2303741511)
         {
            return invalidPNG();
         }
         if(fileIn.readUnsignedInt() != 218765834)
         {
            return invalidPNG();
         }
         var _loc2_:Array = getChunks();
         var _loc3_:int = 0;
         _loc5_ = 0;
         while(_loc5_ < _loc2_.length)
         {
            fileIn.position = _loc2_[_loc5_].position;
            _loc4_ = true;
            if(_loc2_[_loc5_].type == IHDR)
            {
               _loc3_++;
               if(_loc5_ == 0)
               {
                  _loc4_ = processIHDR(_loc2_[_loc5_].length);
               }
               else
               {
                  _loc4_ = false;
               }
            }
            if(_loc2_[_loc5_].type == IDAT)
            {
               buffer.writeBytes(fileIn,fileIn.position,_loc2_[_loc5_].length);
            }
            if(!_loc4_ || _loc3_ > 1)
            {
               return invalidPNG();
            }
            _loc5_++;
         }
         var _loc6_:BitmapData = processIDAT();
         fileIn = null;
         buffer = null;
         return _loc6_;
      }
      
      public static function decodeInfo(param1:ByteArray) : XML
      {
         var _loc4_:int = 0;
         if(param1 == null)
         {
            return null;
         }
         fileIn = param1;
         fileIn.position = 0;
         if(fileIn.readUnsignedInt() != 2303741511)
         {
            fileIn = null;
            return null;
         }
         if(fileIn.readUnsignedInt() != 218765834)
         {
            fileIn = null;
            return null;
         }
         var _loc2_:Array = getChunks();
         var _loc3_:XML = <information/>;
         _loc4_ = 0;
         while(_loc4_ < _loc2_.length)
         {
            if(_loc2_[_loc4_].type == tEXt)
            {
               _loc3_.appendChild(gettEXt(_loc2_[_loc4_].position,_loc2_[_loc4_].length));
            }
            if(_loc2_[_loc4_].type == iTXt)
            {
               _loc3_.appendChild(getiTXt(_loc2_[_loc4_].position,_loc2_[_loc4_].length));
            }
            if(_loc2_[_loc4_].type == zTXt)
            {
               _loc3_.appendChild(getzTXt(_loc2_[_loc4_].position,_loc2_[_loc4_].length));
            }
            _loc4_++;
         }
         fileIn = null;
         return _loc3_;
      }
      
      private static function gettEXt(param1:int, param2:int) : XML
      {
         var _loc3_:XML = <tEXt/>;
         var _loc4_:String = "";
         var _loc5_:String = "";
         var _loc6_:int = -1;
         fileIn.position = param1;
         while(fileIn.position < param1 + param2)
         {
            _loc6_ = int(fileIn.readUnsignedByte());
            if(_loc6_ <= 0)
            {
               break;
            }
            _loc4_ += String.fromCharCode(_loc6_);
         }
         _loc5_ = fileIn.readUTFBytes(param1 + param2 - fileIn.position);
         _loc3_.appendChild(<keyword>{_loc4_}</keyword>);
         _loc3_.appendChild(<text>{_loc5_}</text>);
         return _loc3_;
      }
      
      private static function getzTXt(param1:int, param2:int) : XML
      {
         var _loc8_:ByteArray = null;
         var _loc3_:XML = <zTXt/>;
         var _loc4_:String = "";
         var _loc5_:String = "";
         var _loc6_:int = -1;
         fileIn.position = param1;
         while(fileIn.position < param1 + param2)
         {
            _loc6_ = int(fileIn.readUnsignedByte());
            if(_loc6_ <= 0)
            {
               break;
            }
            _loc4_ += String.fromCharCode(_loc6_);
         }
         var _loc7_:int = int(fileIn.readUnsignedByte());
         if(_loc7_ == 0)
         {
            _loc8_ = new ByteArray();
            _loc8_.writeBytes(fileIn,fileIn.position,param1 + param2 - fileIn.position);
            _loc8_.uncompress();
            _loc5_ = _loc8_.readUTFBytes(_loc8_.length);
         }
         _loc3_.appendChild(<keyword>{_loc4_}</keyword>);
         _loc3_.appendChild(<text>{_loc5_}</text>);
         return _loc3_;
      }
      
      private static function getiTXt(param1:int, param2:int) : XML
      {
         var _loc11_:ByteArray = null;
         var _loc3_:XML = <iTXt/>;
         var _loc4_:String = "";
         var _loc5_:String = "";
         var _loc6_:String = "";
         var _loc7_:String = "";
         var _loc8_:int = -1;
         fileIn.position = param1;
         while(fileIn.position < param1 + param2)
         {
            _loc8_ = int(fileIn.readUnsignedByte());
            if(_loc8_ <= 0)
            {
               break;
            }
            _loc4_ += String.fromCharCode(_loc8_);
         }
         var _loc9_:Boolean = fileIn.readUnsignedByte() == 1;
         var _loc10_:int = int(fileIn.readUnsignedByte());
         while(fileIn.position < param1 + param2)
         {
            _loc8_ = int(fileIn.readUnsignedByte());
            if(_loc8_ <= 0)
            {
               break;
            }
            _loc5_ += String.fromCharCode(_loc8_);
         }
         while(fileIn.position < param1 + param2)
         {
            _loc8_ = int(fileIn.readUnsignedByte());
            if(_loc8_ <= 0)
            {
               break;
            }
            _loc6_ += String.fromCharCode(_loc8_);
         }
         if(_loc9_)
         {
            if(_loc10_ == 0)
            {
               _loc11_ = new ByteArray();
               _loc11_.writeBytes(fileIn,fileIn.position,param1 + param2 - fileIn.position);
               _loc11_.uncompress();
               _loc7_ = _loc11_.readUTFBytes(_loc11_.length);
            }
         }
         else
         {
            _loc7_ = fileIn.readUTFBytes(param1 + param2 - fileIn.position);
         }
         _loc3_.appendChild(<keyword>{_loc4_}</keyword>);
         _loc3_.appendChild(<text>{_loc7_}</text>);
         _loc3_.appendChild(<languageTag>{_loc5_}</languageTag>);
         _loc3_.appendChild(<translatedKeyword>{_loc6_}</translatedKeyword>);
         return _loc3_;
      }
      
      private static function invalidPNG() : BitmapData
      {
         fileIn = null;
         buffer = null;
         return null;
      }
      
      private static function getChunks() : Array
      {
         var _loc2_:uint = 0;
         var _loc3_:int = 0;
         var _loc1_:Array = [];
         do
         {
            _loc2_ = fileIn.readUnsignedInt();
            _loc3_ = fileIn.readInt();
            _loc1_.push({
               "type":_loc3_,
               "position":fileIn.position,
               "length":_loc2_
            });
            fileIn.position += _loc2_ + 4;
         }
         while(_loc3_ != IEND && fileIn.bytesAvailable > 0);
         return _loc1_;
      }
      
      private static function processIHDR(param1:int) : Boolean
      {
         if(param1 != 13)
         {
            return false;
         }
         infoWidth = fileIn.readUnsignedInt();
         infoHeight = fileIn.readUnsignedInt();
         infoBitDepth = fileIn.readUnsignedByte();
         infoColourType = fileIn.readUnsignedByte();
         infoCompressionMethod = fileIn.readUnsignedByte();
         infoFilterMethod = fileIn.readUnsignedByte();
         infoInterlaceMethod = fileIn.readUnsignedByte();
         if(infoWidth <= 0 || infoHeight <= 0)
         {
            return false;
         }
         switch(infoBitDepth)
         {
            case 1:
            case 2:
            case 4:
            case 8:
            case 16:
               switch(infoColourType)
               {
                  case 0:
                     if(infoBitDepth != 1 && infoBitDepth != 2 && infoBitDepth != 4 && infoBitDepth != 8 && infoBitDepth != 16)
                     {
                        return false;
                     }
                     break;
                  case 2:
                  case 4:
                  case 6:
                     if(infoBitDepth != 8 && infoBitDepth != 16)
                     {
                        return false;
                     }
                     break;
                  case 3:
                     if(infoBitDepth != 1 && infoBitDepth != 2 && infoBitDepth != 4 && infoBitDepth != 8)
                     {
                        return false;
                     }
                     break;
                  default:
                     return false;
               }
               if(infoCompressionMethod != 0 || infoFilterMethod != 0)
               {
                  return false;
               }
               if(infoInterlaceMethod != 0 && infoInterlaceMethod != 1)
               {
                  return false;
               }
               return true;
               break;
            default:
               return false;
         }
      }
      
      private static function processIDAT() : BitmapData
      {
         var bufferLen:uint = 0;
         var filter:int = 0;
         var i:int = 0;
         var r:uint = 0;
         var g:uint = 0;
         var b:uint = 0;
         var a:uint = 0;
         var bd:BitmapData = new BitmapData(infoWidth,infoHeight);
         try
         {
            buffer.uncompress();
         }
         catch(err:*)
         {
            return null;
         }
         scanline = 0;
         bufferLen = buffer.length;
         while(buffer.position < bufferLen)
         {
            filter = int(buffer.readUnsignedByte());
            if(filter == 0)
            {
               i = 0;
               while(i < infoWidth)
               {
                  r = uint(noSample() << 16);
                  g = uint(noSample() << 8);
                  b = noSample();
                  a = uint(noSample() << 24);
                  bd.setPixel32(i,scanline,a + r + g + b);
                  i++;
               }
            }
            else if(filter == 1)
            {
               i = 0;
               while(i < infoWidth)
               {
                  r = uint(subSample() << 16);
                  g = uint(subSample() << 8);
                  b = subSample();
                  a = uint(subSample() << 24);
                  bd.setPixel32(i,scanline,a + r + g + b);
                  i++;
               }
            }
            else if(filter == 2)
            {
               i = 0;
               while(i < infoWidth)
               {
                  r = uint(upSample() << 16);
                  g = uint(upSample() << 8);
                  b = upSample();
                  a = uint(upSample() << 24);
                  bd.setPixel32(i,scanline,a + r + g + b);
                  i++;
               }
            }
            else if(filter == 3)
            {
               i = 0;
               while(i < infoWidth)
               {
                  r = uint(averageSample() << 16);
                  g = uint(averageSample() << 8);
                  b = averageSample();
                  a = uint(averageSample() << 24);
                  bd.setPixel32(i,scanline,a + r + g + b);
                  i++;
               }
            }
            else if(filter == 4)
            {
               i = 0;
               while(i < infoWidth)
               {
                  r = uint(paethSample() << 16);
                  g = uint(paethSample() << 8);
                  b = paethSample();
                  a = uint(paethSample() << 24);
                  bd.setPixel32(i,scanline,a + r + g + b);
                  i++;
               }
            }
            else
            {
               buffer.position += samples * infoWidth;
            }
            ++scanline;
         }
         return bd;
      }
      
      private static function noSample() : uint
      {
         return buffer[buffer.position++];
      }
      
      private static function subSample() : uint
      {
         var _loc1_:uint = buffer[buffer.position] + byteA();
         _loc1_ &= 255;
         buffer[buffer.position++] = _loc1_;
         return _loc1_;
      }
      
      private static function upSample() : uint
      {
         var _loc1_:uint = buffer[buffer.position] + byteB();
         _loc1_ &= 255;
         buffer[buffer.position++] = _loc1_;
         return _loc1_;
      }
      
      private static function averageSample() : uint
      {
         var _loc1_:uint = buffer[buffer.position] + Math.floor((byteA() + byteB()) / 2);
         _loc1_ &= 255;
         buffer[buffer.position++] = _loc1_;
         return _loc1_;
      }
      
      private static function paethSample() : uint
      {
         var _loc1_:uint = buffer[buffer.position] + paethPredictor();
         _loc1_ &= 255;
         buffer[buffer.position++] = _loc1_;
         return _loc1_;
      }
      
      private static function paethPredictor() : uint
      {
         var _loc1_:uint = byteA();
         var _loc2_:uint = byteB();
         var _loc3_:uint = byteC();
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         _loc4_ = _loc1_ + _loc2_ - _loc3_;
         _loc5_ = Math.abs(_loc4_ - _loc1_);
         _loc6_ = Math.abs(_loc4_ - _loc2_);
         _loc7_ = Math.abs(_loc4_ - _loc3_);
         if(_loc5_ <= _loc6_ && _loc5_ <= _loc7_)
         {
            _loc8_ = int(_loc1_);
         }
         else if(_loc6_ <= _loc7_)
         {
            _loc8_ = int(_loc2_);
         }
         else
         {
            _loc8_ = int(_loc3_);
         }
         return _loc8_;
      }
      
      private static function byteA() : uint
      {
         var _loc1_:int = scanline * (infoWidth * samples + 1);
         var _loc2_:int = buffer.position - samples;
         if(_loc2_ <= _loc1_)
         {
            return 0;
         }
         return buffer[_loc2_];
      }
      
      private static function byteB() : uint
      {
         var _loc1_:int = buffer.position - (infoWidth * samples + 1);
         if(_loc1_ < 0)
         {
            return 0;
         }
         return buffer[_loc1_];
      }
      
      private static function byteC() : uint
      {
         var _loc1_:int = buffer.position - (infoWidth * samples + 1);
         if(_loc1_ < 0)
         {
            return 0;
         }
         var _loc2_:int = (scanline - 1) * (infoWidth * samples + 1);
         _loc1_ -= samples;
         if(_loc1_ <= _loc2_)
         {
            return 0;
         }
         return buffer[_loc1_];
      }
   }
}

