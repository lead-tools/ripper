
Function Dump(JSONWriter, List)
	JSONWriter.WriteStartArray();
	For Each Item In List Do
		If TypeOf(Item) = Type("Array") Then
			Dump(JSONWriter, Item)
		Else
			JSONWriter.WriteValue(Item);
		EndIf;
	EndDo;
	JSONWriter.WriteEndArray();
EndFunction // Dump()

AttachScript(".\src\Ripper\Ext\ObjectModule.bsl", "Ripper");

TextReader = New TextReader("C:\temp\RU\1Cv8_cf\root");
Source = TextReader.Read();

Ripper = New Ripper;
List = Ripper.Parse(Source);

JSONWriter = New JSONWriter;
JSONWriter.SetString(New JSONWriterSettings(, Chars.Tab));
Dump(JSONWriter, List);
Message(JSONWriter.Close());