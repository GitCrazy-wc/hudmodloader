package
{
   import flash.utils.Dictionary;
   
   public class SharedUtils
   {
      
      public function SharedUtils()
      {
         super();
      }
      
      public static function displayObject(name:String, obj:Object, flag:Boolean = false) : String
      {
         var res:String = "";
         for(var p in obj)
         {
            var prop:String = String(p);
            if(prop && prop !== "" && prop !== " ")
            {
               if(flag)
               {
                  var val:String = String(obj[p]);
                  if(val.length > 10)
                  {
                     val = val.substr(0,10) + "...";
                  }
                  res += prop + ":" + val + ", ";
               }
               else
               {
                  res += prop + ", ";
               }
            }
         }
         return name + ":" + res;
      }
      
      public static function calcColor(red:uint, green:uint, blue:uint) : uint
      {
         return red * 256 * 256 + green * 256 + blue;
      }
      
      public static function multColor(color:uint, percent:Number) : uint
      {
         var blue:uint = color % 256;
         var green:uint = uint(color / 256) % 256;
         var red:uint = uint(color / (256 * 256));
         blue = Math.min(blue * percent,255);
         green = Math.min(green * percent,255);
         red = Math.min(red * percent,255);
         return SharedUtils.calcColor(red,green,blue);
      }
      
      public static function hexColor(red:uint, green:uint, blue:uint) : String
      {
         return red.toString(16) + green.toString(16) + blue.toString(16);
      }
      
      public static function trimString(str:String) : String
      {
         return str.replace(/^\s+|\s+$/g,"");
      }
      
      public static function formatInt(passInt:uint) : String
      {
         var textInt:String = String(passInt);
         var textLength:int = textInt.length;
         var textComma:int = 3;
         while(textLength > textComma)
         {
            textInt = textInt.slice(0,textLength - textComma) + "," + textInt.slice(textLength - textComma);
            textComma += 3;
         }
         return textInt;
      }
      
      public static function formatNumber(passNumber:Number) : String
      {
         var textNumber:String = String(SharedUtils.setPrecision(passNumber,1));
         var textPeriod:int = int(textNumber.indexOf("."));
         var textLength:int = textNumber.length;
         var textComma:int = 3;
         if(textPeriod >= 0 && textLength - textPeriod > 2)
         {
            textNumber = textNumber.slice(0,textPeriod + 2);
            textPeriod = int(textNumber.indexOf("."));
            textLength = textNumber.length;
         }
         if(textPeriod >= 0)
         {
            textComma += textLength - textPeriod;
         }
         while(textLength > textComma)
         {
            textNumber = textNumber.slice(0,textLength - textComma) + "," + textNumber.slice(textLength - textComma);
            textComma += 3;
         }
         return textNumber;
      }
      
      public static function setPrecision(number:Number, precision:int) : Number
      {
         precision = Math.pow(10,precision);
         return Math.round(number * precision) / precision;
      }
      
      public static function countKeys(dict:Dictionary) : int
      {
         var n:int = 0;
         for(var key in dict)
         {
            n++;
         }
         return n;
      }
      
      public static function approximateZero(num:Number) : *
      {
         if(Math.abs(num) < 0.01)
         {
            return true;
         }
         return false;
      }
      
      public static function limitInt(input:String, defaultValue:int, minimumValue:int, maximumValue:int) : int
      {
         var inputValue:int;
         try
         {
            inputValue = int(parseInt(input));
            if(isNaN(inputValue))
            {
               return defaultValue;
            }
            if(inputValue == defaultValue)
            {
               return inputValue;
            }
            if(inputValue < minimumValue)
            {
               return minimumValue;
            }
            if(inputValue > maximumValue)
            {
               return maximumValue;
            }
            return inputValue;
         }
         catch(e:Error)
         {
            return defaultValue;
         }
      }
      
      public static function limitNumber(input:String, defaultValue:Number, minimumValue:Number, maximumValue:Number) : Number
      {
         var inputValue:Number;
         try
         {
            inputValue = Number(parseFloat(input));
            if(isNaN(inputValue))
            {
               return defaultValue;
            }
            if(inputValue == defaultValue)
            {
               return inputValue;
            }
            if(inputValue < minimumValue)
            {
               return minimumValue;
            }
            if(inputValue > maximumValue)
            {
               return maximumValue;
            }
            return inputValue;
         }
         catch(e:Error)
         {
            return defaultValue;
         }
      }
   }
}

