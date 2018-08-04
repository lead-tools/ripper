
Var Ripper;

Function ReadFile(Path)
	TextReader = New TextReader(Path);
	Text = TextReader.Read();
	TextReader.Close();
	Return Text;
EndFunction // ReadFile()

Function VisitRoot(Path)
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
				Message(MetadataType);
				For k = 2 To MetadataCount + 1 Do
					Message(Chars.Tab + MetadataList[k]);
				EndDo;
			EndDo;
		EndIf;
	EndDo;
EndFunction // VisitRoot()

AttachScript(".\src\Ripper\Ext\ObjectModule.bsl", "Ripper");
Ripper = New Ripper;

VisitRoot("C:\temp\RU\1Cv8_cf\")