csv2plist
=========

In English

this tool convert csv file to plist file.

Usage

csv2plist [option] -i [inputFilePath...] -o [outputFilePath...]

option
  -datatype		this option apply data type at 2 column to this row
  kind of data type
  String
  Number
  Date
  Data
  Boolean
   
   ex. convert item.csv 
   (item.csv)
   index,item,number
   Number,String,Number
   1,peach,20
   2,banana,5
   3,coconut,6
   
csv2plist -datatype -i item.csv -o item.plist

generated plist data(item.plist)
  <?xml version="1.0" encoding="UTF-8" standalone="no"?>
  <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
  <plist version="1.0">
  	<array>
  		<dict>
  			<key>index</key>
  			<integer>1</integer>
  			<key>item</key>
  			<string>peach></string>
  			<key>number</key>
  			<integer>20</integer>
  		</dict>
  		<dict>
  			<key>index</key>
  			<integer>2</integer>
  			<key>item</key>
  			<string>banana</string>
  			<key>number</key>
  			<integer>20</integer>
  		</dict>
  		<dict>
  			<key>index</key>
  			<integer>3</integer>
  			<key>item</key>
  			<string>coconut</string>
  			<key>number</key>
  			<integer>6</integer>
  		</dict>
  	</array>
  </plist>
   

In Japanese

CSV形式のデータをPlist形式に変換するツールです。
  使い方

csv2plist [option] -i [inputfilepath...] -o [outputfilepath...]

option
  -datatype csvデータの2列目からその列のデータ型を読み込む。
	
  ・読み込めるデータ型
  String 文字列
  Number 数値
  Date　 日付
  Data   データ型
  Boolean ブール値

変換対象のcsvデータの例(item.csv)
  index,item,number
  Number,String,Number
  1,peach,20
  2,banana,5
  3,coconut,6

csv2plist -datatype -i item.csv -o item.plist

変換後のplistデータ
  <?xml version="1.0" encoding="UTF-8" standalone="no"?>
  <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
  <plist version="1.0">
  	<array>
  		<dict>
  			<key>index</key>
  			<integer>1</integer>
  			<key>item</key>
  			<string>peach></string>
  			<key>number</key>
  			<integer>20</integer>
  		</dict>
  		<dict>
  			<key>index</key>
  			<integer>2</integer>
  			<key>item</key>
  			<string>banana</string>
  			<key>number</key>
  			<integer>20</integer>
  		</dict>
  		<dict>
  			<key>index</key>
  			<integer>3</integer>
  			<key>item</key>
  			<string>coconut</string>
  			<key>number</key>
  			<integer>6</integer>
  		</dict>
  	</array>
  </plist>


