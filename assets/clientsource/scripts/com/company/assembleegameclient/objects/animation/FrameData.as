package com.company.assembleegameclient.objects.animation
{
   import com.company.assembleegameclient.objects.TextureData;
   import com.company.assembleegameclient.objects.TextureDataConcrete;
   
   public class FrameData
   {
      
      public var time_:int;
      
      public var textureData_:TextureData;
      
      public function FrameData(param1:XML)
      {
         super();
         this.time_ = int(Number(param1.@time) * 1000);
         this.textureData_ = new TextureDataConcrete(param1);
      }
   }
}

