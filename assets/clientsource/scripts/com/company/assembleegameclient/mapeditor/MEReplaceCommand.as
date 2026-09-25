package com.company.assembleegameclient.mapeditor
{
   import com.company.assembleegameclient.editor.Command;
   
   public class MEReplaceCommand extends Command
   {
      
      private var map_:MEMap;
      
      private var x_:int;
      
      private var y_:int;
      
      private var oldTile_:METile;
      
      private var newTile_:METile;
      
      public function MEReplaceCommand(param1:MEMap, param2:int, param3:int, param4:METile, param5:METile)
      {
         super();
         this.map_ = param1;
         this.x_ = param2;
         this.y_ = param3;
         if(param4 != null)
         {
            this.oldTile_ = param4.clone();
         }
         if(param5 != null)
         {
            this.newTile_ = param5.clone();
         }
      }
      
      override public function execute() : void
      {
         if(this.newTile_ == null)
         {
            this.map_.eraseTile(this.x_,this.y_);
         }
         else
         {
            this.map_.setTile(this.x_,this.y_,this.newTile_);
         }
      }
      
      override public function unexecute() : void
      {
         if(this.oldTile_ == null)
         {
            this.map_.eraseTile(this.x_,this.y_);
         }
         else
         {
            this.map_.setTile(this.x_,this.y_,this.oldTile_);
         }
      }
   }
}

