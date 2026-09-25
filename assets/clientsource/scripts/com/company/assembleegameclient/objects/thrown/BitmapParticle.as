package com.company.assembleegameclient.objects.thrown
{
   import com.company.assembleegameclient.map.Camera;
   import com.company.assembleegameclient.map.Square;
   import com.company.assembleegameclient.objects.BasicObject;
   import com.company.util.GraphicsUtil;
   import flash.display.BitmapData;
   import flash.display.GraphicsBitmapFill;
   import flash.display.GraphicsPath;
   import flash.display.IGraphicsData;
   import flash.geom.Matrix;
   
   public class BitmapParticle extends BasicObject
   {
      
      protected var bitmapFill_:GraphicsBitmapFill = new GraphicsBitmapFill(null,null,false,false);
      
      protected var path_:GraphicsPath = new GraphicsPath(GraphicsUtil.QUAD_COMMANDS,null);
      
      protected var vS_:Vector.<Number> = new Vector.<Number>();
      
      protected var fillMatrix_:Matrix = new Matrix();
      
      public var size_:int;
      
      public var _bitmapData:BitmapData;
      
      protected var _rotationDelta:Number = 0;
      
      public var _rotation:Number = 0;
      
      public function BitmapParticle(param1:BitmapData, param2:Number)
      {
         super();
         hasShadow_ = false;
         objectId_ = getNextFakeObjectId();
         this._bitmapData = param1;
         z_ = param2;
      }
      
      public function moveTo(param1:Number, param2:Number) : Boolean
      {
         var _loc3_:com.company.assembleegameclient.map.Square = null;
         _loc3_ = map_.getSquare(param1,param2);
         if(!_loc3_)
         {
            return false;
         }
         x_ = param1;
         y_ = param2;
         square_ = _loc3_;
         return true;
      }
      
      public function setSize(param1:int) : void
      {
         this.size_ = param1 / 100 * 5;
      }
      
      override public function drawShadow(param1:Vector.<IGraphicsData>, param2:Camera, param3:int) : void
      {
      }
      
      override public function draw(param1:Vector.<IGraphicsData>, param2:Camera, param3:int) : void
      {
         var texture:BitmapData = null;
         var w:int = 0;
         var h:int = 0;
         var graphicsData:Vector.<IGraphicsData> = param1;
         var camera:Camera = param2;
         var time:int = param3;
         try
         {
            texture = this._bitmapData;
            w = texture.width;
            h = texture.height;
            if(!w || !h)
            {
               return;
            }
            this.vS_.length = 0;
            this.vS_.push(posS_[3] - w / 2,posS_[4] - h / 2,posS_[3] + w / 2,posS_[4] - h / 2,posS_[3] + w / 2,posS_[4] + h / 2,posS_[3] - w / 2,posS_[4] + h / 2);
            this.path_.data = this.vS_;
            this.bitmapFill_.bitmapData = texture;
            this.fillMatrix_.identity();
            if(Boolean(this._rotation) || Boolean(this._rotationDelta))
            {
               if(this._rotationDelta)
               {
                  this._rotation += this._rotationDelta;
               }
               this.fillMatrix_.translate(-w / 2,-h / 2);
               this.fillMatrix_.rotate(this._rotation);
               this.fillMatrix_.translate(w / 2,h / 2);
            }
            this.fillMatrix_.translate(this.vS_[0],this.vS_[1]);
            this.bitmapFill_.matrix = this.fillMatrix_;
            graphicsData.push(this.bitmapFill_);
            graphicsData.push(this.bitmapFill_);
            graphicsData.push(this.path_);
            graphicsData.push(GraphicsUtil.END_FILL);
         }
         catch(error:Error)
         {
            return;
         }
      }
   }
}

