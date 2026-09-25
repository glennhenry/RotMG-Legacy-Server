package com.company.assembleegameclient.util
{
   import com.company.assembleegameclient.util.redrawers.GlowRedrawer;
   import com.company.util.AssetLibrary;
   import com.company.util.PointUtil;
   import flash.display.BitmapData;
   import flash.display.Shader;
   import flash.filters.BitmapFilterQuality;
   import flash.filters.GlowFilter;
   import flash.filters.ShaderFilter;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   
   public class TextureRedrawer
   {
      
      public static const magic:int = 12;
      
      public static const minSize:int = 2 * magic;
      
      private static const BORDER:int = 4;
      
      public static const OUTLINE_FILTER:GlowFilter = new GlowFilter(0,0.8,1.4,1.4,255,BitmapFilterQuality.LOW,false,false);
      
      private static var cache_:Dictionary = new Dictionary();
      
      private static var faceCache_:Dictionary = new Dictionary();
      
      private static var redrawCaches:Dictionary = new Dictionary();
      
      public static var sharedTexture_:BitmapData = null;
      
      private static var textureShaderEmbed_:Class = TextureRedrawer_textureShaderEmbed_;
      
      private static var textureShaderData_:ByteArray = new textureShaderEmbed_() as ByteArray;
      
      private static var colorTexture1:BitmapData = new BitmapDataSpy(1,1,false);
      
      private static var colorTexture2:BitmapData = new BitmapDataSpy(1,1,false);
      
      public function TextureRedrawer()
      {
         super();
      }
      
      public static function redraw(param1:BitmapData, param2:int, param3:Boolean, param4:uint, param5:Boolean = true, param6:Number = 5) : BitmapData
      {
         var _loc7_:String = getHash(param2,param3,param4,param6);
         if(param5 && isCached(param1,_loc7_))
         {
            return redrawCaches[param1][_loc7_];
         }
         var _loc8_:BitmapData = resize(param1,null,param2,param3,0,0,param6);
         _loc8_ = GlowRedrawer.outlineGlow(_loc8_,param4,1.4,param5);
         if(param5)
         {
            cache(param1,_loc7_,_loc8_);
         }
         return _loc8_;
      }
      
      private static function getHash(param1:int, param2:Boolean, param3:uint, param4:Number) : String
      {
         return param1.toString() + "," + param3.toString() + "," + param2 + "," + param4;
      }
      
      private static function cache(param1:BitmapData, param2:String, param3:BitmapData) : void
      {
         if(!(param1 in redrawCaches))
         {
            redrawCaches[param1] = {};
         }
         redrawCaches[param1][param2] = param3;
      }
      
      private static function isCached(param1:BitmapData, param2:String) : Boolean
      {
         if(param1 in redrawCaches)
         {
            if(param2 in redrawCaches[param1])
            {
               return true;
            }
         }
         return false;
      }
      
      public static function resize(param1:BitmapData, param2:BitmapData, param3:int, param4:Boolean, param5:int, param6:int, param7:Number = 5) : BitmapData
      {
         if(param2 != null && (param5 != 0 || param6 != 0))
         {
            param1 = retexture(param1,param2,param5,param6);
            param3 /= 5;
         }
         var _loc8_:int = param7 * (param3 / 100) * param1.width;
         var _loc9_:int = param7 * (param3 / 100) * param1.height;
         var _loc10_:Matrix = new Matrix();
         _loc10_.scale(_loc8_ / param1.width,_loc9_ / param1.height);
         _loc10_.translate(magic,magic);
         var _loc11_:BitmapData = new BitmapDataSpy(_loc8_ + minSize,_loc9_ + (param4 ? magic : 1) + magic,true,0);
         _loc11_.draw(param1,_loc10_);
         return _loc11_;
      }
      
      public static function redrawSolidSquare(param1:uint, param2:int) : BitmapData
      {
         var _loc3_:Dictionary = cache_[param2];
         if(_loc3_ == null)
         {
            _loc3_ = new Dictionary();
            cache_[param2] = _loc3_;
         }
         var _loc4_:BitmapData = _loc3_[param1];
         if(_loc4_ != null)
         {
            return _loc4_;
         }
         _loc4_ = new BitmapDataSpy(param2 + 4 + 4,param2 + 4 + 4,true,0);
         _loc4_.fillRect(new Rectangle(4,4,param2,param2),0xFF000000 | param1);
         _loc4_.applyFilter(_loc4_,_loc4_.rect,PointUtil.ORIGIN,OUTLINE_FILTER);
         _loc3_[param1] = _loc4_;
         return _loc4_;
      }
      
      public static function clearCache() : void
      {
         var _loc1_:BitmapData = null;
         var _loc2_:Dictionary = null;
         var _loc3_:Dictionary = null;
         for each(_loc2_ in cache_)
         {
            for each(_loc1_ in _loc2_)
            {
               _loc1_.dispose();
            }
         }
         cache_ = new Dictionary();
         for each(_loc3_ in faceCache_)
         {
            for each(_loc1_ in _loc3_)
            {
               _loc1_.dispose();
            }
         }
         faceCache_ = new Dictionary();
      }
      
      public static function redrawFace(param1:BitmapData, param2:Number) : BitmapData
      {
         if(param2 == 1)
         {
            return param1;
         }
         var _loc3_:Dictionary = faceCache_[param2];
         if(_loc3_ == null)
         {
            _loc3_ = new Dictionary();
            faceCache_[param2] = _loc3_;
         }
         var _loc4_:BitmapData = _loc3_[param1];
         if(_loc4_ != null)
         {
            return _loc4_;
         }
         _loc4_ = param1.clone();
         _loc4_.colorTransform(_loc4_.rect,new ColorTransform(param2,param2,param2));
         _loc3_[param1] = _loc4_;
         return _loc4_;
      }
      
      private static function getTexture(param1:int, param2:BitmapData) : BitmapData
      {
         var _loc3_:BitmapData = null;
         var _loc4_:int = param1 >> 24 & 0xFF;
         var _loc5_:int = param1 & 0xFFFFFF;
         switch(_loc4_)
         {
            case 0:
               _loc3_ = param2;
               break;
            case 1:
               param2.setPixel(0,0,_loc5_);
               _loc3_ = param2;
               break;
            case 4:
               _loc3_ = AssetLibrary.getImageFromSet("textile4x4",_loc5_);
               break;
            case 5:
               _loc3_ = AssetLibrary.getImageFromSet("textile5x5",_loc5_);
               break;
            case 9:
               _loc3_ = AssetLibrary.getImageFromSet("textile9x9",_loc5_);
               break;
            case 10:
               _loc3_ = AssetLibrary.getImageFromSet("textile10x10",_loc5_);
               break;
            case 255:
               _loc3_ = sharedTexture_;
               break;
            default:
               _loc3_ = param2;
         }
         return _loc3_;
      }
      
      private static function retexture(param1:BitmapData, param2:BitmapData, param3:int, param4:int) : BitmapData
      {
         var _loc5_:Matrix = new Matrix();
         _loc5_.scale(5,5);
         var _loc6_:BitmapData = new BitmapDataSpy(param1.width * 5,param1.height * 5,true,0);
         _loc6_.draw(param1,_loc5_);
         var _loc7_:BitmapData = getTexture(param3,colorTexture1);
         var _loc8_:BitmapData = getTexture(param4,colorTexture2);
         var _loc9_:Shader = new Shader(textureShaderData_);
         _loc9_.data.src.input = _loc6_;
         _loc9_.data.mask.input = param2;
         _loc9_.data.texture1.input = _loc7_;
         _loc9_.data.texture2.input = _loc8_;
         _loc9_.data.texture1Size.value = [param3 == 0 ? 0 : _loc7_.width];
         _loc9_.data.texture2Size.value = [param4 == 0 ? 0 : _loc8_.width];
         _loc6_.applyFilter(_loc6_,_loc6_.rect,PointUtil.ORIGIN,new ShaderFilter(_loc9_));
         return _loc6_;
      }
      
      private static function getDrawMatrix() : Matrix
      {
         var _loc1_:Matrix = new Matrix();
         _loc1_.scale(8,8);
         _loc1_.translate(BORDER,BORDER);
         return _loc1_;
      }
   }
}

