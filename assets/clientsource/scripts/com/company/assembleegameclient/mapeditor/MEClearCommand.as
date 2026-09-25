package com.company.assembleegameclient.mapeditor
{
   import com.company.assembleegameclient.editor.Command;
   
   public class MEClearCommand extends Command
   {
      
      private var map_:MEMap;
      
      private var x_:int;
      
      private var y_:int;
      
      private var oldTile_:METile;
      
      public function MEClearCommand(param1:MEMap, param2:int, param3:int, param4:METile)
      {
         super();
         this.map_ = param1;
         this.x_ = param2;
         this.y_ = param3;
         this.oldTile_ = param4.clone();
      }
      
      override public function execute() : void
      {
         this.map_.eraseTile(this.x_,this.y_);
      }
      
      override public function unexecute() : void
      {
         this.map_.setTile(this.x_,this.y_,this.oldTile_);
      }
   }
}

