package com.company.assembleegameclient.objects
{
   public class TextureDataFactory
   {
      
      public function TextureDataFactory()
      {
         super();
      }
      
      public function create(param1:XML) : TextureData
      {
         return new TextureDataConcrete(param1);
      }
   }
}

