package com.company.assembleegameclient.objects.particles
{
   import com.company.assembleegameclient.objects.TextureData;
   import com.company.assembleegameclient.objects.TextureDataConcrete;
   import com.company.assembleegameclient.objects.animation.AnimationsData;
   
   public class ParticleProperties
   {
      
      public var id_:String;
      
      public var textureData_:TextureData;
      
      public var size_:int = 100;
      
      public var z_:Number = 0;
      
      public var duration_:Number = 0;
      
      public var animationsData_:AnimationsData = null;
      
      public function ParticleProperties(param1:XML)
      {
         super();
         this.id_ = param1.@id;
         this.textureData_ = new TextureDataConcrete(param1);
         if(param1.hasOwnProperty("Size"))
         {
            this.size_ = Number(param1.Size);
         }
         if(param1.hasOwnProperty("Z"))
         {
            this.z_ = Number(param1.Z);
         }
         if(param1.hasOwnProperty("Duration"))
         {
            this.duration_ = Number(param1.Duration);
         }
         if(param1.hasOwnProperty("Animation"))
         {
            this.animationsData_ = new AnimationsData(param1);
         }
      }
   }
}

