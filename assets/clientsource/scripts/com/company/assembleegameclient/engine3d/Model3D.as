package com.company.assembleegameclient.engine3d
{
   import com.company.util.ConversionUtil;
   import flash.display3D.Context3D;
   import flash.utils.ByteArray;
   import kabam.rotmg.stage3D.Object3D.Model3D_stage3d;
   import kabam.rotmg.stage3D.Object3D.Object3DStage3D;
   
   public class Model3D
   {
      
      private static var modelLib_:Object = new Object();
      
      private static var models:Object = new Object();
      
      public var vL_:Vector.<Number> = new Vector.<Number>();
      
      public var uvts_:Vector.<Number> = new Vector.<Number>();
      
      public var faces_:Vector.<ModelFace3D> = new Vector.<ModelFace3D>();
      
      public function Model3D()
      {
         super();
      }
      
      public static function parse3DOBJ(param1:String, param2:ByteArray) : void
      {
         var _loc3_:Model3D_stage3d = new Model3D_stage3d();
         _loc3_.readBytes(param2);
         models[param1] = _loc3_;
      }
      
      public static function Create3dBuffer(param1:Context3D) : void
      {
         var _loc2_:Model3D_stage3d = null;
         for each(_loc2_ in models)
         {
            _loc2_.CreatBuffer(param1);
         }
      }
      
      public static function parseFromOBJ(param1:String, param2:String) : void
      {
         var _loc11_:String = null;
         var _loc12_:Model3D = null;
         var _loc13_:String = null;
         var _loc14_:int = 0;
         var _loc15_:Array = null;
         var _loc16_:String = null;
         var _loc17_:String = null;
         var _loc18_:Array = null;
         var _loc19_:Array = null;
         var _loc20_:String = null;
         var _loc21_:Vector.<int> = null;
         var _loc22_:int = 0;
         var _loc3_:Array = param2.split(/\s*\n\s*/);
         var _loc4_:Array = [];
         var _loc5_:Array = [];
         var _loc6_:Array = [];
         var _loc7_:Object = {};
         var _loc8_:Array = [];
         var _loc9_:String = null;
         var _loc10_:Array = [];
         for each(_loc11_ in _loc3_)
         {
            if(_loc11_.charAt(0) == "#" || _loc11_.length == 0)
            {
               continue;
            }
            _loc15_ = _loc11_.split(/\s+/);
            if(_loc15_.length == 0)
            {
               continue;
            }
            _loc16_ = _loc15_.shift();
            if(_loc16_.length == 0)
            {
               continue;
            }
            switch(_loc16_)
            {
               case "v":
                  if(_loc15_.length != 3)
                  {
                     return;
                  }
                  _loc4_.push(_loc15_);
                  break;
               case "vt":
                  if(_loc15_.length != 2)
                  {
                     return;
                  }
                  _loc5_.push(_loc15_);
                  break;
               case "f":
                  if(_loc15_.length < 3)
                  {
                     return;
                  }
                  _loc8_.push(_loc15_);
                  _loc10_.push(_loc9_);
                  for each(_loc17_ in _loc15_)
                  {
                     if(!_loc7_.hasOwnProperty(_loc17_))
                     {
                        _loc7_[_loc17_] = _loc6_.length;
                        _loc6_.push(_loc17_);
                     }
                  }
                  break;
               case "usemtl":
                  if(_loc15_.length != 1)
                  {
                     return;
                  }
                  _loc9_ = _loc15_[0];
            }
         }
         _loc12_ = new Model3D();
         for each(_loc13_ in _loc6_)
         {
            _loc18_ = _loc13_.split("/");
            ConversionUtil.addToNumberVector(_loc4_[int(_loc18_[0]) - 1],_loc12_.vL_);
            if(_loc18_.length > 1 && _loc18_[1].length > 0)
            {
               ConversionUtil.addToNumberVector(_loc5_[int(_loc18_[1]) - 1],_loc12_.uvts_);
               _loc12_.uvts_.push(0);
            }
            else
            {
               _loc12_.uvts_.push(0,0,0);
            }
         }
         _loc14_ = 0;
         while(_loc14_ < _loc8_.length)
         {
            _loc19_ = _loc8_[_loc14_];
            _loc20_ = _loc10_[_loc14_];
            _loc21_ = new Vector.<int>();
            _loc22_ = 0;
            while(_loc22_ < _loc19_.length)
            {
               _loc21_.push(_loc7_[_loc19_[_loc22_]]);
               _loc22_++;
            }
            _loc12_.faces_.push(new ModelFace3D(_loc12_,_loc21_,_loc20_ == null || _loc20_.substr(0,5) != "Solid"));
            _loc14_++;
         }
         _loc12_.orderFaces();
         modelLib_[param1] = _loc12_;
      }
      
      public static function getModel(param1:String) : Model3D
      {
         return modelLib_[param1];
      }
      
      public static function getObject3D(param1:String) : Object3D
      {
         var _loc2_:Model3D = modelLib_[param1];
         if(_loc2_ == null)
         {
            return null;
         }
         return new Object3D(_loc2_);
      }
      
      public static function getStage3dObject3D(param1:String) : Object3DStage3D
      {
         var _loc2_:Model3D_stage3d = models[param1];
         if(_loc2_ == null)
         {
            return null;
         }
         return new Object3DStage3D(_loc2_);
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_ += "vL(" + this.vL_.length + "): " + this.vL_.join() + "\n";
         _loc1_ += "uvts(" + this.uvts_.length + "): " + this.uvts_.join() + "\n";
         return _loc1_ + ("faces_(" + this.faces_.length + "): " + this.faces_.join() + "\n");
      }
      
      public function orderFaces() : void
      {
         this.faces_.sort(ModelFace3D.compare);
      }
   }
}

