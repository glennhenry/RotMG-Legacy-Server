package kabam.rotmg.stage3D.Object3D
{
   import flash.display.BitmapData;
   import flash.display3D.Context3D;
   import flash.display3D.Context3DTextureFormat;
   import flash.display3D.Context3DVertexBufferFormat;
   import flash.display3D.textures.Texture;
   import flash.geom.Matrix3D;
   import flash.geom.Vector3D;
   import kabam.rotmg.stage3D.graphic3D.TextureFactory;
   
   public class Object3DStage3D
   {
      
      public static const missingTextureBitmap:BitmapData = new BitmapData(1,1,true,2290649343);
      
      public var model_:Model3D_stage3d = null;
      
      private var bitmapData:BitmapData;
      
      public var modelMatrix_:Matrix3D;
      
      public var modelView_:Matrix3D;
      
      public var modelViewProjection_:Matrix3D;
      
      public var position:Vector3D;
      
      private var zRotation_:Number;
      
      private var texture_:Texture;
      
      public function Object3DStage3D(param1:Model3D_stage3d)
      {
         super();
         this.model_ = param1;
         this.modelMatrix_ = new Matrix3D();
         this.modelView_ = new Matrix3D();
         this.modelViewProjection_ = new Matrix3D();
      }
      
      public function setBitMapData(param1:BitmapData) : void
      {
         this.bitmapData = TextureFactory.GetFlippedBitmapData(param1);
      }
      
      public function setPosition(param1:Number, param2:Number, param3:Number, param4:Number) : void
      {
         this.position = new Vector3D(param1,-param2,param3);
         this.zRotation_ = param4;
      }
      
      public function dispose() : void
      {
         if(this.texture_ != null)
         {
            this.texture_.dispose();
            this.texture_ = null;
         }
         this.bitmapData = null;
         this.modelMatrix_ = null;
         this.modelView_ = null;
         this.modelViewProjection_ = null;
         this.position = null;
      }
      
      public function UpdateModelMatrix(param1:Number, param2:Number) : void
      {
         this.modelMatrix_.identity();
         this.modelMatrix_.appendRotation(-90,Vector3D.Z_AXIS);
         this.modelMatrix_.appendRotation(-this.zRotation_,Vector3D.Z_AXIS);
         this.modelMatrix_.appendTranslation(this.position.x,this.position.y,0);
         this.modelMatrix_.appendTranslation(param1,param2,0);
      }
      
      public function GetModelMatrix() : Matrix3D
      {
         return this.modelMatrix_;
      }
      
      public function draw(param1:Context3D) : void
      {
         var _loc2_:OBJGroup = null;
         param1.setVertexBufferAt(0,this.model_.vertexBuffer,0,Context3DVertexBufferFormat.FLOAT_3);
         param1.setVertexBufferAt(1,this.model_.vertexBuffer,3,Context3DVertexBufferFormat.FLOAT_3);
         param1.setVertexBufferAt(2,this.model_.vertexBuffer,6,Context3DVertexBufferFormat.FLOAT_2);
         if(this.texture_ == null && this.bitmapData != null)
         {
            this.texture_ = param1.createTexture(this.bitmapData.width,this.bitmapData.height,Context3DTextureFormat.BGRA,false);
            this.texture_.uploadFromBitmapData(this.bitmapData);
         }
         else if(this.texture_ == null)
         {
            this.bitmapData = missingTextureBitmap;
            this.texture_ = param1.createTexture(this.bitmapData.width,this.bitmapData.height,Context3DTextureFormat.BGRA,false);
            this.texture_.uploadFromBitmapData(this.bitmapData);
         }
         param1.setTextureAt(0,this.texture_);
         for each(_loc2_ in this.model_.groups)
         {
            if(_loc2_.indexBuffer != null)
            {
               param1.drawTriangles(_loc2_.indexBuffer);
            }
         }
      }
   }
}

