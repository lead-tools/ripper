
// MIT License

// Copyright (c) 2019 Tsukanov Alexander

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

Функция Разобрать(Исходник) Экспорт
	Возврат Parse(Исходник);
КонецФункции // Разобрать()

Function Parse(Src, Pos = 1) Export
	List = New Array;
	Pos = Pos + 1;
	Chr = Mid(Src, Pos, 1);
	If Chr = Chars.LF Then
		Pos = Pos + 1;
		Chr = Mid(Src, Pos, 1);
	EndIf;
	Beg = Pos;
	While Chr <> "" Do
		If Chr = "{" Then
			List.Add(Parse(Src, Pos));
			Pos = Pos + 1;
			Chr = Mid(Src, Pos, 1);
			If Chr = Chars.LF Then
				Pos = Pos + 1;
				Chr = Mid(Src, Pos, 1);
			EndIf;
			Beg = Pos;
		ElsIf Chr = "," Then
			If Beg < Pos Then
				List.Add(Mid(Src, Beg, Pos - Beg));
			EndIf;
			Pos = Pos + 1;
			Chr = Mid(Src, Pos, 1);
			If Chr = Chars.LF Then
				Pos = Pos + 1;
				Chr = Mid(Src, Pos, 1);
			EndIf;
			Beg = Pos;
		ElsIf Chr = "}" Then
			If Beg < Pos Then
				List.Add(Mid(Src, Beg, Pos - Beg));
			EndIf;
			Break;
		ElsIf Chr = """" Then
			While Chr = """" Do
				Pos = Pos + 1;
				While Mid(Src, Pos, 1) <> """" Do
					Pos = Pos + 1;
				EndDo;
				Pos = Pos + 1;
				Chr = Mid(Src, Pos, 1);
			EndDo;
		Else
			Pos = Pos + 1;
			Chr = Mid(Src, Pos, 1);
		EndIf;
	EndDo;
	Return List;
EndFunction // Parse()

Function ParseLimited(Src, Limit = 10, Pos = 1, Level = 0) Export
	List = New Array;
	Pos = Pos + 1;
	Chr = Mid(Src, Pos, 1);
	If Chr = Chars.LF Then
		Pos = Pos + 1;
		Chr = Mid(Src, Pos, 1);
	EndIf;
	Beg = Pos;
	While Chr <> "" Do
		If Chr = "{" Then
			If Level < Limit Then
				List.Add(ParseLimited(Src, Limit, Pos, Level + 1));
				Pos = Pos + 1;
				Chr = Mid(Src, Pos, 1);
				If Chr = Chars.LF Then
					Pos = Pos + 1;
					Chr = Mid(Src, Pos, 1);
				EndIf;
				Beg = Pos;
			Else
				Level = Level + 1;
				Pos = Pos + 1;
				Chr = Mid(Src, Pos, 1);
			EndIf;
		ElsIf Chr = "," Then
			If Level < Limit Then
				If Beg < Pos Then
					List.Add(Mid(Src, Beg, Pos - Beg));
				EndIf;
				Pos = Pos + 1;
				Chr = Mid(Src, Pos, 1);
				If Chr = Chars.LF Then
					Pos = Pos + 1;
					Chr = Mid(Src, Pos, 1);
				EndIf;
				Beg = Pos;
			Else
				Pos = Pos + 1;
				Chr = Mid(Src, Pos, 1);
			EndIf;
		ElsIf Chr = "}" Then
			Level = Level - 1;
			If Level < Limit Then
				If Beg < Pos Then
					List.Add(Mid(Src, Beg, Pos - Beg));
				EndIf;
				Break;
			Else
				Pos = Pos + 1;
				Chr = Mid(Src, Pos, 1);
			EndIf;
		ElsIf Chr = """" Then
			While Chr = """" Do
				Pos = Pos + 1;
				While Mid(Src, Pos, 1) <> """" Do
					Pos = Pos + 1;
				EndDo;
				Pos = Pos + 1;
				Chr = Mid(Src, Pos, 1);
			EndDo;
		Else
			Pos = Pos + 1;
			Chr = Mid(Src, Pos, 1);
		EndIf;
	EndDo;
	Return List;
EndFunction // ParseLimited()
