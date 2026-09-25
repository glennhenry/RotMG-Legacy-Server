package kabam.lib.console.view
{
   import com.junkbyte.console.Console;
   import com.junkbyte.console.ConsoleConfig;
   import flash.display.BlendMode;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import kabam.lib.console.model.Watch;
   import kabam.lib.resizing.view.Resizable;
   
   public final class ConsoleOutputView extends Sprite implements Resizable
   {
      
      private static const DEFAULT_OUTPUT:String = "kabam.lib/console";
      
      private const PATTERN:RegExp = /\[0x(.+)\:(.+)\]/ig;
      
      private const HTML_TEMPLATE:String = "<font color=\'#$1\'>$2</font>";
      
      private var watchTextField:TextField = new TextField();
      
      private var logConsole:Console;
      
      private const logged:Array = [];
      
      private const watched:Array = [];
      
      private const watchMap:Object = {};
      
      private var watchBottom:Number;
      
      public function ConsoleOutputView()
      {
         super();
         alpha = 0.8;
         blendMode = BlendMode.LAYER;
         addChild(this.watchTextField);
         this.watchTextField.alpha = 0.6;
         this.watchTextField.defaultTextFormat = new TextFormat("_sans",14,16777215,true);
         this.watchTextField.htmlText = DEFAULT_OUTPUT;
         this.watchTextField.selectable = false;
         this.watchTextField.multiline = true;
         this.watchTextField.wordWrap = true;
         this.watchTextField.autoSize = TextFieldAutoSize.LEFT;
         this.watchTextField.background = true;
         this.watchTextField.border = false;
         this.watchTextField.backgroundColor = 13056;
         this.logConsole = new Console("",new ConsoleConfig());
         addChild(this.logConsole);
      }
      
      public function watch(param1:Watch) : void
      {
         var _loc2_:Watch = this.watchMap[param1.name] = this.watchMap[param1.name] || this.makeWatch(param1.name);
         _loc2_.data = param1.data.replace(this.PATTERN,this.HTML_TEMPLATE);
         this.updateOutputText();
      }
      
      public function unwatch(param1:String) : void
      {
         var _loc2_:Watch = this.watchMap[param1];
         if(_loc2_)
         {
            delete this.watchMap[param1];
            this.watched.splice(this.watched.indexOf(_loc2_),1);
         }
      }
      
      private function makeWatch(param1:String) : Watch
      {
         var _loc2_:Watch = new Watch(param1);
         this.watched.push(_loc2_);
         return _loc2_;
      }
      
      public function log(param1:String) : void
      {
         var _loc2_:String = param1.replace(this.PATTERN,this.HTML_TEMPLATE);
         this.logged.push(_loc2_);
         this.logConsole.addHTML(_loc2_);
      }
      
      public function clear() : void
      {
         var _loc1_:String = null;
         this.logged.length = 0;
         this.watched.length = 0;
         for(_loc1_ in this.watchMap)
         {
            delete this.watchMap[_loc1_];
         }
      }
      
      public function resize(param1:Rectangle) : void
      {
         this.watchBottom = param1.height - ConsoleInputView.HEIGHT;
         x = param1.x;
         y = param1.y;
         this.watchTextField.width = param1.width;
         this.logConsole.width = param1.width;
         this.snapWatchTextToInputView();
      }
      
      private function snapWatchTextToInputView() : void
      {
         this.watchTextField.y = this.watchBottom - this.watchTextField.height;
      }
      
      private function updateOutputText() : void
      {
         this.watchTextField.htmlText = this.watched.join("\n");
         this.snapWatchTextToInputView();
      }
      
      public function getText() : String
      {
         return this.logged.join("\r");
      }
   }
}

