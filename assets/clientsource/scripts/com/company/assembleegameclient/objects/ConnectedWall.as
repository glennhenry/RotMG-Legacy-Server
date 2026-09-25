package com.company.assembleegameclient.objects
{
   import com.company.assembleegameclient.engine3d.ObjectFace3D;
   import com.company.assembleegameclient.parameters.Parameters;
   import com.company.util.AssetLibrary;
   import flash.display.BitmapData;
   import flash.geom.Vector3D;
   import kabam.rotmg.stage3D.GraphicsFillExtra;
   
   public class ConnectedWall extends ConnectedObject
   {
      
      protected var objectXML_:XML;
      
      protected var bI_:Number = 0.5;
      
      protected var tI_:Number = 0.25;
      
      protected var h_:Number = 1;
      
      protected var wallRepeat_:Boolean;
      
      protected var topRepeat_:Boolean;
      
      public function ConnectedWall(param1:XML)
      {
         super(param1);
         this.objectXML_ = param1;
         if(param1.hasOwnProperty("BaseIndent"))
         {
            this.bI_ = 0.5 - Number(param1.BaseIndent);
         }
         if(param1.hasOwnProperty("TopIndent"))
         {
            this.tI_ = 0.5 - Number(param1.TopIndent);
         }
         if(param1.hasOwnProperty("Height"))
         {
            this.h_ = Number(param1.Height);
         }
         this.wallRepeat_ = !param1.hasOwnProperty("NoWallTextureRepeat");
         this.topRepeat_ = !param1.hasOwnProperty("NoTopTextureRepeat");
      }
      
      override protected function buildDot() : void
      {
         var _loc1_:Vector3D = new Vector3D(-this.bI_,-this.bI_,0);
         var _loc2_:Vector3D = new Vector3D(this.bI_,-this.bI_,0);
         var _loc3_:Vector3D = new Vector3D(this.bI_,this.bI_,0);
         var _loc4_:Vector3D = new Vector3D(-this.bI_,this.bI_,0);
         var _loc5_:Vector3D = new Vector3D(-this.tI_,-this.tI_,this.h_);
         var _loc6_:Vector3D = new Vector3D(this.tI_,-this.tI_,this.h_);
         var _loc7_:Vector3D = new Vector3D(this.tI_,this.tI_,this.h_);
         var _loc8_:Vector3D = new Vector3D(-this.tI_,this.tI_,this.h_);
         this.addQuad(_loc6_,_loc5_,_loc1_,_loc2_,texture_,true,true);
         this.addQuad(_loc7_,_loc6_,_loc2_,_loc3_,texture_,true,true);
         this.addQuad(_loc5_,_loc8_,_loc4_,_loc1_,texture_,true,true);
         this.addQuad(_loc8_,_loc7_,_loc3_,_loc4_,texture_,true,true);
         var _loc9_:BitmapData = texture_;
         if(this.objectXML_.hasOwnProperty("DotTexture"))
         {
            _loc9_ = AssetLibrary.getImageFromSet(String(this.objectXML_.DotTexture.File),int(this.objectXML_.DotTexture.Index));
         }
         this.addTop([_loc5_,_loc6_,_loc7_,_loc8_],new <Number>[0.25,0.25,0.75,0.25,0.25,0.75],_loc9_);
      }
      
      override protected function buildShortLine() : void
      {
         var _loc1_:Vector3D = new Vector3D(-this.bI_,-0.5,0);
         var _loc2_:Vector3D = new Vector3D(this.bI_,-0.5,0);
         var _loc3_:Vector3D = new Vector3D(this.bI_,this.bI_,0);
         var _loc4_:Vector3D = new Vector3D(-this.bI_,this.bI_,0);
         var _loc5_:Vector3D = new Vector3D(-this.tI_,-0.5,this.h_);
         var _loc6_:Vector3D = new Vector3D(this.tI_,-0.5,this.h_);
         var _loc7_:Vector3D = new Vector3D(this.tI_,this.tI_,this.h_);
         var _loc8_:Vector3D = new Vector3D(-this.tI_,this.tI_,this.h_);
         this.addQuad(_loc7_,_loc6_,_loc2_,_loc3_,texture_,true,false);
         this.addQuad(_loc5_,_loc8_,_loc4_,_loc1_,texture_,false,true);
         this.addQuad(_loc8_,_loc7_,_loc3_,_loc4_,texture_,true,true);
         var _loc9_:BitmapData = texture_;
         if(this.objectXML_.hasOwnProperty("ShortLineTexture"))
         {
            _loc9_ = AssetLibrary.getImageFromSet(String(this.objectXML_.ShortLineTexture.File),int(this.objectXML_.ShortLineTexture.Index));
         }
         this.addTop([_loc5_,_loc6_,_loc7_,_loc8_],new <Number>[0.25,0,0.75,0,0.25,0.75],_loc9_);
      }
      
      override protected function buildL() : void
      {
         var _loc1_:Vector3D = new Vector3D(-this.bI_,-0.5,0);
         var _loc2_:Vector3D = new Vector3D(this.bI_,-0.5,0);
         var _loc3_:Vector3D = new Vector3D(this.bI_,-this.bI_,0);
         var _loc4_:Vector3D = new Vector3D(0.5,-this.bI_,0);
         var _loc5_:Vector3D = new Vector3D(0.5,this.bI_,0);
         var _loc6_:Vector3D = new Vector3D(-this.bI_,this.bI_,0);
         var _loc7_:Vector3D = new Vector3D(-this.tI_,-0.5,this.h_);
         var _loc8_:Vector3D = new Vector3D(this.tI_,-0.5,this.h_);
         var _loc9_:Vector3D = new Vector3D(this.tI_,-this.tI_,this.h_);
         var _loc10_:Vector3D = new Vector3D(0.5,-this.tI_,this.h_);
         var _loc11_:Vector3D = new Vector3D(0.5,this.tI_,this.h_);
         var _loc12_:Vector3D = new Vector3D(-this.tI_,this.tI_,this.h_);
         this.addBit(_loc9_,_loc8_,_loc2_,_loc3_,texture_,N2,true,true,true);
         this.addBit(_loc10_,_loc9_,_loc3_,_loc4_,texture_,N2,false,true,false);
         this.addQuad(_loc12_,_loc11_,_loc5_,_loc6_,texture_,true,false);
         this.addQuad(_loc7_,_loc12_,_loc6_,_loc1_,texture_,false,true);
         var _loc13_:BitmapData = texture_;
         if(this.objectXML_.hasOwnProperty("LTexture"))
         {
            _loc13_ = AssetLibrary.getImageFromSet(String(this.objectXML_.LTexture.File),int(this.objectXML_.LTexture.Index));
         }
         this.addTop([_loc7_,_loc8_,_loc9_,_loc10_,_loc11_,_loc12_],new <Number>[0.25,0,0.75,0,0.25,0.75],_loc13_);
      }
      
      override protected function buildLine() : void
      {
         var _loc1_:Vector3D = new Vector3D(-this.bI_,-0.5,0);
         var _loc2_:Vector3D = new Vector3D(this.bI_,-0.5,0);
         var _loc3_:Vector3D = new Vector3D(this.bI_,0.5,0);
         var _loc4_:Vector3D = new Vector3D(-this.bI_,0.5,0);
         var _loc5_:Vector3D = new Vector3D(-this.tI_,-0.5,this.h_);
         var _loc6_:Vector3D = new Vector3D(this.tI_,-0.5,this.h_);
         var _loc7_:Vector3D = new Vector3D(this.tI_,0.5,this.h_);
         var _loc8_:Vector3D = new Vector3D(-this.tI_,0.5,this.h_);
         this.addQuad(_loc7_,_loc6_,_loc2_,_loc3_,texture_,false,false);
         this.addQuad(_loc5_,_loc8_,_loc4_,_loc1_,texture_,false,false);
         var _loc9_:BitmapData = texture_;
         if(this.objectXML_.hasOwnProperty("LineTexture"))
         {
            _loc9_ = AssetLibrary.getImageFromSet(String(this.objectXML_.LineTexture.File),int(this.objectXML_.LineTexture.Index));
         }
         this.addTop([_loc5_,_loc6_,_loc7_,_loc8_],new <Number>[0.25,0,0.75,0,0.25,1],_loc9_);
      }
      
      override protected function buildT() : void
      {
         var _loc1_:Vector3D = new Vector3D(-this.bI_,-0.5,0);
         var _loc2_:Vector3D = new Vector3D(this.bI_,-0.5,0);
         var _loc3_:Vector3D = new Vector3D(this.bI_,-this.bI_,0);
         var _loc4_:Vector3D = new Vector3D(0.5,-this.bI_,0);
         var _loc5_:Vector3D = new Vector3D(0.5,this.bI_,0);
         var _loc6_:Vector3D = new Vector3D(-0.5,this.bI_,0);
         var _loc7_:Vector3D = new Vector3D(-0.5,-this.bI_,0);
         var _loc8_:Vector3D = new Vector3D(-this.bI_,-this.bI_,0);
         var _loc9_:Vector3D = new Vector3D(-this.tI_,-0.5,this.h_);
         var _loc10_:Vector3D = new Vector3D(this.tI_,-0.5,this.h_);
         var _loc11_:Vector3D = new Vector3D(this.tI_,-this.tI_,this.h_);
         var _loc12_:Vector3D = new Vector3D(0.5,-this.tI_,this.h_);
         var _loc13_:Vector3D = new Vector3D(0.5,this.tI_,this.h_);
         var _loc14_:Vector3D = new Vector3D(-0.5,this.tI_,this.h_);
         var _loc15_:Vector3D = new Vector3D(-0.5,-this.tI_,this.h_);
         var _loc16_:Vector3D = new Vector3D(-this.tI_,-this.tI_,this.h_);
         this.addBit(_loc11_,_loc10_,_loc2_,_loc3_,texture_,N2,true);
         this.addBit(_loc12_,_loc11_,_loc3_,_loc4_,texture_,N2,false);
         this.addQuad(_loc14_,_loc13_,_loc5_,_loc6_,texture_,false,false);
         this.addBit(_loc16_,_loc15_,_loc7_,_loc8_,texture_,N0,true);
         this.addBit(_loc9_,_loc16_,_loc8_,_loc1_,texture_,N0,false);
         var _loc17_:BitmapData = texture_;
         if(this.objectXML_.hasOwnProperty("TTexture"))
         {
            _loc17_ = AssetLibrary.getImageFromSet(String(this.objectXML_.TTexture.File),int(this.objectXML_.TTexture.Index));
         }
         this.addTop([_loc9_,_loc10_,_loc11_,_loc12_,_loc13_,_loc14_,_loc15_,_loc16_],new <Number>[0.25,0,0.75,0,0.25,0.25],_loc17_);
      }
      
      override protected function buildCross() : void
      {
         var _loc1_:Vector3D = new Vector3D(-this.bI_,-0.5,0);
         var _loc2_:Vector3D = new Vector3D(this.bI_,-0.5,0);
         var _loc3_:Vector3D = new Vector3D(this.bI_,-this.bI_,0);
         var _loc4_:Vector3D = new Vector3D(0.5,-this.bI_,0);
         var _loc5_:Vector3D = new Vector3D(0.5,this.bI_,0);
         var _loc6_:Vector3D = new Vector3D(this.bI_,this.bI_,0);
         var _loc7_:Vector3D = new Vector3D(this.bI_,0.5,0);
         var _loc8_:Vector3D = new Vector3D(-this.bI_,0.5,0);
         var _loc9_:Vector3D = new Vector3D(-this.bI_,this.bI_,0);
         var _loc10_:Vector3D = new Vector3D(-0.5,this.bI_,0);
         var _loc11_:Vector3D = new Vector3D(-0.5,-this.bI_,0);
         var _loc12_:Vector3D = new Vector3D(-this.bI_,-this.bI_,0);
         var _loc13_:Vector3D = new Vector3D(-this.tI_,-0.5,this.h_);
         var _loc14_:Vector3D = new Vector3D(this.tI_,-0.5,this.h_);
         var _loc15_:Vector3D = new Vector3D(this.tI_,-this.tI_,this.h_);
         var _loc16_:Vector3D = new Vector3D(0.5,-this.tI_,this.h_);
         var _loc17_:Vector3D = new Vector3D(0.5,this.tI_,this.h_);
         var _loc18_:Vector3D = new Vector3D(this.tI_,this.tI_,this.h_);
         var _loc19_:Vector3D = new Vector3D(this.tI_,0.5,this.h_);
         var _loc20_:Vector3D = new Vector3D(-this.tI_,0.5,this.h_);
         var _loc21_:Vector3D = new Vector3D(-this.tI_,this.tI_,this.h_);
         var _loc22_:Vector3D = new Vector3D(-0.5,this.tI_,this.h_);
         var _loc23_:Vector3D = new Vector3D(-0.5,-this.tI_,this.h_);
         var _loc24_:Vector3D = new Vector3D(-this.tI_,-this.tI_,this.h_);
         this.addBit(_loc15_,_loc14_,_loc2_,_loc3_,texture_,N2,true);
         this.addBit(_loc16_,_loc15_,_loc3_,_loc4_,texture_,N2,false);
         this.addBit(_loc18_,_loc17_,_loc5_,_loc6_,texture_,N4,true);
         this.addBit(_loc19_,_loc18_,_loc6_,_loc7_,texture_,N4,false);
         this.addBit(_loc21_,_loc20_,_loc8_,_loc9_,texture_,N6,true);
         this.addBit(_loc22_,_loc21_,_loc9_,_loc10_,texture_,N6,false);
         this.addBit(_loc24_,_loc23_,_loc11_,_loc12_,texture_,N0,true);
         this.addBit(_loc13_,_loc24_,_loc12_,_loc1_,texture_,N0,false);
         var _loc25_:BitmapData = texture_;
         if(this.objectXML_.hasOwnProperty("CrossTexture"))
         {
            _loc25_ = AssetLibrary.getImageFromSet(String(this.objectXML_.CrossTexture.File),int(this.objectXML_.CrossTexture.Index));
         }
         this.addTop([_loc13_,_loc14_,_loc15_,_loc16_,_loc17_,_loc18_,_loc19_,_loc20_,_loc21_,_loc22_,_loc23_,_loc24_],new <Number>[0.25,0,0.75,0,0.25,0.25],_loc25_);
      }
      
      protected function addQuad(param1:Vector3D, param2:Vector3D, param3:Vector3D, param4:Vector3D, param5:BitmapData, param6:Boolean, param7:Boolean) : void
      {
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Vector.<Number> = null;
         var _loc8_:int = obj3D_.vL_.length / 3;
         obj3D_.vL_.push(param1.x,param1.y,param1.z,param2.x,param2.y,param2.z,param3.x,param3.y,param3.z,param4.x,param4.y,param4.z);
         var _loc9_:Number = param6 ? -(this.bI_ - this.tI_) / (1 - (this.bI_ - this.tI_) - (param7 ? this.bI_ - this.tI_ : 0)) : 0;
         obj3D_.uvts_.push(0,0,0,1,0,0,1,1,0,_loc9_,1,0);
         var _loc10_:ObjectFace3D = new ObjectFace3D(obj3D_,new <int>[_loc8_,_loc8_ + 1,_loc8_ + 2,_loc8_ + 3]);
         _loc10_.texture_ = param5;
         _loc10_.bitmapFill_.repeat = this.wallRepeat_;
         obj3D_.faces_.push(_loc10_);
         if(GraphicsFillExtra.getVertexBuffer(_loc10_.bitmapFill_) == null && Parameters.isGpuRender())
         {
            _loc11_ = 0;
            _loc12_ = 0;
            if(param6)
            {
               _loc11_ = _loc9_;
            }
            if(param7)
            {
               _loc12_ = -_loc9_;
            }
            if(_loc12_ == 0 && _loc11_ == 0 && param7 && param4.x == -0.5)
            {
               _loc12_ = 0.34;
            }
            _loc13_ = Vector.<Number>([-0.5,0.5,0,0,0,0.5,0.5,0,1,0,-0.5 + _loc11_,-0.5,0,0,1,0.5 + _loc12_,-0.5,0,1,1]);
            GraphicsFillExtra.setVertexBuffer(_loc10_.bitmapFill_,_loc13_);
         }
      }
      
      protected function addBit(param1:Vector3D, param2:Vector3D, param3:Vector3D, param4:Vector3D, param5:BitmapData, param6:Vector3D, param7:Boolean, param8:Boolean = false, param9:Boolean = false) : void
      {
         var _loc12_:Vector.<Number> = null;
         var _loc10_:int = obj3D_.vL_.length / 3;
         obj3D_.vL_.push(param1.x,param1.y,param1.z,param2.x,param2.y,param2.z,param3.x,param3.y,param3.z,param4.x,param4.y,param4.z);
         if(param7)
         {
            obj3D_.uvts_.push(-0.5 + this.tI_,0,0,0,0,0,0,0,0,-0.5 + this.bI_,1,0);
         }
         else
         {
            obj3D_.uvts_.push(1,0,0,1.5 - this.tI_,0,0,0,0,0,1,1,0);
         }
         var _loc11_:ObjectFace3D = new ObjectFace3D(obj3D_,new <int>[_loc10_,_loc10_ + 1,_loc10_ + 2,_loc10_ + 3]);
         _loc11_.texture_ = param5;
         _loc11_.bitmapFill_.repeat = this.wallRepeat_;
         _loc11_.normalL_ = param6;
         if(!Parameters.isGpuRender() && !param8)
         {
            obj3D_.faces_.push(_loc11_);
         }
         else if(param8)
         {
            if(param9)
            {
               _loc12_ = Vector.<Number>([-0.75,0.5,0,0,0,-0.5,0.5,0,1,0,-0.75,-0.5,0,0,1,-0.5,-0.5,0,1,1]);
            }
            else
            {
               _loc12_ = Vector.<Number>([0.5,0.5,0,0,0,0.75,0.5,0,1,0,0.5,-0.5,0,0,1,0.75,-0.5,0,1,1]);
            }
            GraphicsFillExtra.setVertexBuffer(_loc11_.bitmapFill_,_loc12_);
            obj3D_.faces_.push(_loc11_);
         }
      }
      
      protected function addTop(param1:Array, param2:Vector.<Number>, param3:BitmapData) : void
      {
         var _loc8_:ObjectFace3D = null;
         var _loc10_:Vector.<Number> = null;
         var _loc11_:int = 0;
         var _loc12_:Array = null;
         var _loc13_:Array = null;
         var _loc14_:Array = null;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc4_:int = obj3D_.vL_.length / 3;
         var _loc5_:Vector.<int> = new Vector.<int>();
         var _loc6_:uint = 0;
         while(_loc6_ < param1.length)
         {
            obj3D_.vL_.push(param1[_loc6_].x,param1[_loc6_].y,param1[_loc6_].z);
            _loc5_.push(_loc4_ + _loc6_);
            if(_loc6_ == 0)
            {
               obj3D_.uvts_.push(param2[0],param2[1],0);
            }
            else if(_loc6_ == 1)
            {
               obj3D_.uvts_.push(param2[2],param2[3],0);
            }
            else if(_loc6_ == param1.length - 1)
            {
               obj3D_.uvts_.push(param2[4],param2[5],0);
            }
            else
            {
               obj3D_.uvts_.push(0,0,0);
            }
            _loc6_++;
         }
         var _loc7_:ObjectFace3D = new ObjectFace3D(obj3D_,_loc5_);
         _loc7_.texture_ = param3;
         _loc7_.bitmapFill_.repeat = this.topRepeat_;
         obj3D_.faces_.push(_loc7_);
         if(_loc5_.length == 6 && Parameters.isGpuRender())
         {
            _loc8_ = new ObjectFace3D(obj3D_,_loc5_);
            _loc8_.texture_ = param3;
            _loc8_.bitmapFill_.repeat = this.topRepeat_;
            obj3D_.faces_.push(_loc8_);
         }
         var _loc9_:int = 0;
         if(_loc5_.length == 4 && GraphicsFillExtra.getVertexBuffer(_loc7_.bitmapFill_) == null && Parameters.isGpuRender())
         {
            _loc10_ = new Vector.<Number>();
            _loc9_ = 0;
            while(_loc9_ < _loc5_.length)
            {
               if(_loc9_ == 3)
               {
                  _loc11_ = 2;
               }
               else if(_loc9_ == 2)
               {
                  _loc11_ = 3;
               }
               else
               {
                  _loc11_ = _loc9_;
               }
               _loc10_.push(obj3D_.vL_[_loc5_[_loc11_] * 3],obj3D_.vL_[_loc5_[_loc11_] * 3 + 1] * -1,obj3D_.vL_[_loc5_[_loc11_] * 3 + 2],obj3D_.uvts_[_loc5_[_loc11_ != 2 ? _loc11_ : _loc11_ - 1] * 3],obj3D_.uvts_[_loc5_[_loc11_ != 2 ? _loc11_ : _loc11_ + 1] * 3 + 1]);
               _loc9_++;
            }
            GraphicsFillExtra.setVertexBuffer(_loc7_.bitmapFill_,_loc10_);
         }
         else if(_loc5_.length == 6 && GraphicsFillExtra.getVertexBuffer(_loc7_.bitmapFill_) == null && Parameters.isGpuRender())
         {
            _loc12_ = [0,1,5,2];
            _loc13_ = [2,3,5,4];
            _loc14_ = [5,0,2,1];
            _loc15_ = 0;
            while(_loc15_ < 2)
            {
               if(_loc15_ == 1)
               {
                  _loc12_ = _loc13_;
               }
               _loc10_ = new Vector.<Number>();
               _loc16_ = 0;
               _loc17_ = 0;
               for each(_loc9_ in _loc12_)
               {
                  if(_loc15_ == 1)
                  {
                     _loc17_ = int(_loc14_[_loc16_]);
                  }
                  else
                  {
                     _loc17_ = _loc9_;
                  }
                  _loc10_.push(obj3D_.vL_[_loc5_[_loc9_] * 3],obj3D_.vL_[_loc5_[_loc9_] * 3 + 1] * -1,obj3D_.vL_[_loc5_[_loc9_] * 3 + 2],obj3D_.uvts_[_loc5_[_loc17_ != 2 ? _loc17_ : _loc17_ - 1] * 3],obj3D_.uvts_[_loc5_[_loc17_ != 2 ? _loc17_ : _loc17_ + 1] * 3 + 1]);
                  _loc16_++;
               }
               if(_loc15_ == 1)
               {
                  GraphicsFillExtra.setVertexBuffer(_loc8_.bitmapFill_,_loc10_);
               }
               else
               {
                  GraphicsFillExtra.setVertexBuffer(_loc7_.bitmapFill_,_loc10_);
               }
               _loc15_++;
            }
         }
      }
   }
}

