package com.company.assembleegameclient.objects
{
   import com.company.assembleegameclient.engine3d.Object3D;
   import com.company.assembleegameclient.engine3d.ObjectFace3D;
   import com.company.assembleegameclient.map.Camera;
   import com.company.assembleegameclient.map.Square;
   import flash.display.BitmapData;
   import flash.display.IGraphicsData;
   import flash.geom.Utils3D;
   import flash.geom.Vector3D;
   import flash.utils.Dictionary;
   
   public class ConnectedObject extends GameObject
   {
      
      protected static const DOT_TYPE:int = 0;
      
      protected static const SHORT_LINE_TYPE:int = 1;
      
      protected static const L_TYPE:int = 2;
      
      protected static const LINE_TYPE:int = 3;
      
      protected static const T_TYPE:int = 4;
      
      protected static const CROSS_TYPE:int = 5;
      
      private static var dict_:Dictionary = null;
      
      protected static const N0:Vector3D = new Vector3D(-1,-1,0);
      
      protected static const N1:Vector3D = new Vector3D(0,-1,0);
      
      protected static const N2:Vector3D = new Vector3D(1,-1,0);
      
      protected static const N3:Vector3D = new Vector3D(1,0,0);
      
      protected static const N4:Vector3D = new Vector3D(1,1,0);
      
      protected static const N5:Vector3D = new Vector3D(0,1,0);
      
      protected static const N6:Vector3D = new Vector3D(-1,1,0);
      
      protected static const N7:Vector3D = new Vector3D(-1,0,0);
      
      protected static const N8:Vector3D = new Vector3D(0,0,1);
      
      protected var rotation_:int = 0;
      
      public function ConnectedObject(param1:XML)
      {
         super(param1);
         hasShadow_ = false;
      }
      
      private static function init() : void
      {
         dict_ = new Dictionary();
         initHelper(33686018,DOT_TYPE);
         initHelper(16908802,SHORT_LINE_TYPE);
         initHelper(16843266,L_TYPE);
         initHelper(16908546,LINE_TYPE);
         initHelper(16843265,T_TYPE);
         initHelper(16843009,CROSS_TYPE);
      }
      
      private static function getConnectedResults(param1:int) : ConnectedResults
      {
         if(dict_ == null)
         {
            init();
         }
         var _loc2_:int = param1 & 0x0F0F0F0F;
         return dict_[_loc2_];
      }
      
      private static function initHelper(param1:int, param2:int) : void
      {
         var _loc4_:int = 0;
         var _loc3_:int = 0;
         while(_loc3_ < 4)
         {
            if(!dict_.hasOwnProperty(String(param1)))
            {
               dict_[param1] = new ConnectedResults(param2,_loc3_);
               _loc4_ = param1 & 0xFF;
               param1 = param1 >> 8 | _loc4_ << 24;
            }
            _loc3_++;
         }
      }
      
      override public function draw(param1:Vector.<IGraphicsData>, param2:Camera, param3:int) : void
      {
         var _loc4_:ObjectFace3D = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:BitmapData = null;
         var _loc8_:com.company.assembleegameclient.map.Square = null;
         if(obj3D_ == null)
         {
            this.rebuild3D();
         }
         Utils3D.projectVectors(param2.wToS_,obj3D_.vW_,obj3D_.vS_,obj3D_.uvts_);
         for each(_loc4_ in obj3D_.faces_)
         {
            _loc5_ = _loc4_.normalW_.x > 0.4 ? 1 : (_loc4_.normalW_.x < -0.4 ? -1 : 0);
            _loc6_ = _loc4_.normalW_.y > 0.4 ? 1 : (_loc4_.normalW_.y < -0.4 ? -1 : 0);
            _loc7_ = _loc4_.texture_;
            if(_loc5_ != 0 || _loc6_ != 0)
            {
               _loc8_ = map_.lookupSquare(x_ + _loc5_,y_ + _loc6_);
               if(_loc8_ == null || _loc8_.texture_ == null)
               {
                  _loc7_ = null;
               }
            }
            _loc4_.draw(param1,0,_loc7_);
         }
      }
      
      public function rebuild3D() : void
      {
         obj3D_ = new Object3D();
         var _loc1_:ConnectedResults = getConnectedResults(connectType_);
         if(_loc1_ == null)
         {
            obj3D_ = null;
            return;
         }
         this.rotation_ = _loc1_.rotation_;
         switch(_loc1_.type_)
         {
            case DOT_TYPE:
               this.buildDot();
               break;
            case SHORT_LINE_TYPE:
               this.buildShortLine();
               break;
            case L_TYPE:
               this.buildL();
               break;
            case LINE_TYPE:
               this.buildLine();
               break;
            case T_TYPE:
               this.buildT();
               break;
            case CROSS_TYPE:
               this.buildCross();
               break;
            default:
               obj3D_ = null;
               return;
         }
         obj3D_.setPosition(x_,y_,0,this.rotation_ * 90);
      }
      
      protected function buildDot() : void
      {
      }
      
      protected function buildShortLine() : void
      {
      }
      
      protected function buildL() : void
      {
      }
      
      protected function buildLine() : void
      {
      }
      
      protected function buildT() : void
      {
      }
      
      protected function buildCross() : void
      {
      }
   }
}

class ConnectedResults
{
   
   public var type_:int;
   
   public var rotation_:int;
   
   public function ConnectedResults(param1:int, param2:int)
   {
      super();
      this.type_ = param1;
      this.rotation_ = param2;
   }
}
