
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
TextReader.Close();

Ripper = New Ripper;
Root = Ripper.Parse(Source);

TextReader = New TextReader("C:\temp\RU\1Cv8_cf\" + Root[1]);
Source = TextReader.Read();
TextReader.Close();

Conf = Ripper.Parse(Source);

JSONWriter = New JSONWriter;
JSONWriter.SetString(New JSONWriterSettings(, Chars.Tab));
Dump(JSONWriter, Conf);
Message(JSONWriter.Close());