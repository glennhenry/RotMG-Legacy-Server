package com.company.assembleegameclient.tutorial
{
   import com.company.assembleegameclient.game.AGameSprite;
   
   public function doneAction(param1:AGameSprite, param2:String) : void
   {
      if(param1.tutorial_ == null)
      {
         return;
      }
      param1.tutorial_.doneAction(param2);
   }
}

