package com.company.util
{
   import flash.display.CapsStyle;
   import flash.display.GraphicsEndFill;
   import flash.display.GraphicsPath;
   import flash.display.GraphicsPathCommand;
   import flash.display.GraphicsSolidFill;
   import flash.display.GraphicsStroke;
   import flash.display.JointStyle;
   import flash.display.LineScaleMode;
   import flash.geom.Matrix;
   
   public class GraphicsUtil
   {
      
      public static const END_FILL:GraphicsEndFill = new GraphicsEndFill();
      
      public static const QUAD_COMMANDS:Vector.<int> = new <int>[GraphicsPathCommand.MOVE_TO,GraphicsPathCommand.LINE_TO,GraphicsPathCommand.LINE_TO,GraphicsPathCommand.LINE_TO];
      
      public static const DEBUG_STROKE:GraphicsStroke = new GraphicsStroke(1,false,LineScaleMode.NORMAL,CapsStyle.NONE,JointStyle.ROUND,3,new GraphicsSolidFill(16711680));
      
      public static const END_STROKE:GraphicsStroke = new GraphicsStroke();
      
      private static const TWO_PI:Number = 2 * Math.PI;
      
      public static const ALL_CUTS:Array = [true,true,true,true];
      
      public function GraphicsUtil()
      {
         super();
      }
      
      public static function clearPath(param1:GraphicsPath) : void
      {
         param1.commands.length = 0;
         param1.data.length = 0;
      }
      
      public static function getRectPath(param1:int, param2:int, param3:int, param4:int) : GraphicsPath
      {
         return new GraphicsPath(QUAD_COMMANDS,new <Number>[param1,param2,param1 + param3,param2,param1 + param3,param2 + param4,param1,param2 + param4]);
      }
      
      public static function getGradientMatrix(param1:Number, param2:Number, param3:Number = 0, param4:Number = 0, param5:Number = 0) : Matrix
      {
         var _loc6_:Matrix = new Matrix();
         _loc6_.createGradientBox(param1,param2,param3,param4,param5);
         return _loc6_;
      }
      
      public static function drawRect(param1:int, param2:int, param3:int, param4:int, param5:GraphicsPath) : void
      {
         param5.moveTo(param1,param2);
         param5.lineTo(param1 + param3,param2);
         param5.lineTo(param1 + param3,param2 + param4);
         param5.lineTo(param1,param2 + param4);
      }
      
      public static function drawCircle(param1:Number, param2:Number, param3:Number, param4:GraphicsPath, param5:int = 8) : void
      {
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc6_:Number = 1 + 1 / (param5 * 1.75);
         param4.moveTo(param1 + param3,param2);
         var _loc7_:int = 1;
         while(_loc7_ <= param5)
         {
            _loc8_ = TWO_PI * _loc7_ / param5;
            _loc9_ = TWO_PI * (_loc7_ - 0.5) / param5;
            _loc10_ = param1 + param3 * Math.cos(_loc8_);
            _loc11_ = param2 + param3 * Math.sin(_loc8_);
            _loc12_ = param1 + param3 * _loc6_ * Math.cos(_loc9_);
            _loc13_ = param2 + param3 * _loc6_ * Math.sin(_loc9_);
            param4.curveTo(_loc12_,_loc13_,_loc10_,_loc11_);
            _loc7_++;
         }
      }
      
      public static function drawCutEdgeRect(param1:int, param2:int, param3:int, param4:int, param5:int, param6:Array, param7:GraphicsPath) : void
      {
         if(param6[0] != 0)
         {
            param7.moveTo(param1,param2 + param5);
            param7.lineTo(param1 + param5,param2);
         }
         else
         {
            param7.moveTo(param1,param2);
         }
         if(param6[1] != 0)
         {
            param7.lineTo(param1 + param3 - param5,param2);
            param7.lineTo(param1 + param3,param2 + param5);
         }
         else
         {
            param7.lineTo(param1 + param3,param2);
         }
         if(param6[2] != 0)
         {
            param7.lineTo(param1 + param3,param2 + param4 - param5);
            param7.lineTo(param1 + param3 - param5,param2 + param4);
         }
         else
         {
            param7.lineTo(param1 + param3,param2 + param4);
         }
         if(param6[3] != 0)
         {
            param7.lineTo(param1 + param5,param2 + param4);
            param7.lineTo(param1,param2 + param4 - param5);
         }
         else
         {
            param7.lineTo(param1,param2 + param4);
         }
         if(param6[0] != 0)
         {
            param7.lineTo(param1,param2 + param5);
         }
         else
         {
            param7.lineTo(param1,param2);
         }
      }
      
      public static function drawDiamond(param1:Number, param2:Number, param3:Number, param4:GraphicsPath) : void
      {
         param4.moveTo(param1,param2 - param3);
         param4.lineTo(param1 + param3,param2);
         param4.lineTo(param1,param2 + param3);
         param4.lineTo(param1 - param3,param2);
      }
   }
}

