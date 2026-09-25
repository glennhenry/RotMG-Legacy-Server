package com.company.assembleegameclient.objects
{
   import com.company.assembleegameclient.map.Camera;
   import flash.display.IGraphicsData;
   import kabam.rotmg.fortune.services.FortuneModel;
   
   public class FortuneTeller extends Character
   {
      
      public function FortuneTeller(param1:XML)
      {
         super(param1);
      }
      
      override public function draw(param1:Vector.<IGraphicsData>, param2:Camera, param3:int) : void
      {
         if(FortuneModel.HAS_FORTUNES)
         {
            super.draw(param1,param2,param3);
         }
      }
      
      override public function drawShadow(param1:Vector.<IGraphicsData>, param2:Camera, param3:int) : void
      {
         if(FortuneModel.HAS_FORTUNES)
         {
            super.drawShadow(param1,param2,param3);
         }
      }
   }
}

