class MorseCode{
  static const Map<String,String>
  alphabets={
    ".-":"A","A":".-",
    "-...":"B","B":"-...",
    "-.-.":"C","C":"-.-.",
    "-..":"D","D":"-..",
    ".":"E","E":".",
    "..-.":"F","F":"..-.",
    "--.":"G","G":"--.",
    "....":"H","H":"....",
    "..":"I","I":"..",
    ".---":"J","J":".---",
    "-.-":"K","K":"-.-",
    ".-..":"L","L":".-..",
    "--":"M","M":"--",
    "-.":"N","N":"-.",
    "---":"O","O":"---",
    ".--.":"P","P":".--.",
    "--.-":"Q","Q":"--.-",
    ".-.":"R","R":".-.",
    "...":"S","S":"...",
    "-":"T","T":"-",
    "..-":"U","U":"..-",
    "...-":"V","V":"...-",
    ".--":"W","W":".--",
    "-..-":"X","X":"-..-",
    "-.--":"Y","Y":"-.--",
    "--..":"Z","Z":"--..",
  };
  static const List<String>
  numbers=[
    "-----",// 0
    ".----",// 1
    "..---",// 2
    "...--",// 3
    "....-",// 4
    ".....",// 5
    "-....",// 6
    "--...",// 7
    "---..",// 8
    "----.",// 9
  ];
  static const String space=" ",newline="\n";

  //Note: use only alphanumerics and space,newline
  static List<String> convertCode(i,s){
    switch(i){
      case 1:// morse to text
        List<String> temp=[];
        for(int i=0;i<s.length;i++){
          if(s[i]==space){
            temp.add(space);continue;
          }
          if(s[i]==newline){
            temp.add(newline);continue;
          }
          if(s[i].length==5){
            temp.add(numbers.indexOf(s[i]).toString());continue;
          }
          if(s[i].length<5) {
            temp.add(alphabets[s[i]].toString());
          }
        }
        return temp;
      case 2:// text to morse
        List<String> temp=[];
        for(int i=0;i<s.length;i++){
          if(s[i]==space){
            temp.add(space);continue;
          }
          if(s[i]==newline){
            temp.add(newline);continue;
          }
          if((s[i]).runtimeType==int){
            temp.add(numbers[s[i]]);continue;
          }
          if(s[i].length<5) {
            temp.add(alphabets[s[i]].toString());
          }
        }
        return temp;
    }
    return [];
  }

  static convertSentences(j,s){
    List temp=[];
    for(int i=0;i<s.length;i++){
      temp.add(convertCode(j,s[i]));
    }
    return temp;
  }
}
/*
void main() {
  String v="Hello".toUpperCase();
  List inp = v.split("").toList();
  print(MorseCode.convertCode(1,inp));
  inp=["-..", "....", ".", ".", ".-.", ".-", ".---"];
  print(MorseCode.convertCode(2,inp));
  inp=["HELLO".split("").toList()," ".split("").toList(),"DHEERAJ".split("").toList()];
  print(MorseCode.convertSentences(1,inp));
  inp=[["-..", "....", ".", ".", ".-.", ".-", ".---"]];
  print(MorseCode.convertSentences(2,inp));
}
*/