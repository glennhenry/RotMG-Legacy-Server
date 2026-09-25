package com.company.assembleegameclient.mapeditor
{
   import com.company.assembleegameclient.map.RegionLibrary;
   
   public class RegionChooser extends Chooser
   {
      
      public function RegionChooser()
      {
         var _loc1_:XML = null;
         var _loc2_:RegionElement = null;
         super(Layer.REGION);
         for each(_loc1_ in RegionLibrary.xmlLibrary_)
         {
            _loc2_ = new RegionElement(_loc1_);
            addElement(_loc2_);
         }
      }
   }
}

