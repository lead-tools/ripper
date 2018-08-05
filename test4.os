
Var Ripper;

Function ReadFile(Path)
	TextReader = New TextReader(Path);
	Text = TextReader.Read();
	TextReader.Close();
	Return Text;
EndFunction // ReadFile()

Procedure WriteFile(Path, Text)
	Message(Path);
	TextWriter = New TextWriter(Path);
	TextWriter.Write(Text);
	TextWriter.Close();
EndProcedure // WriteFile()

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

Function VisitRoot(Path, ResultPath)
	Root = Ripper.Parse(ReadFile(Path + "root"));
	ConfID = Root[1];
	Conf = Ripper.Parse(ReadFile(Path + ConfID));
	ContainerCount = Number(Conf[2]);
	For i = 3 To ContainerCount + 2 Do
		Container = Conf[i];
		ContainerID = Container[0];
		MetadataClasses = Undefined;
		If ContainerID = "9cd510cd-abfc-11d4-9434-004095e12fc7" Then
			MetadataClasses = Container[1];
		ElsIf ContainerID = "9fcd25a0-4822-11d4-9414-008048da11f9" Then
			MetadataClasses = Container[1][1];
		ElsIf ContainerID = "e3687481-0a87-462c-a166-9f34594f9bba" Then
			MetadataClasses = Container[1];
		ElsIf ContainerID = "9de14907-ec23-4a07-96f0-85521cb6b53b" Then
			MetadataClasses = Container[1];
		ElsIf ContainerID = "51f2d5d8-ea4d-4064-8892-82951750031e" Then
			MetadataClasses = Container[1];
		ElsIf ContainerID = "e68182ea-4237-4383-967f-90c1e3370bc7" Then
			MetadataClasses = Container[1];
		EndIf;
		If MetadataClasses <> Undefined Then
			MetadataClassesCount = Number(MetadataClasses[2]);
			For j = 3 To MetadataClassesCount + 2 Do
				MetadataList = MetadataClasses[j];
				MetadataType = MetadataList[0];
				MetadataCount = Number(MetadataList[1]);
				If MetadataType = "061d872a-5787-460e-95ac-ed74ea3a3e84" Then // Document
					For k = 2 To MetadataCount + 1 Do
						DocumentID = MetadataList[k];
						Document = Ripper.ParseLimited(ReadFile(Path + DocumentID), 2);
						DocumentName = Ripper.Parse(Document[1][9][0], 0)[1][2];
						DocumentName = Mid(DocumentName, 2, StrLen(DocumentName) - 2);
						DirPath = StrTemplate("%1Documents\%2\", ResultPath, DocumentName);
						CreateDirectory(DirPath);
						Try
							Try
								WriteFile(
									DirPath + "ObjectModule.bsl",
									ReadFile(StrTemplate("%1%2.0\text", Path, DocumentID))
								);
							Except
								WriteFile(
									DirPath + "ObjectModule.bsl",
									ReadFile(StrTemplate("%1%2.0", Path, DocumentID))
								);
							EndTry;
							Try
								WriteFile(
									DirPath + "ManagerModule.bsl",
									ReadFile(StrTemplate("%1%2.2\text", Path, DocumentID))
								);
							Except
								WriteFile(
									DirPath + "ManagerModule.bsl",
									ReadFile(StrTemplate("%1%2.2", Path, DocumentID))
								);
							EndTry;
						Except
							Message(ErrorInfo());
						EndTry;
						// JSONWriter = New JSONWriter;
						// JSONWriter.SetString(New JSONWriterSettings(, Chars.Tab));
						// Dump(JSONWriter, Document);
						// Message(JSONWriter.Close());
						// Break;
					EndDo;
					Break;
				EndIf;
			EndDo;
		EndIf;
	EndDo;
EndFunction // VisitRoot()

AttachScript(".\src\Ripper\Ext\ObjectModule.bsl", "Ripper");
Ripper = New Ripper;

VisitRoot("C:\temp\RU\1Cv8_cf\", "C:\temp\RU\1Cv8_cf_result\")